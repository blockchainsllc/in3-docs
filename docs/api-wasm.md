# API Reference WASM

This page contains a list of all Datastructures and Classes used within the IN3 WASM-Client.
  
## Main Module

 Importing incubed is as easy as 
```ts
import Client from "in3-wasm"
```

 While the In3Client-class is the default import, the following imports can be used: 

   

* [**IN3**](#type-in3) :`class`

* [**SimpleSigner**](#type-simplesigner) :`class`

* [**EthAPI**](#type-ethapi) :`interface`

* [**IN3Config**](#type-in3config) :`interface` - the iguration of the IN3-Client. This can be paritally overriden for every request.

* [**IN3NodeConfig**](#type-in3nodeconfig) :`interface` - a configuration of a in3-server.

* [**IN3NodeWeight**](#type-in3nodeweight) :`interface` - a local weight of a n3-node. (This is used internally to weight the requests)

* [**RPCRequest**](#type-rpcrequest) :`interface` - a JSONRPC-Request with N3-Extension

* [**RPCResponse**](#type-rpcresponse) :`interface` - a JSONRPC-Responset with N3-Extension

* [**Signer**](#type-signer) :`interface`

* [**Utils**](#type-utils) :`interface` - Collection of different util-functions.

* **[anonymous](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L477)** :`boolean` *(optional)*  

* **[constant](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L478)** :`boolean` *(optional)*  

* **[inputs](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L482)** :[`ABIField`](#type-abifield)[] *(optional)*  

* **[name](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L484)** :`string` *(optional)*  

* **[outputs](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L483)** :[`ABIField`](#type-abifield)[] *(optional)*  

* **[payable](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L479)** :`boolean` *(optional)*  

* **[stateMutability](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L480)** :`'nonpayable'`|`'payable'`|`'view'`|`'pure'` *(optional)*  

* **[type](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L485)** :`'event'`|`'function'`|`'constructor'`|`'fallback'` 

* **[indexed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L472)** :`boolean` *(optional)*  

* **[name](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L473)** :`string` 

* **[type](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L474)** :`string` 

* **[Hex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)** :`string` - a Hexcoded String (starting with 0x)

* **[author](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L596)** :[`Address`](#type-address) - 20 Bytes - the address of the author of the block (the beneficiary to whom the mining rewards were given)

* **[difficulty](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L600)** :[`Quantity`](#type-quantity) - integer of the difficulty for this block

* **[extraData](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L604)** :[`Data`](#type-data) - the ‘extra data’ field of this block

* **[gasLimit](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L608)** :[`Quantity`](#type-quantity) - the maximum gas allowed in this block

* **[gasUsed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L610)** :[`Quantity`](#type-quantity) - the total used gas by all transactions in this block

* **[hash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L580)** :[`Hash`](#type-hash) - hash of the block. null when its pending block

* **[logsBloom](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L588)** :[`Data`](#type-data) - 256 Bytes - the bloom filter for the logs of the block. null when its pending block

* **[miner](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L598)** :[`Address`](#type-address) - 20 Bytes - alias of ‘author’

* **[nonce](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L584)** :[`Data`](#type-data) - 8 bytes hash of the generated proof-of-work. null when its pending block. Missing in case of PoA.

* **[number](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L578)** :[`Quantity`](#type-quantity) - The block number. null when its pending block

* **[parentHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L582)** :[`Hash`](#type-hash) - hash of the parent block

* **[receiptsRoot](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L594)** :[`Data`](#type-data) - 32 Bytes - the root of the receipts trie of the block

* **[sealFields](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L618)** :[`Data`](#type-data)[] - PoA-Fields

* **[sha3Uncles](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L586)** :[`Data`](#type-data) - SHA3 of the uncles data in the block

* **[size](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L606)** :[`Quantity`](#type-quantity) - integer the size of this block in bytes

* **[stateRoot](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L592)** :[`Data`](#type-data) - 32 Bytes - the root of the final state trie of the block

* **[timestamp](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L612)** :[`Quantity`](#type-quantity) - the unix timestamp for when the block was collated

* **[totalDifficulty](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L602)** :[`Quantity`](#type-quantity) - integer of the total difficulty of the chain until this block

* **[transactions](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L614)** :`string`|[] - Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter

* **[transactionsRoot](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L590)** :[`Data`](#type-data) - 32 Bytes - the root of the transaction trie of the block

* **[uncles](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L616)** :[`Hash`](#type-hash)[] - Array of uncle hashes

* **[BlockType](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L437)** :`number`|`'latest'`|`'earliest'`|`'pending'` - BlockNumber or predefined Block

* **[Hex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)** :`string` - a Hexcoded String (starting with 0x)

* **[Hex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)** :`string` - a Hexcoded String (starting with 0x)

* **[Hex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)** :`string` - a Hexcoded String (starting with 0x)

* **[address](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L634)** :[`Address`](#type-address) - 20 Bytes - address from which this log originated.

* **[blockHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L630)** :[`Hash`](#type-hash) - Hash, 32 Bytes - hash of the block where this log was in. null when its pending. null when its pending log.

* **[blockNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L632)** :[`Quantity`](#type-quantity) - the block number where this log was in. null when its pending. null when its pending log.

* **[data](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L636)** :[`Data`](#type-data) - contains the non-indexed arguments of the log.

* **[logIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L624)** :[`Quantity`](#type-quantity) - integer of the log index position in the block. null when its pending log.

* **[removed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L622)** :`boolean` - true when the log was removed, due to a chain reorganization. false if its a valid log.

* **[topics](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L638)** :[`Data`](#type-data)[] - - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.)

* **[transactionHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L628)** :[`Hash`](#type-hash) - Hash, 32 Bytes - hash of the transactions this log was created from. null when its pending log.

* **[transactionIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L626)** :[`Quantity`](#type-quantity) - integer of the transactions index position log was created from. null when its pending log.

* **[address](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L647)** :[`Address`](#type-address) - (optional) 20 Bytes - Contract address or a list of addresses from which logs should originate.

* **[fromBlock](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L643)** :[`BlockType`](#type-blocktype) - Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions.

* **[limit](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L651)** :[`Quantity`](#type-quantity) - å(optional) The maximum number of entries to retrieve (latest first).

* **[toBlock](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L645)** :[`BlockType`](#type-blocktype) - Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions.

* **[topics](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L649)** :`string`|`string`[][] - (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching.

* **[Quantity](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L445)** :`number`|[`Hex`](#type-hex) - a BigInteger encoded as hex.

* **[message](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L463)** :[`Data`](#type-data) - data encoded as Hex (starting with 0x)

* **[messageHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L464)** :[`Hash`](#type-hash) - a 32 byte Hash encoded as Hex (starting with 0x)

* **[r](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L466)** :[`Hash`](#type-hash) - a 32 byte Hash encoded as Hex (starting with 0x)

* **[s](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L467)** :[`Hash`](#type-hash) - a 32 byte Hash encoded as Hex (starting with 0x)

* **[signature](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L468)** :[`Data`](#type-data) *(optional)*  - data encoded as Hex (starting with 0x)

* **[v](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L465)** :[`Hex`](#type-hex) - a Hexcoded String (starting with 0x)

* **[chainId](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L503)** :`any` *(optional)*  - optional chain id

* **[data](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L499)** :`string` - 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI.

* **[from](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L489)** :[`Address`](#type-address) - 20 Bytes - The address the transaction is send from.

* **[gas](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L493)** :[`Quantity`](#type-quantity) - Integer of the gas provided for the transaction execution. eth_call consumes zero gas, but this parameter may be needed by some executions.

* **[gasPrice](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L495)** :[`Quantity`](#type-quantity) - Integer of the gas price used for each paid gas.

* **[nonce](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L501)** :[`Quantity`](#type-quantity) - nonce

* **[to](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L491)** :[`Address`](#type-address) - (optional when creating new contract) 20 Bytes - The address the transaction is directed to.

* **[value](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L497)** :[`Quantity`](#type-quantity) - Integer of the value sent with this transaction.

* **[blockHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L539)** :[`Hash`](#type-hash) - 32 Bytes - hash of the block where this transaction was in. null when its pending.

* **[blockNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L541)** :[`BlockType`](#type-blocktype) - block number where this transaction was in. null when its pending.

* **[chainId](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L567)** :[`Quantity`](#type-quantity) - the chain id of the transaction, if any.

* **[condition](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L571)** :`any` - (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature)

* **[creates](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L569)** :[`Address`](#type-address) - creates contract address

* **[from](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L545)** :[`Address`](#type-address) - 20 Bytes - address of the sender.

* **[gas](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L553)** :[`Quantity`](#type-quantity) - gas provided by the sender.

* **[gasPrice](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L551)** :[`Quantity`](#type-quantity) - gas price provided by the sender in Wei.

* **[hash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L535)** :[`Hash`](#type-hash) - 32 Bytes - hash of the transaction.

* **[input](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L555)** :[`Data`](#type-data) - the data send along with the transaction.

* **[nonce](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L537)** :[`Quantity`](#type-quantity) - the number of transactions made by the sender prior to this one.

* **[pk](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L573)** :`any` *(optional)*  - optional: the private key to use for signing

* **[publicKey](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L565)** :[`Hash`](#type-hash) - public key of the signer.

* **[r](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L561)** :[`Quantity`](#type-quantity) - the R field of the signature.

* **[raw](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L563)** :[`Data`](#type-data) - raw transaction data

* **[standardV](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L559)** :[`Quantity`](#type-quantity) - the standardised V field of the signature (0 or 1).

* **[to](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L547)** :[`Address`](#type-address) - 20 Bytes - address of the receiver. null when its a contract creation transaction.

* **[transactionIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L543)** :[`Quantity`](#type-quantity) - integer of the transactions index position in the block. null when its pending.

* **[v](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L557)** :[`Quantity`](#type-quantity) - the standardised V field of the signature.

* **[value](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L549)** :[`Quantity`](#type-quantity) - value transferred in Wei.

* **[blockHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L507)** :[`Hash`](#type-hash) - 32 Bytes - hash of the block where this transaction was in.

* **[blockNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L509)** :[`BlockType`](#type-blocktype) - block number where this transaction was in.

* **[contractAddress](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L511)** :[`Address`](#type-address) - 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null.

* **[cumulativeGasUsed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L513)** :[`Quantity`](#type-quantity) - The total amount of gas used when this transaction was executed in the block.

* **[from](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L515)** :[`Address`](#type-address) - 20 Bytes - The address of the sender.

* **[gasUsed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L519)** :[`Quantity`](#type-quantity) - The amount of gas used by this specific transaction alone.

* **[logs](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L521)** :[`Log`](#type-log)[] - Array of log objects, which this transaction generated.

* **[logsBloom](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L523)** :[`Data`](#type-data) - 256 Bytes - A bloom filter of logs/events generated by contracts during transaction execution. Used to efficiently rule out transactions without expected logs.

* **[root](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L525)** :[`Hash`](#type-hash) - 32 Bytes - Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork EIP609)

* **[status](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L527)** :[`Quantity`](#type-quantity) - 0x0 indicates transaction failure , 0x1 indicates transaction success. Set for blocks mined after Byzantium hard fork EIP609, null before.

* **[to](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L517)** :[`Address`](#type-address) - 20 Bytes - The address of the receiver. null when it’s a contract creation transaction.

* **[transactionHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L529)** :[`Hash`](#type-hash) - 32 Bytes - hash of the transaction.

* **[transactionIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L531)** :[`Quantity`](#type-quantity) - Integer of the transactions index position in the block.

* **[args](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L680)** :`any`[] *(optional)*  - the argument to pass to the method

* **[confirmations](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L686)** :`number` *(optional)*  - number of block to wait before confirming

* **[data](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L662)** :[`Data`](#type-data) *(optional)*  - the data to send

* **[from](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L659)** :[`Address`](#type-address) *(optional)*  - address of the account to use

* **[gas](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L665)** :`number` *(optional)*  - the gas needed

* **[gasPrice](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L668)** :`number` *(optional)*  - the gasPrice used

* **[method](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L677)** :`string` *(optional)*  - the ABI of the method to be used

* **[nonce](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L671)** :`number` *(optional)*  - the nonce

* **[pk](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L683)** :[`Hash`](#type-hash) *(optional)*  - raw private key in order to sign

* **[to](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L656)** :[`Address`](#type-address) *(optional)*  - contract

* **[value](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L674)** :[`Quantity`](#type-quantity) *(optional)*  - the value in wei


## Package in3.d.ts


### Type IN3


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L346)



* **[default](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L431)** :[`IN3`](#type-in3) - supporting both ES6 and UMD usage

* **[util](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L428)** :[`Utils`](#type-utils) - collection of util-functions.

* `static` **[freeAll](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L412)**() :`void` - frees all Incubed instances.

* `static` **[onInit](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L406)**(fn :) :[`Promise<T>`](#type-t) - registers a function to be called as soon as the wasm is ready.
    If it is already initialized it will call it right away.

* `static` **[setStorage](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L395)**(handler :) :`void` - changes the storage handler, which is called to read and write to the cache.

* `static` **[setTransport](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L390)**(fn :) :`void` - changes the transport-function.

* `constructor` **[constructor](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L346)**(config :[`Partial<IN3Config>`](#type-partial)) :[`IN3`](#type-in3) - creates a new client.

* **[eth](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L418)** :[`EthAPI`](#type-ethapi) - eth1 API.

* **[signer](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L382)** :[`Signer`](#type-signer) - the signer, if specified this interface will be used to sign transactions, if not, sending transaction will not be possible.

* **[util](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L423)** :[`Utils`](#type-utils) - collection of util-functions.

* **[free](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L377)**() :`any` - disposes the Client. This must be called in order to free allocated memory!

* **[send](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L365)**(request :[`RPCRequest`](#type-rpcrequest), callback :) :[`Promise<RPCResponse>`](#type-rpcresponse) - sends a raw request.
    if the request is a array the response will be a array as well.
    If the callback is given it will be called with the response, if not a Promise will be returned.
    This function supports callback so it can be used as a Provider for the web3.

* **[sendRPC](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L372)**(method :`string`, params :`any`[]) :`Promise<any>` - sends a RPC-Requests specified by name and params.

* **[setConfig](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L357)**(config :[`Partial<IN3Config>`](#type-partial)) :`void` - sets configuration properties. You can pass a partial object specifieing any of defined properties.


### Type SimpleSigner


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L907)



* `constructor` **[constructor](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L910)**(pks :`any`[]) :[`SimpleSigner`](#type-simplesigner) 

* **[accounts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L908)**

* **[prepareTransaction](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L914)** *(optional)*  - optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig.

* **[sign](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L923)** - signing of any data.
    if hashFirst is true the data should be hashed first, otherwise the data is the hash.

* **[addAccount](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L912)**(pk :[`Hash`](#type-hash)) :`string` 

* **[hasAccount](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L917)**(account :[`Address`](#type-address)) :`Promise<boolean>` - returns true if the account is supported (or unlocked)


### Type EthAPI


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L703)



* **[client](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L704)** :[`IN3`](#type-in3) 

* **[signer](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L705)** :[`Signer`](#type-signer) *(optional)*  

* **[blockNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L710)**() :`Promise<number>` - Returns the number of most recent block. (as number)

* **[call](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L718)**(tx :[`Transaction`](#type-transaction), block :[`BlockType`](#type-blocktype)) :`Promise<string>` - Executes a new message call immediately without creating a transaction on the block chain.

* **[callFn](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L722)**(to :[`Address`](#type-address), method :`string`, args :`any`[]) :`Promise<any>` - Executes a function of a contract, by passing a [method-signature](https://github.com/ethereumjs/ethereumjs-abi/blob/master/README.md#simple-encoding-and-decoding) and the arguments, which will then be ABI-encoded and send as eth_call.

* **[chainId](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L726)**() :`Promise<string>` - Returns the EIP155 chain ID used for transaction signing at the current best block. Null is returned if not available.

* **[constructor](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L706)**(client :[`IN3`](#type-in3)) :`any` 

* **[contractAt](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L864)**(abi :[`ABI`](#type-abi)[], address :[`Address`](#type-address)) : 

* **[decodeEventData](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L904)**(log :[`Log`](#type-log), d :[`ABI`](#type-abi)) :`any` 

* **[estimateGas](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L730)**(tx :[`Transaction`](#type-transaction)) :`Promise<number>` - Makes a call or transaction, which won’t be added to the blockchain and returns the used gas, which can be used for estimating the used gas.

* **[gasPrice](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L714)**() :`Promise<number>` - Returns the current price per gas in wei. (as number)

* **[getBalance](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L734)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype)) :`Promise<bigint>` - Returns the balance of the account of given address in wei (as hex).

* **[getBlockByHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L746)**(hash :[`Hash`](#type-hash), includeTransactions :`boolean`) :[`Promise<Block>`](#type-block) - Returns information about a block by hash.

* **[getBlockByNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L750)**(block :[`BlockType`](#type-blocktype), includeTransactions :`boolean`) :[`Promise<Block>`](#type-block) - Returns information about a block by block number.

* **[getBlockTransactionCountByHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L754)**(block :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of transactions in a block from a block matching the given block hash.

* **[getBlockTransactionCountByNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L758)**(block :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of transactions in a block from a block matching the given block number.

* **[getCode](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L738)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype)) :`Promise<string>` - Returns code at a given address.

* **[getFilterChanges](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L762)**(id :[`Quantity`](#type-quantity)) :`Promise<>` - Polling method for a filter, which returns an array of logs which occurred since last poll.

* **[getFilterLogs](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L766)**(id :[`Quantity`](#type-quantity)) :`Promise<>` - Returns an array of all logs matching filter with given id.

* **[getLogs](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L770)**(filter :[`LogFilter`](#type-logfilter)) :`Promise<>` - Returns an array of all logs matching a given filter object.

* **[getStorageAt](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L742)**(address :[`Address`](#type-address), pos :[`Quantity`](#type-quantity), block :[`BlockType`](#type-blocktype)) :`Promise<string>` - Returns the value from a storage position at a given address.

* **[getTransactionByBlockHashAndIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L774)**(hash :[`Hash`](#type-hash), pos :[`Quantity`](#type-quantity)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns information about a transaction by block hash and transaction index position.

* **[getTransactionByBlockNumberAndIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L778)**(block :[`BlockType`](#type-blocktype), pos :[`Quantity`](#type-quantity)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns information about a transaction by block number and transaction index position.

* **[getTransactionByHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L782)**(hash :[`Hash`](#type-hash)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns the information about a transaction requested by transaction hash.

* **[getTransactionCount](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L786)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype)) :`Promise<number>` - Returns the number of transactions sent from an address. (as number)

* **[getTransactionReceipt](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L791)**(hash :[`Hash`](#type-hash)) :[`Promise<TransactionReceipt>`](#type-transactionreceipt) - Returns the receipt of a transaction by transaction hash.
    Note That the receipt is available even for pending transactions.

* **[getUncleByBlockHashAndIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L796)**(hash :[`Hash`](#type-hash), pos :[`Quantity`](#type-quantity)) :[`Promise<Block>`](#type-block) - Returns information about a uncle of a block by hash and uncle index position.
    Note: An uncle doesn’t contain individual transactions.

* **[getUncleByBlockNumberAndIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L801)**(block :[`BlockType`](#type-blocktype), pos :[`Quantity`](#type-quantity)) :[`Promise<Block>`](#type-block) - Returns information about a uncle of a block number and uncle index position.
    Note: An uncle doesn’t contain individual transactions.

* **[getUncleCountByBlockHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L805)**(hash :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of uncles in a block from a block matching the given block hash.

* **[getUncleCountByBlockNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L809)**(block :[`BlockType`](#type-blocktype)) :`Promise<number>` - Returns the number of uncles in a block from a block matching the given block hash.

* **[hashMessage](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L905)**(data :[`Data`](#type-data)) :[`Hex`](#type-hex) 

* **[newBlockFilter](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L813)**() :`Promise<string>` - Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges.

* **[newFilter](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L826)**(filter :[`LogFilter`](#type-logfilter)) :`Promise<string>` - Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges.

* **[newPendingTransactionFilter](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L832)**() :`Promise<string>` - Creates a filter in the node, to notify when new pending transactions arrive.

* **[protocolVersion](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L840)**() :`Promise<string>` - Returns the current ethereum protocol version.

* **[sendRawTransaction](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L855)**(data :[`Data`](#type-data)) :`Promise<string>` - Creates new message call transaction or a contract creation for signed transactions.

* **[sendTransaction](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L863)**(args :[`TxRequest`](#type-txrequest)) :`Promise<>` - sends a Transaction

* **[sign](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L861)**(account :[`Address`](#type-address), data :[`Data`](#type-data)) :[`Promise<Signature>`](#type-signature) - signs any kind of message using the `\x19Ethereum Signed Message:\n`-prefix

* **[syncing](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L844)**() :`Promise<>` - Returns the current ethereum protocol version.

* **[uninstallFilter](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L836)**(id :[`Quantity`](#type-quantity)) :[`Promise<Quantity>`](#type-quantity) - Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren’t requested with eth_getFilterChanges for a period of time.


### Type IN3Config


the iguration of the IN3-Client. This can be paritally overriden for every request.


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L38)



* **[autoConfig](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L65)** :`boolean` *(optional)*  - if true the config will be adjusted depending on the request

* **[autoUpdateList](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L147)** :`boolean` *(optional)*  - if true the nodelist will be automaticly updated if the lastBlock is newer
    example: true

* **[cacheTimeout](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L42)** :`number` *(optional)*  - number of seconds requests can be cached.

* **[chainId](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L132)** :`string` - servers to filter for the given chain. The chain-id based on EIP-155.
    example: 0x1

* **[chainRegistry](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L137)** :`string` *(optional)*  - main chain-registry contract
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945

* **[finality](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L122)** :`number` *(optional)*  - the number in percent needed in order reach finality (% of signature of the validators)
    example: 50

* **[format](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L56)** :`'json'`|`'jsonRef'`|`'cbor'` *(optional)*  - the format for sending the data to the client. Default is json, but using cbor means using only 30-40% of the payload since it is using binary encoding
    example: json

* **[includeCode](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L79)** :`boolean` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
    example: true

* **[keepIn3](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L51)** :`boolean` *(optional)*  - if true, the in3-section of thr response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.

* **[key](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L61)** :`any` *(optional)*  - the client key to sign requests
    example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7

* **[mainChain](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L142)** :`string` *(optional)*  - main chain-id, where the chain registry is running.
    example: 0x1

* **[maxAttempts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L74)** :`number` *(optional)*  - max number of attempts in case a response is rejected
    example: 10

* **[maxBlockCache](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L89)** :`number` *(optional)*  - number of number of blocks cached  in memory
    example: 100

* **[maxCodeCache](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L84)** :`number` *(optional)*  - number of max bytes used to cache the code in memory
    example: 100000

* **[minDeposit](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L107)** :`number` - min stake of the server. Only nodes owning at least this amount will be chosen.

* **[nodeLimit](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L47)** :`number` *(optional)*  - the limit of nodes to store in the client.
    example: 150

* **[proof](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L98)** :`'none'`|`'standard'`|`'full'` *(optional)*  - if true the nodes should send a proof of the response
    example: true

* **[replaceLatestBlock](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L112)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[requestCount](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L117)** :`number` - the number of request send when getting a first answer
    example: 3

* **[retryWithoutProof](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L69)** :`boolean` *(optional)*  - if true the the request may be handled without proof in case of an error. (use with care!)

* **[rpc](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L151)** :`string` *(optional)*  - url of one or more rpc-endpoints to use. (list can be comma seperated)

* **[servers](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L155)** *(optional)*  - the nodelist per chain

* **[signatureCount](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L103)** :`number` *(optional)*  - number of signatures requested
    example: 2

* **[timeout](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L127)** :`number` *(optional)*  - specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
    example: 3000

* **[verifiedHashes](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L93)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.


### Type IN3NodeConfig


a configuration of a in3-server.


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L210)



* **[address](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L220)** :`string` - the address of the node, which is the public address it iis signing with.
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[capacity](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L245)** :`number` *(optional)*  - the capacity of the node.
    example: 100

* **[chainIds](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L235)** :`string`[] - the list of supported chains
    example: 0x1

* **[deposit](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L240)** :`number` - the deposit of the node in wei
    example: 12350000

* **[index](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L215)** :`number` *(optional)*  - the index within the contract
    example: 13

* **[props](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L250)** :`number` *(optional)*  - the properties of the node.
    example: 3

* **[registerTime](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L255)** :`number` *(optional)*  - the UNIX-timestamp when the node was registered
    example: 1563279168

* **[timeout](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L225)** :`number` *(optional)*  - the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
    example: 3600

* **[unregisterTime](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L260)** :`number` *(optional)*  - the UNIX-timestamp when the node is allowed to be deregister
    example: 1563279168

* **[url](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L230)** :`string` - the endpoint to post to
    example: https://in3.slock.it


### Type IN3NodeWeight


a local weight of a n3-node. (This is used internally to weight the requests)


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L265)



* **[avgResponseTime](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L280)** :`number` *(optional)*  - average time of a response in ms
    example: 240

* **[blacklistedUntil](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L294)** :`number` *(optional)*  - blacklisted because of failed requests until the timestamp
    example: 1529074639623

* **[lastRequest](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L289)** :`number` *(optional)*  - timestamp of the last request in ms
    example: 1529074632623

* **[pricePerRequest](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L284)** :`number` *(optional)*  - last price

* **[responseCount](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L275)** :`number` *(optional)*  - number of uses.
    example: 147

* **[weight](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L270)** :`number` *(optional)*  - factor the weight this noe (default 1.0)
    example: 0.5


### Type RPCRequest


a JSONRPC-Request with N3-Extension


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L300)



* **[id](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L314)** :`number`|`string` *(optional)*  - the identifier of the request
    example: 2

* **[jsonrpc](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L304)** :`'2.0'` - the version

* **[method](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L309)** :`string` - the method to call
    example: eth_getBalance

* **[params](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L319)** :`any`[] *(optional)*  - the params
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest


### Type RPCResponse


a JSONRPC-Responset with N3-Extension


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L324)



* **[error](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L337)** :`string` *(optional)*  - in case of an error this needs to be set

* **[id](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L333)** :`string`|`number` - the id matching the request
    example: 2

* **[jsonrpc](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L328)** :`'2.0'` - the version

* **[result](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L342)** :`any` *(optional)*  - the params
    example: 0xa35bc


### Type Signer


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L689)



* **[prepareTransaction](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L691)** *(optional)*  - optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig.

* **[sign](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L700)** - signing of any data.
    if hashFirst is true the data should be hashed first, otherwise the data is the hash.

* **[hasAccount](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L694)**(account :[`Address`](#type-address)) :`Promise<boolean>` - returns true if the account is supported (or unlocked)


### Type Utils


Collection of different util-functions.


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L929)



* **[abiDecode](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L947)**(signature :`string`, data :[`Data`](#type-data)) :`any`[] - decodes the given data as ABI-encoded (without the methodHash)

* **[abiEncode](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L940)**(signature :`string`, args :`any`[]) :[`Hex`](#type-hex) - encodes the given arguments as ABI-encoded (including the methodHash)

* **[createSignature](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L931)**(fields :[`ABIField`](#type-abifield)[]) :`string` 

* **[createSignatureHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L930)**(def :[`ABI`](#type-abi)) :[`Hex`](#type-hex) 

* **[decodeEvent](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L932)**(log :[`Log`](#type-log), d :[`ABI`](#type-abi)) :`any` 

* **[ecSign](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L983)**(pk :[`Uint8Array`](#type-uint8array)|[`Hex`](#type-hex), msg :[`Uint8Array`](#type-uint8array)|[`Hex`](#type-hex), hashFirst :`boolean`, adjustV :`boolean`) :[`Uint8Array`](#type-uint8array) - create a signature (65 bytes) for the given message and kexy

* **[keccak](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L961)**(data :[`Uint8Array`](#type-uint8array)|[`Data`](#type-data)) :[`Uint8Array`](#type-uint8array) - calculates the keccack hash for the given data.

* **[private2address](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L997)**(pk :[`Hex`](#type-hex)|[`Uint8Array`](#type-uint8array)) :[`Address`](#type-address) - generates the public address from the private key.

* **[soliditySha3](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L933)**(args :`any`[]) :`string` 

* **[splitSignature](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L991)**(signature :[`Uint8Array`](#type-uint8array)|[`Hex`](#type-hex), message :[`Uint8Array`](#type-uint8array)|[`Hex`](#type-hex), hashFirst :`boolean`) :[`Signature`](#type-signature) - takes raw signature (65 bytes) and splits it into a signature object.

* **[toBuffer](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L973)**(data :[`Hex`](#type-hex)|[`Uint8Array`](#type-uint8array)|`number`|`bigint`, len :`number`) :[`Uint8Array`](#type-uint8array) - converts any value to a Uint8Array.
    optionally the target length can be specified (in bytes)

* **[toChecksumAddress](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L955)**(address :[`Address`](#type-address), chainId :`number`) :[`Address`](#type-address) - generates a checksum Address for the given address.
    If the chainId is passed, it will be included accord to EIP 1191

* **[toHex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L967)**(data :[`Hex`](#type-hex)|[`Uint8Array`](#type-uint8array)|`number`|`bigint`, len :`number`) :[`Hex`](#type-hex) - converts any value to a hex string (with prefix 0x).
    optionally the target length can be specified (in bytes)


### Type ABIField


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L471)



* **[indexed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L472)** :`boolean` *(optional)*  

* **[name](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L473)** :`string` 

* **[type](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L474)** :`string` 


### Type Address


a 20 byte Address encoded as Hex (starting with 0x)


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L453)



* **[Hex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)** :`string` - a Hexcoded String (starting with 0x)


### Type Quantity


a BigInteger encoded as hex.


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L445)



* **[Quantity](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L445)** :`number`|[`Hex`](#type-hex) - a BigInteger encoded as hex.


### Type Data


data encoded as Hex (starting with 0x)


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L457)



* **[Hex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)** :`string` - a Hexcoded String (starting with 0x)


### Type Hash


a 32 byte Hash encoded as Hex (starting with 0x)


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L449)



* **[Hex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)** :`string` - a Hexcoded String (starting with 0x)


### Type BlockType


BlockNumber or predefined Block


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L437)



* **[BlockType](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L437)** :`number`|`'latest'`|`'earliest'`|`'pending'` - BlockNumber or predefined Block


### Type Hex


a Hexcoded String (starting with 0x)


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)



* **[Hex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L441)** :`string` - a Hexcoded String (starting with 0x)


### Type Log


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L620)



* **[address](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L634)** :[`Address`](#type-address) - 20 Bytes - address from which this log originated.

* **[blockHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L630)** :[`Hash`](#type-hash) - Hash, 32 Bytes - hash of the block where this log was in. null when its pending. null when its pending log.

* **[blockNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L632)** :[`Quantity`](#type-quantity) - the block number where this log was in. null when its pending. null when its pending log.

* **[data](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L636)** :[`Data`](#type-data) - contains the non-indexed arguments of the log.

* **[logIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L624)** :[`Quantity`](#type-quantity) - integer of the log index position in the block. null when its pending log.

* **[removed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L622)** :`boolean` - true when the log was removed, due to a chain reorganization. false if its a valid log.

* **[topics](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L638)** :[`Data`](#type-data)[] - - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.)

* **[transactionHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L628)** :[`Hash`](#type-hash) - Hash, 32 Bytes - hash of the transactions this log was created from. null when its pending log.

* **[transactionIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L626)** :[`Quantity`](#type-quantity) - integer of the transactions index position log was created from. null when its pending log.


### Type Transaction


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L487)



* **[chainId](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L503)** :`any` *(optional)*  - optional chain id

* **[data](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L499)** :`string` - 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI.

* **[from](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L489)** :[`Address`](#type-address) - 20 Bytes - The address the transaction is send from.

* **[gas](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L493)** :[`Quantity`](#type-quantity) - Integer of the gas provided for the transaction execution. eth_call consumes zero gas, but this parameter may be needed by some executions.

* **[gasPrice](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L495)** :[`Quantity`](#type-quantity) - Integer of the gas price used for each paid gas.

* **[nonce](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L501)** :[`Quantity`](#type-quantity) - nonce

* **[to](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L491)** :[`Address`](#type-address) - (optional when creating new contract) 20 Bytes - The address the transaction is directed to.

* **[value](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L497)** :[`Quantity`](#type-quantity) - Integer of the value sent with this transaction.


### Type ABI


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L476)



* **[anonymous](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L477)** :`boolean` *(optional)*  

* **[constant](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L478)** :`boolean` *(optional)*  

* **[inputs](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L482)** :[`ABIField`](#type-abifield)[] *(optional)*  

* **[name](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L484)** :`string` *(optional)*  

* **[outputs](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L483)** :[`ABIField`](#type-abifield)[] *(optional)*  

* **[payable](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L479)** :`boolean` *(optional)*  

* **[stateMutability](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L480)** :`'nonpayable'`|`'payable'`|`'view'`|`'pure'` *(optional)*  

* **[type](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L485)** :`'event'`|`'function'`|`'constructor'`|`'fallback'` 


### Type Block


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L576)



* **[author](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L596)** :[`Address`](#type-address) - 20 Bytes - the address of the author of the block (the beneficiary to whom the mining rewards were given)

* **[difficulty](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L600)** :[`Quantity`](#type-quantity) - integer of the difficulty for this block

* **[extraData](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L604)** :[`Data`](#type-data) - the ‘extra data’ field of this block

* **[gasLimit](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L608)** :[`Quantity`](#type-quantity) - the maximum gas allowed in this block

* **[gasUsed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L610)** :[`Quantity`](#type-quantity) - the total used gas by all transactions in this block

* **[hash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L580)** :[`Hash`](#type-hash) - hash of the block. null when its pending block

* **[logsBloom](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L588)** :[`Data`](#type-data) - 256 Bytes - the bloom filter for the logs of the block. null when its pending block

* **[miner](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L598)** :[`Address`](#type-address) - 20 Bytes - alias of ‘author’

* **[nonce](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L584)** :[`Data`](#type-data) - 8 bytes hash of the generated proof-of-work. null when its pending block. Missing in case of PoA.

* **[number](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L578)** :[`Quantity`](#type-quantity) - The block number. null when its pending block

* **[parentHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L582)** :[`Hash`](#type-hash) - hash of the parent block

* **[receiptsRoot](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L594)** :[`Data`](#type-data) - 32 Bytes - the root of the receipts trie of the block

* **[sealFields](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L618)** :[`Data`](#type-data)[] - PoA-Fields

* **[sha3Uncles](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L586)** :[`Data`](#type-data) - SHA3 of the uncles data in the block

* **[size](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L606)** :[`Quantity`](#type-quantity) - integer the size of this block in bytes

* **[stateRoot](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L592)** :[`Data`](#type-data) - 32 Bytes - the root of the final state trie of the block

* **[timestamp](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L612)** :[`Quantity`](#type-quantity) - the unix timestamp for when the block was collated

* **[totalDifficulty](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L602)** :[`Quantity`](#type-quantity) - integer of the total difficulty of the chain until this block

* **[transactions](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L614)** :`string`|[] - Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter

* **[transactionsRoot](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L590)** :[`Data`](#type-data) - 32 Bytes - the root of the transaction trie of the block

* **[uncles](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L616)** :[`Hash`](#type-hash)[] - Array of uncle hashes


### Type LogFilter


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L641)



* **[address](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L647)** :[`Address`](#type-address) - (optional) 20 Bytes - Contract address or a list of addresses from which logs should originate.

* **[fromBlock](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L643)** :[`BlockType`](#type-blocktype) - Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions.

* **[limit](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L651)** :[`Quantity`](#type-quantity) - å(optional) The maximum number of entries to retrieve (latest first).

* **[toBlock](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L645)** :[`BlockType`](#type-blocktype) - Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions.

* **[topics](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L649)** :`string`|`string`[][] - (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching.


### Type TransactionDetail


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L533)



* **[blockHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L539)** :[`Hash`](#type-hash) - 32 Bytes - hash of the block where this transaction was in. null when its pending.

* **[blockNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L541)** :[`BlockType`](#type-blocktype) - block number where this transaction was in. null when its pending.

* **[chainId](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L567)** :[`Quantity`](#type-quantity) - the chain id of the transaction, if any.

* **[condition](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L571)** :`any` - (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature)

* **[creates](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L569)** :[`Address`](#type-address) - creates contract address

* **[from](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L545)** :[`Address`](#type-address) - 20 Bytes - address of the sender.

* **[gas](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L553)** :[`Quantity`](#type-quantity) - gas provided by the sender.

* **[gasPrice](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L551)** :[`Quantity`](#type-quantity) - gas price provided by the sender in Wei.

* **[hash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L535)** :[`Hash`](#type-hash) - 32 Bytes - hash of the transaction.

* **[input](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L555)** :[`Data`](#type-data) - the data send along with the transaction.

* **[nonce](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L537)** :[`Quantity`](#type-quantity) - the number of transactions made by the sender prior to this one.

* **[pk](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L573)** :`any` *(optional)*  - optional: the private key to use for signing

* **[publicKey](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L565)** :[`Hash`](#type-hash) - public key of the signer.

* **[r](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L561)** :[`Quantity`](#type-quantity) - the R field of the signature.

* **[raw](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L563)** :[`Data`](#type-data) - raw transaction data

* **[standardV](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L559)** :[`Quantity`](#type-quantity) - the standardised V field of the signature (0 or 1).

* **[to](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L547)** :[`Address`](#type-address) - 20 Bytes - address of the receiver. null when its a contract creation transaction.

* **[transactionIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L543)** :[`Quantity`](#type-quantity) - integer of the transactions index position in the block. null when its pending.

* **[v](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L557)** :[`Quantity`](#type-quantity) - the standardised V field of the signature.

* **[value](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L549)** :[`Quantity`](#type-quantity) - value transferred in Wei.


### Type TransactionReceipt


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L505)



* **[blockHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L507)** :[`Hash`](#type-hash) - 32 Bytes - hash of the block where this transaction was in.

* **[blockNumber](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L509)** :[`BlockType`](#type-blocktype) - block number where this transaction was in.

* **[contractAddress](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L511)** :[`Address`](#type-address) - 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null.

* **[cumulativeGasUsed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L513)** :[`Quantity`](#type-quantity) - The total amount of gas used when this transaction was executed in the block.

* **[from](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L515)** :[`Address`](#type-address) - 20 Bytes - The address of the sender.

* **[gasUsed](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L519)** :[`Quantity`](#type-quantity) - The amount of gas used by this specific transaction alone.

* **[logs](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L521)** :[`Log`](#type-log)[] - Array of log objects, which this transaction generated.

* **[logsBloom](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L523)** :[`Data`](#type-data) - 256 Bytes - A bloom filter of logs/events generated by contracts during transaction execution. Used to efficiently rule out transactions without expected logs.

* **[root](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L525)** :[`Hash`](#type-hash) - 32 Bytes - Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork EIP609)

* **[status](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L527)** :[`Quantity`](#type-quantity) - 0x0 indicates transaction failure , 0x1 indicates transaction success. Set for blocks mined after Byzantium hard fork EIP609, null before.

* **[to](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L517)** :[`Address`](#type-address) - 20 Bytes - The address of the receiver. null when it’s a contract creation transaction.

* **[transactionHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L529)** :[`Hash`](#type-hash) - 32 Bytes - hash of the transaction.

* **[transactionIndex](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L531)** :[`Quantity`](#type-quantity) - Integer of the transactions index position in the block.


### Type TxRequest


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L654)



* **[args](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L680)** :`any`[] *(optional)*  - the argument to pass to the method

* **[confirmations](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L686)** :`number` *(optional)*  - number of block to wait before confirming

* **[data](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L662)** :[`Data`](#type-data) *(optional)*  - the data to send

* **[from](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L659)** :[`Address`](#type-address) *(optional)*  - address of the account to use

* **[gas](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L665)** :`number` *(optional)*  - the gas needed

* **[gasPrice](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L668)** :`number` *(optional)*  - the gasPrice used

* **[method](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L677)** :`string` *(optional)*  - the ABI of the method to be used

* **[nonce](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L671)** :`number` *(optional)*  - the nonce

* **[pk](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L683)** :[`Hash`](#type-hash) *(optional)*  - raw private key in order to sign

* **[to](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L656)** :[`Address`](#type-address) *(optional)*  - contract

* **[value](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L674)** :[`Quantity`](#type-quantity) *(optional)*  - the value in wei


### Type Signature


Signature


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L462)



* **[message](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L463)** :[`Data`](#type-data) - data encoded as Hex (starting with 0x)

* **[messageHash](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L464)** :[`Hash`](#type-hash) - a 32 byte Hash encoded as Hex (starting with 0x)

* **[r](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L466)** :[`Hash`](#type-hash) - a 32 byte Hash encoded as Hex (starting with 0x)

* **[s](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L467)** :[`Hash`](#type-hash) - a 32 byte Hash encoded as Hex (starting with 0x)

* **[signature](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L468)** :[`Data`](#type-data) *(optional)*  - data encoded as Hex (starting with 0x)

* **[v](https://github.com/slockit/in3-c/blob/master/src/bindings/wasm/in3.d.ts#L465)** :[`Hex`](#type-hex) - a Hexcoded String (starting with 0x)


