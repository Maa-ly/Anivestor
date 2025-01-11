// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IWhiteList {
    // Events
    event AddressAdded(address indexed Address);
    event AddressRemoved(address indexed Address);

    // Public Variables
    function publicWhitelist(address Add) external view returns (bool);
    function privateWhitelist(address Add) external view returns (bool);
    function owner() external view returns (address);

    // Functions
    function addToPublicWhiteList(address Add) external;

    function verifyWhiteList(address Add) external view returns (bool);

    function isPublicWhiteList(address Add) external view returns (bool);

    function isPrivateWhiteList(address Add) external view returns (bool);

    function addToPrivateWhitelist(address Add) external;

    function removeFromPublicWhitelist(address Add) external;

    function removeFromPrivateWhitelist(address Add) external;
}
