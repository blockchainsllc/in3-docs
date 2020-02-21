# API Reference WASM

This page contains a list of all Datastructures and Classes used within the IN3 WASM-Client.

## Installing

This client uses the in3-core sources compiled to wasm. The wasm is included into the js-file wich makes it easier to include the data.
This module has **no** dependencies! All it needs is included inta a wasm of about 300kB.

Installing incubed is as easy as installing any other module:

```
npm install --save in3-wasm
```

### WASM-support

In case you want to run incubed within a react native app, you might face issues because wasm is not supported there yet. In this case you can use [in3-asmjs](https://www.npmjs.com/package/in3-asmjs), which has the same API, but runs on pure javascript (a bit slower and bigger, but full support everywhere).



## Examples

### get_block_rpc

source : [in3-c/wasm/examples/get_block_rpc.js](https://github.com/slockit/in3-c/blob/master/wasm/examples/get_block_rpc.js)

read block as rpc


```js
/// read block as rpc

const IN3 = require('in3-wasm')

async function showLatestBlock() {
    // create new incubed instance
    var c = new IN3()

    await c.setConfig({
        chainId: 0x5 // use goerli
    })

    // send raw RPC-Request
    const lastBlockResponse = await c.send({ method: 'eth_getBlockByNumber', params: ['latest', false] })

    if (lastBlockResponse.error)
        console.error("Error getting the latest block : ", lastBlockResponse.error)
    else
        console.log("latest Block: ", JSON.stringify(lastBlockResponse.result, null, 2))

    // clean up
    c.free()

}

showLatestBlock().catch(console.error)
```

### get_block_api

source : [in3-c/wasm/examples/get_block_api.ts](https://github.com/slockit/in3-c/blob/master/wasm/examples/get_block_api.ts)

read block with API


```js
/// read block with API

import { IN3 } from 'in3-wasm'

async function showLatestBlock() {
  // create new incubed instance
  const client = new IN3({
    chainId: 'goerli'
  })

  // send raw RPC-Request
  const lastBlock = await client.eth.getBlockByNumber()

  console.log("latest Block: ", JSON.stringify(lastBlock, null, 2))

  // clean up
  client.free()

}

showLatestBlock().catch(console.error)
```

### use_web3

source : [in3-c/wasm/examples/use_web3.ts](https://github.com/slockit/in3-c/blob/master/wasm/examples/use_web3.ts)

use incubed as Web3Provider in web3js 


```js
/// use incubed as Web3Provider in web3js 

// import in3-Module
import { IN3 } from 'in3-wasm'
const Web3 = require('web3')

const in3 = new IN3({
    proof: 'standard',
    signatureCount: 1,
    requestCount: 1,
    chainId: 'mainnet',
    replaceLatestBlock: 10
})

// use the In3Client as Http-Provider
const web3 = new Web3(in3.createWeb3Provider());

(async () => {

    // use the web3
    const block = await web3.eth.getBlock('latest')
    console.log("Block : ", block)

})().catch(console.error);
```

### in3_in_browser

source : [in3-c/wasm/examples/in3_in_browser.html](https://github.com/slockit/in3-c/blob/master/wasm/examples/in3_in_browser.html)

use incubed directly in html 


```html
<!-- use incubed directly in html -->
<html>
    <head>
        <script src="node_modules/in3-wasm/index.js"></script>
    </head>

    <body>
        IN3-Demo
        <div>
            result:
            <pre id="result"> ...waiting... </pre>
        </div>
        <script>
            var in3 = new IN3({ chainId: 0x1, replaceLatestBlock: 6 });
            in3.eth.getBlockByNumber('latest', false)
                .then(block => document.getElementById('result').innerHTML = JSON.stringify(block, null, 2))
                .catch(alert)
        </script>
    </body>

</html>
```


### Building 

In order to run those examples, you need to install in3-wasm and typescript first.
The build.sh will do this and the run the tsc-compiler

```sh
./build.sh
```

In order to run a example use

```
node build/get_block_api.ts
```

## Incubed Module

This page contains a list of all Datastructures and Classes used within the IN3 WASM-Client

Importing incubed is as easy as 
```ts
import {IN3} from "in3-wasm"
```

While the In3Client-class is the default import, the following imports can be used:


```eval_rst
  .. list-table::
     :widths: auto

     * - | `IN3 <#type-in3>`_ 
       - | Class
       - | default Incubed client with
         | bigint for big numbers
         | Uint8Array for bytes
     * - | `IN3Generic <#type-in3generic>`_ 
       - | Class
       - | the IN3Generic
     * - | `SimpleSigner <#type-simplesigner>`_ 
       - | Class
       - | the SimpleSigner
     * - | `EthAPI <#type-ethapi>`_ 
       - | Interface
       - | the EthAPI
     * - | `IN3Config <#type-in3config>`_ 
       - | Interface
       - | the iguration of the IN3-Client. This can be paritally overriden for every request.
     * - | `IN3NodeConfig <#type-in3nodeconfig>`_ 
       - | Interface
       - | a configuration of a in3-server.
     * - | `IN3NodeWeight <#type-in3nodeweight>`_ 
       - | Interface
       - | a local weight of a n3-node. (This is used internally to weight the requests)
     * - | `RPCRequest <#type-rpcrequest>`_ 
       - | Interface
       - | a JSONRPC-Request with N3-Extension
     * - | `RPCResponse <#type-rpcresponse>`_ 
       - | Interface
       - | a JSONRPC-Responset with N3-Extension
     * - | `Signer <#type-signer>`_ 
       - | Interface
       - | the Signer
     * - | `Utils <#type-utils>`_ 
       - | Interface
       - | Collection of different util-functions.
     * - | `ABI <#type-abi>`_ 
       - | Type literal
       - | the ABI
     * - | `ABIField <#type-abifield>`_ 
       - | Type literal
       - | the ABIField
     * - | `Address <#type-address>`_ 
       - | Type alias
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | `Block <#type-block>`_ 
       - | Type literal
       - | the Block
     * - | `BlockType <#type-blocktype>`_ 
       - | Type
       - | BlockNumber or predefined Block
     * - | `Data <#type-data>`_ 
       - | Type alias
       - | data encoded as Hex (starting with 0x)
     * - | `Hash <#type-hash>`_ 
       - | Type alias
       - | a 32 byte Hash encoded as Hex (starting with 0x)
     * - | `Hex <#type-hex>`_ 
       - | Type
       - | a Hexcoded String (starting with 0x)
     * - | `Log <#type-log>`_ 
       - | Type literal
       - | the Log
     * - | `LogFilter <#type-logfilter>`_ 
       - | Type literal
       - | the LogFilter
     * - | `Quantity <#type-quantity>`_ 
       - | Type
       - | a BigInteger encoded as hex.
     * - | `Signature <#type-signature>`_ 
       - | Type literal
       - | Signature
     * - | `Transaction <#type-transaction>`_ 
       - | Type literal
       - | the Transaction
     * - | `TransactionDetail <#type-transactiondetail>`_ 
       - | Type literal
       - | the TransactionDetail
     * - | `TransactionReceipt <#type-transactionreceipt>`_ 
       - | Type literal
       - | the TransactionReceipt
     * - | `TxRequest <#type-txrequest>`_ 
       - | Type literal
       - | the TxRequest

```


## Package in3


### Type IN3


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L456)


default Incubed client with
bigint for big numbers
Uint8Array for bytes

```eval_rst
  .. list-table::
     :widths: auto

     * - | `default <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L448>`_
       - | `IN3Generic <#type-in3generic>`_ 
       - | supporting both ES6 and UMD usage 
     * - | `util <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L441>`_
       - | `Utils<any> <#type-utils>`_ 
       - | collection of util-functions. 
     * - | `config <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L349>`_
       - | `IN3Config <#type-in3config>`_ 
       - | IN3 config 
     * - | `eth <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L431>`_
       - | `EthAPI<bigint,Uint8Array> <#type-ethapi>`_ 
       - | eth1 API. 
     * - | `signer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L395>`_
       - | `Signer<bigint,Uint8Array> <#type-signer>`_ 
       - | the signer, if specified this interface will be used to sign transactions, if not, sending transaction will not be possible. 
     * - | `util <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L436>`_
       - | `Utils<Uint8Array> <#type-utils>`_ 
       - | collection of util-functions. 

```


#### freeAll()

```eval_rst
frees all Incubed instances. 
```

```eval_rst
static ``void`` `freeAll <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L425>`_ ()
```



#### onInit()

```eval_rst
registers a function to be called as soon as the wasm is ready.
If it is already initialized it will call it right away. 
```

```eval_rst
static `Promise<T> <#type-t>`_  `onInit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L419>`_ (
      fn:() => `T <#type-t>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | fn
       - | () => `T <#type-t>`_ 
       - | the function to call

```


Returns: 
```eval_rst
static `Promise<T> <#type-t>`_ 
```



#### setConvertBigInt()

```eval_rst
set convert big int 
```

```eval_rst
static ``any`` `setConvertBigInt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L465>`_ (
      convert:(``any``) => ``any``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | convert
       - | (``any``) => ``any``
       - | convert

```


Returns: 
```eval_rst
static ``any``
```



#### setConvertBuffer()

```eval_rst
set convert buffer 
```

```eval_rst
static ``any`` `setConvertBuffer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L466>`_ (
      convert:(``any``) => ``any``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | convert
       - | (``any``) => ``any``
       - | convert

```


Returns: 
```eval_rst
static ``any``
```



#### setStorage()

```eval_rst
changes the storage handler, which is called to read and write to the cache. 
```

```eval_rst
static ``void`` `setStorage <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L408>`_ (
      handler:)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | handler
       - | 
       - | handler

```




#### setTransport()

```eval_rst
changes the transport-function. 
```

```eval_rst
static ``void`` `setTransport <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L403>`_ (
      fn:(``string`` , ``string`` , ``number``) => ``Promise<string>``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | fn
       - | (``string`` , ``string`` , ``number``) => ``Promise<string>``
       - | the function to fetch the response for the given url
         | 

```




#### constructor()

```eval_rst
creates a new client. 
```

```eval_rst
`IN3 <#type-in3>`_  `constructor <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L456>`_ (
      config:`Partial<IN3Config> <#type-in3config>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | config
       - | `Partial<IN3Config> <#type-in3config>`_ 
       - | a optional config
         | 

```


Returns: 
```eval_rst
`IN3 <#type-in3>`_ 
```



#### createWeb3Provider()

```eval_rst
returns a Object, which can be used as Web3Provider.

```
const web3 = new Web3(new IN3().createWeb3Provider())
```
 
```

```eval_rst
``any`` `createWeb3Provider <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L390>`_ ()
```

Returns: 
```eval_rst
``any``
```



#### free()

```eval_rst
disposes the Client. This must be called in order to free allocated memory! 
```

```eval_rst
``any`` `free <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L381>`_ ()
```

Returns: 
```eval_rst
``any``
```



#### send()

```eval_rst
sends a raw request.
if the request is a array the response will be a array as well.
If the callback is given it will be called with the response, if not a Promise will be returned.
This function supports callback so it can be used as a Provider for the web3. 
```

```eval_rst
`Promise<RPCResponse> <#type-rpcresponse>`_  `send <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L367>`_ (
      request:`RPCRequest <#type-rpcrequest>`_ ,
      callback:(`Error <#type-error>`_  , `RPCResponse <#type-rpcresponse>`_ ) => ``void``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | request
       - | `RPCRequest <#type-rpcrequest>`_ 
       - | a JSONRPC-Request with N3-Extension
     * - | callback
       - | (`Error <#type-error>`_  , `RPCResponse <#type-rpcresponse>`_ ) => ``void``
       - | callback

```


Returns: 
```eval_rst
`Promise<RPCResponse> <#type-rpcresponse>`_ 
```



#### sendRPC()

```eval_rst
sends a RPC-Requests specified by name and params.

if the response contains an error, this will be thrown. if not the result will be returned.
 
```

```eval_rst
``Promise<any>`` `sendRPC <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L376>`_ (
      method:``string``,
      params:``any`` [])
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | method
       - | ``string``
       - | the method to call.
         | 
     * - | params
       - | ``any`` []
       - | params

```


Returns: 
```eval_rst
``Promise<any>``
```



#### setConfig()

```eval_rst
sets configuration properties. You can pass a partial object specifieing any of defined properties. 
```

```eval_rst
``void`` `setConfig <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L359>`_ (
      config:`Partial<IN3Config> <#type-in3config>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | config
       - | `Partial<IN3Config> <#type-in3config>`_ 
       - | config

```




### Type IN3Generic


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L345)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `default <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L448>`_
       - | `IN3Generic <#type-in3generic>`_ 
       - | supporting both ES6 and UMD usage 
     * - | `util <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L441>`_
       - | `Utils<any> <#type-utils>`_ 
       - | collection of util-functions. 
     * - | `config <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L349>`_
       - | `IN3Config <#type-in3config>`_ 
       - | IN3 config 
     * - | `eth <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L431>`_
       - | `EthAPI<BigIntType,BufferType> <#type-ethapi>`_ 
       - | eth1 API. 
     * - | `signer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L395>`_
       - | `Signer<BigIntType,BufferType> <#type-signer>`_ 
       - | the signer, if specified this interface will be used to sign transactions, if not, sending transaction will not be possible. 
     * - | `util <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L436>`_
       - | `Utils<BufferType> <#type-utils>`_ 
       - | collection of util-functions. 

```


#### freeAll()

```eval_rst
frees all Incubed instances. 
```

```eval_rst
static ``void`` `freeAll <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L425>`_ ()
```



#### onInit()

```eval_rst
registers a function to be called as soon as the wasm is ready.
If it is already initialized it will call it right away. 
```

```eval_rst
static `Promise<T> <#type-t>`_  `onInit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L419>`_ (
      fn:() => `T <#type-t>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | fn
       - | () => `T <#type-t>`_ 
       - | the function to call

```


Returns: 
```eval_rst
static `Promise<T> <#type-t>`_ 
```



#### setConvertBigInt()

```eval_rst
set convert big int 
```

```eval_rst
static ``any`` `setConvertBigInt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L443>`_ (
      convert:(``any``) => ``any``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | convert
       - | (``any``) => ``any``
       - | convert

```


Returns: 
```eval_rst
static ``any``
```



#### setConvertBuffer()

```eval_rst
set convert buffer 
```

```eval_rst
static ``any`` `setConvertBuffer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L444>`_ (
      convert:(``any``) => ``any``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | convert
       - | (``any``) => ``any``
       - | convert

```


Returns: 
```eval_rst
static ``any``
```



#### setStorage()

```eval_rst
changes the storage handler, which is called to read and write to the cache. 
```

```eval_rst
static ``void`` `setStorage <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L408>`_ (
      handler:)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | handler
       - | 
       - | handler

```




#### setTransport()

```eval_rst
changes the transport-function. 
```

```eval_rst
static ``void`` `setTransport <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L403>`_ (
      fn:(``string`` , ``string`` , ``number``) => ``Promise<string>``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | fn
       - | (``string`` , ``string`` , ``number``) => ``Promise<string>``
       - | the function to fetch the response for the given url
         | 

```




#### constructor()

```eval_rst
creates a new client. 
```

```eval_rst
`IN3Generic <#type-in3generic>`_  `constructor <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L349>`_ (
      config:`Partial<IN3Config> <#type-in3config>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | config
       - | `Partial<IN3Config> <#type-in3config>`_ 
       - | a optional config
         | 

```


Returns: 
```eval_rst
`IN3Generic <#type-in3generic>`_ 
```



#### createWeb3Provider()

```eval_rst
returns a Object, which can be used as Web3Provider.

```
const web3 = new Web3(new IN3().createWeb3Provider())
```
 
```

```eval_rst
``any`` `createWeb3Provider <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L390>`_ ()
```

Returns: 
```eval_rst
``any``
```



#### free()

```eval_rst
disposes the Client. This must be called in order to free allocated memory! 
```

```eval_rst
``any`` `free <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L381>`_ ()
```

Returns: 
```eval_rst
``any``
```



#### send()

```eval_rst
sends a raw request.
if the request is a array the response will be a array as well.
If the callback is given it will be called with the response, if not a Promise will be returned.
This function supports callback so it can be used as a Provider for the web3. 
```

```eval_rst
`Promise<RPCResponse> <#type-rpcresponse>`_  `send <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L367>`_ (
      request:`RPCRequest <#type-rpcrequest>`_ ,
      callback:(`Error <#type-error>`_  , `RPCResponse <#type-rpcresponse>`_ ) => ``void``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | request
       - | `RPCRequest <#type-rpcrequest>`_ 
       - | a JSONRPC-Request with N3-Extension
     * - | callback
       - | (`Error <#type-error>`_  , `RPCResponse <#type-rpcresponse>`_ ) => ``void``
       - | callback

```


Returns: 
```eval_rst
`Promise<RPCResponse> <#type-rpcresponse>`_ 
```



#### sendRPC()

```eval_rst
sends a RPC-Requests specified by name and params.

if the response contains an error, this will be thrown. if not the result will be returned.
 
```

```eval_rst
``Promise<any>`` `sendRPC <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L376>`_ (
      method:``string``,
      params:``any`` [])
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | method
       - | ``string``
       - | the method to call.
         | 
     * - | params
       - | ``any`` []
       - | params

```


Returns: 
```eval_rst
``Promise<any>``
```



#### setConfig()

```eval_rst
sets configuration properties. You can pass a partial object specifieing any of defined properties. 
```

```eval_rst
``void`` `setConfig <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L359>`_ (
      config:`Partial<IN3Config> <#type-in3config>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | config
       - | `Partial<IN3Config> <#type-in3config>`_ 
       - | config

```




### Type SimpleSigner


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L953)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `accounts <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L954>`_
       - | 
       - | the accounts 

```


#### constructor()

```eval_rst
constructor 
```

```eval_rst
`SimpleSigner <#type-simplesigner>`_  `constructor <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L956>`_ (
      pks:``string`` | `BufferType <#type-buffertype>`_  [])
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | pks
       - | ``string`` | `BufferType <#type-buffertype>`_  []
       - | pks

```


Returns: 
```eval_rst
`SimpleSigner <#type-simplesigner>`_ 
```



#### prepareTransaction()

```eval_rst
optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig. 
```

```eval_rst
`Promise<Transaction> <#type-transaction>`_  `prepareTransaction <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L960>`_ (
      client:`IN3Generic<BigIntType,BufferType> <#type-in3generic>`_ ,
      tx:`Transaction <#type-transaction>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | client
       - | `IN3Generic<BigIntType,BufferType> <#type-in3generic>`_ 
       - | client
     * - | tx
       - | `Transaction <#type-transaction>`_ 
       - | tx

```


Returns: 
```eval_rst
`Promise<Transaction> <#type-transaction>`_ 
```



#### sign()

```eval_rst
signing of any data.
if hashFirst is true the data should be hashed first, otherwise the data is the hash. 
```

```eval_rst
`Promise<BufferType> <#type-buffertype>`_  `sign <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L969>`_ (
      data:`Hex <#type-hex>`_ ,
      account:`Address <#type-address>`_ ,
      hashFirst:``boolean``,
      ethV:``boolean``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | `Hex <#type-hex>`_ 
       - | a Hexcoded String (starting with 0x)
     * - | account
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | hashFirst
       - | ``boolean``
       - | hash first
     * - | ethV
       - | ``boolean``
       - | eth v

```


Returns: 
```eval_rst
`Promise<BufferType> <#type-buffertype>`_ 
```



#### addAccount()

```eval_rst
add account 
```

```eval_rst
``string`` `addAccount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L958>`_ (
      pk:`Hash <#type-hash>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | pk
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
``string``
```



#### hasAccount()

```eval_rst
returns true if the account is supported (or unlocked) 
```

```eval_rst
``Promise<boolean>`` `hasAccount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L963>`_ (
      account:`Address <#type-address>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | account
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
``Promise<boolean>``
```



### Type EthAPI


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L739)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `client <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L740>`_
       - | `IN3Generic<BigIntType,BufferType> <#type-in3generic>`_ 
       - | the client 
     * - | `signer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L741>`_
       - | `Signer<BigIntType,BufferType> <#type-signer>`_ 
       - | the signer  *(optional)* 

```


#### blockNumber()

```eval_rst
Returns the number of most recent block. (as number) 
```

```eval_rst
``Promise<number>`` `blockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L746>`_ ()
```

Returns: 
```eval_rst
``Promise<number>``
```



#### call()

```eval_rst
Executes a new message call immediately without creating a transaction on the block chain. 
```

```eval_rst
``Promise<string>`` `call <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L754>`_ (
      tx:`Transaction <#type-transaction>`_ ,
      block:`BlockType <#type-blocktype>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | tx
       - | `Transaction <#type-transaction>`_ 
       - | tx
     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block

```


Returns: 
```eval_rst
``Promise<string>``
```



#### callFn()

```eval_rst
Executes a function of a contract, by passing a [method-signature](https://github.com/ethereumjs/ethereumjs-abi/blob/master/README.md#simple-encoding-and-decoding) and the arguments, which will then be ABI-encoded and send as eth_call. 
```

```eval_rst
``Promise<any>`` `callFn <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L758>`_ (
      to:`Address <#type-address>`_ ,
      method:``string``,
      args:``any`` [])
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | to
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | method
       - | ``string``
       - | method
     * - | args
       - | ``any`` []
       - | args

```


Returns: 
```eval_rst
``Promise<any>``
```



#### chainId()

```eval_rst
Returns the EIP155 chain ID used for transaction signing at the current best block. Null is returned if not available. 
```

```eval_rst
``Promise<string>`` `chainId <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L762>`_ ()
```

Returns: 
```eval_rst
``Promise<string>``
```



#### constructor()

```eval_rst
constructor 
```

```eval_rst
``any`` `constructor <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L742>`_ (
      client:`IN3Generic<BigIntType,BufferType> <#type-in3generic>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | client
       - | `IN3Generic<BigIntType,BufferType> <#type-in3generic>`_ 
       - | client

```


Returns: 
```eval_rst
``any``
```



#### contractAt()

```eval_rst
contract at 
```

```eval_rst
 `contractAt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L910>`_ (
      abi:`ABI <#type-abi>`_  [],
      address:`Address <#type-address>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | abi
       - | `ABI <#type-abi>`_  []
       - | abi
     * - | address
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)

```




#### decodeEventData()

```eval_rst
decode event data 
```

```eval_rst
``any`` `decodeEventData <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L950>`_ (
      log:`Log <#type-log>`_ ,
      d:`ABI <#type-abi>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | log
       - | `Log <#type-log>`_ 
       - | log
     * - | d
       - | `ABI <#type-abi>`_ 
       - | d

```


Returns: 
```eval_rst
``any``
```



#### estimateGas()

```eval_rst
Makes a call or transaction, which won’t be added to the blockchain and returns the used gas, which can be used for estimating the used gas. 
```

```eval_rst
``Promise<number>`` `estimateGas <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L766>`_ (
      tx:`Transaction <#type-transaction>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | tx
       - | `Transaction <#type-transaction>`_ 
       - | tx

```


Returns: 
```eval_rst
``Promise<number>``
```



#### gasPrice()

```eval_rst
Returns the current price per gas in wei. (as number) 
```

```eval_rst
``Promise<number>`` `gasPrice <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L750>`_ ()
```

Returns: 
```eval_rst
``Promise<number>``
```



#### getBalance()

```eval_rst
Returns the balance of the account of given address in wei (as hex). 
```

```eval_rst
`Promise<BigIntType> <#type-biginttype>`_  `getBalance <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L770>`_ (
      address:`Address <#type-address>`_ ,
      block:`BlockType <#type-blocktype>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | address
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block

```


Returns: 
```eval_rst
`Promise<BigIntType> <#type-biginttype>`_ 
```



#### getBlockByHash()

```eval_rst
Returns information about a block by hash. 
```

```eval_rst
`Promise<Block> <#type-block>`_  `getBlockByHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L782>`_ (
      hash:`Hash <#type-hash>`_ ,
      includeTransactions:``boolean``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | hash
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)
     * - | includeTransactions
       - | ``boolean``
       - | include transactions

```


Returns: 
```eval_rst
`Promise<Block> <#type-block>`_ 
```



#### getBlockByNumber()

```eval_rst
Returns information about a block by block number. 
```

```eval_rst
`Promise<Block> <#type-block>`_  `getBlockByNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L786>`_ (
      block:`BlockType <#type-blocktype>`_ ,
      includeTransactions:``boolean``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block
     * - | includeTransactions
       - | ``boolean``
       - | include transactions

```


Returns: 
```eval_rst
`Promise<Block> <#type-block>`_ 
```



#### getBlockTransactionCountByHash()

```eval_rst
Returns the number of transactions in a block from a block matching the given block hash. 
```

```eval_rst
``Promise<number>`` `getBlockTransactionCountByHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L790>`_ (
      block:`Hash <#type-hash>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | block
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
``Promise<number>``
```



#### getBlockTransactionCountByNumber()

```eval_rst
Returns the number of transactions in a block from a block matching the given block number. 
```

```eval_rst
``Promise<number>`` `getBlockTransactionCountByNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L794>`_ (
      block:`Hash <#type-hash>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | block
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
``Promise<number>``
```



#### getCode()

```eval_rst
Returns code at a given address. 
```

```eval_rst
``Promise<string>`` `getCode <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L774>`_ (
      address:`Address <#type-address>`_ ,
      block:`BlockType <#type-blocktype>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | address
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block

```


Returns: 
```eval_rst
``Promise<string>``
```



#### getFilterChanges()

```eval_rst
Polling method for a filter, which returns an array of logs which occurred since last poll. 
```

```eval_rst
``Promise<>`` `getFilterChanges <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L798>`_ (
      id:`Quantity <#type-quantity>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | id
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.

```


Returns: 
```eval_rst
``Promise<>``
```



#### getFilterLogs()

```eval_rst
Returns an array of all logs matching filter with given id. 
```

```eval_rst
``Promise<>`` `getFilterLogs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L802>`_ (
      id:`Quantity <#type-quantity>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | id
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.

```


Returns: 
```eval_rst
``Promise<>``
```



#### getLogs()

```eval_rst
Returns an array of all logs matching a given filter object. 
```

```eval_rst
``Promise<>`` `getLogs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L806>`_ (
      filter:`LogFilter <#type-logfilter>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | filter
       - | `LogFilter <#type-logfilter>`_ 
       - | filter

```


Returns: 
```eval_rst
``Promise<>``
```



#### getStorageAt()

```eval_rst
Returns the value from a storage position at a given address. 
```

```eval_rst
``Promise<string>`` `getStorageAt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L778>`_ (
      address:`Address <#type-address>`_ ,
      pos:`Quantity <#type-quantity>`_ ,
      block:`BlockType <#type-blocktype>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | address
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | pos
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.
     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block

```


Returns: 
```eval_rst
``Promise<string>``
```



#### getTransactionByBlockHashAndIndex()

```eval_rst
Returns information about a transaction by block hash and transaction index position. 
```

```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_  `getTransactionByBlockHashAndIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L810>`_ (
      hash:`Hash <#type-hash>`_ ,
      pos:`Quantity <#type-quantity>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | hash
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)
     * - | pos
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.

```


Returns: 
```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_ 
```



#### getTransactionByBlockNumberAndIndex()

```eval_rst
Returns information about a transaction by block number and transaction index position. 
```

```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_  `getTransactionByBlockNumberAndIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L814>`_ (
      block:`BlockType <#type-blocktype>`_ ,
      pos:`Quantity <#type-quantity>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block
     * - | pos
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.

```


Returns: 
```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_ 
```



#### getTransactionByHash()

```eval_rst
Returns the information about a transaction requested by transaction hash. 
```

```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_  `getTransactionByHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L818>`_ (
      hash:`Hash <#type-hash>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | hash
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_ 
```



#### getTransactionCount()

```eval_rst
Returns the number of transactions sent from an address. (as number) 
```

```eval_rst
``Promise<number>`` `getTransactionCount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L822>`_ (
      address:`Address <#type-address>`_ ,
      block:`BlockType <#type-blocktype>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | address
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block

```


Returns: 
```eval_rst
``Promise<number>``
```



#### getTransactionReceipt()

```eval_rst
Returns the receipt of a transaction by transaction hash.
Note That the receipt is available even for pending transactions. 
```

```eval_rst
`Promise<TransactionReceipt> <#type-transactionreceipt>`_  `getTransactionReceipt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L827>`_ (
      hash:`Hash <#type-hash>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | hash
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
`Promise<TransactionReceipt> <#type-transactionreceipt>`_ 
```



#### getUncleByBlockHashAndIndex()

```eval_rst
Returns information about a uncle of a block by hash and uncle index position.
Note: An uncle doesn’t contain individual transactions. 
```

```eval_rst
`Promise<Block> <#type-block>`_  `getUncleByBlockHashAndIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L832>`_ (
      hash:`Hash <#type-hash>`_ ,
      pos:`Quantity <#type-quantity>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | hash
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)
     * - | pos
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.

```


Returns: 
```eval_rst
`Promise<Block> <#type-block>`_ 
```



#### getUncleByBlockNumberAndIndex()

```eval_rst
Returns information about a uncle of a block number and uncle index position.
Note: An uncle doesn’t contain individual transactions. 
```

```eval_rst
`Promise<Block> <#type-block>`_  `getUncleByBlockNumberAndIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L837>`_ (
      block:`BlockType <#type-blocktype>`_ ,
      pos:`Quantity <#type-quantity>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block
     * - | pos
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.

```


Returns: 
```eval_rst
`Promise<Block> <#type-block>`_ 
```



#### getUncleCountByBlockHash()

```eval_rst
Returns the number of uncles in a block from a block matching the given block hash. 
```

```eval_rst
``Promise<number>`` `getUncleCountByBlockHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L841>`_ (
      hash:`Hash <#type-hash>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | hash
       - | `Hash <#type-hash>`_ 
       - | a 32 byte Hash encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
``Promise<number>``
```



#### getUncleCountByBlockNumber()

```eval_rst
Returns the number of uncles in a block from a block matching the given block hash. 
```

```eval_rst
``Promise<number>`` `getUncleCountByBlockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L845>`_ (
      block:`BlockType <#type-blocktype>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | block
       - | `BlockType <#type-blocktype>`_ 
       - | BlockNumber or predefined Block

```


Returns: 
```eval_rst
``Promise<number>``
```



#### hashMessage()

```eval_rst
a Hexcoded String (starting with 0x) 
```

```eval_rst
`Hex <#type-hex>`_  `hashMessage <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L951>`_ (
      data:`Data <#type-data>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | `Data <#type-data>`_ 
       - | data encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
`Hex <#type-hex>`_ 
```



#### newBlockFilter()

```eval_rst
Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges. 
```

```eval_rst
``Promise<string>`` `newBlockFilter <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L849>`_ ()
```

Returns: 
```eval_rst
``Promise<string>``
```



#### newFilter()

```eval_rst
Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges.

A note on specifying topic filters:
Topics are order-dependent. A transaction with a log with topics [A, B] will be matched by the following topic filters:

[] “anything”
[A] “A in first position (and anything after)”
[null, B] “anything in first position AND B in second position (and anything after)”
[A, B] “A in first position AND B in second position (and anything after)”
[[A, B], [A, B]] “(A OR B) in first position AND (A OR B) in second position (and anything after)”
 
```

```eval_rst
``Promise<string>`` `newFilter <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L862>`_ (
      filter:`LogFilter <#type-logfilter>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | filter
       - | `LogFilter <#type-logfilter>`_ 
       - | filter

```


Returns: 
```eval_rst
``Promise<string>``
```



#### newPendingTransactionFilter()

```eval_rst
Creates a filter in the node, to notify when new pending transactions arrive.

To check if the state has changed, call eth_getFilterChanges.
 
```

```eval_rst
``Promise<string>`` `newPendingTransactionFilter <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L868>`_ ()
```

Returns: 
```eval_rst
``Promise<string>``
```



#### protocolVersion()

```eval_rst
Returns the current ethereum protocol version. 
```

```eval_rst
``Promise<string>`` `protocolVersion <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L876>`_ ()
```

Returns: 
```eval_rst
``Promise<string>``
```



#### resolveENS()

```eval_rst
resolves a name as an ENS-Domain. 
```

```eval_rst
`Promise<Address> <#type-address>`_  `resolveENS <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L895>`_ (
      name:``string``,
      type:`Address <#type-address>`_ ,
      registry:``string``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | name
       - | ``string``
       - | the domain name
     * - | type
       - | `Address <#type-address>`_ 
       - | the type (currently only addr is supported)
     * - | registry
       - | ``string``
       - | optionally the address of the registry (default is the mainnet ens registry)
         | 

```


Returns: 
```eval_rst
`Promise<Address> <#type-address>`_ 
```



#### sendRawTransaction()

```eval_rst
Creates new message call transaction or a contract creation for signed transactions. 
```

```eval_rst
``Promise<string>`` `sendRawTransaction <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L900>`_ (
      data:`Data <#type-data>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | `Data <#type-data>`_ 
       - | data encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
``Promise<string>``
```



#### sendTransaction()

```eval_rst
sends a Transaction 
```

```eval_rst
``Promise<>`` `sendTransaction <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L908>`_ (
      args:`TxRequest <#type-txrequest>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | args
       - | `TxRequest <#type-txrequest>`_ 
       - | args

```


Returns: 
```eval_rst
``Promise<>``
```



#### sign()

```eval_rst
signs any kind of message using the `\x19Ethereum Signed Message:\n`-prefix 
```

```eval_rst
`Promise<BufferType> <#type-buffertype>`_  `sign <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L906>`_ (
      account:`Address <#type-address>`_ ,
      data:`Data <#type-data>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | account
       - | `Address <#type-address>`_ 
       - | the address to sign the message with (if this is a 32-bytes hex-string it will be used as private key)
     * - | data
       - | `Data <#type-data>`_ 
       - | the data to sign (Buffer, hexstring or utf8-string)
         | 

```


Returns: 
```eval_rst
`Promise<BufferType> <#type-buffertype>`_ 
```



#### syncing()

```eval_rst
Returns the current ethereum protocol version. 
```

```eval_rst
``Promise<>`` `syncing <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L880>`_ ()
```

Returns: 
```eval_rst
``Promise<>``
```



#### uninstallFilter()

```eval_rst
Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren’t requested with eth_getFilterChanges for a period of time. 
```

```eval_rst
`Promise<Quantity> <#type-quantity>`_  `uninstallFilter <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L872>`_ (
      id:`Quantity <#type-quantity>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | id
       - | `Quantity <#type-quantity>`_ 
       - | a BigInteger encoded as hex.

```


Returns: 
```eval_rst
`Promise<Quantity> <#type-quantity>`_ 
```



### Type IN3Config


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L38)


the iguration of the IN3-Client. This can be paritally overriden for every request.

```eval_rst
  .. list-table::
     :widths: auto

     * - | `autoConfig <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L65>`_
       - | ``boolean``
       - | if true the config will be adjusted depending on the request  *(optional)* 
     * - | `autoUpdateList <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L147>`_
       - | ``boolean``
       - | if true the nodelist will be automaticly updated if the lastBlock is newer
         | example: true  *(optional)* 
     * - | `cacheTimeout <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L42>`_
       - | ``number``
       - | number of seconds requests can be cached.  *(optional)* 
     * - | `chainId <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L132>`_
       - | ``string``
       - | servers to filter for the given chain. The chain-id based on EIP-155.
         | example: 0x1 
     * - | `chainRegistry <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L137>`_
       - | ``string``
       - | main chain-registry contract
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945  *(optional)* 
     * - | `finality <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L122>`_
       - | ``number``
       - | the number in percent needed in order reach finality (% of signature of the validators)
         | example: 50  *(optional)* 
     * - | `format <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L56>`_
       - | ``'json'`` | ``'jsonRef'`` | ``'cbor'``
       - | the format for sending the data to the client. Default is json, but using cbor means using only 30-40% of the payload since it is using binary encoding
         | example: json  *(optional)* 
     * - | `includeCode <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L79>`_
       - | ``boolean``
       - | if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
         | example: true  *(optional)* 
     * - | `keepIn3 <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L51>`_
       - | ``boolean``
       - | if true, the in3-section of thr response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.  *(optional)* 
     * - | `key <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L61>`_
       - | ``any``
       - | the client key to sign requests
         | example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7  *(optional)* 
     * - | `mainChain <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L142>`_
       - | ``string``
       - | main chain-id, where the chain registry is running.
         | example: 0x1  *(optional)* 
     * - | `maxAttempts <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L74>`_
       - | ``number``
       - | max number of attempts in case a response is rejected
         | example: 10  *(optional)* 
     * - | `maxBlockCache <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L89>`_
       - | ``number``
       - | number of number of blocks cached  in memory
         | example: 100  *(optional)* 
     * - | `maxCodeCache <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L84>`_
       - | ``number``
       - | number of max bytes used to cache the code in memory
         | example: 100000  *(optional)* 
     * - | `minDeposit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L107>`_
       - | ``number``
       - | min stake of the server. Only nodes owning at least this amount will be chosen. 
     * - | `nodeLimit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L47>`_
       - | ``number``
       - | the limit of nodes to store in the client.
         | example: 150  *(optional)* 
     * - | `proof <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L98>`_
       - | ``'none'`` | ``'standard'`` | ``'full'``
       - | if true the nodes should send a proof of the response
         | example: true  *(optional)* 
     * - | `replaceLatestBlock <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L112>`_
       - | ``number``
       - | if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
         | example: 6  *(optional)* 
     * - | `requestCount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L117>`_
       - | ``number``
       - | the number of request send when getting a first answer
         | example: 3 
     * - | `retryWithoutProof <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L69>`_
       - | ``boolean``
       - | if true the the request may be handled without proof in case of an error. (use with care!)  *(optional)* 
     * - | `rpc <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L151>`_
       - | ``string``
       - | url of one or more rpc-endpoints to use. (list can be comma seperated)  *(optional)* 
     * - | `servers <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L155>`_
       - | 
       - | the nodelist per chain  *(optional)* 
     * - | `signatureCount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L103>`_
       - | ``number``
       - | number of signatures requested
         | example: 2  *(optional)* 
     * - | `timeout <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L127>`_
       - | ``number``
       - | specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
         | example: 3000  *(optional)* 
     * - | `verifiedHashes <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L93>`_
       - | ``string`` []
       - | if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.  *(optional)* 

```


### Type IN3NodeConfig


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L210)


a configuration of a in3-server.

```eval_rst
  .. list-table::
     :widths: auto

     * - | `address <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L220>`_
       - | ``string``
       - | the address of the node, which is the public address it iis signing with.
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679 
     * - | `capacity <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L245>`_
       - | ``number``
       - | the capacity of the node.
         | example: 100  *(optional)* 
     * - | `chainIds <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L235>`_
       - | ``string`` []
       - | the list of supported chains
         | example: 0x1 
     * - | `deposit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L240>`_
       - | ``number``
       - | the deposit of the node in wei
         | example: 12350000 
     * - | `index <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L215>`_
       - | ``number``
       - | the index within the contract
         | example: 13  *(optional)* 
     * - | `props <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L250>`_
       - | ``number``
       - | the properties of the node.
         | example: 3  *(optional)* 
     * - | `registerTime <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L255>`_
       - | ``number``
       - | the UNIX-timestamp when the node was registered
         | example: 1563279168  *(optional)* 
     * - | `timeout <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L225>`_
       - | ``number``
       - | the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
         | example: 3600  *(optional)* 
     * - | `unregisterTime <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L260>`_
       - | ``number``
       - | the UNIX-timestamp when the node is allowed to be deregister
         | example: 1563279168  *(optional)* 
     * - | `url <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L230>`_
       - | ``string``
       - | the endpoint to post to
         | example: https://in3.slock.it 

```


### Type IN3NodeWeight


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L265)


a local weight of a n3-node. (This is used internally to weight the requests)

```eval_rst
  .. list-table::
     :widths: auto

     * - | `avgResponseTime <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L280>`_
       - | ``number``
       - | average time of a response in ms
         | example: 240  *(optional)* 
     * - | `blacklistedUntil <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L294>`_
       - | ``number``
       - | blacklisted because of failed requests until the timestamp
         | example: 1529074639623  *(optional)* 
     * - | `lastRequest <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L289>`_
       - | ``number``
       - | timestamp of the last request in ms
         | example: 1529074632623  *(optional)* 
     * - | `pricePerRequest <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L284>`_
       - | ``number``
       - | last price  *(optional)* 
     * - | `responseCount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L275>`_
       - | ``number``
       - | number of uses.
         | example: 147  *(optional)* 
     * - | `weight <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L270>`_
       - | ``number``
       - | factor the weight this noe (default 1.0)
         | example: 0.5  *(optional)* 

```


### Type RPCRequest


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L300)


a JSONRPC-Request with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | `id <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L314>`_
       - | ``number`` | ``string``
       - | the identifier of the request
         | example: 2  *(optional)* 
     * - | `jsonrpc <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L304>`_
       - | ``'2.0'``
       - | the version 
     * - | `method <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L309>`_
       - | ``string``
       - | the method to call
         | example: eth_getBalance 
     * - | `params <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L319>`_
       - | ``any`` []
       - | the params
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest  *(optional)* 

```


### Type RPCResponse


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L324)


a JSONRPC-Responset with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | `error <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L337>`_
       - | ``string``
       - | in case of an error this needs to be set  *(optional)* 
     * - | `id <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L333>`_
       - | ``string`` | ``number``
       - | the id matching the request
         | example: 2 
     * - | `jsonrpc <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L328>`_
       - | ``'2.0'``
       - | the version 
     * - | `result <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L342>`_
       - | ``any``
       - | the params
         | example: 0xa35bc  *(optional)* 

```


### Type Signer


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L725)






#### prepareTransaction()

```eval_rst
optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig. 
```

```eval_rst
`Promise<Transaction> <#type-transaction>`_  `prepareTransaction <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L727>`_ (
      client:`IN3Generic<BigIntType,BufferType> <#type-in3generic>`_ ,
      tx:`Transaction <#type-transaction>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | client
       - | `IN3Generic<BigIntType,BufferType> <#type-in3generic>`_ 
       - | client
     * - | tx
       - | `Transaction <#type-transaction>`_ 
       - | tx

```


Returns: 
```eval_rst
`Promise<Transaction> <#type-transaction>`_ 
```



#### sign()

```eval_rst
signing of any data.
if hashFirst is true the data should be hashed first, otherwise the data is the hash. 
```

```eval_rst
`Promise<BufferType> <#type-buffertype>`_  `sign <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L736>`_ (
      data:`Hex <#type-hex>`_ ,
      account:`Address <#type-address>`_ ,
      hashFirst:``boolean``,
      ethV:``boolean``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | `Hex <#type-hex>`_ 
       - | a Hexcoded String (starting with 0x)
     * - | account
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)
     * - | hashFirst
       - | ``boolean``
       - | hash first
     * - | ethV
       - | ``boolean``
       - | eth v

```


Returns: 
```eval_rst
`Promise<BufferType> <#type-buffertype>`_ 
```



#### hasAccount()

```eval_rst
returns true if the account is supported (or unlocked) 
```

```eval_rst
``Promise<boolean>`` `hasAccount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L730>`_ (
      account:`Address <#type-address>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | account
       - | `Address <#type-address>`_ 
       - | a 20 byte Address encoded as Hex (starting with 0x)

```


Returns: 
```eval_rst
``Promise<boolean>``
```



### Type Utils


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L975)


Collection of different util-functions.



#### abiDecode()

```eval_rst
decodes the given data as ABI-encoded (without the methodHash) 
```

```eval_rst
``any`` [] `abiDecode <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L995>`_ (
      signature:``string``,
      data:`Data <#type-data>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | signature
       - | ``string``
       - | the method signature, which must contain a return description
     * - | data
       - | `Data <#type-data>`_ 
       - | the data to decode
         | 

```


Returns: 
```eval_rst
``any`` []
```



#### abiEncode()

```eval_rst
encodes the given arguments as ABI-encoded (including the methodHash) 
```

```eval_rst
`Hex <#type-hex>`_  `abiEncode <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L988>`_ (
      signature:``string``,
      args:``any`` [])
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | signature
       - | ``string``
       - | the method signature
     * - | args
       - | ``any`` []
       - | the arguments
         | 

```


Returns: 
```eval_rst
`Hex <#type-hex>`_ 
```



#### createSignatureHash()

```eval_rst
a Hexcoded String (starting with 0x) 
```

```eval_rst
`Hex <#type-hex>`_  `createSignatureHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L978>`_ (
      def:`ABI <#type-abi>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | def
       - | `ABI <#type-abi>`_ 
       - | def

```


Returns: 
```eval_rst
`Hex <#type-hex>`_ 
```



#### decodeEvent()

```eval_rst
decode event 
```

```eval_rst
``any`` `decodeEvent <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L980>`_ (
      log:`Log <#type-log>`_ ,
      d:`ABI <#type-abi>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | log
       - | `Log <#type-log>`_ 
       - | log
     * - | d
       - | `ABI <#type-abi>`_ 
       - | d

```


Returns: 
```eval_rst
``any``
```



#### ecSign()

```eval_rst
create a signature (65 bytes) for the given message and kexy 
```

```eval_rst
`BufferType <#type-buffertype>`_  `ecSign <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1050>`_ (
      pk:`Hex <#type-hex>`_  | `BufferType <#type-buffertype>`_ ,
      msg:`Hex <#type-hex>`_  | `BufferType <#type-buffertype>`_ ,
      hashFirst:``boolean``,
      adjustV:``boolean``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | pk
       - | `Hex <#type-hex>`_  
         | | `BufferType <#type-buffertype>`_ 
       - | the private key
     * - | msg
       - | `Hex <#type-hex>`_  
         | | `BufferType <#type-buffertype>`_ 
       - | the message
     * - | hashFirst
       - | ``boolean``
       - | if true the message will be hashed first (default:true), if not the message is the hash.
     * - | adjustV
       - | ``boolean``
       - | if true (default) the v value will be adjusted by adding 27
         | 

```


Returns: 
```eval_rst
`BufferType <#type-buffertype>`_ 
```



#### keccak()

```eval_rst
calculates the keccack hash for the given data. 
```

```eval_rst
`BufferType <#type-buffertype>`_  `keccak <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1009>`_ (
      data:`BufferType <#type-buffertype>`_  | `Data <#type-data>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | `BufferType <#type-buffertype>`_  
         | | `Data <#type-data>`_ 
       - | the data as Uint8Array or hex data.
         | 

```


Returns: 
```eval_rst
`BufferType <#type-buffertype>`_ 
```



#### private2address()

```eval_rst
generates the public address from the private key. 
```

```eval_rst
`Address <#type-address>`_  `private2address <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1064>`_ (
      pk:`Hex <#type-hex>`_  | `BufferType <#type-buffertype>`_ )
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | pk
       - | `Hex <#type-hex>`_  
         | | `BufferType <#type-buffertype>`_ 
       - | the private key.
         | 

```


Returns: 
```eval_rst
`Address <#type-address>`_ 
```



#### soliditySha3()

```eval_rst
solidity sha3 
```

```eval_rst
``string`` `soliditySha3 <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L981>`_ (
      args:``any`` [])
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | args
       - | ``any`` []
       - | args

```


Returns: 
```eval_rst
``string``
```



#### splitSignature()

```eval_rst
takes raw signature (65 bytes) and splits it into a signature object. 
```

```eval_rst
`Signature <#type-signature>`_  `splitSignature <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1058>`_ (
      signature:`Hex <#type-hex>`_  | `BufferType <#type-buffertype>`_ ,
      message:`BufferType <#type-buffertype>`_  | `Hex <#type-hex>`_ ,
      hashFirst:``boolean``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | signature
       - | `Hex <#type-hex>`_  
         | | `BufferType <#type-buffertype>`_ 
       - | the 65 byte-signature
     * - | message
       - | `BufferType <#type-buffertype>`_  
         | | `Hex <#type-hex>`_ 
       - | the message
     * - | hashFirst
       - | ``boolean``
       - | if true (default) this will be taken as raw-data and will be hashed first.
         | 

```


Returns: 
```eval_rst
`Signature <#type-signature>`_ 
```



#### toBuffer()

```eval_rst
converts any value to a Buffer.
optionally the target length can be specified (in bytes) 
```

```eval_rst
`BufferType <#type-buffertype>`_  `toBuffer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1030>`_ (
      data:`Hex <#type-hex>`_  | `BufferType <#type-buffertype>`_  | ``number`` | ``bigint``,
      len:``number``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | `Hex <#type-hex>`_  
         | | `BufferType <#type-buffertype>`_  
         | | ``number`` 
         | | ``bigint``
       - | data
     * - | len
       - | ``number``
       - | len

```


Returns: 
```eval_rst
`BufferType <#type-buffertype>`_ 
```



#### toChecksumAddress()

```eval_rst
generates a checksum Address for the given address.
If the chainId is passed, it will be included accord to EIP 1191 
```

```eval_rst
`Address <#type-address>`_  `toChecksumAddress <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1003>`_ (
      address:`Address <#type-address>`_ ,
      chainId:``number``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | address
       - | `Address <#type-address>`_ 
       - | the address (as hex)
     * - | chainId
       - | ``number``
       - | the chainId (if supported)
         | 

```


Returns: 
```eval_rst
`Address <#type-address>`_ 
```



#### toHex()

```eval_rst
converts any value to a hex string (with prefix 0x).
optionally the target length can be specified (in bytes) 
```

```eval_rst
`Hex <#type-hex>`_  `toHex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1015>`_ (
      data:`Hex <#type-hex>`_  | `BufferType <#type-buffertype>`_  | ``number`` | ``bigint``,
      len:``number``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | `Hex <#type-hex>`_  
         | | `BufferType <#type-buffertype>`_  
         | | ``number`` 
         | | ``bigint``
       - | data
     * - | len
       - | ``number``
       - | len

```


Returns: 
```eval_rst
`Hex <#type-hex>`_ 
```



#### toMinHex()

```eval_rst
removes all leading 0 in the hexstring 
```

```eval_rst
``string`` `toMinHex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1018>`_ (
      key:``string`` | `BufferType <#type-buffertype>`_  | ``number``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | key
       - | ``string`` 
         | | `BufferType <#type-buffertype>`_  
         | | ``number``
       - | key

```


Returns: 
```eval_rst
``string``
```



#### toNumber()

```eval_rst
converts any value to a hex string (with prefix 0x).
optionally the target length can be specified (in bytes) 
```

```eval_rst
``number`` `toNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1036>`_ (
      data:``string`` | `BufferType <#type-buffertype>`_  | ``number`` | ``bigint``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | ``string`` 
         | | `BufferType <#type-buffertype>`_  
         | | ``number`` 
         | | ``bigint``
       - | data

```


Returns: 
```eval_rst
``number``
```



#### toUint8Array()

```eval_rst
converts any value to a Uint8Array.
optionally the target length can be specified (in bytes) 
```

```eval_rst
`BufferType <#type-buffertype>`_  `toUint8Array <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1024>`_ (
      data:`Hex <#type-hex>`_  | `BufferType <#type-buffertype>`_  | ``number`` | ``bigint``,
      len:``number``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | data
       - | `Hex <#type-hex>`_  
         | | `BufferType <#type-buffertype>`_  
         | | ``number`` 
         | | ``bigint``
       - | data
     * - | len
       - | ``number``
       - | len

```


Returns: 
```eval_rst
`BufferType <#type-buffertype>`_ 
```



#### toUtf8()

```eval_rst
convert to String 
```

```eval_rst
``string`` `toUtf8 <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1041>`_ (
      val:``any``)
```

Parameters: 
```eval_rst
  .. list-table::
     :widths: auto

     * - | val
       - | ``any``
       - | val

```


Returns: 
```eval_rst
``string``
```



### Type ABI


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L512)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `anonymous <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L513>`_
       - | ``boolean``
       - | the anonymous  *(optional)* 
     * - | `constant <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L514>`_
       - | ``boolean``
       - | the constant  *(optional)* 
     * - | `inputs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L518>`_
       - | `ABIField <#type-abifield>`_  []
       - | the inputs  *(optional)* 
     * - | `name <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L520>`_
       - | ``string``
       - | the name  *(optional)* 
     * - | `outputs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L519>`_
       - | `ABIField <#type-abifield>`_  []
       - | the outputs  *(optional)* 
     * - | `payable <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L515>`_
       - | ``boolean``
       - | the payable  *(optional)* 
     * - | `stateMutability <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L516>`_
       - | ``'nonpayable'`` 
         | | ``'payable'`` 
         | | ``'view'`` 
         | | ``'pure'``
       - | the stateMutability  *(optional)* 
     * - | `type <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L521>`_
       - | ``'event'`` 
         | | ``'function'`` 
         | | ``'constructor'`` 
         | | ``'fallback'``
       - | the type 

```


### Type ABIField


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L507)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `indexed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L508>`_
       - | ``boolean``
       - | the indexed  *(optional)* 
     * - | `name <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L509>`_
       - | ``string``
       - | the name 
     * - | `type <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L510>`_
       - | ``string``
       - | the type 

```


### Type Address


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L489)


a 20 byte Address encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Block


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L612)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `author <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L632>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - the address of the author of the block (the beneficiary to whom the mining rewards were given) 
     * - | `difficulty <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L636>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the difficulty for this block 
     * - | `extraData <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L640>`_
       - | `Data <#type-data>`_ 
       - | the ‘extra data’ field of this block 
     * - | `gasLimit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L644>`_
       - | `Quantity <#type-quantity>`_ 
       - | the maximum gas allowed in this block 
     * - | `gasUsed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L646>`_
       - | `Quantity <#type-quantity>`_ 
       - | the total used gas by all transactions in this block 
     * - | `hash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L616>`_
       - | `Hash <#type-hash>`_ 
       - | hash of the block. null when its pending block 
     * - | `logsBloom <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L624>`_
       - | `Data <#type-data>`_ 
       - | 256 Bytes - the bloom filter for the logs of the block. null when its pending block 
     * - | `miner <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L634>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - alias of ‘author’ 
     * - | `nonce <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L620>`_
       - | `Data <#type-data>`_ 
       - | 8 bytes hash of the generated proof-of-work. null when its pending block. Missing in case of PoA. 
     * - | `number <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L614>`_
       - | `Quantity <#type-quantity>`_ 
       - | The block number. null when its pending block 
     * - | `parentHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L618>`_
       - | `Hash <#type-hash>`_ 
       - | hash of the parent block 
     * - | `receiptsRoot <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L630>`_
       - | `Data <#type-data>`_ 
       - | 32 Bytes - the root of the receipts trie of the block 
     * - | `sealFields <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L654>`_
       - | `Data <#type-data>`_  []
       - | PoA-Fields 
     * - | `sha3Uncles <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L622>`_
       - | `Data <#type-data>`_ 
       - | SHA3 of the uncles data in the block 
     * - | `size <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L642>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer the size of this block in bytes 
     * - | `stateRoot <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L628>`_
       - | `Data <#type-data>`_ 
       - | 32 Bytes - the root of the final state trie of the block 
     * - | `timestamp <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L648>`_
       - | `Quantity <#type-quantity>`_ 
       - | the unix timestamp for when the block was collated 
     * - | `totalDifficulty <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L638>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the total difficulty of the chain until this block 
     * - | `transactions <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L650>`_
       - | ``string`` |  []
       - | Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter 
     * - | `transactionsRoot <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L626>`_
       - | `Data <#type-data>`_ 
       - | 32 Bytes - the root of the transaction trie of the block 
     * - | `uncles <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L652>`_
       - | `Hash <#type-hash>`_  []
       - | Array of uncle hashes 

```


### Type Data


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L493)


data encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Hash


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L485)


a 32 byte Hash encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Log


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L656)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `address <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L670>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - address from which this log originated. 
     * - | `blockHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L666>`_
       - | `Hash <#type-hash>`_ 
       - | Hash, 32 Bytes - hash of the block where this log was in. null when its pending. null when its pending log. 
     * - | `blockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L668>`_
       - | `Quantity <#type-quantity>`_ 
       - | the block number where this log was in. null when its pending. null when its pending log. 
     * - | `data <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L672>`_
       - | `Data <#type-data>`_ 
       - | contains the non-indexed arguments of the log. 
     * - | `logIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L660>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the log index position in the block. null when its pending log. 
     * - | `removed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L658>`_
       - | ``boolean``
       - | true when the log was removed, due to a chain reorganization. false if its a valid log. 
     * - | `topics <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L674>`_
       - | `Data <#type-data>`_  []
       - | - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.) 
     * - | `transactionHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L664>`_
       - | `Hash <#type-hash>`_ 
       - | Hash, 32 Bytes - hash of the transactions this log was created from. null when its pending log. 
     * - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L662>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the transactions index position log was created from. null when its pending log. 

```


### Type LogFilter


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L677)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `address <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L683>`_
       - | `Address <#type-address>`_ 
       - | (optional) 20 Bytes - Contract address or a list of addresses from which logs should originate. 
     * - | `fromBlock <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L679>`_
       - | `BlockType <#type-blocktype>`_ 
       - | Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions. 
     * - | `limit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L687>`_
       - | `Quantity <#type-quantity>`_ 
       - | å(optional) The maximum number of entries to retrieve (latest first). 
     * - | `toBlock <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L681>`_
       - | `BlockType <#type-blocktype>`_ 
       - | Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions. 
     * - | `topics <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L685>`_
       - | ``string`` | ``string`` [] []
       - | (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching. 

```


### Type Signature


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L498)


Signature


```eval_rst
  .. list-table::
     :widths: auto

     * - | `message <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L499>`_
       - | `Data <#type-data>`_ 
       - | the message 
     * - | `messageHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L500>`_
       - | `Hash <#type-hash>`_ 
       - | the messageHash 
     * - | `r <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L502>`_
       - | `Hash <#type-hash>`_ 
       - | the r 
     * - | `s <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L503>`_
       - | `Hash <#type-hash>`_ 
       - | the s 
     * - | `signature <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L504>`_
       - | `Data <#type-data>`_ 
       - | the signature  *(optional)* 
     * - | `v <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L501>`_
       - | `Hex <#type-hex>`_ 
       - | the v 

```


### Type Transaction


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L523)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `chainId <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L539>`_
       - | ``any``
       - | optional chain id  *(optional)* 
     * - | `data <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L535>`_
       - | ``string``
       - | 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI. 
     * - | `from <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L525>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - The address the transaction is send from. 
     * - | `gas <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L529>`_
       - | `Quantity <#type-quantity>`_ 
       - | Integer of the gas provided for the transaction execution. eth_call consumes zero gas, but this parameter may be needed by some executions. 
     * - | `gasPrice <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L531>`_
       - | `Quantity <#type-quantity>`_ 
       - | Integer of the gas price used for each paid gas. 
     * - | `nonce <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L537>`_
       - | `Quantity <#type-quantity>`_ 
       - | nonce 
     * - | `to <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L527>`_
       - | `Address <#type-address>`_ 
       - | (optional when creating new contract) 20 Bytes - The address the transaction is directed to. 
     * - | `value <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L533>`_
       - | `Quantity <#type-quantity>`_ 
       - | Integer of the value sent with this transaction. 

```


### Type TransactionDetail


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L569)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `blockHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L575>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - hash of the block where this transaction was in. null when its pending. 
     * - | `blockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L577>`_
       - | `BlockType <#type-blocktype>`_ 
       - | block number where this transaction was in. null when its pending. 
     * - | `chainId <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L603>`_
       - | `Quantity <#type-quantity>`_ 
       - | the chain id of the transaction, if any. 
     * - | `condition <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L607>`_
       - | ``any``
       - | (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature) 
     * - | `creates <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L605>`_
       - | `Address <#type-address>`_ 
       - | creates contract address 
     * - | `from <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L581>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - address of the sender. 
     * - | `gas <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L589>`_
       - | `Quantity <#type-quantity>`_ 
       - | gas provided by the sender. 
     * - | `gasPrice <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L587>`_
       - | `Quantity <#type-quantity>`_ 
       - | gas price provided by the sender in Wei. 
     * - | `hash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L571>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - hash of the transaction. 
     * - | `input <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L591>`_
       - | `Data <#type-data>`_ 
       - | the data send along with the transaction. 
     * - | `nonce <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L573>`_
       - | `Quantity <#type-quantity>`_ 
       - | the number of transactions made by the sender prior to this one. 
     * - | `pk <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L609>`_
       - | ``any``
       - | optional: the private key to use for signing  *(optional)* 
     * - | `publicKey <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L601>`_
       - | `Hash <#type-hash>`_ 
       - | public key of the signer. 
     * - | `r <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L597>`_
       - | `Quantity <#type-quantity>`_ 
       - | the R field of the signature. 
     * - | `raw <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L599>`_
       - | `Data <#type-data>`_ 
       - | raw transaction data 
     * - | `standardV <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L595>`_
       - | `Quantity <#type-quantity>`_ 
       - | the standardised V field of the signature (0 or 1). 
     * - | `to <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L583>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - address of the receiver. null when its a contract creation transaction. 
     * - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L579>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the transactions index position in the block. null when its pending. 
     * - | `v <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L593>`_
       - | `Quantity <#type-quantity>`_ 
       - | the standardised V field of the signature. 
     * - | `value <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L585>`_
       - | `Quantity <#type-quantity>`_ 
       - | value transferred in Wei. 

```


### Type TransactionReceipt


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L541)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `blockHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L543>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - hash of the block where this transaction was in. 
     * - | `blockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L545>`_
       - | `BlockType <#type-blocktype>`_ 
       - | block number where this transaction was in. 
     * - | `contractAddress <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L547>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null. 
     * - | `cumulativeGasUsed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L549>`_
       - | `Quantity <#type-quantity>`_ 
       - | The total amount of gas used when this transaction was executed in the block. 
     * - | `from <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L551>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - The address of the sender. 
     * - | `gasUsed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L555>`_
       - | `Quantity <#type-quantity>`_ 
       - | The amount of gas used by this specific transaction alone. 
     * - | `logs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L557>`_
       - | `Log <#type-log>`_  []
       - | Array of log objects, which this transaction generated. 
     * - | `logsBloom <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L559>`_
       - | `Data <#type-data>`_ 
       - | 256 Bytes - A bloom filter of logs/events generated by contracts during transaction execution. Used to efficiently rule out transactions without expected logs. 
     * - | `root <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L561>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork EIP609) 
     * - | `status <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L563>`_
       - | `Quantity <#type-quantity>`_ 
       - | 0x0 indicates transaction failure , 0x1 indicates transaction success. Set for blocks mined after Byzantium hard fork EIP609, null before. 
     * - | `to <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L553>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - The address of the receiver. null when it’s a contract creation transaction. 
     * - | `transactionHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L565>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - hash of the transaction. 
     * - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L567>`_
       - | `Quantity <#type-quantity>`_ 
       - | Integer of the transactions index position in the block. 

```


### Type TxRequest


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L690)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `args <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L716>`_
       - | ``any`` []
       - | the argument to pass to the method  *(optional)* 
     * - | `confirmations <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L722>`_
       - | ``number``
       - | number of block to wait before confirming  *(optional)* 
     * - | `data <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L698>`_
       - | `Data <#type-data>`_ 
       - | the data to send  *(optional)* 
     * - | `from <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L695>`_
       - | `Address <#type-address>`_ 
       - | address of the account to use  *(optional)* 
     * - | `gas <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L701>`_
       - | ``number``
       - | the gas needed  *(optional)* 
     * - | `gasPrice <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L704>`_
       - | ``number``
       - | the gasPrice used  *(optional)* 
     * - | `method <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L713>`_
       - | ``string``
       - | the ABI of the method to be used  *(optional)* 
     * - | `nonce <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L707>`_
       - | ``number``
       - | the nonce  *(optional)* 
     * - | `pk <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L719>`_
       - | `Hash <#type-hash>`_ 
       - | raw private key in order to sign  *(optional)* 
     * - | `to <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L692>`_
       - | `Address <#type-address>`_ 
       - | contract  *(optional)* 
     * - | `value <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L710>`_
       - | `Quantity <#type-quantity>`_ 
       - | the value in wei  *(optional)* 

```


### Type Hex


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L477)


a Hexcoded String (starting with 0x)
 = `string`



### Type BlockType


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L473)


BlockNumber or predefined Block
 = `number` | `'latest'` | `'earliest'` | `'pending'`



### Type Quantity


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L481)


a BigInteger encoded as hex.
 = `number` | [Hex](#type-hex) 



