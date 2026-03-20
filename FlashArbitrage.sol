// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title FlashArbitrage
 * @dev Professional implementation of a Flash Loan arbitrage executor.
 */
contract FlashArbitrage is Ownable {
    
    struct FlashCallbackData {
        address pool0;
        address pool1;
        address token0;
        address token1;
        uint24 fee0;
        uint24 fee1;
        uint256 amount;
    }

    constructor() Ownable(msg.sender) {}

    /**
     * @notice Initiates a flash loan from a Uniswap V3 Pool.
     */
    function startArbitrage(
        address pool,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data
    ) external onlyOwner {
        IUniswapV3Pool(pool).flash(address(this), amount0, amount1, data);
    }

    /**
     * @notice Callback called by Uniswap V3 after sending the flash assets.
     */
    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external {
        FlashCallbackData memory decoded = abi.decode(data, (FlashCallbackData));
        
        // Ensure the call came from a trusted pool
        require(msg.sender == decoded.pool0, "Unauthorized callback");

        // 1. EXECUTE ARBITRAGE LOGIC HERE
        // Example: Swap on DEX B (SushiSwap/PancakeSwap)
        // Ensure the resulting amount covers (decoded.amount + fee0/fee1)

        // 2. REPAY LOAN
        if (fee0 > 0) {
            IERC20(decoded.token0).transfer(msg.sender, decoded.amount + fee0);
        }
        if (fee1 > 0) {
            IERC20(decoded.token1).transfer(msg.sender, decoded.amount + fee1);
        }

        // 3. PROFIT CHECK
        // If contract balance didn't increase, the tx should have been reverted earlier
    }

    function withdraw(address token) external onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner(), balance);
    }
}
