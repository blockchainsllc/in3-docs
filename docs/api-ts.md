# API Reference TS

This page contains a list of all Datastructures and Classes used within the TypeScript IN3 Client.
 ## Examples

This is a collection of different incubed-examples.

### using Web3

Since incubed works with on a JSON-RPC-Level it can easily be used as Provider for Web3:

```js
// import in3-Module
import In3Client from 'in3'
import * as web3 from 'web3'

// use the In3Client as Http-Provider
const web3 = new Web3(new In3Client({
    proof         : 'standard',
    signatureCount: 1,
    requestCount  : 2,
    chainId       : 'mainnet'
}).createWeb3Provider())

// use the web3
const block = await web.eth.getBlockByNumber('latest')
...

```

### using Incubed API


Incubed includes a light API, allowinng not only to use all RPC-Methods in a typesafe way, but also to sign transactions and call funnctions of a contract without the web3-library.

For more details see the [API-Doc](api-ts.html#type-client)


```ts


// import in3-Module
import In3Client from 'in3'

// use the In3Client
const in3 = new In3Client({
    proof         : 'standard',
    signatureCount: 1,
    requestCount  : 2,
    chainId       : 'mainnet'
})

// use the api to call a funnction..
const myBalance = await in3.eth.callFn(myTokenContract, 'balanceOf(address):uint', myAccount)

// ot to send a transaction..
const receipt = await in3.eth.sendTransaction({ 
  to           : myTokenContract, 
  method       : 'transfer(address,uint256)',
  args         : [target,amount],
  confirmations: 2,
  pk           : myKey
})

...
```

### Reading event with incubed


```js

// import in3-Module
import In3Client from 'in3'

// use the In3Client
const in3 = new In3Client({
    proof         : 'standard',
    signatureCount: 1,
    requestCount  : 2,
    chainId       : 'mainnet'
})

// use the ABI-String of the smart contract
abi = [{"anonymous":false,"inputs":[{"indexed":false,"name":"name","type":"string"},{"indexed":true,"name":"label","type":"bytes32"},{"indexed":true,"name":"owner","type":"address"},{"indexed":false,"name":"cost","type":"uint256"},{"indexed":false,"name":"expires","type":"uint256"}],"name":"NameRegistered","type":"event"}]

// create a contract-object for a given address
const contract = in3.eth.contractAt(abi, '0xF0AD5cAd05e10572EfcEB849f6Ff0c68f9700455') // ENS contract.

// read all events starting from a specified block until the latest
const logs = await c.events.NameRegistered.getLogs({fromBlock:8022948})) 

// print out the properties of the event.
for (const ev of logs) 
  console.log(`${ev.owner} registered ${ev.name} for ${ev.cost} wei until ${new Date(ev.expires.toNumber()*1000).toString()}`)

...
``` 
## Main Module

 Importing incubed is as easy as 
```ts
import Client,{util} from "in3"
```

 While the In3Client-class is the default import, the following imports can be used: 

`   

* [**AccountProof**](#type-accountproof) : `interface`  - the Proof-for a single Account

* [**AuraValidatoryProof**](#type-auravalidatoryproof) : `interface`  - a Object holding proofs for validator logs. The key is the blockNumber as hex

* [**BlockData**](#type-blockdata) : `interface`  - Block as returned by eth_getBlockByNumber

* [**ChainSpec**](#type-chainspec) : `interface`  - describes the chainspecific consensus params

* [**IN3Client**](#type-client) : `class`  - Client for N3.

* [**IN3Config**](#type-in3config) : `interface`  - the iguration of the IN3-Client. This can be paritally overriden for every request.

* [**IN3NodeConfig**](#type-in3nodeconfig) : `interface`  - a configuration of a in3-server.

* [**IN3NodeWeight**](#type-in3nodeweight) : `interface`  - a local weight of a n3-node. (This is used internally to weight the requests)

* [**IN3RPCConfig**](#type-in3rpcconfig) : `interface`  - the configuration for the rpc-handler

* [**IN3RPCHandlerConfig**](#type-in3rpchandlerconfig) : `interface`  - the configuration for the rpc-handler

* [**IN3RPCRequestConfig**](#type-in3rpcrequestconfig) : `interface`  - additional config for a IN3 RPC-Request

* [**IN3ResponseConfig**](#type-in3responseconfig) : `interface`  - additional data returned from a IN3 Server

* [**LogData**](#type-logdata) : `interface`  - LogData as part of the TransactionReceipt

* [**LogProof**](#type-logproof) : `interface`  - a Object holding proofs for event logs. The key is the blockNumber as hex

* [**Proof**](#type-proof) : `interface`  - the Proof-data as part of the in3-section

* [**RPCRequest**](#type-rpcrequest) : `interface`  - a JSONRPC-Request with N3-Extension

* [**RPCResponse**](#type-rpcresponse) : `interface`  - a JSONRPC-Responset with N3-Extension

* [**ReceiptData**](#type-receiptdata) : `interface`  - TransactionReceipt as returned by eth_getTransactionReceipt

* [**ServerList**](#type-serverlist) : `interface`  - a List of nodes

* [**Signature**](#type-signature) : `interface`  - Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.

* [**TransactionData**](#type-transactiondata) : `interface`  - Transaction as returned by eth_getTransactionByHash

* [**Transport**](#type-transport) : `interface`  - A Transport-object responsible to transport the message to the handler.

* [**AxiosTransport**](#type-axiostransport) : `class`  - Default Transport impl sending http-requests.

* [**EthAPI**](#type-ethapi) : `class` 

* **[cbor](https://github.com/slockit/in3/blob/master/src/index.ts#L33)**

    * **[createRefs](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L86)**(val :[`T`](#type-t), cache :`string`[] =  []) :[`T`](#type-t) 

    * **[decodeRequests](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L30)**(request :[`Buffer`](#type-buffer)) :[`RPCRequest`](#type-rpcrequest)[] 

    * **[decodeResponses](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L44)**(responses :[`Buffer`](#type-buffer)) :[`RPCResponse`](#type-rpcresponse)[] 

    * **[encodeRequests](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L26)**(requests :[`RPCRequest`](#type-rpcrequest)[]) :[`Buffer`](#type-buffer) - turn

    * **[encodeResponses](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L41)**(responses :[`RPCResponse`](#type-rpcresponse)[]) :[`Buffer`](#type-buffer) 

    * **[resolveRefs](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L107)**(val :[`T`](#type-t), cache :`string`[] =  []) :[`T`](#type-t) 

* **[chainAliases](https://github.com/slockit/in3/blob/master/src/index.ts#L82)**

    * **[goerli](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L700)** :`string` 

    * **[ipfs](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L700)** :`string` 

    * **[kovan](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L700)** :`string` 

    * **[main](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L700)** :`string` 

    * **[mainnet](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L700)** :`string` 

    * **[tobalaba](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L700)** :`string` 

* **[chainData](https://github.com/slockit/in3/blob/master/src/index.ts#L49)**

    * **[callContract](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L27)**(client :[`Client`](#type-client), contract :`string`, chainId :`string`, signature :`string`, args :`any`[], config :[`IN3Config`](#type-in3config)) :`Promise<any>` 

    * **[getChainData](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L36)**(client :[`Client`](#type-client), chainId :`string`, config :[`IN3Config`](#type-in3config)) :`Promise<>` 

* **[createRandomIndexes](https://github.com/slockit/in3/blob/master/src/client/serverList.ts#L56)**(len :`number`, limit :`number`, seed :[`Buffer`](#type-buffer), result :`number`[] =  []) :`number`[] - helper function creating deterministic random indexes used for limited nodelists

* **[header](https://github.com/slockit/in3/blob/master/src/index.ts#L39)**

    * [**AuthSpec**](#type-authspec) :`interface` - Authority specification for proof of authority chains

    * **[checkBlockSignatures](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L27)**(blockHeaders :`string`|[`Buffer`](#type-buffer)|[`Block`](#type-block)|[`BlockData`](#type-blockdata)[], getChainSpec :) :`Promise<number>` - verify a Blockheader and returns the percentage of finality

    * **[getChainSpec](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L230)**(b :[`Block`](#type-block), ctx :[`ChainContext`](#type-chaincontext)) :[`Promise<AuthSpec>`](#type-authspec) 

    * **[getSigner](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L76)**(data :[`Block`](#type-block)) :[`Buffer`](#type-buffer) 

* **[serialize](https://github.com/slockit/in3/blob/master/src/index.ts#L36)**

    * [**Block**](#type-block) :`class` - encodes and decodes the blockheader

    * [**AccountData**](#type-accountdata) :`interface` - Account-Object

    * [**BlockData**](#type-blockdata) :`interface` - Block as returned by eth_getBlockByNumber

    * [**LogData**](#type-logdata) :`interface` - LogData as part of the TransactionReceipt

    * [**ReceiptData**](#type-receiptdata) :`interface` - TransactionReceipt as returned by eth_getTransactionReceipt

    * [**TransactionData**](#type-transactiondata) :`interface` - Transaction as returned by eth_getTransactionByHash

    * **[Account](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L33)** :[`Buffer`](#type-buffer)[] - Buffer[] of the Account

    * **[BlockHeader](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L27)** :[`Buffer`](#type-buffer)[] - Buffer[] of the header

    * **[Receipt](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L36)** : - Buffer[] of the Receipt

    * **[Transaction](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L30)** :[`Buffer`](#type-buffer)[] - Buffer[] of the transaction

    * **[rlp](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L25)** - RLP-functions

    * **[address](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L145)**(val :`any`) :`any` - converts it to a Buffer with 20 bytes length

    * **[blockFromHex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L313)**(hex :`string`) :[`Block`](#type-block) - converts a hexstring to a block-object

    * **[blockToHex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L308)**(block :`any`) :`string` - converts blockdata to a hexstring

    * **[bytes](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L143)**(val :`any`) :`any` - converts it to a Buffer

    * **[bytes256](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L137)**(val :`any`) :`any` - converts it to a Buffer with 256 bytes length

    * **[bytes32](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L139)**(val :`any`) :`any` - converts it to a Buffer with 32 bytes length

    * **[bytes8](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L141)**(val :`any`) :`any` - converts it to a Buffer with 8 bytes length

    * **[createTx](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L280)**(transaction :`any`) :`any` - creates a Transaction-object from the rpc-transaction-data

    * **[hash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L131)**(val :[`Block`](#type-block)|[`Transaction`](#type-transaction)|[`Receipt`](#type-receipt)|[`Account`](#type-account)|[`Buffer`](#type-buffer)) :[`Buffer`](#type-buffer) - returns the hash of the object

    * **[serialize](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L128)**(val :[`Block`](#type-block)|[`Transaction`](#type-transaction)|[`Receipt`](#type-receipt)|[`Account`](#type-account)) :[`Buffer`](#type-buffer) - serialize the data

    * **[toAccount](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L191)**(account :[`AccountData`](#type-accountdata)) :[`Buffer`](#type-buffer)[] 

    * **[toBlockHeader](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L152)**(block :[`BlockData`](#type-blockdata)) :[`Buffer`](#type-buffer)[] - create a Buffer[] from RPC-Response

    * **[toReceipt](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L200)**(r :[`ReceiptData`](#type-receiptdata)) :`Object` - create a Buffer[] from RPC-Response

    * **[toTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L177)**(tx :[`TransactionData`](#type-transactiondata)) :[`Buffer`](#type-buffer)[] - create a Buffer[] from RPC-Response

    * **[uint](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L147)**(val :`any`) :`any` - converts it to a Buffer with a variable length. 0 = length 0

    * **[uint64](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L149)**(val :`any`) :`any` 

* **[storage](https://github.com/slockit/in3/blob/master/src/index.ts#L42)**

    * **[getStorageArrayKey](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L28)**(pos :`number`, arrayIndex :`number`, structSize :`number` = 1, structPos :`number` = 0) :`any` - calc the storrage array key

    * **[getStorageMapKey](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L40)**(pos :`number`, key :`string`, structPos :`number` = 0) :`any` - calcs the storage Map key.

    * **[getStorageValue](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L88)**(rpc :`string`, contract :`string`, pos :`number`, type :`'address'`|`'bytes32'`|`'bytes16'`|`'bytes4'`|`'int'`|`'string'`, keyOrIndex :`number`|`string`, structSize :`number`, structPos :`number`) :`Promise<any>` - get a storage value from the server

    * **[getStringValue](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L50)**(data :[`Buffer`](#type-buffer), storageKey :[`Buffer`](#type-buffer)) :`string`| - creates a string from storage.

    * **[getStringValueFromList](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L69)**(values :[`Buffer`](#type-buffer)[], len :`number`) :`string` - concats the storage values to a string.

    * **[toBN](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L76)**(val :`any`) :`any` - converts any value to BN

* **[transport](https://github.com/slockit/in3/blob/master/src/index.ts#L45)**

    * [**AxiosTransport**](#type-axiostransport) :`class` - Default Transport impl sending http-requests.

    * [**Transport**](#type-transport) :`interface` - A Transport-object responsible to transport the message to the handler.

* **[typeDefs](https://github.com/slockit/in3/blob/master/src/index.ts#L80)**

    * **[AccountProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[AuraValidatoryProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[ChainSpec](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[IN3Config](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[IN3NodeConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[IN3NodeWeight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[IN3RPCConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[IN3RPCHandlerConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[IN3RPCRequestConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[IN3ResponseConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[LogProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[Proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[RPCRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[RPCResponse](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[ServerList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


    * **[Signature](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** : `Object`  


* **[util](https://github.com/slockit/in3/blob/master/src/index.ts#L28)**

    * **[checkForError](https://github.com/slockit/in3/blob/master/src/util/util.ts#L58)**(res :[`T`](#type-t)) :[`T`](#type-t) - check a RPC-Response for errors and rejects the promise if found

    * **[getAddress](https://github.com/slockit/in3/blob/master/src/util/util.ts#L173)**(pk :`string`) :`string` - returns a address from a private key

    * **[padEnd](https://github.com/slockit/in3/blob/master/src/util/util.ts#L212)**(val :`string`, minLength :`number`, fill :`string` = " ") :`string` - padEnd for legacy

    * **[padStart](https://github.com/slockit/in3/blob/master/src/util/util.ts#L205)**(val :`string`, minLength :`number`, fill :`string` = " ") :`string` - padStart for legacy

    * **[promisify](https://github.com/slockit/in3/blob/master/src/util/util.ts#L36)**(self :`any`, fn :`any`, args :`any`[]) :`Promise<any>` - simple promisy-function

    * **[toBN](https://github.com/slockit/in3/blob/master/src/util/util.ts#L67)**(val :`any`) :`any` - convert to BigNumber

    * **[toBuffer](https://github.com/slockit/in3/blob/master/src/util/util.ts#L129)**(val :`any`, len :`number` =  -1) :`any` - converts any value as Buffer
         if len === 0 it will return an empty Buffer if the value is 0 or '0x00', since this is the way rlpencode works wit 0-values.

    * **[toHex](https://github.com/slockit/in3/blob/master/src/util/util.ts#L78)**(val :`any`, bytes :`number`) :`string` - converts any value as hex-string

    * **[toMinHex](https://github.com/slockit/in3/blob/master/src/util/util.ts#L179)**(key :`string`|[`Buffer`](#type-buffer)|`number`) :`string` - removes all leading 0 in the hexstring

    * **[toNumber](https://github.com/slockit/in3/blob/master/src/util/util.ts#L101)**(val :`any`) :`number` - converts to a js-number

    * **[toSimpleHex](https://github.com/slockit/in3/blob/master/src/util/util.ts#L162)**(val :`string`) :`string` - removes all leading 0 in a hex-string

    * **[toUtf8](https://github.com/slockit/in3/blob/master/src/util/util.ts#L47)**(val :`any`) :`string` 

* **[validate](https://github.com/slockit/in3/blob/master/src/util/validate.ts#L55)**(ob :`any`, def :`any`) :`void` 


## Package client


### Type Client


Client for N3.


Source: [client/Client.ts](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L54)



* **[defaultMaxListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L9)** :`number` 

* `static` **[listenerCount](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L8)**(emitter :[`EventEmitter`](#type-eventemitter), event :`string`|`symbol`) :`number` 

* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L65)**(config :[`Partial<IN3Config>`](#type-partial) =  {}, transport :[`Transport`](#type-transport)) :[`Client`](#type-client) - creates a new Client.

* **[defConfig](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L61)** :[`IN3Config`](#type-in3config) - the iguration of the IN3-Client. This can be paritally overriden for every request.

* **[eth](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L57)** :[`EthAPI`](#type-ethapi) 

* **[ipfs](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L58)** :[`IpfsAPI`](#type-ipfsapi) - simple API for IPFS

*  **config()** 

* **[addListener](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L11)**(event :`string`|`symbol`, listener :) :`this` 

* **[call](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L219)**(method :`string`, params :`any`, chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<any>` - sends a simply RPC-Request

* **[clearStats](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L251)**() :`void` - clears all stats and weights, like blocklisted nodes

* **[createWeb3Provider](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L112)**() :`any` 

* **[emit](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L23)**(event :`string`|`symbol`, args :`any`[]) :`boolean` 

* **[eventNames](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L24)**() :[`Array<>`](#type-array) 

* **[getChainContext](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L119)**(chainId :`string`) :[`ChainContext`](#type-chaincontext) 

* **[getMaxListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L20)**() :`number` 

* **[listenerCount](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L25)**(type :`string`|`symbol`) :`number` 

* **[listeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L21)**(event :`string`|`symbol`) :[`Function`](#type-function)[] 

* **[off](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L17)**(event :`string`|`symbol`, listener :) :`this` 

* **[on](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L12)**(event :`string`|`symbol`, listener :) :`this` 

* **[once](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L13)**(event :`string`|`symbol`, listener :) :`this` 

* **[prependListener](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L14)**(event :`string`|`symbol`, listener :) :`this` 

* **[prependOnceListener](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L15)**(event :`string`|`symbol`, listener :) :`this` 

* **[rawListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L22)**(event :`string`|`symbol`) :[`Function`](#type-function)[] 

* **[removeAllListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L18)**(event :`string`|`symbol`) :`this` 

* **[removeListener](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L16)**(event :`string`|`symbol`, listener :) :`this` 

* **[send](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L231)**(request :[`RPCRequest`](#type-rpcrequest)[]|[`RPCRequest`](#type-rpcrequest), callback :, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<>` - sends one or a multiple requests.
    if the request is a array the response will be a array as well.
    If the callback is given it will be called with the response, if not a Promise will be returned.
    This function supports callback so it can be used as a Provider for the web3.

* **[sendRPC](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L208)**(method :`string`, params :`any`[] =  [], chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :[`Promise<RPCResponse>`](#type-rpcresponse) - sends a simply RPC-Request

* **[setMaxListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L19)**(n :`number`) :`this` 

* **[updateNodeList](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L142)**(chainId :`string`, conf :[`Partial<IN3Config>`](#type-partial), retryCount :`number` = 5) :`Promise<void>` - fetches the nodeList from the servers.


### Type ChainContext


Context for a specific chain including cache and chainSpecs.


Source: [client/ChainContext.ts](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L27)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L33)**(client :[`Client`](#type-client), chainId :`string`, chainSpec :[`ChainSpec`](#type-chainspec)[]) :[`ChainContext`](#type-chaincontext) 

* **[chainId](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L31)** :`string` 

* **[chainSpec](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L29)** :[`ChainSpec`](#type-chainspec)[] 

* **[client](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L28)** :[`Client`](#type-client) - Client for N3.

* **[genericCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L33)**

* **[lastValidatorChange](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L32)** :`number` 

* **[module](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L30)** :[`Module`](#type-module) 

* **[clearCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L115)**(prefix :`string`) :`void` 

* **[getChainSpec](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L68)**(block :`number`) :[`ChainSpec`](#type-chainspec) - returns the chainspec for th given block number

* **[getFromCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L105)**(key :`string`) :`string` 

* **[handleIntern](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L61)**(request :[`RPCRequest`](#type-rpcrequest)) :[`Promise<RPCResponse>`](#type-rpcresponse) - this function is calleds before the server is asked.
    If it returns a promise than the request is handled internally otherwise the server will handle the response.
    this function should be overriden by modules that want to handle calls internally

* **[initCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L73)**() :`void` 

* **[putInCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L109)**(key :`string`, value :`string`) :`void` 

* **[updateCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L99)**() :`void` 


### Type Module


Source: [client/modules.ts](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L7)



* **[name](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L8)** :`string` 

* **[createChainContext](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L10)**(client :[`Client`](#type-client), chainId :`string`, spec :[`ChainSpec`](#type-chainspec)[]) :[`ChainContext`](#type-chaincontext) 

* **[verifyProof](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L12)**(request :[`RPCRequest`](#type-rpcrequest), response :[`RPCResponse`](#type-rpcresponse), allowWithoutProof :`boolean`, ctx :[`ChainContext`](#type-chaincontext)) :`Promise<boolean>` - general verification-function which handles it according to its given type.



## Package modules/eth


### Type BlockData


Block as returned by eth_getBlockByNumber


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L39)



* **[coinbase](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L44)** :`string` *(optional)*  

* **[difficulty](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L50)** :`string`|`number` 

* **[extraData](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L55)** :`string` 

* **[gasLimit](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L52)** :`string`|`number` 

* **[gasUsed](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L53)** :`string`|`number` 

* **[hash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L40)** :`string` 

* **[logsBloom](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L49)** :`string` 

* **[miner](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L43)** :`string` 

* **[mixHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L57)** :`string` *(optional)*  

* **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L58)** :`string`|`number` *(optional)*  

* **[number](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L51)** :`string`|`number` 

* **[parentHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L41)** :`string` 

* **[receiptRoot](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L48)** :`string` *(optional)*  

* **[receiptsRoot](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L47)** :`string` 

* **[sealFields](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L56)** :`string`[] *(optional)*  

* **[sha3Uncles](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L42)** :`string` 

* **[stateRoot](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L45)** :`string` 

* **[timestamp](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L54)** :`string`|`number` 

* **[transactions](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L59)** :`any`[] *(optional)*  

* **[transactionsRoot](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L46)** :`string` 

* **[uncles](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L60)** :`string`[] *(optional)*  


### Type LogData


LogData as part of the TransactionReceipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L99)



* **[address](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L107)** :`string` 

* **[blockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L105)** :`string` 

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L106)** :`string` 

* **[data](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L108)** :`string` 

* **[logIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L101)** :`string` 

* **[removed](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L100)** :`boolean` 

* **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L109)** :`string`[] 

* **[transactionHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L104)** :`string` 

* **[transactionIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L103)** :`string` 

* **[transactionLogIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L102)** :`string` 


### Type ReceiptData


TransactionReceipt as returned by eth_getTransactionReceipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L113)



* **[blockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L117)** :`string` *(optional)*  

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L116)** :`string`|`number` *(optional)*  

* **[cumulativeGasUsed](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L120)** :`string`|`number` *(optional)*  

* **[gasUsed](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L121)** :`string`|`number` *(optional)*  

* **[logs](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L123)** :[`LogData`](#type-logdata)[] 

* **[logsBloom](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L122)** :`string` *(optional)*  

* **[root](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L119)** :`string` *(optional)*  

* **[status](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L118)** :`string`|`boolean` *(optional)*  

* **[transactionHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L114)** :`string` *(optional)*  

* **[transactionIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L115)** :`number` *(optional)*  


### Type TransactionData


Transaction as returned by eth_getTransactionByHash


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L64)



* **[blockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L66)** :`string` *(optional)*  

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L67)** :`number`|`string` *(optional)*  

* **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L68)** :`number`|`string` *(optional)*  

* **[condition](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L69)** :`string` *(optional)*  

* **[creates](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L70)** :`string` *(optional)*  

* **[data](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L76)** :`string` *(optional)*  

* **[from](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L71)** :`string` *(optional)*  

* **[gas](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L72)** :`number`|`string` *(optional)*  

* **[gasLimit](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L73)** :`number`|`string` *(optional)*  

* **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L74)** :`number`|`string` *(optional)*  

* **[hash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L65)** :`string` 

* **[input](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L75)** :`string` 

* **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L77)** :`number`|`string` 

* **[publicKey](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L78)** :`string` *(optional)*  

* **[r](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L83)** :`string` *(optional)*  

* **[raw](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L79)** :`string` *(optional)*  

* **[s](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L84)** :`string` *(optional)*  

* **[standardV](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L80)** :`string` *(optional)*  

* **[to](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L81)** :`string` 

* **[transactionIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L82)** :`number` 

* **[v](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L85)** :`string` *(optional)*  

* **[value](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L86)** :`number`|`string` 


### Type EthAPI


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L257)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L259)**(client :[`Client`](#type-client)) :[`EthAPI`](#type-ethapi) 

* **[client](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L258)** :[`Client`](#type-client) - Client for N3.

* **[signer](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L259)** :[`Signer`](#type-signer) *(optional)*  

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L274)**() :`Promise<number>` - Returns the number of most recent block. (as number)

* **[call](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L287)**(tx :[`Transaction`](#type-transaction), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Executes a new message call immediately without creating a transaction on the block chain.

* **[callFn](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L294)**(to :[`Address`](#type-address), method :`string`, args :`any`[]) :`Promise<any>` - Executes a function of a contract, by passing a [method-signature](https://github.com/ethereumjs/ethereumjs-abi/blob/master/README.md#simple-encoding-and-decoding) and the arguments, which will then be ABI-encoded and send as eth_call.

* **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L302)**() :`Promise<string>` - Returns the EIP155 chain ID used for transaction signing at the current best block. Null is returned if not available.

* **[contractAt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L594)**(abi :[`ABI`](#type-abi)[], address :[`Address`](#type-address)) : 

* **[decodeEventData](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L675)**(log :[`Log`](#type-log), d :[`ABI`](#type-abi)) :`any` 

* **[estimateGas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L309)**(tx :[`Transaction`](#type-transaction)) :`Promise<number>` - Makes a call or transaction, which won’t be added to the blockchain and returns the used gas, which can be used for estimating the used gas.

* **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L280)**() :`Promise<number>` - Returns the current price per gas in wei. (as number)

* **[getBalance](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L316)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :[`Promise<BN>`](#type-bn) - Returns the balance of the account of given address in wei (as hex).

* **[getBlockByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L339)**(hash :[`Hash`](#type-hash), includeTransactions :`boolean` = false) :[`Promise<Block>`](#type-block) - Returns information about a block by hash.

* **[getBlockByNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L346)**(block :[`BlockType`](#type-blocktype) = "latest", includeTransactions :`boolean` = false) :[`Promise<Block>`](#type-block) - Returns information about a block by block number.

* **[getBlockTransactionCountByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L354)**(block :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of transactions in a block from a block matching the given block hash.

* **[getBlockTransactionCountByNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L362)**(block :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of transactions in a block from a block matching the given block number.

* **[getCode](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L323)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Returns code at a given address.

* **[getFilterChanges](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L369)**(id :[`Quantity`](#type-quantity)) :`Promise<>` - Polling method for a filter, which returns an array of logs which occurred since last poll.

* **[getFilterLogs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L376)**(id :[`Quantity`](#type-quantity)) :`Promise<>` - Returns an array of all logs matching filter with given id.

* **[getLogs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L383)**(filter :[`LogFilter`](#type-logfilter)) :`Promise<>` - Returns an array of all logs matching a given filter object.

* **[getStorageAt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L331)**(address :[`Address`](#type-address), pos :[`Quantity`](#type-quantity), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Returns the value from a storage position at a given address.

* **[getTransactionByBlockHashAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L396)**(hash :[`Hash`](#type-hash), pos :[`Quantity`](#type-quantity)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns information about a transaction by block hash and transaction index position.

* **[getTransactionByBlockNumberAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L404)**(block :[`BlockType`](#type-blocktype), pos :[`Quantity`](#type-quantity)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns information about a transaction by block number and transaction index position.

* **[getTransactionByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L411)**(hash :[`Hash`](#type-hash)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns the information about a transaction requested by transaction hash.

* **[getTransactionCount](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L418)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<number>` - Returns the number of transactions sent from an address. (as number)

* **[getTransactionReceipt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L426)**(hash :[`Hash`](#type-hash)) :[`Promise<TransactionReceipt>`](#type-transactionreceipt) - Returns the receipt of a transaction by transaction hash.
    Note That the receipt is available even for pending transactions.

* **[getUncleByBlockHashAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L438)**(hash :[`Hash`](#type-hash), pos :[`Quantity`](#type-quantity)) :[`Promise<Block>`](#type-block) - Returns information about a uncle of a block by hash and uncle index position.
    Note: An uncle doesn’t contain individual transactions.

* **[getUncleByBlockNumberAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L447)**(block :[`BlockType`](#type-blocktype), pos :[`Quantity`](#type-quantity)) :[`Promise<Block>`](#type-block) - Returns information about a uncle of a block number and uncle index position.
    Note: An uncle doesn’t contain individual transactions.

* **[getUncleCountByBlockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L454)**(hash :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of uncles in a block from a block matching the given block hash.

* **[getUncleCountByBlockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L461)**(block :[`BlockType`](#type-blocktype)) :`Promise<number>` - Returns the number of uncles in a block from a block matching the given block hash.

* **[hashMessage](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L678)**(data :[`Data`](#type-data)|[`Buffer`](#type-buffer)) :[`Buffer`](#type-buffer) 

* **[newBlockFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L469)**() :`Promise<string>` - Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges.

* **[newFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L486)**(filter :[`LogFilter`](#type-logfilter)) :`Promise<string>` - Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges.

* **[newPendingTransactionFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L495)**() :`Promise<string>` - Creates a filter in the node, to notify when new pending transactions arrive.

* **[protocolVersion](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L510)**() :`Promise<string>` - Returns the current ethereum protocol version.

* **[sendRawTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L539)**(data :[`Data`](#type-data)) :`Promise<string>` - Creates new message call transaction or a contract creation for signed transactions.

* **[sendTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L566)**(args :[`TxRequest`](#type-txrequest)) :`Promise<>` - sends a Transaction

* **[sign](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L548)**(account :[`Address`](#type-address), data :[`Data`](#type-data)) :[`Promise<Signature>`](#type-signature) - signs any kind of message using the `\x19Ethereum Signed Message:\n`-prefix

* **[syncing](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L517)**() :`Promise<>` - Returns the current ethereum protocol version.

* **[uninstallFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L503)**(id :[`Quantity`](#type-quantity)) :[`Promise<Quantity>`](#type-quantity) - Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren’t requested with eth_getFilterChanges for a period of time.


### Type AuthSpec


Authority specification for proof of authority chains


Source: [modules/eth/header.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L13)



* **[authorities](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L15)** :[`Buffer`](#type-buffer)[] - List of validator addresses storead as an buffer array

* **[proposer](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L19)** :[`Buffer`](#type-buffer) - proposer of the block this authspec belongs

* **[spec](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L17)** :[`ChainSpec`](#type-chainspec) - chain specification


### Type Block


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L132)



* **[Block](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L132)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[sealFields](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L174)** :[`Data`](#type-data)[] - PoA-Fields

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[transactions](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L170)** :`string`|[] - Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[uncles](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L172)** :[`Hash`](#type-hash)[] - Array of uncle hashes


### Type AccountData


Account-Object


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L90)



* **[balance](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L92)** :`string` 

* **[code](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L95)** :`string` *(optional)*  

* **[codeHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L94)** :`string` 

* **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L91)** :`string` 

* **[storageHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L93)** :`string` 


### Type Transaction


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L43)



* **[Transaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L43)**

    * **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L59)** :`any` *(optional)*  - optional chain id

    * **[data](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L55)** :`string` - 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 


### Type Receipt


Buffer[] of the Receipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L36)



* **[Receipt](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L36)** : - Buffer[] of the Receipt


### Type Account


Buffer[] of the Account


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L33)



* **[Account](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L33)** :[`Buffer`](#type-buffer)[] - Buffer[] of the Account


### Type Signer


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L245)



* **[prepareTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L247)** *(optional)*  - optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig.

* **[sign](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L253)** - signing of any data.

* **[hasAccount](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L250)**(account :[`Address`](#type-address)) :`Promise<boolean>` - returns true if the account is supported (or unlocked)


### Type BlockType


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)



* **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|`'latest'`|`'earliest'`|`'pending'` 


### Type Address


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L15)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 


### Type ABI


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L32)



* **[ABI](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L32)**

    * **[anonymous](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L33)** :`boolean` *(optional)*  

    * **[constant](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L34)** :`boolean` *(optional)*  

    * **[inputs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L38)** :[`ABIField`](#type-abifield)[] *(optional)*  

    * **[name](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L40)** :`string` *(optional)*  

    * **[outputs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L39)** :[`ABIField`](#type-abifield)[] *(optional)*  

    * **[payable](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L35)** :`boolean` *(optional)*  

    * **[stateMutability](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L36)** :`'nonpayable'`|`'payable'`|`'view'`|`'pure'` *(optional)*  

    * **[type](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L41)** :`'event'`|`'function'`|`'constructor'`|`'fallback'` 


### Type Log


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L176)



* **[Log](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L176)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[removed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L178)** :`boolean` - true when the log was removed, due to a chain reorganization. false if its a valid log.

    * **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L194)** :[`Data`](#type-data)[] - - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.)

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 


### Type Hash


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L14)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 


### Type Quantity


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)



* **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 


### Type LogFilter


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L197)



* **[LogFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L197)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L205)** :`string`|`string`[][] - (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching.


### Type TransactionDetail


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L89)



* **[TransactionDetail](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L89)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[condition](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L127)** :`any` - (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature)

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[pk](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L129)** :`any` *(optional)*  - optional: the private key to use for signing

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 


### Type TransactionReceipt


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L61)



* **[TransactionReceipt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L61)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[logs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L77)** :[`Log`](#type-log)[] - Array of log objects, which this transaction generated.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 


### Type Data


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L16)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 


### Type TxRequest


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L210)



* **[TxRequest](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L210)**

    * **[args](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L236)** :`any`[] *(optional)*  - the argument to pass to the method

    * **[confirmations](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L242)** :`number` *(optional)*  - number of block to wait before confirming

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[gas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L221)** :`number` *(optional)*  - the gas needed

    * **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L224)** :`number` *(optional)*  - the gasPrice used

    * **[method](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L233)** :`string` *(optional)*  - the ABI of the method to be used

    * **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L227)** :`number` *(optional)*  - the nonce

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)** :`number`|[`Hex`](#type-hex) 


### Type Hex


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)** :`string` 


### Type ABIField


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L27)



* **[ABIField](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L27)**

    * **[indexed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L28)** :`boolean` *(optional)*  

    * **[name](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L29)** :`string` 

    * **[type](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L30)** :`string` 



## Package modules/ipfs


### Type IpfsAPI


simple API for IPFS


Source: [modules/ipfs/api.ts](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L6)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L7)**(_client :[`Client`](#type-client)) :[`IpfsAPI`](#type-ipfsapi) 

* **[client](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L7)** :[`Client`](#type-client) - Client for N3.

* **[get](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L19)**(hash :`string`, resultEncoding :`string`) :[`Promise<Buffer>`](#type-buffer) - retrieves the conent for a hash from IPFS.

* **[put](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L30)**(data :[`Buffer`](#type-buffer), dataEncoding :`string`) :`Promise<string>` - stores the data on ipfs and returns the IPFS-Hash.



## Package types


### Type AccountProof


the Proof-for a single Account


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L6)



* **[accountProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L10)** :`string`[] - the serialized merle-noodes beginning with the root-node

* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L14)** :`string` - the address of this account

* **[balance](https://github.com/slockit/in3/blob/master/src/types/types.ts#L18)** :`string` - the balance of this account as hex

* **[code](https://github.com/slockit/in3/blob/master/src/types/types.ts#L26)** :`string` *(optional)*  - the code of this account as hex ( if required)

* **[codeHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L22)** :`string` - the codeHash of this account as hex

* **[nonce](https://github.com/slockit/in3/blob/master/src/types/types.ts#L30)** :`string` - the nonce of this account as hex

* **[storageHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L34)** :`string` - the storageHash of this account as hex

* **[storageProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L38)** :[] - proof for requested storage-data


### Type AuraValidatoryProof


a Object holding proofs for validator logs. The key is the blockNumber as hex


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L56)



* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L65)** :`string` - the serialized blockheader
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3/blob/master/src/types/types.ts#L78)** :`any`[] *(optional)*  - the serialized blockheader as hex, required in case of finality asked
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L60)** :`number` - the transaction log index

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L73)** :`string`[] - the merkleProof

* **[txIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L69)** :`number` - the transactionIndex within the block


### Type ChainSpec


describes the chainspecific consensus params


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L83)



* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L87)** :`number` *(optional)*  - the blocknumnber when this configuration should apply

* **[bypassFinality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L109)** :`number` *(optional)*  - Bypass finality check for transition to contract based Aura Engines
    example: bypassFinality = 10960502 -> will skip the finality check and add the list at block 10960502

* **[contract](https://github.com/slockit/in3/blob/master/src/types/types.ts#L99)** :`string` *(optional)*  - The validator contract at the block

* **[engine](https://github.com/slockit/in3/blob/master/src/types/types.ts#L91)** :`'ethHash'`|`'authorityRound'`|`'clique'` *(optional)*  - the engine type (like Ethhash, authorityRound, ... )

* **[list](https://github.com/slockit/in3/blob/master/src/types/types.ts#L95)** :`string`[] *(optional)*  - The list of validators at the particular block

* **[requiresFinality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L104)** :`boolean` *(optional)*  - indicates whether the transition requires a finality check
    example: true


### Type IN3Config


the iguration of the IN3-Client. This can be paritally overriden for every request.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L114)



* **[autoConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L141)** :`boolean` *(optional)*  - if true the config will be adjusted depending on the request

* **[autoUpdateList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L223)** :`boolean` *(optional)*  - if true the nodelist will be automaticly updated if the lastBlock is newer
    example: true

* **[cacheStorage](https://github.com/slockit/in3/blob/master/src/types/types.ts#L227)** :`any` *(optional)*  - a cache handler offering 2 functions ( setItem(string,string), getItem(string) )

* **[cacheTimeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L118)** :`number` *(optional)*  - number of seconds requests can be cached.

* **[chainId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L208)** :`string` - servers to filter for the given chain. The chain-id based on EIP-155.
    example: 0x1

* **[chainRegistry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L213)** :`string` *(optional)*  - main chain-registry contract
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945

* **[finality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L198)** :`number` *(optional)*  - the number in percent needed in order reach finality (% of signature of the validators)
    example: 50

* **[format](https://github.com/slockit/in3/blob/master/src/types/types.ts#L132)** :`'json'`|`'jsonRef'`|`'cbor'` *(optional)*  - the format for sending the data to the client. Default is json, but using cbor means using only 30-40% of the payload since it is using binary encoding
    example: json

* **[includeCode](https://github.com/slockit/in3/blob/master/src/types/types.ts#L155)** :`boolean` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
    example: true

* **[keepIn3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L127)** :`boolean` *(optional)*  - if true, the in3-section of thr response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.

* **[key](https://github.com/slockit/in3/blob/master/src/types/types.ts#L137)** :`any` *(optional)*  - the client key to sign requests
    example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7

* **[loggerUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L231)** :`string` *(optional)*  - a url of RES-Endpoint, the client will log all errors to. The client will post to this endpoint JSON like { id?, level, message, meta? }

* **[mainChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L218)** :`string` *(optional)*  - main chain-id, where the chain registry is running.
    example: 0x1

* **[maxAttempts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L150)** :`number` *(optional)*  - max number of attempts in case a response is rejected
    example: 10

* **[maxBlockCache](https://github.com/slockit/in3/blob/master/src/types/types.ts#L165)** :`number` *(optional)*  - number of number of blocks cached  in memory
    example: 100

* **[maxCodeCache](https://github.com/slockit/in3/blob/master/src/types/types.ts#L160)** :`number` *(optional)*  - number of max bytes used to cache the code in memory
    example: 100000

* **[minDeposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L183)** :`number` - min stake of the server. Only nodes owning at least this amount will be chosen.

* **[nodeLimit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L123)** :`number` *(optional)*  - the limit of nodes to store in the client.
    example: 150

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L174)** :`'none'`|`'standard'`|`'full'` *(optional)*  - if true the nodes should send a proof of the response
    example: true

* **[replaceLatestBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L188)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[requestCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L193)** :`number` - the number of request send when getting a first answer
    example: 3

* **[retryWithoutProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L145)** :`boolean` *(optional)*  - if true the the request may be handled without proof in case of an error. (use with care!)

* **[rpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L235)** :`string` *(optional)*  - url of one or more rpc-endpoints to use. (list can be comma seperated)

* **[servers](https://github.com/slockit/in3/blob/master/src/types/types.ts#L239)** *(optional)*  - the nodelist per chain

* **[signatureCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L179)** :`number` *(optional)*  - number of signatures requested
    example: 2

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L203)** :`number` *(optional)*  - specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
    example: 3000

* **[verifiedHashes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L169)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.


### Type IN3NodeConfig


a configuration of a in3-server.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L298)



* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L308)** :`string` - the address of the node, which is the public address it iis signing with.
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[capacity](https://github.com/slockit/in3/blob/master/src/types/types.ts#L333)** :`number` *(optional)*  - the capacity of the node.
    example: 100

* **[chainIds](https://github.com/slockit/in3/blob/master/src/types/types.ts#L323)** :`string`[] - the list of supported chains
    example: 0x1

* **[deposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L328)** :`number` - the deposit of the node in wei
    example: 12350000

* **[index](https://github.com/slockit/in3/blob/master/src/types/types.ts#L303)** :`number` *(optional)*  - the index within the contract
    example: 13

* **[props](https://github.com/slockit/in3/blob/master/src/types/types.ts#L338)** :`number` *(optional)*  - the properties of the node.
    example: 3

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L313)** :`number` *(optional)*  - the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
    example: 3600

* **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L318)** :`string` - the endpoint to post to
    example: https://in3.slock.it


### Type IN3NodeWeight


a local weight of a n3-node. (This is used internally to weight the requests)


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L343)



* **[avgResponseTime](https://github.com/slockit/in3/blob/master/src/types/types.ts#L358)** :`number` *(optional)*  - average time of a response in ms
    example: 240

* **[blacklistedUntil](https://github.com/slockit/in3/blob/master/src/types/types.ts#L372)** :`number` *(optional)*  - blacklisted because of failed requests until the timestamp
    example: 1529074639623

* **[lastRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L367)** :`number` *(optional)*  - timestamp of the last request in ms
    example: 1529074632623

* **[pricePerRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L362)** :`number` *(optional)*  - last price

* **[responseCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L353)** :`number` *(optional)*  - number of uses.
    example: 147

* **[weight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L348)** :`number` *(optional)*  - factor the weight this noe (default 1.0)
    example: 0.5


### Type IN3RPCConfig


the configuration for the rpc-handler


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L377)



* **[chains](https://github.com/slockit/in3/blob/master/src/types/types.ts#L470)** *(optional)*  - a definition of the Handler per chain

* **[db](https://github.com/slockit/in3/blob/master/src/types/types.ts#L390)** *(optional)* 

    * **[database](https://github.com/slockit/in3/blob/master/src/types/types.ts#L410)** :`string` *(optional)*  - name of the database

    * **[host](https://github.com/slockit/in3/blob/master/src/types/types.ts#L402)** :`string` *(optional)*  - db-host (default = localhost)

    * **[password](https://github.com/slockit/in3/blob/master/src/types/types.ts#L398)** :`string` *(optional)*  - password for db-access

    * **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L406)** :`number` *(optional)*  - the database port

    * **[user](https://github.com/slockit/in3/blob/master/src/types/types.ts#L394)** :`string` *(optional)*  - username for the db

* **[defaultChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L385)** :`string` *(optional)*  - the default chainId in case the request does not contain one.

* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L381)** :`string` *(optional)*  - a identifier used in logfiles as also for reading the config from the database

* **[logging](https://github.com/slockit/in3/blob/master/src/types/types.ts#L437)** *(optional)*  - logger config

    * **[colors](https://github.com/slockit/in3/blob/master/src/types/types.ts#L449)** :`boolean` *(optional)*  - if true colors will be used

    * **[file](https://github.com/slockit/in3/blob/master/src/types/types.ts#L441)** :`string` *(optional)*  - the path to the logile

    * **[host](https://github.com/slockit/in3/blob/master/src/types/types.ts#L465)** :`string` *(optional)*  - the host for custom logging

    * **[level](https://github.com/slockit/in3/blob/master/src/types/types.ts#L445)** :`string` *(optional)*  - Loglevel

    * **[name](https://github.com/slockit/in3/blob/master/src/types/types.ts#L453)** :`string` *(optional)*  - the name of the provider

    * **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L461)** :`number` *(optional)*  - the port for custom logging

    * **[type](https://github.com/slockit/in3/blob/master/src/types/types.ts#L457)** :`string` *(optional)*  - the module of the provider

* **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L389)** :`number` *(optional)*  - the listeneing port for the server

* **[profile](https://github.com/slockit/in3/blob/master/src/types/types.ts#L412)** *(optional)* 

    * **[comment](https://github.com/slockit/in3/blob/master/src/types/types.ts#L428)** :`string` *(optional)*  - comments for the node

    * **[icon](https://github.com/slockit/in3/blob/master/src/types/types.ts#L416)** :`string` *(optional)*  - url to a icon or logo of company offering this node

    * **[name](https://github.com/slockit/in3/blob/master/src/types/types.ts#L424)** :`string` *(optional)*  - name of the node or company

    * **[noStats](https://github.com/slockit/in3/blob/master/src/types/types.ts#L432)** :`boolean` *(optional)*  - if active the stats will not be shown (default:false)

    * **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L420)** :`string` *(optional)*  - url of the website of the company


### Type IN3RPCHandlerConfig


the configuration for the rpc-handler


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L477)



* **[autoRegistry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L542)** *(optional)* 

    * **[capabilities](https://github.com/slockit/in3/blob/master/src/types/types.ts#L559)** *(optional)* 

        * **[multiChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L567)** :`boolean` *(optional)*  - if true, this node is able to deliver multiple chains

        * **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L563)** :`boolean` *(optional)*  - if true, this node is able to deliver proofs

    * **[capacity](https://github.com/slockit/in3/blob/master/src/types/types.ts#L554)** :`number` *(optional)*  - max number of parallel requests

    * **[deposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L550)** :`number` - the deposit you want ot store

    * **[depositUnit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L558)** :`'ether'`|`'finney'`|`'szabo'`|`'wei'` *(optional)*  - unit of the deposit value

    * **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L546)** :`string` - the public url to reach this node

* **[clientKeys](https://github.com/slockit/in3/blob/master/src/types/types.ts#L497)** :`string` *(optional)*  - a comma sepearted list of client keys to use for simulating clients for the watchdog

* **[freeScore](https://github.com/slockit/in3/blob/master/src/types/types.ts#L505)** :`number` *(optional)*  - the score for requests without a valid signature

* **[handler](https://github.com/slockit/in3/blob/master/src/types/types.ts#L481)** :`'eth'`|`'ipfs'`|`'btc'` *(optional)*  - the impl used to handle the calls

* **[ipfsUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L485)** :`string` *(optional)*  - the url of the ipfs-client

* **[maxThreads](https://github.com/slockit/in3/blob/master/src/types/types.ts#L513)** :`number` *(optional)*  - the maximal number of threads ofr running parallel processes

* **[minBlockHeight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L509)** :`number` *(optional)*  - the minimal blockheight in order to sign

* **[persistentFile](https://github.com/slockit/in3/blob/master/src/types/types.ts#L517)** :`string` *(optional)*  - the filename of the file keeping track of the last handled blocknumber

* **[privateKey](https://github.com/slockit/in3/blob/master/src/types/types.ts#L529)** :`string` - the private key used to sign blockhashes. this can be either a 0x-prefixed string with the raw private key or the path to a key-file.

* **[privateKeyPassphrase](https://github.com/slockit/in3/blob/master/src/types/types.ts#L533)** :`string` *(optional)*  - the password used to decrpyt the private key

* **[registry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L537)** :`string` - the address of the server registry used in order to update the nodeList

* **[registryRPC](https://github.com/slockit/in3/blob/master/src/types/types.ts#L541)** :`string` *(optional)*  - the url of the client in case the registry is not on the same chain.

* **[rpcUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L493)** :`string` - the url of the client

* **[startBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L521)** :`number` *(optional)*  - blocknumber to start watching the registry

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L489)** :`number` *(optional)*  - number of milliseconds to wait before a request gets a timeout

* **[watchInterval](https://github.com/slockit/in3/blob/master/src/types/types.ts#L525)** :`number` *(optional)*  - the number of seconds of the interval for checking for new events

* **[watchdogInterval](https://github.com/slockit/in3/blob/master/src/types/types.ts#L501)** :`number` *(optional)*  - average time between sending requests to the same node. 0 turns it off (default)


### Type IN3RPCRequestConfig


additional config for a IN3 RPC-Request


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L574)



* **[chainId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L579)** :`string` - the requested chainId
    example: 0x1

* **[clientSignature](https://github.com/slockit/in3/blob/master/src/types/types.ts#L618)** :`any` *(optional)*  - the signature of the client

* **[finality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L609)** :`number` *(optional)*  - if given the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.

* **[includeCode](https://github.com/slockit/in3/blob/master/src/types/types.ts#L584)** :`boolean` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
    example: true

* **[latestBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L593)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[signatures](https://github.com/slockit/in3/blob/master/src/types/types.ts#L623)** :`string`[] *(optional)*  - a list of addresses requested to sign the blockhash
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[useBinary](https://github.com/slockit/in3/blob/master/src/types/types.ts#L601)** :`boolean` *(optional)*  - if true binary-data will be used.

* **[useFullProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L605)** :`boolean` *(optional)*  - if true all data in the response will be proven, which leads to a higher payload.

* **[useRef](https://github.com/slockit/in3/blob/master/src/types/types.ts#L597)** :`boolean` *(optional)*  - if true binary-data (starting with a 0x) will be refered if occuring again.

* **[verification](https://github.com/slockit/in3/blob/master/src/types/types.ts#L614)** :`'never'`|`'proof'`|`'proofWithSignature'` *(optional)*  - defines the kind of proof the client is asking for
    example: proof

* **[verifiedHashes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L588)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number.


### Type IN3ResponseConfig


additional data returned from a IN3 Server


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L628)



* **[currentBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L646)** :`number` *(optional)*  - the current blocknumber.
    example: 320126478

* **[lastNodeList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L637)** :`number` *(optional)*  - the blocknumber for the last block updating the nodelist. If the client has a smaller blocknumber he should update the nodeList.
    example: 326478

* **[lastValidatorChange](https://github.com/slockit/in3/blob/master/src/types/types.ts#L641)** :`number` *(optional)*  - the blocknumber of gthe last change of the validatorList

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L632)** :[`Proof`](#type-proof) *(optional)*  - the Proof-data


### Type LogProof


a Object holding proofs for event logs. The key is the blockNumber as hex


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L651)




### Type Proof


the Proof-data as part of the in3-section


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L694)



* **[accounts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L739)** *(optional)*  - a map of addresses and their AccountProof

* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L704)** :`string` *(optional)*  - the serialized blockheader as hex, required in most proofs
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3/blob/master/src/types/types.ts#L709)** :`any`[] *(optional)*  - the serialized blockheader as hex, required in case of finality asked
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L735)** :[`LogProof`](#type-logproof) *(optional)*  - the Log Proof in case of a Log-Request

* **[merkleProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L723)** :`string`[] *(optional)*  - the serialized merle-noodes beginning with the root-node

* **[merkleProofPrev](https://github.com/slockit/in3/blob/master/src/types/types.ts#L727)** :`string`[] *(optional)*  - the serialized merkle-noodes beginning with the root-node of the previous entry (only for full proof of receipts)

* **[signatures](https://github.com/slockit/in3/blob/master/src/types/types.ts#L750)** :[`Signature`](#type-signature)[] *(optional)*  - requested signatures

* **[transactions](https://github.com/slockit/in3/blob/master/src/types/types.ts#L714)** :`any`[] *(optional)*  - the list of transactions of the block
    example:

* **[txIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L746)** :`number` *(optional)*  - the transactionIndex within the block
    example: 4

* **[txProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L731)** :`string`[] *(optional)*  - the serialized merkle-nodes beginning with the root-node in order to prrof the transactionIndex

* **[type](https://github.com/slockit/in3/blob/master/src/types/types.ts#L699)** :`'transactionProof'`|`'receiptProof'`|`'blockProof'`|`'accountProof'`|`'callProof'`|`'logProof'` - the type of the proof
    example: accountProof

* **[uncles](https://github.com/slockit/in3/blob/master/src/types/types.ts#L719)** :`any`[] *(optional)*  - the list of uncle-headers of the block
    example:


### Type RPCRequest


a JSONRPC-Request with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L755)



* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L769)** :`number`|`string` *(optional)*  - the identifier of the request
    example: 2

* **[in3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L778)** :[`IN3RPCRequestConfig`](#type-in3rpcrequestconfig) *(optional)*  - the IN3-Config

* **[jsonrpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L759)** :`'2.0'` - the version

* **[method](https://github.com/slockit/in3/blob/master/src/types/types.ts#L764)** :`string` - the method to call
    example: eth_getBalance

* **[params](https://github.com/slockit/in3/blob/master/src/types/types.ts#L774)** :`any`[] *(optional)*  - the params
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest


### Type RPCResponse


a JSONRPC-Responset with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L783)



* **[error](https://github.com/slockit/in3/blob/master/src/types/types.ts#L796)** :`string` *(optional)*  - in case of an error this needs to be set

* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L792)** :`string`|`number` - the id matching the request
    example: 2

* **[in3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L805)** :[`IN3ResponseConfig`](#type-in3responseconfig) *(optional)*  - the IN3-Result

* **[in3Node](https://github.com/slockit/in3/blob/master/src/types/types.ts#L809)** :[`IN3NodeConfig`](#type-in3nodeconfig) *(optional)*  - the node handling this response (internal only)

* **[jsonrpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L787)** :`'2.0'` - the version

* **[result](https://github.com/slockit/in3/blob/master/src/types/types.ts#L801)** :`any` *(optional)*  - the params
    example: 0xa35bc


### Type ServerList


a List of nodes


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L814)



* **[contract](https://github.com/slockit/in3/blob/master/src/types/types.ts#L826)** :`string` *(optional)*  - IN3 Registry

* **[lastBlockNumber](https://github.com/slockit/in3/blob/master/src/types/types.ts#L818)** :`number` *(optional)*  - last Block number

* **[nodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L822)** :[`IN3NodeConfig`](#type-in3nodeconfig)[] - the list of nodes

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L831)** :[`Proof`](#type-proof) *(optional)*  - the Proof-data as part of the in3-section

* **[totalServers](https://github.com/slockit/in3/blob/master/src/types/types.ts#L830)** :`number` *(optional)*  - number of servers


### Type Signature


Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L836)



* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L841)** :`string` *(optional)*  - the address of the signing node
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L846)** :`number` - the blocknumber
    example: 3123874

* **[blockHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L851)** :`string` - the hash of the block
    example: 0x6C1a01C2aB554930A937B0a212346037E8105fB47946c679

* **[msgHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L856)** :`string` - hash of the message
    example: 0x9C1a01C2aB554930A937B0a212346037E8105fB47946AB5D

* **[r](https://github.com/slockit/in3/blob/master/src/types/types.ts#L861)** :`string` - Positive non-zero Integer signature.r
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1f

* **[s](https://github.com/slockit/in3/blob/master/src/types/types.ts#L866)** :`string` - Positive non-zero Integer signature.s
    example: 0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda

* **[v](https://github.com/slockit/in3/blob/master/src/types/types.ts#L871)** :`number` - Calculated curve point, or identity element O.
    example: 28



## Package util

a collection of util classes inside incubed. They can be get directly through `require('in3/js/srrc/util/util')`


### Type Transport


A Transport-object responsible to transport the message to the handler.


Source: [util/transport.ts](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L27)



* **[handle](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L31)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` - handles a request by passing the data to the handler

* **[isOnline](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L36)**() :`Promise<boolean>` - check whether the handler is onlne.

* **[random](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L41)**(count :`number`) :`number`[] - generates random numbers (between 0-1)


### Type AxiosTransport


Default Transport impl sending http-requests.


Source: [util/transport.ts](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L49)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L51)**(format :`'json'`|`'jsonRef'`|`'cbor'` = "json") :[`AxiosTransport`](#type-axiostransport) 

* **[format](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L51)** :`'json'`|`'jsonRef'`|`'cbor'` 

* **[handle](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L61)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` 

* **[isOnline](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L57)**() :`Promise<boolean>` 

* **[random](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L90)**(count :`number`) :`number`[] 


### Type BN


Source: [util/util.ts](https://github.com/slockit/in3/blob/master/src/util/util.ts#L26)




## in3-common

The common module contains all the typedefs used in the node and server.



* [**BlockData**](#type-blockdata) : `interface`  - Block as returned by eth_getBlockByNumber

* [**LogData**](#type-logdata) : `interface`  - LogData as part of the TransactionReceipt

* **[Receipt](https://github.com/slockit/in3-common/blob/master/src/index.ts#L56)** :[`_serialize.Receipt`](#type-_serialize.receipt) 

* [**ReceiptData**](#type-receiptdata) : `interface`  - TransactionReceipt as returned by eth_getTransactionReceipt

* **[Transaction](https://github.com/slockit/in3-common/blob/master/src/index.ts#L57)** :[`_serialize.Transaction`](#type-_serialize.transaction) 

* [**TransactionData**](#type-transactiondata) : `interface`  - Transaction as returned by eth_getTransactionByHash

* [**Transport**](#type-transport) : `interface`  - A Transport-object responsible to transport the message to the handler.

* [**AxiosTransport**](#type-axiostransport) : `class`  - Default Transport impl sending http-requests.

* [**Block**](#type-block) : `class`  - encodes and decodes the blockheader

* **[blockFromHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L313)**(hex :`string`) :[`Block`](#type-block) - converts a hexstring to a block-object

* **[cbor](https://github.com/slockit/in3-common/blob/master/src/index.ts#L71)**

    * **[createRefs](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L86)**(val :[`T`](#type-t), cache :`string`[] =  []) :[`T`](#type-t) 

    * **[decodeRequests](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L30)**(request :[`Buffer`](#type-buffer)) :[`RPCRequest`](#type-rpcrequest)[] 

    * **[decodeResponses](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L44)**(responses :[`Buffer`](#type-buffer)) :[`RPCResponse`](#type-rpcresponse)[] 

    * **[encodeRequests](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L26)**(requests :[`RPCRequest`](#type-rpcrequest)[]) :[`Buffer`](#type-buffer) - turn

    * **[encodeResponses](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L41)**(responses :[`RPCResponse`](#type-rpcresponse)[]) :[`Buffer`](#type-buffer) 

    * **[resolveRefs](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L107)**(val :[`T`](#type-t), cache :`string`[] =  []) :[`T`](#type-t) 

* **[chainAliases](https://github.com/slockit/in3-common/blob/master/src/index.ts#L68)**

    * **[goerli](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

    * **[ipfs](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

    * **[kovan](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

    * **[main](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

    * **[mainnet](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

    * **[tobalaba](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

* **[createRandomIndexes](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L222)**(len :`number`, limit :`number`, seed :[`Buffer`](#type-buffer), result :`number`[] =  []) :`number`[] 

* **[createTx](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L280)**(transaction :`any`) :`any` - creates a Transaction-object from the rpc-transaction-data

* **[getSigner](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L235)**(data :[`Block`](#type-block)) :[`Buffer`](#type-buffer) 

* **[rlp](https://github.com/slockit/in3-common/blob/master/src/index.ts#L85)**

* **[serialize](https://github.com/slockit/in3-common/blob/master/src/index.ts#L49)**

    * [**Block**](#type-block) :`class` - encodes and decodes the blockheader

    * [**AccountData**](#type-accountdata) :`interface` - Account-Object

    * [**BlockData**](#type-blockdata) :`interface` - Block as returned by eth_getBlockByNumber

    * [**LogData**](#type-logdata) :`interface` - LogData as part of the TransactionReceipt

    * [**ReceiptData**](#type-receiptdata) :`interface` - TransactionReceipt as returned by eth_getTransactionReceipt

    * [**TransactionData**](#type-transactiondata) :`interface` - Transaction as returned by eth_getTransactionByHash

    * **[Account](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L33)** :[`Buffer`](#type-buffer)[] - Buffer[] of the Account

    * **[BlockHeader](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L27)** :[`Buffer`](#type-buffer)[] - Buffer[] of the header

    * **[Receipt](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L36)** : - Buffer[] of the Receipt

    * **[Transaction](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L30)** :[`Buffer`](#type-buffer)[] - Buffer[] of the transaction

    * **[rlp](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L25)** - RLP-functions

    * **[address](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L145)**(val :`any`) :`any` - converts it to a Buffer with 20 bytes length

    * **[blockFromHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L313)**(hex :`string`) :[`Block`](#type-block) - converts a hexstring to a block-object

    * **[blockToHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L308)**(block :`any`) :`string` - converts blockdata to a hexstring

    * **[bytes](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L143)**(val :`any`) :`any` - converts it to a Buffer

    * **[bytes256](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L137)**(val :`any`) :`any` - converts it to a Buffer with 256 bytes length

    * **[bytes32](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L139)**(val :`any`) :`any` - converts it to a Buffer with 32 bytes length

    * **[bytes8](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L141)**(val :`any`) :`any` - converts it to a Buffer with 8 bytes length

    * **[createTx](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L280)**(transaction :`any`) :`any` - creates a Transaction-object from the rpc-transaction-data

    * **[hash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L131)**(val :[`Block`](#type-block)|[`Transaction`](#type-transaction)|[`Receipt`](#type-receipt)|[`Account`](#type-account)|[`Buffer`](#type-buffer)) :[`Buffer`](#type-buffer) - returns the hash of the object

    * **[serialize](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L128)**(val :[`Block`](#type-block)|[`Transaction`](#type-transaction)|[`Receipt`](#type-receipt)|[`Account`](#type-account)|`any`) :[`Buffer`](#type-buffer) - serialize the data

    * **[toAccount](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L191)**(account :[`AccountData`](#type-accountdata)) :[`Buffer`](#type-buffer)[] 

    * **[toBlockHeader](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L152)**(block :[`BlockData`](#type-blockdata)) :[`Buffer`](#type-buffer)[] - create a Buffer[] from RPC-Response

    * **[toReceipt](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L200)**(r :[`ReceiptData`](#type-receiptdata)) :`Object` - create a Buffer[] from RPC-Response

    * **[toTransaction](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L177)**(tx :[`TransactionData`](#type-transactiondata)) :[`Buffer`](#type-buffer)[] - create a Buffer[] from RPC-Response

    * **[uint](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L147)**(val :`any`) :`any` - converts it to a Buffer with a variable length. 0 = length 0

    * **[uint64](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L149)**(val :`any`) :`any` 

* **[storage](https://github.com/slockit/in3-common/blob/master/src/index.ts#L65)**

    * **[getStorageArrayKey](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L28)**(pos :`number`, arrayIndex :`number`, structSize :`number` = 1, structPos :`number` = 0) :`any` - calc the storrage array key

    * **[getStorageMapKey](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L40)**(pos :`number`, key :`string`, structPos :`number` = 0) :`any` - calcs the storage Map key.

    * **[getStorageValue](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L88)**(rpc :`string`, contract :`string`, pos :`number`, type :`'address'`|`'bytes32'`|`'bytes16'`|`'bytes4'`|`'int'`|`'string'`, keyOrIndex :`number`|`string`, structSize :`number`, structPos :`number`) :`Promise<any>` - get a storage value from the server

    * **[getStringValue](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L50)**(data :[`Buffer`](#type-buffer), storageKey :[`Buffer`](#type-buffer)) :`string`| - creates a string from storage.

    * **[getStringValueFromList](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L69)**(values :[`Buffer`](#type-buffer)[], len :`number`) :`string` - concats the storage values to a string.

    * **[toBN](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L76)**(val :`any`) :`any` - converts any value to BN

* **[transport](https://github.com/slockit/in3-common/blob/master/src/index.ts#L60)**

    * [**AxiosTransport**](#type-axiostransport) :`class` - Default Transport impl sending http-requests.

    * [**Transport**](#type-transport) :`interface` - A Transport-object responsible to transport the message to the handler.

* **[util](https://github.com/slockit/in3-common/blob/master/src/index.ts#L25)**

    * **[checkForError](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L61)**(res :[`T`](#type-t)) :[`T`](#type-t) - check a RPC-Response for errors and rejects the promise if found

    * **[createRandomIndexes](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L222)**(len :`number`, limit :`number`, seed :[`Buffer`](#type-buffer), result :`number`[] =  []) :`number`[] 

    * **[getAddress](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L176)**(pk :`string`) :`string` - returns a address from a private key

    * **[getSigner](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L235)**(data :[`Block`](#type-block)) :[`Buffer`](#type-buffer) 

    * **[padEnd](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L215)**(val :`string`, minLength :`number`, fill :`string` = " ") :`string` - padEnd for legacy

    * **[padStart](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L208)**(val :`string`, minLength :`number`, fill :`string` = " ") :`string` - padStart for legacy

    * **[promisify](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L39)**(self :`any`, fn :`any`, args :`any`[]) :`Promise<any>` - simple promisy-function

    * **[toBN](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L70)**(val :`any`) :`any` - convert to BigNumber

    * **[toBuffer](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L132)**(val :`any`, len :`number` =  -1) :`any` - converts any value as Buffer
         if len === 0 it will return an empty Buffer if the value is 0 or '0x00', since this is the way rlpencode works wit 0-values.

    * **[toHex](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L81)**(val :`any`, bytes :`number`) :`string` - converts any value as hex-string

    * **[toMinHex](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L182)**(key :`string`|[`Buffer`](#type-buffer)|`number`) :`string` - removes all leading 0 in the hexstring

    * **[toNumber](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L104)**(val :`any`) :`number` - converts to a js-number

    * **[toSimpleHex](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L165)**(val :`string`) :`string` - removes all leading 0 in a hex-string

    * **[toUtf8](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L50)**(val :`any`) :`string` 

    * **[aliases](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** : `Object`  


        * **[goerli](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

        * **[ipfs](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

        * **[kovan](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

        * **[main](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

        * **[mainnet](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

        * **[tobalaba](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L241)** :`string` 

* **[validate](https://github.com/slockit/in3-common/blob/master/src/index.ts#L22)**

    * **[ajv](https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L27)** :[`Ajv`](#type-ajv) - the ajv instance with custom formatters and keywords

    * **[validate](https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L55)**(ob :`any`, def :`any`) :`void` 

    * **[validateAndThrow](https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L49)**(fn :[`Ajv.ValidateFunction`](#type-ajv.validatefunction), ob :`any`) :`void` - validates the data and throws an error in case they are not valid.


## Package modules/eth


### Type BlockData


Block as returned by eth_getBlockByNumber


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L39)



* **[coinbase](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L44)** :`string` *(optional)*  

* **[difficulty](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L50)** :`string`|`number` 

* **[extraData](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L55)** :`string` 

* **[gasLimit](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L52)** :`string`|`number` 

* **[gasUsed](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L53)** :`string`|`number` 

* **[hash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L40)** :`string` 

* **[logsBloom](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L49)** :`string` 

* **[miner](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L43)** :`string` 

* **[mixHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L57)** :`string` *(optional)*  

* **[nonce](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L58)** :`string`|`number` *(optional)*  

* **[number](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L51)** :`string`|`number` 

* **[parentHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L41)** :`string` 

* **[receiptRoot](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L48)** :`string` *(optional)*  

* **[receiptsRoot](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L47)** :`string` 

* **[sealFields](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L56)** :`string`[] *(optional)*  

* **[sha3Uncles](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L42)** :`string` 

* **[stateRoot](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L45)** :`string` 

* **[timestamp](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L54)** :`string`|`number` 

* **[transactions](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L59)** :`any`[] *(optional)*  

* **[transactionsRoot](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L46)** :`string` 

* **[uncles](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L60)** :`string`[] *(optional)*  


### Type LogData


LogData as part of the TransactionReceipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L99)



* **[address](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L107)** :`string` 

* **[blockHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L105)** :`string` 

* **[blockNumber](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L106)** :`string` 

* **[data](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L108)** :`string` 

* **[logIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L101)** :`string` 

* **[removed](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L100)** :`boolean` 

* **[topics](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L109)** :`string`[] 

* **[transactionHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L104)** :`string` 

* **[transactionIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L103)** :`string` 

* **[transactionLogIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L102)** :`string` 


### Type ReceiptData


TransactionReceipt as returned by eth_getTransactionReceipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L113)



* **[blockHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L117)** :`string` *(optional)*  

* **[blockNumber](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L116)** :`string`|`number` *(optional)*  

* **[cumulativeGasUsed](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L120)** :`string`|`number` *(optional)*  

* **[gasUsed](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L121)** :`string`|`number` *(optional)*  

* **[logs](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L123)** :[`LogData`](#type-logdata)[] 

* **[logsBloom](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L122)** :`string` *(optional)*  

* **[root](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L119)** :`string` *(optional)*  

* **[status](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L118)** :`string`|`boolean` *(optional)*  

* **[transactionHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L114)** :`string` *(optional)*  

* **[transactionIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L115)** :`number` *(optional)*  


### Type TransactionData


Transaction as returned by eth_getTransactionByHash


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L64)



* **[blockHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L66)** :`string` *(optional)*  

* **[blockNumber](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L67)** :`number`|`string` *(optional)*  

* **[chainId](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L68)** :`number`|`string` *(optional)*  

* **[condition](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L69)** :`string` *(optional)*  

* **[creates](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L70)** :`string` *(optional)*  

* **[data](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L76)** :`string` *(optional)*  

* **[from](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L71)** :`string` *(optional)*  

* **[gas](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L72)** :`number`|`string` *(optional)*  

* **[gasLimit](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L73)** :`number`|`string` *(optional)*  

* **[gasPrice](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L74)** :`number`|`string` *(optional)*  

* **[hash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L65)** :`string` 

* **[input](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L75)** :`string` 

* **[nonce](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L77)** :`number`|`string` 

* **[publicKey](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L78)** :`string` *(optional)*  

* **[r](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L83)** :`string` *(optional)*  

* **[raw](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L79)** :`string` *(optional)*  

* **[s](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L84)** :`string` *(optional)*  

* **[standardV](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L80)** :`string` *(optional)*  

* **[to](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L81)** :`string` 

* **[transactionIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L82)** :`number` 

* **[v](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L85)** :`string` *(optional)*  

* **[value](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L86)** :`number`|`string` 


### Type Block


encodes and decodes the blockheader


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L224)



* `constructor` **[constructor](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L245)**(data :[`Buffer`](#type-buffer)|`string`|[`BlockData`](#type-blockdata)) :[`Block`](#type-block) - creates a Block-Onject from either the block-data as returned from rpc, a buffer or a hex-string of the encoded blockheader

* **[raw](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L227)** :[`BlockHeader`](#type-blockheader) - the raw Buffer fields of the BlockHeader

* **[transactions](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L230)** :[`Tx`](#type-tx)[] - the transaction-Object (if given)

*  **bloom()** 

*  **coinbase()** 

*  **difficulty()** 

*  **extra()** 

*  **gasLimit()** 

*  **gasUsed()** 

*  **number()** 

*  **parentHash()** 

*  **receiptTrie()** 

*  **sealedFields()** 

*  **stateRoot()** 

*  **timestamp()** 

*  **transactionsTrie()** 

*  **uncleHash()** 

* **[bareHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L268)**() :[`Buffer`](#type-buffer) - the blockhash as buffer without the seal fields

* **[hash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L263)**() :[`Buffer`](#type-buffer) - the blockhash as buffer

* **[serializeHeader](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L273)**() :[`Buffer`](#type-buffer) - the serialized header as buffer


### Type AccountData


Account-Object


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L90)



* **[balance](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L92)** :`string` 

* **[code](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L95)** :`string` *(optional)*  

* **[codeHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L94)** :`string` 

* **[nonce](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L91)** :`string` 

* **[storageHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L93)** :`string` 


### Type Transaction


Buffer[] of the transaction


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L30)



* **[Transaction](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L30)** :[`Buffer`](#type-buffer)[] - Buffer[] of the transaction


### Type Receipt


Buffer[] of the Receipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L36)



* **[Receipt](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L36)** : - Buffer[] of the Receipt


### Type Account


Buffer[] of the Account


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L33)



* **[Account](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L33)** :[`Buffer`](#type-buffer)[] - Buffer[] of the Account


### Type BlockHeader


Buffer[] of the header


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L27)



* **[BlockHeader](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L27)** :[`Buffer`](#type-buffer)[] - Buffer[] of the header



## Package types


### Type RPCRequest


a JSONRPC-Request with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L77)



* **[id](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L91)** :`number`|`string` *(optional)*  - the identifier of the request
    example: 2

* **[in3](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L100)** :[`IN3RPCRequestConfig`](#type-in3rpcrequestconfig) *(optional)*  - the IN3-Config

* **[jsonrpc](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L81)** :`'2.0'` - the version

* **[method](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L86)** :`string` - the method to call
    example: eth_getBalance

* **[params](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L96)** :`any`[] *(optional)*  - the params
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest


### Type RPCResponse


a JSONRPC-Responset with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L152)



* **[error](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L165)** :`string` *(optional)*  - in case of an error this needs to be set

* **[id](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L161)** :`string`|`number` - the id matching the request
    example: 2

* **[in3](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L174)** :[`IN3ResponseConfig`](#type-in3responseconfig) *(optional)*  - the IN3-Result

* **[in3Node](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L178)** :[`IN3NodeConfig`](#type-in3nodeconfig) *(optional)*  - the node handling this response (internal only)

* **[jsonrpc](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L156)** :`'2.0'` - the version

* **[result](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L170)** :`any` *(optional)*  - the params
    example: 0xa35bc


### Type IN3RPCRequestConfig


additional config for a IN3 RPC-Request


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L22)



* **[chainId](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L27)** :`string` - the requested chainId
    example: 0x1

* **[clientSignature](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L66)** :`any` *(optional)*  - the signature of the client

* **[finality](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L57)** :`number` *(optional)*  - if given the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.

* **[includeCode](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L32)** :`boolean` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
    example: true

* **[latestBlock](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L41)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[signatures](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L71)** :`string`[] *(optional)*  - a list of addresses requested to sign the blockhash
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[useBinary](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L49)** :`boolean` *(optional)*  - if true binary-data will be used.

* **[useFullProof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L53)** :`boolean` *(optional)*  - if true all data in the response will be proven, which leads to a higher payload.

* **[useRef](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L45)** :`boolean` *(optional)*  - if true binary-data (starting with a 0x) will be refered if occuring again.

* **[verification](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L62)** :`'never'`|`'proof'`|`'proofWithSignature'` *(optional)*  - defines the kind of proof the client is asking for
    example: proof

* **[verifiedHashes](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L36)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number.


### Type IN3ResponseConfig


additional data returned from a IN3 Server


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L382)



* **[currentBlock](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L400)** :`number` *(optional)*  - the current blocknumber.
    example: 320126478

* **[lastNodeList](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L391)** :`number` *(optional)*  - the blocknumber for the last block updating the nodelist. If the client has a smaller blocknumber he should update the nodeList.
    example: 326478

* **[lastValidatorChange](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L395)** :`number` *(optional)*  - the blocknumber of gthe last change of the validatorList

* **[proof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L386)** :[`Proof`](#type-proof) *(optional)*  - the Proof-data


### Type IN3NodeConfig


a configuration of a in3-server.


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L106)



* **[address](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L116)** :`string` - the address of the node, which is the public address it iis signing with.
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[capacity](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L141)** :`number` *(optional)*  - the capacity of the node.
    example: 100

* **[chainIds](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L131)** :`string`[] - the list of supported chains
    example: 0x1

* **[deposit](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L136)** :`number` - the deposit of the node in wei
    example: 12350000

* **[index](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L111)** :`number` *(optional)*  - the index within the contract
    example: 13

* **[props](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L146)** :`number` *(optional)*  - the properties of the node.
    example: 3

* **[timeout](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L121)** :`number` *(optional)*  - the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
    example: 3600

* **[url](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L126)** :`string` - the endpoint to post to
    example: https://in3.slock.it


### Type Proof


the Proof-data as part of the in3-section


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L320)



* **[accounts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L365)** *(optional)*  - a map of addresses and their AccountProof

* **[block](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L330)** :`string` *(optional)*  - the serialized blockheader as hex, required in most proofs
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L335)** :`any`[] *(optional)*  - the serialized blockheader as hex, required in case of finality asked
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logProof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L361)** :[`LogProof`](#type-logproof) *(optional)*  - the Log Proof in case of a Log-Request

* **[merkleProof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L349)** :`string`[] *(optional)*  - the serialized merle-noodes beginning with the root-node

* **[merkleProofPrev](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L353)** :`string`[] *(optional)*  - the serialized merkle-noodes beginning with the root-node of the previous entry (only for full proof of receipts)

* **[signatures](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L376)** :[`Signature`](#type-signature)[] *(optional)*  - requested signatures

* **[transactions](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L340)** :`any`[] *(optional)*  - the list of transactions of the block
    example:

* **[txIndex](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L372)** :`number` *(optional)*  - the transactionIndex within the block
    example: 4

* **[txProof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L357)** :`string`[] *(optional)*  - the serialized merkle-nodes beginning with the root-node in order to prrof the transactionIndex

* **[type](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L325)** :`'transactionProof'`|`'receiptProof'`|`'blockProof'`|`'accountProof'`|`'callProof'`|`'logProof'` - the type of the proof
    example: accountProof

* **[uncles](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L345)** :`any`[] *(optional)*  - the list of uncle-headers of the block
    example:


### Type LogProof


a Object holding proofs for event logs. The key is the blockNumber as hex


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L184)




### Type Signature


Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L279)



* **[address](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L284)** :`string` *(optional)*  - the address of the signing node
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[block](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L289)** :`number` - the blocknumber
    example: 3123874

* **[blockHash](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L294)** :`string` - the hash of the block
    example: 0x6C1a01C2aB554930A937B0a212346037E8105fB47946c679

* **[msgHash](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L299)** :`string` - hash of the message
    example: 0x9C1a01C2aB554930A937B0a212346037E8105fB47946AB5D

* **[r](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L304)** :`string` - Positive non-zero Integer signature.r
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1f

* **[s](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L309)** :`string` - Positive non-zero Integer signature.s
    example: 0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda

* **[v](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L314)** :`number` - Calculated curve point, or identity element O.
    example: 28



## Package util


### Type Transport


A Transport-object responsible to transport the message to the handler.


Source: [util/transport.ts](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L27)



* **[handle](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L31)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` - handles a request by passing the data to the handler

* **[isOnline](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L36)**() :`Promise<boolean>` - check whether the handler is onlne.

* **[random](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L41)**(count :`number`) :`number`[] - generates random numbers (between 0-1)


### Type AxiosTransport


Default Transport impl sending http-requests.


Source: [util/transport.ts](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L49)



* `constructor` **[constructor](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L51)**(format :`'json'`|`'cbor'`|`'jsonRef'` = "json") :[`AxiosTransport`](#type-axiostransport) 

* **[format](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L51)** :`'json'`|`'cbor'`|`'jsonRef'` 

* **[handle](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L61)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` 

* **[isOnline](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L57)**() :`Promise<boolean>` 

* **[random](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L90)**(count :`number`) :`number`[] 


