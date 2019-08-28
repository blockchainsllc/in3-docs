# Getting Started 

Incubed can be used in different ways:

```eval_rst

+-----------------------+----------------------+-------------------------------------+---------------------------------------------------------------------------------------------+
| Stack                 | Size                 | Code Base                           | Use Case                                                                                    |
+=======================+======================+=====================================+=============================================================================================+
| TS/JS                 | 2.7 MB (browserified)| TypeScript                          | Web application (client in the browser) or mobile application                               |
+-----------------------+----------------------+-------------------------------------+---------------------------------------------------------------------------------------------+
| TS/JS/WASM            | 470 kB               | C - (WASM)                          | Web application (client in the browser) or mobile application                               |
+-----------------------+----------------------+-------------------------------------+---------------------------------------------------------------------------------------------+
| C/C++                 | 200 KB               | C                                   | IoT devices can be integrated nicely on many micro controllers                              |
|                       |                      |                                     | (like Zephyr-supported boards (https://docs.zephyrproject.org/latest/boards/index.html))    |
|                       |                      |                                     | or any other C/C++ application                                                              |
+-----------------------+----------------------+-------------------------------------+---------------------------------------------------------------------------------------------+
| Java                  | 705 KB               | C                                   | Java implementation of a native wrapper                                                     |
+-----------------------+----------------------+-------------------------------------+---------------------------------------------------------------------------------------------+
| Docker                | 2.6 MB               | C                                   | For replacing existing clients with this docker and connecting to Incubed via localhost:8545|
|                       |                      |                                     | without needing to change the architecture                                                  |
+-----------------------+----------------------+-------------------------------------+---------------------------------------------------------------------------------------------+
| Bash                  | 400 KB               | C                                   | The command-line utilities can be used directly as executable within Bash script or on the shell |
+-----------------------+----------------------+-------------------------------------+---------------------------------------------------------------------------------------------+
```

Other languages will be supported soon (or simply use the shared library directly).

## TypeScript/JavaScript

Installing Incubed is as easy as installing any other module:

```
npm install --save in3
```

### As Provider in Web3

The Incubed client also implements the provider interface used in the Web3 library and can be used directly.

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

### Direct API

Incubed includes a light API, allowing the ability to not only use all RPC methods in a type-safe way but also sign transactions and call functions of a contract without the Web3 library.

