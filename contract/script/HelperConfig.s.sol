// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import "../lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import "../lib/forge-std/src/Script.sol";
import "../Test/Mock/AggregatorV3INterfaceMock.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        //   address wethUsdPriceFeed;
        address wbtcUsdPriceFeed;
        //   address usdtPriceFeed;
        uint256 deployerKey;
    }
    //   string rpcUrl;

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    constructor() {
        if (block.chainid == 11_155_111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 5115) {
            activeNetworkConfig = getCitreaConfig();
        }
    }

    function getSepoliaEthConfig() public view returns (NetworkConfig memory sepoliaNetworkConfig) {
        sepoliaNetworkConfig = NetworkConfig({
            // wethUsdPriceFeed: 0x7c9906cb5a589c6fa3DaB8E56267D3Ab687cA52f,
            wbtcUsdPriceFeed: 0xb68B780bae5ec684337D78a94fC306a076cE03f9,
            // usdtPriceFeed: 0x2558f030239B950C3e27194A3c58272a05237c15,
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
        // rpcUrl: "https://rpc.sepolia.org"
    }

    function getCitreaConfig() public view returns (NetworkConfig memory citreaNetworkConfig) {
        citreaNetworkConfig = NetworkConfig({
            // wethUsdPriceFeed: 0x7c9906cb5a589c6fa3DaB8E56267D3Ab687cA52f,
            wbtcUsdPriceFeed: 0xb68B780bae5ec684337D78a94fC306a076cE03f9,
            // usdtPriceFeed: 0x2558f030239B950C3e27194A3c58272a05237c15,
            deployerKey: vm.envUint("PRIVATE_KEY")
        });
        // rpcUrl: "https://rpc.testnet.citrea.xyz/"
    }
}
