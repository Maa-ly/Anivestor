// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "../lib/forge-std/src/Script.sol";
import "../src/marketplace.sol";
import "../src/FarmerRegistration.sol";
import "../src/whiteList.sol";
import "../src/WhitelIstDeployer.sol";
import "../src/Borrow.sol";
import "./HelperConfig.s.sol";
import "../src/Borrow.sol";

contract DeployAnivestor is Script {
    address public weth = 0xca5b8bE68ad7C298b2Eaa8f6B25D05721D151648;
    address public wbtc = 0x8d0c9d1c17aE5e40ffF9bE350f57840E9E66Cd93;
    address public usdt = 0xC6F0cacFddAFd1Ed72b6806a0E1A5a94BD612038;

    function run() external returns (FarmerRegistration, WhiteListDeployer, MarketPlace, Borrow, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();

        (
            // address wethUsdPriceFeed,
            address wbtcUsdPriceFeed,
            // address usdtPriceFeed,
            uint256 deployerKey
        ) =
        // string memory rpcUrl
         helperConfig.activeNetworkConfig();

        vm.startBroadcast(deployerKey);

        FarmerRegistration farmer = new FarmerRegistration();

        WhiteListDeployer whiteListDeployer = new WhiteListDeployer(address(farmer));

        //   whiteListDeployer.deployWhiteList();

        address farmerWhiteList = whiteListDeployer.getFarmerWhiteList(msg.sender);

        string memory URI = ""; // Use iexec ipfs

        //           address _whiteListAddress,
        //   address _farmerRegistrationAddress,
        //   address _tokenAddress,
        //   address wbtc,
        //   address wbtcUsdAggregatorAddress
        MarketPlace marketPlace = new MarketPlace(URI, farmerWhiteList, address(farmer), usdt);

        Borrow borrow = new Borrow(farmerWhiteList, address(farmer), usdt, wbtc, wbtcUsdPriceFeed);
        // wethUsdPriceFeed, wbtcUsdPriceFeed
        // wbtc/usd right?

        vm.stopBroadcast();

        return (farmer, whiteListDeployer, marketPlace, borrow, helperConfig);
    }
}
