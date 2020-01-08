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

* **[ABI](https://github.com/slockit/in3/blob/master/src/index.ts#L95)** :[`_ethapi.ABI`](#type-_ethapi.abi) 

* [**AccountProof**](#type-accountproof) : `interface`  - the Proof-for a single Account

* [**AuraValidatoryProof**](#type-auravalidatoryproof) : `interface`  - a Object holding proofs for validator logs. The key is the blockNumber as hex

* **[BlockData](https://github.com/slockit/in3/blob/master/src/index.ts#L86)** :[`_serialize.BlockData`](#type-_serialize.blockdata) 

* **[BlockType](https://github.com/slockit/in3/blob/master/src/index.ts#L96)** :[`_ethapi.BlockType`](#type-_ethapi.blocktype) 

* [**ChainSpec**](#type-chainspec) : `interface`  - describes the chainspecific consensus params

* [**IN3Client**](#type-client) : `class`  - Client for N3.

* [**IN3Config**](#type-in3config) : `interface`  - the iguration of the IN3-Client. This can be paritally overriden for every request.

* [**IN3NodeConfig**](#type-in3nodeconfig) : `interface`  - a configuration of a in3-server.

* [**IN3NodeWeight**](#type-in3nodeweight) : `interface`  - a local weight of a n3-node. (This is used internally to weight the requests)

* [**IN3RPCConfig**](#type-in3rpcconfig) : `interface`  - the configuration for the rpc-handler

* [**IN3RPCHandlerConfig**](#type-in3rpchandlerconfig) : `interface`  - the configuration for the rpc-handler

* [**IN3RPCRequestConfig**](#type-in3rpcrequestconfig) : `interface`  - additional config for a IN3 RPC-Request

* [**IN3ResponseConfig**](#type-in3responseconfig) : `interface`  - additional data returned from a IN3 Server

* **[Log](https://github.com/slockit/in3/blob/master/src/index.ts#L97)** :[`_ethapi.Log`](#type-_ethapi.log) 

* **[LogData](https://github.com/slockit/in3/blob/master/src/index.ts#L87)** :[`_serialize.LogData`](#type-_serialize.logdata) 

* [**LogProof**](#type-logproof) : `interface`  - a Object holding proofs for event logs. The key is the blockNumber as hex

* [**Proof**](#type-proof) : `interface`  - the Proof-data as part of the in3-section

* [**RPCRequest**](#type-rpcrequest) : `interface`  - a JSONRPC-Request with N3-Extension

* [**RPCResponse**](#type-rpcresponse) : `interface`  - a JSONRPC-Responset with N3-Extension

* **[ReceiptData](https://github.com/slockit/in3/blob/master/src/index.ts#L88)** :[`_serialize.ReceiptData`](#type-_serialize.receiptdata) 

* [**ServerList**](#type-serverlist) : `interface`  - a List of nodes

* [**Signature**](#type-signature) : `interface`  - Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.

* **[Transaction](https://github.com/slockit/in3/blob/master/src/index.ts#L99)** :[`_ethapi.Transaction`](#type-_ethapi.transaction) 

* **[TransactionData](https://github.com/slockit/in3/blob/master/src/index.ts#L89)** :[`_serialize.TransactionData`](#type-_serialize.transactiondata) 

* **[TransactionReceipt](https://github.com/slockit/in3/blob/master/src/index.ts#L98)** :[`_ethapi.TransactionReceipt`](#type-_ethapi.transactionreceipt) 

* **[Transport](https://github.com/slockit/in3/blob/master/src/index.ts#L84)** :[`_transporttype`](#type-_transporttype) 

* **[AxiosTransport](https://github.com/slockit/in3/blob/master/src/index.ts#L102)** :`any` 

* [**EthAPI**](#type-ethapi) : `class` 

* **[cbor](https://github.com/slockit/in3/blob/master/src/index.ts#L48)** :`any` 

* **[chainAliases](https://github.com/slockit/in3/blob/master/src/index.ts#L105)**

    * **[goerli](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L810)** :`string` 

    * **[ipfs](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L810)** :`string` 

    * **[kovan](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L810)** :`string` 

    * **[main](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L810)** :`string` 

    * **[mainnet](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L810)** :`string` 

    * **[tobalaba](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L810)** :`string` 

* **[chainData](https://github.com/slockit/in3/blob/master/src/index.ts#L64)**

    * **[callContract](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L42)**(client :[`Client`](#type-client), contract :`string`, chainId :`string`, signature :`string`, args :`any`[], config :[`IN3Config`](#type-in3config)) :`Promise<any>` 

    * **[getChainData](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L51)**(client :[`Client`](#type-client), chainId :`string`, config :[`IN3Config`](#type-in3config)) :`Promise<>` 

* **[createRandomIndexes](https://github.com/slockit/in3/blob/master/src/client/serverList.ts#L71)**(len :`number`, limit :`number`, seed :[`Buffer`](#type-buffer), result :`number`[] =  []) :`number`[] - helper function creating deterministic random indexes used for limited nodelists

* **[header](https://github.com/slockit/in3/blob/master/src/index.ts#L54)**

    * [**AuthSpec**](#type-authspec) :`interface` - Authority specification for proof of authority chains

    * **[checkBlockSignatures](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L60)**(blockHeaders :`any`[], getChainSpec :) :`Promise<number>` - verify a Blockheader and returns the percentage of finality

    * **[getChainSpec](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L263)**(b :[`Block`](#type-block), ctx :[`ChainContext`](#type-chaincontext)) :[`Promise<AuthSpec>`](#type-authspec) 

    * **[getSigner](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L109)**(data :[`Block`](#type-block)) :[`Buffer`](#type-buffer) 

* **[serialize](https://github.com/slockit/in3/blob/master/src/index.ts#L51)** :`any` 

* **[storage](https://github.com/slockit/in3/blob/master/src/index.ts#L57)** :`any` 

* **[transport](https://github.com/slockit/in3/blob/master/src/index.ts#L61)** :`any` 

* **[typeDefs](https://github.com/slockit/in3/blob/master/src/index.ts#L103)**

    * **[AccountProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[AuraValidatoryProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[ChainSpec](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[IN3Config](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[IN3NodeConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[IN3NodeWeight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[IN3RPCConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[IN3RPCHandlerConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[IN3RPCRequestConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[IN3ResponseConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[LogProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[Proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[RPCRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[RPCResponse](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[ServerList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


    * **[Signature](https://github.com/slockit/in3/blob/master/src/types/types.ts#L988)** : `Object`  


* **[util](https://github.com/slockit/in3/blob/master/src/index.ts#L36)** :`any` 

* **[validate](https://github.com/slockit/in3/blob/master/src/index.ts#L104)** :`any` 


## Package client


### Type Client


Client for N3.


Source: [client/Client.ts](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L69)



* **[defaultMaxListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L9)** :`number` 

* `static` **[listenerCount](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L8)**(emitter :[`EventEmitter`](#type-eventemitter), event :`string`|`symbol`) :`number` 

* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L80)**(config :[`Partial<IN3Config>`](#type-partial) =  {}, transport :[`Transport`](#type-transport)) :[`Client`](#type-client) - creates a new Client.

* **[defConfig](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L76)** :[`IN3Config`](#type-in3config) - the iguration of the IN3-Client. This can be paritally overriden for every request.

* **[eth](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L72)** :[`EthAPI`](#type-ethapi) 

* **[ipfs](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L73)** :[`IpfsAPI`](#type-ipfsapi) - simple API for IPFS

*  **config()** 

* **[addListener](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L11)**(event :`string`|`symbol`, listener :) :`this` 

* **[call](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L259)**(method :`string`, params :`any`, chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<any>` - sends a simply RPC-Request

* **[clearStats](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L311)**() :`void` - clears all stats and weights, like blocklisted nodes

* **[createWeb3Provider](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L127)**() :`any` 

* **[emit](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L23)**(event :`string`|`symbol`, args :`any`[]) :`boolean` 

* **[eventNames](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L24)**() :[`Array<>`](#type-array) 

* **[getChainContext](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L134)**(chainId :`string`) :[`ChainContext`](#type-chaincontext) 

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

* **[send](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L271)**(request :[`RPCRequest`](#type-rpcrequest)[]|[`RPCRequest`](#type-rpcrequest), callback :, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<>` - sends one or a multiple requests.
    if the request is a array the response will be a array as well.
    If the callback is given it will be called with the response, if not a Promise will be returned.
    This function supports callback so it can be used as a Provider for the web3.

* **[sendRPC](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L248)**(method :`string`, params :`any`[] =  [], chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :[`Promise<RPCResponse>`](#type-rpcresponse) - sends a simply RPC-Request

* **[setMaxListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L19)**(n :`number`) :`this` 

* **[updateNodeList](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L182)**(chainId :`string`, conf :[`Partial<IN3Config>`](#type-partial), retryCount :`number` = 5) :`Promise<void>` - fetches the nodeList from the servers.

* **[updateWhiteListNodes](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L155)**(config :[`IN3Config`](#type-in3config)) :`Promise<void>` 

* **[verifyResponse](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L298)**(request :[`RPCRequest`](#type-rpcrequest), response :[`RPCResponse`](#type-rpcresponse), chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<boolean>` - Verify the response of a request without any effect on the state of the client.
    Note: The node-list will not be updated.
    The method will either return `true` if its inputs could be verified.
     Or else, it will throw an exception with a helpful message.


### Type ChainContext


Context for a specific chain including cache and chainSpecs.


Source: [client/ChainContext.ts](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L42)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L49)**(client :[`Client`](#type-client), chainId :`string`, chainSpec :[`ChainSpec`](#type-chainspec)[]) :[`ChainContext`](#type-chaincontext) 

* **[chainId](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L46)** :`string` 

* **[chainSpec](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L44)** :[`ChainSpec`](#type-chainspec)[] 

* **[client](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L43)** :[`Client`](#type-client) - Client for N3.

* **[genericCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L48)**

* **[lastValidatorChange](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L47)** :`number` 

* **[module](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L45)** :[`Module`](#type-module) 

* **[registryId](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L49)** :`string` *(optional)*  

* **[clearCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L156)**(prefix :`string`) :`void` 

* **[getChainSpec](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L85)**(block :`number`) :[`ChainSpec`](#type-chainspec) - returns the chainspec for th given block number

* **[getFromCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L146)**(key :`string`) :`string` 

* **[handleIntern](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L78)**(request :[`RPCRequest`](#type-rpcrequest)) :[`Promise<RPCResponse>`](#type-rpcresponse) - this function is calleds before the server is asked.
    If it returns a promise than the request is handled internally otherwise the server will handle the response.
    this function should be overriden by modules that want to handle calls internally

* **[initCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L90)**() :`void` 

* **[putInCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L150)**(key :`string`, value :`string`) :`void` 

* **[updateCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L137)**(whiteList :[`Set<string>`](#type-set), whiteListContract :`string`) :`void` 


### Type Module


Source: [client/modules.ts](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L41)



* **[name](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L42)** :`string` 

* **[createChainContext](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L44)**(client :[`Client`](#type-client), chainId :`string`, spec :[`ChainSpec`](#type-chainspec)[]) :[`ChainContext`](#type-chaincontext) 

* **[verifyProof](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L46)**(request :[`RPCRequest`](#type-rpcrequest), response :[`RPCResponse`](#type-rpcresponse), allowWithoutProof :`boolean`, ctx :[`ChainContext`](#type-chaincontext)) :`Promise<boolean>` - general verification-function which handles it according to its given type.



## Package index.ts


### Type Transport


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L84)



* **[Transport](https://github.com/slockit/in3/blob/master/src/index.ts#L84)** :[`_transporttype`](#type-_transporttype) 



## Package modules/eth


### Type EthAPI


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L290)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L292)**(client :[`Client`](#type-client)) :[`EthAPI`](#type-ethapi) 

* **[client](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L291)** :[`Client`](#type-client) - Client for N3.

* **[signer](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L292)** :[`Signer`](#type-signer) *(optional)*  

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L307)**() :`Promise<number>` - Returns the number of most recent block. (as number)

* **[call](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L320)**(tx :[`Transaction`](#type-transaction), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Executes a new message call immediately without creating a transaction on the block chain.

* **[callFn](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L327)**(to :[`Address`](#type-address), method :`string`, args :`any`[]) :`Promise<any>` - Executes a function of a contract, by passing a [method-signature](https://github.com/ethereumjs/ethereumjs-abi/blob/master/README.md#simple-encoding-and-decoding) and the arguments, which will then be ABI-encoded and send as eth_call.

* **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L335)**() :`Promise<string>` - Returns the EIP155 chain ID used for transaction signing at the current best block. Null is returned if not available.

* **[contractAt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L627)**(abi :[`ABI`](#type-abi)[], address :[`Address`](#type-address)) : 

* **[decodeEventData](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L708)**(log :[`Log`](#type-log), d :[`ABI`](#type-abi)) :`any` 

* **[estimateGas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L342)**(tx :[`Transaction`](#type-transaction)) :`Promise<number>` - Makes a call or transaction, which won’t be added to the blockchain and returns the used gas, which can be used for estimating the used gas.

* **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L313)**() :`Promise<number>` - Returns the current price per gas in wei. (as number)

* **[getBalance](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L349)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :[`Promise<BN>`](#type-bn) - Returns the balance of the account of given address in wei (as hex).

* **[getBlockByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L372)**(hash :[`Hash`](#type-hash), includeTransactions :`boolean` = false) :[`Promise<Block>`](#type-block) - Returns information about a block by hash.

* **[getBlockByNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L379)**(block :[`BlockType`](#type-blocktype) = "latest", includeTransactions :`boolean` = false) :[`Promise<Block>`](#type-block) - Returns information about a block by block number.

* **[getBlockTransactionCountByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L387)**(block :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of transactions in a block from a block matching the given block hash.

* **[getBlockTransactionCountByNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L395)**(block :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of transactions in a block from a block matching the given block number.

* **[getCode](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L356)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Returns code at a given address.

* **[getFilterChanges](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L402)**(id :[`Quantity`](#type-quantity)) :`Promise<>` - Polling method for a filter, which returns an array of logs which occurred since last poll.

* **[getFilterLogs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L409)**(id :[`Quantity`](#type-quantity)) :`Promise<>` - Returns an array of all logs matching filter with given id.

* **[getLogs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L416)**(filter :[`LogFilter`](#type-logfilter)) :`Promise<>` - Returns an array of all logs matching a given filter object.

* **[getStorageAt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L364)**(address :[`Address`](#type-address), pos :[`Quantity`](#type-quantity), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<string>` - Returns the value from a storage position at a given address.

* **[getTransactionByBlockHashAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L429)**(hash :[`Hash`](#type-hash), pos :[`Quantity`](#type-quantity)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns information about a transaction by block hash and transaction index position.

* **[getTransactionByBlockNumberAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L437)**(block :[`BlockType`](#type-blocktype), pos :[`Quantity`](#type-quantity)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns information about a transaction by block number and transaction index position.

* **[getTransactionByHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L444)**(hash :[`Hash`](#type-hash)) :[`Promise<TransactionDetail>`](#type-transactiondetail) - Returns the information about a transaction requested by transaction hash.

* **[getTransactionCount](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L451)**(address :[`Address`](#type-address), block :[`BlockType`](#type-blocktype) = "latest") :`Promise<number>` - Returns the number of transactions sent from an address. (as number)

* **[getTransactionReceipt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L459)**(hash :[`Hash`](#type-hash)) :[`Promise<TransactionReceipt>`](#type-transactionreceipt) - Returns the receipt of a transaction by transaction hash.
    Note That the receipt is available even for pending transactions.

* **[getUncleByBlockHashAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L471)**(hash :[`Hash`](#type-hash), pos :[`Quantity`](#type-quantity)) :[`Promise<Block>`](#type-block) - Returns information about a uncle of a block by hash and uncle index position.
    Note: An uncle doesn’t contain individual transactions.

* **[getUncleByBlockNumberAndIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L480)**(block :[`BlockType`](#type-blocktype), pos :[`Quantity`](#type-quantity)) :[`Promise<Block>`](#type-block) - Returns information about a uncle of a block number and uncle index position.
    Note: An uncle doesn’t contain individual transactions.

* **[getUncleCountByBlockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L487)**(hash :[`Hash`](#type-hash)) :`Promise<number>` - Returns the number of uncles in a block from a block matching the given block hash.

* **[getUncleCountByBlockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L494)**(block :[`BlockType`](#type-blocktype)) :`Promise<number>` - Returns the number of uncles in a block from a block matching the given block hash.

* **[hashMessage](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L711)**(data :[`Data`](#type-data)|[`Buffer`](#type-buffer)) :[`Buffer`](#type-buffer) 

* **[newBlockFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L502)**() :`Promise<string>` - Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges.

* **[newFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L519)**(filter :[`LogFilter`](#type-logfilter)) :`Promise<string>` - Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges.

* **[newPendingTransactionFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L528)**() :`Promise<string>` - Creates a filter in the node, to notify when new pending transactions arrive.

* **[protocolVersion](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L543)**() :`Promise<string>` - Returns the current ethereum protocol version.

* **[sendRawTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L572)**(data :[`Data`](#type-data)) :`Promise<string>` - Creates new message call transaction or a contract creation for signed transactions.

* **[sendTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L599)**(args :[`TxRequest`](#type-txrequest)) :`Promise<>` - sends a Transaction

* **[sign](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L581)**(account :[`Address`](#type-address), data :[`Data`](#type-data)) :[`Promise<Signature>`](#type-signature) - signs any kind of message using the `\x19Ethereum Signed Message:\n`-prefix

* **[syncing](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L550)**() :`Promise<>` - Returns the current ethereum protocol version.

* **[uninstallFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L536)**(id :[`Quantity`](#type-quantity)) :[`Promise<Quantity>`](#type-quantity) - Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren’t requested with eth_getFilterChanges for a period of time.


### Type AuthSpec


Authority specification for proof of authority chains


Source: [modules/eth/header.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L46)



* **[authorities](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L48)** :[`Buffer`](#type-buffer)[] - List of validator addresses storead as an buffer array

* **[proposer](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L52)** :[`Buffer`](#type-buffer) - proposer of the block this authspec belongs

* **[spec](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L50)** :[`ChainSpec`](#type-chainspec) - chain specification


### Type Block


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L165)



* **[author](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L185)** :[`Address`](#type-address) - 20 Bytes - the address of the author of the block (the beneficiary to whom the mining rewards were given)

* **[difficulty](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L189)** :[`Quantity`](#type-quantity) - integer of the difficulty for this block

* **[extraData](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L193)** :[`Data`](#type-data) - the ‘extra data’ field of this block

* **[gasLimit](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L197)** :[`Quantity`](#type-quantity) - the maximum gas allowed in this block

* **[gasUsed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L199)** :[`Quantity`](#type-quantity) - the total used gas by all transactions in this block

* **[hash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L169)** :[`Hash`](#type-hash) - hash of the block. null when its pending block

* **[logsBloom](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L177)** :[`Data`](#type-data) - 256 Bytes - the bloom filter for the logs of the block. null when its pending block

* **[miner](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L187)** :[`Address`](#type-address) - 20 Bytes - alias of ‘author’

* **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L173)** :[`Data`](#type-data) - 8 bytes hash of the generated proof-of-work. null when its pending block. Missing in case of PoA.

* **[number](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L167)** :[`Quantity`](#type-quantity) - The block number. null when its pending block

* **[parentHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L171)** :[`Hash`](#type-hash) - hash of the parent block

* **[receiptsRoot](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L183)** :[`Data`](#type-data) - 32 Bytes - the root of the receipts trie of the block

* **[sealFields](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L207)** :[`Data`](#type-data)[] - PoA-Fields

* **[sha3Uncles](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L175)** :[`Data`](#type-data) - SHA3 of the uncles data in the block

* **[size](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L195)** :[`Quantity`](#type-quantity) - integer the size of this block in bytes

* **[stateRoot](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L181)** :[`Data`](#type-data) - 32 Bytes - the root of the final state trie of the block

* **[timestamp](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L201)** :[`Quantity`](#type-quantity) - the unix timestamp for when the block was collated

* **[totalDifficulty](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L191)** :[`Quantity`](#type-quantity) - integer of the total difficulty of the chain until this block

* **[transactions](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L203)** :`string`|[] - Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter

* **[transactionsRoot](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L179)** :[`Data`](#type-data) - 32 Bytes - the root of the transaction trie of the block

* **[uncles](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L205)** :[`Hash`](#type-hash)[] - Array of uncle hashes


### Type Signer


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L278)



* **[prepareTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L280)** *(optional)*  - optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig.

* **[sign](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L286)** - signing of any data.

* **[hasAccount](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L283)**(account :[`Address`](#type-address)) :`Promise<boolean>` - returns true if the account is supported (or unlocked)


### Type Transaction


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L76)



* **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L92)** :`any` *(optional)*  - optional chain id

* **[data](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L88)** :`string` - 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI.

* **[from](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L78)** :[`Address`](#type-address) - 20 Bytes - The address the transaction is send from.

* **[gas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L82)** :[`Quantity`](#type-quantity) - Integer of the gas provided for the transaction execution. eth_call consumes zero gas, but this parameter may be needed by some executions.

* **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L84)** :[`Quantity`](#type-quantity) - Integer of the gas price used for each paid gas.

* **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L90)** :[`Quantity`](#type-quantity) - nonce

* **[to](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L80)** :[`Address`](#type-address) - (optional when creating new contract) 20 Bytes - The address the transaction is directed to.

* **[value](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L86)** :[`Quantity`](#type-quantity) - Integer of the value sent with this transaction.


### Type BlockType


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)



* **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)** :`number`|`'latest'`|`'earliest'`|`'pending'` 


### Type Address


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L48)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 


### Type ABI


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L65)



* **[anonymous](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L66)** :`boolean` *(optional)*  

* **[constant](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L67)** :`boolean` *(optional)*  

* **[inputs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L71)** :[`ABIField`](#type-abifield)[] *(optional)*  

* **[name](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L73)** :`string` *(optional)*  

* **[outputs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L72)** :[`ABIField`](#type-abifield)[] *(optional)*  

* **[payable](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L68)** :`boolean` *(optional)*  

* **[stateMutability](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L69)** :`'nonpayable'`|`'payable'`|`'view'`|`'pure'` *(optional)*  

* **[type](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L74)** :`'event'`|`'function'`|`'constructor'`|`'fallback'` 


### Type Log


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L209)



* **[address](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L223)** :[`Address`](#type-address) - 20 Bytes - address from which this log originated.

* **[blockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L219)** :[`Hash`](#type-hash) - Hash, 32 Bytes - hash of the block where this log was in. null when its pending. null when its pending log.

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L221)** :[`Quantity`](#type-quantity) - the block number where this log was in. null when its pending. null when its pending log.

* **[data](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L225)** :[`Data`](#type-data) - contains the non-indexed arguments of the log.

* **[logIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L213)** :[`Quantity`](#type-quantity) - integer of the log index position in the block. null when its pending log.

* **[removed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L211)** :`boolean` - true when the log was removed, due to a chain reorganization. false if its a valid log.

* **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L227)** :[`Data`](#type-data)[] - - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.)

* **[transactionHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L217)** :[`Hash`](#type-hash) - Hash, 32 Bytes - hash of the transactions this log was created from. null when its pending log.

* **[transactionIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L215)** :[`Quantity`](#type-quantity) - integer of the transactions index position log was created from. null when its pending log.


### Type Hash


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L47)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 


### Type Quantity


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)



* **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 


### Type LogFilter


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L230)



* **[address](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L236)** :[`Address`](#type-address) - (optional) 20 Bytes - Contract address or a list of addresses from which logs should originate.

* **[fromBlock](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L232)** :[`BlockType`](#type-blocktype) - Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions.

* **[limit](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L240)** :[`Quantity`](#type-quantity) - å(optional) The maximum number of entries to retrieve (latest first).

* **[toBlock](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L234)** :[`BlockType`](#type-blocktype) - Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions.

* **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L238)** :`string`|`string`[][] - (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching.


### Type TransactionDetail


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L122)



* **[blockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L128)** :[`Hash`](#type-hash) - 32 Bytes - hash of the block where this transaction was in. null when its pending.

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L130)** :[`BlockType`](#type-blocktype) - block number where this transaction was in. null when its pending.

* **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L156)** :[`Quantity`](#type-quantity) - the chain id of the transaction, if any.

* **[condition](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L160)** :`any` - (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature)

* **[creates](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L158)** :[`Address`](#type-address) - creates contract address

* **[from](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L134)** :[`Address`](#type-address) - 20 Bytes - address of the sender.

* **[gas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L142)** :[`Quantity`](#type-quantity) - gas provided by the sender.

* **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L140)** :[`Quantity`](#type-quantity) - gas price provided by the sender in Wei.

* **[hash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L124)** :[`Hash`](#type-hash) - 32 Bytes - hash of the transaction.

* **[input](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L144)** :[`Data`](#type-data) - the data send along with the transaction.

* **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L126)** :[`Quantity`](#type-quantity) - the number of transactions made by the sender prior to this one.

* **[pk](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L162)** :`any` *(optional)*  - optional: the private key to use for signing

* **[publicKey](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L154)** :[`Hash`](#type-hash) - public key of the signer.

* **[r](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L150)** :[`Quantity`](#type-quantity) - the R field of the signature.

* **[raw](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L152)** :[`Data`](#type-data) - raw transaction data

* **[standardV](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L148)** :[`Quantity`](#type-quantity) - the standardised V field of the signature (0 or 1).

* **[to](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L136)** :[`Address`](#type-address) - 20 Bytes - address of the receiver. null when its a contract creation transaction.

* **[transactionIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L132)** :[`Quantity`](#type-quantity) - integer of the transactions index position in the block. null when its pending.

* **[v](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L146)** :[`Quantity`](#type-quantity) - the standardised V field of the signature.

* **[value](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L138)** :[`Quantity`](#type-quantity) - value transferred in Wei.


### Type TransactionReceipt


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L94)



* **[blockHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L96)** :[`Hash`](#type-hash) - 32 Bytes - hash of the block where this transaction was in.

* **[blockNumber](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L98)** :[`BlockType`](#type-blocktype) - block number where this transaction was in.

* **[contractAddress](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L100)** :[`Address`](#type-address) - 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null.

* **[cumulativeGasUsed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L102)** :[`Quantity`](#type-quantity) - The total amount of gas used when this transaction was executed in the block.

* **[from](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L104)** :[`Address`](#type-address) - 20 Bytes - The address of the sender.

* **[gasUsed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L108)** :[`Quantity`](#type-quantity) - The amount of gas used by this specific transaction alone.

* **[logs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L110)** :[`Log`](#type-log)[] - Array of log objects, which this transaction generated.

* **[logsBloom](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L112)** :[`Data`](#type-data) - 256 Bytes - A bloom filter of logs/events generated by contracts during transaction execution. Used to efficiently rule out transactions without expected logs.

* **[root](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L114)** :[`Hash`](#type-hash) - 32 Bytes - Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork EIP609)

* **[status](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L116)** :[`Quantity`](#type-quantity) - 0x0 indicates transaction failure , 0x1 indicates transaction success. Set for blocks mined after Byzantium hard fork EIP609, null before.

* **[to](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L106)** :[`Address`](#type-address) - 20 Bytes - The address of the receiver. null when it’s a contract creation transaction.

* **[transactionHash](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L118)** :[`Hash`](#type-hash) - 32 Bytes - hash of the transaction.

* **[transactionIndex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L120)** :[`Quantity`](#type-quantity) - Integer of the transactions index position in the block.


### Type Data


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L49)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 


### Type TxRequest


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L243)



* **[args](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L269)** :`any`[] *(optional)*  - the argument to pass to the method

* **[confirmations](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L275)** :`number` *(optional)*  - number of block to wait before confirming

* **[data](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L251)** :[`Data`](#type-data) *(optional)*  - the data to send

* **[from](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L248)** :[`Address`](#type-address) *(optional)*  - address of the account to use

* **[gas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L254)** :`number` *(optional)*  - the gas needed

* **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L257)** :`number` *(optional)*  - the gasPrice used

* **[method](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L266)** :`string` *(optional)*  - the ABI of the method to be used

* **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L260)** :`number` *(optional)*  - the nonce

* **[pk](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L272)** :[`Hash`](#type-hash) *(optional)*  - raw private key in order to sign

* **[to](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L245)** :[`Address`](#type-address) *(optional)*  - contract

* **[value](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L263)** :[`Quantity`](#type-quantity) *(optional)*  - the value in wei


### Type ABIField


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L60)



* **[indexed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L61)** :`boolean` *(optional)*  

* **[name](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L62)** :`string` 

* **[type](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L63)** :`string` 


### Type Hex


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 



## Package modules/ipfs


### Type IpfsAPI


simple API for IPFS


Source: [modules/ipfs/api.ts](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L40)



* `constructor` **[constructor](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L41)**(_client :[`Client`](#type-client)) :[`IpfsAPI`](#type-ipfsapi) 

* **[client](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L41)** :[`Client`](#type-client) - Client for N3.

* **[get](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L53)**(hash :`string`, resultEncoding :`string`) :[`Promise<Buffer>`](#type-buffer) - retrieves the conent for a hash from IPFS.

* **[put](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L64)**(data :[`Buffer`](#type-buffer), dataEncoding :`string`) :`Promise<string>` - stores the data on ipfs and returns the IPFS-Hash.



## Package types


### Type AccountProof


the Proof-for a single Account


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L38)



* **[accountProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L42)** :`string`[] - the serialized merle-noodes beginning with the root-node

* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L46)** :`string` - the address of this account

* **[balance](https://github.com/slockit/in3/blob/master/src/types/types.ts#L50)** :`string` - the balance of this account as hex

* **[code](https://github.com/slockit/in3/blob/master/src/types/types.ts#L58)** :`string` *(optional)*  - the code of this account as hex ( if required)

* **[codeHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L54)** :`string` - the codeHash of this account as hex

* **[nonce](https://github.com/slockit/in3/blob/master/src/types/types.ts#L62)** :`string` - the nonce of this account as hex

* **[storageHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L66)** :`string` - the storageHash of this account as hex

* **[storageProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L70)** :[] - proof for requested storage-data


### Type AuraValidatoryProof


a Object holding proofs for validator logs. The key is the blockNumber as hex


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L88)



* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L97)** :`string` - the serialized blockheader
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3/blob/master/src/types/types.ts#L110)** :`any`[] *(optional)*  - the serialized blockheader as hex, required in case of finality asked
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L92)** :`number` - the transaction log index

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L105)** :`string`[] - the merkleProof

* **[txIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L101)** :`number` - the transactionIndex within the block


### Type ChainSpec


describes the chainspecific consensus params


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L115)



* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L119)** :`number` *(optional)*  - the blocknumnber when this configuration should apply

* **[bypassFinality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L141)** :`number` *(optional)*  - Bypass finality check for transition to contract based Aura Engines
    example: bypassFinality = 10960502 -> will skip the finality check and add the list at block 10960502

* **[contract](https://github.com/slockit/in3/blob/master/src/types/types.ts#L131)** :`string` *(optional)*  - The validator contract at the block

* **[engine](https://github.com/slockit/in3/blob/master/src/types/types.ts#L123)** :`'ethHash'`|`'authorityRound'`|`'clique'` *(optional)*  - the engine type (like Ethhash, authorityRound, ... )

* **[list](https://github.com/slockit/in3/blob/master/src/types/types.ts#L127)** :`string`[] *(optional)*  - The list of validators at the particular block

* **[requiresFinality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L136)** :`boolean` *(optional)*  - indicates whether the transition requires a finality check
    example: true


### Type IN3Config


the iguration of the IN3-Client. This can be paritally overriden for every request.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L146)



* **[archiveNodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L287)** :`boolean` *(optional)*  - if true the in3 client will filter out non archive supporting nodes
    example: true

* **[autoConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L173)** :`boolean` *(optional)*  - if true the config will be adjusted depending on the request

* **[autoUpdateList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L255)** :`boolean` *(optional)*  - if true the nodelist will be automaticly updated if the lastBlock is newer
    example: true

* **[binaryNodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L297)** :`boolean` *(optional)*  - if true the in3 client will only include nodes that support binary encording
    example: true

* **[cacheStorage](https://github.com/slockit/in3/blob/master/src/types/types.ts#L259)** :`any` *(optional)*  - a cache handler offering 2 functions ( setItem(string,string), getItem(string) )

* **[cacheTimeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L150)** :`number` *(optional)*  - number of seconds requests can be cached.

* **[chainId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L240)** :`string` - servers to filter for the given chain. The chain-id based on EIP-155.
    example: 0x1

* **[chainRegistry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L245)** :`string` *(optional)*  - main chain-registry contract
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945

* **[depositTimeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L307)** :`number` *(optional)*  - timeout after which the owner is allowed to receive its stored deposit. This information is also important for the client
    example: 3000

* **[finality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L230)** :`number` *(optional)*  - the number in percent needed in order reach finality (% of signature of the validators)
    example: 50

* **[format](https://github.com/slockit/in3/blob/master/src/types/types.ts#L164)** :`'json'`|`'jsonRef'`|`'cbor'` *(optional)*  - the format for sending the data to the client. Default is json, but using cbor means using only 30-40% of the payload since it is using binary encoding
    example: json

* **[httpNodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L292)** :`boolean` *(optional)*  - if true the in3 client will include http nodes
    example: true

* **[includeCode](https://github.com/slockit/in3/blob/master/src/types/types.ts#L187)** :`boolean` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
    example: true

* **[keepIn3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L159)** :`boolean` *(optional)*  - if true, the in3-section of thr response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.

* **[key](https://github.com/slockit/in3/blob/master/src/types/types.ts#L169)** :`any` *(optional)*  - the client key to sign requests
    example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7

* **[loggerUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L263)** :`string` *(optional)*  - a url of RES-Endpoint, the client will log all errors to. The client will post to this endpoint JSON like { id?, level, message, meta? }

* **[mainChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L250)** :`string` *(optional)*  - main chain-id, where the chain registry is running.
    example: 0x1

* **[maxAttempts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L182)** :`number` *(optional)*  - max number of attempts in case a response is rejected
    example: 10

* **[maxBlockCache](https://github.com/slockit/in3/blob/master/src/types/types.ts#L197)** :`number` *(optional)*  - number of number of blocks cached  in memory
    example: 100

* **[maxCodeCache](https://github.com/slockit/in3/blob/master/src/types/types.ts#L192)** :`number` *(optional)*  - number of max bytes used to cache the code in memory
    example: 100000

* **[minDeposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L215)** :`number` - min stake of the server. Only nodes owning at least this amount will be chosen.

* **[multichainNodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L282)** :`boolean` *(optional)*  - if true the in3 client will filter out nodes other then which have capability of the same RPC endpoint may also accept requests for different chains
    example: true

* **[nodeLimit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L155)** :`number` *(optional)*  - the limit of nodes to store in the client.
    example: 150

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L206)** :`'none'`|`'standard'`|`'full'` *(optional)*  - if true the nodes should send a proof of the response
    example: true

* **[proofNodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L277)** :`boolean` *(optional)*  - if true the in3 client will filter out nodes which are providing no proof
    example: true

* **[replaceLatestBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L220)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[requestCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L225)** :`number` - the number of request send when getting a first answer
    example: 3

* **[retryWithoutProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L177)** :`boolean` *(optional)*  - if true the the request may be handled without proof in case of an error. (use with care!)

* **[rpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L267)** :`string` *(optional)*  - url of one or more rpc-endpoints to use. (list can be comma seperated)

* **[servers](https://github.com/slockit/in3/blob/master/src/types/types.ts#L315)** *(optional)*  - the nodelist per chain

* **[signatureCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L211)** :`number` *(optional)*  - number of signatures requested
    example: 2

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L235)** :`number` *(optional)*  - specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
    example: 3000

* **[torNodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L302)** :`boolean` *(optional)*  - if true the in3 client will filter out non tor nodes
    example: true

* **[verifiedHashes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L201)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.

* **[whiteList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L272)** :`string`[] *(optional)*  - a list of in3 server addresses which are whitelisted manually by client
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b1

* **[whiteListContract](https://github.com/slockit/in3/blob/master/src/types/types.ts#L311)** :`string` *(optional)*  - White list contract address


### Type IN3NodeConfig


a configuration of a in3-server.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L379)



* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L389)** :`string` - the address of the node, which is the public address it iis signing with.
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[capacity](https://github.com/slockit/in3/blob/master/src/types/types.ts#L414)** :`number` *(optional)*  - the capacity of the node.
    example: 100

* **[chainIds](https://github.com/slockit/in3/blob/master/src/types/types.ts#L404)** :`string`[] - the list of supported chains
    example: 0x1

* **[deposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L409)** :`number` - the deposit of the node in wei
    example: 12350000

* **[index](https://github.com/slockit/in3/blob/master/src/types/types.ts#L384)** :`number` *(optional)*  - the index within the contract
    example: 13

* **[props](https://github.com/slockit/in3/blob/master/src/types/types.ts#L419)** :`number` *(optional)*  - the properties of the node.
    example: 3

* **[registerTime](https://github.com/slockit/in3/blob/master/src/types/types.ts#L424)** :`number` *(optional)*  - the UNIX-timestamp when the node was registered
    example: 1563279168

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L394)** :`number` *(optional)*  - the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
    example: 3600

* **[unregisterTime](https://github.com/slockit/in3/blob/master/src/types/types.ts#L429)** :`number` *(optional)*  - the UNIX-timestamp when the node is allowed to be deregister
    example: 1563279168

* **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L399)** :`string` - the endpoint to post to
    example: https://in3.slock.it


### Type IN3NodeWeight


a local weight of a n3-node. (This is used internally to weight the requests)


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L434)



* **[avgResponseTime](https://github.com/slockit/in3/blob/master/src/types/types.ts#L449)** :`number` *(optional)*  - average time of a response in ms
    example: 240

* **[blacklistedUntil](https://github.com/slockit/in3/blob/master/src/types/types.ts#L463)** :`number` *(optional)*  - blacklisted because of failed requests until the timestamp
    example: 1529074639623

* **[lastRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L458)** :`number` *(optional)*  - timestamp of the last request in ms
    example: 1529074632623

* **[pricePerRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L453)** :`number` *(optional)*  - last price

* **[responseCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L444)** :`number` *(optional)*  - number of uses.
    example: 147

* **[weight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L439)** :`number` *(optional)*  - factor the weight this noe (default 1.0)
    example: 0.5


### Type IN3RPCConfig


the configuration for the rpc-handler


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L468)



* **[chains](https://github.com/slockit/in3/blob/master/src/types/types.ts#L561)** *(optional)*  - a definition of the Handler per chain

* **[db](https://github.com/slockit/in3/blob/master/src/types/types.ts#L481)** *(optional)* 

    * **[database](https://github.com/slockit/in3/blob/master/src/types/types.ts#L501)** :`string` *(optional)*  - name of the database

    * **[host](https://github.com/slockit/in3/blob/master/src/types/types.ts#L493)** :`string` *(optional)*  - db-host (default = localhost)

    * **[password](https://github.com/slockit/in3/blob/master/src/types/types.ts#L489)** :`string` *(optional)*  - password for db-access

    * **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L497)** :`number` *(optional)*  - the database port

    * **[user](https://github.com/slockit/in3/blob/master/src/types/types.ts#L485)** :`string` *(optional)*  - username for the db

* **[defaultChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L476)** :`string` *(optional)*  - the default chainId in case the request does not contain one.

* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L472)** :`string` *(optional)*  - a identifier used in logfiles as also for reading the config from the database

* **[logging](https://github.com/slockit/in3/blob/master/src/types/types.ts#L528)** *(optional)*  - logger config

    * **[colors](https://github.com/slockit/in3/blob/master/src/types/types.ts#L540)** :`boolean` *(optional)*  - if true colors will be used

    * **[file](https://github.com/slockit/in3/blob/master/src/types/types.ts#L532)** :`string` *(optional)*  - the path to the logile

    * **[host](https://github.com/slockit/in3/blob/master/src/types/types.ts#L556)** :`string` *(optional)*  - the host for custom logging

    * **[level](https://github.com/slockit/in3/blob/master/src/types/types.ts#L536)** :`string` *(optional)*  - Loglevel

    * **[name](https://github.com/slockit/in3/blob/master/src/types/types.ts#L544)** :`string` *(optional)*  - the name of the provider

    * **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L552)** :`number` *(optional)*  - the port for custom logging

    * **[type](https://github.com/slockit/in3/blob/master/src/types/types.ts#L548)** :`string` *(optional)*  - the module of the provider

* **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L480)** :`number` *(optional)*  - the listeneing port for the server

* **[profile](https://github.com/slockit/in3/blob/master/src/types/types.ts#L503)** *(optional)* 

    * **[comment](https://github.com/slockit/in3/blob/master/src/types/types.ts#L519)** :`string` *(optional)*  - comments for the node

    * **[icon](https://github.com/slockit/in3/blob/master/src/types/types.ts#L507)** :`string` *(optional)*  - url to a icon or logo of company offering this node

    * **[name](https://github.com/slockit/in3/blob/master/src/types/types.ts#L515)** :`string` *(optional)*  - name of the node or company

    * **[noStats](https://github.com/slockit/in3/blob/master/src/types/types.ts#L523)** :`boolean` *(optional)*  - if active the stats will not be shown (default:false)

    * **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L511)** :`string` *(optional)*  - url of the website of the company


### Type IN3RPCHandlerConfig


the configuration for the rpc-handler


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L568)



* **[autoRegistry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L633)** *(optional)* 

    * **[capabilities](https://github.com/slockit/in3/blob/master/src/types/types.ts#L650)** : *(optional)*  

    * **[capacity](https://github.com/slockit/in3/blob/master/src/types/types.ts#L645)** :`number` *(optional)*  - max number of parallel requests

    * **[deposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L641)** :`number` - the deposit you want ot store

    * **[depositUnit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L649)** :`'ether'`|`'finney'`|`'szabo'`|`'wei'` *(optional)*  - unit of the deposit value

    * **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L637)** :`string` - the public url to reach this node

* **[clientKeys](https://github.com/slockit/in3/blob/master/src/types/types.ts#L588)** :`string` *(optional)*  - a comma sepearted list of client keys to use for simulating clients for the watchdog

* **[freeScore](https://github.com/slockit/in3/blob/master/src/types/types.ts#L596)** :`number` *(optional)*  - the score for requests without a valid signature

* **[handler](https://github.com/slockit/in3/blob/master/src/types/types.ts#L572)** :`'eth'`|`'ipfs'`|`'btc'` *(optional)*  - the impl used to handle the calls

* **[ipfsUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L576)** :`string` *(optional)*  - the url of the ipfs-client

* **[maxThreads](https://github.com/slockit/in3/blob/master/src/types/types.ts#L604)** :`number` *(optional)*  - the maximal number of threads ofr running parallel processes

* **[minBlockHeight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L600)** :`number` *(optional)*  - the minimal blockheight in order to sign

* **[persistentFile](https://github.com/slockit/in3/blob/master/src/types/types.ts#L608)** :`string` *(optional)*  - the filename of the file keeping track of the last handled blocknumber

* **[privateKey](https://github.com/slockit/in3/blob/master/src/types/types.ts#L620)** :`string` - the private key used to sign blockhashes. this can be either a 0x-prefixed string with the raw private key or the path to a key-file.

* **[privateKeyPassphrase](https://github.com/slockit/in3/blob/master/src/types/types.ts#L624)** :`string` *(optional)*  - the password used to decrpyt the private key

* **[registry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L628)** :`string` - the address of the server registry used in order to update the nodeList

* **[registryRPC](https://github.com/slockit/in3/blob/master/src/types/types.ts#L632)** :`string` *(optional)*  - the url of the client in case the registry is not on the same chain.

* **[rpcUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L584)** :`string` - the url of the client

* **[startBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L612)** :`number` *(optional)*  - blocknumber to start watching the registry

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L580)** :`number` *(optional)*  - number of milliseconds to wait before a request gets a timeout

* **[watchInterval](https://github.com/slockit/in3/blob/master/src/types/types.ts#L616)** :`number` *(optional)*  - the number of seconds of the interval for checking for new events

* **[watchdogInterval](https://github.com/slockit/in3/blob/master/src/types/types.ts#L592)** :`number` *(optional)*  - average time between sending requests to the same node. 0 turns it off (default)


### Type IN3RPCRequestConfig


additional config for a IN3 RPC-Request


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L665)



* **[chainId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L670)** :`string` - the requested chainId
    example: 0x1

* **[clientSignature](https://github.com/slockit/in3/blob/master/src/types/types.ts#L709)** :`any` *(optional)*  - the signature of the client

* **[finality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L700)** :`number` *(optional)*  - if given the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.

* **[includeCode](https://github.com/slockit/in3/blob/master/src/types/types.ts#L675)** :`boolean` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
    example: true

* **[latestBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L684)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[signatures](https://github.com/slockit/in3/blob/master/src/types/types.ts#L714)** :`string`[] *(optional)*  - a list of addresses requested to sign the blockhash
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[useBinary](https://github.com/slockit/in3/blob/master/src/types/types.ts#L692)** :`boolean` *(optional)*  - if true binary-data will be used.

* **[useFullProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L696)** :`boolean` *(optional)*  - if true all data in the response will be proven, which leads to a higher payload.

* **[useRef](https://github.com/slockit/in3/blob/master/src/types/types.ts#L688)** :`boolean` *(optional)*  - if true binary-data (starting with a 0x) will be refered if occuring again.

* **[verification](https://github.com/slockit/in3/blob/master/src/types/types.ts#L705)** :`'never'`|`'proof'`|`'proofWithSignature'` *(optional)*  - defines the kind of proof the client is asking for
    example: proof

* **[verifiedHashes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L679)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number.

* **[version](https://github.com/slockit/in3/blob/master/src/types/types.ts#L719)** :`string` *(optional)*  - IN3 protocol version that client can specify explicitly in request
    example: 1.0.0

* **[whiteList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L724)** :`string` *(optional)*  - address of whitelist contract if added in3 server will register it in watch
    and will notify client the whitelist event block number in reponses it depends on cahce settings


### Type IN3ResponseConfig


additional data returned from a IN3 Server


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L729)



* **[currentBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L747)** :`number` *(optional)*  - the current blocknumber.
    example: 320126478

* **[lastNodeList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L738)** :`number` *(optional)*  - the blocknumber for the last block updating the nodelist. If the client has a smaller blocknumber he should update the nodeList.
    example: 326478

* **[lastValidatorChange](https://github.com/slockit/in3/blob/master/src/types/types.ts#L742)** :`number` *(optional)*  - the blocknumber of the last change of the validatorList

* **[lastWhiteList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L756)** :`number` *(optional)*  - The blocknumber of the last white list event

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L733)** :[`Proof`](#type-proof) *(optional)*  - the Proof-data

* **[version](https://github.com/slockit/in3/blob/master/src/types/types.ts#L752)** :`string` *(optional)*  - IN3 protocol version
    example: 1.0.0


### Type LogProof


a Object holding proofs for event logs. The key is the blockNumber as hex


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L761)




### Type Proof


the Proof-data as part of the in3-section


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L804)



* **[accounts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L849)** *(optional)*  - a map of addresses and their AccountProof

* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L814)** :`string` *(optional)*  - the serialized blockheader as hex, required in most proofs
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3/blob/master/src/types/types.ts#L819)** :`any`[] *(optional)*  - the serialized blockheader as hex, required in case of finality asked
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L845)** :[`LogProof`](#type-logproof) *(optional)*  - the Log Proof in case of a Log-Request

* **[merkleProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L833)** :`string`[] *(optional)*  - the serialized merle-noodes beginning with the root-node

* **[merkleProofPrev](https://github.com/slockit/in3/blob/master/src/types/types.ts#L837)** :`string`[] *(optional)*  - the serialized merkle-noodes beginning with the root-node of the previous entry (only for full proof of receipts)

* **[signatures](https://github.com/slockit/in3/blob/master/src/types/types.ts#L860)** :[`Signature`](#type-signature)[] *(optional)*  - requested signatures

* **[transactions](https://github.com/slockit/in3/blob/master/src/types/types.ts#L824)** :`any`[] *(optional)*  - the list of transactions of the block
    example:

* **[txIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L856)** :`number` *(optional)*  - the transactionIndex within the block
    example: 4

* **[txProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L841)** :`string`[] *(optional)*  - the serialized merkle-nodes beginning with the root-node in order to prrof the transactionIndex

* **[type](https://github.com/slockit/in3/blob/master/src/types/types.ts#L809)** :`'transactionProof'`|`'receiptProof'`|`'blockProof'`|`'accountProof'`|`'callProof'`|`'logProof'` - the type of the proof
    example: accountProof

* **[uncles](https://github.com/slockit/in3/blob/master/src/types/types.ts#L829)** :`any`[] *(optional)*  - the list of uncle-headers of the block
    example:


### Type RPCRequest


a JSONRPC-Request with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L865)



* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L879)** :`number`|`string` *(optional)*  - the identifier of the request
    example: 2

* **[in3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L888)** :[`IN3RPCRequestConfig`](#type-in3rpcrequestconfig) *(optional)*  - the IN3-Config

* **[jsonrpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L869)** :`'2.0'` - the version

* **[method](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** :`string` - the method to call
    example: eth_getBalance

* **[params](https://github.com/slockit/in3/blob/master/src/types/types.ts#L884)** :`any`[] *(optional)*  - the params
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest


### Type RPCResponse


a JSONRPC-Responset with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L893)



* **[error](https://github.com/slockit/in3/blob/master/src/types/types.ts#L906)** :`string` *(optional)*  - in case of an error this needs to be set

* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L902)** :`string`|`number` - the id matching the request
    example: 2

* **[in3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L915)** :[`IN3ResponseConfig`](#type-in3responseconfig) *(optional)*  - the IN3-Result

* **[in3Node](https://github.com/slockit/in3/blob/master/src/types/types.ts#L919)** :[`IN3NodeConfig`](#type-in3nodeconfig) *(optional)*  - the node handling this response (internal only)

* **[jsonrpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L897)** :`'2.0'` - the version

* **[result](https://github.com/slockit/in3/blob/master/src/types/types.ts#L911)** :`any` *(optional)*  - the params
    example: 0xa35bc


### Type ServerList


a List of nodes


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L924)



* **[contract](https://github.com/slockit/in3/blob/master/src/types/types.ts#L936)** :`string` *(optional)*  - IN3 Registry

* **[lastBlockNumber](https://github.com/slockit/in3/blob/master/src/types/types.ts#L928)** :`number` *(optional)*  - last Block number

* **[nodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L932)** :[`IN3NodeConfig`](#type-in3nodeconfig)[] - the list of nodes

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L945)** :[`Proof`](#type-proof) *(optional)*  - the Proof-data as part of the in3-section

* **[registryId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L940)** :`string` *(optional)*  - registry id of the contract

* **[totalServers](https://github.com/slockit/in3/blob/master/src/types/types.ts#L944)** :`number` *(optional)*  - number of servers


### Type Signature


Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L950)



* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L955)** :`string` *(optional)*  - the address of the signing node
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L960)** :`number` - the blocknumber
    example: 3123874

* **[blockHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L965)** :`string` - the hash of the block
    example: 0x6C1a01C2aB554930A937B0a212346037E8105fB47946c679

* **[msgHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L970)** :`string` - hash of the message
    example: 0x9C1a01C2aB554930A937B0a212346037E8105fB47946AB5D

* **[r](https://github.com/slockit/in3/blob/master/src/types/types.ts#L975)** :`string` - Positive non-zero Integer signature.r
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1f

* **[s](https://github.com/slockit/in3/blob/master/src/types/types.ts#L980)** :`string` - Positive non-zero Integer signature.s
    example: 0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda

* **[v](https://github.com/slockit/in3/blob/master/src/types/types.ts#L985)** :`number` - Calculated curve point, or identity element O.
    example: 28


## Common Module

The common module (in3-common) contains all the typedefs used in the node and server.



* [**BlockData**](#type-blockdata) : `interface`  - Block as returned by eth_getBlockByNumber

* [**LogData**](#type-logdata) : `interface`  - LogData as part of the TransactionReceipt

* **[Receipt](https://github.com/slockit/in3-common/blob/master/src/index.ts#L71)** :[`_serialize.Receipt`](#type-_serialize.receipt) 

* [**ReceiptData**](#type-receiptdata) : `interface`  - TransactionReceipt as returned by eth_getTransactionReceipt

* **[Transaction](https://github.com/slockit/in3-common/blob/master/src/index.ts#L72)** :[`_serialize.Transaction`](#type-_serialize.transaction) 

* [**TransactionData**](#type-transactiondata) : `interface`  - Transaction as returned by eth_getTransactionByHash

* [**Transport**](#type-transport) : `interface`  - A Transport-object responsible to transport the message to the handler.

* [**AxiosTransport**](#type-axiostransport) : `class`  - Default Transport impl sending http-requests.

* [**Block**](#type-block) : `class`  - encodes and decodes the blockheader

* **[blockFromHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L331)**(hex :`string`) :[`Block`](#type-block) - converts a hexstring to a block-object

* **[cbor](https://github.com/slockit/in3-common/blob/master/src/index.ts#L86)**

    * **[createRefs](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L101)**(val :[`T`](#type-t), cache :`string`[] =  []) :[`T`](#type-t) 

    * **[decodeRequests](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L45)**(request :[`Buffer`](#type-buffer)) :[`RPCRequest`](#type-rpcrequest)[] 

    * **[decodeResponses](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L59)**(responses :[`Buffer`](#type-buffer)) :[`RPCResponse`](#type-rpcresponse)[] 

    * **[encodeRequests](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L41)**(requests :[`RPCRequest`](#type-rpcrequest)[]) :[`Buffer`](#type-buffer) - turn

    * **[encodeResponses](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L56)**(responses :[`RPCResponse`](#type-rpcresponse)[]) :[`Buffer`](#type-buffer) 

    * **[resolveRefs](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L122)**(val :[`T`](#type-t), cache :`string`[] =  []) :[`T`](#type-t) 

* **[chainAliases](https://github.com/slockit/in3-common/blob/master/src/index.ts#L83)**

    * **[goerli](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

    * **[ipfs](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

    * **[kovan](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

    * **[main](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

    * **[mainnet](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

    * **[tobalaba](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

* **[createRandomIndexes](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L237)**(len :`number`, limit :`number`, seed :[`Buffer`](#type-buffer), result :`number`[] =  []) :`number`[] 

* **[createTx](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L296)**(transaction :`any`) :`any` - creates a Transaction-object from the rpc-transaction-data

* **[getSigner](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L250)**(data :[`Block`](#type-block)) :[`Buffer`](#type-buffer) 

* **[rlp](https://github.com/slockit/in3-common/blob/master/src/index.ts#L101)**

* **[serialize](https://github.com/slockit/in3-common/blob/master/src/index.ts#L64)**

    * [**Block**](#type-block) :`class` - encodes and decodes the blockheader

    * [**AccountData**](#type-accountdata) :`interface` - Account-Object

    * [**BlockData**](#type-blockdata) :`interface` - Block as returned by eth_getBlockByNumber

    * [**LogData**](#type-logdata) :`interface` - LogData as part of the TransactionReceipt

    * [**ReceiptData**](#type-receiptdata) :`interface` - TransactionReceipt as returned by eth_getTransactionReceipt

    * [**TransactionData**](#type-transactiondata) :`interface` - Transaction as returned by eth_getTransactionByHash

    * **[Account](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L48)** :[`Buffer`](#type-buffer)[] - Buffer[] of the Account

    * **[BlockHeader](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L42)** :[`Buffer`](#type-buffer)[] - Buffer[] of the header

    * **[Receipt](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L51)** : - Buffer[] of the Receipt

    * **[Transaction](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L45)** :[`Buffer`](#type-buffer)[] - Buffer[] of the transaction

    * **[rlp](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L40)** - RLP-functions

    * **[address](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L160)**(val :`any`) :`any` - converts it to a Buffer with 20 bytes length

    * **[blockFromHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L331)**(hex :`string`) :[`Block`](#type-block) - converts a hexstring to a block-object

    * **[blockToHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L326)**(block :`any`) :`string` - converts blockdata to a hexstring

    * **[bytes](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L158)**(val :`any`) :`any` - converts it to a Buffer

    * **[bytes256](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L152)**(val :`any`) :`any` - converts it to a Buffer with 256 bytes length

    * **[bytes32](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L154)**(val :`any`) :`any` - converts it to a Buffer with 32 bytes length

    * **[bytes8](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L156)**(val :`any`) :`any` - converts it to a Buffer with 8 bytes length

    * **[createTx](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L296)**(transaction :`any`) :`any` - creates a Transaction-object from the rpc-transaction-data

    * **[hash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L146)**(val :[`Block`](#type-block)|[`Transaction`](#type-transaction)|[`Receipt`](#type-receipt)|[`Account`](#type-account)|[`Buffer`](#type-buffer)) :[`Buffer`](#type-buffer) - returns the hash of the object

    * **[serialize](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L143)**(val :[`Block`](#type-block)|[`Transaction`](#type-transaction)|[`Receipt`](#type-receipt)|[`Account`](#type-account)|`any`) :[`Buffer`](#type-buffer) - serialize the data

    * **[toAccount](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L207)**(account :[`AccountData`](#type-accountdata)) :[`Buffer`](#type-buffer)[] 

    * **[toBlockHeader](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L168)**(block :[`BlockData`](#type-blockdata)) :[`Buffer`](#type-buffer)[] - create a Buffer[] from RPC-Response

    * **[toReceipt](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L216)**(r :[`ReceiptData`](#type-receiptdata)) :`Object` - create a Buffer[] from RPC-Response

    * **[toTransaction](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L193)**(tx :[`TransactionData`](#type-transactiondata)) :[`Buffer`](#type-buffer)[] - create a Buffer[] from RPC-Response

    * **[uint](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L162)**(val :`any`) :`any` - converts it to a Buffer with a variable length. 0 = length 0

    * **[uint128](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L165)**(val :`any`) :`any` 

    * **[uint64](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L164)**(val :`any`) :`any` 

* **[storage](https://github.com/slockit/in3-common/blob/master/src/index.ts#L80)**

    * **[getStorageArrayKey](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L43)**(pos :`number`, arrayIndex :`number`, structSize :`number` = 1, structPos :`number` = 0) :`any` - calc the storrage array key

    * **[getStorageMapKey](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L55)**(pos :`number`, key :`string`, structPos :`number` = 0) :`any` - calcs the storage Map key.

    * **[getStorageValue](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L103)**(rpc :`string`, contract :`string`, pos :`number`, type :`'address'`|`'bytes32'`|`'bytes16'`|`'bytes4'`|`'int'`|`'string'`, keyOrIndex :`number`|`string`, structSize :`number`, structPos :`number`) :`Promise<>` - get a storage value from the server

    * **[getStringValue](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L65)**(data :[`Buffer`](#type-buffer), storageKey :[`Buffer`](#type-buffer)) :`string`| - creates a string from storage.

    * **[getStringValueFromList](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L84)**(values :[`Buffer`](#type-buffer)[], len :`number`) :`string` - concats the storage values to a string.

    * **[toBN](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L91)**(val :`any`) :[`BN`](#type-bn) - converts any value to BN

* **[transport](https://github.com/slockit/in3-common/blob/master/src/index.ts#L75)**

    * [**AxiosTransport**](#type-axiostransport) :`class` - Default Transport impl sending http-requests.

    * [**Transport**](#type-transport) :`interface` - A Transport-object responsible to transport the message to the handler.

* **[util](https://github.com/slockit/in3-common/blob/master/src/index.ts#L40)**

    * **[checkForError](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L76)**(res :[`T`](#type-t)) :[`T`](#type-t) - check a RPC-Response for errors and rejects the promise if found

    * **[createRandomIndexes](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L237)**(len :`number`, limit :`number`, seed :[`Buffer`](#type-buffer), result :`number`[] =  []) :`number`[] 

    * **[getAddress](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L191)**(pk :`string`) :`string` - returns a address from a private key

    * **[getSigner](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L250)**(data :[`Block`](#type-block)) :[`Buffer`](#type-buffer) 

    * **[padEnd](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L230)**(val :`string`, minLength :`number`, fill :`string` = " ") :`string` - padEnd for legacy

    * **[padStart](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L223)**(val :`string`, minLength :`number`, fill :`string` = " ") :`string` - padStart for legacy

    * **[promisify](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L54)**(self :`any`, fn :`any`, args :`any`[]) :`Promise<any>` - simple promisy-function

    * **[toBN](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L85)**(val :`any`) :[`BN`](#type-bn) - convert to BigNumber

    * **[toBuffer](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L147)**(val :`any`, len :`number` =  -1) :`any` - converts any value as Buffer
         if len === 0 it will return an empty Buffer if the value is 0 or '0x00', since this is the way rlpencode works wit 0-values.

    * **[toHex](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L96)**(val :`any`, bytes :`number`) :`string` - converts any value as hex-string

    * **[toMinHex](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L197)**(key :`string`|[`Buffer`](#type-buffer)|`number`) :`string` - removes all leading 0 in the hexstring

    * **[toNumber](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L119)**(val :`any`) :`number` - converts to a js-number

    * **[toSimpleHex](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L180)**(val :`string`) :`string` - removes all leading 0 in a hex-string

    * **[toUtf8](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L65)**(val :`any`) :`string` 

    * **[aliases](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** : `Object`  


        * **[goerli](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

        * **[ipfs](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

        * **[kovan](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

        * **[main](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

        * **[mainnet](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

        * **[tobalaba](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L256)** :`string` 

* **[validate](https://github.com/slockit/in3-common/blob/master/src/index.ts#L37)**

    * **[ajv](https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L42)** :[`Ajv`](#type-ajv) - the ajv instance with custom formatters and keywords

    * **[validate](https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L70)**(ob :`any`, def :`any`) :`void` 

    * **[validateAndThrow](https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L64)**(fn :[`Ajv.ValidateFunction`](#type-ajv.validatefunction), ob :`any`) :`void` - validates the data and throws an error in case they are not valid.


## Package modules/eth


### Type BlockData


Block as returned by eth_getBlockByNumber


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L54)



* **[coinbase](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L59)** :`string` *(optional)*  

* **[difficulty](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L65)** :`string`|`number` 

* **[extraData](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L70)** :`string` 

* **[gasLimit](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L67)** :`string`|`number` 

* **[gasUsed](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L68)** :`string`|`number` 

* **[hash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L55)** :`string` 

* **[logsBloom](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L64)** :`string` 

* **[miner](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L58)** :`string` 

* **[mixHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L72)** :`string` *(optional)*  

* **[nonce](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L73)** :`string`|`number` *(optional)*  

* **[number](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L66)** :`string`|`number` 

* **[parentHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L56)** :`string` 

* **[receiptRoot](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L63)** :`string` *(optional)*  

* **[receiptsRoot](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L62)** :`string` 

* **[sealFields](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L71)** :`string`[] *(optional)*  

* **[sha3Uncles](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L57)** :`string` 

* **[stateRoot](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L60)** :`string` 

* **[timestamp](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L69)** :`string`|`number` 

* **[transactions](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L74)** :`any`[] *(optional)*  

* **[transactionsRoot](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L61)** :`string` 

* **[uncles](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L75)** :`string`[] *(optional)*  


### Type LogData


LogData as part of the TransactionReceipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L114)



* **[address](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L122)** :`string` 

* **[blockHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L120)** :`string` 

* **[blockNumber](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L121)** :`string` 

* **[data](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L123)** :`string` 

* **[logIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L116)** :`string` 

* **[removed](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L115)** :`boolean` 

* **[topics](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L124)** :`string`[] 

* **[transactionHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L119)** :`string` 

* **[transactionIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L118)** :`string` 

* **[transactionLogIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L117)** :`string` 


### Type ReceiptData


TransactionReceipt as returned by eth_getTransactionReceipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L128)



* **[blockHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L132)** :`string` *(optional)*  

* **[blockNumber](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L131)** :`string`|`number` *(optional)*  

* **[cumulativeGasUsed](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L135)** :`string`|`number` *(optional)*  

* **[gasUsed](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L136)** :`string`|`number` *(optional)*  

* **[logs](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L138)** :[`LogData`](#type-logdata)[] 

* **[logsBloom](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L137)** :`string` *(optional)*  

* **[root](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L134)** :`string` *(optional)*  

* **[status](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L133)** :`string`|`boolean` *(optional)*  

* **[transactionHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L129)** :`string` *(optional)*  

* **[transactionIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L130)** :`number` *(optional)*  


### Type TransactionData


Transaction as returned by eth_getTransactionByHash


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L79)



* **[blockHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L81)** :`string` *(optional)*  

* **[blockNumber](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L82)** :`number`|`string` *(optional)*  

* **[chainId](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L83)** :`number`|`string` *(optional)*  

* **[condition](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L84)** :`string` *(optional)*  

* **[creates](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L85)** :`string` *(optional)*  

* **[data](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L91)** :`string` *(optional)*  

* **[from](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L86)** :`string` *(optional)*  

* **[gas](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L87)** :`number`|`string` *(optional)*  

* **[gasLimit](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L88)** :`number`|`string` *(optional)*  

* **[gasPrice](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L89)** :`number`|`string` *(optional)*  

* **[hash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L80)** :`string` 

* **[input](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L90)** :`string` 

* **[nonce](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L92)** :`number`|`string` 

* **[publicKey](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L93)** :`string` *(optional)*  

* **[r](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L98)** :`string` *(optional)*  

* **[raw](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L94)** :`string` *(optional)*  

* **[s](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L99)** :`string` *(optional)*  

* **[standardV](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L95)** :`string` *(optional)*  

* **[to](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L96)** :`string` 

* **[transactionIndex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L97)** :`number` 

* **[v](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L100)** :`string` *(optional)*  

* **[value](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L101)** :`number`|`string` 


### Type Block


encodes and decodes the blockheader


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L240)



* `constructor` **[constructor](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L261)**(data :[`Buffer`](#type-buffer)|`string`|[`BlockData`](#type-blockdata)) :[`Block`](#type-block) - creates a Block-Onject from either the block-data as returned from rpc, a buffer or a hex-string of the encoded blockheader

* **[raw](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L243)** :[`BlockHeader`](#type-blockheader) - the raw Buffer fields of the BlockHeader

* **[transactions](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L246)** :[`Tx`](#type-tx)[] - the transaction-Object (if given)

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

* **[bareHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L284)**() :[`Buffer`](#type-buffer) - the blockhash as buffer without the seal fields

* **[hash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L279)**() :[`Buffer`](#type-buffer) - the blockhash as buffer

* **[serializeHeader](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L289)**() :[`Buffer`](#type-buffer) - the serialized header as buffer


### Type AccountData


Account-Object


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L105)



* **[balance](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L107)** :`string` 

* **[code](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L110)** :`string` *(optional)*  

* **[codeHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L109)** :`string` 

* **[nonce](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L106)** :`string` 

* **[storageHash](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L108)** :`string` 


### Type Transaction


Buffer[] of the transaction


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L45)



* **[Transaction](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L45)** :[`Buffer`](#type-buffer)[] - Buffer[] of the transaction


### Type Receipt


Buffer[] of the Receipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L51)



* **[Receipt](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L51)** : - Buffer[] of the Receipt


### Type Account


Buffer[] of the Account


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L48)



* **[Account](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L48)** :[`Buffer`](#type-buffer)[] - Buffer[] of the Account


### Type BlockHeader


Buffer[] of the header


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L42)



* **[BlockHeader](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L42)** :[`Buffer`](#type-buffer)[] - Buffer[] of the header



## Package types


### Type RPCRequest


a JSONRPC-Request with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L370)



* **[id](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L384)** :`number`|`string` *(optional)*  - the identifier of the request
    example: 2

* **[in3](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L393)** :[`IN3RPCRequestConfig`](#type-in3rpcrequestconfig) *(optional)*  - the IN3-Config

* **[jsonrpc](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L374)** :`'2.0'` - the version

* **[method](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L379)** :`string` - the method to call
    example: eth_getBalance

* **[params](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L389)** :`any`[] *(optional)*  - the params
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest


### Type RPCResponse


a JSONRPC-Responset with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L398)



* **[error](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L411)** :`string` *(optional)*  - in case of an error this needs to be set

* **[id](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L407)** :`string`|`number` - the id matching the request
    example: 2

* **[in3](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L420)** :[`IN3ResponseConfig`](#type-in3responseconfig) *(optional)*  - the IN3-Result

* **[in3Node](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L424)** :[`IN3NodeConfig`](#type-in3nodeconfig) *(optional)*  - the node handling this response (internal only)

* **[jsonrpc](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L402)** :`'2.0'` - the version

* **[result](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L416)** :`any` *(optional)*  - the params
    example: 0xa35bc


### Type IN3RPCRequestConfig


additional config for a IN3 RPC-Request


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L179)



* **[chainId](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L184)** :`string` - the requested chainId
    example: 0x1

* **[clientSignature](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L223)** :`any` *(optional)*  - the signature of the client

* **[finality](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L214)** :`number` *(optional)*  - if given the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.

* **[includeCode](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L189)** :`boolean` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
    example: true

* **[latestBlock](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L198)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[signatures](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L228)** :`string`[] *(optional)*  - a list of addresses requested to sign the blockhash
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[useBinary](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L206)** :`boolean` *(optional)*  - if true binary-data will be used.

* **[useFullProof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L210)** :`boolean` *(optional)*  - if true all data in the response will be proven, which leads to a higher payload.

* **[useRef](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L202)** :`boolean` *(optional)*  - if true binary-data (starting with a 0x) will be refered if occuring again.

* **[verification](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L219)** :`'never'`|`'proof'`|`'proofWithSignature'` *(optional)*  - defines the kind of proof the client is asking for
    example: proof

* **[verifiedHashes](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L193)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number.

* **[version](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L233)** :`string` *(optional)*  - IN3 protocol version that client can specify explicitly in request
    example: 1.0.0


### Type IN3ResponseConfig


additional data returned from a IN3 Server


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L238)



* **[currentBlock](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L256)** :`number` *(optional)*  - the current blocknumber.
    example: 320126478

* **[lastNodeList](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L247)** :`number` *(optional)*  - the blocknumber for the last block updating the nodelist. If the client has a smaller blocknumber he should update the nodeList.
    example: 326478

* **[lastValidatorChange](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L251)** :`number` *(optional)*  - the blocknumber of gthe last change of the validatorList

* **[proof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L242)** :[`Proof`](#type-proof) *(optional)*  - the Proof-data

* **[version](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L261)** :`string` *(optional)*  - the in3 protocol version.
    example: 1.0.0


### Type IN3NodeConfig


a configuration of a in3-server.


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L90)



* **[address](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L100)** :`string` - the address of the node, which is the public address it iis signing with.
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[capacity](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L125)** :`number` *(optional)*  - the capacity of the node.
    example: 100

* **[chainIds](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L115)** :`string`[] - the list of supported chains
    example: 0x1

* **[deposit](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L120)** :`number` - the deposit of the node in wei
    example: 12350000

* **[index](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L95)** :`number` *(optional)*  - the index within the contract
    example: 13

* **[props](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L130)** :`number` *(optional)*  - the properties of the node.
    example: 3

* **[registerTime](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L135)** :`number` *(optional)*  - the UNIX-timestamp when the node was registered
    example: 1563279168

* **[timeout](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L105)** :`number` *(optional)*  - the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
    example: 3600

* **[unregisterTime](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L140)** :`number` *(optional)*  - the UNIX-timestamp when the node is allowed to be deregister
    example: 1563279168

* **[url](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L110)** :`string` - the endpoint to post to
    example: https://in3.slock.it


### Type Proof


the Proof-data as part of the in3-section


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L309)



* **[accounts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L354)** *(optional)*  - a map of addresses and their AccountProof

* **[block](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L319)** :`string` *(optional)*  - the serialized blockheader as hex, required in most proofs
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L324)** :`any`[] *(optional)*  - the serialized blockheader as hex, required in case of finality asked
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logProof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L350)** :[`LogProof`](#type-logproof) *(optional)*  - the Log Proof in case of a Log-Request

* **[merkleProof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L338)** :`string`[] *(optional)*  - the serialized merle-noodes beginning with the root-node

* **[merkleProofPrev](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L342)** :`string`[] *(optional)*  - the serialized merkle-noodes beginning with the root-node of the previous entry (only for full proof of receipts)

* **[signatures](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L365)** :[`Signature`](#type-signature)[] *(optional)*  - requested signatures

* **[transactions](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L329)** :`any`[] *(optional)*  - the list of transactions of the block
    example:

* **[txIndex](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L361)** :`number` *(optional)*  - the transactionIndex within the block
    example: 4

* **[txProof](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L346)** :`string`[] *(optional)*  - the serialized merkle-nodes beginning with the root-node in order to prrof the transactionIndex

* **[type](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L314)** :`'transactionProof'`|`'receiptProof'`|`'blockProof'`|`'accountProof'`|`'callProof'`|`'logProof'` - the type of the proof
    example: accountProof

* **[uncles](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L334)** :`any`[] *(optional)*  - the list of uncle-headers of the block
    example:


### Type LogProof


a Object holding proofs for event logs. The key is the blockNumber as hex


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L266)




### Type Signature


Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L429)



* **[address](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L434)** :`string` *(optional)*  - the address of the signing node
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[block](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L439)** :`number` - the blocknumber
    example: 3123874

* **[blockHash](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L444)** :`string` - the hash of the block
    example: 0x6C1a01C2aB554930A937B0a212346037E8105fB47946c679

* **[msgHash](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L449)** :`string` - hash of the message
    example: 0x9C1a01C2aB554930A937B0a212346037E8105fB47946AB5D

* **[r](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L454)** :`string` - Positive non-zero Integer signature.r
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1f

* **[s](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L459)** :`string` - Positive non-zero Integer signature.s
    example: 0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda

* **[v](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L464)** :`number` - Calculated curve point, or identity element O.
    example: 28



## Package util


### Type Transport


A Transport-object responsible to transport the message to the handler.


Source: [util/transport.ts](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L42)



* **[handle](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L46)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` - handles a request by passing the data to the handler

* **[isOnline](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L51)**() :`Promise<boolean>` - check whether the handler is onlne.

* **[random](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L56)**(count :`number`) :`number`[] - generates random numbers (between 0-1)


### Type AxiosTransport


Default Transport impl sending http-requests.


Source: [util/transport.ts](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L64)



* `constructor` **[constructor](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L66)**(format :`'json'`|`'cbor'`|`'jsonRef'` = "json") :[`AxiosTransport`](#type-axiostransport) 

* **[format](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L66)** :`'json'`|`'cbor'`|`'jsonRef'` 

* **[handle](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L81)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` 

* **[isOnline](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L72)**() :`Promise<boolean>` 

* **[random](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L110)**(count :`number`) :`number`[] 


