// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract FarmerRegistration is Ownable {
  address ownerr;

  
  

    struct Farmer {
        address farmerAddress;
        string name;
        string documentHash;
        bool verified;
    }

    constructor() Ownable(msg.sender){
        ownerr = msg.sender;
    }

    mapping(address => Farmer) public farmer;

    event FarmerRegistered(address indexed farmer, string name);
    event FarmerVerified(address indexed farmer);

    function registerFarmer(string memory name, string memory documentHash) external {
        require(farmer[msg.sender].farmerAddress == address(0), "FarmerRegistration__Farmer_Already_Registered");
        farmer[msg.sender] =
            Farmer({farmerAddress: msg.sender, name: name, documentHash: documentHash, verified: false});
        emit FarmerRegistered(msg.sender, name);
    }

    // q does iExec have anything for verification ?
    function verifyFarmer(address farmerAddress) external onlyOwner {
        require(farmer[farmerAddress].farmerAddress != address(0), "FarmerRegistration__Farmer_Hasnt_registered");
        // oracle verification
        farmer[farmerAddress].verified = true;
        emit FarmerVerified(farmerAddress);
    }

    function isVerified(address farmerAddress) external view returns (bool) {
        return farmer[farmerAddress].verified;
    }
}
