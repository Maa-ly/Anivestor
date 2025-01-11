// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {IChainlinkAggregator} from "../src/lib/IChainlinkAggregator.sol";
import {OracleLib} from "../src/lib/oracleLib.sol";
import "../src/lib/oracleLib.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IFarmerRegistration} from "./interfaces/IFarmerRegistration.sol";
import {IWhiteList} from "./interfaces/IWhitelist.sol";
import {IMarketPlace} from "./interfaces/IMarketplace.sol";

contract Borrow {

    IChainlinkAggregator internal s_wbtcUsdAggregator; // wbtc

    uint256 public constant USDT_DECIMAL = 1e6;
    uint256 public constant WETH_DECIMAL = 1e18;
    uint256 public constant WBTC_DECIMAL = 1e8;

    CollateralStruct[] public collateral;
    IMarketPlace.Animal[] public liveStock; /* */
    IMarketPlace public marketplace;

    IERC20 public collateralToken; //collateral weth / wbtc
    IERC20 public usdtToken; // base Token for transacting on our platform - usdc
    address public usdtTokenAddress; // USDT token address
    address public wethTokenAddress;
    address public wbtcTokenAddress;

    mapping(address => uint256) public balances;
    // uint256 is livestockId
    mapping(uint256 => LivestockBorrow) public livestockBorrowed;
    mapping(uint256 => mapping(address => uint256)) public refunds; // Track refunds for investors
    mapping(uint256 => uint256) public livestockFunding;

    mapping(uint256 => uint256) public livestockFunds;

    uint256 public collateralIndex = 1;

    IFarmerRegistration public farmer;
    IWhiteList public whiteList;

    struct CollateralStruct {
        // uint256 amount; //
        address farmer;
        uint256 lockPeriod;
        bool isLocked;
        uint256 valueOfCollateral;
        uint256 borrowed;
    }

    struct LivestockBorrow {
        uint256 livestockId;
        uint256 amountBorrowed;
        bool paid;
    }

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

    constructor(
        address _whiteListAddress,
        address _farmerRegistrationAddress,
        address _tokenAddress,
        address wbtc,
        address wbtcUsdAggregatorAddress
    ) {
        whiteList = IWhiteList(_whiteListAddress);
        farmer = IFarmerRegistration(_farmerRegistrationAddress);
        usdtToken = IERC20(_tokenAddress);
        collateralToken = IERC20(wbtc);

      //   s_usdtUsdAggregator = IChainlinkAggregator(usdtUsdAggregatorAddress);
      //   s_wethEthUsdAggregator = IChainlinkAggregator(wethEthUsdAggregatorAddress);
        s_wbtcUsdAggregator = IChainlinkAggregator(wbtcUsdAggregatorAddress);
    }

    modifier onlyLivestockOwner(uint256 _livestockId) {
        require(msg.sender == liveStock[_livestockId].farmer, "MARKETPLACE___NOT_OWNER_OF_ID");
        _;
    }

    modifier isverified() {
        require(farmer.isVerified(msg.sender), "WhiteListDeployer___Farmer_not_verified");
        _;
    }

    event Refunded(uint256 livestockId, address indexed investor, uint256 amount);
    event Withdrawn(uint256 indexed livestockId, address indexed owner, uint256 amount);

    event LoanRepaid(uint256 indexed _collateralIndex, uint256 indexed _livestockId, uint256 _amount);
    event ReleaseCollateal(uint256 _collateralIndex, address farmer, uint256 valueOfCollateral);
    event FundedProtocol(address indexed funder, uint256 amount);
    event DepositedCollateral(address indexed farmer, uint256 amount, uint256 id);
    event AmountBorrowed(address indexed farmer, uint256 amount);

    function depositCollateral(uint256 amount) external isverified returns (uint256) {
        uint256 _collateralIndex = collateralIndex;
        require(amount > 0, "COLLATERAL__Amount_Must_Greater_Than_Zero");

        uint256 wbtcPriceInUsd = getwbtcPriceInUsd(); // Fetch the price of wBTC in USD
        uint256 collateralValueInUsd = (amount * wbtcPriceInUsd) / WBTC_DECIMAL;

        //   if (collateralTokenAddress == address(wbtcTokenAddress)) {
        //       uint256 wbtcPriceInUsd = getwbtcPriceInUsd(); // Fetch the price of wBTC in USD
        //       collateralValueInUsd = (amount * wbtcPriceInUsd) / WBTC_DECIMAL; // Adjust for price decimals
        //   } else if (collateralTokenAddress == address(wethTokenAddress)) {
        //       uint256 wethPriceInUsd = getwethPriceInUsd(); // Fetch the price of wETH in USD
        //       collateralValueInUsd = (amount * wethPriceInUsd) / WETH_DECIMAL; // Adjust for price decimals
        //   } else {
        //       revert("Invalid collateral token");
        //   }

        //   collateralValueInUsd = amount; // calculate the value of collateral -LTV
        collateral[_collateralIndex] = CollateralStruct({
            farmer: msg.sender,
            lockPeriod: block.timestamp,
            isLocked: false,
            valueOfCollateral: collateralValueInUsd,
            borrowed: 0
        });
        collateralIndex++;
        collateralToken.transferFrom(msg.sender, address(this), amount);

        emit DepositedCollateral(msg.sender, collateralValueInUsd, _collateralIndex);
        return _collateralIndex;
    }

    /**
     * @notice borrow amount is allocated to the famer addresss , after you deposit you get id......
     */
    function borrow( /*uint256 _livestockId,*/ uint256 _collateralIndex, uint256 borrowAmount) external {
        CollateralStruct memory collateralInformation = collateral[_collateralIndex];

        require(collateralInformation.farmer == msg.sender, "COLLATERAL__Not_The_Owner_Of_Collateral");

        require(!collateralInformation.isLocked, "COLLATERAL__Collateral_Already_Locked");

        uint256 availableAmountToBorrow = collateralInformation.valueOfCollateral - collateralInformation.borrowed;
        require(borrowAmount > 0, "COLLATERAL__BorrowAmount_Must_Be_Greater_Than_Zero");
        require(borrowAmount <= availableAmountToBorrow, "COLLATERAL__BorrowAmount_Exceeds_Avaliablle_Amount_Allowed");

        collateralInformation.borrowed += borrowAmount;
        collateralInformation.isLocked = true;
        balances[msg.sender] += borrowAmount;
        emit AmountBorrowed(msg.sender, borrowAmount);
    }

    //use funds for listing

    function allocateFundsToListing(uint256 _livestockId, uint256 _collateralIndex /*uint256 _amount*/ )
        external
        onlyLivestockOwner(_livestockId)
    {
        require(livestockFunding[_livestockId] == 0, "COLLATERAL__MUST_BE_ZERO");
        //   Animal storage animal = liveStock[_livestockId];
        IMarketPlace.Animal memory animal = marketplace.getListingDetails(_livestockId);
        CollateralStruct memory _collateral = collateral[_collateralIndex];
        require(animal.listingState == IMarketPlace.State.IN_STOCK, "MARKETPLACE__List_Not_In_Stock");
        require(_collateral.farmer == msg.sender, "COLLATERAL__OWNER_MUST_BE_SENDER");

        require(balances[msg.sender] >= animal.periodProfit, "COLLATERAL__NOT_ENOUGH_FUNDS");

        livestockBorrowed[_livestockId] =
            LivestockBorrow({livestockId: _livestockId, amountBorrowed: animal.periodProfit, paid: false});
        livestockFunding[_livestockId] += animal.periodProfit;
        balances[msg.sender] -= animal.periodProfit;
    }

    function releaseCollateral(uint256 _collateralIndex) external {
        CollateralStruct memory collateralInfo = collateral[_collateralIndex];
        require(collateralInfo.farmer == msg.sender, "COLLATERAL__NOT_OWNER");
        require(collateralInfo.isLocked || collateralInfo.borrowed == 0, "COLLATERAL__Cannot_Release");
        collateral[_collateralIndex] =
            CollateralStruct({farmer: address(0), lockPeriod: 0, isLocked: false, valueOfCollateral: 0, borrowed: 0});
        delete collateral[_collateralIndex];
        collateralToken.transferFrom(address(this), msg.sender, collateralInfo.valueOfCollateral);

        emit ReleaseCollateal(_collateralIndex, msg.sender, collateralInfo.valueOfCollateral);
    }

    function repayLoan(uint256 _collateralIndex, uint256 _livestockId, uint256 _amount) external {
        CollateralStruct storage collateralInfo = collateral[_collateralIndex];
        require(collateralInfo.farmer == msg.sender, "COLLATERAL__Not_The_Owner");


        require(collateralInfo.borrowed > 0 && _amount <= collateralInfo.borrowed, "COLLATERAL__AMOUNT_NOT_IN_RANGE");
        uint256 livestockAmountBorrowed = livestockBorrowed[_livestockId].amountBorrowed;
        if (_amount < livestockAmountBorrowed) {
            livestockBorrowed[_livestockId].amountBorrowed -= _amount;
        } else if (_amount == livestockAmountBorrowed) {
            livestockBorrowed[_livestockId].amountBorrowed -= _amount;
            livestockBorrowed[_livestockId].paid = true;
        }
        usdtToken.transferFrom(msg.sender, address(this), _amount);
        collateralInfo.borrowed += _amount;
        emit LoanRepaid(_collateralIndex, _livestockId, _amount);
    }

    function withdrawListingFunds(uint256 _livestockId) external onlyLivestockOwner(_livestockId) {
        //   Animal storage animal = liveStock[_livestockId];
        IMarketPlace.Animal memory animal = marketplace.getListingDetails(_livestockId);

        require(animal.listingState == IMarketPlace.State.IN_STOCK, "MarketPlace___Not_Listed");
        uint256 availableFunds = livestockFunds[_livestockId];
        require(availableFunds > 0, "MarketPlace___No_Funds_Available");

        uint256 totalRefunds = 0;
        for (address investorAddr = address(0); investorAddr != address(0); investorAddr) {
            uint256 refundAmount = refunds[_livestockId][investorAddr];
            totalRefunds += refundAmount;
        }

        uint256 withdrawableAmount = availableFunds - totalRefunds;

        require(address(this).balance >= withdrawableAmount, "MarketPlace___Insufficient_Funds");
        livestockFunds[_livestockId] = 0;

        bool success = usdtToken.transferFrom(address(this), msg.sender, withdrawableAmount);
        require(success, "MarketPlace__USDC_Transfer_Failed");
        emit Withdrawn(_livestockId, msg.sender, withdrawableAmount);
    }

    function fundProtocol(uint256 _amount) external {
        require(_amount > 0, "MARKETPLACE__AMOUNT_TOO_SMALL");
        //   collateralToken.transferFrom(msg.sender, address(this), _amountInUsd);
        usdtToken.transferFrom(msg.sender, address(this), _amount);
    }

    function getFarmerBorrowedAmount(uint256 _collateralIndex) external view returns (uint256) {
        CollateralStruct memory _collateral = collateral[_collateralIndex];
        return _collateral.borrowed;
    }

    function getFarmerAvailableCredit(uint256 _collateralIndex) external view returns (uint256) {
        CollateralStruct memory _collateral = collateral[_collateralIndex];
        return _collateral.valueOfCollateral - _collateral.borrowed;
    }

    function getwbtcPriceInUsd() public view returns (uint256) {
        (, int256 price,,,) = s_wbtcUsdAggregator.latestRoundData();
        return uint256(price);
    }
}
