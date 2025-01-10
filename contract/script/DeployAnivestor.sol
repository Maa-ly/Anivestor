// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;
import "contract/lib/forge-std/src/Script.sol";
import "contract/src/marketplace.sol";
import "contract/src/FarmerRegistration.sol";
import "contract/src/whiteList.sol";
import "contract/src/WhitelIstDeployer.sol";
import "contract/script/HelperConfig.sol";
contract DeployAnivestor is Script {
    address[] public tokenAddresses;
    address[] public priceFeedAddresses;
    function run() external returns (FarmerRegistration, WhiteList, MarketPlace, HelperConfig, WhiteListDeployer) {
        
        HelperConfig helperConfig = new HelperConfig(); 
      
        (
          
            address weth, 
            address wbtc, 
            address usdt, 
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
            usdt,             
            wethUsdPriceFeed, 
            wbtcUsdPriceFeed  
        );
        vm.stopBroadcast();
     
        return (farmer, whiteListDeployer, marketPlace, helperConfig);
    }
}