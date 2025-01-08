// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {WhiteList} from "./whiteList.sol";
import {FarmerRegistration} from "./FarmerRegistration.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

contract MarketPlace is ERC1155, IERC1155Receiver {
    ///////////State Viriables/////////////
    uint256 livestockId = 1; // everything is over.....0 nothing 0 id means nada

    FarmerRegistration public farmer;
    WhiteList public whiteList;

    /////mapping/////////////
    //mapping(uint256 => Animal) public liveStock;

    //tokenId -> investorAddr -> Investor

    Animal[] public liveStock; /* */

    //////Event//////////////
    event AnimalRegistered(
        uint256 indexed id, address indexed famer, string animalName, uint256 totalAmountSharesMinted
    );
    event ListCreated(uint256 indexed id, address farmer, uint256 lockPeriod, WhiteListType whiteListType);
    event DeListed(uint256 indexed id, address farmer);
    event Invested(uint256 indexed _id, address investor, uint256 amount, uint256 profitPerDay);
    event TransferedOwnership(uint256 indexed _id, address indexed farmer, address newOwner, uint256 totalTokens);

    // bytes32 constant STRING_SIZE_SHOULD_BE = 32;
    struct Investor {
        uint256 totalShares;
        uint256 timeTracking;
        uint256 lockingPeriod;
        uint256 totalProfit; // ((profitPerDay * lockingPeriod) / totalAmountSharesMinted ) * totalShares;
        uint256 profitPerDay; // profitPerDay / totalAmountSharesMinted * totalShares;
        uint256 daysClaimed;
    }
    //available Days to Claim

    struct Animal {
        address farmer;
        string animalName;
        string breed;
        // price Per Share 4000, 1 at 3$;
        uint256 pricepershare; // 3$ for 1 share; totalSharesInUSDT= 3 * totalAmountSharesMinted;
        uint256 profitPerDay; // for 4000 mintedTokens, 12$;
        uint256 periodProfit;
        uint256 lockPeriod;
        uint256 totalAmountSharesMinted; /*TotalSharessharesAvaliable */
        uint256 avaliableShare; /*TotalSharessharesAvaliable - avaliableShare*/
        uint256 listingTime;
        State listingState;
        WhiteListType whiteListType;
    }

    enum State {
        SOLDOUT,
        IN_STOCK,
        /// during the delisting we check if the list is instck if yes, then yooou cannot delist.....
        UNLISTED
    }

    enum WhiteListType {
        PUBLIC,
        PRIVATE
    }

    ///////Modifier////////////

    modifier onlyLivestockOwner(uint256 _livestockId) {
        require(msg.sender == liveStock[_livestockId].farmer, "MARKETPLACE___NOT_OWNER_OF_ID");
        _;
    }

    modifier isverified() {
        require(farmer.isVerified(msg.sender), "WhiteListDeployer___Farmer_not_verified");
        _;
    }

    mapping(uint256 => mapping(address => Investor)) public investor;

    constructor(string memory URI, address _whiteListAddress, address _farmerRegistrationAddress) ERC1155(URI) {
        whiteList = WhiteList(_whiteListAddress);
        farmer = FarmerRegistration(_farmerRegistrationAddress);
    }

    /**
     * 1. tokenize the livestock
     *    2. shares
     *    3. metadatauri
     *    4.pricepershare
     *    5....when ever you want to register an animal you need to mint equivalent nft/whatever shares
     *    6. after done mint itll return an ID that will be special to that animal registration ...
     *    7. id shows ownership of the animal registered for the farmer
     */
    function registerAnimal(string memory _animalName, string memory _breed, uint256 _totalAmountSharesMinted)
        external
        isverified
        returns (uint256)
    {
        //check the animal name is an acceptable string formal...otherwise if the famer input somewird and not stringish there will be siisue
        // require(
        //bytes32(_animalName).length != 0 && bytes32(_animalName).length <= STRING_SIZE_SHOULD_BE * 3,
        // "MarketPlace__Invalid_naming"
        // ); //32 * 3 = 96
        uint256 _livestockId = livestockId;
        liveStock[_livestockId] = Animal({
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
        });
        livestockId++;
        _mint(msg.sender, _livestockId, _totalAmountSharesMinted, "");
        emit AnimalRegistered(_livestockId, msg.sender, _animalName, _totalAmountSharesMinted);
        return _livestockId;
    }

    //list the registred animal/livestock
    function createListing(
        uint256 _livestockId,
        uint256 _pricepershare,
        uint256 _profitPerDay,
        uint256 _lockPeriod,
        uint256 _periodProfit,
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

        setApprovalForAll(address(this), true);
        _safeTransferFrom(msg.sender, address(this), _livestockId, animal.totalAmountSharesMinted, "");
        emit ListCreated(_livestockId, msg.sender, _lockPeriod, _whiteListType);
    }

    //whenever a farmer delist there should be a fee .....investers get their money back...
    // edge cases
    //1. removes list but 1. this list has been spotted/purchased by investor?
    // my solution will be to
    // 1. check if listing is being invested--cureently
    //2. refund the investors
    //3. delisting fees
    //4. we delist
    function deList(uint256 _livestockId) external view onlyLivestockOwner(_livestockId) {
        Animal storage animal = liveStock[_livestockId];
        require(animal.listingState == State.IN_STOCK, "MarketPlace___Not_Listed");

        if (animal.avaliableShare < animal.totalAmountSharesMinted) {
            // refund the investor
        }
    }

    //  function refundInvestor(uint256 _livestockId) external {
    //    Investor memory _investor = investor[_livestockId][msg.sender];
    //    // require();
    //  }

    function getListings() external view returns (Animal[] memory) {
        return liveStock;
    }

    function getListingDetails(uint256 _livestockId) external view returns (Animal memory) {
        return liveStock[_livestockId];
    }

    //  function spotListing() external {}

    function calculateProfitPerDay(uint256 _livestockId, address investorAddress) internal view returns (uint256) {
        Animal memory animal = liveStock[_livestockId];
        Investor memory _investor = investor[_livestockId][investorAddress];
        uint256 profitPerDay = (animal.profitPerDay / animal.totalAmountSharesMinted) * _investor.totalShares;
        return profitPerDay;
    }

    function calculateTotalProfit(uint256 _livestockId, address investorAddress) internal view returns (uint256) {
        Animal memory animal = liveStock[_livestockId];
        Investor memory _investor = investor[_livestockId][investorAddress];
        uint256 profitPerDay = (animal.profitPerDay / animal.totalAmountSharesMinted) * _investor.totalShares;
        uint256 totalProfit = profitPerDay * _investor.lockingPeriod;
        return totalProfit;
    }

    //buying shares
    //payable funtion
    function invest(uint256 _livestockId, uint256 sharesToInvest) external payable {
        Animal memory animal = liveStock[_livestockId];

        require(animal.listingState == State.IN_STOCK, "MarketPlace__Not_IN_STOCK");

        if (animal.whiteListType == WhiteListType.PUBLIC) {
            //if public , check if this msg is in the public whitelist
            require(whiteList.isPublicWhiteList(msg.sender), "MarketPlace__Not_In_Public_Whitelist");
        } else if (animal.whiteListType == WhiteListType.PRIVATE) {
            require(whiteList.isPrivateWhiteList(msg.sender), "MarketPlace__Not_In_Private_Whitelist");
        }

        // checks if its in stock

        // check if theres enough to invest
        require(animal.avaliableShare >= sharesToInvest, "MarketPlace__Not_Enough_Shares_TO_Invest");
        //   uint256 totalPriceToInvest = sharesToInvest * animal.pricepershare;
        require(msg.value == animal.pricepershare * sharesToInvest, "MarketPlace__Not_Enough_funds");

        // remove the bough shares from the total
        Investor storage _investor = investor[_livestockId][msg.sender];

        liveStock[_livestockId].avaliableShare -= sharesToInvest;

        //add it to the investors thing
        _investor.totalShares += sharesToInvest;

        uint256 profitPerDay = (animal.profitPerDay / animal.totalAmountSharesMinted) * sharesToInvest;
        uint256 totalProfit = profitPerDay * animal.lockPeriod;

        _investor.profitPerDay = profitPerDay;
        _investor.lockingPeriod = block.timestamp + animal.lockPeriod;
        _investor.timeTracking = block.timestamp; //ly will come up with something better
        _investor.totalProfit = totalProfit;

        // transfer fund
        _safeTransferFrom(address(this), msg.sender, _livestockId, sharesToInvest, "");

        (bool success,) = animal.farmer.call{value: msg.value}("");
        require(success, "MARKETPlACE___TRansaction failed");

        //emit Invested
        emit Invested(_livestockId, msg.sender, sharesToInvest, profitPerDay);

        //calculate totalProfit
        //totalProfit = lockPeriod * pricePerDay;
        //profitPerDay = profitPerDay / totalShareMinted * (totalSharesOfInvestor)
        //ly: profitPerDay = totalProfit / lockPeriod;

        //e.g lockPeriod = 30 days TotalProfit: 373 totalShareMinted: 4000 totalShareofInvestor: 200
        // profitPerday = 373 / 30 = 12.433 / totalShareMinted * totalSharesOfInvestor
        // profitPerday = (12.433 / 4000) * 200 = 0.62165;
        // investor[_livestockId][msg.sender].totalProfit =
    }

    //buys the whole listing

    // after purchaisng you can transfer ownership ? right

    function transferListOwnerShip(uint256 _livestockId, address newOwner) external onlyLivestockOwner(_livestockId) {
        Animal memory animal = liveStock[_livestockId];
        require(newOwner != address(0), "Marketplace__Invalid_Address");
        require(animal.listingState == State.IN_STOCK, "MarketPlace__Not_IN_STOCK");
        require(animal.avaliableShare == animal.totalAmountSharesMinted, "Markeplace__Not_Total_Shares_Minted");
        liveStock[_livestockId].farmer = newOwner;
        _safeTransferFrom(msg.sender, newOwner, _livestockId, animal.totalAmountSharesMinted, "");
        emit TransferedOwnership(_livestockId, animal.farmer, newOwner, animal.totalAmountSharesMinted);
    }

    //claims what you have so far
    function claim(uint256 _livestockId) external {
        Investor storage _investor = investor[_livestockId][msg.sender];
        uint256 daysPassed = (_investor.timeTracking - block.timestamp) / 24 * 60 * 60; // convert to days
        uint256 availableClaimableDays = daysPassed - _investor.daysClaimed;
        uint256 profitToClaim = availableClaimableDays * _investor.profitPerDay;
        _investor.daysClaimed += availableClaimableDays;

        //transfer profitToClaim to investor;
    }

    function withdrawClaim(uint256 _livestockId, address _investorAddress) external {}

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
