// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IMarketPlace {
    enum State {
        SOLDOUT,
        IN_STOCK,
        UNLISTED
    }

    enum WhiteListType {
        PUBLIC,
        PRIVATE
    }

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
        uint256 pricepershare;
        uint256 profitPerDay;
        uint256 periodProfit;
        uint256 lockPeriod;
        uint256 totalAmountSharesMinted;
        uint256 avaliableShare;
        uint256 listingTime;
        State listingState;
        WhiteListType whiteListType;
    }

    event AnimalRegistered(
        uint256 indexed id, 
        address indexed famer, 
        string animalName, 
        uint256 totalAmountSharesMinted
    );
    event Refunded(uint256 livestockId, address indexed investor, uint256 amount);
    event ListCreated(uint256 indexed id, address farmer, uint256 lockPeriod, WhiteListType whiteListType);
    event Invested(uint256 indexed _id, address investor, uint256 amount, uint256 profitPerDay);
    event TransferedOwnership(uint256 indexed _id, address indexed farmer, address newOwner, uint256 totalTokens);
    event DeListed(uint256 livestockId, address indexed owner);
    event Claim(address indexed investor, uint256 Id, uint256 amount);

    function registerAnimal(
        string memory _animalName,
        string memory _breed,
        uint256 _totalAmountSharesMinted
    ) external returns (uint256);

    function createListing(
        uint256 _livestockId,
        uint256 _pricepershare,
        uint256 _profitPerDay,
        uint256 _lockPeriod,
        uint256 _periodProfit,
        WhiteListType _whiteListType
    ) external;

    function deList(uint256 _livestockId) external;

    function Refund(uint256 _livestockId) external;

    function invest(uint256 _livestockId, uint256 sharesToInvest) external;

    function transferListOwnerShip(uint256 _livestockId, address newOwner) external;

    function claim(uint256 _livestockId) external;

    function getListings() external view returns (Animal[] memory);

    function getListingDetails(uint256 _livestockId) external view returns (Animal memory);
}