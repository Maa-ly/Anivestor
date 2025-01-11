// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "../lib/forge-std/src/Script.sol";
import "../src/marketplace.sol";
import "../src/FarmerRegistration.sol";
import "../src/whiteList.sol";
import "../src/WhitelIstDeployer.sol";
import "./HelperConfig.s.sol";

contract DeployAnivestor is Script {
    address[] public tokenAddresses;
    address[] public priceFeedAddresses;
 
    
    address public weth = ;
    address public wbtc = ;
    address public usdt = ;

    function run() external returns (FarmerRegistration,  WhiteListDeployer, MarketPlace,  HelperConfig ) {
        
        HelperConfig helperConfig = new HelperConfig(); 
      
        (
          
            address wethUsdPriceFeed , 
            address wbtcUsdPriceFeed, 
            address usdtPriceFeed, 
            uint256 deployerKey
        ) = helperConfig.activeNetworkConfig();
   
        tokenAddresses = [weth, wbtc, usdt];
        priceFeedAddresses = [wethUsdPriceFeed, wbtcUsdPriceFeed, usdtPriceFeed];
     
        
        vm.startBroadcast(deployerKey);
       
        FarmerRegistration farmer = new FarmerRegistration();
        
        
        WhiteListDeployer whiteListDeployer = new WhiteListDeployer(address(farmer));
       
        whiteListDeployer.deployWhiteList(); 
     
        address farmerWhiteList = whiteListDeployer.getFarmerWhiteList(msg.sender);
        
        string memory URI = ""; // Use iexec ipfs
        MarketPlace marketPlace = new MarketPlace(
            URI, 
            farmerWhiteList,  
            address(farmer),  
            tokenAddresses,
            priceFeedAddresses  // wbtc/usd right?
        );
        vm.stopBroadcast();
     
        return (farmer, whiteListDeployer, marketPlace, helperConfig);
    }
}