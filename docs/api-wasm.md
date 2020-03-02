# API Reference WASM

Even though the incubed client is written in C, we are using emscripten to build wasm. Together with some binding-code incubed runs in any Javascript-Runtime.
Using WASM gives us 3 important features:

1. Performance. 
   Since WASM runs at almost native speed it is very fast

2. Security
   Since the WASM-Module has no dependencies it reduces the risk of using a malicious dependency, which would be able to manipulate Prototypes.
   Also, since the real work is happening inside the wasm, trying to change Prototype would not work.

3. Size
   The current wasm-file is about 200kb. This is smaller then most other libraries and can easily be used in any app or website.


## Installing

This client uses the in3-core sources compiled to wasm. The wasm is included into the js-file wich makes it easier to include the data.
This module has **no** dependencies! All it needs is included inta a wasm of about 300kB.

Installing incubed is as easy as installing any other module:

```
npm install --save in3-wasm
```

### WASM-support

Even though most browsers and javascript enviroment such as nodejs, have full support for wasm, there are ocasions, where WASM is fully supported.
In case you want to run incubed within a react native app, you might face such issues. In this case you can use [in3-asmjs](https://www.npmjs.com/package/in3-asmjs), which has the same API, but runs on pure javascript (a bit slower and bigger, but full support everywhere).



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


### BufferType and BigIntType

The WASM-Module comes with no dependencies. This means per default it uses the standard classes provided as part of the EMCAScript-Standard.

If you work with a library which expects different types, you can change the generic-type and giving a converter:

#### Type BigIntType

Per default we use `bigint`. This is used whenever we work with number too big to be stored as a `number`-type.

If you want to change this type, use [setConverBigInt()](#setconvertbigint) function.

#### Type Buffer

Per default we use `UInt8Array`. This is used whenever we work with raw bytes.

If you want to change this type, use [setConverBuffer()](#setconvertbuffer) function.

#### Generics

```js
import {IN3Generic} from 'in3-wasm'
import BN from 'bn.js'

// create a new client by setting the Generic Types
const c = new IN3Generic<BN,Buffer>()

// set the converter-functions
IN3Generic.setConverBuffer(val => Buffer.from(val))
IN3Generic.setConverBigInt(val => new BN(val))

```



### Package

While the In3Client-class is also the default import, the following imports can be used:


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
       - | the configuration of the IN3-Client. This can be changed at any time.
         | All properties are optional and will be verified when sending the next request.
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


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L491)


default Incubed client with
bigint for big numbers
Uint8Array for bytes

```eval_rst
  .. list-table::
     :widths: auto

     * - | `default <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L483>`_
       - | `IN3Generic <#type-in3generic>`_ 
       - | supporting both ES6 and UMD usage 
     * - | `util <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L476>`_
       - | `Utils<any> <#type-utils>`_ 
       - | collection of util-functions. 
     * - | `config <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L384>`_
       - | `IN3Config <#type-in3config>`_ 
       - | IN3 config 
     * - | `eth <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L466>`_
       - | `EthAPI<bigint,Uint8Array> <#type-ethapi>`_ 
       - | eth1 API. 
     * - | `signer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L430>`_
       - | `Signer<bigint,Uint8Array> <#type-signer>`_ 
       - | the signer, if specified this interface will be used to sign transactions, if not, sending transaction will not be possible. 
     * - | `util <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L471>`_
       - | `Utils<Uint8Array> <#type-utils>`_ 
       - | collection of util-functions. 

```


#### freeAll()


frees all Incubed instances. 

```eval_rst
static ``void`` `freeAll <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L460>`_ ()
```



#### onInit()


registers a function to be called as soon as the wasm is ready.
If it is already initialized it will call it right away. 

```eval_rst
static `Promise<T> <#type-t>`_  `onInit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L454>`_ (
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


set convert big int 

```eval_rst
static ``any`` `setConvertBigInt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L500>`_ (
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


set convert buffer 

```eval_rst
static ``any`` `setConvertBuffer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L501>`_ (
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


changes the storage handler, which is called to read and write to the cache. 

```eval_rst
static ``void`` `setStorage <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L443>`_ (
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


changes the transport-function. 

```eval_rst
static ``void`` `setTransport <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L438>`_ (
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


creates a new client. 

```eval_rst
`IN3 <#type-in3>`_  `constructor <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L491>`_ (
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


returns a Object, which can be used as Web3Provider.

```
const web3 = new Web3(new IN3().createWeb3Provider())
```
 

```eval_rst
``any`` `createWeb3Provider <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L425>`_ ()
```

Returns: 
```eval_rst
``any``
```



#### free()


disposes the Client. This must be called in order to free allocated memory! 

```eval_rst
``any`` `free <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L416>`_ ()
```

Returns: 
```eval_rst
``any``
```



#### send()


sends a raw request.
if the request is a array the response will be a array as well.
If the callback is given it will be called with the response, if not a Promise will be returned.
This function supports callback so it can be used as a Provider for the web3. 

```eval_rst
`Promise<RPCResponse> <#type-rpcresponse>`_  `send <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L402>`_ (
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


sends a RPC-Requests specified by name and params.

if the response contains an error, this will be thrown. if not the result will be returned.
 

```eval_rst
``Promise<any>`` `sendRPC <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L411>`_ (
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


sets configuration properties. You can pass a partial object specifieing any of defined properties. 

```eval_rst
``void`` `setConfig <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L394>`_ (
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


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L380)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `default <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L483>`_
       - | `IN3Generic <#type-in3generic>`_ 
       - | supporting both ES6 and UMD usage 
     * - | `util <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L476>`_
       - | `Utils<any> <#type-utils>`_ 
       - | collection of util-functions. 
     * - | `config <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L384>`_
       - | `IN3Config <#type-in3config>`_ 
       - | IN3 config 
     * - | `eth <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L466>`_
       - | `EthAPI<BigIntType,BufferType> <#type-ethapi>`_ 
       - | eth1 API. 
     * - | `signer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L430>`_
       - | `Signer<BigIntType,BufferType> <#type-signer>`_ 
       - | the signer, if specified this interface will be used to sign transactions, if not, sending transaction will not be possible. 
     * - | `util <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L471>`_
       - | `Utils<BufferType> <#type-utils>`_ 
       - | collection of util-functions. 

```


#### freeAll()


frees all Incubed instances. 

```eval_rst
static ``void`` `freeAll <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L460>`_ ()
```



#### onInit()


registers a function to be called as soon as the wasm is ready.
If it is already initialized it will call it right away. 

```eval_rst
static `Promise<T> <#type-t>`_  `onInit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L454>`_ (
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


set convert big int 

```eval_rst
static ``any`` `setConvertBigInt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L478>`_ (
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


set convert buffer 

```eval_rst
static ``any`` `setConvertBuffer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L479>`_ (
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


changes the storage handler, which is called to read and write to the cache. 

```eval_rst
static ``void`` `setStorage <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L443>`_ (
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


changes the transport-function. 

```eval_rst
static ``void`` `setTransport <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L438>`_ (
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


creates a new client. 

```eval_rst
`IN3Generic <#type-in3generic>`_  `constructor <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L384>`_ (
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


returns a Object, which can be used as Web3Provider.

```
const web3 = new Web3(new IN3().createWeb3Provider())
```
 

```eval_rst
``any`` `createWeb3Provider <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L425>`_ ()
```

Returns: 
```eval_rst
``any``
```



#### free()


disposes the Client. This must be called in order to free allocated memory! 

```eval_rst
``any`` `free <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L416>`_ ()
```

Returns: 
```eval_rst
``any``
```



#### send()


sends a raw request.
if the request is a array the response will be a array as well.
If the callback is given it will be called with the response, if not a Promise will be returned.
This function supports callback so it can be used as a Provider for the web3. 

```eval_rst
`Promise<RPCResponse> <#type-rpcresponse>`_  `send <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L402>`_ (
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


sends a RPC-Requests specified by name and params.

if the response contains an error, this will be thrown. if not the result will be returned.
 

```eval_rst
``Promise<any>`` `sendRPC <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L411>`_ (
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


sets configuration properties. You can pass a partial object specifieing any of defined properties. 

```eval_rst
``void`` `setConfig <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L394>`_ (
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


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L988)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `accounts <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L989>`_
       - | 
       - | the accounts 

```


#### constructor()


constructor 

```eval_rst
`SimpleSigner <#type-simplesigner>`_  `constructor <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L991>`_ (
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


optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig. 

```eval_rst
`Promise<Transaction> <#type-transaction>`_  `prepareTransaction <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L995>`_ (
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


signing of any data.
if hashFirst is true the data should be hashed first, otherwise the data is the hash. 

```eval_rst
`Promise<BufferType> <#type-buffertype>`_  `sign <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1004>`_ (
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


add account 

```eval_rst
``string`` `addAccount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L993>`_ (
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


returns true if the account is supported (or unlocked) 

```eval_rst
``Promise<boolean>`` `hasAccount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L998>`_ (
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


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L774)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `client <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L775>`_
       - | `IN3Generic<BigIntType,BufferType> <#type-in3generic>`_ 
       - | the client 
     * - | `signer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L776>`_
       - | `Signer<BigIntType,BufferType> <#type-signer>`_ 
       - | the signer  *(optional)* 

```


#### blockNumber()


Returns the number of most recent block. (as number) 

```eval_rst
``Promise<number>`` `blockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L781>`_ ()
```

Returns: 
```eval_rst
``Promise<number>``
```



#### call()


Executes a new message call immediately without creating a transaction on the block chain. 

```eval_rst
``Promise<string>`` `call <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L789>`_ (
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


Executes a function of a contract, by passing a [method-signature](https://github.com/ethereumjs/ethereumjs-abi/blob/master/README.md#simple-encoding-and-decoding) and the arguments, which will then be ABI-encoded and send as eth_call. 

```eval_rst
``Promise<any>`` `callFn <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L793>`_ (
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


Returns the EIP155 chain ID used for transaction signing at the current best block. Null is returned if not available. 

```eval_rst
``Promise<string>`` `chainId <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L797>`_ ()
```

Returns: 
```eval_rst
``Promise<string>``
```



#### constructor()


constructor 

```eval_rst
``any`` `constructor <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L777>`_ (
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


contract at 

```eval_rst
 `contractAt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L945>`_ (
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


decode event data 

```eval_rst
``any`` `decodeEventData <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L985>`_ (
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


Makes a call or transaction, which won’t be added to the blockchain and returns the used gas, which can be used for estimating the used gas. 

```eval_rst
``Promise<number>`` `estimateGas <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L801>`_ (
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


Returns the current price per gas in wei. (as number) 

```eval_rst
``Promise<number>`` `gasPrice <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L785>`_ ()
```

Returns: 
```eval_rst
``Promise<number>``
```



#### getBalance()


Returns the balance of the account of given address in wei (as hex). 

```eval_rst
`Promise<BigIntType> <#type-biginttype>`_  `getBalance <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L805>`_ (
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


Returns information about a block by hash. 

```eval_rst
`Promise<Block> <#type-block>`_  `getBlockByHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L817>`_ (
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


Returns information about a block by block number. 

```eval_rst
`Promise<Block> <#type-block>`_  `getBlockByNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L821>`_ (
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


Returns the number of transactions in a block from a block matching the given block hash. 

```eval_rst
``Promise<number>`` `getBlockTransactionCountByHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L825>`_ (
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


Returns the number of transactions in a block from a block matching the given block number. 

```eval_rst
``Promise<number>`` `getBlockTransactionCountByNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L829>`_ (
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


Returns code at a given address. 

```eval_rst
``Promise<string>`` `getCode <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L809>`_ (
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


Polling method for a filter, which returns an array of logs which occurred since last poll. 

```eval_rst
``Promise<>`` `getFilterChanges <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L833>`_ (
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


Returns an array of all logs matching filter with given id. 

```eval_rst
``Promise<>`` `getFilterLogs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L837>`_ (
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


Returns an array of all logs matching a given filter object. 

```eval_rst
``Promise<>`` `getLogs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L841>`_ (
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


Returns the value from a storage position at a given address. 

```eval_rst
``Promise<string>`` `getStorageAt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L813>`_ (
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


Returns information about a transaction by block hash and transaction index position. 

```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_  `getTransactionByBlockHashAndIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L845>`_ (
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


Returns information about a transaction by block number and transaction index position. 

```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_  `getTransactionByBlockNumberAndIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L849>`_ (
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


Returns the information about a transaction requested by transaction hash. 

```eval_rst
`Promise<TransactionDetail> <#type-transactiondetail>`_  `getTransactionByHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L853>`_ (
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


Returns the number of transactions sent from an address. (as number) 

```eval_rst
``Promise<number>`` `getTransactionCount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L857>`_ (
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


Returns the receipt of a transaction by transaction hash.
Note That the receipt is available even for pending transactions. 

```eval_rst
`Promise<TransactionReceipt> <#type-transactionreceipt>`_  `getTransactionReceipt <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L862>`_ (
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


Returns information about a uncle of a block by hash and uncle index position.
Note: An uncle doesn’t contain individual transactions. 

```eval_rst
`Promise<Block> <#type-block>`_  `getUncleByBlockHashAndIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L867>`_ (
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


Returns information about a uncle of a block number and uncle index position.
Note: An uncle doesn’t contain individual transactions. 

```eval_rst
`Promise<Block> <#type-block>`_  `getUncleByBlockNumberAndIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L872>`_ (
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


Returns the number of uncles in a block from a block matching the given block hash. 

```eval_rst
``Promise<number>`` `getUncleCountByBlockHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L876>`_ (
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


Returns the number of uncles in a block from a block matching the given block hash. 

```eval_rst
``Promise<number>`` `getUncleCountByBlockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L880>`_ (
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


a Hexcoded String (starting with 0x) 

```eval_rst
`Hex <#type-hex>`_  `hashMessage <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L986>`_ (
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


Creates a filter in the node, to notify when a new block arrives. To check if the state has changed, call eth_getFilterChanges. 

```eval_rst
``Promise<string>`` `newBlockFilter <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L884>`_ ()
```

Returns: 
```eval_rst
``Promise<string>``
```



#### newFilter()


Creates a filter object, based on filter options, to notify when the state changes (logs). To check if the state has changed, call eth_getFilterChanges.

A note on specifying topic filters:
Topics are order-dependent. A transaction with a log with topics [A, B] will be matched by the following topic filters:

[] “anything”
[A] “A in first position (and anything after)”
[null, B] “anything in first position AND B in second position (and anything after)”
[A, B] “A in first position AND B in second position (and anything after)”
[[A, B], [A, B]] “(A OR B) in first position AND (A OR B) in second position (and anything after)”
 

```eval_rst
``Promise<string>`` `newFilter <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L897>`_ (
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


Creates a filter in the node, to notify when new pending transactions arrive.

To check if the state has changed, call eth_getFilterChanges.
 

```eval_rst
``Promise<string>`` `newPendingTransactionFilter <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L903>`_ ()
```

Returns: 
```eval_rst
``Promise<string>``
```



#### protocolVersion()


Returns the current ethereum protocol version. 

```eval_rst
``Promise<string>`` `protocolVersion <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L911>`_ ()
```

Returns: 
```eval_rst
``Promise<string>``
```



#### resolveENS()


resolves a name as an ENS-Domain. 

```eval_rst
`Promise<Address> <#type-address>`_  `resolveENS <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L930>`_ (
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


Creates new message call transaction or a contract creation for signed transactions. 

```eval_rst
``Promise<string>`` `sendRawTransaction <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L935>`_ (
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


sends a Transaction 

```eval_rst
``Promise<>`` `sendTransaction <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L943>`_ (
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


signs any kind of message using the `\x19Ethereum Signed Message:\n`-prefix 

```eval_rst
`Promise<BufferType> <#type-buffertype>`_  `sign <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L941>`_ (
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


Returns the current ethereum protocol version. 

```eval_rst
``Promise<>`` `syncing <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L915>`_ ()
```

Returns: 
```eval_rst
``Promise<>``
```



#### uninstallFilter()


Uninstalls a filter with given id. Should always be called when watch is no longer needed. Additonally Filters timeout when they aren’t requested with eth_getFilterChanges for a period of time. 

```eval_rst
`Promise<Quantity> <#type-quantity>`_  `uninstallFilter <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L907>`_ (
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


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L39)


the configuration of the IN3-Client. This can be changed at any time.
All properties are optional and will be verified when sending the next request.

```eval_rst
  .. list-table::
     :widths: auto

     * - | `autoUpdateList <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L45>`_
       - | ``boolean``
       - | if true the nodelist will be automaticly updated if the lastBlock is newer.
         | 
         | default: true
         |   *(optional)* 
     * - | `chainId <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L60>`_
       - | ``string``
       - | The chain-id based on EIP-155.
         | or the name of the supported chain.
         | 
         | Currently we support 'mainnet', 'goerli', 'kovan', 'ipfs' and 'local'
         | 
         | While most of the chains use preconfigured chain settings,
         | 'local' actually uses the local running client turning of proof.
         | 
         | example: '0x1' or 'mainnet' or 'goerli'
         | 
         | default: 'mainnet'
         |  
     * - | `chainRegistry <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L178>`_
       - | ``string``
       - | main chain-registry contract
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945  *(optional)* 
     * - | `finality <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L75>`_
       - | ``number``
       - | the number in percent needed in order reach finality if you run on a POA-Chain.
         | (% of signature of the validators)
         | 
         | default: 0
         |   *(optional)* 
     * - | `includeCode <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L84>`_
       - | ``boolean``
       - | if true, the request should include the codes of all accounts.
         | Otherwise only the the codeHash is returned.
         | In this case the client may ask by calling eth_getCode() afterwards
         | 
         | default: false
         |   *(optional)* 
     * - | `keepIn3 <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L102>`_
       - | ``boolean``
       - | if true, the in3-section of the response will be kept and returned.
         | Otherwise it will be removed after validating the data.
         | This is useful for debugging or if the proof should be used afterwards.
         | 
         | default: false
         |   *(optional)* 
     * - | `key <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L107>`_
       - | `Hash <#type-hash>`_ 
       - | the key to sign requests. This is required for payments.  *(optional)* 
     * - | `mainChain <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L183>`_
       - | ``string``
       - | main chain-id, where the chain registry is running.
         | example: 0x1  *(optional)* 
     * - | `maxAttempts <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L92>`_
       - | ``number``
       - | max number of attempts in case a response is rejected.
         | Incubed will retry to find a different node giving a verified response.
         | 
         | default: 5
         |   *(optional)* 
     * - | `maxCodeCache <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L128>`_
       - | ``number``
       - | number of max bytes used to cache the code in memory.
         | 
         | default: 0
         |   *(optional)* 
     * - | `minDeposit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L141>`_
       - | ``number``
       - | min stake of the server. Only nodes owning at least this amount will be chosen.
         | 
         | default: 0
         |  
     * - | `nodeLimit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L114>`_
       - | ``number``
       - | the limit of nodes to store in the client. If set a random seed will be picked, which is the base for a deterministic verifiable partial nodelist.
         | 
         | default: 0
         |   *(optional)* 
     * - | `nodeProps <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L146>`_
       - | ``number`` | `Hex <#type-hex>`_ 
       - | a bitmask-value combining the minimal properties as filter for the selected nodes. See https://in3.readthedocs.io/en/develop/spec.html#node-structure for details. 
     * - | `nodes <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L187>`_
       - | 
       - | the nodelists per chain. the chain_id will be used as key within the object.  *(optional)* 
     * - | `proof <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L153>`_
       - | ``'none'`` | ``'standard'`` | ``'full'``
       - | if true the nodes should send a proof of the response
         | 
         | default: 'standard'
         |   *(optional)* 
     * - | `replaceLatestBlock <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L160>`_
       - | ``number``
       - | if specified, the blocknumber *latest* will be replaced by blockNumber- specified value
         | 
         | default: 6
         |   *(optional)* 
     * - | `requestCount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L167>`_
       - | ``number``
       - | the number of request send when getting a first answer
         | 
         | default: 1
         |  
     * - | `rpc <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L172>`_
       - | ``string``
       - | url of a rpc-endpoints to use. If this is set proof will be turned off and it will be treated like local_chain.  *(optional)* 
     * - | `signatureCount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L67>`_
       - | ``number``
       - | number of signatures requested. The more signatures, the more security you get, but responses may take longer.
         | 
         | default: 0
         |   *(optional)* 
     * - | `stats <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L121>`_
       - | ``boolean``
       - | if false, the requests will not be included in the stats of the nodes ( or marked as intern ).
         | 
         | default: true
         |   *(optional)* 
     * - | `timeout <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L135>`_
       - | ``number``
       - | specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
         | 
         | default: 5000
         |   *(optional)* 

```


### Type IN3NodeConfig


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L245)


a configuration of a in3-server.

```eval_rst
  .. list-table::
     :widths: auto

     * - | `address <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L255>`_
       - | ``string``
       - | the address of the node, which is the public address it iis signing with.
         | example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679 
     * - | `capacity <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L280>`_
       - | ``number``
       - | the capacity of the node.
         | example: 100  *(optional)* 
     * - | `chainIds <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L270>`_
       - | ``string`` []
       - | the list of supported chains
         | example: 0x1 
     * - | `deposit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L275>`_
       - | ``number``
       - | the deposit of the node in wei
         | example: 12350000 
     * - | `index <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L250>`_
       - | ``number``
       - | the index within the contract
         | example: 13  *(optional)* 
     * - | `props <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L285>`_
       - | ``number``
       - | the properties of the node.
         | example: 3  *(optional)* 
     * - | `registerTime <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L290>`_
       - | ``number``
       - | the UNIX-timestamp when the node was registered
         | example: 1563279168  *(optional)* 
     * - | `timeout <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L260>`_
       - | ``number``
       - | the time (in seconds) until an owner is able to receive his deposit back after he unregisters himself
         | example: 3600  *(optional)* 
     * - | `unregisterTime <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L295>`_
       - | ``number``
       - | the UNIX-timestamp when the node is allowed to be deregister
         | example: 1563279168  *(optional)* 
     * - | `url <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L265>`_
       - | ``string``
       - | the endpoint to post to
         | example: https://in3.slock.it 

```


### Type IN3NodeWeight


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L300)


a local weight of a n3-node. (This is used internally to weight the requests)

```eval_rst
  .. list-table::
     :widths: auto

     * - | `avgResponseTime <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L315>`_
       - | ``number``
       - | average time of a response in ms
         | example: 240  *(optional)* 
     * - | `blacklistedUntil <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L329>`_
       - | ``number``
       - | blacklisted because of failed requests until the timestamp
         | example: 1529074639623  *(optional)* 
     * - | `lastRequest <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L324>`_
       - | ``number``
       - | timestamp of the last request in ms
         | example: 1529074632623  *(optional)* 
     * - | `pricePerRequest <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L319>`_
       - | ``number``
       - | last price  *(optional)* 
     * - | `responseCount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L310>`_
       - | ``number``
       - | number of uses.
         | example: 147  *(optional)* 
     * - | `weight <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L305>`_
       - | ``number``
       - | factor the weight this noe (default 1.0)
         | example: 0.5  *(optional)* 

```


### Type RPCRequest


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L335)


a JSONRPC-Request with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | `id <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L349>`_
       - | ``number`` | ``string``
       - | the identifier of the request
         | example: 2  *(optional)* 
     * - | `jsonrpc <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L339>`_
       - | ``'2.0'``
       - | the version 
     * - | `method <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L344>`_
       - | ``string``
       - | the method to call
         | example: eth_getBalance 
     * - | `params <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L354>`_
       - | ``any`` []
       - | the params
         | example: 0xe36179e2286ef405e929C90ad3E70E649B22a945,latest  *(optional)* 

```


### Type RPCResponse


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L359)


a JSONRPC-Responset with N3-Extension

```eval_rst
  .. list-table::
     :widths: auto

     * - | `error <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L372>`_
       - | ``string``
       - | in case of an error this needs to be set  *(optional)* 
     * - | `id <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L368>`_
       - | ``string`` | ``number``
       - | the id matching the request
         | example: 2 
     * - | `jsonrpc <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L363>`_
       - | ``'2.0'``
       - | the version 
     * - | `result <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L377>`_
       - | ``any``
       - | the params
         | example: 0xa35bc  *(optional)* 

```


### Type Signer


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L760)






#### prepareTransaction()


optiional method which allows to change the transaction-data before sending it. This can be used for redirecting it through a multisig. 

```eval_rst
`Promise<Transaction> <#type-transaction>`_  `prepareTransaction <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L762>`_ (
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


signing of any data.
if hashFirst is true the data should be hashed first, otherwise the data is the hash. 

```eval_rst
`Promise<BufferType> <#type-buffertype>`_  `sign <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L771>`_ (
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


returns true if the account is supported (or unlocked) 

```eval_rst
``Promise<boolean>`` `hasAccount <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L765>`_ (
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


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1010)


Collection of different util-functions.



#### abiDecode()


decodes the given data as ABI-encoded (without the methodHash) 

```eval_rst
``any`` [] `abiDecode <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1030>`_ (
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


encodes the given arguments as ABI-encoded (including the methodHash) 

```eval_rst
`Hex <#type-hex>`_  `abiEncode <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1023>`_ (
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


a Hexcoded String (starting with 0x) 

```eval_rst
`Hex <#type-hex>`_  `createSignatureHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1013>`_ (
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


decode event 

```eval_rst
``any`` `decodeEvent <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1015>`_ (
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


create a signature (65 bytes) for the given message and kexy 

```eval_rst
`BufferType <#type-buffertype>`_  `ecSign <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1085>`_ (
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


calculates the keccack hash for the given data. 

```eval_rst
`BufferType <#type-buffertype>`_  `keccak <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1044>`_ (
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


generates the public address from the private key. 

```eval_rst
`Address <#type-address>`_  `private2address <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1099>`_ (
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


solidity sha3 

```eval_rst
``string`` `soliditySha3 <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1016>`_ (
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


takes raw signature (65 bytes) and splits it into a signature object. 

```eval_rst
`Signature <#type-signature>`_  `splitSignature <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1093>`_ (
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


converts any value to a Buffer.
optionally the target length can be specified (in bytes) 

```eval_rst
`BufferType <#type-buffertype>`_  `toBuffer <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1065>`_ (
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


generates a checksum Address for the given address.
If the chainId is passed, it will be included accord to EIP 1191 

```eval_rst
`Address <#type-address>`_  `toChecksumAddress <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1038>`_ (
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


converts any value to a hex string (with prefix 0x).
optionally the target length can be specified (in bytes) 

```eval_rst
`Hex <#type-hex>`_  `toHex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1050>`_ (
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


removes all leading 0 in the hexstring 

```eval_rst
``string`` `toMinHex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1053>`_ (
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


converts any value to a hex string (with prefix 0x).
optionally the target length can be specified (in bytes) 

```eval_rst
``number`` `toNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1071>`_ (
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


converts any value to a Uint8Array.
optionally the target length can be specified (in bytes) 

```eval_rst
`BufferType <#type-buffertype>`_  `toUint8Array <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1059>`_ (
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


convert to String 

```eval_rst
``string`` `toUtf8 <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L1076>`_ (
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


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L547)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `anonymous <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L548>`_
       - | ``boolean``
       - | the anonymous  *(optional)* 
     * - | `constant <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L549>`_
       - | ``boolean``
       - | the constant  *(optional)* 
     * - | `inputs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L553>`_
       - | `ABIField <#type-abifield>`_  []
       - | the inputs  *(optional)* 
     * - | `name <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L555>`_
       - | ``string``
       - | the name  *(optional)* 
     * - | `outputs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L554>`_
       - | `ABIField <#type-abifield>`_  []
       - | the outputs  *(optional)* 
     * - | `payable <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L550>`_
       - | ``boolean``
       - | the payable  *(optional)* 
     * - | `stateMutability <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L551>`_
       - | ``'nonpayable'`` 
         | | ``'payable'`` 
         | | ``'view'`` 
         | | ``'pure'``
       - | the stateMutability  *(optional)* 
     * - | `type <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L556>`_
       - | ``'event'`` 
         | | ``'function'`` 
         | | ``'constructor'`` 
         | | ``'fallback'``
       - | the type 

```


### Type ABIField


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L542)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `indexed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L543>`_
       - | ``boolean``
       - | the indexed  *(optional)* 
     * - | `name <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L544>`_
       - | ``string``
       - | the name 
     * - | `type <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L545>`_
       - | ``string``
       - | the type 

```


### Type Address


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L524)


a 20 byte Address encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Block


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L647)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `author <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L667>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - the address of the author of the block (the beneficiary to whom the mining rewards were given) 
     * - | `difficulty <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L671>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the difficulty for this block 
     * - | `extraData <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L675>`_
       - | `Data <#type-data>`_ 
       - | the ‘extra data’ field of this block 
     * - | `gasLimit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L679>`_
       - | `Quantity <#type-quantity>`_ 
       - | the maximum gas allowed in this block 
     * - | `gasUsed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L681>`_
       - | `Quantity <#type-quantity>`_ 
       - | the total used gas by all transactions in this block 
     * - | `hash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L651>`_
       - | `Hash <#type-hash>`_ 
       - | hash of the block. null when its pending block 
     * - | `logsBloom <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L659>`_
       - | `Data <#type-data>`_ 
       - | 256 Bytes - the bloom filter for the logs of the block. null when its pending block 
     * - | `miner <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L669>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - alias of ‘author’ 
     * - | `nonce <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L655>`_
       - | `Data <#type-data>`_ 
       - | 8 bytes hash of the generated proof-of-work. null when its pending block. Missing in case of PoA. 
     * - | `number <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L649>`_
       - | `Quantity <#type-quantity>`_ 
       - | The block number. null when its pending block 
     * - | `parentHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L653>`_
       - | `Hash <#type-hash>`_ 
       - | hash of the parent block 
     * - | `receiptsRoot <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L665>`_
       - | `Data <#type-data>`_ 
       - | 32 Bytes - the root of the receipts trie of the block 
     * - | `sealFields <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L689>`_
       - | `Data <#type-data>`_  []
       - | PoA-Fields 
     * - | `sha3Uncles <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L657>`_
       - | `Data <#type-data>`_ 
       - | SHA3 of the uncles data in the block 
     * - | `size <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L677>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer the size of this block in bytes 
     * - | `stateRoot <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L663>`_
       - | `Data <#type-data>`_ 
       - | 32 Bytes - the root of the final state trie of the block 
     * - | `timestamp <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L683>`_
       - | `Quantity <#type-quantity>`_ 
       - | the unix timestamp for when the block was collated 
     * - | `totalDifficulty <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L673>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the total difficulty of the chain until this block 
     * - | `transactions <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L685>`_
       - | ``string`` |  []
       - | Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter 
     * - | `transactionsRoot <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L661>`_
       - | `Data <#type-data>`_ 
       - | 32 Bytes - the root of the transaction trie of the block 
     * - | `uncles <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L687>`_
       - | `Hash <#type-hash>`_  []
       - | Array of uncle hashes 

```


### Type Data


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L528)


data encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Hash


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L520)


a 32 byte Hash encoded as Hex (starting with 0x)
a Hexcoded String (starting with 0x)
 = `string`



### Type Log


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L691)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `address <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L705>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - address from which this log originated. 
     * - | `blockHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L701>`_
       - | `Hash <#type-hash>`_ 
       - | Hash, 32 Bytes - hash of the block where this log was in. null when its pending. null when its pending log. 
     * - | `blockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L703>`_
       - | `Quantity <#type-quantity>`_ 
       - | the block number where this log was in. null when its pending. null when its pending log. 
     * - | `data <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L707>`_
       - | `Data <#type-data>`_ 
       - | contains the non-indexed arguments of the log. 
     * - | `logIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L695>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the log index position in the block. null when its pending log. 
     * - | `removed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L693>`_
       - | ``boolean``
       - | true when the log was removed, due to a chain reorganization. false if its a valid log. 
     * - | `topics <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L709>`_
       - | `Data <#type-data>`_  []
       - | - Array of 0 to 4 32 Bytes DATA of indexed log arguments. (In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.) 
     * - | `transactionHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L699>`_
       - | `Hash <#type-hash>`_ 
       - | Hash, 32 Bytes - hash of the transactions this log was created from. null when its pending log. 
     * - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L697>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the transactions index position log was created from. null when its pending log. 

```


### Type LogFilter


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L712)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `address <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L718>`_
       - | `Address <#type-address>`_ 
       - | (optional) 20 Bytes - Contract address or a list of addresses from which logs should originate. 
     * - | `fromBlock <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L714>`_
       - | `BlockType <#type-blocktype>`_ 
       - | Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions. 
     * - | `limit <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L722>`_
       - | `Quantity <#type-quantity>`_ 
       - | å(optional) The maximum number of entries to retrieve (latest first). 
     * - | `toBlock <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L716>`_
       - | `BlockType <#type-blocktype>`_ 
       - | Quantity or Tag - (optional) (default: latest) Integer block number, or 'latest' for the last mined block or 'pending', 'earliest' for not yet mined transactions. 
     * - | `topics <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L720>`_
       - | ``string`` | ``string`` [] []
       - | (optional) Array of 32 Bytes Data topics. Topics are order-dependent. It’s possible to pass in null to match any topic, or a subarray of multiple topics of which one should be matching. 

```


### Type Signature


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L533)


Signature


```eval_rst
  .. list-table::
     :widths: auto

     * - | `message <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L534>`_
       - | `Data <#type-data>`_ 
       - | the message 
     * - | `messageHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L535>`_
       - | `Hash <#type-hash>`_ 
       - | the messageHash 
     * - | `r <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L537>`_
       - | `Hash <#type-hash>`_ 
       - | the r 
     * - | `s <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L538>`_
       - | `Hash <#type-hash>`_ 
       - | the s 
     * - | `signature <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L539>`_
       - | `Data <#type-data>`_ 
       - | the signature  *(optional)* 
     * - | `v <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L536>`_
       - | `Hex <#type-hex>`_ 
       - | the v 

```


### Type Transaction


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L558)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `chainId <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L574>`_
       - | ``any``
       - | optional chain id  *(optional)* 
     * - | `data <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L570>`_
       - | ``string``
       - | 4 byte hash of the method signature followed by encoded parameters. For details see Ethereum Contract ABI. 
     * - | `from <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L560>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - The address the transaction is send from. 
     * - | `gas <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L564>`_
       - | `Quantity <#type-quantity>`_ 
       - | Integer of the gas provided for the transaction execution. eth_call consumes zero gas, but this parameter may be needed by some executions. 
     * - | `gasPrice <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L566>`_
       - | `Quantity <#type-quantity>`_ 
       - | Integer of the gas price used for each paid gas. 
     * - | `nonce <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L572>`_
       - | `Quantity <#type-quantity>`_ 
       - | nonce 
     * - | `to <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L562>`_
       - | `Address <#type-address>`_ 
       - | (optional when creating new contract) 20 Bytes - The address the transaction is directed to. 
     * - | `value <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L568>`_
       - | `Quantity <#type-quantity>`_ 
       - | Integer of the value sent with this transaction. 

```


### Type TransactionDetail


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L604)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `blockHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L610>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - hash of the block where this transaction was in. null when its pending. 
     * - | `blockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L612>`_
       - | `BlockType <#type-blocktype>`_ 
       - | block number where this transaction was in. null when its pending. 
     * - | `chainId <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L638>`_
       - | `Quantity <#type-quantity>`_ 
       - | the chain id of the transaction, if any. 
     * - | `condition <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L642>`_
       - | ``any``
       - | (optional) conditional submission, Block number in block or timestamp in time or null. (parity-feature) 
     * - | `creates <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L640>`_
       - | `Address <#type-address>`_ 
       - | creates contract address 
     * - | `from <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L616>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - address of the sender. 
     * - | `gas <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L624>`_
       - | `Quantity <#type-quantity>`_ 
       - | gas provided by the sender. 
     * - | `gasPrice <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L622>`_
       - | `Quantity <#type-quantity>`_ 
       - | gas price provided by the sender in Wei. 
     * - | `hash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L606>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - hash of the transaction. 
     * - | `input <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L626>`_
       - | `Data <#type-data>`_ 
       - | the data send along with the transaction. 
     * - | `nonce <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L608>`_
       - | `Quantity <#type-quantity>`_ 
       - | the number of transactions made by the sender prior to this one. 
     * - | `pk <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L644>`_
       - | ``any``
       - | optional: the private key to use for signing  *(optional)* 
     * - | `publicKey <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L636>`_
       - | `Hash <#type-hash>`_ 
       - | public key of the signer. 
     * - | `r <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L632>`_
       - | `Quantity <#type-quantity>`_ 
       - | the R field of the signature. 
     * - | `raw <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L634>`_
       - | `Data <#type-data>`_ 
       - | raw transaction data 
     * - | `standardV <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L630>`_
       - | `Quantity <#type-quantity>`_ 
       - | the standardised V field of the signature (0 or 1). 
     * - | `to <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L618>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - address of the receiver. null when its a contract creation transaction. 
     * - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L614>`_
       - | `Quantity <#type-quantity>`_ 
       - | integer of the transactions index position in the block. null when its pending. 
     * - | `v <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L628>`_
       - | `Quantity <#type-quantity>`_ 
       - | the standardised V field of the signature. 
     * - | `value <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L620>`_
       - | `Quantity <#type-quantity>`_ 
       - | value transferred in Wei. 

```


### Type TransactionReceipt


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L576)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `blockHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L578>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - hash of the block where this transaction was in. 
     * - | `blockNumber <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L580>`_
       - | `BlockType <#type-blocktype>`_ 
       - | block number where this transaction was in. 
     * - | `contractAddress <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L582>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise null. 
     * - | `cumulativeGasUsed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L584>`_
       - | `Quantity <#type-quantity>`_ 
       - | The total amount of gas used when this transaction was executed in the block. 
     * - | `from <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L586>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - The address of the sender. 
     * - | `gasUsed <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L590>`_
       - | `Quantity <#type-quantity>`_ 
       - | The amount of gas used by this specific transaction alone. 
     * - | `logs <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L592>`_
       - | `Log <#type-log>`_  []
       - | Array of log objects, which this transaction generated. 
     * - | `logsBloom <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L594>`_
       - | `Data <#type-data>`_ 
       - | 256 Bytes - A bloom filter of logs/events generated by contracts during transaction execution. Used to efficiently rule out transactions without expected logs. 
     * - | `root <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L596>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork EIP609) 
     * - | `status <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L598>`_
       - | `Quantity <#type-quantity>`_ 
       - | 0x0 indicates transaction failure , 0x1 indicates transaction success. Set for blocks mined after Byzantium hard fork EIP609, null before. 
     * - | `to <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L588>`_
       - | `Address <#type-address>`_ 
       - | 20 Bytes - The address of the receiver. null when it’s a contract creation transaction. 
     * - | `transactionHash <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L600>`_
       - | `Hash <#type-hash>`_ 
       - | 32 Bytes - hash of the transaction. 
     * - | `transactionIndex <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L602>`_
       - | `Quantity <#type-quantity>`_ 
       - | Integer of the transactions index position in the block. 

```


### Type TxRequest


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L725)




```eval_rst
  .. list-table::
     :widths: auto

     * - | `args <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L751>`_
       - | ``any`` []
       - | the argument to pass to the method  *(optional)* 
     * - | `confirmations <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L757>`_
       - | ``number``
       - | number of block to wait before confirming  *(optional)* 
     * - | `data <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L733>`_
       - | `Data <#type-data>`_ 
       - | the data to send  *(optional)* 
     * - | `from <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L730>`_
       - | `Address <#type-address>`_ 
       - | address of the account to use  *(optional)* 
     * - | `gas <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L736>`_
       - | ``number``
       - | the gas needed  *(optional)* 
     * - | `gasPrice <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L739>`_
       - | ``number``
       - | the gasPrice used  *(optional)* 
     * - | `method <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L748>`_
       - | ``string``
       - | the ABI of the method to be used  *(optional)* 
     * - | `nonce <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L742>`_
       - | ``number``
       - | the nonce  *(optional)* 
     * - | `pk <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L754>`_
       - | `Hash <#type-hash>`_ 
       - | raw private key in order to sign  *(optional)* 
     * - | `to <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L727>`_
       - | `Address <#type-address>`_ 
       - | contract  *(optional)* 
     * - | `value <https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L745>`_
       - | `Quantity <#type-quantity>`_ 
       - | the value in wei  *(optional)* 

```


### Type Hex


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L512)


a Hexcoded String (starting with 0x)
 = `string`



### Type BlockType


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L508)


BlockNumber or predefined Block
 = `number` | `'latest'` | `'earliest'` | `'pending'`



### Type Quantity


Source: [in3.d.ts](https://github.com/slockit/in3-c/blob/master/wasm/src/in3.d.ts#L516)


a BigInteger encoded as hex.
 = `number` | [Hex](#type-hex) 



