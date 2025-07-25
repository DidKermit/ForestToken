# 🌲 ForestToken (FST) - Create Your Own ERC20 Token


**ForestToken (FST)** is a custom ERC20 token designed to incentivize **environmental sustainability**. Built on top of **OpenZeppelin’s ERC20 standards**, it integrates several powerful features such as:

- 🧢 **Capped Supply**
- 🔐 **Access Control**
- 💸 **Miner Rewards**
- 🌱 **Token Minting via Tree Planting**


In this project, you’ll learn how to build your own **Ethereum-based ERC-20 token** from scratch, integrating minting logic, role-based access control, and custom incentives for sustainable blockchain applications.

---
## 📚 Table of Contents

- [🌲 ForestToken (FST) - Create Your Own ERC20 Token](#-foresttoken-fst---create-your-own-erc20-token)
  - [📚 Table of Contents](#-table-of-contents)
  - [🚀 Getting started](#-getting-started)
    - [✅ Requirements](#-requirements)
    - [🌐 Network](#-network)
  - [⚡ Quickstart](#-quickstart)
  - [🔗 Resources](#-resources)
  - [🔐 Roles](#-roles)
  - [🔄 Core Functions](#-core-functions)
  - [📉 Emits a `TokensBurned` event upon successful burning.](#-emits-a-tokensburned-event-upon-successful-burning)
  - [📢 Events](#-events)
  - [🔥 Emitted when a user burns their tokens, reducing the total supply.](#-emitted-when-a-user-burns-their-tokens-reducing-the-total-supply)
  - [📦 Compile, Test and Deploy](#-compile-test-and-deploy)
    - [1.  Setup Environment Variables 🔐](#1--setup-environment-variables-)
        - [Required Environment Variables :](#required-environment-variables-)
      - [`.env` file (should look like this)](#env-file-should-look-like-this)
    - [2. Set Your Private Key Using Foundry Keystore 🔑](#2-set-your-private-key-using-foundry-keystore-)
      - [Import Your Wallet 📥](#import-your-wallet-)
    - [3. Compile contract ⚙️](#3-compile-contract-️)
    - [4. Run Tests 🧪](#4-run-tests-)
    - [5. Deployment 🚀](#5-deployment-)
    - [6. Verify Contract 🔍](#6-verify-contract-)
    - [7. Estimate gas](#7-estimate-gas)
    - [8. Formatting](#8-formatting)
  - [✅ Test Coverage Report](#-test-coverage-report)
  - [🙌 Thank You!](#-thank-you)
- [ERC20Token](#erc20token)



---
## 🚀 Getting started 
### ✅ Requirements
Before getting started, make sure you have the following tools installed:

- **Git**  
  Version control system used for cloning and managing the project.

  ```bash
  git --version
- **Foundry**   
  Ethereum development toolkit used to compile, test, and deploy smart contracts.
  ```bash
  curl -L https://foundry.paradigm.xyz | bash && foundryup
  forge --version
- **Metamask**  
  MetaMask is a crypto wallet and gateway to blockchain apps.    
  ```bash
  # Check if MetaMask is installed by visiting:
   chrome://extensions/
  ```
### 🌐 Network   
    
 Sepolia Testnet -  The ForestToken smart contract is deployed on the Sepolia Testnet for development and testing purposes.

 ---
## ⚡ Quickstart 

Follow these steps to get up and running with the ForestToken project:

```bash
git clone https://github.com/your-username/forest-token
cd forest-token
forge install
forge build
``` 
---
## 🔗 Resources

- ### OpenZeppelin Integration 🧰

  ForestToken is built using [OpenZeppelin Contracts](https://docs.openzeppelin.com/contracts), the standard for secure smart contract development.
  To install the OpenZeppelin contracts package using Foundry:
  ```bash
  forge install OpenZeppelin/openzeppelin-contracts --no-commit 
  ```
- ### More Information 📘
  - **Solidity Version**: `v0.8.4`
  - **ERC-20 Standard**: Implemented using OpenZeppelin's ERC-20 interface and extensions.

---
## 🔐 Roles

- `DEFAULT_ADMIN_ROLE`: Can update the block reward.
- `MINER_ROLE`: Cannot plant trees. Receives miner rewards.

---

## 🔄 Core Functions

- `initialSupply(uint256 cap)` : 
  📦 Calculates 25% of the cap to be used as the initial supply.

- `setBlockReward(uint256 reward)`  : 
  🛠️ Admin-only function to update the miner block reward.

- `getBlockReward()` → `uint256`  : 
  💰 Returns the current reward given to miners for planting events.
 - `plantTree(uint256 amount)`  :  
   🌳 Allows a user (non-miner) to plant trees by minting tokens.  
  ❗ Restricted: users with `MINER_ROLE` cannot call this function.  
  🧮 Increases `s_TotalTreesPlanted` and mints tokens to `msg.sender`.  
  🎁 Also rewards the miner (`block.coinbase`) with a predefined block reward.  
  🔥 Emits both `TreesPlanted` and `MintedReward` events.
- `burnTokens(uint256 amount)`   :  
  🔥 Allows users to burn their own tokens, reducing total supply.  
  ❗ Requires the sender to hold at least the amount being burned.  
  📉 Emits a `TokensBurned` event upon successful burning.
---
## 📢 Events

- `TreesPlanted(address sender, uint256 amount)`  : 
  🌱 Emitted when a user successfully plants trees.

- `MintedReward(address miner, uint256 reward, uint256 timestamp)`  : 
  🪙 Emitted when miner rewards are minted.
- `TokensBurned(address account, uint256 amount)` : 
  🔥 Emitted when a user burns their tokens, reducing the total supply.
---
##  📦 Compile, Test and Deploy

With this repository, you can compile, run tests, and deploy ERC-20 smart contract using Foundry. 

### 1.  Setup Environment Variables 🔐

Before deploying or interacting with your contract, you’ll need to set a few environment variables. This ensures your deployment scripts and verification tools work correctly.

You can add these variables to a `.env` file in your project root (refer to `.env.example` for guidance).

##### Required Environment Variables :
- **`SENDER`**  -  Your MetaMask account address (used as the deployer).

- **`DEFAULT_ANVIL_KEY`** -
  The private key used when deploying to a local Anvil chain.

- **`SEPOLIA_RPC_URL`**  -
  The RPC URL for the Sepolia testnet.  
  👉 You can get one for free from:  - [Alchemy](https://www.alchemy.com/)
 

- **`ETHERSCAN_API_KEY`**  -
  Your Etherscan API key — used to verify contracts on [etherscan.io](https://etherscan.io/)

#### `.env` file (should look like this) 

```dotenv
SENDER=0xYourMetaMaskAddress
DEFAULT_ANVIL_KEY=your_local_anvil_private_key
SEPOLIA_RPC_URL=https://eth-sepolia.alchemyapi.io/v2/your-api-key
ETHERSCAN_API_KEY=your_etherscan_api_key
```
⚠️ Never commit your .env file to version control. It contains sensitive information.

###  2. Set Your Private Key Using Foundry Keystore 🔑

To securely manage your private key using Foundry's keystore system, follow the steps below:

#### Import Your Wallet 📥

Use the `cast wallet import` command to store your private key securely:

```bash
cast wallet import your-account-name --interactive
Enter private key:
Enter password:
`your-account-name` keystore was saved successfully. Address: address-corresponding-to-private-key
```
### 3. Compile contract ⚙️

To compile all contracts and generate artifacts (including ABI, bytecode, etc.) in the `./out/` directory, run:

```bash
forge build

# You can also use the Makefile shortcut:
make build
```
### 4. Run Tests 🧪
Before running tests, make sure all test dependencies are registered. This includes libraries inside the lib/ folder, such as:
- forge-std
- openzeppelin-contracts

To run your tests use :
```bash
forge test
```
To see detailed traces and logs:
```bash
forge test -vvvv
``` 
To Test a particular test:
```bash
forge test --match-test test_name 
```
Or simply use the Makefile shortcut (to test all test cases):
```bash
make test 
```
### 5. Deployment 🚀
The Makefile supports multiple deployment targets.

- #### 🛠 Local Deployment (Anvil)
   Start Anvil-chain using: 

   ```bash
    make anvil
  ```
  Then deploy locally:
  ```bash
  make deploy
  ```
  This uses the DEFAULT_ANVIL_KEY specified in your .env file.

- #### Deploy to Sepolia 🌐
  Ensure your .env includes the following:

  - SEPOLIA_RPC_URL
  - SENDER
  - ETHERSCAN_API_KEY

  Then deploy to Sepolia and auto-verify:
  ```bash
  make deploy-sepolia
  ```
### 6. Verify Contract 🔍
You can verify the deployed contract on Etherscan using:
 ```bash
 make verify
 ```
This uses:
- Chain ID: 11155111 (Sepolia)
- Compiler: v0.8.25
- Constructor arguments (pre-encoded)

Ensure your Etherscan API key is set in the .env file. 
### 7. Estimate gas
You can estimate how much gas things cost by running:
 ```bash 
 forge snapshot
 ```
And you'll see and output file called .gas-snapshot

### 8. Formatting
To run code formatting:
 ```bash
 forge fmt
 ```
---
## ✅ Test Coverage Report

ForestToken is well-tested to ensure reliability, correctness, and security. Below is the latest test coverage summary generated using Foundry:

![Test Coverage Report](assets/test-coverage.png)

> 📊 This demonstrates that the core logic, control flows, and deployment scripts are covered with **80%+ test coverage** in all categories.

✅ **Key Highlights**:
- All deployment scripts are 100% covered.
- All function paths and major logic branches are thoroughly tested.
- Coverage will continue to improve with each new feature or bug fix.

---
## 🙌 Thank You!

If you found this helpful, feel free to ⭐ star the repo or follow me for more Solidity and Web3 tools!

Connect with me:
- 🐦 Twitter: [@DidKermit](https://x.com/kai_mi_98)
- 💼 LinkedIn: [Kajal Kashyap](https://linkedin.com/in/kajal-kashyap-396910194/)
# ERC20Token
