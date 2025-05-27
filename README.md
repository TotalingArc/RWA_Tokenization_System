### NOT INTENDED FOR PRODUCTION , ONLY EDUCATIONAL PURPOSES. 

# RWA_Tokenization_System
A permissionless real-world asset tokenization framework: mint an ERC-721 NFT for property, verify its market value via Chainlink Functions, store attested valuations in a PoR feed, and issue a 1:1 ERC-20 stablecoin (HouseDAI) backed by the locked NFT, with optional on-chain redemption and DEX liquidity.

## Overview

Collateral: Real estate property represented as an ERC-721 NFT (RealEstateNFT).

Price Oracle: Chainlink Functions (ZillowOracleConsumer) fetches off-chain Zestimate data from Zillow.

Proof-of-Reserve: PoRFeed contract stores and confirms per-token valuations.

Stablecoin: HouseDAI is an ERC-20 token, minted 1:1 against verified property value.

Vault: Vault locks the NFT and mints HouseDAI when price is confirmed.

Swap Adapter (optional): PoRSwapAdapter allows holders to swap HouseDAI for USDC if pre-fund

## Contracts

RealEstateNFT (ERC721URIStorage, Ownable)

Mint property NFTs with IPFS-based metadata.

mintProperty(address to, string tokenURI) -> tokenId

HouseDAI (ERC20, ERC20Burnable, Ownable)

Mintable/burnable stablecoin: HouseDAI (symbol: HDAI).

Owner-only mint() and burnFrom().

PoRFeed (Ownable)

On-chain storage of { tokenId -> value } and confirmation flags.

Only designated oracle address can confirmValue(tokenId, value).

ZillowOracleConsumer (FunctionsClient, Ownable)

Inherits Chainlink FunctionsClient to send/fulfill off-chain requests.

updateConfig(sourceCode, donId, subId, gasLimit) sets JS code and Chainlink parameters.

sendZestimateRequest(url, tokenId) initiates a Functions request, writing result to PoRFeed.

Vault (ReentrancyGuard, Ownable)

Accepts NFT deposits when PoRFeed.isConfirmed(tokenId) is true.

Mints HouseDAI equal to value * 1e18.

Redemption by burning HouseDAI returns the NFT.

PoRSwapAdapter (ReentrancyGuard, Ownable)

Optional USDC swap: burns HouseDAI if PoRFeed.isConfirmed(tokenId) and transfers USDC from a liquidity wallet.
