// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {WhiteList} from "./whiteList.sol";
import {FarmerRegistration} from "./FarmerRegistration.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WhiteListDeployer is Ownable {
    address ownerr;
    WhiteList public list;
    FarmerRegistration public farmer;

    mapping(address => address) public farmerToWhitelist;

    modifier isverified() {
        require(farmer.isVerified(msg.sender), "WhiteListDeployer___Farmer_not_verified");
        _;
    }

    constructor(address _farmerRegistration) Ownable(msg.sender) {
        ownerr = msg.sender;
        farmer = FarmerRegistration(_farmerRegistration);
    }

    function deployWhiteList() external onlyOwner isverified {
        require(farmerToWhitelist[msg.sender] == address(0), "WhiteListDeployer___Farmer_Already_Has_Whitelist");
        list = new WhiteList(); // Farmer becomes the owner of their WhiteList
        farmerToWhitelist[msg.sender] = address(list);
    }

    function getFarmerWhiteList(address farmerAddress) external view returns (address) {
        return farmerToWhitelist[farmerAddress];
    }
}
