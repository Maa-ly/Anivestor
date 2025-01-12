// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";


/**@author Lydia && Kaleel
 *@notice this contract is used to register farmer and verify the farmer
 *@notice farmer data is protected using iexec data protector , farmer allows the manager to see protected doc in other to be verified
 */
contract FarmerRegistration is Ownable {
    /*//////////////////////////////////////////////////////////////
                            STATE VARIABLES
    //////////////////////////////////////////////////////////////*/

    mapping(address => Farmer) public farmer;
    address manager;

     /*//////////////////////////////////////////////////////////////
                            STRUCT
    //////////////////////////////////////////////////////////////*/

    struct Farmer {
        address farmerAddress;
        string name;
        string documentHash;
        bool verified;
    }

/*//////////////////////////////////////////////////////////////
                  EVENT
    //////////////////////////////////////////////////////////////*/
    event FarmerRegistered(address indexed farmer, string name);
    event FarmerVerified(address indexed farmer);

    /*//////////////////////////////////////////////////////////////
                            FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    constructor() Ownable(msg.sender) {
        manager = msg.sender;
    }

  

 /*//////////////////////////////////////////////////////////////
                            EXTERANL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    /**@notice this function is used by a livestock farmer to register
     *@notice string memory name name of the farm. eg mcdonald's farm
     *@notice string memory documentHash e.g documents proving farm ownership
     */

<<<<<<< HEAD
    function registerFarmer(string memory name, string memory documentHash) external {
        require(farmer[msg.sender].farmerAddress == address(0), "FarmerRegistration__Farmer_Already_Registered");
        farmer[msg.sender] =
            Farmer({farmerAddress: msg.sender, name: name, documentHash: documentHash, verified: false});
        emit FarmerRegistered(msg.sender, name);
    }

    // q does iExec have anything for verification ?
     /**@notice this function is used by manager to verify farmer
     *@notice address farmerAddress
     */
    function verifyFarmer(address farmerAddress) external onlyOwner {
=======
    function verifyFarmer(address farmerAddress) external 
    //  onlyOwner
    {
>>>>>>> b7b83c9798ecf5ccc377fe91c9a1ea89fcb0a6ae
        require(farmer[farmerAddress].farmerAddress != address(0), "FarmerRegistration__Farmer_Hasnt_registered");
        // oracle verification
        farmer[farmerAddress].verified = true;
        emit FarmerVerified(farmerAddress);
    }

<<<<<<< HEAD
      /**@notice this function is used users/anyone to check if a farmer is verified
     *@notice address farmerAddress
     */
=======
    function registerFarmer(string memory name, string memory documentHash) external {
        require(farmer[msg.sender].farmerAddress == address(0), "FarmerRegistration__Farmer_Already_Registered");
        farmer[msg.sender] = Farmer({farmerAddress: msg.sender, name: name, documentHash: documentHash, verified: false});
        this.verifyFarmer(msg.sender);
        emit FarmerRegistered(msg.sender, name);
    }
>>>>>>> b7b83c9798ecf5ccc377fe91c9a1ea89fcb0a6ae

    function isVerified(address farmerAddress) external view returns (bool) {
        return farmer[farmerAddress].verified;
    }
}
