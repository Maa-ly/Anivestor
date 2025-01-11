// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

interface IFarmerRegistration {
    // Events
    event FarmerRegistered(address indexed farmer, string name);
    event FarmerVerified(address indexed farmer);

    // Functions
    function registerFarmer(string memory name, string memory documentHash) external;

    function verifyFarmer(address farmerAddress) external;

    function isVerified(address farmerAddress) external view returns (bool);

    // Getter for farmer mapping
    function farmer(address farmerAddress)
        external
        view
        returns (address farmerAddress_, string memory name, string memory documentHash, bool verified);
}
