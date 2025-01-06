// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


import{ ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

contract MarketPlace is ERC1155 {

    uint256 livestockId;

    constructor() ERC1155("NBLE", "LY") {

    }


    struct Animal {
        address farmer;
        string AnimalName;
        string Breed;
        uint256 pricepershare;
        uint256 profitPerDay;
        uint256 periodProfit;
        uint256 lockPeriod;
        uint256 amountMinted /*TotalSharessharesAvaliable */
        uint256 avaliableShare /*TotalSharessharesAvaliable - avaliableShare*/ 
        
    }
    enum state{SOLDOUT, IN_STOCK}


    event ListCreated(uint256 indexed  id, address farmer, uint256 lockPeriod);
    event DeListed(uint256 indexed  id, address farmer);
    

    /**1. tokenize the livestock
       2. shares
       3. metadatauri
       4.pricepershare
       5....when ever you want to register an animal you need to mint equivalent nft/whatever shares
       6. after done mint itll return an ID that will be special to that animal registration ...
       7. id shows ownership of the animal registered for the farmer
     */
    function registerAnimal() external returns(uint256) {}

    function createListing() external {

    }
    function deList() external {}
    function getListings() external {}
    function getListingDetails() external {}

    function spotListing() external {}
    function invest() external {}
    function purchaseListing() external {}
    function transferListOwnerShip() external {}

}