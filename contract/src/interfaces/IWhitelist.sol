// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IWhiteList {
    struct WhiteListStruct {
        address owner;
        address[] contacts;
    }

    event AddressAdded(address indexed Address);
    event AddressRemoved(address indexed Address);

    function createPublicWhitelist(uint256 _livestockId, address _owner) external;

    function createPrivateWhitelist(uint256 _livestockId, address _owner) external;

    function addToPublicWhiteList(uint256 _livestockId, address Add) external;

    function addToPrivateWhiteList(uint256 _livestockId, address Add) external;

    function isPublicWhiteList(uint256 _livestockId, address Add) external view returns (bool);

    function isPrivateWhiteList(uint256 _livestockId, address Add) external view returns (bool);

    function removeFromPublicWhitelist(uint256 _livestockId, address Add) external;

    function removeFromPrivateWhitelist(uint256 _livestockId, address Add) external;

    function owner() external view returns (address);

    function publicWhitelist(uint256 _livestockId) external view returns (WhiteListStruct memory);

    function privateWhitelist(uint256 _livestockId) external view returns (WhiteListStruct memory);
}
