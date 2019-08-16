# API Reference TS

This page contains a list of all Datastructures and Classes used within the TypeScript Incubed Client.
 ## Examples

This is a collection of different Incubed-examples.

### Using Web3

Since Incubed works with on a JSON-RPC-Level it can easily be used as Provider for Web3:

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

### Using Incubed API


Incubed includes a light API, allowing it to not only use all RPC-Methods in a typesafe way, but also to sign transactions and call functions of a contract without the web3-library.

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

// use the api to call a function..
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

### Reading Event with Incubed


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

// Use the ABI-String of the smart contract.
abi = [{"anonymous":false,"inputs":[{"indexed":false,"name":"name","type":"string"},{"indexed":true,"name":"label","type":"bytes32"},{"indexed":true,"name":"owner","type":"address"},{"indexed":false,"name":"cost","type":"uint256"},{"indexed":false,"name":"expires","type":"uint256"}],"name":"NameRegistered","type":"event"}]

// Create a contract-object for a given address.
const contract = in3.eth.contractAt(abi, '0xF0AD5cAd05e10572EfcEB849f6Ff0c68f9700455') // ENS contract.

// Read all events starting from a specified block until the latest.
const logs = await c.events.NameRegistered.getLogs({fromBlock:8022948})) 

// Print out the properties of the event.
for (const ev of logs) 
  console.log(`${ev.owner} registered ${ev.name} for ${ev.cost} wei until ${new Date(ev.expires.toNumber()*1000).toString()}`)

...
``` 
## Main Module

 Importing Incubed is as easy as: 
```ts
import Client,{util} from "in3"
```

 While the IN3-client-class is the default import, the following imports can be used: 

`   

