# API Reference WASM

This page contains a list of all Datastructures and Classes used within the IN3 WASM-Client.
  
## Main Module

 Importing incubed is as easy as 
```ts
import Client from "in3-wasm"
```

 While the In3Client-class is the default import, the following imports can be used: 

   
This file is part of the Incubed project.
Sources: https://github.com/slockit/in3-c

```eval_rst
  .. list-table::
     :widths: auto

     * - | Class
       - | `IN3 <#type-in3>`_ 
       - | the IN3
     * - | Class
       - | `SimpleSigner <#type-simplesigner>`_ 
       - | the SimpleSigner
     * - | Interface
       - | `EthAPI <#type-ethapi>`_ 
       - | the EthAPI
     * - | Interface
       - | `IN3Config <#type-in3config>`_ 
       - | the iguration of the IN3-Client. This can be paritally overriden for every request.
     * - | Interface
       - | `IN3NodeConfig <#type-in3nodeconfig>`_ 
       - | a configuration of a in3-server.
     * - | Interface
       - | `IN3NodeWeight <#type-in3nodeweight>`_ 
       - | a local weight of a n3-node. (This is used internally to weight the requests)
     * - | Interface
       - | `RPCRequest <#type-rpcrequest>`_ 
       - | a JSONRPC-Request with N3-Extension
     * - | Interface
       - | `RPCResponse <#type-rpcresponse>`_ 
       - | a JSONRPC-Responset with N3-Extension
     * - | Interface
       - | `Signer <#type-signer>`_ 
       - | the Signer
     * - | Interface
       - | `Utils <#type-utils>`_ 
       - | Collection of different util-functions.
     * - | Type literal
       - | `ABI <#type-abi>`_ 
       - | the ABI
     * - | Type literal
       - | `ABIField <#type-abifield>`_ 
       - | the ABIField
     * - | Type alias
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | Type literal
       - | `Block <#type-block>`_ 
       - | the Block
     * - | Type
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block
     * - | Type alias
       - | `Data <#type-data>`_ 
       - | data encoded as Hex (starting with 0x)
     * - | Type alias
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)
     * - | Type
       - | `Hex <#type-hex>`_ 
       - | a Hexcoded String (starting with 0x)
     * - | Type literal
       - | `Log <#type-log>`_ 
       - | the Log
     * - | Type literal
       - | `LogFilter <#type-logfilter>`_ 
       - | the LogFilter
     * - | Type
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.
     * - | Type literal
       - | `Signature <#type-signature>`_ 
       - | Signature
     * - | Type literal
       - | `Transaction <#type-transaction>`_ 
       - | the Transaction
     * - | Type literal
       - | `TransactionDetail <#type-transactiondetail>`_ 
       - | the TransactionDetail
     * - | Type literal
       - | `TransactionReceipt <#type-transactionreceipt>`_ 
       - | the TransactionReceipt
     * - | Type literal
       - | `TxRequest <#type-txrequest>`_ 
       - | the TxRequest

