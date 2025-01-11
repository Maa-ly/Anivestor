// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {IERC1155} from "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import {IERC1155Receiver} from "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";

interface IMarketPlace is IERC1155, IERC1155Receiver {
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

    function registerAnimal(string memory _animalName, string memory _breed, uint256 _totalAmountSharesMinted)
        external
        returns (uint256);

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

    function invest(uint256 _livestockId, uint256 sharesToInvest, address tokenAddress) external payable;

    function transferListOwnerShip(uint256 _livestockId, address newOwner) external;

    function claim(uint256 _livestockId) external;

    // New getter function
    function getAnimal(uint256 _livestockId) external view returns (Animal memory);
}
