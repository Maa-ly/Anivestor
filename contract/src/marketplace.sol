// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {IWhiteList} from "./interfaces/IWhitelist.sol";
import {IFarmerRegistration} from "./interfaces/IFarmerRegistration.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

/**
 * @author Lydia GYamfi Ahenkorah && Kaleel
 * @notice This is the marketplace contract, where verified farmers can register
 *   livestock/animal and create a listing for the livestockId
 * @notice investors can buy shares from the list
 * @notice investors can get a refund
 * @notice farmer borrowing money from the contract, this money is then used for
 *  a specified listing to pay priceperday of invested shares
 * @notice uses usdc(listing info and pricing) and weth(collateral is deposited)
 */
contract MarketPlace is ERC1155, IERC1155Receiver {
    CollateralStruct[] public collateral;
    Animal[] public liveStock;

    uint256 livestockId; // everything is over.....0 nothing 0 id means nada
    IERC20 public usdtToken; // base Token for transacting on our platform - usdc
    address public usdtTokenAddress; // USDT token address

    uint256 public collateralIndex = 1;

    IFarmerRegistration public farmer;
    IWhiteList public whiteList;

    ////////////////////////////////////////////////////////
    /////////// Enums /////////////////////////////////////
    //////////////////////////////////////////////////////
    /**
     * @notice the state of the listing
     * @SOLDOUT : listing is out of stock
     * IN-STOCK : IN the market and avaliable
     * UNLISTED : Removed form the listing
     */
    enum State {
        SOLDOUT,
        IN_STOCK,
        /// during the delisting we check if the list is instck if yes, then yooou cannot delist.....
        UNLISTED
    }

    /**
     * Type of whitelist
     * PUBLIC : anyone can join
     * PRIvATE : only verified farmer can add investor
     */
    enum WhiteListType {
        PUBLIC,
        PRIVATE
    }

    //////////////////////////////////////////////////////////
    /////mapping///////////////////////////////////////////////
    ///////////////////////////////////////////////////////////
    //mapping(uint256 => Animal) public liveStock;
    mapping(uint256 => mapping(address => Investor)) public investor;

    mapping(address => uint256) public balances;
    // uint256 is livestockId
    mapping(uint256 => LivestockBorrow) public livestockBorrowed;
    mapping(uint256 => mapping(address => uint256)) public refunds; // Track refunds for investors
    mapping(uint256 => uint256) public livestockFunding;

    mapping(uint256 => uint256) public livestockFunds;
    ////////////////////////////////////////////////////////
    /////////// structs /////////////////////////////////////
    //////////////////////////////////////////////////////

    struct LivestockBorrow {
        uint256 livestockId;
        uint256 amountBorrowed;
        bool paid;
    }

    struct CollateralStruct {
        address farmer;
        uint256 lockPeriod;
        bool isLocked;
        uint256 valueOfCollateral;
        uint256 borrowed;
    }

    struct Investor {
        uint256 totalShares;
        uint256 timeTracking;
        uint256 lockingPeriod;
        uint256 totalProfit;
        uint256 profitPerDay;
        uint256 daysClaimed;
    }

    struct Animal {
        address farmer;
        string animalName;
        string breed;
        uint256 pricepershare; // 3$ for 1 share; totalSharesInUSDT= 3 * totalAmountSharesMinted;
        uint256 profitPerDay; // for 4000 mintedTokens, 12$;
        uint256 periodProfit; // lockPeriod * profitPerDay
        uint256 lockPeriod;
        uint256 totalAmountSharesMinted; /*TotalSharessharesAvaliable */
        uint256 avaliableShare; /*TotalSharessharesAvaliable - avaliableShare*/
        uint256 listingTime;
        State listingState;
        WhiteListType whiteListType;
    }

    //////Event//////////////
    event AnimalRegistered(
        uint256 indexed id, address indexed famer, string animalName, uint256 totalAmountSharesMinted
    );
    event Refunded(uint256 livestockId, address indexed investor, uint256 amount);
    event ListCreated(uint256 indexed id, address farmer, uint256 lockPeriod, WhiteListType whiteListType);
    event Invested(uint256 indexed _id, address investor, uint256 amount, uint256 profitPerDay);
    event TransferedOwnership(uint256 indexed _id, address indexed farmer, address newOwner, uint256 totalTokens);
    event DeListed(uint256 livestockId, address indexed owner);
    event Claim(address indexed investor, uint256 Id, uint256 amount);

    ///////Modifier////////////

    modifier onlyLivestockOwner(uint256 _livestockId) {
        require(msg.sender == liveStock[_livestockId].farmer, "MARKETPLACE___NOT_OWNER_OF_ID");
        _;
    }

    modifier isverified() {
        require(farmer.isVerified(msg.sender), "WhiteListDeployer___Farmer_not_verified");
        _;
    }

    constructor(
        string memory URI,
        address _whiteListAddress,
        address _farmerRegistrationAddress,
        address _usdtTokenAddress
    ) ERC1155(URI) {
        whiteList = IWhiteList(_whiteListAddress);
        farmer = IFarmerRegistration(_farmerRegistrationAddress);
        usdtToken = IERC20(_usdtTokenAddress);
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////  external farmer functions   ///////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////////////////////////////////

    function registerAnimal(string memory _animalName, string memory _breed, uint256 _totalAmountSharesMinted)
        external
        isverified
        returns (uint256)
    {
        uint256 _livestockId = livestockId;
        liveStock.push(
            Animal({
                farmer: msg.sender,
                animalName: _animalName,
                breed: _breed,
                pricepershare: 0,
                profitPerDay: 0,
                periodProfit: 0,
                lockPeriod: 0,
                totalAmountSharesMinted: _totalAmountSharesMinted, /*TotalSharessharesAvaliable */
                avaliableShare: _totalAmountSharesMinted, /*TotalSharessharesAvaliable - avaliableShare*/
                listingTime: 0,
                listingState: State.UNLISTED,
                whiteListType: WhiteListType.PUBLIC
            })
        );
        livestockId++;
        _mint(msg.sender, _livestockId, _totalAmountSharesMinted, "");
        emit AnimalRegistered(_livestockId, msg.sender, _animalName, _totalAmountSharesMinted);
        return _livestockId;
    }

    function createListing(
        uint256 _livestockId,
        uint256 _pricepershare,
        uint256 _profitPerDay,
        uint256 _lockPeriod,
        uint256 _periodProfit, // the entire lock period/duration
        WhiteListType _whiteListType
    ) external isverified onlyLivestockOwner(_livestockId) {
        Animal storage animal = liveStock[_livestockId];
        // farmer hanst already listed that id
        require(animal.listingState == State.UNLISTED, "MARKETPLACE__ID_ALREADy_LISTED");
        require(_pricepershare > 0, "MARKETPLACE__Price_Must_Be_GREATER_THAN_ZERO");
        require(_profitPerDay > 0, "MARKETPLACE__Profit_Must_Be_GREATER_THAN_ZERO");
        require(_lockPeriod > 1 days, "MARKETPLACE__INVALID_LOCKPERIOD");

        liveStock[_livestockId] = Animal({
            farmer: animal.farmer,
            animalName: animal.animalName,
            breed: animal.breed,
            pricepershare: _pricepershare,
            profitPerDay: _profitPerDay,
            periodProfit: _periodProfit,
            lockPeriod: _lockPeriod,
            totalAmountSharesMinted: animal.totalAmountSharesMinted, /*TotalSharessharesAvaliable */
            avaliableShare: animal.avaliableShare, /*TotalSharessharesAvaliable - avaliableShare*/
            listingTime: block.timestamp,
            listingState: State.IN_STOCK,
            whiteListType: _whiteListType
        });
        whiteList.createPublicWhitelist(_livestockId, msg.sender);
        whiteList.createPrivateWhitelist(_livestockId, msg.sender);

        //   setApprovalForAll(address(this), true);
        //   _safeTransferFrom(msg.sender, address(this), _livestockId, animal.totalAmountSharesMinted, "");
        emit ListCreated(_livestockId, msg.sender, _lockPeriod, _whiteListType);
    }

    function invest(uint256 _livestockId, uint256 sharesToInvest) external {
        Animal memory animal = liveStock[_livestockId];

        require(animal.listingState == State.IN_STOCK, "MarketPlace__Not_IN_STOCK");

        if (animal.whiteListType == WhiteListType.PUBLIC) {
            require(whiteList.isPublicWhiteList(_livestockId, msg.sender), "MarketPlace__Not_In_Public_Whitelist");
        } else if (animal.whiteListType == WhiteListType.PRIVATE) {
            require(whiteList.isPrivateWhiteList(_livestockId, msg.sender), "MarketPlace__Not_In_Private_Whitelist");
        }
        require(animal.avaliableShare >= sharesToInvest, "MarketPlace__Not_Enough_Shares_TO_Invest");
        uint256 totalPriceToInvest = sharesToInvest * animal.pricepershare;

        Investor storage _investor = investor[_livestockId][msg.sender];

        liveStock[_livestockId].avaliableShare -= sharesToInvest;

        _investor.totalShares += sharesToInvest;

        uint256 profitPerDay = (animal.profitPerDay / animal.totalAmountSharesMinted) * sharesToInvest;

        _investor.profitPerDay = profitPerDay;
        _investor.lockingPeriod = block.timestamp + animal.lockPeriod;
        _investor.timeTracking = block.timestamp; //ly will come up with something better
        _investor.totalProfit = profitPerDay * animal.lockPeriod;
        //   usdtToken.Approval(msg.sender, address(this), totalPriceToInvest);
        require(
            usdtToken.allowance(msg.sender, address(this)) >= totalPriceToInvest, "MarketPlace__Allowance_Insufficient"
        );
        bool success = usdtToken.transferFrom(msg.sender, address(this), totalPriceToInvest);
        require(success, "MarketPlace__USDC_Transfer_Failed");
        _safeTransferFrom(address(this), msg.sender, _livestockId, sharesToInvest, "");
        emit Invested(_livestockId, msg.sender, sharesToInvest, profitPerDay);
    }

    function transferListOwnerShip(uint256 _livestockId, address newOwner) external onlyLivestockOwner(_livestockId) {
        Animal memory animal = liveStock[_livestockId];
        require(newOwner != address(0), "Marketplace__Invalid_Address");
        require(animal.listingState == State.IN_STOCK, "MarketPlace__Not_IN_STOCK");
        require(animal.avaliableShare == animal.totalAmountSharesMinted, "Markeplace__Not_Total_Shares_Minted");
        liveStock[_livestockId].farmer = newOwner;
        _safeTransferFrom(msg.sender, newOwner, _livestockId, animal.totalAmountSharesMinted, "");
        emit TransferedOwnership(_livestockId, animal.farmer, newOwner, animal.totalAmountSharesMinted);
    }

    function claim(uint256 _livestockId) external {
        Investor storage _investor = investor[_livestockId][msg.sender];
        uint256 daysPassed = (_investor.timeTracking - block.timestamp) / 24 * 60 * 60; // convert to days
        uint256 availableClaimableDays = daysPassed - _investor.daysClaimed;
        uint256 profitToClaim = availableClaimableDays * _investor.profitPerDay;

        _investor.daysClaimed += availableClaimableDays;
        usdtToken.transferFrom(address(this), msg.sender, profitToClaim);
        emit Claim(msg.sender, _livestockId, profitToClaim);
    }

    function getListings() external view returns (Animal[] memory) {
        return liveStock;
    }

    function getListingDetails(uint256 _livestockId) external view returns (Animal memory) {
        return liveStock[_livestockId];
    }

    function onERC1155Received(address operator, address from, uint256 id, uint256 value, bytes calldata data)
        external
        override
        returns (bytes4)
    {}

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external override returns (bytes4) {}
}
