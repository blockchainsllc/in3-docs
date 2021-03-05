# Getting Started 

Incubed can be used in different ways:

```eval_rst

+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
| Stack                 | Size                 | Use Case                                                                                    |
+=======================+======================+=============================================================================================+
| TS/JS/WASM            | 486 kB               | JS client based on WASM or asm.js for Web, nodejs or mobile application                     |
+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
| C/C++                 | 128 KB (minimal)     | IoT devices can be integrated nicely on many micro controllers                              |
|                       |                      | (like Zephyr-supported boards (https://docs.zephyrproject.org/latest/boards/index.html))    |
|                       |                      | or any other C/C++ application                                                              |
+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
| Rust                  | 2.6MB                | Rust crates based on bindgen                                                                |
+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
| Java                  | 705 KB               | Java implementation of a JNI wrapper for native android or other java applications          |
+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
| Python                | 4MB                  | Multi PLatform Python Bindings wrapping native incubed core                                 |
+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
| .NET                  | 705 KB               | .NET implementation of a native wrapper for all supported platforms                         |
+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
| Docker                | 40 MB                | For replacing existing clients with this docker and connecting to Incubed via localhost:8545|
|                       |                      | without needing to change the architecture                                                  |
+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
| CMD                   | 400 KB               | The command-line tool can be used directly as executable within Bash script or on the shell |
|                       |                      | it can execute all methods eiterh as argument or from stdin                                 |
+-----------------------+----------------------+---------------------------------------------------------------------------------------------+
```

Other languages will be supported soon (or simply use the shared library directly).

## Command-line Tool

Based on the C implementation, we build a powerful command-line utility, which executes a JSON-RPC request and only delivers the result. This can be used within Bash scripts:

```sh
#
CURRENT_BLOCK = `in3 eth_blockNumber`

# or to send a transaction
in3 -pk my_key_file.json send -to mycontract.ens -value 0.2eth

# or call a function in a contract
DAO_PROPOSALS=`in3 call -to 0xbb9bc244d798123fde783fcc1c72d3bb8c189413 "numberOfProposals():uint"`

# or compile - deploy - and use the address in one line
DEPLOYED_ADDRESS=`solc --bin ServerRegistry.sol | in3 -gas 5000000 -pk my_private_key.json -d - -w send | jq -r .contractAddress`

```

More details and examples See [CMD](api-cmd.html)
## TypeScript/JavaScript

Installing Incubed is as easy as installing any other module:

```
npm install --save in3
```

### As Provider in Web3

The Incubed client also implements the provider interface used in the Web3 library and can be used directly without the need to refactor or change the code of your application.

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

Incubed includes a API, allowing the ability to not only use all RPC methods in a type-safe way but also sign transactions and call functions of a contract without the Web3 library.

