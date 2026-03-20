# Flash Loan Arbitrage Bot V3 ⚡

A high-performance, professional-grade arbitrage bot designed for EVM-compatible chains. This repository implements the logic to borrow millions in liquidity, execute swaps across multiple DEXs, repay the loan, and pocket the profit—all in one atomic transaction.

## Core Features
- **Flash Loan Integration**: Compatible with Aave V3 and Uniswap V3.
- **Uniswap V3 Quoter**: Real-time price impact and quote calculation.
- **Optimized Gas**: Written with efficient Solidity patterns to minimize gas overhead during execution.
- **Fail-Safe**: Transaction reverts automatically if the arbitrage is not profitable after gas fees.

## Workflow
1. **Trigger**: External bot detects a price discrepancy between DEX A and DEX B.
2. **Borrow**: Request a Flash Loan from Aave V3.
3. **Arbitrage**: 
    - Swap Asset X for Asset Y on DEX A.
    - Swap Asset Y for Asset X on DEX B.
4. **Repay**: Return the borrowed amount plus the small flash loan fee.
5. **Profit**: Remaining Asset X is sent to the contract owner.

## Tech Stack
- Solidity ^0.8.20
- Foundry / Hardhat
- Aave V3 Core & Uniswap V3 Periphery
