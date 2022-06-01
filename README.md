# Web3 Bazaar contract



Web3 Bazaar its a escrow contract an escrow usually its an instrument whereby an asset or escrow money is held by a third party on behalf of two other parties that are in the process of completing a transaction. Web3Bazaar in that sense aren't held the assets on behalf of the parties, web3Bazaar its a non-custodial contract which means asset's pass from one part to other when the conditions of the trade are met.

In Web3Bazaar the goal is move web3 assets ownership from two web3 users, one part wants to give a set of web3 assets(ERC20, ERC721, ERC1155) 
and pretend to receives back other another set of web3 assets. The quantity and price estimation about the two swappble sets of itens needs to be agreed between two parties offchain.

Once the trade had been created by the first part (creator) where he supply all the items we want to give and receive once the trade is completed

blabla

fig.1 (state)


### Web3 Bazaar

![this screenshot](/assets/trade_flow.png)




## startTrade

Go to the [Bazaar smart contract](https://mumbai.polygonscan.com/address/0x3ca48686212af897019a8e89140e64e8f2cc2f30) and on the `write` tab execute the following methods to complete a full P2P trade

Start trade method needs to be called by the creator he sends the tokens we want to trade from his side it could be a list of assets of any type of asset's ERC20 ERC721 and ERC1155. Also send the list of asset's they want to get from the executer side also in a form of a list of tokens in any type. 

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

#3# executeTrade

The executer needs to execute the trade to complete swap between the assets. This operation swap's the assets from the creator to the executer wallet. 

- `executeTrade` method

Execute this method in behalf of both parties' wallets in order to deposit the assets in the contract:

| Parameter     | Input |
| ---      | ---       |
| tradeId  | Input value returned by `startTrade` method|

>Note: When role-playing as the counterparty you can call this method without providing a wallet address. 
>







