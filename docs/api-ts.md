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

   


```eval_rst
  .. list-table::
     :widths: auto

     * - | Type
       - | `ABI <#type-abi>`_ 
       - | the ABI
     * - | Interface
       - | `AccountProof <#type-accountproof>`_ 
       - | the AccountProof
     * - | Interface
       - | `AuraValidatoryProof <#type-auravalidatoryproof>`_ 
       - | the AuraValidatoryProof
     * - | Type
       - | `BlockData <#type-blockdata>`_ 
       - | the BlockData
     * - | Type
       - | `BlockType <#type-blocktype>`_ 
       - | the BlockType
     * - | Interface
       - | `ChainSpec <#type-chainspec>`_ 
       - | the ChainSpec
     * - | Class
       - | `IN3Client <#type-in3client>`_ 
       - | the IN3Client
     * - | Interface
       - | `IN3Config <#type-in3config>`_ 
       - | the IN3Config
     * - | Interface
       - | `IN3NodeConfig <#type-in3nodeconfig>`_ 
       - | the IN3NodeConfig
     * - | Interface
       - | `IN3NodeWeight <#type-in3nodeweight>`_ 
       - | the IN3NodeWeight
     * - | Interface
       - | `IN3RPCConfig <#type-in3rpcconfig>`_ 
       - | the IN3RPCConfig
     * - | Interface
       - | `IN3RPCHandlerConfig <#type-in3rpchandlerconfig>`_ 
       - | the IN3RPCHandlerConfig
     * - | Interface
       - | `IN3RPCRequestConfig <#type-in3rpcrequestconfig>`_ 
       - | the IN3RPCRequestConfig
     * - | Interface
       - | `IN3ResponseConfig <#type-in3responseconfig>`_ 
       - | the IN3ResponseConfig
     * - | Type
       - | `Log <#type-log>`_ 
       - | the Log
     * - | Type
       - | `LogData <#type-logdata>`_ 
       - | the LogData
     * - | Interface
       - | `LogProof <#type-logproof>`_ 
       - | the LogProof
     * - | Interface
       - | `Proof <#type-proof>`_ 
       - | the Proof
     * - | Interface
       - | `RPCRequest <#type-rpcrequest>`_ 
       - | the RPCRequest
     * - | Interface
       - | `RPCResponse <#type-rpcresponse>`_ 
       - | the RPCResponse
     * - | Type
       - | `ReceiptData <#type-receiptdata>`_ 
       - | the ReceiptData
     * - | Interface
       - | `ServerList <#type-serverlist>`_ 
       - | the ServerList
     * - | Interface
       - | `Signature <#type-signature>`_ 
       - | the Signature
     * - | Type
       - | `Transaction <#type-transaction>`_ 
       - | the Transaction
     * - | Type
       - | `TransactionData <#type-transactiondata>`_ 
       - | the TransactionData
     * - | Type
       - | `TransactionReceipt <#type-transactionreceipt>`_ 
       - | the TransactionReceipt
     * - | Type
       - | `Transport <#type-transport>`_ 
       - | the Transport
     * - | ``any``
       - | `AxiosTransport <https://github.com/slockit/in3/blob/master/src/index.ts#L102>`_
       - | the AxiosTransport 
         |  value= ``transport.AxiosTransport``
     * - | `EthAPI <#type-ethapi>`_ 
       - | `EthAPI <https://github.com/slockit/in3/blob/master/src/index.ts#L43>`_
       - | the EthAPI 
         |  value= ``_ethapi.default``
     * - | ``any``
       - | `cbor <https://github.com/slockit/in3/blob/master/src/index.ts#L48>`_
       - | the cbor 
         |  value= ``_cbor``
     * - | 
       - | `chainAliases <https://github.com/slockit/in3/blob/master/src/index.ts#L105>`_
       - | the chainAliases 
         |  value= ``aliases``
     * - | `chainData <#type-chaindata>`_ 
       - | `chainData <https://github.com/slockit/in3/blob/master/src/index.ts#L64>`_
       - | the chainData 
         |  value= ``_chainData``
     * - | ``number`` []
       - | `createRandomIndexes <https://github.com/slockit/in3/blob/master/src/client/serverList.ts#L71>`_ (
         |       len:``number``,
         |       limit:``number``,
         |       seed:`Buffer <#type-buffer>`_ ,
         |       result:``number`` [])
       - | helper function creating deterministic random indexes used for limited nodelists 
     * - | `header <#type-header>`_ 
       - | `header <https://github.com/slockit/in3/blob/master/src/index.ts#L54>`_
       - | the header 
         |  value= ``_header``
     * - | `serialize <#type-serialize>`_ 
       - | `serialize <https://github.com/slockit/in3/blob/master/src/index.ts#L51>`_
       - | the serialize 
         |  value= ``_serialize``
     * - | ``any``
       - | `storage <https://github.com/slockit/in3/blob/master/src/index.ts#L57>`_
       - | the storage 
         |  value= ``_storage``
     * - | ``any``
       - | `transport <https://github.com/slockit/in3/blob/master/src/index.ts#L61>`_
       - | the transport 
         |  value= ``_transport``
     * - | 
       - | `typeDefs <https://github.com/slockit/in3/blob/master/src/index.ts#L103>`_
       - | the typeDefs 
         |  value= ``types.validationDef``
     * - | ``any``
       - | `util <https://github.com/slockit/in3/blob/master/src/index.ts#L36>`_
       - | the util 
         |  value= ``_util``
     * - | ``any``
       - | `validate <https://github.com/slockit/in3/blob/master/src/index.ts#L104>`_
       - | the validate 
         |  value= ``validateOb.validate``

