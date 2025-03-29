# FashionNFT

A decentralized platform for fashion designers to mint and sell digital fashion items as NFTs on the Stacks blockchain.

## Overview

FashionNFT enables designers to tokenize their digital fashion creations, establishing provenance and enabling direct sales to collectors and fashion enthusiasts. The platform leverages Stacks blockchain technology to provide secure, transparent transactions and ownership records.

## Features

- Mint digital fashion items as NFTs with metadata
- Purchase fashion NFTs with STX tokens
- Track designer portfolios and ownership history
- Transparent pricing and provenance

## Smart Contract Functions

### Mint
Allows designers to create new fashion NFTs with name, description, image URI, and price.

### Purchase
Enables users to buy fashion NFTs directly from designers or current owners.

### Read-only Functions
- `get-token-metadata`: Retrieve metadata for a specific token
- `get-designer-tokens`: Get all tokens owned by a specific designer

## Getting Started

1. Clone this repository
2. Install [Clarinet](https://github.com/hirosystems/clarinet)
3. Run `clarinet check` to verify the contract
4. Deploy using Clarinet or the Stacks CLI