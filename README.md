# Web3 Bazaar contract


Now that your wallet is funded with testnet assets, you can create and execute trades from the [Bazaar dApp](https://web3bazaar.org) to help us improve the UX or spot eventual bugs in the interface <br>

Alternatively, feel free to keep your journey fully on-chain and interact with the Bazaar smart contract directly by following the steps below.

### Web3 Bazaar

![this screenshot](/assets/trade_flow.png)




## startTrade

Start trade method needs to be called by the creator he sends the tokens we want to trade from their side it could be a list of assets of any type of asset's ERC20 ERC721 and ERC1155, and also send the list of asset's they want to get from the executer side also in a form of a list of tokens in any type. 

Smart contract stores the information about that trade as the following picture describes

![this screenshot](/assets/trades-image.png)

- `startTrade` method

Execute this method by providing the following parameters' data with the trade terms to open a trade in the contract:

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

## executeTrade




### 5 - Create a trade in the Bazaar

Go to the [Bazaar smart contract](https://mumbai.polygonscan.com/address/0x3ca48686212af897019a8e89140e64e8f2cc2f30) and on the `write` tab execute the following methods to complete a full P2P trade






### 6 - Execute a trade 

- `executeTrade` method

Execute this method in behalf of both parties' wallets in order to deposit the assets in the contract:

| Parameter     | Input |
| ---      | ---       |
| tradeId  | Input value returned by `startTrade` method|

>Note: When role-playing as the counterparty you can call this method without providing a wallet address. 



