## Anivestor

### ustaj vojsko

**Farmer Risk**

- farmer needs to put in a collateral to make sure theres a balance

**vesting**

- calculation
- duration/lockperiod
- amount
- lockperiod amount

## IExec

**Ownership**

- investors can transfer ownership

**Data Protection**

**TEE**

**Data protector**
**Grant Access**

**IExec App blackbox**
**web3 email**

### prompt

### todo tonight

- farmer part of marketplace
- Interface - Imarket, Ifarmer

## todo tomorrow

- buyer/invester part of marketplace
- interfaces left, vesting..investor
- vesting

### Thursday

### Oracle, Token interagrtion, IExec intergration

### 8th january todo

- add whitelist in the marketplace --- done
- collateral system ---
  ` farmer locks in collateral

  - gets loan
    -pays back
    -colateral gets unlocked

  ```solidty
  struct CollateralInfomation{
      uint256 amount;
      uint256 lockEndTime;
      bool isLocked;
      uint256 liveStockId;
  }
  function depositCollateralForListing(uint256 _liveSTockId) external payable isverified onlyLivestockOwner(_livestockId){
      Animal storage animal = liveStock[_liveStockId];

      uint256 lockEndTime = block.timestamp + animal.lockperiod;

      //creates the collateral entry so meaning i need a struct ok

  }
  ```

- interfaces

### Oracle, IExec intergration

## borrowing system

- puts collateral
  - collateral is lock untill lockperiodend and borrow amount is paid || borrow amount is paid
  - repay borrowed amount
- borrows against the collateral
  - needs to be a borrow limit per day or not || just borrow enough for that particular listing
  - how much collateral is locked in
    -currently daily profit obligation
- Repays the borrowed amount

### functions

- function releaseCollateral() external {}

- function repayCollateral() external{}

- function getFarmerBorrowedAmount() external{}

- function getFarmerAvailableCredit() external{}

- function withdrawClaim(uint256 \_livestockId, address \_investorAddress) external {}
- done

### thing left to be done --------------------------------------

## restructure the code, better error handling, natspec 
- add interface
- comment
- robust naming
- graphing


### oracles

-acceptedTokens -👍
-priceFeed -👍

### Citea deployment 
- how to deploy on citea
- 

### iExec tools integration
- read on iexec 
- what we can implement in our project
- make a documation on improvment 

### TOdo tomorrow
- Interface 
- Funding the contract
- last code clean-up
- get deployment address


