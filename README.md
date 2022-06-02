# Web3 Bazaar Test Smart Contract V2

## About this repo

This repo contains the solidity code used in the Bazaar test smart contract hosted on the Mumbai test network.

## About the Smart contract

The Web3 Bazaar dApp is supported by a non-custodial escrow contract that enables peer-to-peer swaps of ERC-20, ERC-721 or ERC-1155 tokens.
The contract only purpose is to switch asset ownership from one wallet address to another. 

Trade terms must be defined between parties before being submitted into the contract.
A Trade in the Bazaar can only have 3 status:
| Status    | Description |
| ---          | ---        |
| Created | Terms are established in the Bazaar and ready to be executed by the counter-party. both parties can also change the status to "Cancelled"|
| Completed     | Counter-party executed the trade and assets swapped hands. The trade is now in a status that can't be accessed or trigerred anymore |
| Cancelled      | One of both parties cancelled the trade and it can't be accessed or trigerred anymore |

### Status flows

![this screenshot](/assets/trade_status.png)


## Smart contract Methods

## 1.Start trade

First, the trade must be submitted by the first counterpart (creator). Creator provides the trade terms and smart contract addresses of the assets both parties should commit to the trade. 
It proceeeds to  perform validations to confirm if all the parameters of the trade are valid. Contract checks if all the assets belong to the wallet addresses provided and if the creator gave the necessary permissions for the Bazaar smart contract to perform this asset exchange. The code detects if some issue occurs and throws an error code to the user as describbed in the ERROR LIST at the end of this Readme. 

### Method Description

| Parameter    | Input  |
| ---          | ---        |
| creatorTokenAddress[]  | smart contract address of the asset you're going to deposit|
| creatorTokenId[]     | for ERC-721 and ERC-1155 assets only. Input the specific ID of the NFT you're depositing |
| creatorAmount[]      | amount of assets to deposit. Non-applicable to ERC-721 assets |
| creatorTokenType[]   | "1" for native token, "2" for ERC-20, "3" for ERC-721 or "4" for ERC-1155 |
| executerAddress      | wallet address of the trade counterparty|
| executorAssetContract    | smart contract address of the asset expected form counterparty|
| executorTokenAddress[]    | "1" for native token, "2" for ERC-20, "3" for ERC-721 or "4" for ERC-1155|
| executorTokenId[]    | for ERC-721 and ERC-1155 assets only. nNput the specific ID of the NFT you're expecting from the counterparty|
| executorAmount[]      | amount of assets to deposit. Non-applicable to ERC-721 assets|
| executorTokenType[]      | "1" for native token, "2" for ERC-20, "3" for ERC-721 or "4" for ERC-1155|

>Note: Once this method is called, the smart contract will return a unique `tradeId` value that will be used by the methods below in order to limit the operations to the designtaed parties and assets.

The contract then internally stores all the trade terms and assets' data depicted below:
![Fig.1](/assets/trades-image.png)

## 2.Execute trade

When a trade is submitted and enters `created` status, the counter-party becomes able to execute it. It must have approved the Bazzar contract permissions to move its assets. 
A verification of the ownership of the assets provided in the trade terms is performed again before executing it.
Upon succesful verification the contract executes the swap and changes the status of the trade to `Completed`

![Fig.1](/assets/trade_flow.png)


### Method Description

| Parameter     | Input |
| ---      | ---       |
| tradeId  | Input value returned by `startTrade` method|



## 3.getTrade

Get Trade methods gives information about the trade based on the `tradeId and user wallet it returns asset's stored for that trade.

| Paramater name | Description  |
| ---     |   ---        |
| tradeId        |   tradeId            |
| userWallet     |   user address       |


## Error List


| Code    | Description  |
| ---     |   ---        |
| CREATOR_PARMS_LEN_ERROR     |   Error sending parameters for creator        |
| EXECUTER_PARMS_LEN_ERROR    |   Error sending parameters for executer       |
| ERR_NOT_OWN_ID_ERC721       |   User isn't the other ERC721 ID asset        |
| ERR_NOT_ALLOW_TO_TRANSER_ITENS_ERC721     |  User did not give permission to spend ERC721 |
| ERR_NOT_ENOUGH_FUNDS_ERC20        |   The user has not have enough ERC20                           |
| ERR_NOT_ALLOW_SPEND_FUNDS         |   User did not give permission to spend ERC20         |
| ERR_NOT_ENOUGH_FUNDS_ERC1155      |   The user has not have enough asset on ERC1155                  |
| ERR_NOT_ALLOW_TO_TRANSER_ITENS_ERC1155     |   ser did not give permission to spend ERC1155        |



## How to test the Web3 Bazaar in Mumbai testnet


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
| ERC-721 V2     | Mumbai |[0x51B..558B](https://mumbai.polygonscan.com/address/0x51B619dE76fc4FD32FE0571F8AD059d07f9f558B#code) | [GO](https://testnets.opensea.io/collection/web3-bazaar-erc-721-test-collection-v3) |
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


