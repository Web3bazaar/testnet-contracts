# Testnet Contracts

## 👋 About this repo

This repo contains the solidity code used in the Bazaar smart contracts hosted on the compatible EVM testnets.

## 📝 About the Smart contract

The Web3 Bazaar dApp is supported by non-custodial escrow contracts that enable peer-to-peer swaps of ERC-20, ERC-721 or ERC-1155 tokens. Contracts' only purpose is to switch asset ownership from one wallet address to another under the trades pre-established in it. 

### Bazaar smart contracts are:
- <b>fully permisionless</b>: every token from a supported standard can be traded by every wallet withouth censorship.
- <b>non-custodial</b>: Your assets never leave your wallet until the trade is complete.
- <b>free to use</b>: no fees are charged to access or swap assets within the Bazaar (apart from gas fees)
- <b>bundle transaction enabled</b>: asset owners can do 1:1 trades or mix assets in a bundle to trade for another set of assets owned by the counter-party.


### Testnets available

| Testnet    | Contract address |
| ---          | ---        |
| Mumbai | [0x0a50b369f107aef88e83b79f8e437eb623ac4a0a](https://mumbai.polygonscan.com/address/0x0a50b369f107aef88e83b79f8e437eb623ac4a0a) |



## 👷 How to test the Web3 Bazaar in Mumbai testnet

>Note: Make sure to connect your wallet to Mumbai test network. There won't be any costs associated with any transaction or fees you'll be paying interacting with the contracts below

### 0- Fund your wallet with native tokens

Before you start minting tokens or interacting with Bazaar contract you'll need to fund your wallet with native tokens of te corresponding test network. You can use one of the faucets below:

Testnet   | Explorers                     | Testnet Faucets
:-------- |:----------------------------- |:-------------------------
Mumbai    | https://mumbai.polygonscan.com/  | https://faucet.polygon.technology/

<br />


### 1 -Fund your wallet with tradeable assets
Go to one of the smart contracts below and connect your wallet on the `connect to web3` button:

| Asset type   | Network | Address | Opensea Collection |
| ---      | ---       |  ---       |  ---       |
| ERC-20      | Mumbai | [0x89A...6c41](https://mumbai.polygonscan.com/token/0x89A84dc58ABA7909818C471B2EbFBc94e6C96c41) | N/A |
| ERC-20 V2   | Mumbai | [0xA2c...d60BA](https://mumbai.polygonscan.com/token/0xA2cCA397A605BD3164820D37f961c96A35fd60BA) | N/A | 
| ERC-721     | Mumbai |[0x8ba..BD2B](https://mumbai.polygonscan.com/address/0x8ba96897cA8A95B39C639BEa1e5E9ce60d22BD2B#code) | [GO](https://testnets.opensea.io/collection/web3-bazaar-erc-721-test-collection) |
| ERC-1155    | Mumbai | [0xc70...66f](https://mumbai.polygonscan.com/address/0xC70d6b33882dE18BDBD0a372B142aC96ceb1366f#code) | [GO](https://testnets.opensea.io/collection/web3-bazaar-erc-1155-test-collection-v3) |
<br>

Within the contract, go to the `write` tab and execute method `.mint`.<br>

>Note:  In the ERC-20 contract you'll be asked to provide a value for the `payableAmount` parameter. This is the value in Matic that will be used to mint the token. Providing '0' as value will consume none of your test tokens and mint 10 units of the ERC-20 token

### 2 - Repeat the first step with a different wallet

If you want to complete the whole flow yourself you’ll need to fund another wallet with a different asset type and role-play as your counterparty.

Or, you can invite friend and make your trades much funnier.



### 3 - Create and execute trades in the Bazaar

Now that your wallet is funded with testnet assets, you can create and execute trades from the [Bazaar dApp](https://web3bazaar.org) to help us improve the UX or spot eventual bugs in the interface 

<b>Happy P2P trades frens<b>