For more details, see the [API doc](api-wasm.html#type-ethapi).

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

More details See [API TS/JS](api-wasm.html)

## As Docker Container

To start Incubed as a standalone client (allowing other non-JS applications to connect to it), you can start the container as the following:

```
docker run -d -p 8545:8545  slockit/in3:latest -port 8545
```


## C Implementation

For embedded Devices or other C/C++ Application using the C-Code directly is the best option. It also gives you the flexibility to only include what you need by using CMake-Flags to configure the included features.

```c
#include <in3/in3_init.h>  // the core client file with all the plugins activated
#include <in3/eth_api.h>   // wrapper for easier use

#include <inttypes.h>
#include <stdio.h>

int main(int argc, char* argv[]) {

  // create new incubed client
  in3_t* in3 = in3_for_chain(CHAIN_ID_MAINNET);

  // the b lock we want to get
  uint64_t block_number = 8432424;

  // get the specified block without the transaction details
  eth_block_t* block = eth_getBlockByNumber(in3, block_number, false);

  // if the result is null there was an error an we can get the latest error message from eth_last_error()
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


More details See [API C](api-c.html)

## Java

The Java implementation uses a wrapper of the C implemenation. The deployed jar-file includes all the binaries for all platforms and is all you need.

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

More details See [API Java](api-java.html)

## Python

Python works nice with native code written in C, so we build the python in a way to make it feel natural for python developers:

```sh
pip install in3
```

And use incubed in your code:

```python
import in3

in3_client = in3.Client()
# Sends a request to the Incubed Network, that in turn will collect proofs from the Ethereum client,
# attest and sign the response, then send back to the client, that will verify signatures and proofs.
block_number = in3_client.eth.block_number()
print(block_number) # Mainnet's block number
```

More details See [API Python](api-python.html)

## DotNet

The .NET implementation is registered on nuget and ships with binaries for all supported platforms. Just install

```sh
dotnet add package Blockchains.In3
```

And use incubed in your code:

```cs
using System;
using System.Threading;
using System.Threading.Tasks;
using In3;
using In3.Crypto;
using In3.Eth1;

namespace SendTransaction
{
    public class Program
    {
        static async Task Main()
        {
            // create a client on a testnet
            IN3 goerliClient = IN3.ForChain(Chain.Goerli);

            string myPrivateKey = "0x0829B3C639A3A8F2226C8057F100128D4F7AE8102C92048BA6DE38CF4D3BC6F1";
            string receivingAddress = "0x6FA33809667A99A805b610C49EE2042863b1bb83";

            // Get the wallet, which is the default signer.
            SimpleWallet myAccountWallet = (SimpleWallet)goerliClient.Signer;

            // add your account to the wallet
            string myAccount = myAccountWallet.AddRawKey(myPrivateKey);

            // Create the transaction request
            TransactionRequest tx = new TransactionRequest();
            tx.To = receivingAddress;
            tx.From = myAccount;
            tx.Value = 300;

            // and send it
            string transactionHash = await goerliClient.Eth1.SendTransaction(tx);
            Console.Out.WriteLine($"Transaction {transactionHash} sent, See Details on https://goerli.etherscan.io/tx/{transactionHash}.");

        }
    }
}
```

More details See [API DotNet](api-dotnet.html)

## Supported Chains

Currently, Incubed is deployed on the following chains:

### Mainnet

Registry-contract: [0x6c095a05764a23156efd9d603eada144a9b1af33](https://etherscan.io/address/0x6c095a05764a23156efd9d603eada144a9b1af33#code)    

ChainId: 0x1 (alias `mainnet`)        

current NodeList: [https://in3-v2.slock.it/mainnet/nd-3/api/in3_nodeList](https://in3-v2.slock.it/mainnet/nd-3/api/in3_nodeList) 

### Görli (Testnet)

Registry Contract: [0x635cccc1db6fc9e3b029814720595092affba12f](https://goerli.etherscan.io/address/0x635cccc1db6fc9e3b029814720595092affba12f)    

ChainId: 0x5 (alias `goerli`)    

NodeList: [https://in3-v2.slock.it/goerli/nd-3/api/in3_nodeList](https://in3-v2.slock.it/goerli/nd-3/api/in3_nodeList) 


### EWC (Energy Web Chain)

Registry Contract: [0x638428ebaa190c6c6331a3a02f3b8c5d8310986b](https://explorer.energyweb.org/address/0x638428ebaa190c6c6331a3a02f3b8c5d8310986b/logs)    

ChainId: 0xf6 (alias `ewc`)

NodeList: [https://in3-v2.slock.it/ewc/nd-3/api/in3_nodeList](https://in3-v2.slock.it/ewc/nd-3/api/in3_nodeList) 


### IPFS

Registry: [0xcb61736de539acfa0ee97bc6bbf9108ef906c88c](https://etherscan.io/address/0xcb61736de539acfa0ee97bc6bbf9108ef906c88c)    

ChainId: 0x7d0 (alias `ipfs`)    

NodeList: [https://in3-v2.slock.it/ipfs/nd-3/api/in3_nodeList](https://in3-v2.slock.it/ipfs/nd-3/api/in3_nodeList) 


### BTC
*(currently experimental)*

Registry: [0xc3845e55756db9990ea06de9ea73dc99769f6c7f](https://etherscan.io/address/0xc3845e55756db9990ea06de9ea73dc99769f6c7f)    

ChainId: 0x7d0 (alias `ipfs`)    

NodeList: [https://in3-v2.slock.it/ipfs/nd-3/api/in3_nodeList](https://in3-v2.slock.it/ipfs/nd-3/api/in3_nodeList) 

## Registering an Incubed Node

If you want to participate in this network and also register a node (or even want to setup incubed nodes in your private chain), you need the following:

1. deployed registry-contracts (See the addressesd or above or deploy those [contracts](https://github.com/blockchainsllc/in3-contracts) )
2. for each node you want to add make sure you have a synced geth, nethermind or openethereum client running.
3. for each node run the `in3-node` which connects to the ethereum-node and register this url with the signer address by sending a transaction to the registry contract, calling `registerNode(string _url, uint _props, uint64 _weight, uint _deposit)`.

For more details on how this is done See

- [Setting up a node](incubed_from_vps.html)
- [API Reference Node](api-node-server.html)
- [The Registry Contracts](api-solidity.html)

or simply use our [setup-tool](https://in3-setup.slock.it/), which helps you generate the docker-compose file and will manage the registry-transactions.