```


## Package client


### Type Client


Source: [client/Client.ts](https://github.com/slockit/in3/blob/master/src/client/Client.ts#L69)


Client for N3.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `defaultMaxListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L9>`_
       - | the defaultMaxListeners 
     * - | ``number``
       - | `listenerCount <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L8>`_ (
         |       emitter:`EventEmitter <#type-eventemitter>`_ ,
         |       event:``string`` 
         | | ``symbol``)
       - | listener count 
     * - | `Client <#type-client>`_ 
       - | `constructor <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L80>`_ (
         |       config:`Partial<IN3Config> <#type-partial>`_ ,
         |       transport:`Transport <#type-transport>`_ )
       - | creates a new Client. 
     * - | `IN3Config <#type-in3config>`_ 
       - | `defConfig <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L76>`_
       - | the defConfig 
     * - | `EthAPI <#type-ethapi>`_ 
       - | `eth <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L72>`_
       - | the eth 
     * - | `IpfsAPI <#type-ipfsapi>`_ 
       - | `ipfs <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L73>`_
       - | the ipfs 
     * - | `IN3Config <#type-in3config>`_ 
       - | `config <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L146>`_
       - | config 
     * - | ``this``
       - | `addListener <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L11>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | add listener 
     * - | ``Promise<any>``
       - | `call <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L259>`_ (
         |       method:``string``,
         |       params:``any``,
         |       chain:``string``,
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | sends a simply RPC-Request 
     * - | ``void``
       - | `clearStats <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L311>`_ ()
       - | clears all stats and weights, like blocklisted nodes 
     * - | ``any``
       - | `createWeb3Provider <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L127>`_ ()
       - | create web3 provider 
     * - | ``boolean``
       - | `emit <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L23>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       args:``any`` [])
       - | emit 
     * - | `Array<> <#type-array>`_ 
       - | `eventNames <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L24>`_ ()
       - | event names 
     * - | `ChainContext <#type-chaincontext>`_ 
       - | `getChainContext <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L134>`_ (
         |       chainId:``string``)
       - | Context for a specific chain including cache and chainSpecs. 
     * - | ``number``
       - | `getMaxListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L20>`_ ()
       - | get max listeners 
     * - | ``number``
       - | `listenerCount <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L25>`_ (
         |       type:``string`` 
         | | ``symbol``)
       - | listener count 
     * - | `Function <#type-function>`_  []
       - | `listeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L21>`_ (
         |       event:``string`` 
         | | ``symbol``)
       - | listeners 
     * - | ``this``
       - | `off <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L17>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | off 
     * - | ``this``
       - | `on <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L12>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | on 
     * - | ``this``
       - | `once <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L13>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | once 
     * - | ``this``
       - | `prependListener <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L14>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | prepend listener 
     * - | ``this``
       - | `prependOnceListener <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L15>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | prepend once listener 
     * - | `Function <#type-function>`_  []
       - | `rawListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L22>`_ (
         |       event:``string`` 
         | | ``symbol``)
       - | raw listeners 
     * - | ``this``
       - | `removeAllListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L18>`_ (
         |       event:``string`` 
         | | ``symbol``)
       - | remove all listeners 
     * - | ``this``
       - | `removeListener <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L16>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | remove listener 
     * - | ``Promise<>``
       - | `send <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L271>`_ (
         |       request:`RPCRequest <#type-rpcrequest>`_  [] 
         | | `RPCRequest <#type-rpcrequest>`_ ,
         |       callback:,
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | sends one or a multiple requests.
         | if the request is a array the response will be a array as well.
         | If the callback is given it will be called with the response, if not a Promise will be returned.
         | This function supports callback so it can be used as a Provider for the web3. 
     * - | `Promise<RPCResponse> <#type-rpcresponse>`_ 
       - | `sendRPC <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L248>`_ (
         |       method:``string``,
         |       params:``any`` [],
         |       chain:``string``,
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | sends a simply RPC-Request 
     * - | ``this``
       - | `setMaxListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L19>`_ (
         |       n:``number``)
       - | set max listeners 
     * - | ``Promise<void>``
       - | `updateNodeList <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L182>`_ (
         |       chainId:``string``,
         |       conf:`Partial<IN3Config> <#type-partial>`_ ,
         |       retryCount:``number``)
       - | fetches the nodeList from the servers. 
     * - | ``Promise<void>``
       - | `updateWhiteListNodes <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L155>`_ (
         |       config:`IN3Config <#type-in3config>`_ )
       - | update white list nodes 
     * - | ``Promise<boolean>``
       - | `verifyResponse <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L298>`_ (
         |       request:`RPCRequest <#type-rpcrequest>`_ ,
         |       response:`RPCResponse <#type-rpcresponse>`_ ,
         |       chain:``string``,
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | Verify the response of a request without any effect on the state of the client.
         | Note: The node-list will not be updated.
         | The method will either return `true` if its inputs could be verified.
         |  Or else, it will throw an exception with a helpful message. 

```


### Type ChainContext


Source: [client/ChainContext.ts](https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L42)


Context for a specific chain including cache and chainSpecs.

```eval_rst
  .. list-table::
     :widths: auto

     * - | `ChainContext <#type-chaincontext>`_ 
       - | `constructor <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L49>`_ (
         |       client:`Client <#type-client>`_ ,
         |       chainId:``string``,
         |       chainSpec:`ChainSpec <#type-chainspec>`_  [])
       - | Context for a specific chain including cache and chainSpecs. 
     * - | ``string``
       - | `chainId <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L46>`_
       - | the chainId 
     * - | `ChainSpec <#type-chainspec>`_  []
       - | `chainSpec <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L44>`_
       - | the chainSpec 
     * - | `Client <#type-client>`_ 
       - | `client <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L43>`_
       - | the client 
     * - | 
       - | `genericCache <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L48>`_
       - | the genericCache 
     * - | ``number``
       - | `lastValidatorChange <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L47>`_
       - | the lastValidatorChange 
     * - | `Module <#type-module>`_ 
       - | `module <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L45>`_
       - | the module 
     * - | ``string``
       - | `registryId <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L49>`_
       - | the registryId  *(optional)* 
     * - | ``void``
       - | `clearCache <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L156>`_ (
         |       prefix:``string``)
       - | clear cache 
     * - | `ChainSpec <#type-chainspec>`_ 
       - | `getChainSpec <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L85>`_ (
         |       block:``number``)
       - | returns the chainspec for th given block number 
     * - | ``string``
       - | `getFromCache <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L146>`_ (
         |       key:``string``)
       - | get from cache 
     * - | `Promise<RPCResponse> <#type-rpcresponse>`_ 
       - | `handleIntern <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L78>`_ (
         |       request:`RPCRequest <#type-rpcrequest>`_ )
       - | this function is calleds before the server is asked.
         | If it returns a promise than the request is handled internally otherwise the server will handle the response.
         | this function should be overriden by modules that want to handle calls internally 
     * - | ``void``
       - | `initCache <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L90>`_ ()
       - | init cache 
     * - | ``void``
       - | `putInCache <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L150>`_ (
         |       key:``string``,
         |       value:``string``)
       - | put in cache 
     * - | ``void``
       - | `updateCache <https://github.com/slockit/in3/blob/master/src/client/ChainContext.ts#L137>`_ (
         |       whiteList:`Set<string> <#type-set>`_ ,
         |       whiteListContract:``string``)
       - | update cache 

```


### Type Module


Source: [client/modules.ts](https://github.com/slockit/in3/blob/master/src/client/modules.ts#L41)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `name <https://github.com/slockit/in3/blob/master/src/client/modules.ts#L42>`_
       - | the name 
     * - | `ChainContext <#type-chaincontext>`_ 
       - | `createChainContext <https://github.com/slockit/in3/blob/master/src/client/modules.ts#L44>`_ (
         |       client:`Client <#type-client>`_ ,
         |       chainId:``string``,
         |       spec:`ChainSpec <#type-chainspec>`_  [])
       - | Context for a specific chain including cache and chainSpecs. 
     * - | ``Promise<boolean>``
       - | `verifyProof <https://github.com/slockit/in3/blob/master/src/client/modules.ts#L46>`_ (
         |       request:`RPCRequest <#type-rpcrequest>`_ ,
         |       response:`RPCResponse <#type-rpcresponse>`_ ,
         |       allowWithoutProof:``boolean``,
         |       ctx:`ChainContext <#type-chaincontext>`_ )
       - | general verification-function which handles it according to its given type. 

```



## Package index.ts


### Type AccountProof


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L73)


the Proof-for a single Account
the Proof-for a single Account

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string`` []
       - | `accountProof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L42>`_
       - | the serialized merle-noodes beginning with the root-node 
     * - | ``string``
       - | `address <https://github.com/slockit/in3/blob/master/src/types/types.ts#L46>`_
       - | the address of this account 
     * - | ``string``
       - | `balance <https://github.com/slockit/in3/blob/master/src/types/types.ts#L50>`_
       - | the balance of this account as hex 
     * - | ``string``
       - | `code <https://github.com/slockit/in3/blob/master/src/types/types.ts#L58>`_
       - | the code of this account as hex ( if required)  *(optional)* 
     * - | ``string``
       - | `codeHash <https://github.com/slockit/in3/blob/master/src/types/types.ts#L54>`_
       - | the codeHash of this account as hex 
     * - | ``string``
       - | `nonce <https://github.com/slockit/in3/blob/master/src/types/types.ts#L62>`_
       - | the nonce of this account as hex 
     * - | ``string``
       - | `storageHash <https://github.com/slockit/in3/blob/master/src/types/types.ts#L66>`_
       - | the storageHash of this account as hex 
     * - |  []
       - | `storageProof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L70>`_
       - | proof for requested storage-data 

```


### Type AuraValidatoryProof


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L81)


a Object holding proofs for validator logs. The key is the blockNumber as hex
a Object holding proofs for validator logs. The key is the blockNumber as hex

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `block <https://github.com/slockit/in3/blob/master/src/types/types.ts#L97>`_
       - | the serialized blockheader
         | example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b 
     * - | ``any`` []
       - | `finalityBlocks <https://github.com/slockit/in3/blob/master/src/types/types.ts#L110>`_
       - | the serialized blockheader as hex, required in case of finality asked
         | example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b  *(optional)* 
     * - | ``number``
       - | `logIndex <https://github.com/slockit/in3/blob/master/src/types/types.ts#L92>`_
       - | the transaction log index 
     * - | ``string`` []
       - | `proof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L105>`_
       - | the merkleProof 
     * - | ``number``
       - | `txIndex <https://github.com/slockit/in3/blob/master/src/types/types.ts#L101>`_
       - | the transactionIndex within the block 

```


### Type ChainSpec


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L92)


describes the chainspecific consensus params
describes the chainspecific consensus params

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `block <https://github.com/slockit/in3/blob/master/src/types/types.ts#L119>`_
       - | the blocknumnber when this configuration should apply  *(optional)* 
     * - | ``number``
       - | `bypassFinality <https://github.com/slockit/in3/blob/master/src/types/types.ts#L141>`_
       - | Bypass finality check for transition to contract based Aura Engines
         | example: bypassFinality = 10960502 -> will skip the finality check and add the list at block 10960502  *(optional)* 
     * - | ``string``
       - | `contract <https://github.com/slockit/in3/blob/master/src/types/types.ts#L131>`_
       - | The validator contract at the block  *(optional)* 
     * - | ``'ethHash'`` 
         | | ``'authorityRound'`` 
         | | ``'clique'``
       - | `engine <https://github.com/slockit/in3/blob/master/src/types/types.ts#L123>`_
       - | the engine type (like Ethhash, authorityRound, ... )  *(optional)* 
     * - | ``string`` []
       - | `list <https://github.com/slockit/in3/blob/master/src/types/types.ts#L127>`_
       - | The list of validators at the particular block  *(optional)* 
     * - | ``boolean``
       - | `requiresFinality <https://github.com/slockit/in3/blob/master/src/types/types.ts#L136>`_
       - | indicates whether the transition requires a finality check
         | example: true  *(optional)* 

```


### Type IN3Client


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L45)


Client for N3.
Client for N3.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `defaultMaxListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L9>`_
       - | the defaultMaxListeners 
     * - | ``number``
       - | `listenerCount <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L8>`_ (
         |       emitter:`EventEmitter <#type-eventemitter>`_ ,
         |       event:``string`` 
         | | ``symbol``)
       - | listener count 
     * - | `Client <#type-client>`_ 
       - | `constructor <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L80>`_ (
         |       config:`Partial<IN3Config> <#type-partial>`_ ,
         |       transport:`Transport <#type-transport>`_ )
       - | creates a new Client. 
     * - | `IN3Config <#type-in3config>`_ 
       - | `defConfig <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L76>`_
       - | the defConfig 
     * - | `EthAPI <#type-ethapi>`_ 
       - | `eth <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L72>`_
       - | the eth 
     * - | `IpfsAPI <#type-ipfsapi>`_ 
       - | `ipfs <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L73>`_
       - | the ipfs 
     * - | `IN3Config <#type-in3config>`_ 
       - | `config <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L146>`_
       - | config 
     * - | ``this``
       - | `addListener <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L11>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | add listener 
     * - | ``Promise<any>``
       - | `call <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L259>`_ (
         |       method:``string``,
         |       params:``any``,
         |       chain:``string``,
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | sends a simply RPC-Request 
     * - | ``void``
       - | `clearStats <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L311>`_ ()
       - | clears all stats and weights, like blocklisted nodes 
     * - | ``any``
       - | `createWeb3Provider <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L127>`_ ()
       - | create web3 provider 
     * - | ``boolean``
       - | `emit <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L23>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       args:``any`` [])
       - | emit 
     * - | `Array<> <#type-array>`_ 
       - | `eventNames <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L24>`_ ()
       - | event names 
     * - | `ChainContext <#type-chaincontext>`_ 
       - | `getChainContext <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L134>`_ (
         |       chainId:``string``)
       - | Context for a specific chain including cache and chainSpecs. 
     * - | ``number``
       - | `getMaxListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L20>`_ ()
       - | get max listeners 
     * - | ``number``
       - | `listenerCount <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L25>`_ (
         |       type:``string`` 
         | | ``symbol``)
       - | listener count 
     * - | `Function <#type-function>`_  []
       - | `listeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L21>`_ (
         |       event:``string`` 
         | | ``symbol``)
       - | listeners 
     * - | ``this``
       - | `off <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L17>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | off 
     * - | ``this``
       - | `on <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L12>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | on 
     * - | ``this``
       - | `once <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L13>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | once 
     * - | ``this``
       - | `prependListener <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L14>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | prepend listener 
     * - | ``this``
       - | `prependOnceListener <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L15>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | prepend once listener 
     * - | `Function <#type-function>`_  []
       - | `rawListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L22>`_ (
         |       event:``string`` 
         | | ``symbol``)
       - | raw listeners 
     * - | ``this``
       - | `removeAllListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L18>`_ (
         |       event:``string`` 
         | | ``symbol``)
       - | remove all listeners 
     * - | ``this``
       - | `removeListener <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L16>`_ (
         |       event:``string`` 
         | | ``symbol``,
         |       listener:)
       - | remove listener 
     * - | ``Promise<>``
       - | `send <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L271>`_ (
         |       request:`RPCRequest <#type-rpcrequest>`_  [] 
         | | `RPCRequest <#type-rpcrequest>`_ ,
         |       callback:,
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | sends one or a multiple requests.
         | if the request is a array the response will be a array as well.
         | If the callback is given it will be called with the response, if not a Promise will be returned.
         | This function supports callback so it can be used as a Provider for the web3. 
     * - | `Promise<RPCResponse> <#type-rpcresponse>`_ 
       - | `sendRPC <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L248>`_ (
         |       method:``string``,
         |       params:``any`` [],
         |       chain:``string``,
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | sends a simply RPC-Request 
     * - | ``this``
       - | `setMaxListeners <https://github.com/slockit/in3/blob/master/src//Users/simon/ws/in3/ts/in3/node_modules/@types/node/events.d.ts#L19>`_ (
         |       n:``number``)
       - | set max listeners 
     * - | ``Promise<void>``
       - | `updateNodeList <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L182>`_ (
         |       chainId:``string``,
         |       conf:`Partial<IN3Config> <#type-partial>`_ ,
         |       retryCount:``number``)
       - | fetches the nodeList from the servers. 
     * - | ``Promise<void>``
       - | `updateWhiteListNodes <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L155>`_ (
         |       config:`IN3Config <#type-in3config>`_ )
       - | update white list nodes 
     * - | ``Promise<boolean>``
       - | `verifyResponse <https://github.com/slockit/in3/blob/master/src/client/Client.ts#L298>`_ (
         |       request:`RPCRequest <#type-rpcrequest>`_ ,
         |       response:`RPCResponse <#type-rpcresponse>`_ ,
         |       chain:``string``,
         |       config:`Partial<IN3Config> <#type-partial>`_ )
       - | Verify the response of a request without any effect on the state of the client.
         | Note: The node-list will not be updated.
         | The method will either return `true` if its inputs could be verified.
         |  Or else, it will throw an exception with a helpful message. 

```


### Type IN3Config


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L74)


the iguration of the IN3-Client. This can be paritally overriden for every request.
the iguration of the IN3-Client. This can be paritally overriden for every request.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``boolean``
       - | `archiveNodes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L287>`_
       - | if true the in3 client will filter out non archive supporting nodes
         | example: true  *(optional)* 
     * - | ``boolean``
       - | `autoConfig <https://github.com/slockit/in3/blob/master/src/types/types.ts#L173>`_
       - | if true the config will be adjusted depending on the request  *(optional)* 
     * - | ``boolean``
       - | `autoUpdateList <https://github.com/slockit/in3/blob/master/src/types/types.ts#L255>`_
       - | if true the nodelist will be automaticly updated if the lastBlock is newer
         | example: true  *(optional)* 
     * - | ``boolean``
       - | `binaryNodes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L297>`_
       - | if true the in3 client will only include nodes that support binary encording
         | example: true  *(optional)* 
     * - | ``any``
       - | `cacheStorage <https://github.com/slockit/in3/blob/master/src/types/types.ts#L259>`_
       - | a cache handler offering 2 functions ( setItem(string,string), getItem(string) )  *(optional)* 
     * - | ``number``
       - | `cacheTimeout <https://github.com/slockit/in3/blob/master/src/types/types.ts#L150>`_
       - | number of seconds requests can be cached.  *(optional)* 
     * - | ``string``
       - | `chainId <https://github.com/slockit/in3/blob/master/src/types/types.ts#L240>`_
       - | servers to filter for the given chain. The chain-id based on EIP-155.
         | example: 0x1 
     * - | ``string``
       - | `chainRegistry <https://github.com/slockit/in3/blob/master/src/types/types.ts#L245>`_
       - | main chain-registry contract
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945  *(optional)* 
     * - | ``number``
       - | `depositTimeout <https://github.com/slockit/in3/blob/master/src/types/types.ts#L307>`_
       - | timeout after which the owner is allowed to receive its stored deposit. This information is also important for the client
         | example: 3000  *(optional)* 
     * - | ``number``
       - | `finality <https://github.com/slockit/in3/blob/master/src/types/types.ts#L230>`_
       - | the number in percent needed in order reach finality (% of signature of the validators)
         | example: 50  *(optional)* 
     * - | ``'json'`` | ``'jsonRef'`` | ``'cbor'``
       - | `format <https://github.com/slockit/in3/blob/master/src/types/types.ts#L164>`_
       - | the format for sending the data to the client. Default is json, but using cbor means using only 30-40% of the payload since it is using binary encoding
         | example: json  *(optional)* 
     * - | ``boolean``
       - | `httpNodes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L292>`_
       - | if true the in3 client will include http nodes
         | example: true  *(optional)* 
     * - | ``boolean``
       - | `includeCode <https://github.com/slockit/in3/blob/master/src/types/types.ts#L187>`_
       - | if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
         | example: true  *(optional)* 
     * - | ``boolean``
       - | `keepIn3 <https://github.com/slockit/in3/blob/master/src/types/types.ts#L159>`_
       - | if true, the in3-section of thr response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.  *(optional)* 
     * - | ``any``
       - | `key <https://github.com/slockit/in3/blob/master/src/types/types.ts#L169>`_
       - | the client key to sign requests
         | example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7  *(optional)* 
     * - | ``string``
       - | `loggerUrl <https://github.com/slockit/in3/blob/master/src/types/types.ts#L263>`_
       - | a url of RES-Endpoint, the client will log all errors to. The client will post to this endpoint JSON like { id?, level, message, meta? }  *(optional)* 
     * - | ``string``
       - | `mainChain <https://github.com/slockit/in3/blob/master/src/types/types.ts#L250>`_
       - | main chain-id, where the chain registry is running.
         | example: 0x1  *(optional)* 
     * - | ``number``
       - | `maxAttempts <https://github.com/slockit/in3/blob/master/src/types/types.ts#L182>`_
       - | max number of attempts in case a response is rejected
         | example: 10  *(optional)* 
     * - | ``number``
       - | `maxBlockCache <https://github.com/slockit/in3/blob/master/src/types/types.ts#L197>`_
       - | number of number of blocks cached  in memory
         | example: 100  *(optional)* 
     * - | ``number``
       - | `maxCodeCache <https://github.com/slockit/in3/blob/master/src/types/types.ts#L192>`_
       - | number of max bytes used to cache the code in memory
         | example: 100000  *(optional)* 
     * - | ``number``
       - | `minDeposit <https://github.com/slockit/in3/blob/master/src/types/types.ts#L215>`_
       - | min stake of the server. Only nodes owning at least this amount will be chosen. 
     * - | ``boolean``
       - | `multichainNodes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L282>`_
       - | if true the in3 client will filter out nodes other then which have capability of the same RPC endpoint may also accept requests for different chains
         | example: true  *(optional)* 
     * - | ``number``
       - | `nodeLimit <https://github.com/slockit/in3/blob/master/src/types/types.ts#L155>`_
       - | the limit of nodes to store in the client.
         | example: 150  *(optional)* 
     * - | ``'none'`` | ``'standard'`` | ``'full'``
       - | `proof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L206>`_
       - | if true the nodes should send a proof of the response
         | example: true  *(optional)* 
     * - | ``boolean``
       - | `proofNodes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L277>`_
       - | if true the in3 client will filter out nodes which are providing no proof
         | example: true  *(optional)* 
     * - | ``number``
       - | `replaceLatestBlock <https://github.com/slockit/in3/blob/master/src/types/types.ts#L220>`_
       - | if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
         | example: 6  *(optional)* 
     * - | ``number``
       - | `requestCount <https://github.com/slockit/in3/blob/master/src/types/types.ts#L225>`_
       - | the number of request send when getting a first answer
         | example: 3 
     * - | ``boolean``
       - | `retryWithoutProof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L177>`_
       - | if true the the request may be handled without proof in case of an error. (use with care!)  *(optional)* 
     * - | ``string``
       - | `rpc <https://github.com/slockit/in3/blob/master/src/types/types.ts#L267>`_
       - | url of one or more rpc-endpoints to use. (list can be comma seperated)  *(optional)* 
     * - | 
       - | `servers <https://github.com/slockit/in3/blob/master/src/types/types.ts#L315>`_
       - | the nodelist per chain  *(optional)* 
     * - | ``number``
       - | `signatureCount <https://github.com/slockit/in3/blob/master/src/types/types.ts#L211>`_
       - | number of signatures requested
         | example: 2  *(optional)* 
     * - | ``number``
       - | `timeout <https://github.com/slockit/in3/blob/master/src/types/types.ts#L235>`_
       - | specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
         | example: 3000  *(optional)* 
     * - | ``boolean``
       - | `torNodes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L302>`_
       - | if true the in3 client will filter out non tor nodes
         | example: true  *(optional)* 
     * - | ``string`` []
       - | `verifiedHashes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L201>`_
       - | if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.  *(optional)* 
     * - | ``string`` []
       - | `whiteList <https://github.com/slockit/in3/blob/master/src/types/types.ts#L272>`_
       - | a list of in3 server addresses which are whitelisted manually by client
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b1  *(optional)* 
     * - | ``string``
       - | `whiteListContract <https://github.com/slockit/in3/blob/master/src/types/types.ts#L311>`_
       - | White list contract address  *(optional)* 

```


### Type IN3NodeConfig


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L75)


a configuration of a in3-server.
a configuration of a in3-server.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `address <https://github.com/slockit/in3/blob/master/src/types/types.ts#L389>`_
       - | the address of the node, which is the public address it iis signing with.
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679 
     * - | ``number``
       - | `capacity <https://github.com/slockit/in3/blob/master/src/types/types.ts#L414>`_
       - | the capacity of the node.
         | example: 100  *(optional)* 
     * - | ``string`` []
       - | `chainIds <https://github.com/slockit/in3/blob/master/src/types/types.ts#L404>`_
       - | the list of supported chains
         | example: 0x1 
     * - | ``number``
       - | `deposit <https://github.com/slockit/in3/blob/master/src/types/types.ts#L409>`_
       - | the deposit of the node in wei
         | example: 12350000 
     * - | ``number``
       - | `index <https://github.com/slockit/in3/blob/master/src/types/types.ts#L384>`_
       - | the index within the contract
         | example: 13  *(optional)* 
     * - | ``number``
       - | `props <https://github.com/slockit/in3/blob/master/src/types/types.ts#L419>`_
       - | the properties of the node.
         | example: 3  *(optional)* 
     * - | ``number``
       - | `registerTime <https://github.com/slockit/in3/blob/master/src/types/types.ts#L424>`_
       - | the UNIX-timestamp when the node was registered
         | example: 1563279168  *(optional)* 
     * - | ``number``
       - | `timeout <https://github.com/slockit/in3/blob/master/src/types/types.ts#L394>`_
       - | the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
         | example: 3600  *(optional)* 
     * - | ``number``
       - | `unregisterTime <https://github.com/slockit/in3/blob/master/src/types/types.ts#L429>`_
       - | the UNIX-timestamp when the node is allowed to be deregister
         | example: 1563279168  *(optional)* 
     * - | ``string``
       - | `url <https://github.com/slockit/in3/blob/master/src/types/types.ts#L399>`_
       - | the endpoint to post to
         | example: https://in3.slock.it 

```


### Type IN3NodeWeight


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L76)


a local weight of a n3-node. (This is used internally to weight the requests)
a local weight of a n3-node. (This is used internally to weight the requests)

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `avgResponseTime <https://github.com/slockit/in3/blob/master/src/types/types.ts#L449>`_
       - | average time of a response in ms
         | example: 240  *(optional)* 
     * - | ``number``
       - | `blacklistedUntil <https://github.com/slockit/in3/blob/master/src/types/types.ts#L463>`_
       - | blacklisted because of failed requests until the timestamp
         | example: 1529074639623  *(optional)* 
     * - | ``number``
       - | `lastRequest <https://github.com/slockit/in3/blob/master/src/types/types.ts#L458>`_
       - | timestamp of the last request in ms
         | example: 1529074632623  *(optional)* 
     * - | ``number``
       - | `pricePerRequest <https://github.com/slockit/in3/blob/master/src/types/types.ts#L453>`_
       - | last price  *(optional)* 
     * - | ``number``
       - | `responseCount <https://github.com/slockit/in3/blob/master/src/types/types.ts#L444>`_
       - | number of uses.
         | example: 147  *(optional)* 
     * - | ``number``
       - | `weight <https://github.com/slockit/in3/blob/master/src/types/types.ts#L439>`_
       - | factor the weight this noe (default 1.0)
         | example: 0.5  *(optional)* 

```


### Type IN3RPCConfig


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L90)


the configuration for the rpc-handler
the configuration for the rpc-handler

```eval_rst
  .. list-table::
     :widths: auto

     * - | 
       - | `chains <https://github.com/slockit/in3/blob/master/src/types/types.ts#L561>`_
       - | a definition of the Handler per chain  *(optional)* 
     * - | 
       - | `db <https://github.com/slockit/in3/blob/master/src/types/types.ts#L481>`_
       - | the db  *(optional)* 
     * - | ``string``
       - | `defaultChain <https://github.com/slockit/in3/blob/master/src/types/types.ts#L476>`_
       - | the default chainId in case the request does not contain one.  *(optional)* 
     * - | ``string``
       - | `id <https://github.com/slockit/in3/blob/master/src/types/types.ts#L472>`_
       - | a identifier used in logfiles as also for reading the config from the database  *(optional)* 
     * - | 
       - | `logging <https://github.com/slockit/in3/blob/master/src/types/types.ts#L528>`_
       - | logger config  *(optional)* 
     * - | ``number``
       - | `port <https://github.com/slockit/in3/blob/master/src/types/types.ts#L480>`_
       - | the listeneing port for the server  *(optional)* 
     * - | 
       - | `profile <https://github.com/slockit/in3/blob/master/src/types/types.ts#L503>`_
       - | the profile  *(optional)* 

```


### Type IN3RPCHandlerConfig


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L91)


the configuration for the rpc-handler
the configuration for the rpc-handler

```eval_rst
  .. list-table::
     :widths: auto

     * - | 
       - | `autoRegistry <https://github.com/slockit/in3/blob/master/src/types/types.ts#L633>`_
       - | the autoRegistry  *(optional)* 
     * - | ``string``
       - | `clientKeys <https://github.com/slockit/in3/blob/master/src/types/types.ts#L588>`_
       - | a comma sepearted list of client keys to use for simulating clients for the watchdog  *(optional)* 
     * - | ``number``
       - | `freeScore <https://github.com/slockit/in3/blob/master/src/types/types.ts#L596>`_
       - | the score for requests without a valid signature  *(optional)* 
     * - | ``'eth'`` | ``'ipfs'`` | ``'btc'``
       - | `handler <https://github.com/slockit/in3/blob/master/src/types/types.ts#L572>`_
       - | the impl used to handle the calls  *(optional)* 
     * - | ``string``
       - | `ipfsUrl <https://github.com/slockit/in3/blob/master/src/types/types.ts#L576>`_
       - | the url of the ipfs-client  *(optional)* 
     * - | ``number``
       - | `maxThreads <https://github.com/slockit/in3/blob/master/src/types/types.ts#L604>`_
       - | the maximal number of threads ofr running parallel processes  *(optional)* 
     * - | ``number``
       - | `minBlockHeight <https://github.com/slockit/in3/blob/master/src/types/types.ts#L600>`_
       - | the minimal blockheight in order to sign  *(optional)* 
     * - | ``string``
       - | `persistentFile <https://github.com/slockit/in3/blob/master/src/types/types.ts#L608>`_
       - | the filename of the file keeping track of the last handled blocknumber  *(optional)* 
     * - | ``string``
       - | `privateKey <https://github.com/slockit/in3/blob/master/src/types/types.ts#L620>`_
       - | the private key used to sign blockhashes. this can be either a 0x-prefixed string with the raw private key or the path to a key-file. 
     * - | ``string``
       - | `privateKeyPassphrase <https://github.com/slockit/in3/blob/master/src/types/types.ts#L624>`_
       - | the password used to decrpyt the private key  *(optional)* 
     * - | ``string``
       - | `registry <https://github.com/slockit/in3/blob/master/src/types/types.ts#L628>`_
       - | the address of the server registry used in order to update the nodeList 
     * - | ``string``
       - | `registryRPC <https://github.com/slockit/in3/blob/master/src/types/types.ts#L632>`_
       - | the url of the client in case the registry is not on the same chain.  *(optional)* 
     * - | ``string``
       - | `rpcUrl <https://github.com/slockit/in3/blob/master/src/types/types.ts#L584>`_
       - | the url of the client 
     * - | ``number``
       - | `startBlock <https://github.com/slockit/in3/blob/master/src/types/types.ts#L612>`_
       - | blocknumber to start watching the registry  *(optional)* 
     * - | ``number``
       - | `timeout <https://github.com/slockit/in3/blob/master/src/types/types.ts#L580>`_
       - | number of milliseconds to wait before a request gets a timeout  *(optional)* 
     * - | ``number``
       - | `watchInterval <https://github.com/slockit/in3/blob/master/src/types/types.ts#L616>`_
       - | the number of seconds of the interval for checking for new events  *(optional)* 
     * - | ``number``
       - | `watchdogInterval <https://github.com/slockit/in3/blob/master/src/types/types.ts#L592>`_
       - | average time between sending requests to the same node. 0 turns it off (default)  *(optional)* 

```


### Type IN3RPCRequestConfig


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L77)


additional config for a IN3 RPC-Request
additional config for a IN3 RPC-Request

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `chainId <https://github.com/slockit/in3/blob/master/src/types/types.ts#L670>`_
       - | the requested chainId
         | example: 0x1 
     * - | ``any``
       - | `clientSignature <https://github.com/slockit/in3/blob/master/src/types/types.ts#L709>`_
       - | the signature of the client  *(optional)* 
     * - | ``number``
       - | `finality <https://github.com/slockit/in3/blob/master/src/types/types.ts#L700>`_
       - | if given the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.  *(optional)* 
     * - | ``boolean``
       - | `includeCode <https://github.com/slockit/in3/blob/master/src/types/types.ts#L675>`_
       - | if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
         | example: true  *(optional)* 
     * - | ``number``
       - | `latestBlock <https://github.com/slockit/in3/blob/master/src/types/types.ts#L684>`_
       - | if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
         | example: 6  *(optional)* 
     * - | ``string`` []
       - | `signatures <https://github.com/slockit/in3/blob/master/src/types/types.ts#L714>`_
       - | a list of addresses requested to sign the blockhash
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679  *(optional)* 
     * - | ``boolean``
       - | `useBinary <https://github.com/slockit/in3/blob/master/src/types/types.ts#L692>`_
       - | if true binary-data will be used.  *(optional)* 
     * - | ``boolean``
       - | `useFullProof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L696>`_
       - | if true all data in the response will be proven, which leads to a higher payload.  *(optional)* 
     * - | ``boolean``
       - | `useRef <https://github.com/slockit/in3/blob/master/src/types/types.ts#L688>`_
       - | if true binary-data (starting with a 0x) will be refered if occuring again.  *(optional)* 
     * - | ``'never'`` 
         | | ``'proof'`` 
         | | ``'proofWithSignature'``
       - | `verification <https://github.com/slockit/in3/blob/master/src/types/types.ts#L705>`_
       - | defines the kind of proof the client is asking for
         | example: proof  *(optional)* 
     * - | ``string`` []
       - | `verifiedHashes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L679>`_
       - | if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number.  *(optional)* 
     * - | ``string``
       - | `version <https://github.com/slockit/in3/blob/master/src/types/types.ts#L719>`_
       - | IN3 protocol version that client can specify explicitly in request
         | example: 1.0.0  *(optional)* 
     * - | ``string``
       - | `whiteList <https://github.com/slockit/in3/blob/master/src/types/types.ts#L724>`_
       - | address of whitelist contract if added in3 server will register it in watch
         | and will notify client the whitelist event block number in reponses it depends on cahce settings  *(optional)* 

```


### Type IN3ResponseConfig


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L78)


additional data returned from a IN3 Server
additional data returned from a IN3 Server

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `currentBlock <https://github.com/slockit/in3/blob/master/src/types/types.ts#L747>`_
       - | the current blocknumber.
         | example: 320126478  *(optional)* 
     * - | ``number``
       - | `lastNodeList <https://github.com/slockit/in3/blob/master/src/types/types.ts#L738>`_
       - | the blocknumber for the last block updating the nodelist. If the client has a smaller blocknumber he should update the nodeList.
         | example: 326478  *(optional)* 
     * - | ``number``
       - | `lastValidatorChange <https://github.com/slockit/in3/blob/master/src/types/types.ts#L742>`_
       - | the blocknumber of the last change of the validatorList  *(optional)* 
     * - | ``number``
       - | `lastWhiteList <https://github.com/slockit/in3/blob/master/src/types/types.ts#L756>`_
       - | The blocknumber of the last white list event  *(optional)* 
     * - | `Proof <#type-proof>`_ 
       - | `proof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L733>`_
       - | the Proof-data  *(optional)* 
     * - | ``string``
       - | `version <https://github.com/slockit/in3/blob/master/src/types/types.ts#L752>`_
       - | IN3 protocol version
         | example: 1.0.0  *(optional)* 

```


### Type LogProof


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L79)


a Object holding proofs for event logs. The key is the blockNumber as hex
a Object holding proofs for event logs. The key is the blockNumber as hex



### Type Proof


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L80)


the Proof-data as part of the in3-section
the Proof-data as part of the in3-section

```eval_rst
  .. list-table::
     :widths: auto

     * - | 
       - | `accounts <https://github.com/slockit/in3/blob/master/src/types/types.ts#L849>`_
       - | a map of addresses and their AccountProof  *(optional)* 
     * - | ``string``
       - | `block <https://github.com/slockit/in3/blob/master/src/types/types.ts#L814>`_
       - | the serialized blockheader as hex, required in most proofs
         | example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b  *(optional)* 
     * - | ``any`` []
       - | `finalityBlocks <https://github.com/slockit/in3/blob/master/src/types/types.ts#L819>`_
       - | the serialized blockheader as hex, required in case of finality asked
         | example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b  *(optional)* 
     * - | `LogProof <#type-logproof>`_ 
       - | `logProof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L845>`_
       - | the Log Proof in case of a Log-Request  *(optional)* 
     * - | ``string`` []
       - | `merkleProof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L833>`_
       - | the serialized merle-noodes beginning with the root-node  *(optional)* 
     * - | ``string`` []
       - | `merkleProofPrev <https://github.com/slockit/in3/blob/master/src/types/types.ts#L837>`_
       - | the serialized merkle-noodes beginning with the root-node of the previous entry (only for full proof of receipts)  *(optional)* 
     * - | `Signature <#type-signature>`_  []
       - | `signatures <https://github.com/slockit/in3/blob/master/src/types/types.ts#L860>`_
       - | requested signatures  *(optional)* 
     * - | ``any`` []
       - | `transactions <https://github.com/slockit/in3/blob/master/src/types/types.ts#L824>`_
       - | the list of transactions of the block
         | example:  *(optional)* 
     * - | ``number``
       - | `txIndex <https://github.com/slockit/in3/blob/master/src/types/types.ts#L856>`_
       - | the transactionIndex within the block
         | example: 4  *(optional)* 
     * - | ``string`` []
       - | `txProof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L841>`_
       - | the serialized merkle-nodes beginning with the root-node in order to prrof the transactionIndex  *(optional)* 
     * - | ``'transactionProof'`` 
         | | ``'receiptProof'`` 
         | | ``'blockProof'`` 
         | | ``'accountProof'`` 
         | | ``'callProof'`` 
         | | ``'logProof'``
       - | `type <https://github.com/slockit/in3/blob/master/src/types/types.ts#L809>`_
       - | the type of the proof
         | example: accountProof 
     * - | ``any`` []
       - | `uncles <https://github.com/slockit/in3/blob/master/src/types/types.ts#L829>`_
       - | the list of uncle-headers of the block
         | example:  *(optional)* 

```


### Type RPCRequest


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L72)


a JSONRPC-Request with N3-Extension
a JSONRPC-Request with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number`` | ``string``
       - | `id <https://github.com/slockit/in3/blob/master/src/types/types.ts#L879>`_
       - | the identifier of the request
         | example: 2  *(optional)* 
     * - | `IN3RPCRequestConfig <#type-in3rpcrequestconfig>`_ 
       - | `in3 <https://github.com/slockit/in3/blob/master/src/types/types.ts#L888>`_
       - | the IN3-Config  *(optional)* 
     * - | ``'2.0'``
       - | `jsonrpc <https://github.com/slockit/in3/blob/master/src/types/types.ts#L869>`_
       - | the version 
     * - | ``string``
       - | `method <https://github.com/slockit/in3/blob/master/src/types/types.ts#L874>`_
       - | the method to call
         | example: eth_getBalance 
     * - | ``any`` []
       - | `params <https://github.com/slockit/in3/blob/master/src/types/types.ts#L884>`_
       - | the params
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest  *(optional)* 

```


### Type RPCResponse


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L82)


a JSONRPC-Responset with N3-Extension
a JSONRPC-Responset with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `error <https://github.com/slockit/in3/blob/master/src/types/types.ts#L906>`_
       - | in case of an error this needs to be set  *(optional)* 
     * - | ``string`` | ``number``
       - | `id <https://github.com/slockit/in3/blob/master/src/types/types.ts#L902>`_
       - | the id matching the request
         | example: 2 
     * - | `IN3ResponseConfig <#type-in3responseconfig>`_ 
       - | `in3 <https://github.com/slockit/in3/blob/master/src/types/types.ts#L915>`_
       - | the IN3-Result  *(optional)* 
     * - | `IN3NodeConfig <#type-in3nodeconfig>`_ 
       - | `in3Node <https://github.com/slockit/in3/blob/master/src/types/types.ts#L919>`_
       - | the node handling this response (internal only)  *(optional)* 
     * - | ``'2.0'``
       - | `jsonrpc <https://github.com/slockit/in3/blob/master/src/types/types.ts#L897>`_
       - | the version 
     * - | ``any``
       - | `result <https://github.com/slockit/in3/blob/master/src/types/types.ts#L911>`_
       - | the params
         | example: 0xa35bc  *(optional)* 

```


### Type ServerList


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L85)


a List of nodes
a List of nodes

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `contract <https://github.com/slockit/in3/blob/master/src/types/types.ts#L936>`_
       - | IN3 Registry  *(optional)* 
     * - | ``number``
       - | `lastBlockNumber <https://github.com/slockit/in3/blob/master/src/types/types.ts#L928>`_
       - | last Block number  *(optional)* 
     * - | `IN3NodeConfig <#type-in3nodeconfig>`_  []
       - | `nodes <https://github.com/slockit/in3/blob/master/src/types/types.ts#L932>`_
       - | the list of nodes 
     * - | `Proof <#type-proof>`_ 
       - | `proof <https://github.com/slockit/in3/blob/master/src/types/types.ts#L945>`_
       - | the proof  *(optional)* 
     * - | ``string``
       - | `registryId <https://github.com/slockit/in3/blob/master/src/types/types.ts#L940>`_
       - | registry id of the contract  *(optional)* 
     * - | ``number``
       - | `totalServers <https://github.com/slockit/in3/blob/master/src/types/types.ts#L944>`_
       - | number of servers  *(optional)* 

```


### Type Signature


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L83)


Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.
Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `address <https://github.com/slockit/in3/blob/master/src/types/types.ts#L955>`_
       - | the address of the signing node
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679  *(optional)* 
     * - | ``number``
       - | `block <https://github.com/slockit/in3/blob/master/src/types/types.ts#L960>`_
       - | the blocknumber
         | example: 3123874 
     * - | ``string``
       - | `blockHash <https://github.com/slockit/in3/blob/master/src/types/types.ts#L965>`_
       - | the hash of the block
         | example: 0x6C1a01C2aB554930A937B0a212346037E8105fB47946c679 
     * - | ``string``
       - | `msgHash <https://github.com/slockit/in3/blob/master/src/types/types.ts#L970>`_
       - | hash of the message
         | example: 0x9C1a01C2aB554930A937B0a212346037E8105fB47946AB5D 
     * - | ``string``
       - | `r <https://github.com/slockit/in3/blob/master/src/types/types.ts#L975>`_
       - | Positive non-zero Integer signature.r
         | example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1f 
     * - | ``string``
       - | `s <https://github.com/slockit/in3/blob/master/src/types/types.ts#L980>`_
       - | Positive non-zero Integer signature.s
         | example: 0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda 
     * - | ``number``
       - | `v <https://github.com/slockit/in3/blob/master/src/types/types.ts#L985>`_
       - | Calculated curve point, or identity element O.
         | example: 28 

```


### Type Transport


Source: [index.ts](https://github.com/slockit/in3/blob/master/src/index.ts#L84)



 = [_transporttype](#type-_transporttype)  




## Package modules/eth


### Type EthAPI


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L290)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `EthAPI <#type-ethapi>`_ 
       - | `constructor <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L292>`_ (
         |       client:`Client <#type-client>`_ )
       - | constructor 
     * - | `Client <#type-client>`_ 
       - | `client <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L291>`_
       - | the client 
     * - | `Signer <#type-signer>`_ 
       - | `signer <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L292>`_
       - | the signer  *(optional)* 
     * - | ``Promise<number>``
       - | `blockNumber <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L307>`_ ()
       - | Returns the number of most recent block. (as number) 
     * - | ``Promise<string>``
       - | `call <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L320>`_ (
         |       tx:`Transaction <#type-transaction>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Executes a new message call immediately without creating a transaction on the block chain. 
     * - | ``Promise<any>``
       - | `callFn <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L327>`_ (
         |       to:`Address <#type-address>`_ ,
         |       method:``string``,
         |       args:``any`` [])
       - | Executes a function of a contract, by passing a [method-signature](https://github.com/ethereumjs/ethereumjs-abi/blob/master/README.md#simple-encoding-and-decoding) and the arguments, which will then be ABI-encoded and send as eth_call. 
     * - | ``Promise<string>``
       - | `chainId <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L335>`_ ()
       - | Returns the EIP155 chain ID used for transaction signing at the current best block. Null is returned if not available. 
     * - | 
       - | `contractAt <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L627>`_ (
         |       abi:`ABI <#type-abi>`_  [],
         |       address:`Address <#type-address>`_ )
       - | contract at 
     * - | ``any``
       - | `decodeEventData <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L708>`_ (
         |       log:`Log <#type-log>`_ ,
         |       d:`ABI <#type-abi>`_ )
       - | decode event data 
     * - | ``Promise<number>``
       - | `estimateGas <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L342>`_ (
         |       tx:`Transaction <#type-transaction>`_ )
       - | Makes a call or transaction, which won’t be added to the blockchain and returns the used gas, which can be used for estimating the used gas. 
     * - | ``Promise<number>``
       - | `gasPrice <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L313>`_ ()
       - | Returns the current price per gas in wei. (as number) 
     * - | `Promise<BN> <#type-bn>`_ 
       - | `getBalance <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L349>`_ (
         |       address:`Address <#type-address>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns the balance of the account of given address in wei (as hex). 
     * - | `Promise<Block> <#type-block>`_ 
       - | `getBlockByHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L372>`_ (
         |       hash:`Hash <#type-hash>`_ ,
         |       includeTransactions:``boolean``)
       - | Returns information about a block by hash. 
     * - | `Promise<Block> <#type-block>`_ 
       - | `getBlockByNumber <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L379>`_ (
         |       block:`BlockType <#type-blocktype>`_ ,
         |       includeTransactions:``boolean``)
       - | Returns information about a block by block number. 
     * - | ``Promise<number>``
       - | `getBlockTransactionCountByHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L387>`_ (
         |       block:`Hash <#type-hash>`_ )
       - | Returns the number of transactions in a block from a block matching the given block hash. 
     * - | ``Promise<number>``
       - | `getBlockTransactionCountByNumber <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L395>`_ (
         |       block:`Hash <#type-hash>`_ )
       - | Returns the number of transactions in a block from a block matching the given block number. 
     * - | ``Promise<string>``
       - | `getCode <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L356>`_ (
         |       address:`Address <#type-address>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns code at a given address. 
     * - | ``Promise<>``
       - | `getFilterChanges <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L402>`_ (
         |       id:`Quantity <#type-quantity>`_ )
       - | Polling method for a filter, which returns an array of logs which occurred since last poll. 
     * - | ``Promise<>``
       - | `getFilterLogs <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L409>`_ (
         |       id:`Quantity <#type-quantity>`_ )
       - | Returns an array of all logs matching filter with given id. 
     * - | ``Promise<>``
       - | `getLogs <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L416>`_ (
         |       filter:`LogFilter <#type-logfilter>`_ )
       - | Returns an array of all logs matching a given filter object. 
     * - | ``Promise<string>``
       - | `getStorageAt <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L364>`_ (
         |       address:`Address <#type-address>`_ ,
         |       pos:`Quantity <#type-quantity>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns the value from a storage position at a given address. 
     * - | `Promise<TransactionDetail> <#type-transactiondetail>`_ 
       - | `getTransactionByBlockHashAndIndex <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L429>`_ (
         |       hash:`Hash <#type-hash>`_ ,
         |       pos:`Quantity <#type-quantity>`_ )
       - | Returns information about a transaction by block hash and transaction index position. 
     * - | `Promise<TransactionDetail> <#type-transactiondetail>`_ 
       - | `getTransactionByBlockNumberAndIndex <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L437>`_ (
         |       block:`BlockType <#type-blocktype>`_ ,
         |       pos:`Quantity <#type-quantity>`_ )
       - | Returns information about a transaction by block number and transaction index position. 
     * - | `Promise<TransactionDetail> <#type-transactiondetail>`_ 
       - | `getTransactionByHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L444>`_ (
         |       hash:`Hash <#type-hash>`_ )
       - | Returns the information about a transaction requested by transaction hash. 
     * - | ``Promise<number>``
       - | `getTransactionCount <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L451>`_ (
         |       address:`Address <#type-address>`_ ,
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns the number of transactions sent from an address. (as number) 
     * - | `Promise<TransactionReceipt> <#type-transactionreceipt>`_ 
       - | `getTransactionReceipt <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L459>`_ (
         |       hash:`Hash <#type-hash>`_ )
       - | Returns the receipt of a transaction by transaction hash.
         | Note That the receipt is available even for pending transactions. 
     * - | `Promise<Block> <#type-block>`_ 
       - | `getUncleByBlockHashAndIndex <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L471>`_ (
         |       hash:`Hash <#type-hash>`_ ,
         |       pos:`Quantity <#type-quantity>`_ )
       - | Returns information about a uncle of a block by hash and uncle index position.
         | Note: An uncle doesn’t contain individual transactions. 
     * - | `Promise<Block> <#type-block>`_ 
       - | `getUncleByBlockNumberAndIndex <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L480>`_ (
         |       block:`BlockType <#type-blocktype>`_ ,
         |       pos:`Quantity <#type-quantity>`_ )
       - | Returns information about a uncle of a block number and uncle index position.
         | Note: An uncle doesn’t contain individual transactions. 
     * - | ``Promise<number>``
       - | `getUncleCountByBlockHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L487>`_ (
         |       hash:`Hash <#type-hash>`_ )
       - | Returns the number of uncles in a block from a block matching the given block hash. 
     * - | ``Promise<number>``
       - | `getUncleCountByBlockNumber <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L494>`_ (
         |       block:`BlockType <#type-blocktype>`_ )
       - | Returns the number of uncles in a block from a block matching the given block hash. 
     * - | `Buffer <#type-buffer>`_ 
       - | `hashMessage <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L711>`_ (
         |       data:`Data <#type-data>`_  
         | | `Buffer <#type-buffer>`_ )
       - | hash message 
     * - | ``Promise<string>``
       - | `newBlockFilter <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L502>`_ ()
       - | Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges. 
     * - | ``Promise<string>``
       - | `newFilter <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L519>`_ (
         |       filter:`LogFilter <#type-logfilter>`_ )
       - | Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges. 
     * - | ``Promise<string>``
       - | `newPendingTransactionFilter <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L528>`_ ()
       - | Creates a filter in the node, to notify when new pending transactions arrive. 
     * - | ``Promise<string>``
       - | `protocolVersion <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L543>`_ ()
       - | Returns the current ethereum protocol version. 
     * - | ``Promise<string>``
       - | `sendRawTransaction <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L572>`_ (
         |       data:`Data <#type-data>`_ )
       - | Creates new message call transaction or a contract creation for signed transactions. 
     * - | ``Promise<>``
       - | `sendTransaction <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L599>`_ (
         |       args:`TxRequest <#type-txrequest>`_ )
       - | sends a Transaction 
     * - | `Promise<Signature> <#type-signature>`_ 
       - | `sign <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L581>`_ (
         |       account:`Address <#type-address>`_ ,
         |       data:`Data <#type-data>`_ )
       - | signs any kind of message using the `\x19Ethereum Signed Message:\n`-prefix 
     * - | ``Promise<>``
       - | `syncing <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L550>`_ ()
       - | Returns the current ethereum protocol version. 
     * - | `Promise<Quantity> <#type-quantity>`_ 
       - | `uninstallFilter <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L536>`_ (
         |       id:`Quantity <#type-quantity>`_ )
       - | Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren’t requested with eth_getFilterChanges for a period of time. 

```


### Type chainData


Source: [modules/eth/chainData.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L1)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``Promise<any>``
       - | `callContract <https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L42>`_ (
         |       client:`Client <#type-client>`_ ,
         |       contract:``string``,
         |       chainId:``string``,
         |       signature:``string``,
         |       args:``any`` [],
         |       config:`IN3Config <#type-in3config>`_ )
       - | call contract 
     * - | ``Promise<>``
       - | `getChainData <https://github.com/slockit/in3/blob/master/src/modules/eth/chainData.ts#L51>`_ (
         |       client:`Client <#type-client>`_ ,
         |       chainId:``string``,
         |       config:`IN3Config <#type-in3config>`_ )
       - | get chain data 

```


### Type header


Source: [modules/eth/header.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L1)




```eval_rst
  .. list-table::
     :widths: auto

     * - | Interface
       - | `AuthSpec <#type-authspec>`_ 
       - | Authority specification for proof of authority chains
     * - | Interface
       - | `HistoryEntry <#type-historyentry>`_ 
       - | the HistoryEntry
     * - | ``Promise<void>``
       - | `addAuraValidators <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L168>`_ (
         |       history:`DeltaHistory<string> <#type-deltahistory>`_ ,
         |       ctx:`ChainContext <#type-chaincontext>`_ ,
         |       states:`HistoryEntry <#type-historyentry>`_  [],
         |       contract:``string``)
       - | add aura validators 
     * - | ``void``
       - | `addCliqueValidators <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L128>`_ (
         |       history:`DeltaHistory<string> <#type-deltahistory>`_ ,
         |       ctx:`ChainContext <#type-chaincontext>`_ ,
         |       states:`HistoryEntry <#type-historyentry>`_  [])
       - | add clique validators 
     * - | ``Promise<number>``
       - | `checkBlockSignatures <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L60>`_ (
         |       blockHeaders:``any`` [],
         |       getChainSpec:)
       - | verify a Blockheader and returns the percentage of finality 
     * - | ``void``
       - | `checkForFinality <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L233>`_ (
         |       stateBlockNumber:``number``,
         |       proof:`AuraValidatoryProof <#type-auravalidatoryproof>`_ ,
         |       current:`Buffer <#type-buffer>`_  [],
         |       _finality:``number``)
       - | check for finality 
     * - | ``Promise<void>``
       - | `checkForValidators <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L213>`_ (
         |       ctx:`ChainContext <#type-chaincontext>`_ ,
         |       validators:`DeltaHistory<string> <#type-deltahistory>`_ )
       - | check for validators 
     * - | `Promise<AuthSpec> <#type-authspec>`_ 
       - | `getChainSpec <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L263>`_ (
         |       b:`Block <#type-block>`_ ,
         |       ctx:`ChainContext <#type-chaincontext>`_ )
       - | get chain spec 
     * - | `Buffer <#type-buffer>`_ 
       - | `getCliqueSigner <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L120>`_ (
         |       data:`Block <#type-block>`_ )
       - | get clique signer 
     * - | `Buffer <#type-buffer>`_ 
       - | `getSigner <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L109>`_ (
         |       data:`Block <#type-block>`_ )
       - | get signer 

```


### Type Signer


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L278)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Promise<Transaction> <#type-transaction>`_ 
       - | `prepareTransaction <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L280>`_ (
         |       client:`Client <#type-client>`_ ,
         |       tx:`Transaction <#type-transaction>`_ )
       - | optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig. 
     * - | `Promise<Signature> <#type-signature>`_ 
       - | `sign <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L286>`_ (
         |       data:`Buffer <#type-buffer>`_ ,
         |       account:`Address <#type-address>`_ )
       - | signing of any data. 
     * - | ``Promise<boolean>``
       - | `hasAccount <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L283>`_ (
         |       account:`Address <#type-address>`_ )
       - | returns true if the account is supported (or unlocked) 

```


### Type Transaction


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L76)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``any``
       - | `chainId <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L92>`_
       - | optional chain id  *(optional)* 
     * - | ``string``
       - | `data <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L88>`_
       - | 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI. 
     * - | `Address <#type-address>`_ 
       - | `from <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L78>`_
       - | 20 Bytes - The address the transaction is send from. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gas <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L82>`_
       - | Integer of the gas provided for the transaction execution. eth_call consumes zero gas, but this parameter may be needed by some executions. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasPrice <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L84>`_
       - | Integer of the gas price used for each paid gas. 
     * - | `Quantity <#type-quantity>`_ 
       - | `nonce <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L90>`_
       - | nonce 
     * - | `Address <#type-address>`_ 
       - | `to <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L80>`_
       - | (optional when creating new contract) 20 Bytes - The address the transaction is directed to. 
     * - | `Quantity <#type-quantity>`_ 
       - | `value <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L86>`_
       - | Integer of the value sent with this transaction. 

```


### Type BlockType


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L44)



 = `number` | `'latest'` | `'earliest'` | `'pending'`



### Type Address


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L48)



 = `string`



### Type ABI


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L65)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``boolean``
       - | `anonymous <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L66>`_
       - | the anonymous  *(optional)* 
     * - | ``boolean``
       - | `constant <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L67>`_
       - | the constant  *(optional)* 
     * - | `ABIField <#type-abifield>`_  []
       - | `inputs <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L71>`_
       - | the inputs  *(optional)* 
     * - | ``string``
       - | `name <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L73>`_
       - | the name  *(optional)* 
     * - | `ABIField <#type-abifield>`_  []
       - | `outputs <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L72>`_
       - | the outputs  *(optional)* 
     * - | ``boolean``
       - | `payable <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L68>`_
       - | the payable  *(optional)* 
     * - | ``'nonpayable'`` 
         | | ``'payable'`` 
         | | ``'view'`` 
         | | ``'pure'``
       - | `stateMutability <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L69>`_
       - | the stateMutability  *(optional)* 
     * - | ``'event'`` 
         | | ``'function'`` 
         | | ``'constructor'`` 
         | | ``'fallback'``
       - | `type <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L74>`_
       - | the type 

```


### Type Log


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L209)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Address <#type-address>`_ 
       - | `address <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L223>`_
       - | 20 Bytes - address from which this log originated. 
     * - | `Hash <#type-hash>`_ 
       - | `blockHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L219>`_
       - | Hash, 32 Bytes - hash of the block where this log was in. null when its pending. null when its pending log. 
     * - | `Quantity <#type-quantity>`_ 
       - | `blockNumber <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L221>`_
       - | the block number where this log was in. null when its pending. null when its pending log. 
     * - | `Data <#type-data>`_ 
       - | `data <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L225>`_
       - | contains the non-indexed arguments of the log. 
     * - | `Quantity <#type-quantity>`_ 
       - | `logIndex <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L213>`_
       - | integer of the log index position in the block. null when its pending log. 
     * - | ``boolean``
       - | `removed <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L211>`_
       - | true when the log was removed, due to a chain reorganization. false if its a valid log. 
     * - | `Data <#type-data>`_  []
       - | `topics <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L227>`_
       - | - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.) 
     * - | `Hash <#type-hash>`_ 
       - | `transactionHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L217>`_
       - | Hash, 32 Bytes - hash of the transactions this log was created from. null when its pending log. 
     * - | `Quantity <#type-quantity>`_ 
       - | `transactionIndex <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L215>`_
       - | integer of the transactions index position log was created from. null when its pending log. 

```


### Type Block


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L165)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Address <#type-address>`_ 
       - | `author <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L185>`_
       - | 20 Bytes - the address of the author of the block (the beneficiary to whom the mining rewards were given) 
     * - | `Quantity <#type-quantity>`_ 
       - | `difficulty <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L189>`_
       - | integer of the difficulty for this block 
     * - | `Data <#type-data>`_ 
       - | `extraData <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L193>`_
       - | the ‘extra data’ field of this block 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasLimit <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L197>`_
       - | the maximum gas allowed in this block 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasUsed <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L199>`_
       - | the total used gas by all transactions in this block 
     * - | `Hash <#type-hash>`_ 
       - | `hash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L169>`_
       - | hash of the block. null when its pending block 
     * - | `Data <#type-data>`_ 
       - | `logsBloom <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L177>`_
       - | 256 Bytes - the bloom filter for the logs of the block. null when its pending block 
     * - | `Address <#type-address>`_ 
       - | `miner <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L187>`_
       - | 20 Bytes - alias of ‘author’ 
     * - | `Data <#type-data>`_ 
       - | `nonce <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L173>`_
       - | 8 bytes hash of the generated proof-of-work. null when its pending block. Missing in case of PoA. 
     * - | `Quantity <#type-quantity>`_ 
       - | `number <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L167>`_
       - | The block number. null when its pending block 
     * - | `Hash <#type-hash>`_ 
       - | `parentHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L171>`_
       - | hash of the parent block 
     * - | `Data <#type-data>`_ 
       - | `receiptsRoot <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L183>`_
       - | 32 Bytes - the root of the receipts trie of the block 
     * - | `Data <#type-data>`_  []
       - | `sealFields <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L207>`_
       - | PoA-Fields 
     * - | `Data <#type-data>`_ 
       - | `sha3Uncles <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L175>`_
       - | SHA3 of the uncles data in the block 
     * - | `Quantity <#type-quantity>`_ 
       - | `size <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L195>`_
       - | integer the size of this block in bytes 
     * - | `Data <#type-data>`_ 
       - | `stateRoot <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L181>`_
       - | 32 Bytes - the root of the final state trie of the block 
     * - | `Quantity <#type-quantity>`_ 
       - | `timestamp <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L201>`_
       - | the unix timestamp for when the block was collated 
     * - | `Quantity <#type-quantity>`_ 
       - | `totalDifficulty <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L191>`_
       - | integer of the total difficulty of the chain until this block 
     * - | ``string`` |  []
       - | `transactions <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L203>`_
       - | Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter 
     * - | `Data <#type-data>`_ 
       - | `transactionsRoot <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L179>`_
       - | 32 Bytes - the root of the transaction trie of the block 
     * - | `Hash <#type-hash>`_  []
       - | `uncles <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L205>`_
       - | Array of uncle hashes 

```


### Type Hash


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L47)



 = `string`



### Type Quantity


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L46)



 = `number` | [Hex](#type-hex) 



### Type LogFilter


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L230)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Address <#type-address>`_ 
       - | `address <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L236>`_
       - | (optional) 20 Bytes - Contract address or a list of addresses from which logs should originate. 
     * - | `BlockType <#type-blocktype>`_ 
       - | `fromBlock <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L232>`_
       - | Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions. 
     * - | `Quantity <#type-quantity>`_ 
       - | `limit <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L240>`_
       - | å(optional) The maximum number of entries to retrieve (latest first). 
     * - | `BlockType <#type-blocktype>`_ 
       - | `toBlock <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L234>`_
       - | Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions. 
     * - | ``string`` | ``string`` [] []
       - | `topics <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L238>`_
       - | (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching. 

```


### Type TransactionDetail


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L122)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Hash <#type-hash>`_ 
       - | `blockHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L128>`_
       - | 32 Bytes - hash of the block where this transaction was in. null when its pending. 
     * - | `BlockType <#type-blocktype>`_ 
       - | `blockNumber <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L130>`_
       - | block number where this transaction was in. null when its pending. 
     * - | `Quantity <#type-quantity>`_ 
       - | `chainId <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L156>`_
       - | the chain id of the transaction, if any. 
     * - | ``any``
       - | `condition <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L160>`_
       - | (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature) 
     * - | `Address <#type-address>`_ 
       - | `creates <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L158>`_
       - | creates contract address 
     * - | `Address <#type-address>`_ 
       - | `from <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L134>`_
       - | 20 Bytes - address of the sender. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gas <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L142>`_
       - | gas provided by the sender. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasPrice <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L140>`_
       - | gas price provided by the sender in Wei. 
     * - | `Hash <#type-hash>`_ 
       - | `hash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L124>`_
       - | 32 Bytes - hash of the transaction. 
     * - | `Data <#type-data>`_ 
       - | `input <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L144>`_
       - | the data send along with the transaction. 
     * - | `Quantity <#type-quantity>`_ 
       - | `nonce <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L126>`_
       - | the number of transactions made by the sender prior to this one. 
     * - | ``any``
       - | `pk <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L162>`_
       - | optional: the private key to use for signing  *(optional)* 
     * - | `Hash <#type-hash>`_ 
       - | `publicKey <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L154>`_
       - | public key of the signer. 
     * - | `Quantity <#type-quantity>`_ 
       - | `r <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L150>`_
       - | the R field of the signature. 
     * - | `Data <#type-data>`_ 
       - | `raw <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L152>`_
       - | raw transaction data 
     * - | `Quantity <#type-quantity>`_ 
       - | `standardV <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L148>`_
       - | the standardised V field of the signature (0 or 1). 
     * - | `Address <#type-address>`_ 
       - | `to <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L136>`_
       - | 20 Bytes - address of the receiver. null when its a contract creation transaction. 
     * - | `Quantity <#type-quantity>`_ 
       - | `transactionIndex <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L132>`_
       - | integer of the transactions index position in the block. null when its pending. 
     * - | `Quantity <#type-quantity>`_ 
       - | `v <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L146>`_
       - | the standardised V field of the signature. 
     * - | `Quantity <#type-quantity>`_ 
       - | `value <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L138>`_
       - | value transferred in Wei. 

```


### Type TransactionReceipt


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L94)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Hash <#type-hash>`_ 
       - | `blockHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L96>`_
       - | 32 Bytes - hash of the block where this transaction was in. 
     * - | `BlockType <#type-blocktype>`_ 
       - | `blockNumber <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L98>`_
       - | block number where this transaction was in. 
     * - | `Address <#type-address>`_ 
       - | `contractAddress <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L100>`_
       - | 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null. 
     * - | `Quantity <#type-quantity>`_ 
       - | `cumulativeGasUsed <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L102>`_
       - | The total amount of gas used when this transaction was executed in the block. 
     * - | `Address <#type-address>`_ 
       - | `from <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L104>`_
       - | 20 Bytes - The address of the sender. 
     * - | `Quantity <#type-quantity>`_ 
       - | `gasUsed <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L108>`_
       - | The amount of gas used by this specific transaction alone. 
     * - | `Log <#type-log>`_  []
       - | `logs <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L110>`_
       - | Array of log objects, which this transaction generated. 
     * - | `Data <#type-data>`_ 
       - | `logsBloom <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L112>`_
       - | 256 Bytes - A bloom filter of logs/events generated by contracts during transaction execution. Used to efficiently rule out transactions without expected logs. 
     * - | `Hash <#type-hash>`_ 
       - | `root <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L114>`_
       - | 32 Bytes - Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork EIP609) 
     * - | `Quantity <#type-quantity>`_ 
       - | `status <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L116>`_
       - | 0x0 indicates transaction failure , 0x1 indicates transaction success. Set for blocks mined after Byzantium hard fork EIP609, null before. 
     * - | `Address <#type-address>`_ 
       - | `to <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L106>`_
       - | 20 Bytes - The address of the receiver. null when it’s a contract creation transaction. 
     * - | `Hash <#type-hash>`_ 
       - | `transactionHash <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L118>`_
       - | 32 Bytes - hash of the transaction. 
     * - | `Quantity <#type-quantity>`_ 
       - | `transactionIndex <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L120>`_
       - | Integer of the transactions index position in the block. 

```


### Type Data


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L49)



 = `string`



### Type TxRequest


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L243)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``any`` []
       - | `args <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L269>`_
       - | the argument to pass to the method  *(optional)* 
     * - | ``number``
       - | `confirmations <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L275>`_
       - | number of block to wait before confirming  *(optional)* 
     * - | `Data <#type-data>`_ 
       - | `data <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L251>`_
       - | the data to send  *(optional)* 
     * - | `Address <#type-address>`_ 
       - | `from <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L248>`_
       - | address of the account to use  *(optional)* 
     * - | ``number``
       - | `gas <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L254>`_
       - | the gas needed  *(optional)* 
     * - | ``number``
       - | `gasPrice <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L257>`_
       - | the gasPrice used  *(optional)* 
     * - | ``string``
       - | `method <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L266>`_
       - | the ABI of the method to be used  *(optional)* 
     * - | ``number``
       - | `nonce <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L260>`_
       - | the nonce  *(optional)* 
     * - | `Hash <#type-hash>`_ 
       - | `pk <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L272>`_
       - | raw private key in order to sign  *(optional)* 
     * - | `Address <#type-address>`_ 
       - | `to <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L245>`_
       - | contract  *(optional)* 
     * - | `Quantity <#type-quantity>`_ 
       - | `value <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L263>`_
       - | the value in wei  *(optional)* 

```


### Type AuthSpec


Source: [modules/eth/header.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L46)


Authority specification for proof of authority chains

```eval_rst
  .. list-table::
     :widths: auto

     * - | `Buffer <#type-buffer>`_  []
       - | `authorities <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L48>`_
       - | List of validator addresses storead as an buffer array 
     * - | `Buffer <#type-buffer>`_ 
       - | `proposer <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L52>`_
       - | proposer of the block this authspec belongs 
     * - | `ChainSpec <#type-chainspec>`_ 
       - | `spec <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L50>`_
       - | chain specification 

```


### Type HistoryEntry


Source: [modules/eth/header.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L115)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `block <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L117>`_
       - | the block 
     * - | `AuraValidatoryProof <#type-auravalidatoryproof>`_  
         | | ``string`` []
       - | `proof <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L118>`_
       - | the proof 
     * - | ``string`` []
       - | `validators <https://github.com/slockit/in3/blob/master/src/modules/eth/header.ts#L116>`_
       - | the validators 

```


### Type ABIField


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L60)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``boolean``
       - | `indexed <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L61>`_
       - | the indexed  *(optional)* 
     * - | ``string``
       - | `name <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L62>`_
       - | the name 
     * - | ``string``
       - | `type <https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L63>`_
       - | the type 

```


### Type Hex


Source: [modules/eth/api.ts](https://github.com/slockit/in3/blob/master/src/modules/eth/api.ts#L45)



 = `string`




## Package modules/ipfs


### Type IpfsAPI


Source: [modules/ipfs/api.ts](https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L40)


simple API for IPFS

```eval_rst
  .. list-table::
     :widths: auto

     * - | `IpfsAPI <#type-ipfsapi>`_ 
       - | `constructor <https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L41>`_ (
         |       _client:`Client <#type-client>`_ )
       - | simple API for IPFS 
     * - | `Client <#type-client>`_ 
       - | `client <https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L41>`_
       - | the client 
     * - | `Promise<Buffer> <#type-buffer>`_ 
       - | `get <https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L53>`_ (
         |       hash:``string``,
         |       resultEncoding:``string``)
       - | retrieves the conent for a hash from IPFS. 
     * - | ``Promise<string>``
       - | `put <https://github.com/slockit/in3/blob/master/src/modules/ipfs/api.ts#L64>`_ (
         |       data:`Buffer <#type-buffer>`_ ,
         |       dataEncoding:``string``)
       - | stores the data on ipfs and returns the IPFS-Hash. 

```



## Package util

a collection of util classes inside incubed. They can be get directly through `require('in3/js/srrc/util/util')`


### Type DeltaHistory


Source: [util/DeltaHistory.ts](https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L42)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `DeltaHistory <#type-deltahistory>`_ 
       - | `constructor <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L43>`_ (
         |       init:`T <#type-t>`_  [],
         |       deltaStrings:``boolean``)
       - | constructor 
     * - | `Delta<T> <#type-delta>`_  []
       - | `data <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L43>`_
       - | the data 
     * - | ``void``
       - | `addState <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L68>`_ (
         |       start:``number``,
         |       data:`T <#type-t>`_  [])
       - | add state 
     * - | `T <#type-t>`_  []
       - | `getData <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L55>`_ (
         |       index:``number``)
       - | get data 
     * - | ``number``
       - | `getLastIndex <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L64>`_ ()
       - | get last index 
     * - | ``void``
       - | `loadDeltaStrings <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L115>`_ (
         |       deltas:``string`` [])
       - | load delta strings 
     * - | ``string`` []
       - | `toDeltaStrings <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L112>`_ ()
       - | to delta strings 

```


### Type Delta


Source: [util/DeltaHistory.ts](https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L35)


This file is part of the Incubed project.
Sources: https://github.com/slockit/in3

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `block <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L36>`_
       - | the block 
     * - | `T <#type-t>`_  []
       - | `data <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L39>`_
       - | the data 
     * - | ``number``
       - | `len <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L38>`_
       - | the len 
     * - | ``number``
       - | `start <https://github.com/slockit/in3/blob/master/src/util/DeltaHistory.ts#L37>`_
       - | the start 

```


## Common Module

The common module (in3-common) contains all the typedefs used in the node and server.




```eval_rst
  .. list-table::
     :widths: auto

     * - | Interface
       - | `BlockData <#type-blockdata>`_ 
       - | the BlockData
     * - | Interface
       - | `LogData <#type-logdata>`_ 
       - | the LogData
     * - | Type
       - | `Receipt <#type-receipt>`_ 
       - | the Receipt
     * - | Interface
       - | `ReceiptData <#type-receiptdata>`_ 
       - | the ReceiptData
     * - | Type
       - | `Transaction <#type-transaction>`_ 
       - | the Transaction
     * - | Interface
       - | `TransactionData <#type-transactiondata>`_ 
       - | the TransactionData
     * - | Interface
       - | `Transport <#type-transport>`_ 
       - | the Transport
     * - | `AxiosTransport <#type-axiostransport>`_ 
       - | `AxiosTransport <https://github.com/slockit/in3-common/blob/master/src/index.ts#L77>`_
       - | the AxiosTransport 
         |  value= ``_transport.AxiosTransport``
     * - | `Block <#type-block>`_ 
       - | `Block <https://github.com/slockit/in3-common/blob/master/src/index.ts#L69>`_
       - | the Block 
         |  value= ``_serialize.Block``
     * - | ``any``
       - | `address <https://github.com/slockit/in3-common/blob/master/src/index.ts#L98>`_ (
         |       val:``any``)
       - | converts it to a Buffer with 20 bytes length 
     * - | `Block <#type-block>`_ 
       - | `blockFromHex <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L331>`_ (
         |       hex:``string``)
       - | converts a hexstring to a block-object 
     * - | ``any``
       - | `bytes <https://github.com/slockit/in3-common/blob/master/src/index.ts#L99>`_ (
         |       val:``any``)
       - | converts it to a Buffer 
     * - | ``any``
       - | `bytes32 <https://github.com/slockit/in3-common/blob/master/src/index.ts#L93>`_ (
         |       val:``any``)
       - | converts it to a Buffer with 32 bytes length 
     * - | ``any``
       - | `bytes8 <https://github.com/slockit/in3-common/blob/master/src/index.ts#L94>`_ (
         |       val:``any``)
       - | converts it to a Buffer with 8 bytes length 
     * - | `cbor <#type-cbor>`_ 
       - | `cbor <https://github.com/slockit/in3-common/blob/master/src/index.ts#L86>`_
       - | the cbor 
         |  value= ``_cbor``
     * - | 
       - | `chainAliases <https://github.com/slockit/in3-common/blob/master/src/index.ts#L83>`_
       - | the chainAliases 
         |  value= ``_util.aliases``
     * - | ``number`` []
       - | `createRandomIndexes <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L237>`_ (
         |       len:``number``,
         |       limit:``number``,
         |       seed:`Buffer <#type-buffer>`_ ,
         |       result:``number`` [])
       - | create random indexes 
     * - | ``any``
       - | `createTx <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L296>`_ (
         |       transaction:``any``)
       - | creates a Transaction-object from the rpc-transaction-data 
     * - | `Buffer <#type-buffer>`_ 
       - | `getSigner <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L250>`_ (
         |       data:`Block <#type-block>`_ )
       - | get signer 
     * - | `Buffer <#type-buffer>`_ 
       - | `hash <https://github.com/slockit/in3-common/blob/master/src/index.ts#L92>`_ (
         |       val:`Block <#type-block>`_  
         | | `Transaction <#type-transaction>`_  
         | | `Receipt <#type-receipt>`_  
         | | `Account <#type-account>`_  
         | | `Buffer <#type-buffer>`_ )
       - | returns the hash of the object 
     * - | `index <#type-index>`_ 
       - | `rlp <https://github.com/slockit/in3-common/blob/master/src/index.ts#L101>`_
       - | the rlp 
         |  value= ``_serialize.rlp``
     * - | `serialize <#type-serialize>`_ 
       - | `serialize <https://github.com/slockit/in3-common/blob/master/src/index.ts#L64>`_
       - | the serialize 
         |  value= ``_serialize``
     * - | `storage <#type-storage>`_ 
       - | `storage <https://github.com/slockit/in3-common/blob/master/src/index.ts#L80>`_
       - | the storage 
         |  value= ``_storage``
     * - | `Buffer <#type-buffer>`_  []
       - | `toAccount <https://github.com/slockit/in3-common/blob/master/src/index.ts#L90>`_ (
         |       account:`AccountData <#type-accountdata>`_ )
       - | to account 
     * - | `Buffer <#type-buffer>`_  []
       - | `toBlockHeader <https://github.com/slockit/in3-common/blob/master/src/index.ts#L102>`_ (
         |       block:`BlockData <#type-blockdata>`_ )
       - | create a Buffer[] from RPC-Response 
     * - | ``Object``
       - | `toReceipt <https://github.com/slockit/in3-common/blob/master/src/index.ts#L91>`_ (
         |       r:`ReceiptData <#type-receiptdata>`_ )
       - | create a Buffer[] from RPC-Response 
     * - | `Buffer <#type-buffer>`_  []
       - | `toTransaction <https://github.com/slockit/in3-common/blob/master/src/index.ts#L100>`_ (
         |       tx:`TransactionData <#type-transactiondata>`_ )
       - | create a Buffer[] from RPC-Response 
     * - | `transport <#type-transport>`_ 
       - | `transport <https://github.com/slockit/in3-common/blob/master/src/index.ts#L75>`_
       - | the transport 
         |  value= ``_transport``
     * - | ``any``
       - | `uint <https://github.com/slockit/in3-common/blob/master/src/index.ts#L95>`_ (
         |       val:``any``)
       - | converts it to a Buffer with a variable length. 0 = length 0 
     * - | ``any``
       - | `uint128 <https://github.com/slockit/in3-common/blob/master/src/index.ts#L97>`_ (
         |       val:``any``)
       - | uint128 
     * - | ``any``
       - | `uint64 <https://github.com/slockit/in3-common/blob/master/src/index.ts#L96>`_ (
         |       val:``any``)
       - | uint64 
     * - | `util <#type-util>`_ 
       - | `util <https://github.com/slockit/in3-common/blob/master/src/index.ts#L40>`_
       - | the util 
         |  value= ``_util``
     * - | `validate <#type-validate>`_ 
       - | `validate <https://github.com/slockit/in3-common/blob/master/src/index.ts#L37>`_
       - | the validate 
         |  value= ``_validate``

```


## Package index.ts


### Type BlockData


Source: [index.ts](https://github.com/slockit/in3-common/blob/master/src/index.ts#L65)


Block as returned by eth_getBlockByNumber
Block as returned by eth_getBlockByNumber

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `coinbase <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L59>`_
       - | the coinbase  *(optional)* 
     * - | ``string`` | ``number``
       - | `difficulty <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L65>`_
       - | the difficulty 
     * - | ``string``
       - | `extraData <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L70>`_
       - | the extraData 
     * - | ``string`` | ``number``
       - | `gasLimit <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L67>`_
       - | the gasLimit 
     * - | ``string`` | ``number``
       - | `gasUsed <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L68>`_
       - | the gasUsed 
     * - | ``string``
       - | `hash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L55>`_
       - | the hash 
     * - | ``string``
       - | `logsBloom <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L64>`_
       - | the logsBloom 
     * - | ``string``
       - | `miner <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L58>`_
       - | the miner 
     * - | ``string``
       - | `mixHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L72>`_
       - | the mixHash  *(optional)* 
     * - | ``string`` | ``number``
       - | `nonce <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L73>`_
       - | the nonce  *(optional)* 
     * - | ``string`` | ``number``
       - | `number <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L66>`_
       - | the number 
     * - | ``string``
       - | `parentHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L56>`_
       - | the parentHash 
     * - | ``string``
       - | `receiptRoot <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L63>`_
       - | the receiptRoot  *(optional)* 
     * - | ``string``
       - | `receiptsRoot <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L62>`_
       - | the receiptsRoot 
     * - | ``string`` []
       - | `sealFields <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L71>`_
       - | the sealFields  *(optional)* 
     * - | ``string``
       - | `sha3Uncles <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L57>`_
       - | the sha3Uncles 
     * - | ``string``
       - | `stateRoot <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L60>`_
       - | the stateRoot 
     * - | ``string`` | ``number``
       - | `timestamp <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L69>`_
       - | the timestamp 
     * - | ``any`` []
       - | `transactions <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L74>`_
       - | the transactions  *(optional)* 
     * - | ``string``
       - | `transactionsRoot <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L61>`_
       - | the transactionsRoot 
     * - | ``string`` []
       - | `uncles <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L75>`_
       - | the uncles  *(optional)* 

```


### Type LogData


Source: [index.ts](https://github.com/slockit/in3-common/blob/master/src/index.ts#L66)


LogData as part of the TransactionReceipt
LogData as part of the TransactionReceipt

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `address <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L122>`_
       - | the address 
     * - | ``string``
       - | `blockHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L120>`_
       - | the blockHash 
     * - | ``string``
       - | `blockNumber <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L121>`_
       - | the blockNumber 
     * - | ``string``
       - | `data <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L123>`_
       - | the data 
     * - | ``string``
       - | `logIndex <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L116>`_
       - | the logIndex 
     * - | ``boolean``
       - | `removed <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L115>`_
       - | the removed 
     * - | ``string`` []
       - | `topics <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L124>`_
       - | the topics 
     * - | ``string``
       - | `transactionHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L119>`_
       - | the transactionHash 
     * - | ``string``
       - | `transactionIndex <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L118>`_
       - | the transactionIndex 
     * - | ``string``
       - | `transactionLogIndex <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L117>`_
       - | the transactionLogIndex 

```


### Type ReceiptData


Source: [index.ts](https://github.com/slockit/in3-common/blob/master/src/index.ts#L67)


TransactionReceipt as returned by eth_getTransactionReceipt
TransactionReceipt as returned by eth_getTransactionReceipt

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `blockHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L132>`_
       - | the blockHash  *(optional)* 
     * - | ``string`` | ``number``
       - | `blockNumber <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L131>`_
       - | the blockNumber  *(optional)* 
     * - | ``string`` | ``number``
       - | `cumulativeGasUsed <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L135>`_
       - | the cumulativeGasUsed  *(optional)* 
     * - | ``string`` | ``number``
       - | `gasUsed <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L136>`_
       - | the gasUsed  *(optional)* 
     * - | `LogData <#type-logdata>`_  []
       - | `logs <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L138>`_
       - | the logs 
     * - | ``string``
       - | `logsBloom <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L137>`_
       - | the logsBloom  *(optional)* 
     * - | ``string``
       - | `root <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L134>`_
       - | the root  *(optional)* 
     * - | ``string`` | ``boolean``
       - | `status <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L133>`_
       - | the status  *(optional)* 
     * - | ``string``
       - | `transactionHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L129>`_
       - | the transactionHash  *(optional)* 
     * - | ``number``
       - | `transactionIndex <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L130>`_
       - | the transactionIndex  *(optional)* 

```


### Type TransactionData


Source: [index.ts](https://github.com/slockit/in3-common/blob/master/src/index.ts#L68)


Transaction as returned by eth_getTransactionByHash
Transaction as returned by eth_getTransactionByHash

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `blockHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L81>`_
       - | the blockHash  *(optional)* 
     * - | ``number`` | ``string``
       - | `blockNumber <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L82>`_
       - | the blockNumber  *(optional)* 
     * - | ``number`` | ``string``
       - | `chainId <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L83>`_
       - | the chainId  *(optional)* 
     * - | ``string``
       - | `condition <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L84>`_
       - | the condition  *(optional)* 
     * - | ``string``
       - | `creates <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L85>`_
       - | the creates  *(optional)* 
     * - | ``string``
       - | `data <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L91>`_
       - | the data  *(optional)* 
     * - | ``string``
       - | `from <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L86>`_
       - | the from  *(optional)* 
     * - | ``number`` | ``string``
       - | `gas <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L87>`_
       - | the gas  *(optional)* 
     * - | ``number`` | ``string``
       - | `gasLimit <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L88>`_
       - | the gasLimit  *(optional)* 
     * - | ``number`` | ``string``
       - | `gasPrice <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L89>`_
       - | the gasPrice  *(optional)* 
     * - | ``string``
       - | `hash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L80>`_
       - | the hash 
     * - | ``string``
       - | `input <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L90>`_
       - | the input 
     * - | ``number`` | ``string``
       - | `nonce <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L92>`_
       - | the nonce 
     * - | ``string``
       - | `publicKey <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L93>`_
       - | the publicKey  *(optional)* 
     * - | ``string``
       - | `r <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L98>`_
       - | the r  *(optional)* 
     * - | ``string``
       - | `raw <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L94>`_
       - | the raw  *(optional)* 
     * - | ``string``
       - | `s <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L99>`_
       - | the s  *(optional)* 
     * - | ``string``
       - | `standardV <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L95>`_
       - | the standardV  *(optional)* 
     * - | ``string``
       - | `to <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L96>`_
       - | the to 
     * - | ``number``
       - | `transactionIndex <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L97>`_
       - | the transactionIndex 
     * - | ``string``
       - | `v <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L100>`_
       - | the v  *(optional)* 
     * - | ``number`` | ``string``
       - | `value <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L101>`_
       - | the value 

```


### Type Transport


Source: [index.ts](https://github.com/slockit/in3-common/blob/master/src/index.ts#L76)


A Transport-object responsible to transport the message to the handler.
A Transport-object responsible to transport the message to the handler.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``Promise<>``
       - | `handle <https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L46>`_ (
         |       url:``string``,
         |       data:`RPCRequest <#type-rpcrequest>`_  
         | | `RPCRequest <#type-rpcrequest>`_  [],
         |       timeout:``number``)
       - | handles a request by passing the data to the handler 
     * - | ``Promise<boolean>``
       - | `isOnline <https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L51>`_ ()
       - | check whether the handler is onlne. 
     * - | ``number`` []
       - | `random <https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L56>`_ (
         |       count:``number``)
       - | generates random numbers (between 0-1) 

```



## Package modules/eth


### Type Block


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L240)


encodes and decodes the blockheader

```eval_rst
  .. list-table::
     :widths: auto

     * - | `Block <#type-block>`_ 
       - | `constructor <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L261>`_ (
         |       data:`Buffer <#type-buffer>`_  
         | | ``string`` 
         | | `BlockData <#type-blockdata>`_ )
       - | creates a Block-Onject from either the block-data as returned from rpc, a buffer or a hex-string of the encoded blockheader 
     * - | `BlockHeader <#type-blockheader>`_ 
       - | `raw <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L243>`_
       - | the raw Buffer fields of the BlockHeader 
     * - | `Tx <#type-tx>`_  []
       - | `transactions <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L246>`_
       - | the transaction-Object (if given) 
     * - | `Buffer <#type-buffer>`_ 
       - | `bloom <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L254>`_
       - | bloom 
     * - | `Buffer <#type-buffer>`_ 
       - | `coinbase <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L250>`_
       - | coinbase 
     * - | `Buffer <#type-buffer>`_ 
       - | `difficulty <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L255>`_
       - | difficulty 
     * - | `Buffer <#type-buffer>`_ 
       - | `extra <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L260>`_
       - | extra 
     * - | `Buffer <#type-buffer>`_ 
       - | `gasLimit <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L257>`_
       - | gas limit 
     * - | `Buffer <#type-buffer>`_ 
       - | `gasUsed <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L258>`_
       - | gas used 
     * - | `Buffer <#type-buffer>`_ 
       - | `number <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L256>`_
       - | number 
     * - | `Buffer <#type-buffer>`_ 
       - | `parentHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L248>`_
       - | parent hash 
     * - | `Buffer <#type-buffer>`_ 
       - | `receiptTrie <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L253>`_
       - | receipt trie 
     * - | `Buffer <#type-buffer>`_  []
       - | `sealedFields <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L261>`_
       - | sealed fields 
     * - | `Buffer <#type-buffer>`_ 
       - | `stateRoot <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L251>`_
       - | state root 
     * - | `Buffer <#type-buffer>`_ 
       - | `timestamp <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L259>`_
       - | timestamp 
     * - | `Buffer <#type-buffer>`_ 
       - | `transactionsTrie <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L252>`_
       - | transactions trie 
     * - | `Buffer <#type-buffer>`_ 
       - | `uncleHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L249>`_
       - | uncle hash 
     * - | `Buffer <#type-buffer>`_ 
       - | `bareHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L284>`_ ()
       - | the blockhash as buffer without the seal fields 
     * - | `Buffer <#type-buffer>`_ 
       - | `hash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L279>`_ ()
       - | the blockhash as buffer 
     * - | `Buffer <#type-buffer>`_ 
       - | `serializeHeader <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L289>`_ ()
       - | the serialized header as buffer 

```


### Type Transaction


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L45)


Buffer[] of the transaction
 = [Buffer](#type-buffer)  [] 



### Type Receipt


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L51)


Buffer[] of the Receipt
 = [ [Buffer](#type-buffer) ,[Buffer](#type-buffer) ,[Buffer](#type-buffer) ,[Buffer](#type-buffer)  , [Buffer](#type-buffer)  [] , [Buffer](#type-buffer)  [] ] 



### Type Account


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L48)


Buffer[] of the Account
 = [Buffer](#type-buffer)  [] 



### Type serialize


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L1)




```eval_rst
  .. list-table::
     :widths: auto

     * - | Class
       - | `Block <#type-block>`_ 
       - | encodes and decodes the blockheader
     * - | Interface
       - | `AccountData <#type-accountdata>`_ 
       - | Account-Object
     * - | Interface
       - | `BlockData <#type-blockdata>`_ 
       - | Block as returned by eth_getBlockByNumber
     * - | Interface
       - | `LogData <#type-logdata>`_ 
       - | LogData as part of the TransactionReceipt
     * - | Interface
       - | `ReceiptData <#type-receiptdata>`_ 
       - | TransactionReceipt as returned by eth_getTransactionReceipt
     * - | Interface
       - | `TransactionData <#type-transactiondata>`_ 
       - | Transaction as returned by eth_getTransactionByHash
     * - | Type
       - | `Account <#type-account>`_ 
       - | Buffer[] of the Account
     * - | Type
       - | `BlockHeader <#type-blockheader>`_ 
       - | Buffer[] of the header
     * - | Type
       - | `Receipt <#type-receipt>`_ 
       - | Buffer[] of the Receipt
     * - | Type
       - | `Transaction <#type-transaction>`_ 
       - | Buffer[] of the transaction
     * - | `index <#type-index>`_ 
       - | `rlp <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L40>`_
       - | RLP-functions 
         |  value= ``ethUtil.rlp``
     * - | ``any``
       - | `address <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L160>`_ (
         |       val:``any``)
       - | converts it to a Buffer with 20 bytes length 
     * - | `Block <#type-block>`_ 
       - | `blockFromHex <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L331>`_ (
         |       hex:``string``)
       - | converts a hexstring to a block-object 
     * - | ``string``
       - | `blockToHex <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L326>`_ (
         |       block:``any``)
       - | converts blockdata to a hexstring 
     * - | ``any``
       - | `bytes <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L158>`_ (
         |       val:``any``)
       - | converts it to a Buffer 
     * - | ``any``
       - | `bytes256 <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L152>`_ (
         |       val:``any``)
       - | converts it to a Buffer with 256 bytes length 
     * - | ``any``
       - | `bytes32 <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L154>`_ (
         |       val:``any``)
       - | converts it to a Buffer with 32 bytes length 
     * - | ``any``
       - | `bytes8 <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L156>`_ (
         |       val:``any``)
       - | converts it to a Buffer with 8 bytes length 
     * - | ``any``
       - | `createTx <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L296>`_ (
         |       transaction:``any``)
       - | creates a Transaction-object from the rpc-transaction-data 
     * - | `Buffer <#type-buffer>`_ 
       - | `hash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L146>`_ (
         |       val:`Block <#type-block>`_  
         | | `Transaction <#type-transaction>`_  
         | | `Receipt <#type-receipt>`_  
         | | `Account <#type-account>`_  
         | | `Buffer <#type-buffer>`_ )
       - | returns the hash of the object 
     * - | `Buffer <#type-buffer>`_ 
       - | `serialize <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L143>`_ (
         |       val:`Block <#type-block>`_  
         | | `Transaction <#type-transaction>`_  
         | | `Receipt <#type-receipt>`_  
         | | `Account <#type-account>`_  
         | | ``any``)
       - | serialize the data 
     * - | `Buffer <#type-buffer>`_  []
       - | `toAccount <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L207>`_ (
         |       account:`AccountData <#type-accountdata>`_ )
       - | to account 
     * - | `Buffer <#type-buffer>`_  []
       - | `toBlockHeader <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L168>`_ (
         |       block:`BlockData <#type-blockdata>`_ )
       - | create a Buffer[] from RPC-Response 
     * - | ``Object``
       - | `toReceipt <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L216>`_ (
         |       r:`ReceiptData <#type-receiptdata>`_ )
       - | create a Buffer[] from RPC-Response 
     * - | `Buffer <#type-buffer>`_  []
       - | `toTransaction <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L193>`_ (
         |       tx:`TransactionData <#type-transactiondata>`_ )
       - | create a Buffer[] from RPC-Response 
     * - | ``any``
       - | `uint <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L162>`_ (
         |       val:``any``)
       - | converts it to a Buffer with a variable length. 0 = length 0 
     * - | ``any``
       - | `uint128 <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L165>`_ (
         |       val:``any``)
       - | uint128 
     * - | ``any``
       - | `uint64 <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L164>`_ (
         |       val:``any``)
       - | uint64 

```


### Type storage


Source: [modules/eth/storage.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L1)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``any``
       - | `getStorageArrayKey <https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L43>`_ (
         |       pos:``number``,
         |       arrayIndex:``number``,
         |       structSize:``number``,
         |       structPos:``number``)
       - | calc the storrage array key 
     * - | ``any``
       - | `getStorageMapKey <https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L55>`_ (
         |       pos:``number``,
         |       key:``string``,
         |       structPos:``number``)
       - | calcs the storage Map key. 
     * - | ``Promise<>``
       - | `getStorageValue <https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L103>`_ (
         |       rpc:``string``,
         |       contract:``string``,
         |       pos:``number``,
         |       type:``'address'`` 
         | | ``'bytes32'`` 
         | | ``'bytes16'`` 
         | | ``'bytes4'`` 
         | | ``'int'`` 
         | | ``'string'``,
         |       keyOrIndex:``number`` 
         | | ``string``,
         |       structSize:``number``,
         |       structPos:``number``)
       - | get a storage value from the server 
     * - | ``string`` | 
       - | `getStringValue <https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L65>`_ (
         |       data:`Buffer <#type-buffer>`_ ,
         |       storageKey:`Buffer <#type-buffer>`_ )
       - | creates a string from storage. 
     * - | ``string``
       - | `getStringValueFromList <https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L84>`_ (
         |       values:`Buffer <#type-buffer>`_  [],
         |       len:``number``)
       - | concats the storage values to a string. 
     * - | `BN <#type-bn>`_ 
       - | `toBN <https://github.com/slockit/in3-common/blob/master/src/modules/eth/storage.ts#L91>`_ (
         |       val:``any``)
       - | converts any value to BN 

```


### Type AccountData


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L105)


Account-Object

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `balance <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L107>`_
       - | the balance 
     * - | ``string``
       - | `code <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L110>`_
       - | the code  *(optional)* 
     * - | ``string``
       - | `codeHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L109>`_
       - | the codeHash 
     * - | ``string``
       - | `nonce <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L106>`_
       - | the nonce 
     * - | ``string``
       - | `storageHash <https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L108>`_
       - | the storageHash 

```


### Type BlockHeader


Source: [modules/eth/serialize.ts](https://github.com/slockit/in3-common/blob/master/src/modules/eth/serialize.ts#L42)


Buffer[] of the header
 = [Buffer](#type-buffer)  [] 




## Package types


### Type RPCRequest


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L370)


a JSONRPC-Request with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number`` | ``string``
       - | `id <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L384>`_
       - | the identifier of the request
         | example: 2  *(optional)* 
     * - | `IN3RPCRequestConfig <#type-in3rpcrequestconfig>`_ 
       - | `in3 <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L393>`_
       - | the IN3-Config  *(optional)* 
     * - | ``'2.0'``
       - | `jsonrpc <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L374>`_
       - | the version 
     * - | ``string``
       - | `method <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L379>`_
       - | the method to call
         | example: eth_getBalance 
     * - | ``any`` []
       - | `params <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L389>`_
       - | the params
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest  *(optional)* 

```


### Type RPCResponse


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L398)


a JSONRPC-Responset with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `error <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L411>`_
       - | in case of an error this needs to be set  *(optional)* 
     * - | ``string`` | ``number``
       - | `id <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L407>`_
       - | the id matching the request
         | example: 2 
     * - | `IN3ResponseConfig <#type-in3responseconfig>`_ 
       - | `in3 <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L420>`_
       - | the IN3-Result  *(optional)* 
     * - | `IN3NodeConfig <#type-in3nodeconfig>`_ 
       - | `in3Node <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L424>`_
       - | the node handling this response (internal only)  *(optional)* 
     * - | ``'2.0'``
       - | `jsonrpc <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L402>`_
       - | the version 
     * - | ``any``
       - | `result <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L416>`_
       - | the params
         | example: 0xa35bc  *(optional)* 

```


### Type IN3RPCRequestConfig


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L179)


additional config for a IN3 RPC-Request

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `chainId <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L184>`_
       - | the requested chainId
         | example: 0x1 
     * - | ``any``
       - | `clientSignature <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L223>`_
       - | the signature of the client  *(optional)* 
     * - | ``number``
       - | `finality <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L214>`_
       - | if given the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.  *(optional)* 
     * - | ``boolean``
       - | `includeCode <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L189>`_
       - | if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
         | example: true  *(optional)* 
     * - | ``number``
       - | `latestBlock <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L198>`_
       - | if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
         | example: 6  *(optional)* 
     * - | ``string`` []
       - | `signatures <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L228>`_
       - | a list of addresses requested to sign the blockhash
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679  *(optional)* 
     * - | ``boolean``
       - | `useBinary <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L206>`_
       - | if true binary-data will be used.  *(optional)* 
     * - | ``boolean``
       - | `useFullProof <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L210>`_
       - | if true all data in the response will be proven, which leads to a higher payload.  *(optional)* 
     * - | ``boolean``
       - | `useRef <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L202>`_
       - | if true binary-data (starting with a 0x) will be refered if occuring again.  *(optional)* 
     * - | ``'never'`` 
         | | ``'proof'`` 
         | | ``'proofWithSignature'``
       - | `verification <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L219>`_
       - | defines the kind of proof the client is asking for
         | example: proof  *(optional)* 
     * - | ``string`` []
       - | `verifiedHashes <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L193>`_
       - | if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number.  *(optional)* 
     * - | ``string``
       - | `version <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L233>`_
       - | IN3 protocol version that client can specify explicitly in request
         | example: 1.0.0  *(optional)* 

```


### Type IN3ResponseConfig


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L238)


additional data returned from a IN3 Server

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``number``
       - | `currentBlock <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L256>`_
       - | the current blocknumber.
         | example: 320126478  *(optional)* 
     * - | ``number``
       - | `lastNodeList <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L247>`_
       - | the blocknumber for the last block updating the nodelist. If the client has a smaller blocknumber he should update the nodeList.
         | example: 326478  *(optional)* 
     * - | ``number``
       - | `lastValidatorChange <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L251>`_
       - | the blocknumber of gthe last change of the validatorList  *(optional)* 
     * - | `Proof <#type-proof>`_ 
       - | `proof <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L242>`_
       - | the Proof-data  *(optional)* 
     * - | ``string``
       - | `version <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L261>`_
       - | the in3 protocol version.
         | example: 1.0.0  *(optional)* 

```


### Type IN3NodeConfig


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L90)


a configuration of a in3-server.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `address <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L100>`_
       - | the address of the node, which is the public address it iis signing with.
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679 
     * - | ``number``
       - | `capacity <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L125>`_
       - | the capacity of the node.
         | example: 100  *(optional)* 
     * - | ``string`` []
       - | `chainIds <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L115>`_
       - | the list of supported chains
         | example: 0x1 
     * - | ``number``
       - | `deposit <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L120>`_
       - | the deposit of the node in wei
         | example: 12350000 
     * - | ``number``
       - | `index <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L95>`_
       - | the index within the contract
         | example: 13  *(optional)* 
     * - | ``number``
       - | `props <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L130>`_
       - | the properties of the node.
         | example: 3  *(optional)* 
     * - | ``number``
       - | `registerTime <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L135>`_
       - | the UNIX-timestamp when the node was registered
         | example: 1563279168  *(optional)* 
     * - | ``number``
       - | `timeout <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L105>`_
       - | the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
         | example: 3600  *(optional)* 
     * - | ``number``
       - | `unregisterTime <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L140>`_
       - | the UNIX-timestamp when the node is allowed to be deregister
         | example: 1563279168  *(optional)* 
     * - | ``string``
       - | `url <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L110>`_
       - | the endpoint to post to
         | example: https://in3.slock.it 

```


### Type Proof


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L309)


the Proof-data as part of the in3-section

```eval_rst
  .. list-table::
     :widths: auto

     * - | 
       - | `accounts <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L354>`_
       - | a map of addresses and their AccountProof  *(optional)* 
     * - | ``string``
       - | `block <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L319>`_
       - | the serialized blockheader as hex, required in most proofs
         | example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b  *(optional)* 
     * - | ``any`` []
       - | `finalityBlocks <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L324>`_
       - | the serialized blockheader as hex, required in case of finality asked
         | example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda6463a8f1ebb14f3aff6b19cb91acf2b8ec1ffee98c0437b4ac839d8a2ece1b18166da704b  *(optional)* 
     * - | `LogProof <#type-logproof>`_ 
       - | `logProof <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L350>`_
       - | the Log Proof in case of a Log-Request  *(optional)* 
     * - | ``string`` []
       - | `merkleProof <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L338>`_
       - | the serialized merle-noodes beginning with the root-node  *(optional)* 
     * - | ``string`` []
       - | `merkleProofPrev <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L342>`_
       - | the serialized merkle-noodes beginning with the root-node of the previous entry (only for full proof of receipts)  *(optional)* 
     * - | `Signature <#type-signature>`_  []
       - | `signatures <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L365>`_
       - | requested signatures  *(optional)* 
     * - | ``any`` []
       - | `transactions <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L329>`_
       - | the list of transactions of the block
         | example:  *(optional)* 
     * - | ``number``
       - | `txIndex <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L361>`_
       - | the transactionIndex within the block
         | example: 4  *(optional)* 
     * - | ``string`` []
       - | `txProof <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L346>`_
       - | the serialized merkle-nodes beginning with the root-node in order to prrof the transactionIndex  *(optional)* 
     * - | ``'transactionProof'`` 
         | | ``'receiptProof'`` 
         | | ``'blockProof'`` 
         | | ``'accountProof'`` 
         | | ``'callProof'`` 
         | | ``'logProof'``
       - | `type <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L314>`_
       - | the type of the proof
         | example: accountProof 
     * - | ``any`` []
       - | `uncles <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L334>`_
       - | the list of uncle-headers of the block
         | example:  *(optional)* 

```


### Type LogProof


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L266)


a Object holding proofs for event logs. The key is the blockNumber as hex



### Type Signature


Source: [types/types.ts](https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L429)


Verified ECDSA Signature. Signatures are a pair (r, s). Where r is computed as the X coordinate of a point R, modulo the curve order n.

```eval_rst
  .. list-table::
     :widths: auto

     * - | ``string``
       - | `address <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L434>`_
       - | the address of the signing node
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679  *(optional)* 
     * - | ``number``
       - | `block <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L439>`_
       - | the blocknumber
         | example: 3123874 
     * - | ``string``
       - | `blockHash <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L444>`_
       - | the hash of the block
         | example: 0x6C1a01C2aB554930A937B0a212346037E8105fB47946c679 
     * - | ``string``
       - | `msgHash <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L449>`_
       - | hash of the message
         | example: 0x9C1a01C2aB554930A937B0a212346037E8105fB47946AB5D 
     * - | ``string``
       - | `r <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L454>`_
       - | Positive non-zero Integer signature.r
         | example: 0x72804cfa0179d648ccbe6a65b01a6463a8f1ebb14f3aff6b19cb91acf2b8ec1f 
     * - | ``string``
       - | `s <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L459>`_
       - | Positive non-zero Integer signature.s
         | example: 0x6d17b34aeaf95fee98c0437b4ac839d8a2ece1b18166da704b86d8f42c92bbda 
     * - | ``number``
       - | `v <https://github.com/slockit/in3-common/blob/master/src/types/types.ts#L464>`_
       - | Calculated curve point, or identity element O.
         | example: 28 

```



## Package util


### Type AxiosTransport


Source: [util/transport.ts](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L64)


Default Transport impl sending http-requests.

```eval_rst
  .. list-table::
     :widths: auto

     * - | `AxiosTransport <#type-axiostransport>`_ 
       - | `constructor <https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L66>`_ (
         |       format:``'json'`` 
         | | ``'cbor'`` 
         | | ``'jsonRef'``)
       - | Default Transport impl sending http-requests. 
     * - | ``'json'`` | ``'cbor'`` | ``'jsonRef'``
       - | `format <https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L66>`_
       - | the format 
     * - | ``Promise<>``
       - | `handle <https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L81>`_ (
         |       url:``string``,
         |       data:`RPCRequest <#type-rpcrequest>`_  
         | | `RPCRequest <#type-rpcrequest>`_  [],
         |       timeout:``number``)
       - | handle 
     * - | ``Promise<boolean>``
       - | `isOnline <https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L72>`_ ()
       - | is online 
     * - | ``number`` []
       - | `random <https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L110>`_ (
         |       count:``number``)
       - | random 

```


### Type cbor


Source: [util/cbor.ts](https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L1)




```eval_rst
  .. list-table::
     :widths: auto

     * - | ``any``
       - | `convertToBuffer <https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L69>`_ (
         |       val:``any``)
       - | convert to buffer 
     * - | ``any``
       - | `convertToHex <https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L83>`_ (
         |       val:``any``)
       - | convert to hex 
     * - | `T <#type-t>`_ 
       - | `createRefs <https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L101>`_ (
         |       val:`T <#type-t>`_ ,
         |       cache:``string`` [])
       - | create refs 
     * - | `RPCRequest <#type-rpcrequest>`_  []
       - | `decodeRequests <https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L45>`_ (
         |       request:`Buffer <#type-buffer>`_ )
       - | decode requests 
     * - | `RPCResponse <#type-rpcresponse>`_  []
       - | `decodeResponses <https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L59>`_ (
         |       responses:`Buffer <#type-buffer>`_ )
       - | decode responses 
     * - | `Buffer <#type-buffer>`_ 
       - | `encodeRequests <https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L41>`_ (
         |       requests:`RPCRequest <#type-rpcrequest>`_  [])
       - | turn 
     * - | `Buffer <#type-buffer>`_ 
       - | `encodeResponses <https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L56>`_ (
         |       responses:`RPCResponse <#type-rpcresponse>`_  [])
       - | encode responses 
     * - | `T <#type-t>`_ 
       - | `resolveRefs <https://github.com/slockit/in3-common/blob/master/src/util/cbor.ts#L122>`_ (
         |       val:`T <#type-t>`_ ,
         |       cache:``string`` [])
       - | resolve refs 

```


### Type transport


Source: [util/transport.ts](https://github.com/slockit/in3-common/blob/master/src/util/transport.ts#L1)




```eval_rst
  .. list-table::
     :widths: auto

     * - | Class
       - | `AxiosTransport <#type-axiostransport>`_ 
       - | Default Transport impl sending http-requests.
     * - | Interface
       - | `Transport <#type-transport>`_ 
       - | A Transport-object responsible to transport the message to the handler.

```


### Type util


Source: [util/util.ts](https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L1)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `BN <#type-bn>`_ 
       - | `BN <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L44>`_
       - | the BN 
         |  value= ``ethUtil.BN``
     * - | ``any``
       - | `Buffer <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L36>`_
       - | This file is part of the Incubed project.
         | Sources: https://github.com/slockit/in3-common 
         |  value= ``require('buffer').Buffer``
     * - | `T <#type-t>`_ 
       - | `checkForError <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L76>`_ (
         |       res:`T <#type-t>`_ )
       - | check a RPC-Response for errors and rejects the promise if found 
     * - | ``number`` []
       - | `createRandomIndexes <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L237>`_ (
         |       len:``number``,
         |       limit:``number``,
         |       seed:`Buffer <#type-buffer>`_ ,
         |       result:``number`` [])
       - | create random indexes 
     * - | ``string``
       - | `fixLength <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L48>`_ (
         |       hex:``string``)
       - | fix length 
     * - | ``string``
       - | `getAddress <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L191>`_ (
         |       pk:``string``)
       - | returns a address from a private key 
     * - | `Buffer <#type-buffer>`_ 
       - | `getSigner <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L250>`_ (
         |       data:`Block <#type-block>`_ )
       - | get signer 
     * - | ``string``
       - | `padEnd <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L230>`_ (
         |       val:``string``,
         |       minLength:``number``,
         |       fill:``string``)
       - | padEnd for legacy 
     * - | ``string``
       - | `padStart <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L223>`_ (
         |       val:``string``,
         |       minLength:``number``,
         |       fill:``string``)
       - | padStart for legacy 
     * - | ``Promise<any>``
       - | `promisify <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L54>`_ (
         |       self:``any``,
         |       fn:``any``,
         |       args:``any`` [])
       - | simple promisy-function 
     * - | `BN <#type-bn>`_ 
       - | `toBN <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L85>`_ (
         |       val:``any``)
       - | convert to BigNumber 
     * - | ``any``
       - | `toBuffer <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L147>`_ (
         |       val:``any``,
         |       len:``number``)
       - | converts any value as Buffer
         |  if len === 0 it will return an empty Buffer if the value is 0 or '0x00', since this is the way rlpencode works wit 0-values. 
     * - | ``string``
       - | `toHex <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L96>`_ (
         |       val:``any``,
         |       bytes:``number``)
       - | converts any value as hex-string 
     * - | ``string``
       - | `toMinHex <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L197>`_ (
         |       key:``string`` 
         | | `Buffer <#type-buffer>`_  
         | | ``number``)
       - | removes all leading 0 in the hexstring 
     * - | ``number``
       - | `toNumber <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L119>`_ (
         |       val:``any``)
       - | converts to a js-number 
     * - | ``string``
       - | `toSimpleHex <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L180>`_ (
         |       val:``string``)
       - | removes all leading 0 in a hex-string 
     * - | ``string``
       - | `toUtf8 <https://github.com/slockit/in3-common/blob/master/src/util/util.ts#L65>`_ (
         |       val:``any``)
       - | to utf8 
     * - | JSON
       - | **``object``**
       - | the aliases

```


### Type validate


Source: [util/validate.ts](https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L1)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `Ajv <#type-ajv>`_ 
       - | `ajv <https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L42>`_
       - | the ajv instance with custom formatters and keywords 
         |  value= ``new Ajv()``
     * - | ``void``
       - | `validate <https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L70>`_ (
         |       ob:``any``,
         |       def:``any``)
       - | validate 
     * - | ``void``
       - | `validateAndThrow <https://github.com/slockit/in3-common/blob/master/src/util/validate.ts#L64>`_ (
         |       fn:`Ajv.ValidateFunction <#type-ajv.validatefunction>`_ ,
         |       ob:``any``)
       - | validates the data and throws an error in case they are not valid. 

```


