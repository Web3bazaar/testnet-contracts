// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract MultiAccessControl {

    mapping (address => uint8) internal _owners;

    modifier isOwner() {
        require(_owners[msg.sender] == 10, "ERR_NOT_OWNER");
        _;
    }
    
    //constructor(address[] payable ownerAdress) {
    //    _owner = ownerAdress; 
    //}

    constructor() {
        _owners[msg.sender] = 10;
    }

    function addOwnership(address payable newOwner) public isOwner {
        require(newOwner != address(0), "ERR_ZERO_ADDR");
       _owners[newOwner] = 10;
    }
    
    function removeOwnership(address payable existingOwner) public isOwner {
        require(_owners[existingOwner] == 10, "ERR_ADDR_NOT_OWNER");
       _owners[existingOwner] = 0;
    }
}

contract BatchWeb3Bazaar is Context, ERC1155Holder, ERC721Holder, MultiAccessControl
{
    event NewTrade(address indexed creator, address indexed executor, uint256 tradeId);
    event FinishTrade( address indexed executor, uint256 tradeId);

    uint256 private _tradeId;
    string  private _symbol;
    mapping(uint256 => Trade) internal _transactions;
    mapping(address => uint256[]) internal _openTrades;

    uint256 public openTradeCount;
    uint256 public totalCompletedTrade;

    enum TradeStatus { NON, TRADE_CREATED, TRADE_COMPLETED, TRADE_CANCELLED  }
    enum UserStatus  { NON, OPEN, DEPOSIT, CLAIM }
    enum TradeType   { NON, ERC20, ERC1155, ERC721, NATIVE }

    struct TradeCounterpart {
        address contractAddr;
        uint256 idAsset;
        uint256 amount;
        TradeType traderType;
        UserStatus traderStatus;
    }
    struct Trade {
        address creator;
        address executor;
        uint256 id;
        mapping(address => TradeUser) _traders;
        TradeStatus tradeStatus;
    }
    struct TradeUser 
    {
         uint256[] tokenAddressIdx;
         mapping(uint256 => TradeCounterpart ) _counterpart;
    }
    constructor()
        MultiAccessControl()
    {
        openTradeCount = 0;
        totalCompletedTrade = 0;
    }
    function cancelTrade(uint256 tradeId) public  returns (bool)
    {
        Trade storage store = _transactions[tradeId];
        require(store.tradeStatus == TradeStatus.TRADE_CREATED, 'WEB3BAZAAR_ERROR: TRADE_STATUS ISNT CREATED');
        require(store.executor == msg.sender || store.creator == msg.sender , 'WEB3BAZAAR_ERROR: EXECUTER ISNT CREATOR OR EXECUTER');
        _transactions[tradeId].tradeStatus = TradeStatus.TRADE_CANCELLED;
        openTradeCount = openTradeCount - 1;
        return true;
    }
    function getTrade(uint256 tradeId) public view returns (address, address,uint8)
    {
        Trade storage store = _transactions[tradeId];
        return (store.creator, store.executor, uint8(store.tradeStatus));
    }
    function getTrade(uint256 tradeId, address userWallet) public view returns (address[] memory, uint256[] memory , uint256[] memory , uint8[] memory )
    {
        Trade storage store = _transactions[tradeId];
        uint256[] memory tokenAddressIdx = store._traders[userWallet].tokenAddressIdx;

        address[]  memory _tradeTokenAddress = new address[](tokenAddressIdx.length);
        uint256[]  memory _tradeTokenIds     = new uint256[](tokenAddressIdx.length);
        uint256[]  memory _tradeTokenAmount  = new uint256[](tokenAddressIdx.length);
        uint8[]    memory _tradeType         = new uint8[](tokenAddressIdx.length);

        for(uint y = 0; y < tokenAddressIdx.length; y++){
                TradeCounterpart memory tInfo = store._traders[userWallet]._counterpart[tokenAddressIdx[y]];
                _tradeTokenAddress[y]= tInfo.contractAddr;
                _tradeTokenIds[y] = tInfo.idAsset;
                _tradeTokenAmount[y]= tInfo.amount;
                _tradeType[y] = uint8(tInfo.traderType);
        }
        return (_tradeTokenAddress, _tradeTokenIds, _tradeTokenAmount, _tradeType  );
    }
    function verifyERC721 (address from, address tokenAddress, uint256 tokenId, bool verifyAproval) internal view returns (bool){
        require(from == ERC721(tokenAddress).ownerOf{gas:100000}(tokenId), 'WEB3BAZAAR_ERROR: ERR_NOT_OWN_ID_ERC721');
        if(verifyAproval){
            require( ERC721(tokenAddress).isApprovedForAll{gas:100000}( from, address(this) ) , 'WEB3BAZAR_ERROR: ERR_NOT_ALLOW_TO_TRANSER_ITENS_ERC721');
        }
        return true;
    }
    function verifyERC20 (address from, address tokenAddress, uint256 amount, bool verifyAproval ) internal view returns (bool){
        require(amount <= IERC20(tokenAddress).balanceOf{gas:100000}(from), 'WEB3BAZAAR_ERROR: ERR_NOT_ENOUGH_FUNDS_ERC20');
        if(verifyAproval){
            require(amount <= IERC20(tokenAddress).allowance{gas:100000}(from, address(this) ), 'WEB3BAZAR_ERROR: ERR_NOT_ALLOW_SPEND_FUNDS');
        }    
        return true;
    }
    function verifyERC1155 (address from, address tokenAddress, uint256 amount, uint256 tokenId, bool verifyAproval) internal view returns (bool){
        require(tokenId > 0, 'WEB3BAZAAR_ERROR: STAKE_ERC1155_ID_SHOULD_GREATER_THEN_0');
        require(amount > 0 && amount <= ERC1155(tokenAddress).balanceOf{gas:100000}(from, tokenId), 'WEB3BAZAAR_ERROR: ERR_NOT_ENOUGH_FUNDS_ERC1155');
        if(verifyAproval){
            require( ERC1155(tokenAddress).isApprovedForAll{gas:100000}( from, address(this) ) , 'WEB3BAZAR_ERROR: ERR_NOT_ALLOW_TO_TRANSER_ITENS_ERC1155');
        }    
        return true;
    }
    function swapERC721 (address from, address to, address tokenAddress, uint256 tokenId) internal returns (bool){
        verifyERC721(from, tokenAddress, tokenId, true);
        ERC721(tokenAddress).safeTransferFrom{gas:100000}(from, to , tokenId, '');
        return true;
    }
    function swapERC1155 (address from, address to, address tokenAddress, uint256 tokenId, uint256 amount) internal returns (bool)
    {
        verifyERC1155(from, tokenAddress, amount, tokenId, true );
        ERC1155(tokenAddress).safeTransferFrom{gas:100000}(from, to , tokenId, amount, '0x01' );
        return true;
    }
    function swapERC20 (address from, address to, address tokenAddress, uint256 amount) internal returns (bool){
        verifyERC20(from, tokenAddress, amount, true );
        IERC20(tokenAddress).transferFrom{gas:100000}(from, to , amount);
        return true;
    }
    function executeTrade(uint256 tradeId )  public returns(uint256)
    {
        Trade storage store = _transactions[tradeId];
        require(store.tradeStatus == TradeStatus.TRADE_CREATED, 'WEB3BAZAAR_ERROR: TRADE_STATUS ISNT CREATED');

        address  executer = store.executor;
        address  creator = store.creator;
        require(executer == msg.sender, 'WEB3BAZAAR_ERROR: CALLER INST THE EXECUTER');
        TradeCounterpart storage tempSwap;
        for (uint i = 0; i < store._traders[creator].tokenAddressIdx.length; i++) 
        {
            uint256 tokenAddressIdx = store._traders[creator].tokenAddressIdx[i];
            tempSwap =  store._traders[creator]._counterpart[tokenAddressIdx];
            if(tempSwap.traderType == TradeType.ERC20){
                swapERC20(creator, executer, tempSwap.contractAddr, tempSwap.amount);
            }else if(tempSwap.traderType == TradeType.ERC721){
                swapERC721(creator, executer, tempSwap.contractAddr, tempSwap.idAsset);
            }else if(tempSwap.traderType == TradeType.ERC1155){
                swapERC1155(creator, executer, tempSwap.contractAddr, tempSwap.idAsset, tempSwap.amount);
            }

        }
        for (uint i = 0; i < store._traders[executer].tokenAddressIdx.length; i++) 
        {
            uint256 tokenAddressIdx = store._traders[executer].tokenAddressIdx[i];
            tempSwap =  store._traders[executer]._counterpart[tokenAddressIdx];
             if(tempSwap.traderType == TradeType.ERC20){
                swapERC20(executer, creator,  tempSwap.contractAddr, tempSwap.amount);
            }else if(tempSwap.traderType == TradeType.ERC721){
                swapERC721(executer, creator,  tempSwap.contractAddr, tempSwap.idAsset);
            }else if(tempSwap.traderType == TradeType.ERC1155){
                swapERC1155(executer, creator,  tempSwap.contractAddr, tempSwap.idAsset, tempSwap.amount);
            }
        } 
        _transactions[_tradeId].tradeStatus = TradeStatus.TRADE_COMPLETED;
        removeTradeForUser(msg.sender, tradeId);
        removeTradeForUser(_transactions[tradeId].creator, tradeId);
        totalCompletedTrade = totalCompletedTrade + 1;
        openTradeCount      = openTradeCount - 1;
        emit FinishTrade(msg.sender, tradeId);
        return tradeId;
    }

    function verifyTradeIntegrity(address tokenAddress, uint256 tokenId,  uint256 amount, uint8 tokenType) public pure returns(bool)
    {
        require(tokenAddress != address(0), 'WEB3BAZAAR_ERROR: CREATOR_CONTRACT_NOT_VALID' );
        require(tokenType >=0 && tokenType <= uint8(TradeType.NATIVE)  , 'WEB3BAZAR_ERROR: NOT_VALID_TRADE_TYPE');
        require(tokenId > 0  , 'WEB3BAZAR_ERROR: TOKENID_MUST_POSITIVE');
        require(amount > 0  , 'WEB3BAZAR_ERROR: AMOUNT_MUST_POSITIVE');
        return true;
    }

    function startTrade( address[] memory creatorTokenAddress, uint256[] memory creatorTokenId, uint256[] memory creatorAmount, uint8[]  memory creatorTokenType,
                         address  executerAddress , address[] memory executorTokenAddress, uint256[] memory executorTokenId, uint256[] memory executorAmount, uint8[] memory executorTokenType  )  public returns(uint256)
    {
        require(executerAddress != address(0), 'WEB3BAZAAR_ERROR: EXECUTER_ADDRESS_NOT_VALID' );
        require(executerAddress != msg.sender, 'WEB3BAZAAR_ERROR: CREATOR_AND_EXECUTER_ARE_EQUAL');
        require(creatorTokenAddress.length  > 0, 'WEB3BAZAAR_ERROR: CREATOR_TOKEN_ADDRESS_EMPTY');
        require(executorTokenAddress.length > 0, 'WEB3BAZAAR_ERROR: EXECUTER_TOKEN_ADDRESS_EMPTY');

        require(creatorTokenAddress.length == creatorTokenId.length && creatorTokenAddress.length ==  creatorAmount.length 
                 && creatorTokenAddress.length == creatorTokenType.length , 'WEB3BAZAR_PARMS:CREATOR_PARMS_LEN_ERROR');
        require(executorTokenAddress.length == executorTokenId.length && executorTokenAddress.length ==  executorAmount.length 
                 && executorTokenAddress.length == executorTokenType.length , 'WEB3BAZAR_PARMS:EXECUTER_PARMS_LEN_ERROR');

        _tradeId++;
        _transactions[_tradeId].id = _tradeId;
        _transactions[_tradeId].creator = msg.sender;
        _transactions[_tradeId].executor = executerAddress;
        for (uint256 i = 0; i < creatorTokenAddress.length; i++) 
        {
            require(creatorTokenAddress[i] != address(0), 'WEB3BAZAAR_ERROR: CREATOR_TOKEN_ADDRESS_IS_ZERO' );
            verifyTradeIntegrity(creatorTokenAddress[i], creatorTokenId[i], creatorAmount[i], creatorTokenType[i] );
            if(TradeType(creatorTokenType[i]) == TradeType.ERC20){
                verifyERC20(msg.sender, creatorTokenAddress[i], creatorAmount[i], true);
            }else if(TradeType(creatorTokenType[i]) == TradeType.ERC721){
                verifyERC721(msg.sender, creatorTokenAddress[i], creatorTokenId[i], true );
            }else if(TradeType(creatorTokenType[i]) == TradeType.ERC1155){
                verifyERC1155(msg.sender, creatorTokenAddress[i], creatorAmount[i], creatorTokenId[i], true );
            }
            _transactions[_tradeId]._traders[msg.sender].tokenAddressIdx.push(i+1);
            _transactions[_tradeId]._traders[msg.sender]._counterpart[i+1].contractAddr = creatorTokenAddress[i];
            _transactions[_tradeId]._traders[msg.sender]._counterpart[i+1].idAsset = creatorTokenId[i];
            _transactions[_tradeId]._traders[msg.sender]._counterpart[i+1].amount  = creatorAmount[i];
            _transactions[_tradeId]._traders[msg.sender]._counterpart[i+1].traderType = TradeType(creatorTokenType[i]);
            _transactions[_tradeId]._traders[msg.sender]._counterpart[i+1].traderStatus = UserStatus.OPEN;
        }
        for (uint i = 0; i < executorTokenAddress.length; i++) 
        {
            require(executorTokenAddress[i] != address(0), 'WEB3BAZAAR_ERROR: EXECUTER_TOKEN_ADDRESS_IS_ZERO' );
            verifyTradeIntegrity(executorTokenAddress[i], executorTokenId[i], executorAmount[i], executorTokenType[i] );
            if(TradeType(executorTokenType[i]) == TradeType.ERC20){
                verifyERC20(executerAddress, executorTokenAddress[i], executorAmount[i], false);
            }else if(TradeType(executorTokenType[i]) == TradeType.ERC721){
                verifyERC721(executerAddress, executorTokenAddress[i], executorTokenId[i], false );
            }else if(TradeType(executorTokenType[i]) == TradeType.ERC1155){
                verifyERC1155(executerAddress, executorTokenAddress[i], executorAmount[i], executorTokenId[i], false);
            }
            _transactions[_tradeId]._traders[executerAddress].tokenAddressIdx.push(i+1);
            _transactions[_tradeId]._traders[executerAddress]._counterpart[i+1].contractAddr = executorTokenAddress[i];
            _transactions[_tradeId]._traders[executerAddress]._counterpart[i+1].idAsset = executorTokenId[i];
            _transactions[_tradeId]._traders[executerAddress]._counterpart[i+1].amount  = executorAmount[i];
            _transactions[_tradeId]._traders[executerAddress]._counterpart[i+1].traderType = TradeType(executorTokenType[i]);
            _transactions[_tradeId]._traders[executerAddress]._counterpart[i+1].traderStatus = UserStatus.OPEN;
        }
        _transactions[_tradeId].tradeStatus = TradeStatus.TRADE_CREATED;
        _openTrades[msg.sender].push(_tradeId);
        _openTrades[executerAddress].push(_tradeId);
        emit NewTrade(msg.sender, executerAddress, _tradeId );
        openTradeCount = openTradeCount + 1;
        return _tradeId;
    }

    function tradePerUser(address u) public view returns(uint256[] memory ){
        return (_openTrades[u]);
    }

    function removeTradeForUser(address u, uint256 tradeId ) private returns(bool)
    {
        uint256[] memory userTrades = _openTrades[u];

        if(_openTrades[u].length == 1){
            _openTrades[u][0] = 0;
            return true;
        }
        for (uint i = 0; i<userTrades.length-1; i++){
            if(userTrades[i] == tradeId ){
                 _openTrades[u][i] = _openTrades[u][userTrades.length-1];
                 _openTrades[u].pop();
                return true;
            }   
        }
        return false;
    }
}
