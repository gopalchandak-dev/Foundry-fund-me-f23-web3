// SPDX-License-Identifier: MIT
// 1. Deploy mocks when we are at the local anvil chains.
// 2. Keep track of contract address across different chains
// Sepolia UTH/USD
// Mainnet UTH/USD


pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // If we are on local anvil, we deploy mocks
    // Otherwise, grab the existing address from the live network!.abi

    NetworkConfig public ActiveNetworkConfig;

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig{
        address priceFeed; 
    }

    constructor() {
        if ( block.chainid = 11155111) {
            ActiveNetworkConfig = getSepoliaEthConfig();
        } else if ( block.chainid = 1) {
            ActiveNetworkConfig = getMainnetEthConfig();
        }else {
            ActiveNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory sepoliaConfig =  NetworkConfig({
            PriceFeed:  0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }
    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // price feed address
        NetworkConfig memory ethConfig =  NetworkConfig({
            PriceFeed: 0x44390589104C9164407A0E0562a9DBe6C24A0E05
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public pure returns (NetworkConfig memory){
        if ( ActiveNetworkConfig.priceFeed != address(0)){
            return ActiveNetworkConfig; 
        }

        //price feed address   

        // 1. Deploy the mocks
        // 2. Return the mock address

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAL, INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}