* [**AccountProof**](#type-accountproof) : `interface`  - The proof for a single account.

* [**AuraValidatoryProof**](#type-auravalidatoryproof) : `interface`  - An object holding proofs for validator logs. The key is the block number as a hex.

* [**BlockData**](#type-blockdata) : `interface`  - Block as returned by eth_getBlockByNumber

* [**ChainSpec**](#type-chainspec) : `interface`  - Describes the chain specific consensus parameters.

* [**IN3Client**](#type-client) : `class`  - Client for Incubed.

* [**IN3Config**](#type-in3config) : `interface`  - The configuration of the IN3-Client. This can be partially overridden for every request.

* [**IN3NodeConfig**](#type-in3nodeconfig) : `interface`  - A configuration of an IN3-server.

* [**IN3NodeWeight**](#type-in3nodeweight) : `interface`  - The local weight of an IN3-node. (This is used internally to weigh the requests.)

* [**IN3RPCConfig**](#type-in3rpcconfig) : `interface`  - The configuration for the RPC-handler.

* [**IN3RPCHandlerConfig**](#type-in3rpchandlerconfig) : `interface`  - The configuration for the RPC-handler.

* [**IN3RPCRequestConfig**](#type-in3rpcrequestconfig) : `interface`  - Additional configuration for an Incubed RPC-request.

* [**IN3ResponseConfig**](#type-in3responseconfig) : `interface`  - Additional data returned from an Incubed server.

* [**LogData**](#type-logdata) : `interface`  - LogData as part of the TransactionReceipt.

* [**LogProof**](#type-logproof) : `interface`  - An object holding proofs for event logs. The key is the block number as a hex.

* [**Proof**](#type-proof) : `interface`  - The proof-data as part of the IN3-section.

* [**RPCRequest**](#type-rpcrequest) : `interface`  - A JSONRPC-request with IN3-extension.

* [**RPCResponse**](#type-rpcresponse) : `interface`  - A JSONRPC-responset with IN3-extension.

* [**ReceiptData**](#type-receiptdata) : `interface`  - TransactionReceipt as returned by eth_getTransactionReceipt.

* [**ServerList**](#type-serverlist) : `interface`  - A list of nodes.

* [**Signature**](#type-signature) : `interface`  - Verified ECDSA signature. Signatures are a pair (r, s), where r is computed as the X coordinate of a point R, modulo the curve order n.

* [**TransactionData**](#type-transactiondata) : `interface`  - Transaction as returned by eth_getTransactionByHash.

* [**Transport**](#type-transport) : `interface`  - A transport-object responsible for transporting the message to the handler.

* [**AxiosTransport**](#type-axiostransport) : `class`  - Default transport impl sending http-requests.

* [**EthAPI**](#type-ethapi) : `class` 

* **[cbor](https://github.com/slockit/in3/blob/master/src/index.ts#L33)**

    * **[createRefs](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L86)**(val :[`T`](#type-t), cache :`string`[] =  []) :[`T`](#type-t) 

    * **[decodeRequests](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L30)**(request :[`Buffer`](#type-buffer)) :[`RPCRequest`](#type-rpcrequest)[] 

    * **[decodeResponses](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L44)**(responses :[`Buffer`](#type-buffer)) :[`RPCResponse`](#type-rpcresponse)[] 

    * **[encodeRequests](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L26)**(requests :[`RPCRequest`](#type-rpcrequest)[]) :[`Buffer`](#type-buffer) - turn

    * **[encodeResponses](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L41)**(responses :[`RPCResponse`](#type-rpcresponse)[]) :[`Buffer`](#type-buffer) 

    * **[resolveRefs](https://github.com/slockit/in3/blob/master/src/util/cbor.ts#L107)**(val :[`T`](#type-t), cache :`string`[] =  []) :[`T`](#type-t) 

* **[chainAliases](https://github.com/slockit/in3/blob/master/src/index.ts#L82)**

    * **[goerli](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L698)** :`string` 

    * **[ipfs](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L698)** :`string` 

    * **[kovan](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L698)** :`string` 

    * **[main](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L698)** :`string` 

    * **[mainnet](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L698)** :`string` 

    * **[tobalaba](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L698)** :`string` 

* **[chainData](https://github.com/slockit/in3/blob/master/src/index.ts#L49)**

    * **[callContract](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L27)**(client :[`Client`](#type-client), contract :`string`, chainId :`string`, signature :`string`, args :`any`[], config :[`IN3Config`](#type-in3config)) :`Promise<any>` 

    * **[getChainData](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L36)**(client :[`Client`](#type-client), chainId :`string`, config :[`IN3Config`](#type-in3config)) :`Promise<>` 

* **[createRandomIndexes](https://github.com/slockit/in3/blob/master/src/client/serverList.ts#L32)**(len :`number`, limit :`number`, seed :[`Buffer`](#type-buffer), result :`number`[] =  []) :`number`[] 

* **[header](https://github.com/slockit/in3/blob/master/src/index.ts#L39)**

    * [**AuthSpec**](#type-authspec) :`interface` - Authority specification for proof of authority chains

    * **[checkBlockSignatures](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L27)**(blockHeaders :`string`|[`Buffer`](#type-buffer)|[`Block`](#type-block)|[`BlockData`](#type-blockdata)[], getChainSpec :) :`Promise<number>` - Verifies a blockheader and returns the percentage of finality.

    * **[getChainSpec](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L211)**(b :[`Block`](#type-block), ctx :[`ChainContext`](#type-chaincontext)) :[`Promise<AuthSpec>`](#type-authspec) 

    * **[getSigner](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L76)**(data :[`Block`](#type-block)) :[`Buffer`](#type-buffer) 

* **[serialize](https://github.com/slockit/in3/blob/master/src/index.ts#L36)**

    * [**Block**](#type-block) :`class` - Encodes and decodes the blockheader.

    * [**AccountData**](#type-accountdata) :`interface` - Account-object.

    * [**BlockData**](#type-blockdata) :`interface` - Block as returned by eth_getBlockByNumber.

    * [**LogData**](#type-logdata) :`interface` - LogData as part of the TransactionReceipt.

    * [**ReceiptData**](#type-receiptdata) :`interface` - TransactionReceipt as returned by eth_getTransactionReceipt.

    * [**TransactionData**](#type-transactiondata) :`interface` - Transaction as returned by eth_getTransactionByHash.

    * **[Account](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L33)** :[`Buffer`](#type-buffer)[] - Buffer[] of the account.

    * **[BlockHeader](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L27)** :[`Buffer`](#type-buffer)[] - Buffer[] of the header.

    * **[Receipt](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L36)** : - Buffer[] of the receipt.

    * **[Transaction](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L30)** :[`Buffer`](#type-buffer)[] - Buffer[] of the transaction.

    * **[rlp](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L25)** - RLP-functions.

    * **[address](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L145)**(val :`any`) :`any` - Converts it to a buffer with 20 bytes length.

    * **[blockFromHex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L313)**(hex :`string`) :[`Block`](#type-block) - Converts a hexstring to a block-object.

    * **[blockToHex](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L308)**(block :`any`) :`string` - Converts blockdata to a hexstring.

    * **[bytes](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L143)**(val :`any`) :`any` - Converts it to a buffer.

    * **[bytes256](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L137)**(val :`any`) :`any` - Converts it to a buffer with 256 bytes length.

    * **[bytes32](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L139)**(val :`any`) :`any` - Converts it to a buffer with 32 bytes length.

    * **[bytes8](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L141)**(val :`any`) :`any` - Converts it to a buffer with 8 bytes length.

    * **[createTx](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L280)**(transaction :`any`) :`any` - Creates a transaction-object from the RPC-transaction data.

    * **[hash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L131)**(val :[`Block`](#type-block)|[`Transaction`](#type-transaction)|[`Receipt`](#type-receipt)|[`Account`](#type-account)|[`Buffer`](#type-buffer)) :[`Buffer`](#type-buffer) - Returns the hash of the object.

    * **[serialize](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L128)**(val :[`Block`](#type-block)|[`Transaction`](#type-transaction)|[`Receipt`](#type-receipt)|[`Account`](#type-account)) :[`Buffer`](#type-buffer) - Serializes the data.

    * **[toAccount](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L191)**(account :[`AccountData`](#type-accountdata)) :[`Buffer`](#type-buffer)[] 

    * **[toBlockHeader](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L152)**(block :[`BlockData`](#type-blockdata)) :[`Buffer`](#type-buffer)[] - Creates a buffer[] from RPC-response.

    * **[toReceipt](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L200)**(r :[`ReceiptData`](#type-receiptdata)) :`Object` - Create a buffer[] from RPC-response.

    * **[toTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L177)**(tx :[`TransactionData`](#type-transactiondata)) :[`Buffer`](#type-buffer)[] - Create a buffer[] from RPC-response.

    * **[uint](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L147)**(val :`any`) :`any` - Converts it to a buffer with a variable length. 0 = length 0

    * **[uint64](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L149)**(val :`any`) :`any` 

* **[storage](https://github.com/slockit/in3/blob/master/src/index.ts#L42)**

    * **[getStorageArrayKey](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L28)**(pos :`number`, arrayIndex :`number`, structSize :`number` = 1, structPos :`number` = 0) :`any` - Calculates the storage array key.

    * **[getStorageMapKey](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L40)**(pos :`number`, key :`string`, structPos :`number` = 0) :`any` - Calculates the storage map key.

    * **[getStorageValue](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L88)**(rpc :`string`, contract :`string`, pos :`number`, type :`'address'`|`'bytes32'`|`'bytes16'`|`'bytes4'`|`'int'`|`'string'`, keyOrIndex :`number`|`string`, structSize :`number`, structPos :`number`) :`Promise<any>` - Receives a storage value from the server.

    * **[getStringValue](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L50)**(data :[`Buffer`](#type-buffer), storageKey :[`Buffer`](#type-buffer)) :`string`| - Creates a string from storage.

    * **[getStringValueFromList](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L69)**(values :[`Buffer`](#type-buffer)[], len :`number`) :`string` - Converts the storage values to a string.

    * **[toBN](https://github.com/slockit/in3/blob/master/src/modules/eth/storage.ts#L76)**(val :`any`) :`any` - Converts any value to BN.

* **[transport](https://github.com/slockit/in3/blob/master/src/index.ts#L45)**

    * [**AxiosTransport**](#type-axiostransport) :`class` - Default transport impl sending http-requests.

    * [**Transport**](#type-transport) :`interface` - A transport-object responsible for transporting the message to the handler.

* **[typeDefs](https://github.com/slockit/in3/blob/master/src/index.ts#L80)**

    * **[AccountProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[AuraValidatoryProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[ChainSpec](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[IN3Config](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[IN3NodeConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[IN3NodeWeight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[IN3RPCConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[IN3RPCHandlerConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[IN3RPCRequestConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[IN3ResponseConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[LogProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[Proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[RPCRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[RPCResponse](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[ServerList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


    * **[Signature](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** : `Object`  


* **[util](https://github.com/slockit/in3/blob/master/src/index.ts#L28)**

    * **[checkForError](https://github.com/slockit/in3/blob/master/src/util/util.ts#L58)**(res :[`T`](#type-t)) :[`T`](#type-t) - Checks an RPC-response for errors and rejects the promise if found.

    * **[getAddress](https://github.com/slockit/in3/blob/master/src/util/util.ts#L162)**(pk :`string`) :`string` - Returns an address from a private key.

    * **[padEnd](https://github.com/slockit/in3/blob/master/src/util/util.ts#L195)**(val :`string`, minLength :`number`, fill :`string` = " ") :`string` - PadEnd for legacy.

    * **[padStart](https://github.com/slockit/in3/blob/master/src/util/util.ts#L188)**(val :`string`, minLength :`number`, fill :`string` = " ") :`string` - PadStart for legacy.

    * **[promisify](https://github.com/slockit/in3/blob/master/src/util/util.ts#L36)**(self :`any`, fn :`any`, args :`any`[]) :`Promise<any>` - Simple promise-function.

    * **[toBN](https://github.com/slockit/in3/blob/master/src/util/util.ts#L67)**(val :`any`) :`any` - Convert to BigNumber.

    * **[toBuffer](https://github.com/slockit/in3/blob/master/src/util/util.ts#L119)**(val :`any`, len :`number` =  -1) :`any` - Converts any value as buffer.
         If len === 0 it will return an empty buffer if the value is 0 or '0x00', since this is the way rlp-encode works with 0-values.

    * **[toHex](https://github.com/slockit/in3/blob/master/src/util/util.ts#L77)**(val :`any`, bytes :`number`) :`string` - Converts any value as hexstring.

    * **[toMinHex](https://github.com/slockit/in3/blob/master/src/util/util.ts#L168)**(key :`string`|[`Buffer`](#type-buffer)|`number`) :`string` - Removes all leading with 0 in the hexstring.

    * **[toNumber](https://github.com/slockit/in3/blob/master/src/util/util.ts#L98)**(val :`any`) :`number` - Converts to a js-number

    * **[toSimpleHex](https://github.com/slockit/in3/blob/master/src/util/util.ts#L151)**(val :`string`) :`string` - Removes all leading with 0 in a hexstring.

    * **[toUtf8](https://github.com/slockit/in3/blob/master/src/util/util.ts#L47)**(val :`any`) :`string` 

* **[validate](https://github.com/slockit/in3/blob/master/src/util/validate.ts#L55)**(ob :`any`, def :`any`) :`void` 


## Package Client


### Type Client


Client for Incubed


Source: [client/Client.ts](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L54)



* **[defaultMaxListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L9)** :`number` 

* `static` **[listenerCount](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L8)**(emitter :[`EventEmitter`](#type-eventemitter), event :`string`|`symbol`) :`number` 

* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L63)**(config :[`Partial<IN3Config>`](#type-partial) =  {}, transport :[`Transport`](#type-transport)) :[`Client`](#type-client) - creates a new Client.

* **[defConfig](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L61)** :[`IN3Config`](#type-in3config) - The configuration of the IN3-client. This can be partially overridden for every request.

* **[eth](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L57)** :[`EthAPI`](#type-ethapi) 

* **[ipfs](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L58)** :[`IpfsAPI`](#type-ipfsapi) - Simple API for IPFS.

*  **config()** 

* **[addListener](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L11)**(event :`string`|`symbol`, listener :) :`this` 

* **[call](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L217)**(method :`string`, params :`any`, chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<any>` - Sends a simple RPC-request.

* **[clearStats](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L249)**() :`void` - Clears all stats and weights, like blacklisted nodes.

* **[createWeb3Provider](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L110)**() :`any` 

* **[emit](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L23)**(event :`string`|`symbol`, args :`any`[]) :`boolean` 

* **[eventNames](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L24)**() :[`Array<>`](#type-array) 

* **[getChainContext](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L117)**(chainId :`string`) :[`ChainContext`](#type-chaincontext) 

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

* **[send](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L229)**(request :[`RPCRequest`](#type-rpcrequest)[]|[`RPCRequest`](#type-rpcrequest), callback :, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<>` - Sends one or multiple requests.
    If the request is an array, the response will be an array as well.
    If the callback is given it will be called with the response. If not, a promise will be returned.
    This function supports callbacks so it can be used as a provider for the web3.

* **[sendRPC](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L206)**(method :`string`, params :`any`[] =  [], chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :[`Promise<RPCResponse>`](#type-rpcresponse) - Sends a simple RPC-request.

* **[setMaxListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L19)**(n :`number`) :`this` 

* **[updateNodeList](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L140)**(chainId :`string`, conf :[`Partial<IN3Config>`](#type-partial), retryCount :`number` = 5) :`Promise<void>` - Fetches the NodeList from the servers.


### Type ChainContext


Context for a specific chain including cache and chainSpecs


Source: [client/ChainContext.ts](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L27)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L33)**(client :[`Client`](#type-client), chainId :`string`, chainSpec :[`ChainSpec`](#type-chainspec)) :[`ChainContext`](#type-chaincontext) 

* **[chainId](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L31)** :`string` 

* **[chainSpec](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L29)** :[`ChainSpec`](#type-chainspec) - Describes the chain-specific consensus parameters.

* **[client](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L28)** :[`Client`](#type-client) - Client for Incubed.

* **[genericCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L33)**

* **[lastValidatorChange](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L32)** :`number` 

* **[module](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L30)** :[`Module`](#type-module) 

* **[clearCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L108)**(prefix :`string`) :`void` 

* **[getFromCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L98)**(key :`string`) :`string` 

* **[handleIntern](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L61)**(request :[`RPCRequest`](#type-rpcrequest)) :[`Promise<RPCResponse>`](#type-rpcresponse) - This function is called before the server is asked.
    If it returns a promise then the request is handled internally, otherwise the server will handle the response.
    This function should be overridden by modules that want to handle calls internally.

* **[initCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L66)**() :`void` 

* **[putInCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L102)**(key :`string`, value :`string`) :`void` 

* **[updateCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L92)**() :`void` 


### Type Module


Source: [client/modules.ts](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L7)



* **[name](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L8)** :`string` 

* **[createChainContext](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L10)**(client :[`Client`](#type-client), chainId :`string`, spec :[`ChainSpec`](#type-chainspec)) :[`ChainContext`](#type-chaincontext) 

* **[verifyProof](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L12)**(request :[`RPCRequest`](#type-rpcrequest), response :[`RPCResponse`](#type-rpcresponse), allowWithoutProof :`boolean`, ctx :[`ChainContext`](#type-chaincontext)) :`Promise<boolean>` - General verification function which handles it according to its given type.



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


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L255)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L257)**(client :[`Client`](#type-client)) :[`EthAPI`](#type-ethapi) 

* **[client](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L256)** :[`Client`](#type-client) - Client for N3.

* **[signer](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L257)** :[`Signer`](#type-signer) *(optional)*  

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L272)**() :`Promise<number>` - Returns the number of most recent block (as number).

* **[call](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L285)**(tx :[`Transaction`](#type-transaction), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Executes a new message call immediately without creating a transaction on the blockchain.

* **[callFn](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L292)**(to :[`Address`](#type-address), method :`string`, args :`any`[]) :`Promise<any>` - Executes a function of a contract by passing a [method-signature](https://github.com/ethereumjs/ethereumjs-abi/blob/master/README.md#simple-encoding-and-decoding) and the arguments, which will then be ABI-encoded and sent as eth_call.

* **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L300)**() :`Promise<string>` - Returns the EIP155 chain ID used for transaction signing at the current best block. Null is returned if not available.

* **[contractAt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L592)**(abi :[`ABI`](#type-abi)[], address :[`Address`](#type-address)) : 

* **[decodeEventData](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L673)**(log :[`Log`](#type-log), d :[`ABI`](#type-abi)) :`any` 

* **[estimateGas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L307)**(tx :[`Transaction`](#type-transaction)) :`Promise<number>` - Makes a call or transaction, which won’t be added to the blockchain and returns the used gas, which can be used for estimating the used gas.

* **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L278)**() :`Promise<number>` - Returns the current price per gas in wei (as number).

* **[getBalance](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L314)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :[`Promise<BN>`](#type-bn) - Returns the balance of the account of given address in wei (as hexstring).

* **[getBlockByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L337)**(hash :[`Hash`](#type-hash), includeTransactions :`boolean` = false) :[`Promise<Block>`](#type-block) - Returns information about a block by hash.

* **[getBlockByNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L344)**(block :[`BlockType`](#type-blocktype) = "latest", includeTransactions :`boolean` = false) :[`Promise<Block>`](#type-block) - Returns information about a block by block number.

* **[getBlockTransactionCountByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L352)**(block :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of transactions in a block from a block matching the given block hash.

* **[getBlockTransactionCountByNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L360)**(block :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of transactions in a block from a block matching the given block number.

* **[getCode](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L321)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Returns code at a given address.

* **[getFilterChanges](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L367)**(id :[`Quantity`](#type-quantity)) :`Promise<>` - Polling method for a filter, which returns an array of logs that have occurred since last poll.

* **[getFilterLogs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L374)**(id :[`Quantity`](#type-quantity)) :`Promise<>` - Returns an array of all logs matching filter with given ID.

* **[getLogs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L381)**(filter :[`LogFilter`](#type-logfilter)) :`Promise<>` - Returns an array of all logs matching a given filter object.

* **[getStorageAt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L329)**(address :[`Address`](#type-address), pos :[`Quantity`](#type-quantity), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Returns the value from a storage position at a given address.

* **[getTransactionByBlockHashAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L394)**(hash :[`Hash`](#type-hash), pos :[`Quantity`](#type-quantity)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns information about a transaction by block hash and transaction index position.

* **[getTransactionByBlockNumberAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L402)**(block :[`BlockType`](#type-blocktype), pos :[`Quantity`](#type-quantity)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns information about a transaction by block number and transaction index position.

* **[getTransactionByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L409)**(hash :[`Hash`](#type-hash)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns the information about a transaction requested by transaction hash.

* **[getTransactionCount](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L416)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<number>` - Returns the number of transactions sent from an address as a number.

* **[getTransactionReceipt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L424)**(hash :[`Hash`](#type-hash)) :[`Promise<TransactionReceipt>`](#type-transactionreceipt) - Returns the receipt of a transaction by transaction hash.
    Note: The receipt is available even for pending transactions.

* **[getUncleByBlockHashAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L436)**(hash :[`Hash`](#type-hash), pos :[`Quantity`](#type-quantity)) :[`Promise<Block>`](#type-block) - Returns information about an uncle of a block by hash and uncle index position.
    Note: An uncle doesn’t contain individual transactions.

* **[getUncleByBlockNumberAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L445)**(block :[`BlockType`](#type-blocktype), pos :[`Quantity`](#type-quantity)) :[`Promise<Block>`](#type-block) - Returns information about a uncle of a block number and uncle index position.
    Note: An uncle doesn’t contain individual transactions.

* **[getUncleCountByBlockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L452)**(hash :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of uncles in a block from a block matching the given block hash.

* **[getUncleCountByBlockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L459)**(block :[`BlockType`](#type-blocktype)) :`Promise<number>` - Returns the number of uncles in a block from a block matching the given block hash.

* **[hashMessage](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L676)**(data :[`Data`](#type-data)|[`Buffer`](#type-buffer)) :[`Buffer`](#type-buffer) 

* **[newBlockFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L467)**() :`Promise<string>` - Creates a filter in the node to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges.

* **[newFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L484)**(filter :[`LogFilter`](#type-logfilter)) :`Promise<string>` - Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges.

* **[newPendingTransactionFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L493)**() :`Promise<string>` - Creates a filter in the node to notify when new pending transactions arrive.

* **[protocolVersion](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L508)**() :`Promise<string>` - Returns the current ethereum protocol version.

* **[sendRawTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L537)**(data :[`Data`](#type-data)) :`Promise<string>` - Creates new message call transaction or a contract creation for signed transactions.

* **[sendTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L564)**(args :[`TxRequest`](#type-txrequest)) :`Promise<>` - Sends a transaction

* **[sign](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L546)**(account :[`Address`](#type-address), data :[`Data`](#type-data)) :[`Promise<Signature>`](#type-signature) - Signs any kind of message using the `\x19Ethereum Signed Message:\n`-prefix.

* **[syncing](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L515)**() :`Promise<>` - Returns the current ethereum protocol version.

* **[uninstallFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L501)**(id :[`Quantity`](#type-quantity)) :[`Promise<Quantity>`](#type-quantity) - Uninstalls a filter with given ID. Should always be called when watch is no longer needed. Additonally, filters timeout when they aren’t requested with eth_getFilterChanges for a period of time.


### Type AuthSpec


Authority specification for proof of authority chains


Source: [modules/eth/header.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L13)



* **[authorities](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L15)** :[`Buffer`](#type-buffer)[] - List of validator addresses stored as a buffer array.

* **[proposer](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L19)** :[`Buffer`](#type-buffer) - Proposer of the block this authspec belongs.

* **[spec](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L17)** :[`ChainSpec`](#type-chainspec) - Chain specification.


### Type Block


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L130)



* **[Block](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L130)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[sealFields](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L172)** :[`Data`](#type-data)[] - PoA-Fields

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[transactions](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L168)** :`string`|[] - Array of transaction objects, or 32 byte transaction hashes depending on the last given parameter.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[uncles](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L170)** :[`Hash`](#type-hash)[] - Array of uncle hashes.


### Type AccountData


Account-object


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L90)



* **[balance](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L92)** :`string` 

* **[code](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L95)** :`string` *(optional)*  

* **[codeHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L94)** :`string` 

* **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L91)** :`string` 

* **[storageHash](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L93)** :`string` 


### Type Transaction


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L41)



* **[Transaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L41)**

    * **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L57)** :`any` *(optional)*  - Optional chain ID.

    * **[data](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L53)** :`string` - A 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 


### Type Receipt


Buffer[] of the Receipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L36)



* **[Receipt](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L36)** : - Buffer[] of the Receipt


### Type Account


Buffer[] of the Account


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L33)



* **[Account](https://github.com/slockit/in3/blob/master/src/modules/eth/serialize.ts#L33)** :[`Buffer`](#type-buffer)[] - Buffer[] of the Account


### Type Signer


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L243)



* **[prepareTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L245)** *(optional)*  - Optional method which allows for a change in transaction data before sending it. This can be used for redirecting it through a multisig.

* **[sign](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L251)** - Signing of any data.

* **[hasAccount](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L248)**(account :[`Address`](#type-address)) :`Promise<boolean>` - Returns true if the account is supported or unlocked.


### Type BlockType


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L9)



* **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L9)** :`number`|`'latest'`|`'earliest'`|`'pending'` 


### Type Address


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L13)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 


### Type ABI


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L30)



* **[ABI](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L30)**

    * **[anonymous](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L31)** :`boolean` *(optional)*  

    * **[constant](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L32)** :`boolean` *(optional)*  

    * **[inputs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L36)** :[`ABIField`](#type-abifield)[] *(optional)*  

    * **[name](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L38)** :`string` *(optional)*  

    * **[outputs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L37)** :[`ABIField`](#type-abifield)[] *(optional)*  

    * **[payable](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L33)** :`boolean` *(optional)*  

    * **[stateMutability](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L34)** :`'nonpayable'`|`'payable'`|`'view'`|`'pure'` *(optional)*  

    * **[type](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L39)** :`'event'`|`'function'`|`'constructor'`|`'fallback'` 


### Type Log


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L174)



* **[Log](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L174)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[removed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L176)** :`boolean` - True if the log was removed, due to a chain reorganization. False if its a valid log.

    * **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L192)** :[`Data`](#type-data)[] - - Array of 0 to 4 32 bytes of data of the indexed log arguments. In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 


### Type Hash


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L12)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 


### Type Quantity


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)



* **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 


### Type LogFilter


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L195)



* **[LogFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L195)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L9)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L9)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L203)** :`string`|`string`[][] - (Optional) Array of 32 bytes data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching.


### Type TransactionDetail


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L87)



* **[TransactionDetail](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L87)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L9)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[condition](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L125)** :`any` - (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature)

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[pk](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L127)** :`any` *(optional)*  - optional: the private key to use for signing

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 


### Type TransactionReceipt


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L59)



* **[TransactionReceipt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L59)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L9)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[logs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L75)** :[`Log`](#type-log)[] - Array of log objects which this transaction generated.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 


### Type Data


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L14)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 


### Type TxRequest


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L208)



* **[TxRequest](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L208)**

    * **[args](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L234)** :`any`[] *(optional)*  - The argument to pass to the method.

    * **[confirmations](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L240)** :`number` *(optional)*  - Number of blocks to wait before confirming.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[gas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L219)** :`number` *(optional)*  - The gas needed.

    * **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L222)** :`number` *(optional)*  - The gas price used.

    * **[method](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L231)** :`string` *(optional)*  - The ABI of the method to be used.

    * **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L225)** :`number` *(optional)*  - The nonce.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L11)** :`number`|[`Hex`](#type-hex) 


### Type Hex


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L10)** :`string` 


### Type ABIField


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L25)



* **[ABIField](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L25)**

    * **[indexed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L26)** :`boolean` *(optional)*  

    * **[name](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L27)** :`string` 

    * **[type](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L28)** :`string` 



## Package modules/ipfs


### Type IpfsAPI


Simple API for IPFS


Source: [modules/ipfs/api.ts](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L6)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L7)**(_client :[`Client`](#type-client)) :[`IpfsAPI`](#type-ipfsapi) 

* **[client](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L7)** :[`Client`](#type-client) - Client for Incubed.

* **[get](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L19)**(hash :`string`, resultEncoding :`string`) :[`Promise<Buffer>`](#type-buffer) - Retrieves the content for a hash from IPFS.

* **[put](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L30)**(data :[`Buffer`](#type-buffer), dataEncoding :`string`) :`Promise<string>` - Stores the data on IPFS and returns the IPFS-hash.



## Package Types


### Type AccountProof


The Proof for a Single Account


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L6)



* **[accountProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L10)** :`string`[] - The serialized merkle-nodes beginning with the root-node.

* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L14)** :`string` - The address of this account.

* **[balance](https://github.com/slockit/in3/blob/master/src/types/types.ts#L18)** :`string` - The balance of this account as hex.

* **[code](https://github.com/slockit/in3/blob/master/src/types/types.ts#L26)** :`string` *(optional)*  - The code of this account as hex (if required).

* **[codeHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L22)** :`string` - The codeHash of this account as hex.

* **[nonce](https://github.com/slockit/in3/blob/master/src/types/types.ts#L30)** :`string` - The nonce of this account as hex.

* **[storageHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L34)** :`string` - The storageHash of this account as hex.

* **[storageProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L38)** :[] - Proof for requested storage data.


### Type AuraValidatoryProof


An object holding proofs for validator logs. The key is the block number as hex.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L56)



* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L65)** :`string` - The serialized blockheader.
    Example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3/blob/master/src/types/types.ts#L78)** :`any`[] *(optional)*  - The serialized blockheader as hex. Required in case of finality asked.
    Example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L60)** :`number` - The transaction log index.

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L73)** :`string`[] - The Merkle proof.

* **[txIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L69)** :`number` - the transaction index within the block.


### Type ChainSpec


Describes the chain-specific consensus parameters.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L83)



* **[engine](https://github.com/slockit/in3/blob/master/src/types/types.ts#L87)** :`string` *(optional)*  - The engine type (like Ethhash, authorityRound, ... ).

* **[validatorContract](https://github.com/slockit/in3/blob/master/src/types/types.ts#L91)** :`string` *(optional)*  - The aura contract to get the validators.

* **[validatorList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L95)** :`any`[] *(optional)*  - The list of validators.


### Type IN3Config


The configuration of the IN3-client. This can be partially overridden for every request.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L100)



* **[autoConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L127)** :`boolean` *(optional)*  - If true, the configuration will be adjusted depending on the request.

* **[autoUpdateList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L209)** :`boolean` *(optional)*  - If true, the node list will be automatically updated if the last block is newer.
    example: true

* **[cacheStorage](https://github.com/slockit/in3/blob/master/src/types/types.ts#L213)** :`any` *(optional)*  - A cache handler offering 2 functions (setItem (string,string), getItem(string)).

* **[cacheTimeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L104)** :`number` *(optional)*  - Number of second requests can be cached.

* **[chainId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L194)** :`string` - Servers to filter for the given chain. The chain-ID based on EIP-155.
    Example: 0x1

* **[chainRegistry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L199)** :`string` *(optional)*  - Main chain-registry contract.
    Example: 0xe36179e2286ef405e929C90ad3E70E649B22a945

* **[finality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L184)** :`number` *(optional)*  - The number in percent needed in order reach finality (% of signature of the validators).
    Example: 50

* **[format](https://github.com/slockit/in3/blob/master/src/types/types.ts#L118)** :`'json'`|`'jsonRef'`|`'cbor'` *(optional)*  - The format for sending the data to the client. Default is JSON, but using CBOR means using only 30-40% of the payload since it is using binary encoding.
    Example: JSON

* **[includeCode](https://github.com/slockit/in3/blob/master/src/types/types.ts#L141)** :`boolean` *(optional)*  - If true, the request should include the codes of all accounts, otherwise, only the codeHash is returned. In this case, the client may ask by calling eth_getCode() afterwards.
    Example: true

* **[keepIn3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L113)** :`boolean` *(optional)*  - If true, the IN3-section of the response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.

* **[key](https://github.com/slockit/in3/blob/master/src/types/types.ts#L123)** :`any` *(optional)*  - The client key to sign requests.
    Example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7

* **[loggerUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L217)** :`string` *(optional)*  - A URL of RES-endpoint the client will log all errors to. The client will post to this endpoint JSON like {ID?, level, message, meta?}.

* **[mainChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L204)** :`string` *(optional)*  - Main chain-ID where the chain registry is running.
    Example: 0x1

* **[maxAttempts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L136)** :`number` *(optional)*  - Max number of attempts in case a response is rejected.
    Example: 10

* **[maxBlockCache](https://github.com/slockit/in3/blob/master/src/types/types.ts#L151)** :`number` *(optional)*  - Number of blocks cached in memory.
    Example: 100

* **[maxCodeCache](https://github.com/slockit/in3/blob/master/src/types/types.ts#L146)** :`number` *(optional)*  - Number of max bytes used to cache the code in memory.
    Example: 100000

* **[minDeposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L169)** :`number` - Minimum stake of the server. Only nodes owning at least this amount will be chosen.

* **[nodeLimit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L109)** :`number` *(optional)*  - The limit of nodes to store in the client.
    Example: 150

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L160)** :`'none'`|`'standard'`|`'full'` *(optional)*  - If true, the nodes should send a proof of the response.
    Example: true

* **[replaceLatestBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L174)** :`number` *(optional)*  - If specified, the *latest* block number will be replaced by a block number-specific value.
    Example: 6

* **[requestCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L179)** :`number` - The number of request sent when getting a first answer.
    Example: 3

* **[retryWithoutProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L131)** :`boolean` *(optional)*  - If true, the  request may be handled without proof in case of an error. (Use with care!)

* **[rpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L221)** :`string` *(optional)*  - URL of one or more RPC-endpoints to use. (List can be comma seperated.)

* **[servers](https://github.com/slockit/in3/blob/master/src/types/types.ts#L225)** *(optional)*  - The node list per chain.

* **[signatureCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L165)** :`number` *(optional)*  - Number of signatures requested.
    Example: 2

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L189)** :`number` *(optional)*  - Specifies the number of milliseconds before the request times out. Increasing may be helpful if the device uses a slow connection.
    Example: 3000

* **[verifiedHashes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L155)** :`string`[] *(optional)*  - If the client sends an array of block hashes, the server will not deliver any signatures or blockheaders for these blocks. Instead, it will only return a string with a number. This is automatically updated by the cache, but can be overriden per request.


### Type IN3NodeConfig


A configuration of an IN3-server.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L284)



* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L294)** :`string` - The address of the node, which is the public address it is signing with.
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[capacity](https://github.com/slockit/in3/blob/master/src/types/types.ts#L319)** :`number` *(optional)*  - The capacity of the node.
    Example: 100

* **[chainIds](https://github.com/slockit/in3/blob/master/src/types/types.ts#L309)** :`string`[] - The list of supported chains.
    Example: 0x1

* **[deposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L314)** :`number` - The deposit of the node in wei.
    Example: 12350000

* **[index](https://github.com/slockit/in3/blob/master/src/types/types.ts#L289)** :`number` *(optional)*  - The index within the contract.
    Example: 13

* **[props](https://github.com/slockit/in3/blob/master/src/types/types.ts#L324)** :`number` *(optional)*  - The properties of the node.
    Example: 3

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L299)** :`number` *(optional)*  - The time (in seconds) until an owner is able to receive their deposit back after they unregister themselves.
    Example: 3600

* **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L304)** :`string` - The endpoint of the post.
    Example: https://in3.slock.it


### Type IN3NodeWeight


The local weight of an Incubed node. (This is used internally to weigh the requests.)


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L329)



* **[avgResponseTime](https://github.com/slockit/in3/blob/master/src/types/types.ts#L344)** :`number` *(optional)*  - Average time of a response in milliseconds
    Example: 240

* **[blacklistedUntil](https://github.com/slockit/in3/blob/master/src/types/types.ts#L358)** :`number` *(optional)*  - Blacklisted because of failed requests until it's timestamped.
    Example: 1529074639623

* **[lastRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L353)** :`number` *(optional)*  - Timestamp of the last request in milliseconds.
    Example: 1529074632623

* **[pricePerRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L348)** :`number` *(optional)*  - Last price.

* **[responseCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L339)** :`number` *(optional)*  - Number of uses.
    Example: 147

* **[weight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L334)** :`number` *(optional)*  - Factor the weight this noe (default 1.0).
    Example: 0.5


### Type IN3RPCConfig


The configuration for the RPC-handler.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L363)



* **[chains](https://github.com/slockit/in3/blob/master/src/types/types.ts#L456)** *(optional)*  - A definition of the handler per chain.

* **[db](https://github.com/slockit/in3/blob/master/src/types/types.ts#L376)** *(optional)* 

    * **[database](https://github.com/slockit/in3/blob/master/src/types/types.ts#L396)** :`string` *(optional)*  - Name of the database.

    * **[host](https://github.com/slockit/in3/blob/master/src/types/types.ts#L388)** :`string` *(optional)*  - Db-host (default = localhost).

    * **[password](https://github.com/slockit/in3/blob/master/src/types/types.ts#L384)** :`string` *(optional)*  - Password for db-access.

    * **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L392)** :`number` *(optional)*  - The database port.

    * **[user](https://github.com/slockit/in3/blob/master/src/types/types.ts#L380)** :`string` *(optional)*  - Username for the db.

* **[defaultChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L371)** :`string` *(optional)*  - The default chain ID in case the request does not contain one.

* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L367)** :`string` *(optional)*  - An identifier used in logfiles for reading the configuration from the database.

* **[logging](https://github.com/slockit/in3/blob/master/src/types/types.ts#L423)** *(optional)*  - Logger configuration.

    * **[colors](https://github.com/slockit/in3/blob/master/src/types/types.ts#L435)** :`boolean` *(optional)*  - If true colors will be used.

    * **[file](https://github.com/slockit/in3/blob/master/src/types/types.ts#L427)** :`string` *(optional)*  - The path to the logile.

    * **[host](https://github.com/slockit/in3/blob/master/src/types/types.ts#L451)** :`string` *(optional)*  - The host for custom logging.

    * **[level](https://github.com/slockit/in3/blob/master/src/types/types.ts#L431)** :`string` *(optional)*  - Loglevel.

    * **[name](https://github.com/slockit/in3/blob/master/src/types/types.ts#L439)** :`string` *(optional)*  - The name of the provider.

    * **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L447)** :`number` *(optional)*  - The port for custom logging.

    * **[type](https://github.com/slockit/in3/blob/master/src/types/types.ts#L443)** :`string` *(optional)*  - The module of the provider.

* **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L375)** :`number` *(optional)*  - The listeneing port for the server.

* **[profile](https://github.com/slockit/in3/blob/master/src/types/types.ts#L398)** *(optional)* 

    * **[comment](https://github.com/slockit/in3/blob/master/src/types/types.ts#L414)** :`string` *(optional)*  - Comments for the node.

    * **[icon](https://github.com/slockit/in3/blob/master/src/types/types.ts#L402)** :`string` *(optional)*  - URL to an icon or logo of company offering this node.

    * **[name](https://github.com/slockit/in3/blob/master/src/types/types.ts#L410)** :`string` *(optional)*  - Name of the node or company.

    * **[noStats](https://github.com/slockit/in3/blob/master/src/types/types.ts#L418)** :`boolean` *(optional)*  - If active, the stats will not be shown (default:false).

    * **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L406)** :`string` *(optional)*  - URL of the website of the company.


### Type IN3RPCHandlerConfig


The configuration for the RPC-handler.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L463)



* **[autoRegistry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L528)** *(optional)* 

    * **[capabilities](https://github.com/slockit/in3/blob/master/src/types/types.ts#L545)** *(optional)* 

        * **[multiChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L553)** :`boolean` *(optional)*  - If true, this node is able to deliver multiple chains.

        * **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L549)** :`boolean` *(optional)*  - If true, this node is able to deliver proofs.

    * **[capacity](https://github.com/slockit/in3/blob/master/src/types/types.ts#L540)** :`number` *(optional)*  - Max number of parallel requests.

    * **[deposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L536)** :`number` - The deposit you want to store.

    * **[depositUnit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L544)** :`'ether'`|`'finney'`|`'szabo'`|`'wei'` *(optional)*  - Unit of the deposit value.

    * **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L532)** :`string` - The public URL to reach this node.

* **[clientKeys](https://github.com/slockit/in3/blob/master/src/types/types.ts#L483)** :`string` *(optional)*  - A comma sepearted list of client keys to use for simulating clients for the watchdog.

* **[freeScore](https://github.com/slockit/in3/blob/master/src/types/types.ts#L491)** :`number` *(optional)*  - The score for requests without a valid signature.

* **[handler](https://github.com/slockit/in3/blob/master/src/types/types.ts#L467)** :`'eth'`|`'ipfs'`|`'btc'` *(optional)*  - The impl used to handle the calls.

* **[ipfsUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L471)** :`string` *(optional)*  - The URL of the ipfs-client.

* **[maxThreads](https://github.com/slockit/in3/blob/master/src/types/types.ts#L499)** :`number` *(optional)*  - The maximal number of threads running parallel to the processes.

* **[minBlockHeight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L495)** :`number` *(optional)*  - The minimal block height in order to sign.

* **[persistentFile](https://github.com/slockit/in3/blob/master/src/types/types.ts#L503)** :`string` *(optional)*  - The file name of the file keeping track of the last handled block number.

* **[privateKey](https://github.com/slockit/in3/blob/master/src/types/types.ts#L515)** :`string` - The private key used to sign blockhashes. This can be either a 0x-prefixed string with the raw private key or the path to a key-file.

* **[privateKeyPassphrase](https://github.com/slockit/in3/blob/master/src/types/types.ts#L519)** :`string` *(optional)*  - The password used to decrpyt the private key.

* **[registry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L523)** :`string` - The address of the server registry used in order to update the node list.

* **[registryRPC](https://github.com/slockit/in3/blob/master/src/types/types.ts#L527)** :`string` *(optional)*  - The URL of the client in case the registry is not on the same chain.

* **[rpcUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L479)** :`string` - The URL of the client.

* **[startBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L507)** :`number` *(optional)*  - Blocknumber to start watching the registry.

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L475)** :`number` *(optional)*  - Number of milliseconds to wait before a request is timed out.

* **[watchInterval](https://github.com/slockit/in3/blob/master/src/types/types.ts#L511)** :`number` *(optional)*  - The number of seconds of the interval for checking for new events.

* **[watchdogInterval](https://github.com/slockit/in3/blob/master/src/types/types.ts#L487)** :`number` *(optional)*  - Average time between sending requests to the same node. 0 turns it off (default).


### Type IN3RPCRequestConfig


Additional configuration for an Incubed RPC-request.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L560)



* **[chainId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L565)** :`string` - The requested chain ID.
    Example: 0x1

* **[clientSignature](https://github.com/slockit/in3/blob/master/src/types/types.ts#L604)** :`any` *(optional)*  - The signature of the client.

* **[finality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L595)** :`number` *(optional)*  - If given, the server will deliver the blockheaders of the following blocks until (at least) the number in percent of the validators is reached.

* **[includeCode](https://github.com/slockit/in3/blob/master/src/types/types.ts#L570)** :`boolean` *(optional)*  - If true, the request should include the codes of all accounts. Otherwise, only the the codeHash is returned. In this case, the client may ask by calling eth_getCode() afterwards.
    Example: true

* **[latestBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L579)** :`number` *(optional)*  - If specified, the *latest* block number will be replaced by block number-specific value.
    Example: 6

* **[signatures](https://github.com/slockit/in3/blob/master/src/types/types.ts#L609)** :`string`[] *(optional)*  - A list of addresses requested to sign the blockhash.
    Example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[useBinary](https://github.com/slockit/in3/blob/master/src/types/types.ts#L587)** :`boolean` *(optional)*  - If true, binary data will be used.

* **[useFullProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L591)** :`boolean` *(optional)*  - If true, all data in the response will be proven, which leads to a higher payload.

* **[useRef](https://github.com/slockit/in3/blob/master/src/types/types.ts#L583)** :`boolean` *(optional)*  - If true, binary-data (starting with a 0x) will be refered if occuring again.

* **[verification](https://github.com/slockit/in3/blob/master/src/types/types.ts#L600)** :`'never'`|`'proof'`|`'proofWithSignature'` *(optional)*  - Defines the kind of proof the client is asking for.
    Example: proof

* **[verifiedHashes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L574)** :`string`[] *(optional)*  - If the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks. Instead, it will only return a string with a number.


### Type IN3ResponseConfig


Additional data returned from an Incubed server.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L614)



* **[currentBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L632)** :`number` *(optional)*  - The current blocknumber.
    Example: 320126478

* **[lastNodeList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L623)** :`number` *(optional)*  - The blocknumber for the last block updating the node list. If the client has a smaller blocknumber, they should update the node list.
    Example: 326478

* **[lastValidatorChange](https://github.com/slockit/in3/blob/master/src/types/types.ts#L627)** :`number` *(optional)*  - The blocknumber of the last change of the validator list.

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L618)** :[`Proof`](#type-proof) *(optional)*  - The proof data.


### Type LogProof


An object holding proofs for event logs. The key is the blocknumber as hex.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L637)




### Type Proof


The proof data as part of the IN3-section.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L680)



* **[accounts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L725)** *(optional)*  - A map of addresses and their account proof.

* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L690)** :`string` *(optional)*  - The serialized blockheader as hex. Required in most proofs.
    Example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3/blob/master/src/types/types.ts#L695)** :`any`[] *(optional)*  - The serialized blockheader as hex. Required in case of finality asked.
    Example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L721)** :[`LogProof`](#type-logproof) *(optional)*  - The log proof in case of a log request.

* **[merkleProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L709)** :`string`[] *(optional)*  - The serialized merle-nodes beginning with the root-node.

* **[merkleProofPrev](https://github.com/slockit/in3/blob/master/src/types/types.ts#L713)** :`string`[] *(optional)*  - The serialized merkle-noodes beginning with the root-node of the previous entry (only for full proof of receipts).

* **[signatures](https://github.com/slockit/in3/blob/master/src/types/types.ts#L736)** :[`Signature`](#type-signature)[] *(optional)*  - Requested signatures.

* **[transactions](https://github.com/slockit/in3/blob/master/src/types/types.ts#L700)** :`any`[] *(optional)*  - The list of transactions of the block.
    Example:

* **[txIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L732)** :`number` *(optional)*  - The transaction index within the block.
    Example: 4

* **[txProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L717)** :`string`[] *(optional)*  - The serialized merkle-nodes beginning with the root-node in order to proof the transaction index.

* **[type](https://github.com/slockit/in3/blob/master/src/types/types.ts#L685)** :`'transactionProof'`|`'receiptProof'`|`'blockProof'`|`'accountProof'`|`'callProof'`|`'logProof'` - The type of the proof.
    Example: accountProof

* **[uncles](https://github.com/slockit/in3/blob/master/src/types/types.ts#L705)** :`any`[] *(optional)*  - The list of uncle-headers of the block.
    Example:


### Type RPCRequest


a JSONRPC-Request with IN3-Extension


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L741)



* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L755)** :`number`|`string` *(optional)*  - The identifier of the request.
    Example: 2

* **[in3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L764)** :[`IN3RPCRequestConfig`](#type-in3rpcrequestconfig) *(optional)*  - The IN3-configuration.

* **[jsonrpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L745)** :`'2.0'` - The version.

* **[method](https://github.com/slockit/in3/blob/master/src/types/types.ts#L750)** :`string` - The method to call.
    Example: eth_getBalance

* **[params](https://github.com/slockit/in3/blob/master/src/types/types.ts#L760)** :`any`[] *(optional)*  - The parameters.
    Example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest


### Type RPCResponse


a JSONRPC-Responset with IN3-Extension


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L769)



* **[error](https://github.com/slockit/in3/blob/master/src/types/types.ts#L782)** :`string` *(optional)*  - In case of an error, this needs to be set.

* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L778)** :`string`|`number` - The ID matching the request.
    Example: 2

* **[in3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L791)** :[`IN3ResponseConfig`](#type-in3responseconfig) *(optional)*  - The IN3-result.

* **[in3Node](https://github.com/slockit/in3/blob/master/src/types/types.ts#L795)** :[`IN3NodeConfig`](#type-in3nodeconfig) *(optional)*  - The node handling this response (internal only).

* **[jsonrpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L773)** :`'2.0'` - The version.

* **[result](https://github.com/slockit/in3/blob/master/src/types/types.ts#L787)** :`any` *(optional)*  - The parameters.
    Example: 0xa35bc


### Type ServerList


A List of Nodes


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L800)



* **[contract](https://github.com/slockit/in3/blob/master/src/types/types.ts#L812)** :`string` *(optional)*  - Incubed registry.

* **[lastBlockNumber](https://github.com/slockit/in3/blob/master/src/types/types.ts#L804)** :`number` *(optional)*  - Last block number.

* **[nodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L808)** :[`IN3NodeConfig`](#type-in3nodeconfig)[] - The list of nodes.

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L817)** :[`Proof`](#type-proof) *(optional)*  - The proof-data as part of the IN3-section.

* **[totalServers](https://github.com/slockit/in3/blob/master/src/types/types.ts#L816)** :`number` *(optional)*  - Number of servers.


### Type Signature


Verified ECDSA Signature. Signatures are a pair (r, s), where r is computed as the X coordinate of a point R, modulo the curve order n.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L822)



* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L827)** :`string` *(optional)*  - The address of the signing node.
    Example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L832)** :`number` - The block number.
    Example: 3123874

* **[blockHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L837)** :`string` - The hash of the block.
    Example: 0x6C1a01C2aB554930A937B0a212346037E8105fB47946c679

* **[msgHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L842)** :`string` - Hash of the message.
    Example: 0x9C1a01C2aB554930A937B0a212346037E8105fB47946AB5D

* **[r](https://github.com/slockit/in3/blob/master/src/types/types.ts#L847)** :`string` - Positive non-zero integer signature.r
    Example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1f

* **[s](https://github.com/slockit/in3/blob/master/src/types/types.ts#L852)** :`string` - Positive non-zero integer signature.s
    Example: 0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda

* **[v](https://github.com/slockit/in3/blob/master/src/types/types.ts#L857)** :`number` - Calculated curve point, or identity element O.
    Example: 28



## Package util

A collection of utility classes inside Incubed. They can be put directly through `require('in3/js/srrc/util/util')`


### Type Transport


A transport-object responsible for transporting the message to the handler.


Source: [util/transport.ts](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L27)



* **[handle](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L31)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` - Handles a request by passing the data to the handler.

* **[isOnline](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L36)**() :`Promise<boolean>` - Checks whether the handler is onlne.

* **[random](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L41)**(count :`number`) :`number`[] - Generates random numbers (between 0-1).


### Type AxiosTransport


Default transport IMPL sending http-requests.


Source: [util/transport.ts](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L49)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L51)**(format :`'json'`|`'jsonRef'`|`'cbor'` = "json") :[`AxiosTransport`](#type-axiostransport) 

* **[format](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L51)** :`'json'`|`'jsonRef'`|`'cbor'` 

* **[handle](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L61)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` 

* **[isOnline](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L57)**() :`Promise<boolean>` 

* **[random](https://github.com/slockit/in3/blob/master/src/util/transport.ts#L90)**(count :`number`) :`number`[] 


### Type BN


Source: [util/util.ts](https://github.com/slockit/in3/blob/master/src/util/util.ts#L26)




