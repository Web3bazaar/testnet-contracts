# Web3 Bazaar 


Web3 Bazaar its a escrow contract an escrow usually its an instrument whereby an asset or escrow money is held by a third party on behalf of two other parties that are in the process of completing a transaction. Web3Bazaar in that sense aren't held the assets on behalf of the parties, web3Bazaar its a non-custodial contract which means asset's pass from one part to other when the conditions are met.

In Web3Bazaar the goal is move web3 assets ownership from two web3 users, one part wants to give a set of web3 assets(ERC20, ERC721, ERC1155) 
and intends to receives back other set of web3 assets. The quantity and price estimation about the two "exchabgable" sets of itens needs to be agreed between two parties before the trade as been setup, this process its outside the scope for this project. They need to know each other and change at least your wallet address.

When trades are created on the blockchain there is only 3 possible status for that trade. Created, Completed, and Cancelled. Created status is the status after the first user creates the trade, then both users could cancel the trade if one or the other decides that it no longer makes sense. when one of the users cancels the transaction it is removed from the list of active transactions. Completed status is when the second user (executer) executes the trade and accepts to trigger trade then we consider that the trade is finished and no longer available on the list of trades.


![this screenshot](/assets/trade_status.png)



## Steps to exchange assets

### Start trade

First, the trade must be created by the first part (creator) where he fills the items we want to give and receive back once the trade is completed. As agreed with the other user. Before the transaction is accepted by the web3Bazaar contract the code will perform validations which verifies if all the parameters of the trade are valid. Contract check if all the web3 assets intended to be used in the exchange belong to the users involved in this exchange and if the user who is creating the trade gave the necessary permissions for web3bazaar contract to perform this asset exchange. The code detects if some issue occurs and throws an error code to the user. 

Internally contract stores the trade information status and assets the user's wallet address on the storage of the contract as shown in the below image.

![Fig.1](/assets/trades-image.png)



### Execute trade

When a trade are in created status executer user needs to execute that trade in order to swap the assets from on part to other. It is then verified that the executer user has given the contract permissions to move its assets to the other user, and an ownership check of all items is performed again. 
If everthing is verified by the contract then contract execute the swap between assets from one user to other and the trade is marked as Completed.

![Fig.1](/assets/trade_flow.png)


### Web3 Bazaar



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