For more details, see the [API doc](https://github.com/slockit/in3/blob/master/docs/api.md#type-api).

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

// use the API to call a function..
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

## As Docker Container

To start Incubed as a standalone client (allowing other non-JS applications to connect to it), you can start the container as the following:

```
docker run -d -p 8545:8545  slockit/in3:latest -port 8545
```


## C Implementation

*The C implementation will be released soon!*

```c
#include <in3/client.h>    // the core client
#include <in3/eth_api.h>   // wrapper for easier use
#include <in3/eth_basic.h> // use the basic module
#include <in3/in3_curl.h>  // transport implementation

#include <inttypes.h>
#include <stdio.h>

int main(int argc, char* argv[]) {

  // register a chain-verifier for basic Ethereum-Support, which is enough to verify blocks
  // this needs to be called only once
  in3_register_eth_basic();

  // use curl as the default for sending out requests
  // this needs to be called only once.
  in3_register_curl();

  // create new incubed client
  in3_t* in3 = in3_new();

  // the b lock we want to get
  uint64_t block_number = 8432424;

  // get the latest block without the transaction details
  eth_block_t* block = eth_getBlockByNumber(in3, block_number, false);

  // if the result is null there was an error an we can get the latest error message from eth_lat_error()
  if (!block)
    printf("error getting the block : %s\n", eth_last_error());
  else {
    printf("Number of transactions in Block #%llu: %d\n", block->number, block->tx_count);
    free(block);
  }

  // cleanup client after usage
  in3_free(in3);
}


```

More details coming soon...

## Java

The Java implementation uses a wrapper of the C implemenation. This is why you need to make sure the libin3.so, in3.dll, or libin3.dylib can be found in the java.library.path. For example:

```
java -cp in3.jar:. HelloIN3.class
```

```java
import java.util.*;
import in3.*;
import in3.eth1.*;
import java.math.BigInteger;

public class HelloIN3 {
  //
  public static void main(String[] args) throws Exception {
    // create incubed
    IN3 in3 = new IN3();

    // configure
    in3.setChainId(0x1); // set it to mainnet (which is also dthe default)

    // read the latest Block including all Transactions.
    Block latestBlock = in3.getEth1API().getBlockByNumber(Block.LATEST, true);

    // Use the getters to retrieve all containing data
    System.out.println("current BlockNumber : " + latestBlock.getNumber());
    System.out.println("minded at : " + new Date(latestBlock.getTimeStamp()) + " by " + latestBlock.getAuthor());

    // get all Transaction of the Block
    Transaction[] transactions = latestBlock.getTransactions();

    BigInteger sum = BigInteger.valueOf(0);
    for (int i = 0; i < transactions.length; i++)
      sum = sum.add(transactions[i].getValue());

    System.out.println("total Value transfered in all Transactions : " + sum + " wei");
  }

}
```

## Command-line Tool

Based on the C implementation, a command-line utility is built, which executes a JSON-RPC request and only delivers the result. This can be used within Bash scripts:

```
CURRENT_BLOCK = `in3 -c kovan eth_blockNumber`

#or to send a transaction

in3 -pk my_key_file.json send -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1 -value 0.2eth

in3 -pk my_key_file.json send -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1 -gas 1000000  "registerServer(string,uint256)" "https://in3.slock.it/kovan1" 0xFF

```

## Supported Chains

Currently, Incubed is deployed on the following chains:

### Mainnet

Registry: [0x2736D225f85740f42D17987100dc8d58e9e16252](https://eth.slock.it/#/main/0x2736D225f85740f42D17987100dc8d58e9e16252)    

ChainId: 0x1 (alias `mainnet`)        

Status: [https://in3.slock.it?n=mainnet](https://in3.slock.it?n=mainnet)    

NodeList: [https://in3.slock.it/mainnet/nd-3](https://in3.slock.it/mainnet/nd-3/api/in3_nodeList) 

### Kovan

Registry: [0x27a37a1210df14f7e058393d026e2fb53b7cf8c1](https://eth.slock.it/#/kovan/0x27a37a1210df14f7e058393d026e2fb53b7cf8c1)    

ChainId: 0x2a (alias `kovan`)    

Status: [https://in3.slock.it?n=kovan](https://in3.slock.it?n=kovan)    

NodeList: [https://in3.slock.it/kovan/nd-3](https://in3.slock.it/kovan/nd-3/api/in3_nodeList) 

### Tobalaba

Registry: [0x845E484b505443814B992Bf0319A5e8F5e407879](https://eth.slock.it/#/tobalaba/0x845E484b505443814B992Bf0319A5e8F5e407879)    

ChainId: 0x44d (alias `tobalaba`)    

Status: [https://in3.slock.it?n=tobalaba](https://in3.slock.it?n=tobalaba)    

NodeList: [https://in3.slock.it/tobalaba/nd-3](https://in3.slock.it/tobalaba/nd-3/api/in3_nodeList) 


### Evan

Registry: [0x85613723dB1Bc29f332A37EeF10b61F8a4225c7e](https://eth.slock.it/#/evan/0x85613723dB1Bc29f332A37EeF10b61F8a4225c7e)    

ChainId: 0x4b1 (alias `evan`)    

Status: [https://in3.slock.it?n=evan](https://in3.slock.it?n=evan)    

NodeList: [https://in3.slock.it/evan/nd-3](https://in3.slock.it/evan/nd-3/api/in3_nodeList) 

### Görli

Registry: [0x85613723dB1Bc29f332A37EeF10b61F8a4225c7e](https://eth.slock.it/#/goerli/0x85613723dB1Bc29f332A37EeF10b61F8a4225c7e)    

ChainId: 0x5 (alias `goerli`)    

Status: [https://in3.slock.it?n=goerli](https://in3.slock.it?n=goerli)    

NodeList: [https://in3.slock.it/goerli/nd-3](https://in3.slock.it/goerli/nd-3/api/in3_nodeList) 

### IPFS

Registry: [0xf0fb87f4757c77ea3416afe87f36acaa0496c7e9](https://eth.slock.it/#/kovan/0xf0fb87f4757c77ea3416afe87f36acaa0496c7e9)    

ChainId: 0x7d0 (alias `ipfs`)    

Status: [https://in3.slock.it?n=ipfs](https://in3.slock.it?n=ipfs)    

NodeList: [https://in3.slock.it/ipfs/nd-3](https://in3.slock.it/ipfs/nd-3/api/in3_nodeList) 

## Registering an Incubed Node

If you want to participate in this network and also register a node, you need to send a transaction to the registry contract, calling `registerServer(string _url, uint _props)`.

ABI of the registry:

```js
[{"constant":true,"inputs":[],"name":"totalServers","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_serverIndex","type":"uint256"},{"name":"_props","type":"uint256"}],"name":"updateServer","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":false,"inputs":[{"name":"_url","type":"string"},{"name":"_props","type":"uint256"}],"name":"registerServer","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"servers","outputs":[{"name":"url","type":"string"},{"name":"owner","type":"address"},{"name":"deposit","type":"uint256"},{"name":"props","type":"uint256"},{"name":"unregisterTime","type":"uint128"},{"name":"unregisterDeposit","type":"uint128"},{"name":"unregisterCaller","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_serverIndex","type":"uint256"}],"name":"cancelUnregisteringServer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_serverIndex","type":"uint256"},{"name":"_blockhash","type":"bytes32"},{"name":"_blocknumber","type":"uint256"},{"name":"_v","type":"uint8"},{"name":"_r","type":"bytes32"},{"name":"_s","type":"bytes32"}],"name":"convict","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_serverIndex","type":"uint256"}],"name":"calcUnregisterDeposit","outputs":[{"name":"","type":"uint128"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_serverIndex","type":"uint256"}],"name":"confirmUnregisteringServer","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_serverIndex","type":"uint256"}],"name":"requestUnregisteringServer","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"name":"url","type":"string"},{"indexed":false,"name":"props","type":"uint256"},{"indexed":false,"name":"owner","type":"address"},{"indexed":false,"name":"deposit","type":"uint256"}],"name":"LogServerRegistered","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"url","type":"string"},{"indexed":false,"name":"owner","type":"address"},{"indexed":false,"name":"caller","type":"address"}],"name":"LogServerUnregisterRequested","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"url","type":"string"},{"indexed":false,"name":"owner","type":"address"}],"name":"LogServerUnregisterCanceled","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"url","type":"string"},{"indexed":false,"name":"owner","type":"address"}],"name":"LogServerConvicted","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"name":"url","type":"string"},{"indexed":false,"name":"owner","type":"address"}],"name":"LogServerRemoved","type":"event"}]
```

To run an Incubed node, you simply use docker-compose:

```yaml
version: '2'
services:
  incubed-server:
    image: slockit/in3-server:latest
    volumes:
    - $PWD/keys:/secure                                     # directory where the private key is stored
    ports:
    - 8500:8500/tcp                                         # open the port 8500 to be accessed by the public
    command:
    - --privateKey=/secure/myKey.json                       # internal path to the key
    - --privateKeyPassphrase=dummy                          # passphrase to unlock the key
    - --chain=0x1                                           # chain (Kovan)
    - --rpcUrl=http://incubed-parity:8545                   # URL of the Kovan client
    - --registry=0xFdb0eA8AB08212A1fFfDB35aFacf37C3857083ca # URL of the Incubed registry
    - --autoRegistry-url=http://in3.server:8500             # check or register this node for this URL
    - --autoRegistry-deposit=2                              # deposit to use when registering

  incubed-parity:
    image: slockit/parity-in3:v2.2                          # parity-image with the getProof-function implemented
    command:
    - --auto-update=none                                    # do not automatically update the client
    - --pruning=archive 
    - --pruning-memory=30000                                # limit storage
```
