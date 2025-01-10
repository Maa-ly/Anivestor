// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;


import  {AggregatorV3Interface  } from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
/*
 * @title OracleLib
 * @author Lydia Gyamfi Ahenkorah && Nobel
 * @notice This library is used to check the Chainlink Oracle for stale data.
 * If a price is stale, functions will revert, and render the --- unusable - this is by design.
 * We want the DSCEngine to freeze if prices become stale.
 *
 * 
 */
 library OracleLib {
    error OracleLib__StalePrice(address feed, uint256 lastUpdated, uint256 timeout);
    error OracleLib__InvalidPrice(address feed, int256 price);
    error OracleLib__InsufficientFeeds();

    event StalePriceDetected(address feed, uint256 lastUpdated, uint256 timeout);

    struct PriceData {
        int256 price;
        uint8 decimals;
    }

    /**
     * @dev Checks if the latest data from a Chainlink feed is stale.
     * @param chainlinkFeed The Chainlink price feed contract.
     * @param timeout The timeout period in seconds.
     */
    function staleCheckLatestRoundData(AggregatorV3Interface chainlinkFeed, uint256 timeout)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            chainlinkFeed.latestRoundData();

        if (updatedAt == 0 || answeredInRound < roundId) {
            revert OracleLib__StalePrice(address(chainlinkFeed), updatedAt, timeout);
        }

        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > timeout) {
            
            revert OracleLib__StalePrice(address(chainlinkFeed), updatedAt, timeout);
        }

        if (answer <= 0) {
            revert OracleLib__InvalidPrice(address(chainlinkFeed), answer);
        }

        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }

    /**
     * @dev Fetches the latest price from a Chainlink feed with stale data checks.
     * @param chainlinkFeed The Chainlink price feed contract.
     * @param timeout The timeout period in seconds.
     * @return price The latest price.
     */
    function getLatestPrice(AggregatorV3Interface chainlinkFeed, uint256 timeout)
        public
        view
        returns (PriceData memory)
    {
        (, int256 answer, , uint256 updatedAt, ) = staleCheckLatestRoundData(chainlinkFeed, timeout);
        uint8 decimals = chainlinkFeed.decimals();
        uint256 lastTImeupdated = updatedAt;
        return PriceData({ price: answer, decimals: decimals });
    }

    /**
     * @dev Normalizes a price to a fixed number of decimals (e.g., 18 decimals).
     * @param priceData The price data structure containing the price and its decimals.
     * @param targetDecimals The target number of decimals.
     * @return normalizedPrice The normalized price.
     */
    function normalizePrice(PriceData memory priceData, uint8 targetDecimals)
        public
        pure
        returns (int256 normalizedPrice)
    {
        if (priceData.decimals < targetDecimals) {
            normalizedPrice = priceData.price * int256(10 ** (targetDecimals - priceData.decimals));
        } else if (priceData.decimals > targetDecimals) {
            normalizedPrice = priceData.price / int256(10 ** (priceData.decimals - targetDecimals));
        } else {
            normalizedPrice = priceData.price;
        }
    }

   
    

   
    function getTimeout(AggregatorV3Interface /* chainlinkFeed */ ) public pure returns (uint256) {
        return 3 hours; // Default timeout
    }
}