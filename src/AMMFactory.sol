// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {AMMPair} from "./AMMPair.sol";

contract AMMFactory {
    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    error PairExists();
    error ZeroAddress();

    function createPairWithCreate(address tokenA, address tokenB) external returns (address pair) {
        if (tokenA == address(0) || tokenB == address(0)) revert ZeroAddress();
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        if (getPair[token0][token1] != address(0)) revert PairExists();

        pair = address(new AMMPair(token0, token1));

        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
        allPairs.push(pair);
    }

    function createPairWithCreate2(address tokenA, address tokenB) external returns (address pair) {
        if (tokenA == address(0) || tokenB == address(0)) revert ZeroAddress();
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        if (getPair[token0][token1] != address(0)) revert PairExists();

        bytes memory bytecode = type(AMMPair).creationCode;
        bytes memory initCode = abi.encodePacked(bytecode, abi.encode(token0, token1));
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));

        assembly {
            pair := create2(0, add(initCode, 32), mload(initCode), salt)
        }

        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair;
        allPairs.push(pair);
    }
}