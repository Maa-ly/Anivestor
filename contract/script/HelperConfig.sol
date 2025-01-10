// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import "../lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import "../lib/forge-std/src/Script.sol";
import "../Test/Mock/AggregatorV3INterfaceMock.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    uint256 public constant WBTC_DECIMALS = 1e18;
    uint256 public constant WETH_DECIMALS = 1e8;
    uint256 public constant USDT_DECIMALS = 1e6;

    int256 public constant ETH_USD_PRICE = 2000e8;

    int256 public constant BTC_USD_PRICE = 1000e8;
    struct NetworkConfig {
       
        address weth;
        address wbtc;
        address usdt;
        uint256 deployerKey;
        string rpcUrl; 
    }

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    constructor() {
        if (block.chainid == 11_155_111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 5115) { 
            activeNetworkConfig = getCitreaConfig(); 
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public view returns (NetworkConfig memory sepoliaNetworkConfig) {
        sepoliaNetworkConfig = NetworkConfig({
           
            weth:0x7c9906cb5a589c6fa3DaB8E56267D3Ab687cA52f,
            wbtc: 0xb68B780bae5ec684337D78a94fC306a076cE03f9,
            usdt:0x2558f030239B950C3e27194A3c58272a05237c15,
            deployerKey: vm.envUint("PRIVATE_KEY"),
            rpcUrl: "https://rpc.sepolia.org" 
        });
    }
    function getCitreaConfig() public view returns (NetworkConfig memory citreaNetworkConfig) {
        
        citreaNetworkConfig = NetworkConfig({
    
            weth: 0x7c9906cb5a589c6fa3DaB8E56267D3Ab687cA52f, 
            wbtc: 0xb68B780bae5ec684337D78a94fC306a076cE03f9, 
            usdt: 0x2558f030239B950C3e27194A3c58272a05237c15, 
            deployerKey: vm.envUint("PRIVATE_KEY"),
            rpcUrl: "https://rpc.testnet.citrea.xyz/" 
        });
    }
    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory anvilNetworkConfig) {
        
        if (activeNetworkConfig.wethUsdPriceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator ethUsdPriceFeed = new MockV3Aggregator(WETH_DECIMALS, ETH_USD_PRICE);
        ERC20Mock wethMock = new ERC20Mock("WETH", "WETH", msg.sender, 1000e8);
        MockV3Aggregator btcUsdPriceFeed = new MockV3Aggregator(WBTC_DECIMALS, BTC_USD_PRICE);
        ERC20Mock wbtcMock = new ERC20Mock("WBTC", "WBTC", msg.sender, 1000e8);
        MockV3Aggregator UsdtPriceFeed = new MockV3Aggregator(USDT_DECIMALS, BTC_USD_PRICE);
        ERC20Mock usdtMock = new ERC20Mock("usdt", "usdt", msg.sender, 1000e8);
        
        vm.stopBroadcast();
        anvilNetworkConfig = NetworkConfig({
            wethUsdPriceFeed: address(ethUsdPriceFeed), // ETH / USD
            weth: address(wethMock),
            wbtcUsdPriceFeed: address(btcUsdPriceFeed),
            wbtc: address(wbtcMock),
            UsdtPriceFeed: address(UsdtPriceFeed),
            usdt : address(usdtMock),
            deployerKey: DEFAULT_ANVIL_PRIVATE_KEY,
            rpcUrl: "http://localhost:8545" 
        });
    }
}
