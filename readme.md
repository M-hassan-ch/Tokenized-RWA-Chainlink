
# Tokenized RWA

This project leverages **Chainlink** and **Zillow's API** to create a fractionalized real estate token, representing off-chain properties on the blockchain. We use **ERC-1155** for fractional ownership, with cross-chain functionality enabled by **Chainlink CCIP**.

## Overview

- **Asset Selection**: Real-world properties are tokenized using data sourced from Zillow's API.
- **Token Specification**: An ERC-1155 token enables fractional ownership with unique property metadata (address, year built, lot size, etc.).
- **Blockchain**: Deployed on Avalanche Fuji, with cross-chain capabilities via CCIP for transfers across connected blockchains.
- **Off-chain Integration**: Chainlink Functions fetch and update property data from Zillow daily, ensuring the token reflects the real-world asset.

## Key Smart Contracts

1. **FunctionsSource.sol**  
   - Stores the JavaScript code to fetch property metadata from Zillow (address, year built, lot size, etc.).

2. **ERC1155Core.sol**  
   - Implements the core ERC-1155 logic, including custom minting functions for the initial issuance and cross-chain transfers.

3. **CrossChainBurnAndMintERC1155.sol**  
   - Extends ERC1155Core to support cross-chain transfers using the burn-and-mint mechanism with Chainlink CCIP.

4. **Withdraw.sol**  
   - Manages the withdrawal of ERC-20 tokens and native coins (funded with LINK tokens for CCIP fees).

5. **RealEstatePriceDetails.sol**  
   - Periodically fetches real estate price data using Chainlink Automation and Functions.

6. **RealEstateToken.sol**  
   - Main contract inheriting all functionality from other contracts.

7. **Issuer.sol**  
   - Helper contract for minting mock ERC-1155 tokens to simulate real estate issuance.

8. **RWALending.sol**  
   - Implements ERC-1155 token lending with initial and liquidation thresholds, slippage protection, and price accuracy via Chainlink Data Feeds.

9. **EnglishAuction.sol**  
   - Minimal English auction implementation for auctioning ERC-1155 real estate tokens with native Avalanche Fuji coin bidding.

## Technologies Used

- **Chainlink Functions**: Fetch off-chain property data.
- **Chainlink Data Feeds**: Ensure accurate USDC/USD price conversions.
- **Chainlink Automation**: Automate data updates from Zillow.
- **Zillow API**: Source real estate metadata.



## Usage

- **Minting Tokens**: Use the `Issuer.sol` to mint token on  `RealEstateToken.sol` contract representing real-world properties.
- **Cross-Chain Transfers**: Tokens can be transferred across chains via the `CrossChainBurnAndMintERC1155.sol` contract.
- **Real Estate Lending**: Lend tokens through `RWALending.sol` and manage auctions using `EnglishAuction.sol`.
