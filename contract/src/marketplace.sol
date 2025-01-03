// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MarketPlace is ERC20 {
    constructor() ERC20("NBLE", "LY") {

    }

    struct Animal {
        address farmer;
        string AnimalName;
        string Breed;
        uint256 profitPerDay;
        uint256 periodProfit;
        uint256 lockPeriod;
    }
    enum state{SOLDOUT, IN_STOCK}


    event ListCreated(uint256 indexed  id, address farmer, uint256 lockPeriod);
    event DeListed(uint256 indexed  id, address farmer);
    
    function registerAnimal() external {}

    function createListing() external {

    }
    function deList() external {}
    function getListings() external {}
    function getListingDetails() external {}

    function spotListing() external {}
    function invest() external {}
    function purchaseListing() external {}

}