```


## Package in3.d.ts


### Type IN3


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L346)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `IN3 <#type-in3>`_ 
       - | `default <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L431>`_
       - | supporting both ES6 and UMD usage 
     * - | `Utils <#type-utils>`_ 
       - | `util <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L428>`_
       - | collection of util-functions. 
     * - | ``void``
       - | `freeAll <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L412>`_ ()
       - | frees all Incubed instances. 
     * - | `Promise<T> <#type-t>`_ 
       - | `onInit <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L406>`_ (
         |       fn:)
       - | registers a function to be called as soon as the wasm is ready.
         | If it is already initialized it will call it right away. 
     * - | ``void``
       - | `setStorage <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L395>`_ (
         |       handler:)
       - | changes the storage handler, which is called to read and write to the cache. 
     * - | ``void``
       - | `setTransport <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L390>`_ (
         |       fn:)
       - | changes the transport-function. 
     * - | `IN3 <#type-in3>`_ 
       - | `constructor <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L346>`_ (
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | creates a new client. 
     * - | `EthAPI <#type-ethapi>`_ 
       - | `eth <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L418>`_
       - | eth1 API. 
     * - | `Signer <#type-signer>`_ 
       - | `signer <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L382>`_
       - | the signer, if specified this interface will be used to sign transactions, if not, sending transaction will not be possible. 
     * - | `Utils <#type-utils>`_ 
       - | `util <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L423>`_
       - | collection of util-functions. 
     * - | ``any``
       - | `free <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L377>`_ ()
       - | disposes the Client. This must be called in order to free allocated memory! 
     * - | `Promise<RPCResponse> <#type-rpcresponse>`_ 
       - | `send <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L365>`_ (
         |       request:`RPCRequest <#type-rpcrequest>`_ ,
         |       callback:)
       - | sends a raw request.
         | if the request is a array the response will be a array as well.
         | If the callback is given it will be called with the response, if not a Promise will be returned.
         | This function supports callback so it can be used as a Provider for the web3. 
     * - | ``Promise<any>``
       - | `sendRPC <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L372>`_ (
         |       method:``string``,
         |       params:``any`` [])
       - | sends a RPC-Requests specified by name and params. 
     * - | ``void``
       - | `setConfig <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L357>`_ (
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | sets configuration properties. You can pass a partial object specifieing any of defined properties. 

```


### Type SimpleSigner


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L907)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `SimpleSigner <#type-simplesigner>`_ 
       - | `constructor <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L910>`_ (
         |       pks:``any`` [])
       - | constructor 
     * - | 
       - | `accounts <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L908>`_
       - | the accounts 
     * - | `Promise<Transaction> <#type-transaction>`_ 
       - | `prepareTransaction <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L914>`_ (
         |       client:`IN3 <#type-in3>`_ ,
         |       tx:`Transaction <#type-transaction>`_ )
       - | optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig. 
     * - | `Promise<Uint8Array> <#type-uint8array>`_ 
       - | `sign <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L923>`_ (
         |       data:`Hex <#type-hex>`_ ,
         |       account:`Address <#type-address>`_ ,
         |       hashFirst:``boolean``,
         |       ethV:``boolean``)
       - | signing of any data.
         | if hashFirst is true the data should be hashed first, otherwise the data is the hash. 
     * - | ``string``
       - | `addAccount <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L912>`_ (
         |       pk:`Hash <#type-hash>`_ )
       - | add account 
     * - | ``Promise<boolean>``
       - | `hasAccount <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L917>`_ (
         |       account:`Address <#type-address>`_ )
       - | returns true if the account is supported (or unlocked) 

```


### Type EthAPI


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L703)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `IN3 <#type-in3>`_ 
       - | `client <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L704>`_
       - | the client 
     * - | `Signer <#type-signer>`_ 
       - | `signer <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L705>`_
       - | the signer  *(optional)* 
     * - | ``Promise<number>``
       - | `blockNumber <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L710>`_ ()
       - | Returns the number of most recent block. (as number) 
     * - | ``Promise<string>``
       - | `call <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L718>`_ (
         |       tx:`Transaction <#type-transaction>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Executes a new message call immediately without creating a transaction on the block chain. 
     * - | ``Promise<any>``
       - | `callFn <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L722>`_ (
         |       to:`Address <#type-address>`_ ,
         |       method:``string``,
         |       args:``any`` [])
       - | Executes a function of a contract, by passing a [method-signature](https://github.com/ethereumjs/ethereumjs-abi/blob/master/README.md#simple-encoding-and-decoding) and the arguments, which will then be ABI-encoded and send as eth_call. 
     * - | ``Promise<string>``
       - | `chainId <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L726>`_ ()
       - | Returns the EIP155 chain ID used for transaction signing at the current best block. Null is returned if not available. 
     * - | ``any``
       - | `constructor <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L706>`_ (
         |       client:`IN3 <#type-in3>`_ )
       - | constructor 
     * - | 
       - | `contractAt <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L864>`_ (
         |       abi:`ABI <#type-abi>`_  [],
         |       address:`Address <#type-address>`_ )
       - | contract at 
     * - | ``any``
       - | `decodeEventData <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L904>`_ (
         |       log:`Log <#type-log>`_ ,
         |       d:`ABI <#type-abi>`_ )
       - | decode event data 
     * - | ``Promise<number>``
       - | `estimateGas <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L730>`_ (
         |       tx:`Transaction <#type-transaction>`_ )
       - | Makes a call or transaction, which won’t be added to the blockchain and returns the used gas, which can be used for estimating the used gas. 
     * - | ``Promise<number>``
       - | `gasPrice <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L714>`_ ()
       - | Returns the current price per gas in wei. (as number) 
     * - | ``Promise<bigint>``
       - | `getBalance <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L734>`_ (
         |       address:`Address <#type-address>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns the balance of the account of given address in wei (as hex). 
     * - | `Promise<Block> <#type-block>`_ 
       - | `getBlockByHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L746>`_ (
         |       hash:`Hash <#type-hash>`_ ,
         |       includeTransactions:``boolean``)
       - | Returns information about a block by hash. 
     * - | `Promise<Block> <#type-block>`_ 
       - | `getBlockByNumber <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L750>`_ (
         |       block:`BlockType <#type-blocktype>`_ ,
         |       includeTransactions:``boolean``)
       - | Returns information about a block by block number. 
     * - | ``Promise<number>``
       - | `getBlockTransactionCountByHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L754>`_ (
         |       block:`Hash <#type-hash>`_ )
       - | Returns the number of transactions in a block from a block matching the given block hash. 
     * - | ``Promise<number>``
       - | `getBlockTransactionCountByNumber <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L758>`_ (
         |       block:`Hash <#type-hash>`_ )
       - | Returns the number of transactions in a block from a block matching the given block number. 
     * - | ``Promise<string>``
       - | `getCode <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L738>`_ (
         |       address:`Address <#type-address>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns code at a given address. 
     * - | ``Promise<>``
       - | `getFilterChanges <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L762>`_ (
         |       id:`Quantity <#type-quantity>`_ )
       - | Polling method for a filter, which returns an array of logs which occurred since last poll. 
     * - | ``Promise<>``
       - | `getFilterLogs <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L766>`_ (
         |       id:`Quantity <#type-quantity>`_ )
       - | Returns an array of all logs matching filter with given id. 
     * - | ``Promise<>``
       - | `getLogs <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L770>`_ (
         |       filter:`LogFilter <#type-logfilter>`_ )
       - | Returns an array of all logs matching a given filter object. 
     * - | ``Promise<string>``
       - | `getStorageAt <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L742>`_ (
         |       address:`Address <#type-address>`_ ,
         |       pos:`Quantity <#type-quantity>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns the value from a storage position at a given address. 
     * - | `Promise<TransactionDetail> <#type-transactiondetail>`_ 
       - | `getTransactionByBlockHashAndIndex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L774>`_ (
         |       hash:`Hash <#type-hash>`_ ,
         |       pos:`Quantity <#type-quantity>`_ )
       - | Returns information about a transaction by block hash and transaction index position. 
     * - | `Promise<TransactionDetail> <#type-transactiondetail>`_ 
       - | `getTransactionByBlockNumberAndIndex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L778>`_ (
         |       block:`BlockType <#type-blocktype>`_ ,
         |       pos:`Quantity <#type-quantity>`_ )
       - | Returns information about a transaction by block number and transaction index position. 
     * - | `Promise<TransactionDetail> <#type-transactiondetail>`_ 
       - | `getTransactionByHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L782>`_ (
         |       hash:`Hash <#type-hash>`_ )
       - | Returns the information about a transaction requested by transaction hash. 
     * - | ``Promise<number>``
       - | `getTransactionCount <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L786>`_ (
         |       address:`Address <#type-address>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns the number of transactions sent from an address. (as number) 
     * - | `Promise<TransactionReceipt> <#type-transactionreceipt>`_ 
       - | `getTransactionReceipt <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L791>`_ (
         |       hash:`Hash <#type-hash>`_ )
       - | Returns the receipt of a transaction by transaction hash.
         | Note That the receipt is available even for pending transactions. 
     * - | `Promise<Block> <#type-block>`_ 
       - | `getUncleByBlockHashAndIndex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L796>`_ (
         |       hash:`Hash <#type-hash>`_ ,
         |       pos:`Quantity <#type-quantity>`_ )
       - | Returns information about a uncle of a block by hash and uncle index position.
         | Note: An uncle doesn’t contain individual transactions. 
     * - | `Promise<Block> <#type-block>`_ 
       - | `getUncleByBlockNumberAndIndex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L801>`_ (
         |       block:`BlockType <#type-blocktype>`_ ,
         |       pos:`Quantity <#type-quantity>`_ )
       - | Returns information about a uncle of a block number and uncle index position.
         | Note: An uncle doesn’t contain individual transactions. 
     * - | ``Promise<number>``
       - | `getUncleCountByBlockHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L805>`_ (
         |       hash:`Hash <#type-hash>`_ )
       - | Returns the number of uncles in a block from a block matching the given block hash. 
     * - | ``Promise<number>``
       - | `getUncleCountByBlockNumber <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L809>`_ (
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns the number of uncles in a block from a block matching the given block hash. 
     * - | `Hex <#type-hex>`_ 
       - | `hashMessage <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L905>`_ (
         |       data:`Data <#type-data>`_ )
       - | a Hexcoded String (starting with 0x) 
     * - | ``Promise<string>``
       - | `newBlockFilter <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L813>`_ ()
       - | Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges. 
     * - | ``Promise<string>``
       - | `newFilter <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L826>`_ (
         |       filter:`LogFilter <#type-logfilter>`_ )
       - | Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges. 
     * - | ``Promise<string>``
       - | `newPendingTransactionFilter <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L832>`_ ()
       - | Creates a filter in the node, to notify when new pending transactions arrive. 
     * - | ``Promise<string>``
       - | `protocolVersion <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L840>`_ ()
       - | Returns the current ethereum protocol version. 
     * - | ``Promise<string>``
       - | `sendRawTransaction <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L855>`_ (
         |       data:`Data <#type-data>`_ )
       - | Creates new message call transaction or a contract creation for signed transactions. 
     * - | ``Promise<>``
       - | `sendTransaction <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L863>`_ (
         |       args:`TxRequest <#type-txrequest>`_ )
       - | sends a Transaction 
     * - | `Promise<Signature> <#type-signature>`_ 
       - | `sign <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L861>`_ (
         |       account:`Address <#type-address>`_ ,
         |       data:`Data <#type-data>`_ )
       - | signs any kind of message using the `\x19Ethereum Signed Message:\n`-prefix 
     * - | ``Promise<>``
       - | `syncing <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L844>`_ ()
       - | Returns the current ethereum protocol version. 
     * - | `Promise<Quantity> <#type-quantity>`_ 
       - | `uninstallFilter <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L836>`_ (
         |       id:`Quantity <#type-quantity>`_ )
       - | Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren’t requested with eth_getFilterChanges for a period of time. 

```


### Type IN3Config


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L38)


the iguration of the IN3-Client. This can be paritally overriden for every request.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``boolean``
       - | `autoConfig <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L65>`_
       - | if true the config will be adjusted depending on the request  *(optional)* 
     * - | ``boolean``
       - | `autoUpdateList <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L147>`_
       - | if true the nodelist will be automaticly updated if the lastBlock is newer
         | example: true  *(optional)* 
     * - | ``number``
       - | `cacheTimeout <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L42>`_
       - | number of seconds requests can be cached.  *(optional)* 
     * - | ``string``
       - | `chainId <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L132>`_
       - | servers to filter for the given chain. The chain-id based on EIP-155.
         | example: 0x1 
     * - | ``string``
       - | `chainRegistry <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L137>`_
       - | main chain-registry contract
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945  *(optional)* 
     * - | ``number``
       - | `finality <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L122>`_
       - | the number in percent needed in order reach finality (% of signature of the validators)
         | example: 50  *(optional)* 
     * - | ``'json'`` | ``'jsonRef'`` | ``'cbor'``
       - | `format <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L56>`_
       - | the format for sending the data to the client. Default is json, but using cbor means using only 30-40% of the payload since it is using binary encoding
         | example: json  *(optional)* 
     * - | ``boolean``
       - | `includeCode <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L79>`_
       - | if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
         | example: true  *(optional)* 
     * - | ``boolean``
       - | `keepIn3 <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L51>`_
       - | if true, the in3-section of thr response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.  *(optional)* 
     * - | ``any``
       - | `key <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L61>`_
       - | the client key to sign requests
         | example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7  *(optional)* 
     * - | ``string``
       - | `mainChain <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L142>`_
       - | main chain-id, where the chain registry is running.
         | example: 0x1  *(optional)* 
     * - | ``number``
       - | `maxAttempts <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L74>`_
       - | max number of attempts in case a response is rejected
         | example: 10  *(optional)* 
     * - | ``number``
       - | `maxBlockCache <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L89>`_
       - | number of number of blocks cached  in memory
         | example: 100  *(optional)* 
     * - | ``number``
       - | `maxCodeCache <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L84>`_
       - | number of max bytes used to cache the code in memory
         | example: 100000  *(optional)* 
     * - | ``number``
       - | `minDeposit <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L107>`_
       - | min stake of the server. Only nodes owning at least this amount will be chosen. 
     * - | ``number``
       - | `nodeLimit <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L47>`_
       - | the limit of nodes to store in the client.
         | example: 150  *(optional)* 
     * - | ``'none'`` | ``'standard'`` | ``'full'``
       - | `proof <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L98>`_
       - | if true the nodes should send a proof of the response
         | example: true  *(optional)* 
     * - | ``number``
       - | `replaceLatestBlock <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L112>`_
       - | if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
         | example: 6  *(optional)* 
     * - | ``number``
       - | `requestCount <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L117>`_
       - | the number of request send when getting a first answer
         | example: 3 
     * - | ``boolean``
       - | `retryWithoutProof <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L69>`_
       - | if true the the request may be handled without proof in case of an error. (use with care!)  *(optional)* 
     * - | ``string``
       - | `rpc <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L151>`_
       - | url of one or more rpc-endpoints to use. (list can be comma seperated)  *(optional)* 
     * - | 
       - | `servers <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L155>`_
       - | the nodelist per chain  *(optional)* 
     * - | ``number``
       - | `signatureCount <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L103>`_
       - | number of signatures requested
         | example: 2  *(optional)* 
     * - | ``number``
       - | `timeout <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L127>`_
       - | specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
         | example: 3000  *(optional)* 
     * - | ``string`` []
       - | `verifiedHashes <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L93>`_
       - | if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.  *(optional)* 

```


### Type IN3NodeConfig


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L210)


a configuration of a in3-server.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `address <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L220>`_
       - | the address of the node, which is the public address it iis signing with.
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679 
     * - | ``number``
       - | `capacity <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L245>`_
       - | the capacity of the node.
         | example: 100  *(optional)* 
     * - | ``string`` []
       - | `chainIds <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L235>`_
       - | the list of supported chains
         | example: 0x1 
     * - | ``number``
       - | `deposit <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L240>`_
       - | the deposit of the node in wei
         | example: 12350000 
     * - | ``number``
       - | `index <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L215>`_
       - | the index within the contract
         | example: 13  *(optional)* 
     * - | ``number``
       - | `props <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L250>`_
       - | the properties of the node.
         | example: 3  *(optional)* 
     * - | ``number``
       - | `registerTime <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L255>`_
       - | the UNIX-timestamp when the node was registered
         | example: 1563279168  *(optional)* 
     * - | ``number``
       - | `timeout <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L225>`_
       - | the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
         | example: 3600  *(optional)* 
     * - | ``number``
       - | `unregisterTime <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L260>`_
       - | the UNIX-timestamp when the node is allowed to be deregister
         | example: 1563279168  *(optional)* 
     * - | ``string``
       - | `url <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L230>`_
       - | the endpoint to post to
         | example: https://in3.slock.it 

```


### Type IN3NodeWeight


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L265)


a local weight of a n3-node. (This is used internally to weight the requests)

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `avgResponseTime <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L280>`_
       - | average time of a response in ms
         | example: 240  *(optional)* 
     * - | ``number``
       - | `blacklistedUntil <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L294>`_
       - | blacklisted because of failed requests until the timestamp
         | example: 1529074639623  *(optional)* 
     * - | ``number``
       - | `lastRequest <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L289>`_
       - | timestamp of the last request in ms
         | example: 1529074632623  *(optional)* 
     * - | ``number``
       - | `pricePerRequest <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L284>`_
       - | last price  *(optional)* 
     * - | ``number``
       - | `responseCount <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L275>`_
       - | number of uses.
         | example: 147  *(optional)* 
     * - | ``number``
       - | `weight <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L270>`_
       - | factor the weight this noe (default 1.0)
         | example: 0.5  *(optional)* 

```


### Type RPCRequest


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L300)


a JSONRPC-Request with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number`` | ``string``
       - | `id <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L314>`_
       - | the identifier of the request
         | example: 2  *(optional)* 
     * - | ``'2.0'``
       - | `jsonrpc <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L304>`_
       - | the version 
     * - | ``string``
       - | `method <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L309>`_
       - | the method to call
         | example: eth_getBalance 
     * - | ``any`` []
       - | `params <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L319>`_
       - | the params
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest  *(optional)* 

```


### Type RPCResponse


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L324)


a JSONRPC-Responset with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `error <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L337>`_
       - | in case of an error this needs to be set  *(optional)* 
     * - | ``string`` | ``number``
       - | `id <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L333>`_
       - | the id matching the request
         | example: 2 
     * - | ``'2.0'``
       - | `jsonrpc <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L328>`_
       - | the version 
     * - | ``any``
       - | `result <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L342>`_
       - | the params
         | example: 0xa35bc  *(optional)* 

```


### Type Signer


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L689)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Promise<Transaction> <#type-transaction>`_ 
       - | `prepareTransaction <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L691>`_ (
         |       client:`IN3 <#type-in3>`_ ,
         |       tx:`Transaction <#type-transaction>`_ )
       - | optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig. 
     * - | `Promise<Uint8Array> <#type-uint8array>`_ 
       - | `sign <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L700>`_ (
         |       data:`Hex <#type-hex>`_ ,
         |       account:`Address <#type-address>`_ ,
         |       hashFirst:``boolean``,
         |       ethV:``boolean``)
       - | signing of any data.
         | if hashFirst is true the data should be hashed first, otherwise the data is the hash. 
     * - | ``Promise<boolean>``
       - | `hasAccount <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L694>`_ (
         |       account:`Address <#type-address>`_ )
       - | returns true if the account is supported (or unlocked) 

```


### Type Utils


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L929)


Collection of different util-functions.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``any`` []
       - | `abiDecode <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L947>`_ (
         |       signature:``string``,
         |       data:`Data <#type-data>`_ )
       - | decodes the given data as ABI-encoded (without the methodHash) 
     * - | `Hex <#type-hex>`_ 
       - | `abiEncode <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L940>`_ (
         |       signature:``string``,
         |       args:``any`` [])
       - | encodes the given arguments as ABI-encoded (including the methodHash) 
     * - | ``string``
       - | `createSignature <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L931>`_ (
         |       fields:`ABIField <#type-abifield>`_  [])
       - | create signature 
     * - | `Hex <#type-hex>`_ 
       - | `createSignatureHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L930>`_ (
         |       def:`ABI <#type-abi>`_ )
       - | a Hexcoded String (starting with 0x) 
     * - | ``any``
       - | `decodeEvent <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L932>`_ (
         |       log:`Log <#type-log>`_ ,
         |       d:`ABI <#type-abi>`_ )
       - | decode event 
     * - | `Uint8Array <#type-uint8array>`_ 
       - | `ecSign <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L983>`_ (
         |       pk:`Uint8Array <#type-uint8array>`_  
         | | `Hex <#type-hex>`_ ,
         |       msg:`Uint8Array <#type-uint8array>`_  
         | | `Hex <#type-hex>`_ ,
         |       hashFirst:``boolean``,
         |       adjustV:``boolean``)
       - | create a signature (65 bytes) for the given message and kexy 
     * - | `Uint8Array <#type-uint8array>`_ 
       - | `keccak <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L961>`_ (
         |       data:`Uint8Array <#type-uint8array>`_  
         | | `Data <#type-data>`_ )
       - | calculates the keccack hash for the given data. 
     * - | `Address <#type-address>`_ 
       - | `private2address <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L997>`_ (
         |       pk:`Hex <#type-hex>`_  
         | | `Uint8Array <#type-uint8array>`_ )
       - | generates the public address from the private key. 
     * - | ``string``
       - | `soliditySha3 <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L933>`_ (
         |       args:``any`` [])
       - | solidity sha3 
     * - | `Signature <#type-signature>`_ 
       - | `splitSignature <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L991>`_ (
         |       signature:`Uint8Array <#type-uint8array>`_  
         | | `Hex <#type-hex>`_ ,
         |       message:`Uint8Array <#type-uint8array>`_  
         | | `Hex <#type-hex>`_ ,
         |       hashFirst:``boolean``)
       - | takes raw signature (65 bytes) and splits it into a signature object. 
     * - | `Uint8Array <#type-uint8array>`_ 
       - | `toBuffer <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L973>`_ (
         |       data:`Hex <#type-hex>`_  
         | | `Uint8Array <#type-uint8array>`_  
         | | ``number`` 
         | | ``bigint``,
         |       len:``number``)
       - | converts any value to a Uint8Array.
         | optionally the target length can be specified (in bytes) 
     * - | `Address <#type-address>`_ 
       - | `toChecksumAddress <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L955>`_ (
         |       address:`Address <#type-address>`_ ,
         |       chainId:``number``)
       - | generates a checksum Address for the given address.
         | If the chainId is passed, it will be included accord to EIP 1191 
     * - | `Hex <#type-hex>`_ 
       - | `toHex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L967>`_ (
         |       data:`Hex <#type-hex>`_  
         | | `Uint8Array <#type-uint8array>`_  
         | | ``number`` 
         | | ``bigint``,
         |       len:``number``)
       - | converts any value to a hex string (with prefix 0x).
         | optionally the target length can be specified (in bytes) 

```


### Type ABI


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L476)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``boolean``
       - | `anonymous <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L477>`_
       - | the anonymous  *(optional)* 
     * - | ``boolean``
       - | `constant <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L478>`_
       - | the constant  *(optional)* 
     * - | `ABIField <#type-abifield>`_  []
       - | `inputs <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L482>`_
       - | the inputs  *(optional)* 
     * - | ``string``
       - | `name <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L484>`_
       - | the name  *(optional)* 
     * - | `ABIField <#type-abifield>`_  []
       - | `outputs <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L483>`_
       - | the outputs  *(optional)* 
     * - | ``boolean``
       - | `payable <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L479>`_
       - | the payable  *(optional)* 
     * - | ``'nonpayable'`` 
         | | ``'payable'`` 
         | | ``'view'`` 
         | | ``'pure'``
       - | `stateMutability <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L480>`_
       - | the stateMutability  *(optional)* 
     * - | ``'event'`` 
         | | ``'function'`` 
         | | ``'constructor'`` 
         | | ``'fallback'``
       - | `type <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L485>`_
       - | the type 

```


### Type ABIField


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L471)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``boolean``
       - | `indexed <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L472>`_
       - | the indexed  *(optional)* 
     * - | ``string``
       - | `name <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L473>`_
       - | the name 
     * - | ``string``
       - | `type <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L474>`_
       - | the type 

```


### Type Address


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L453)


a 20 byte Address encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Block


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L576)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Address <#type-address>`_ 
       - | `author <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L596>`_
       - | 20 Bytes - the address of the author of the block (the beneficiary to whom the mining rewards were given) 
     * - | `Quantity <#type-quantity>`_ 
       - | `difficulty <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L600>`_
       - | integer of the difficulty for this block 
     * - | `Data <#type-data>`_ 
       - | `extraData <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L604>`_
       - | the ‘extra data’ field of this block 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasLimit <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L608>`_
       - | the maximum gas allowed in this block 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasUsed <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L610>`_
       - | the total used gas by all transactions in this block 
     * - | `Hash <#type-hash>`_ 
       - | `hash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L580>`_
       - | hash of the block. null when its pending block 
     * - | `Data <#type-data>`_ 
       - | `logsBloom <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L588>`_
       - | 256 Bytes - the bloom filter for the logs of the block. null when its pending block 
     * - | `Address <#type-address>`_ 
       - | `miner <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L598>`_
       - | 20 Bytes - alias of ‘author’ 
     * - | `Data <#type-data>`_ 
       - | `nonce <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L584>`_
       - | 8 bytes hash of the generated proof-of-work. null when its pending block. Missing in case of PoA. 
     * - | `Quantity <#type-quantity>`_ 
       - | `number <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L578>`_
       - | The block number. null when its pending block 
     * - | `Hash <#type-hash>`_ 
       - | `parentHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L582>`_
       - | hash of the parent block 
     * - | `Data <#type-data>`_ 
       - | `receiptsRoot <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L594>`_
       - | 32 Bytes - the root of the receipts trie of the block 
     * - | `Data <#type-data>`_  []
       - | `sealFields <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L618>`_
       - | PoA-Fields 
     * - | `Data <#type-data>`_ 
       - | `sha3Uncles <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L586>`_
       - | SHA3 of the uncles data in the block 
     * - | `Quantity <#type-quantity>`_ 
       - | `size <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L606>`_
       - | integer the size of this block in bytes 
     * - | `Data <#type-data>`_ 
       - | `stateRoot <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L592>`_
       - | 32 Bytes - the root of the final state trie of the block 
     * - | `Quantity <#type-quantity>`_ 
       - | `timestamp <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L612>`_
       - | the unix timestamp for when the block was collated 
     * - | `Quantity <#type-quantity>`_ 
       - | `totalDifficulty <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L602>`_
       - | integer of the total difficulty of the chain until this block 
     * - | ``string`` |  []
       - | `transactions <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L614>`_
       - | Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter 
     * - | `Data <#type-data>`_ 
       - | `transactionsRoot <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L590>`_
       - | 32 Bytes - the root of the transaction trie of the block 
     * - | `Hash <#type-hash>`_  []
       - | `uncles <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L616>`_
       - | Array of uncle hashes 

```


### Type Data


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L457)


data encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Hash


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L449)


a 32 byte Hash encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Log


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L620)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Address <#type-address>`_ 
       - | `address <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L634>`_
       - | 20 Bytes - address from which this log originated. 
     * - | `Hash <#type-hash>`_ 
       - | `blockHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L630>`_
       - | Hash, 32 Bytes - hash of the block where this log was in. null when its pending. null when its pending log. 
     * - | `Quantity <#type-quantity>`_ 
       - | `blockNumber <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L632>`_
       - | the block number where this log was in. null when its pending. null when its pending log. 
     * - | `Data <#type-data>`_ 
       - | `data <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L636>`_
       - | contains the non-indexed arguments of the log. 
     * - | `Quantity <#type-quantity>`_ 
       - | `logIndex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L624>`_
       - | integer of the log index position in the block. null when its pending log. 
     * - | ``boolean``
       - | `removed <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L622>`_
       - | true when the log was removed, due to a chain reorganization. false if its a valid log. 
     * - | `Data <#type-data>`_  []
       - | `topics <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L638>`_
       - | - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.) 
     * - | `Hash <#type-hash>`_ 
       - | `transactionHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L628>`_
       - | Hash, 32 Bytes - hash of the transactions this log was created from. null when its pending log. 
     * - | `Quantity <#type-quantity>`_ 
       - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L626>`_
       - | integer of the transactions index position log was created from. null when its pending log. 

```


### Type LogFilter


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L641)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Address <#type-address>`_ 
       - | `address <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L647>`_
       - | (optional) 20 Bytes - Contract address or a list of addresses from which logs should originate. 
     * - | `BlockType <#type-blocktype>`_ 
       - | `fromBlock <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L643>`_
       - | Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions. 
     * - | `Quantity <#type-quantity>`_ 
       - | `limit <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L651>`_
       - | å(optional) The maximum number of entries to retrieve (latest first). 
     * - | `BlockType <#type-blocktype>`_ 
       - | `toBlock <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L645>`_
       - | Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions. 
     * - | ``string`` | ``string`` [] []
       - | `topics <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L649>`_
       - | (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching. 

```


### Type Signature


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L462)


Signature


```eval_rst
  .. list-table::
     :widths: auto

     * - | `Data <#type-data>`_ 
       - | `message <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L463>`_
       - | the message 
     * - | `Hash <#type-hash>`_ 
       - | `messageHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L464>`_
       - | the messageHash 
     * - | `Hash <#type-hash>`_ 
       - | `r <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L466>`_
       - | the r 
     * - | `Hash <#type-hash>`_ 
       - | `s <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L467>`_
       - | the s 
     * - | `Data <#type-data>`_ 
       - | `signature <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L468>`_
       - | the signature  *(optional)* 
     * - | `Hex <#type-hex>`_ 
       - | `v <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L465>`_
       - | the v 

```


### Type Transaction


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L487)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``any``
       - | `chainId <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L503>`_
       - | optional chain id  *(optional)* 
     * - | ``string``
       - | `data <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L499>`_
       - | 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI. 
     * - | `Address <#type-address>`_ 
       - | `from <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L489>`_
       - | 20 Bytes - The address the transaction is send from. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gas <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L493>`_
       - | Integer of the gas provided for the transaction execution. eth_call consumes zero gas, but this parameter may be needed by some executions. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasPrice <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L495>`_
       - | Integer of the gas price used for each paid gas. 
     * - | `Quantity <#type-quantity>`_ 
       - | `nonce <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L501>`_
       - | nonce 
     * - | `Address <#type-address>`_ 
       - | `to <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L491>`_
       - | (optional when creating new contract) 20 Bytes - The address the transaction is directed to. 
     * - | `Quantity <#type-quantity>`_ 
       - | `value <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L497>`_
       - | Integer of the value sent with this transaction. 

```


### Type TransactionDetail


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L533)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Hash <#type-hash>`_ 
       - | `blockHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L539>`_
       - | 32 Bytes - hash of the block where this transaction was in. null when its pending. 
     * - | `BlockType <#type-blocktype>`_ 
       - | `blockNumber <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L541>`_
       - | block number where this transaction was in. null when its pending. 
     * - | `Quantity <#type-quantity>`_ 
       - | `chainId <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L567>`_
       - | the chain id of the transaction, if any. 
     * - | ``any``
       - | `condition <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L571>`_
       - | (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature) 
     * - | `Address <#type-address>`_ 
       - | `creates <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L569>`_
       - | creates contract address 
     * - | `Address <#type-address>`_ 
       - | `from <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L545>`_
       - | 20 Bytes - address of the sender. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gas <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L553>`_
       - | gas provided by the sender. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasPrice <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L551>`_
       - | gas price provided by the sender in Wei. 
     * - | `Hash <#type-hash>`_ 
       - | `hash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L535>`_
       - | 32 Bytes - hash of the transaction. 
     * - | `Data <#type-data>`_ 
       - | `input <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L555>`_
       - | the data send along with the transaction. 
     * - | `Quantity <#type-quantity>`_ 
       - | `nonce <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L537>`_
       - | the number of transactions made by the sender prior to this one. 
     * - | ``any``
       - | `pk <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L573>`_
       - | optional: the private key to use for signing  *(optional)* 
     * - | `Hash <#type-hash>`_ 
       - | `publicKey <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L565>`_
       - | public key of the signer. 
     * - | `Quantity <#type-quantity>`_ 
       - | `r <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L561>`_
       - | the R field of the signature. 
     * - | `Data <#type-data>`_ 
       - | `raw <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L563>`_
       - | raw transaction data 
     * - | `Quantity <#type-quantity>`_ 
       - | `standardV <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L559>`_
       - | the standardised V field of the signature (0 or 1). 
     * - | `Address <#type-address>`_ 
       - | `to <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L547>`_
       - | 20 Bytes - address of the receiver. null when its a contract creation transaction. 
     * - | `Quantity <#type-quantity>`_ 
       - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L543>`_
       - | integer of the transactions index position in the block. null when its pending. 
     * - | `Quantity <#type-quantity>`_ 
       - | `v <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L557>`_
       - | the standardised V field of the signature. 
     * - | `Quantity <#type-quantity>`_ 
       - | `value <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L549>`_
       - | value transferred in Wei. 

```


### Type TransactionReceipt


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L505)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Hash <#type-hash>`_ 
       - | `blockHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L507>`_
       - | 32 Bytes - hash of the block where this transaction was in. 
     * - | `BlockType <#type-blocktype>`_ 
       - | `blockNumber <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L509>`_
       - | block number where this transaction was in. 
     * - | `Address <#type-address>`_ 
       - | `contractAddress <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L511>`_
       - | 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null. 
     * - | `Quantity <#type-quantity>`_ 
       - | `cumulativeGasUsed <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L513>`_
       - | The total amount of gas used when this transaction was executed in the block. 
     * - | `Address <#type-address>`_ 
       - | `from <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L515>`_
       - | 20 Bytes - The address of the sender. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasUsed <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L519>`_
       - | The amount of gas used by this specific transaction alone. 
     * - | `Log <#type-log>`_  []
       - | `logs <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L521>`_
       - | Array of log objects, which this transaction generated. 
     * - | `Data <#type-data>`_ 
       - | `logsBloom <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L523>`_
       - | 256 Bytes - A bloom filter of logs/events generated by contracts during transaction execution. Used to efficiently rule out transactions without expected logs. 
     * - | `Hash <#type-hash>`_ 
       - | `root <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L525>`_
       - | 32 Bytes - Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork EIP609) 
     * - | `Quantity <#type-quantity>`_ 
       - | `status <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L527>`_
       - | 0x0 indicates transaction failure , 0x1 indicates transaction success. Set for blocks mined after Byzantium hard fork EIP609, null before. 
     * - | `Address <#type-address>`_ 
       - | `to <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L517>`_
       - | 20 Bytes - The address of the receiver. null when it’s a contract creation transaction. 
     * - | `Hash <#type-hash>`_ 
       - | `transactionHash <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L529>`_
       - | 32 Bytes - hash of the transaction. 
     * - | `Quantity <#type-quantity>`_ 
       - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L531>`_
       - | Integer of the transactions index position in the block. 

```


### Type TxRequest


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L654)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``any`` []
       - | `args <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L680>`_
       - | the argument to pass to the method  *(optional)* 
     * - | ``number``
       - | `confirmations <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L686>`_
       - | number of block to wait before confirming  *(optional)* 
     * - | `Data <#type-data>`_ 
       - | `data <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L662>`_
       - | the data to send  *(optional)* 
     * - | `Address <#type-address>`_ 
       - | `from <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L659>`_
       - | address of the account to use  *(optional)* 
     * - | ``number``
       - | `gas <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L665>`_
       - | the gas needed  *(optional)* 
     * - | ``number``
       - | `gasPrice <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L668>`_
       - | the gasPrice used  *(optional)* 
     * - | ``string``
       - | `method <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L677>`_
       - | the ABI of the method to be used  *(optional)* 
     * - | ``number``
       - | `nonce <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L671>`_
       - | the nonce  *(optional)* 
     * - | `Hash <#type-hash>`_ 
       - | `pk <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L683>`_
       - | raw private key in order to sign  *(optional)* 
     * - | `Address <#type-address>`_ 
       - | `to <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L656>`_
       - | contract  *(optional)* 
     * - | `Quantity <#type-quantity>`_ 
       - | `value <https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L674>`_
       - | the value in wei  *(optional)* 

```


### Type Hex


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)


a Hexcoded String (starting with 0x)
 = `string`



### Type BlockType


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L437)


BlockNumber or predefined Block
 = `number` | `'latest'` | `'earliest'` | `'pending'`



### Type Quantity


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L445)


a BigInteger encoded as hex.
 = `number` | [Hex](#type-hex) 



