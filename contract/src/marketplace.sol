// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {WhiteList} from "./whiteList.sol";
import {FarmerRegistration} from "./FarmerRegistration.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import{OracleLib} from "../src/lib/oracleLib.sol";
import "../src/lib/oracleLib.sol";


/** @author Lydia GYamfi Ahenkorah && Kaleel
 * @notice This is the marketplace contract, where verified farmers can register
  livestock/animal and create a listing for the livestockId
 *@notice investors can buy shares from the list
 *@notice investors can get a refund
 *@notice farmer borrowing money from the contract, this money is then used for 
 a specified listing to pay priceperday of invested shares
 *@notice uses usdc(listing info and pricing) and weth(collateral is deposited)
 */
contract MarketPlace is ERC1155, IERC1155Receiver {
    

    
   using OracleLib for AggregatorV3Interface;

    AggregatorV3Interface internal s_usdtUsdAggregator; // usdc
   AggregatorV3Interface internal s_wethEthUsdAggregator; // wthEthereum
    AggregatorV3Interface internal s_wbtcUsdAggregator; // wbtc

     //////////////////////////////////////////////////////////////
    ///////////State Viriables/////////////////////////////////////
    //////////////////////////////////////////////////////////////
    uint256 public constant USDT_DECIMAL = 1e6;
    uint256 public constant WETH_DECIMAL = 1e18;
    uint256 public constant WBTC_DECIMAL = 1e8;

    CollateralStruct[] public collateral;
    Animal[] public liveStock; /* */
    
    uint256 livestockId = 1; // everything is over.....0 nothing 0 id means nada
    IERC20 public collateralToken; //collateral weth / wbtc
    IERC20 public usdtToken; // base Token for transacting on our platform - usdc
    address public usdtTokenAddress; // USDT token address
    address public wethTokenAddress;
    address public wbtcTokenAddress;

    uint256 public collateralIndex = 1;

    FarmerRegistration public farmer;
    WhiteList public whiteList;


    ////////////////////////////////////////////////////////
    /////////// Enums /////////////////////////////////////
    //////////////////////////////////////////////////////
/**@notice the state of the listing
 *@SOLDOUT : listing is out of stock
 *IN-STOCK : IN the market and avaliable
 *UNLISTED : Removed form the listing
 */
    enum State {
        SOLDOUT,
        IN_STOCK,
        /// during the delisting we check if the list is instck if yes, then yooou cannot delist.....
        UNLISTED
    }

    /** Type of whitelist 
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


    //tokenId -> investorAddr -> Investor
 
    // mapping(uint256 => uint256)public  livestockidToBorrowAmount;
    //mapping(address => CollateralStruct) public collateral;


     ////////////////////////////////////////////////////////
    /////////// structs /////////////////////////////////////
    //////////////////////////////////////////////////////


    struct LivestockBorrow {
        uint256 livestockId;
        uint256 amountBorrowed;
        bool paid;
    }

    struct CollateralStruct {
        // uint256 amount; //
        address farmer;
        uint256 lockPeriod;
        bool isLocked;
        uint256 valueOfCollateral;
        uint256 borrowed;
    }
    // uint256 amountLeftToBorrow;
    //uint256 livestockId;
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
    event DepositedCollateral(address indexed farmer, uint256 amount, uint256 id);
    event AmountBorrowed(address indexed farmer, uint256 amount);
    event ListCreated(uint256 indexed id, address farmer, uint256 lockPeriod, WhiteListType whiteListType);
    event Invested(uint256 indexed _id, address investor, uint256 amount, uint256 profitPerDay);
    event TransferedOwnership(uint256 indexed _id, address indexed farmer, address newOwner, uint256 totalTokens);
    event DeListed(uint256 livestockId, address indexed owner);
    event Refunded(uint256 livestockId, address indexed investor, uint256 amount);
    event Withdrawn(uint256 indexed livestockId, address indexed owner, uint256 amount);
    event LoanRepaid(uint256 indexed _collateralIndex, uint256 indexed _livestockId, uint256 _amount);
    event ReleaseCollateal(uint256 _collateralIndex, address farmer, uint256 valueOfCollateral);
    event Claim(address indexed investor, uint256 Id, uint256 amount);
    event FundedProtocol(address indexed funder, uint256 amount);


    // bytes32 constant STRING_SIZE_SHOULD_BE = 32;
   
 
    ///////Modifier////////////

    modifier onlyLivestockOwner(uint256 _livestockId) {
        require(msg.sender == liveStock[_livestockId].farmer, "MARKETPLACE___NOT_OWNER_OF_ID");
        _;
    }

    modifier isverified() {
        require(farmer.isVerified(msg.sender), "WhiteListDeployer___Farmer_not_verified");
        _;
    }



    constructor(string memory URI, address _whiteListAddress, address _farmerRegistrationAddress, address _tokenAddress, address wbtc, address usdtUsdAggregatorAddress, address wethEthUsdAggregatorAddress, address wbtcUsdAggregatorAddress)
        ERC1155(URI)
    {
        whiteList = WhiteList(_whiteListAddress);
        farmer = FarmerRegistration(_farmerRegistrationAddress);
        usdtToken =IERC20(_tokenAddress);
        collateralToken = IERC20(wbtc);
                       
    

        s_usdtUsdAggregator = AggregatorV3Interface(usdtUsdAggregatorAddress);
       s_wethEthUsdAggregator = AggregatorV3Interface(wethEthUsdAggregatorAddress);
        s_wbtcUsdAggregator =  AggregatorV3Interface(wbtcUsdAggregatorAddress);
    }



  
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
   //////  external farmer functions   ///////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////

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
    //@audit work on this -- logic 
 
    function deList(uint256 _livestockId) external onlyLivestockOwner(_livestockId) {
        Animal storage animal = liveStock[_livestockId];
        require(animal.listingState == State.IN_STOCK, "MarketPlace___Not_Listed");

        // If there are any shares sold, refund the investors
        if (animal.avaliableShare < animal.totalAmountSharesMinted) {
            uint256 soldShares = animal.totalAmountSharesMinted - animal.avaliableShare;
            uint256 refundPerShare = animal.pricepershare * soldShares;

            // Iterate through the investors to calculate their refunds
            for (address investorAddr = address(0); investorAddr != address(0); investorAddr) {
                if (investor[_livestockId][investorAddr].totalShares > 0) {
                    uint256 sharesOwned = investor[_livestockId][investorAddr].totalShares;
                    uint256 refundAmount = (sharesOwned * refundPerShare);

                    refunds[_livestockId][investorAddr] = refundAmount;
                }
            }
        }

        // Mark as unlisted
        liveStock[_livestockId].listingState = State.UNLISTED;

        emit DeListed(_livestockId, msg.sender);
    }

    /**@notice 
     */
    // Investor claim refund function (Pull method)
    function Refund(uint256 _livestockId) external {
        uint256 refundAmount = refunds[_livestockId][msg.sender];
        uint256 priceinUSD = getusdtPriceInUsd();
        uint256 refundAmountInUsd = (refundAmount * priceinUSD ) / USDT_DECIMAL;
        require(refundAmountInUsd > 0, "MarketPlace___No_Refund_Available");

        // Reset the refund to prevent re-claims
        refunds[_livestockId][msg.sender] = 0;

        // Transfer the refund to the investor
        bool success = usdtToken.transferFrom(address(this), msg.sender, refundAmountInUsd);
        require(success, "MarketPlace___Refund_Transfer_Failed");

        emit Refunded(_livestockId, msg.sender, refundAmountInUsd);
    }

    
    //  function spotListing() external {}
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
   //////  internal functions            ///////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////

    function calculateProfitPerDay(uint256 _livestockId, uint256 sharesOwned) internal view returns (uint256) {
        Animal memory animal = liveStock[_livestockId];
        Investor memory _investor = investor[_livestockId][msg.sender];
        sharesOwned = _investor.totalShares;
        uint256 profitPerDay = (animal.profitPerDay / animal.totalAmountSharesMinted) * sharesOwned;

        return profitPerDay;
    }

    function calculateTotalProfit(uint256 _livestockId) internal view returns (uint256) {
        Animal memory animal = liveStock[_livestockId];
        Investor memory _investor = investor[_livestockId][msg.sender];
        
        uint256 profitPerDay = (animal.profitPerDay / animal.totalAmountSharesMinted) * _investor.totalShares;
       uint256  duration = _investor.lockingPeriod;
        uint256 totalProfit = profitPerDay * duration;
       
        return totalProfit ;
    }


    ////////////////////////////////////////////////////////////////////////////////////////////////////////
   //////  exteranl investor functions            ///////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
    //buying shares
    //payable funtion
    function invest(uint256 _livestockId, uint256 sharesToInvest, address tokenAddress ) external payable {
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
         //  uint256 totalPriceToInvest = sharesToInvest * animal.pricepershare;
         //  totalPriceToInvest = totalPriceToInvest * getUsdcPriceInUsd;
         uint256 totalPriceToInvest = sharesToInvest * animal.pricepershare;

       uint256 _amountInUsd;


       if (tokenAddress == address(wbtcTokenAddress)) {
        uint256 wbtcPriceInUsd = getwbtcPriceInUsd(); 
        _amountInUsd = (totalPriceToInvest * wbtcPriceInUsd) / WBTC_DECIMAL;  
    } else if (tokenAddress == address(wethTokenAddress)) {
        uint256 wethPriceInUsd = getwethPriceInUsd();
        _amountInUsd = (totalPriceToInvest * wethPriceInUsd) / WETH_DECIMAL; 
    } else if (tokenAddress == address(usdtTokenAddress)){
        uint256 usdtPriceInUsd = getusdtPriceInUsd();
        _amountInUsd =(totalPriceToInvest * usdtPriceInUsd ) / USDT_DECIMAL;
    }
    require(msg.value == _amountInUsd, "MarketPlace__Not_Enough_funds");
        // remove the bough shares from the total
        Investor storage _investor = investor[_livestockId][msg.sender];

        liveStock[_livestockId].avaliableShare -= sharesToInvest;

        //add it to the investors thing
        _investor.totalShares += sharesToInvest;

        uint256 profitPerDay = (animal.profitPerDay / animal.totalAmountSharesMinted) * sharesToInvest;

        
        _investor.profitPerDay = profitPerDay;
        _investor.lockingPeriod = block.timestamp + animal.lockPeriod;
        _investor.timeTracking = block.timestamp; //ly will come up with something better
        _investor.totalProfit = profitPerDay * animal.lockPeriod;
        // Ensure the user has approved enough USDC for the contract
        require(usdtToken.allowance(msg.sender, address(this)) >= msg.value, "MarketPlace__Allowance_Insufficient");
        bool success = usdtToken.transferFrom(msg.sender, address(this), msg.value);
        require(success, "MarketPlace__USDC_Transfer_Failed");
        // transfer fund
        _safeTransferFrom(address(this), msg.sender, _livestockId, sharesToInvest, "");

        

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
        uint256 priceInUSD = getusdtPriceInUsd();
        uint256 profitToClaim = availableClaimableDays * _investor.profitPerDay;
        uint256 profitToclaimInUsd = (profitToClaim * priceInUSD) /USDT_DECIMAL;

       
        _investor.daysClaimed += availableClaimableDays;

        //transfer profitToClaim to investor;
        usdtToken.transferFrom(address(this), msg.sender, profitToclaimInUsd);
        emit Claim(msg.sender,_livestockId,profitToclaimInUsd);
       // collateralToken.transferFrom(address(this), msg.sender, profitToClaim);
    }
   

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
   //////  borrowing functions            ///////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////

    // accepted collateral e.g USDT, something different;
    function depositCollateral(uint256 amount, address collateralTokenAddress) external payable isverified returns (uint256) {
        uint256 _collateralIndex = collateralIndex;
        //CollateralStruct storage collateralInfomation = collateral[_collateralIndex ];
        require(amount > 0, "COLLATERAL__Amount_Must_Greater_Than_Zero");

        uint256 collateralValueInUsd;

        if (collateralTokenAddress == address(wbtcTokenAddress)) {
            uint256 wbtcPriceInUsd = getwbtcPriceInUsd(); // Fetch the price of wBTC in USD
            collateralValueInUsd = (amount * wbtcPriceInUsd) / WBTC_DECIMAL;  // Adjust for price decimals
        } else if (collateralTokenAddress == address(wethTokenAddress)) {
            uint256 wethPriceInUsd = getwethPriceInUsd(); // Fetch the price of wETH in USD
            collateralValueInUsd = (amount * wethPriceInUsd) / WETH_DECIMAL;  // Adjust for price decimals
        } else{revert("Invalid collateral token");
    }

       collateralValueInUsd = amount; // calculate the value of collateral -LTV
        collateral[_collateralIndex] = CollateralStruct({
            farmer: msg.sender,
            lockPeriod: block.timestamp,
            isLocked: false,
            valueOfCollateral: collateralValueInUsd,
            borrowed: 0
        });
        //collateral[msg.sender].valueOfCollateral = value;
        //collateral[msg.sender].isLocked = true;
        //deposit collateral
        //get collateral value
        // collateralInfomation.valueOfCollateral = value;
        //collateralInfomation.isLocked = true;
        //collateralInfomation.lockPeriod = block.timestamp;
        // collateralInfomation.borrowed = 0;
        collateralIndex++;
       // _safeTransferFrom(msg.sender, address(this), _collateralIndex, value, "");
        collateralToken.transferFrom(msg.sender, address(this), collateralValueInUsd);

        emit DepositedCollateral(msg.sender, collateralValueInUsd, _collateralIndex);
        return _collateralIndex;
    }

    /**
     * @notice borrow amount is allocated to the famer addresss , after you deposit you get id......
     */
    function borrow( /*uint256 _livestockId,*/ uint256 _collateralIndex, uint256 borrowAmount) external {
        // borrowAmount < (valueOfColleral - borrowed)
        CollateralStruct memory collateralInformation = collateral[_collateralIndex];
    
      
        require(collateralInformation.farmer == msg.sender, "COLLATERAL__Not_The_Owner_Of_Collateral");

       
        require(!collateralInformation.isLocked, "COLLATERAL__Collateral_Already_Locked");
      
    
          
        uint256 availableAmountToBorrow = collateralInformation.valueOfCollateral -  collateralInformation.borrowed;
        //uint256  availableAmountToBorrow = collateralInformation.valueOfCollateral;
        require(borrowAmount> 0, "COLLATERAL__BorrowAmount_Must_Be_Greater_Than_Zero");
        require(borrowAmount <= availableAmountToBorrow, "COLLATERAL__BorrowAmount_Exceeds_Avaliablle_Amount_Allowed");

        // Update the collateral struct with the borrowed amount
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
        Animal storage animal = liveStock[_livestockId];
        CollateralStruct memory _collateral = collateral[_collateralIndex];
        require(animal.listingState == State.IN_STOCK, "MARKETPLACE__List_Not_In_Stock");
        require(_collateral.farmer == msg.sender, "COLLATERAL__OWNER_MUST_BE_SENDER");
        //   uint256 availableAmountToBorrow = _collateral.valueOfCollateral - _collateral.borrowed;
        //  require(availableAmountToBorrow > );
           //animal.lockPeriod ;
    
        require(balances[msg.sender] >= animal.periodProfit , "COLLATERAL__NOT_ENOUGH_FUNDS");

        livestockBorrowed[_livestockId] =
            LivestockBorrow({livestockId: _livestockId, amountBorrowed: animal.periodProfit , paid: false});
        livestockFunding[_livestockId] += animal.periodProfit ;
        balances[msg.sender] -= animal.periodProfit ;
    }

 
    function releaseCollateral(uint256 _collateralIndex) external {
        CollateralStruct memory collateralInfo = collateral[_collateralIndex];
        require(collateralInfo.farmer == msg.sender, "COLLATERAL__NOT_OWNER");
        require(collateralInfo.isLocked || collateralInfo.borrowed == 0, "COLLATERAL__Cannot_Release");
        collateral[_collateralIndex] =
            CollateralStruct({farmer: address(0), lockPeriod: 0, isLocked: false, valueOfCollateral: 0, borrowed: 0});
            delete collateral[_collateralIndex];
        collateralToken.transferFrom(address(this), msg.sender, collateralInfo.valueOfCollateral);
        //   _safeTransferFrom(address(this), msg.sender, _collateralIndex, collateralInfo.valueOfCollateral, "");
        emit ReleaseCollateal(_collateralIndex, msg.sender, collateralInfo.valueOfCollateral);
    }
    


    function repayLoan(uint256 _collateralIndex, uint256 _livestockId, uint256 _amount, address tokenAddress) external payable {
        CollateralStruct storage collateralInfo = collateral[_collateralIndex];
        require(collateralInfo.farmer == msg.sender, "COLLATERAL__Not_The_Owner");
        
        uint256 _amountInUsd;
        if (tokenAddress == address(wbtcTokenAddress)) {
            uint256 wbtcPriceInUsd = getwbtcPriceInUsd(); 
            _amountInUsd = (_amount * wbtcPriceInUsd) / WBTC_DECIMAL;  
        } else if (tokenAddress == address(wethTokenAddress)) {
            uint256 wethPriceInUsd = getwethPriceInUsd();
            _amountInUsd = (_amount * wethPriceInUsd) / WETH_DECIMAL; 
        } else if (tokenAddress == address(usdtTokenAddress)){
            uint256 usdtPriceInUsd = getusdtPriceInUsd();
            _amountInUsd =(_amount * usdtPriceInUsd ) / USDT_DECIMAL;
        }
        

        
        require(collateralInfo.borrowed > 0 && _amountInUsd  <= collateralInfo.borrowed, "COLLATERAL__AMOUNT_NOT_IN_RANGE");
        uint256 livestockAmountBorrowed = livestockBorrowed[_livestockId].amountBorrowed;
        // require(_amount == livestockAmountBorrowed, "COLATERAL__NOT")
        if ( _amountInUsd < livestockAmountBorrowed) {
            livestockBorrowed[_livestockId].amountBorrowed -=  _amountInUsd;
        } else if (_amount == livestockAmountBorrowed) {
            livestockBorrowed[_livestockId].amountBorrowed -= _amountInUsd;
            livestockBorrowed[_livestockId].paid = true;
        }

        collateralInfo.borrowed -= _amount;
        emit LoanRepaid(_collateralIndex, _livestockId,  _amountInUsd);
    }

    /**
    * used by farmer to withdraw funding from specific livestockId
     */
     // Mapping to track the total amount of funds for each livestockId

    function withdrawListingFunds(uint256 _livestockId) external onlyLivestockOwner( _livestockId){
        Animal storage animal = liveStock[_livestockId];

        // Ensure the livestock is listed and has some available funds
        require(animal.listingState == State.IN_STOCK, "MarketPlace___Not_Listed");
        uint256 availableFunds = livestockFunds[_livestockId];
        require(availableFunds > 0, "MarketPlace___No_Funds_Available");

        // Check for any remaining refunds to investors
        
        uint256 totalRefunds = 0;
        for (address investorAddr = address(0); investorAddr != address(0); investorAddr) {
            uint256 refundAmount = refunds[_livestockId][investorAddr];
            totalRefunds += refundAmount;
        }

        uint256 withdrawableAmount = availableFunds - totalRefunds;

        // Ensure the contract has enough funds to perform the transfer
        require(address(this).balance >= withdrawableAmount, "MarketPlace___Insufficient_Funds");
        // Set the livestock funds to 0 as they have been withdrawn
            livestockFunds[_livestockId] = 0;

        // Transfer the withdrawable funds to the farmer
        
        bool success = usdtToken.transferFrom( address(this), msg.sender,  withdrawableAmount);
        require(success, "MarketPlace__USDC_Transfer_Failed");
        //(bool success, ) = msg.sender.call{value: withdrawableAmount}("");
        //require(success, "MarketPlace___Withdraw_Fund_Failed");

        
        // Emit event for the withdrawal
        emit Withdrawn(_livestockId, msg.sender, withdrawableAmount);
    }
    

    /**@notice this function is used to fund the protocol
     * donors can help raise funds for the protocol through this function
     */
  function fundProtocol(uint256 _amount, address tokenAddress) external payable {
    uint256 _amountInUsd;
    if (tokenAddress == address(wbtcTokenAddress)) {
        uint256 wbtcPriceInUsd = getwbtcPriceInUsd(); 
        _amountInUsd = (_amount * wbtcPriceInUsd) / WBTC_DECIMAL;  
    } else if (tokenAddress == address(wethTokenAddress)) {
        uint256 wethPriceInUsd = getwethPriceInUsd();
        _amountInUsd = (_amount * wethPriceInUsd) / WETH_DECIMAL; 
    } else if (tokenAddress == address(usdtTokenAddress)){
        uint256 usdtPriceInUsd = getusdtPriceInUsd();
        _amountInUsd =(_amount * usdtPriceInUsd ) / USDT_DECIMAL;
    }
    require (_amountInUsd > 0 ,"MARKETPLACE__AMOUNT_TOO_SMALL");
    collateralToken.transferFrom(msg.sender, address(this), _amountInUsd);
    usdtToken.transferFrom(msg.sender, address(this), _amountInUsd);

  }
 

   ////////////////////////////////////////////////////////////////////////////////////////////////////////
   //////  getter functions            ///////////////////////////////////////////////////////////////////
   ///////////////////////////////////////////////////////////////////////////////////////////////////////
    function getFarmerBorrowedAmount(uint256 _collateralIndex) external view returns (uint256) {
        CollateralStruct memory _collateral = collateral[_collateralIndex];
        return _collateral.borrowed;
    }

    function getFarmerAvailableCredit(uint256 _collateralIndex) external view returns (uint256) {
        CollateralStruct memory _collateral = collateral[_collateralIndex];
        return _collateral.valueOfCollateral - _collateral.borrowed;
    }

    //  function withdrawClaim(uint256 _livestockId, address _investorAddress) external {}
    function getwbtcPriceInUsd() public view returns (uint256) {
        (, int256 price,,, ) = s_wbtcUsdAggregator.latestRoundData();
        return uint256(price);
    }

    function getwethPriceInUsd() public view returns (uint256) {
        (, int256 price,,, ) = s_wbtcUsdAggregator.latestRoundData();
        return uint256(price);
    }

    function getusdtPriceInUsd() public view returns (uint256) {
        (, int256 price,,, ) = s_wbtcUsdAggregator.latestRoundData();
        return uint256(price);
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

 //funding the contract 
 
}