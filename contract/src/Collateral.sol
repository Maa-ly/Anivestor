// SPDX-Lidense-Identier: MIT
pragma solidity ^0.8.26;

import {FarmerRegistration} from "./marketplace.sol";

contract Collateral {
   FarmerRegistration public farmer;

   struct CollateralStruct {
      // uint256 amount; //
      uint256 lockPeriod;
      bool isLocked;
      uint256 valueOfCollateral;
      uint256 borrowed;
      // uint256 amountLeftToBorrow;
      uint256 livestockId;
   }

   // implement accepted collateral
   constructor (address _FarmerRegistrationAddress) {
      farmer = FarmerRegistration(_FarmerRegistrationAddress);
   }
   mapping(address => CollateralStruct) public collateral;
       modifier isverified() {
        require(farmer.isVerified(msg.sender), "WhiteListDeployer___Farmer_not_verified");
        _;
    }


   // accepted collateral e.g USDT, something different;
   function depositCollateral(uint256 amount) external payable isverified {
      require(amount > 0, "COLLATERAL__Amount_Must_Greater_Than_Zero");
      
      uint256 value = amount; // calculate the value of collateral -LTV
      collateral[msg.sender].valueOfCollateral = value;
      //deposit collateral 
      //get collateral value
      
   }
   function borrow(uint256 _livestockId, uint256 borrowAmount) external {
      // borrowAmount < (valueOfColleral - borrowed)
      CollateralStruct memory _collateral = collateral[msg.sender];
      require(collateral[msg.sender].valueOfCollateral > 0, "COLLATERAL__Not_Enough_Value");
      require(borrowAmount < (_collateral.valueOfCollateral - _collateral.borrowed), "COLLATERAL__BorrowAmount_Exceeded_Value");

      collateral[msg.sender].borrowed += borrowAmount;
      //livestock -> livestockProfit;

      //totalSharesMinted - availableShares;


   }

   // calculateCollateralValue

}