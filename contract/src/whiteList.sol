// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

contract WhiteList {
    mapping(address => bool) public publicWhitelist;
    mapping(address => bool) public privateWhitelist;
    address public owner;

    event AddressAdded(address indexed Address);
    event AddressRemoved(address indexed Address);

    modifier onlyFarmer() {
        require(owner == msg.sender, "revert__only_farmer");
        _;
    }

    constructor(address _owner) {
        owner = _owner;
    }

    function addToPublicWhiteList(address Add) external {
        require(Add != address(0), "revert___Must_Not_Be_Zero_Address");
        require(publicWhitelist[Add] == false, "revert__Already_in_PublicWhitelist");
        publicWhitelist[Add] = true;
    }

    function verifyWhiteList(address Add) external view returns (bool) {
        require(
            privateWhitelist[Add] == true || publicWhitelist[Add] == true, "revert_not_in_public_or_private_whitelist"
        );
        return true;
    }

    function isWhiteList() external view returns (bool) {
        require(
            privateWhitelist[msg.sender] == true || publicWhitelist[msg.sender] == true,
            "revert_not_in_public_or_private_whitelist"
        );
        return true;
    }

    function addToPrivateWhitelist(address Add) external onlyFarmer {
        require(Add != address(0), "revert___Must_Not_Be_Zero_Address");
        require(privateWhitelist[Add] == false, "revert__Already_in_PrivateWhitelist");
        privateWhitelist[Add] = true;
    }

    function removeFromPublicWhitelist(address Add) external {
        require(publicWhitelist[Add] == true, "revert__Address_not_in_PublicWhitelist");
        publicWhitelist[Add] = false;
    }

    function removeFromPrivateWhitelist(address Add) external {
        require(privateWhitelist[Add] == true, "revert__Address_not_in_PrivateWhitelist");
        privateWhitelist[Add] = false;
    }
}
