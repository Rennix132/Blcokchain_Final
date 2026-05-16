// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

contract AMMPair is ERC20, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint112 public reserve0;
    uint112 public reserve1;

    error InsufficientAmount();
    error InvalidPath();
    error SlippageExceeded();

    constructor(address _token0, address _token1) ERC20("AMM LP", "AMMLP") {
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _update(uint256 balance0, uint256 balance1) private {
        reserve0 = uint112(balance0);
        reserve1 = uint112(balance1);
    }

    function addLiquidity(uint256 amount0, uint256 amount1, uint256 minLpTokens) external nonReentrant returns (uint256 liquidity) {
        token0.safeTransferFrom(msg.sender, address(this), amount0);
        token1.safeTransferFrom(msg.sender, address(this), amount1);

        uint256 _reserve0 = reserve0;
        uint256 _reserve1 = reserve1;
        uint256 balance0 = token0.balanceOf(address(this));
        uint256 balance1 = token1.balanceOf(address(this));

        if (totalSupply() == 0) {
            liquidity = Math.sqrt(amount0 * amount1) - 1000;
            _mint(address(0), 1000);
        } else {
            liquidity = Math.min(
                (amount0 * totalSupply()) / _reserve0,
                (amount1 * totalSupply()) / _reserve1
            );
        }

        if (liquidity < minLpTokens) revert SlippageExceeded();

        _mint(msg.sender, liquidity);
        _update(balance0, balance1);
    }

    function swap(address tokenIn, uint256 amountIn, uint256 minAmountOut) external nonReentrant returns (uint256 amountOut) {
        if (amountIn == 0) revert InsufficientAmount();
        bool isToken0 = tokenIn == address(token0);
        if (!isToken0 && tokenIn != address(token1)) revert InvalidPath();

        IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), amountIn);

        uint256 amountInWithFee = amountIn * 997;
        
        if (isToken0) {
            amountOut = (amountInWithFee * reserve1) / ((reserve0 * 1000) + amountInWithFee);
            if (amountOut < minAmountOut) revert SlippageExceeded();
            token1.safeTransfer(msg.sender, amountOut);
        } else {
            amountOut = (amountInWithFee * reserve0) / ((reserve1 * 1000) + amountInWithFee);
            if (amountOut < minAmountOut) revert SlippageExceeded();
            token0.safeTransfer(msg.sender, amountOut);
        }

        _update(token0.balanceOf(address(this)), token1.balanceOf(address(this)));
    }
}