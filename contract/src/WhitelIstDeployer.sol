// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {WhiteList} from "Anivestor/contract/src/whiteList.sol";
import {FarmerRegistration} from "Anivestor/contract/src/FarmerRegistration.sol";

contract WhiteListDeployer {
    address owner;
    WhiteList public list;
    FarmerRegistration public farmer;

    mapping(address => address) public farmerToWhitelist;

    modifier isverified() {
        require(farmer.isVerified(msg.sender), "WhiteListDeployer___Farmer_not_verified");
    }

    constructor(address _farmerRegistration) {
        owner = msg.sender;
        farmer = FarmerRegistration(_farmerRegistration);
    }

    function deployWhiteList() external onlyOwner isverified {
        require(farmerToWhitelist[msg.sender] == address(0), "WhiteListDeployer___Farmer_Already_Has_Whitelist");
        WhiteList list = new WhiteList(msg.sender); // Farmer becomes the owner of their WhiteList
        farmerToWhitelist[msg.sender] = address(list);
    }

    function getFarmerWhiteList(address farmerAddress) external view returns (address) {
        return farmerToWhitelist[farmerAddress];
    }
}
