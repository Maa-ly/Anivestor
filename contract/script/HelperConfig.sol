// SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import "contract/lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";
import "contract/lib/forge-std/src/Script.sol";
import "contract/Test/Mock/AggregatorV3INterfaceMock.sol";

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    uint8 public constant WETH_DECIMALS = 1e18;
    uint8 public constant WETH_DECIMALS = 1e8;
    uint8 public constant USDT_DECIMALS = 1e6;

    int256 public constant ETH_USD_PRICE = 2000e8;

    int256 public constant BTC_USD_PRICE = 1000e8;
    struct NetworkConfig {
        address wethUsdPriceFeed;
        address wbtcUsdPriceFeed;
        address usdtPriceFeed;
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
            wethUsdPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, // ETH / USD
            wbtcUsdPriceFeed: 0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43,
            usdtPriceFeed: "",
            weth: 0xdd13E55209Fd76AfE204dBda4007C227904f0a81,
            wbtc: 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063,
            usdt:"",
            deployerKey: vm.envUint("PRIVATE_KEY"),
            rpcUrl: "https://rpc.sepolia.org" 
        });
    }
    function getCitreaConfig() public view returns (NetworkConfig memory citreaNetworkConfig) {
        // using Iexec networkconfig / citrea inst avaliable on chainlink
        citrinaNetworkConfig = NetworkConfig({
            wethUsdPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306, 
            wbtcUsdPriceFeed: 0xb68B780bae5ec684337D78a94fC306a076cE03f9, 
            usdtPriceFeed: "",
            weth: 0xdd13E55209Fd76AfE204dBda4007C227904f0a81, 
            wbtc: 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063, 
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
        MockV3Aggregator UsdtPriceFeed = new MockV3Aggregator(USDT_DECIMALS, CBTC_USD_PRICE);
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
