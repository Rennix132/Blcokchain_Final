// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);
    function description() external view returns (string memory);
    function version() external view returns (uint256);
    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}

contract PriceOracle {
    AggregatorV3Interface public immutable priceFeed;
    uint256 public immutable maxStaleness;

    error StalePrice();
    error InvalidPrice();

    constructor(address _priceFeed, uint256 _maxStaleness) {
        priceFeed = AggregatorV3Interface(_priceFeed);
        maxStaleness = _maxStaleness;
    }

    function getLatestPrice() external view returns (uint256) {
        (, int256 price, , uint256 updatedAt, ) = priceFeed.latestRoundData();
        
        if (price <= 0) revert InvalidPrice();
        if (block.timestamp - updatedAt > maxStaleness) revert StalePrice();

        return uint256(price);
    }
}