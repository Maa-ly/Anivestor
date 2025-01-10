// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "contract/lib/forge-std/src/Script.sol";

contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;

    uint256 public DEFAULT_ANVIL_PRIVATE_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;

    struct NetworkConfig {
        address deployerKey;
        string rpcUrl; 
    }

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
            deployerKey: vm.envUint("PRIVATE_KEY"),
            rpcUrl: "https://rpc.sepolia.org" 
        });
    }

    function getCitreaConfig() public view returns (NetworkConfig memory citreaNetworkConfig) {
        citreaNetworkConfig = NetworkConfig({
            deployerKey: vm.envUint("PRIVATE_KEY"),
            rpcUrl: "https://rpc.testnet.citrea.xyz/"
        });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory anvilNetworkConfig) {
        anvilNetworkConfig = NetworkConfig({
            deployerKey: DEFAULT_ANVIL_PRIVATE_KEY,
            rpcUrl: "http://localhost:8545" 
        });
    }
}


