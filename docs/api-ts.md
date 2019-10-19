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

* **[BlockData](https://github.com/slockit/in3/blob/master/src/index.ts#L86)** :[`BlockData`](#type-blockdata) 

* [**ChainSpec**](#type-chainspec) : `interface`  - describes the chainspecific consensus params

* [**IN3Client**](#type-client) : `class`  - Client for N3.

* [**IN3Config**](#type-in3config) : `interface`  - the iguration of the IN3-Client. This can be paritally overriden for every request.

* [**IN3NodeConfig**](#type-in3nodeconfig) : `interface`  - a configuration of a in3-server.

* [**IN3NodeWeight**](#type-in3nodeweight) : `interface`  - a local weight of a n3-node. (This is used internally to weight the requests)

* [**IN3RPCConfig**](#type-in3rpcconfig) : `interface`  - the configuration for the rpc-handler

* [**IN3RPCHandlerConfig**](#type-in3rpchandlerconfig) : `interface`  - the configuration for the rpc-handler

* [**IN3RPCRequestConfig**](#type-in3rpcrequestconfig) : `interface`  - additional config for a IN3 RPC-Request

* [**IN3ResponseConfig**](#type-in3responseconfig) : `interface`  - additional data returned from a IN3 Server

* **[LogData](https://github.com/slockit/in3/blob/master/src/index.ts#L87)** :[`LogData`](#type-logdata) 

* [**LogProof**](#type-logproof) : `interface`  - a Object holding proofs for event logs. The key is the blockNumber as hex

* [**Proof**](#type-proof) : `interface`  - the Proof-data as part of the in3-section

* [**RPCRequest**](#type-rpcrequest) : `interface`  - a JSONRPC-Request with N3-Extension

* [**RPCResponse**](#type-rpcresponse) : `interface`  - a JSONRPC-Responset with N3-Extension

* **[ReceiptData](https://github.com/slockit/in3/blob/master/src/index.ts#L88)** :[`ReceiptData`](#type-receiptdata) 

* [**ServerList**](#type-serverlist) : `interface`  - a List of nodes

* [**Signature**](#type-signature) : `interface`  - Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.

* **[TransactionData](https://github.com/slockit/in3/blob/master/src/index.ts#L89)** :[`TransactionData`](#type-transactiondata) 

* **[Transport](https://github.com/slockit/in3/blob/master/src/index.ts#L84)** :[`_transporttype`](#type-_transporttype) 

* **[AxiosTransport](https://github.com/slockit/in3/blob/master/src/index.ts#L94)** :`any` 

* [**EthAPI**](#type-ethapi) : `class` 

* **[cbor](https://github.com/slockit/in3/blob/master/src/index.ts#L48)** :`any` 

* **[chainAliases](https://github.com/slockit/in3/blob/master/src/index.ts#L97)**

    * **[goerli](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L720)** :`string` 

    * **[ipfs](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L720)** :`string` 

    * **[kovan](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L720)** :`string` 

    * **[main](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L720)** :`string` 

    * **[mainnet](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L720)** :`string` 

    * **[tobalaba](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L720)** :`string` 

* **[chainData](https://github.com/slockit/in3/blob/master/src/index.ts#L64)**

    * **[callContract](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L42)**(client :[`Client`](#type-client), contract :`string`, chainId :`string`, signature :`string`, args :`any`[], config :[`IN3Config`](#type-in3config)) :`Promise<any>` 

    * **[getChainData](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L51)**(client :[`Client`](#type-client), chainId :`string`, config :[`IN3Config`](#type-in3config)) :`Promise<>` 

* **[createRandomIndexes](https://github.com/slockit/in3/blob/master/src/client/serverList.ts#L71)**(len :`number`, limit :`number`, seed :[`Buffer`](#type-buffer), result :`number`[] =  []) :`number`[] - helper function creating deterministic random indexes used for limited nodelists

* **[header](https://github.com/slockit/in3/blob/master/src/index.ts#L54)**

    * [**AuthSpec**](#type-authspec) :`interface` - Authority specification for proof of authority chains

    * **[checkBlockSignatures](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L60)**(blockHeaders :`any`[], getChainSpec :) :`Promise<number>` - verify a Blockheader and returns the percentage of finality

    * **[getChainSpec](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L263)**(b :[`Block`](#type-block), ctx :[`ChainContext`](#type-chaincontext)) :[`Promise<AuthSpec>`](#type-authspec) 

    * **[getSigner](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L109)**(data :[`Block`](#type-block)) :[`Buffer`](#type-buffer) 

* **[serialize](https://github.com/slockit/in3/blob/master/src/index.ts#L51)**

* **[storage](https://github.com/slockit/in3/blob/master/src/index.ts#L57)** :`any` 

* **[transport](https://github.com/slockit/in3/blob/master/src/index.ts#L61)** :`any` 

* **[typeDefs](https://github.com/slockit/in3/blob/master/src/index.ts#L95)**

    * **[AccountProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[AuraValidatoryProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[ChainSpec](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[IN3Config](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[IN3NodeConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[IN3NodeWeight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[IN3RPCConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[IN3RPCHandlerConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[IN3RPCRequestConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[IN3ResponseConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[LogProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[Proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[RPCRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[RPCResponse](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[ServerList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


    * **[Signature](https://github.com/slockit/in3/blob/master/src/types/types.ts#L930)** : `Object`  


* **[util](https://github.com/slockit/in3/blob/master/src/index.ts#L36)** :`any` 

* **[validate](https://github.com/slockit/in3/blob/master/src/index.ts#L96)** :`any` 


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

* **[call](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L235)**(method :`string`, params :`any`, chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<any>` - sends a simply RPC-Request

* **[clearStats](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L267)**() :`void` - clears all stats and weights, like blocklisted nodes

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

* **[send](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L247)**(request :[`RPCRequest`](#type-rpcrequest)[]|[`RPCRequest`](#type-rpcrequest), callback :, config :[`Partial<IN3Config>`](#type-partial)) :`Promise<>` - sends one or a multiple requests.
    if the request is a array the response will be a array as well.
    If the callback is given it will be called with the response, if not a Promise will be returned.
    This function supports callback so it can be used as a Provider for the web3.

* **[sendRPC](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L224)**(method :`string`, params :`any`[] =  [], chain :`string`, config :[`Partial<IN3Config>`](#type-partial)) :[`Promise<RPCResponse>`](#type-rpcresponse) - sends a simply RPC-Request

* **[setMaxListeners](https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L19)**(n :`number`) :`this` 

* **[updateNodeList](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L159)**(chainId :`string`, conf :[`Partial<IN3Config>`](#type-partial), retryCount :`number` = 5) :`Promise<void>` - fetches the nodeList from the servers.


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

* **[clearCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L131)**(prefix :`string`) :`void` 

* **[getChainSpec](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L84)**(block :`number`) :[`ChainSpec`](#type-chainspec) - returns the chainspec for th given block number

* **[getFromCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L121)**(key :`string`) :`string` 

* **[handleIntern](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L77)**(request :[`RPCRequest`](#type-rpcrequest)) :[`Promise<RPCResponse>`](#type-rpcresponse) - this function is calleds before the server is asked.
    If it returns a promise than the request is handled internally otherwise the server will handle the response.
    this function should be overriden by modules that want to handle calls internally

* **[initCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L89)**() :`void` 

* **[putInCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L125)**(key :`string`, value :`string`) :`void` 

* **[updateCache](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L115)**() :`void` 


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



* **[Block](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L165)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[sealFields](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L207)** :[`Data`](#type-data)[] - PoA-Fields

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[transactions](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L203)** :`string`|[] - Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[uncles](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L205)** :[`Hash`](#type-hash)[] - Array of uncle hashes


### Type Signer


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L278)



* **[prepareTransaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L280)** *(optional)*  - optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig.

* **[sign](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L286)** - signing of any data.

* **[hasAccount](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L283)**(account :[`Address`](#type-address)) :`Promise<boolean>` - returns true if the account is supported (or unlocked)


### Type Transaction


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L76)



* **[Transaction](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L76)**

    * **[chainId](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L92)** :`any` *(optional)*  - optional chain id

    * **[data](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L88)** :`string` - 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 


### Type BlockType


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)



* **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)** :`number`|`'latest'`|`'earliest'`|`'pending'` 


### Type Address


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L48)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 


### Type ABI


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L65)



* **[ABI](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L65)**

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



* **[Log](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L209)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[removed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L211)** :`boolean` - true when the log was removed, due to a chain reorganization. false if its a valid log.

    * **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L227)** :[`Data`](#type-data)[] - - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.)

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 


### Type Hash


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L47)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 


### Type Quantity


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)



* **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 


### Type LogFilter


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L230)



* **[LogFilter](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L230)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[topics](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L238)** :`string`|`string`[][] - (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching.


### Type TransactionDetail


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L122)



* **[TransactionDetail](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L122)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[condition](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L160)** :`any` - (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature)

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[pk](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L162)** :`any` *(optional)*  - optional: the private key to use for signing

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 


### Type TransactionReceipt


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L94)



* **[TransactionReceipt](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L94)**

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[BlockType](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)** :`number`|`'latest'`|`'earliest'`|`'pending'` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[logs](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L110)** :[`Log`](#type-log)[] - Array of log objects, which this transaction generated.

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 


### Type Data


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L49)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 


### Type TxRequest


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L243)



* **[TxRequest](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L243)**

    * **[args](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L269)** :`any`[] *(optional)*  - the argument to pass to the method

    * **[confirmations](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L275)** :`number` *(optional)*  - number of block to wait before confirming

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[gas](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L254)** :`number` *(optional)*  - the gas needed

    * **[gasPrice](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L257)** :`number` *(optional)*  - the gasPrice used

    * **[method](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L266)** :`string` *(optional)*  - the ABI of the method to be used

    * **[nonce](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L260)** :`number` *(optional)*  - the nonce

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 

    * **[Quantity](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)** :`number`|[`Hex`](#type-hex) 


### Type Hex


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)



* **[Hex](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)** :`string` 


### Type ABIField


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L60)



* **[ABIField](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L60)**

    * **[indexed](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L61)** :`boolean` *(optional)*  

    * **[name](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L62)** :`string` 

    * **[type](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L63)** :`string` 



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



* **[autoConfig](https://github.com/slockit/in3/blob/master/src/types/types.ts#L173)** :`boolean` *(optional)*  - if true the config will be adjusted depending on the request

* **[autoUpdateList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L255)** :`boolean` *(optional)*  - if true the nodelist will be automaticly updated if the lastBlock is newer
    example: true

* **[cacheStorage](https://github.com/slockit/in3/blob/master/src/types/types.ts#L259)** :`any` *(optional)*  - a cache handler offering 2 functions ( setItem(string,string), getItem(string) )

* **[cacheTimeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L150)** :`number` *(optional)*  - number of seconds requests can be cached.

* **[chainId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L240)** :`string` - servers to filter for the given chain. The chain-id based on EIP-155.
    example: 0x1

* **[chainRegistry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L245)** :`string` *(optional)*  - main chain-registry contract
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945

* **[finality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L230)** :`number` *(optional)*  - the number in percent needed in order reach finality (% of signature of the validators)
    example: 50

* **[format](https://github.com/slockit/in3/blob/master/src/types/types.ts#L164)** :`'json'`|`'jsonRef'`|`'cbor'` *(optional)*  - the format for sending the data to the client. Default is json, but using cbor means using only 30-40% of the payload since it is using binary encoding
    example: json

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

* **[nodeLimit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L155)** :`number` *(optional)*  - the limit of nodes to store in the client.
    example: 150

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L206)** :`'none'`|`'standard'`|`'full'` *(optional)*  - if true the nodes should send a proof of the response
    example: true

* **[replaceLatestBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L220)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[requestCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L225)** :`number` - the number of request send when getting a first answer
    example: 3

* **[retryWithoutProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L177)** :`boolean` *(optional)*  - if true the the request may be handled without proof in case of an error. (use with care!)

* **[rpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L267)** :`string` *(optional)*  - url of one or more rpc-endpoints to use. (list can be comma seperated)

* **[servers](https://github.com/slockit/in3/blob/master/src/types/types.ts#L271)** *(optional)*  - the nodelist per chain

* **[signatureCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L211)** :`number` *(optional)*  - number of signatures requested
    example: 2

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L235)** :`number` *(optional)*  - specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
    example: 3000

* **[verifiedHashes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L201)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.


### Type IN3NodeConfig


a configuration of a in3-server.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L330)



* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L340)** :`string` - the address of the node, which is the public address it iis signing with.
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[capacity](https://github.com/slockit/in3/blob/master/src/types/types.ts#L365)** :`number` *(optional)*  - the capacity of the node.
    example: 100

* **[chainIds](https://github.com/slockit/in3/blob/master/src/types/types.ts#L355)** :`string`[] - the list of supported chains
    example: 0x1

* **[deposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L360)** :`number` - the deposit of the node in wei
    example: 12350000

* **[index](https://github.com/slockit/in3/blob/master/src/types/types.ts#L335)** :`number` *(optional)*  - the index within the contract
    example: 13

* **[props](https://github.com/slockit/in3/blob/master/src/types/types.ts#L370)** :`number` *(optional)*  - the properties of the node.
    example: 3

* **[registerTime](https://github.com/slockit/in3/blob/master/src/types/types.ts#L375)** :`number` *(optional)*  - the UNIX-timestamp when the node was registered
    example: 1563279168

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L345)** :`number` *(optional)*  - the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
    example: 3600

* **[unregisterTime](https://github.com/slockit/in3/blob/master/src/types/types.ts#L380)** :`number` *(optional)*  - the UNIX-timestamp when the node is allowed to be deregister
    example: 1563279168

* **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L350)** :`string` - the endpoint to post to
    example: https://in3.slock.it


### Type IN3NodeWeight


a local weight of a n3-node. (This is used internally to weight the requests)


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L385)



* **[avgResponseTime](https://github.com/slockit/in3/blob/master/src/types/types.ts#L400)** :`number` *(optional)*  - average time of a response in ms
    example: 240

* **[blacklistedUntil](https://github.com/slockit/in3/blob/master/src/types/types.ts#L414)** :`number` *(optional)*  - blacklisted because of failed requests until the timestamp
    example: 1529074639623

* **[lastRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L409)** :`number` *(optional)*  - timestamp of the last request in ms
    example: 1529074632623

* **[pricePerRequest](https://github.com/slockit/in3/blob/master/src/types/types.ts#L404)** :`number` *(optional)*  - last price

* **[responseCount](https://github.com/slockit/in3/blob/master/src/types/types.ts#L395)** :`number` *(optional)*  - number of uses.
    example: 147

* **[weight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L390)** :`number` *(optional)*  - factor the weight this noe (default 1.0)
    example: 0.5


### Type IN3RPCConfig


the configuration for the rpc-handler


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L419)



* **[chains](https://github.com/slockit/in3/blob/master/src/types/types.ts#L512)** *(optional)*  - a definition of the Handler per chain

* **[db](https://github.com/slockit/in3/blob/master/src/types/types.ts#L432)** *(optional)* 

    * **[database](https://github.com/slockit/in3/blob/master/src/types/types.ts#L452)** :`string` *(optional)*  - name of the database

    * **[host](https://github.com/slockit/in3/blob/master/src/types/types.ts#L444)** :`string` *(optional)*  - db-host (default = localhost)

    * **[password](https://github.com/slockit/in3/blob/master/src/types/types.ts#L440)** :`string` *(optional)*  - password for db-access

    * **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L448)** :`number` *(optional)*  - the database port

    * **[user](https://github.com/slockit/in3/blob/master/src/types/types.ts#L436)** :`string` *(optional)*  - username for the db

* **[defaultChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L427)** :`string` *(optional)*  - the default chainId in case the request does not contain one.

* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L423)** :`string` *(optional)*  - a identifier used in logfiles as also for reading the config from the database

* **[logging](https://github.com/slockit/in3/blob/master/src/types/types.ts#L479)** *(optional)*  - logger config

    * **[colors](https://github.com/slockit/in3/blob/master/src/types/types.ts#L491)** :`boolean` *(optional)*  - if true colors will be used

    * **[file](https://github.com/slockit/in3/blob/master/src/types/types.ts#L483)** :`string` *(optional)*  - the path to the logile

    * **[host](https://github.com/slockit/in3/blob/master/src/types/types.ts#L507)** :`string` *(optional)*  - the host for custom logging

    * **[level](https://github.com/slockit/in3/blob/master/src/types/types.ts#L487)** :`string` *(optional)*  - Loglevel

    * **[name](https://github.com/slockit/in3/blob/master/src/types/types.ts#L495)** :`string` *(optional)*  - the name of the provider

    * **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L503)** :`number` *(optional)*  - the port for custom logging

    * **[type](https://github.com/slockit/in3/blob/master/src/types/types.ts#L499)** :`string` *(optional)*  - the module of the provider

* **[port](https://github.com/slockit/in3/blob/master/src/types/types.ts#L431)** :`number` *(optional)*  - the listeneing port for the server

* **[profile](https://github.com/slockit/in3/blob/master/src/types/types.ts#L454)** *(optional)* 

    * **[comment](https://github.com/slockit/in3/blob/master/src/types/types.ts#L470)** :`string` *(optional)*  - comments for the node

    * **[icon](https://github.com/slockit/in3/blob/master/src/types/types.ts#L458)** :`string` *(optional)*  - url to a icon or logo of company offering this node

    * **[name](https://github.com/slockit/in3/blob/master/src/types/types.ts#L466)** :`string` *(optional)*  - name of the node or company

    * **[noStats](https://github.com/slockit/in3/blob/master/src/types/types.ts#L474)** :`boolean` *(optional)*  - if active the stats will not be shown (default:false)

    * **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L462)** :`string` *(optional)*  - url of the website of the company


### Type IN3RPCHandlerConfig


the configuration for the rpc-handler


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L519)



* **[autoRegistry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L584)** *(optional)* 

    * **[capabilities](https://github.com/slockit/in3/blob/master/src/types/types.ts#L601)** *(optional)* 

        * **[multiChain](https://github.com/slockit/in3/blob/master/src/types/types.ts#L609)** :`boolean` *(optional)*  - if true, this node is able to deliver multiple chains

        * **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L605)** :`boolean` *(optional)*  - if true, this node is able to deliver proofs

    * **[capacity](https://github.com/slockit/in3/blob/master/src/types/types.ts#L596)** :`number` *(optional)*  - max number of parallel requests

    * **[deposit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L592)** :`number` - the deposit you want ot store

    * **[depositUnit](https://github.com/slockit/in3/blob/master/src/types/types.ts#L600)** :`'ether'`|`'finney'`|`'szabo'`|`'wei'` *(optional)*  - unit of the deposit value

    * **[url](https://github.com/slockit/in3/blob/master/src/types/types.ts#L588)** :`string` - the public url to reach this node

* **[clientKeys](https://github.com/slockit/in3/blob/master/src/types/types.ts#L539)** :`string` *(optional)*  - a comma sepearted list of client keys to use for simulating clients for the watchdog

* **[freeScore](https://github.com/slockit/in3/blob/master/src/types/types.ts#L547)** :`number` *(optional)*  - the score for requests without a valid signature

* **[handler](https://github.com/slockit/in3/blob/master/src/types/types.ts#L523)** :`'eth'`|`'ipfs'`|`'btc'` *(optional)*  - the impl used to handle the calls

* **[ipfsUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L527)** :`string` *(optional)*  - the url of the ipfs-client

* **[maxThreads](https://github.com/slockit/in3/blob/master/src/types/types.ts#L555)** :`number` *(optional)*  - the maximal number of threads ofr running parallel processes

* **[minBlockHeight](https://github.com/slockit/in3/blob/master/src/types/types.ts#L551)** :`number` *(optional)*  - the minimal blockheight in order to sign

* **[persistentFile](https://github.com/slockit/in3/blob/master/src/types/types.ts#L559)** :`string` *(optional)*  - the filename of the file keeping track of the last handled blocknumber

* **[privateKey](https://github.com/slockit/in3/blob/master/src/types/types.ts#L571)** :`string` - the private key used to sign blockhashes. this can be either a 0x-prefixed string with the raw private key or the path to a key-file.

* **[privateKeyPassphrase](https://github.com/slockit/in3/blob/master/src/types/types.ts#L575)** :`string` *(optional)*  - the password used to decrpyt the private key

* **[registry](https://github.com/slockit/in3/blob/master/src/types/types.ts#L579)** :`string` - the address of the server registry used in order to update the nodeList

* **[registryRPC](https://github.com/slockit/in3/blob/master/src/types/types.ts#L583)** :`string` *(optional)*  - the url of the client in case the registry is not on the same chain.

* **[rpcUrl](https://github.com/slockit/in3/blob/master/src/types/types.ts#L535)** :`string` - the url of the client

* **[startBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L563)** :`number` *(optional)*  - blocknumber to start watching the registry

* **[timeout](https://github.com/slockit/in3/blob/master/src/types/types.ts#L531)** :`number` *(optional)*  - number of milliseconds to wait before a request gets a timeout

* **[watchInterval](https://github.com/slockit/in3/blob/master/src/types/types.ts#L567)** :`number` *(optional)*  - the number of seconds of the interval for checking for new events

* **[watchdogInterval](https://github.com/slockit/in3/blob/master/src/types/types.ts#L543)** :`number` *(optional)*  - average time between sending requests to the same node. 0 turns it off (default)


### Type IN3RPCRequestConfig


additional config for a IN3 RPC-Request


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L616)



* **[chainId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L621)** :`string` - the requested chainId
    example: 0x1

* **[clientSignature](https://github.com/slockit/in3/blob/master/src/types/types.ts#L660)** :`any` *(optional)*  - the signature of the client

* **[finality](https://github.com/slockit/in3/blob/master/src/types/types.ts#L651)** :`number` *(optional)*  - if given the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.

* **[includeCode](https://github.com/slockit/in3/blob/master/src/types/types.ts#L626)** :`boolean` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
    example: true

* **[latestBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L635)** :`number` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
    example: 6

* **[signatures](https://github.com/slockit/in3/blob/master/src/types/types.ts#L665)** :`string`[] *(optional)*  - a list of addresses requested to sign the blockhash
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[useBinary](https://github.com/slockit/in3/blob/master/src/types/types.ts#L643)** :`boolean` *(optional)*  - if true binary-data will be used.

* **[useFullProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L647)** :`boolean` *(optional)*  - if true all data in the response will be proven, which leads to a higher payload.

* **[useRef](https://github.com/slockit/in3/blob/master/src/types/types.ts#L639)** :`boolean` *(optional)*  - if true binary-data (starting with a 0x) will be refered if occuring again.

* **[verification](https://github.com/slockit/in3/blob/master/src/types/types.ts#L656)** :`'never'`|`'proof'`|`'proofWithSignature'` *(optional)*  - defines the kind of proof the client is asking for
    example: proof

* **[verifiedHashes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L630)** :`string`[] *(optional)*  - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number.

* **[version](https://github.com/slockit/in3/blob/master/src/types/types.ts#L670)** :`string` *(optional)*  - IN3 protocol version that client can specify explicitly in request
    example: 1.0.0


### Type IN3ResponseConfig


additional data returned from a IN3 Server


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L675)



* **[currentBlock](https://github.com/slockit/in3/blob/master/src/types/types.ts#L693)** :`number` *(optional)*  - the current blocknumber.
    example: 320126478

* **[lastNodeList](https://github.com/slockit/in3/blob/master/src/types/types.ts#L684)** :`number` *(optional)*  - the blocknumber for the last block updating the nodelist. If the client has a smaller blocknumber he should update the nodeList.
    example: 326478

* **[lastValidatorChange](https://github.com/slockit/in3/blob/master/src/types/types.ts#L688)** :`number` *(optional)*  - the blocknumber of gthe last change of the validatorList

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L679)** :[`Proof`](#type-proof) *(optional)*  - the Proof-data

* **[version](https://github.com/slockit/in3/blob/master/src/types/types.ts#L698)** :`string` *(optional)*  - IN3 protocol version
    example: 1.0.0


### Type LogProof


a Object holding proofs for event logs. The key is the blockNumber as hex


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L703)




### Type Proof


the Proof-data as part of the in3-section


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L746)



* **[accounts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L791)** *(optional)*  - a map of addresses and their AccountProof

* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L756)** :`string` *(optional)*  - the serialized blockheader as hex, required in most proofs
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[finalityBlocks](https://github.com/slockit/in3/blob/master/src/types/types.ts#L761)** :`any`[] *(optional)*  - the serialized blockheader as hex, required in case of finality asked
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b

* **[logProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L787)** :[`LogProof`](#type-logproof) *(optional)*  - the Log Proof in case of a Log-Request

* **[merkleProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L775)** :`string`[] *(optional)*  - the serialized merle-noodes beginning with the root-node

* **[merkleProofPrev](https://github.com/slockit/in3/blob/master/src/types/types.ts#L779)** :`string`[] *(optional)*  - the serialized merkle-noodes beginning with the root-node of the previous entry (only for full proof of receipts)

* **[signatures](https://github.com/slockit/in3/blob/master/src/types/types.ts#L802)** :[`Signature`](#type-signature)[] *(optional)*  - requested signatures

* **[transactions](https://github.com/slockit/in3/blob/master/src/types/types.ts#L766)** :`any`[] *(optional)*  - the list of transactions of the block
    example:

* **[txIndex](https://github.com/slockit/in3/blob/master/src/types/types.ts#L798)** :`number` *(optional)*  - the transactionIndex within the block
    example: 4

* **[txProof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L783)** :`string`[] *(optional)*  - the serialized merkle-nodes beginning with the root-node in order to prrof the transactionIndex

* **[type](https://github.com/slockit/in3/blob/master/src/types/types.ts#L751)** :`'transactionProof'`|`'receiptProof'`|`'blockProof'`|`'accountProof'`|`'callProof'`|`'logProof'` - the type of the proof
    example: accountProof

* **[uncles](https://github.com/slockit/in3/blob/master/src/types/types.ts#L771)** :`any`[] *(optional)*  - the list of uncle-headers of the block
    example:


### Type RPCRequest


a JSONRPC-Request with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L807)



* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L821)** :`number`|`string` *(optional)*  - the identifier of the request
    example: 2

* **[in3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L830)** :[`IN3RPCRequestConfig`](#type-in3rpcrequestconfig) *(optional)*  - the IN3-Config

* **[jsonrpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L811)** :`'2.0'` - the version

* **[method](https://github.com/slockit/in3/blob/master/src/types/types.ts#L816)** :`string` - the method to call
    example: eth_getBalance

* **[params](https://github.com/slockit/in3/blob/master/src/types/types.ts#L826)** :`any`[] *(optional)*  - the params
    example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest


### Type RPCResponse


a JSONRPC-Responset with N3-Extension


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L835)



* **[error](https://github.com/slockit/in3/blob/master/src/types/types.ts#L848)** :`string` *(optional)*  - in case of an error this needs to be set

* **[id](https://github.com/slockit/in3/blob/master/src/types/types.ts#L844)** :`string`|`number` - the id matching the request
    example: 2

* **[in3](https://github.com/slockit/in3/blob/master/src/types/types.ts#L857)** :[`IN3ResponseConfig`](#type-in3responseconfig) *(optional)*  - the IN3-Result

* **[in3Node](https://github.com/slockit/in3/blob/master/src/types/types.ts#L861)** :[`IN3NodeConfig`](#type-in3nodeconfig) *(optional)*  - the node handling this response (internal only)

* **[jsonrpc](https://github.com/slockit/in3/blob/master/src/types/types.ts#L839)** :`'2.0'` - the version

* **[result](https://github.com/slockit/in3/blob/master/src/types/types.ts#L853)** :`any` *(optional)*  - the params
    example: 0xa35bc


### Type ServerList


a List of nodes


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L866)



* **[contract](https://github.com/slockit/in3/blob/master/src/types/types.ts#L878)** :`string` *(optional)*  - IN3 Registry

* **[lastBlockNumber](https://github.com/slockit/in3/blob/master/src/types/types.ts#L870)** :`number` *(optional)*  - last Block number

* **[nodes](https://github.com/slockit/in3/blob/master/src/types/types.ts#L874)** :[`IN3NodeConfig`](#type-in3nodeconfig)[] - the list of nodes

* **[proof](https://github.com/slockit/in3/blob/master/src/types/types.ts#L887)** :[`Proof`](#type-proof) *(optional)*  - the Proof-data as part of the in3-section

* **[registryId](https://github.com/slockit/in3/blob/master/src/types/types.ts#L882)** :`string` *(optional)*  - registry id of the contract

* **[totalServers](https://github.com/slockit/in3/blob/master/src/types/types.ts#L886)** :`number` *(optional)*  - number of servers


### Type Signature


Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.


Source: [types/types.ts](https://github.com/slockit/in3/blob/master/src/types/types.ts#L892)



* **[address](https://github.com/slockit/in3/blob/master/src/types/types.ts#L897)** :`string` *(optional)*  - the address of the signing node
    example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679

* **[block](https://github.com/slockit/in3/blob/master/src/types/types.ts#L902)** :`number` - the blocknumber
    example: 3123874

* **[blockHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L907)** :`string` - the hash of the block
    example: 0x6C1a01C2aB554930A937B0a212346037E8105fB47946c679

* **[msgHash](https://github.com/slockit/in3/blob/master/src/types/types.ts#L912)** :`string` - hash of the message
    example: 0x9C1a01C2aB554930A937B0a212346037E8105fB47946AB5D

* **[r](https://github.com/slockit/in3/blob/master/src/types/types.ts#L917)** :`string` - Positive non-zero Integer signature.r
    example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1f

* **[s](https://github.com/slockit/in3/blob/master/src/types/types.ts#L922)** :`string` - Positive non-zero Integer signature.s
    example: 0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda

* **[v](https://github.com/slockit/in3/blob/master/src/types/types.ts#L927)** :`number` - Calculated curve point, or identity element O.
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

* **[blockFromHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L329)**(hex :`string`) :[`Block`](#type-block) - converts a hexstring to a block-object

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

    * **[blockFromHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L329)**(hex :`string`) :[`Block`](#type-block) - converts a hexstring to a block-object

    * **[blockToHex](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L324)**(block :`any`) :`string` - converts blockdata to a hexstring

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

* **[handle](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L76)**(url :`string`, data :[`RPCRequest`](#type-rpcrequest)|[`RPCRequest`](#type-rpcrequest)[], timeout :`number`) :`Promise<>` 

* **[isOnline](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L72)**() :`Promise<boolean>` 

* **[random](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L105)**(count :`number`) :`number`[] 


