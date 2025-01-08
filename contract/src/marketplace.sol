// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import {WhiteList} from "./whiteList.sol";
import {FarmerRegistration} from "./FarmerRegistration.sol";


contract MarketPlace is ERC1155 {
    ///////////State Viriables/////////////
    uint256 livestockId = 1; // everything is over.....0 nothing 0 id means nada

    FarmerRegistration public farmer;

    /////mapping/////////////
    //mapping(uint256 => Animal) public liveStock;

    Animal[] public liveStock;/* */

    //////Event//////////////
    event AnimalRegistered(
        uint256 indexed id, address indexed famer, string animalName, uint256 totalAmountSharesMinted
    );
    event ListCreated(uint256 indexed id, address farmer, uint256 lockPeriod);
    event DeListed(uint256 indexed id, address farmer);

  //  bytes32 constant STRING_SIZE_SHOULD_BE = 32;

    struct Animal {
        address farmer;
        string animalName;
        string breed;
        uint256 pricepershare;
        uint256 profitPerDay;
        uint256 periodProfit;
        uint256 lockPeriod;
        uint256 totalAmountSharesMinted; /*TotalSharessharesAvaliable */  
        uint256 avaliableShare; /*TotalSharessharesAvaliable - avaliableShare*/
        uint256 listingTime;
        State listingState;
    }

    enum State {
        SOLDOUT,
        IN_STOCK, /// during the delisting we check if the list is instck if yes, then yooou cannot delist.....
        UNLISTED
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

    constructor(string memory URI) ERC1155(URI) {}

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
            listingState: State.UNLISTED
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
        uint256 _periodProfit
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
            listingState: State.IN_STOCK
        });

        emit ListCreated(_livestockId, msg.sender, _lockPeriod);
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

        if(animal.avaliableShare < animal.totalAmountSharesMinted) {
            // refund the investor

        }
        

    }

    
    function refundInvestor() external{}

    function getListings() external view returns(Animal[] memory) {
        return liveStock;
    }

    function getListingDetails(uint256 _livestockId) external view returns(Animal memory){
        return liveStock[_livestockId];
    }

    function spotListing() external {}
    function invest() external {}
    function purchaseListing() external {}
    function transferListOwnerShip() external {}
}
