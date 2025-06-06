#### *NOT INTENDED FOR PRODUCTION , ONLY EDUCATIONAL PURPOSES. 

# RWA_Tokenization_System
A permissionless real-world asset tokenization framework: mint an ERC-721 NFT for property, verify its market value via Chainlink Functions, store attested valuations in a PoR feed, and issue a 1:1 ERC-20 stablecoin (HouseDAI) backed by the locked NFT, with optional on-chain redemption and DEX liquidity.

## Overview

Collateral: Real estate property represented as an ERC-721 NFT (RealEstateNFT).

Price Oracle: Chainlink Functions (ZillowOracleConsumer) fetches off-chain Zestimate data from Zillow.

Proof-of-Reserve: PoRFeed contract stores and confirms per-token valuations.

Stablecoin: HouseDAI is an ERC-20 token, minted 1:1 against verified property value.

Vault: Vault locks the NFT and mints HouseDAI when price is confirmed.

Swap Adapter (optional): PoRSwapAdapter allows holders to swap HouseDAI for USDC if pre-fund


##  Repository Structure

rwa-tokenization/
- ├── contracts/
- │ ├── RealEstateNFT.sol
- │ ├── HouseDAI.sol
- │ ├── PoRFeed.sol
- │ ├── ZillowOracleConsumer.sol
- │ ├── Vault.sol
- │ ├── PoRSwapAdapter.sol
- │ ├── FunctionsClient.sol
- │ ├── FunctionsRequest.sol
- │ ├── IFunctionsRouter.sol
- │ └── IFunctionsClient.sol
- │
- ├── metadata/
- │ ├── metadata.json # NFT metadata
- │ ├── front.jpg # Property image
- │ └── deed.png # Deed scan image
- │
- ├── scripts/
- │ └── deploy.js # Hardhat/ethers.js deployment script
- │
- ├── test/
- │ └── vault.test.js # Automated unit tests
- │
- ├── frontend/ # (Optional) simple DApp UI
- │ ├── index.html
- │ ├── script.js-
- │ └── style.css
- │
- ├── README.md # This file
- ├── package.json # NPM dependencies & scripts
- ├── hardhat.config.js # Hardhat config
- ├── .env # Environment variables (e.g. RPC URLs, keys)
- └── .gitignore

##  Prerequisites

- **Node.js v14+ & npm**
- **Solidity 0.8.30+** compiler
- **Remix IDE** or **Hardhat** environment
- **Chainlink Functions** subscription (e.g. Avalanche Fuji)  

