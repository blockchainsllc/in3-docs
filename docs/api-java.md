# API Reference Java


## Installing

The Incubed Java client uses JNI in order to call native functions. But all the native-libraries are bundled inside the jar-file. This jar file ha **no** dependencies and can even be used standalone:

like

```c
java -cp in3.jar in3.IN3 eth_getBlockByNumber latest false
```
### Downloading

The jar file can be downloaded from the latest release. [here](https://github.com/slockit/in3-c/releases).

Alternatively, If you wish to download Incubed using the maven package manager, add this to your pom.xml 

```c
<dependency>
  <groupId>it.slock</groupId>
  <artifactId>in3</artifactId>
  <version>2.21</version>
</dependency> 
```
After which, install in3 with `mvn install`.

### Building

For building the shared library you need to enable java by using the `-DJAVA=true` flag:

```c
git clone git@github.com:slockit/in3-c.git
mkdir -p in3-c/build
cd in3-c/build
cmake -DJAVA=true .. && make
```
You will find the `in3.jar` in the build/lib - folder.

### Android

In order to use Incubed in android simply follow these steps:

Step 1: Create a top-level CMakeLists.txt in android project inside app folder and link this to gradle. Follow the steps using this [guide](https://developer.android.com/studio/projects/gradle-external-native-builds) on howto link.

The Content of the `CMakeLists.txt` should look like this:

```c
cmake_minimum_required(VERSION 3.4.1)

# turn off FAST_MATH in the evm.
ADD_DEFINITIONS(-DIN3_MATH_LITE)

# loop through the required module and cretae the build-folders
foreach(module 
  c/src/core 
  c/src/verifier/eth1/nano 
  c/src/verifier/eth1/evm 
  c/src/verifier/eth1/basic 
  c/src/verifier/eth1/full 
  java/src
  c/src/third-party/crypto 
  c/src/third-party/tommath 
  c/src/api/eth1)
        file(MAKE_DIRECTORY in3-c/${module}/outputs)
        add_subdirectory( in3-c/${module} in3-c/${module}/outputs )
endforeach()
```
Step 2: clone [in3-c](https://github.com/slockit/in3-c.git) into the `app`-folder or use this script to clone and update in3:

```c
#!/usr/bin/env sh

#github-url for in3-c
IN3_SRC=https://github.com/slockit/in3-c.git

cd app

# if it exists we only call git pull
if [ -d in3-c ]; then
    cd in3-c
    git pull
    cd ..
else
# if not we clone it
    git clone $IN3_SRC
fi


# copy the java-sources to the main java path
cp -r in3-c/java/src/in3 src/main/java/
```
Step 3: Use methods available in app/src/main/java/in3/IN3.java from android activity to access IN3 functions.

Here is example how to use it:

[https://github.com/slockit/in3-example-android](https://github.com/slockit/in3-example-android) 




## Examples

### CallFunction

source : [in3-c/java/examples/CallFunction.java](https://github.com/slockit/in3-c/blob/master/java/examples/CallFunction.java)

Calling Functions of Contracts

```c

// This Example shows how to call functions and use the decoded results. Here we get the struct from the registry.

import in3.*;
import in3.eth1.*;

public class CallFunction {
  //
  public static void main(String[] args) {
    // create incubed
    IN3 in3 = IN3.forChain(Chain.MAINNET); // set it to mainnet (which is also dthe default)

    // call a contract, which uses eth_call to get the result.
    Object[] result = (Object[]) in3.getEth1API().call(                      // call a function of a contract
        "0x2736D225f85740f42D17987100dc8d58e9e16252",                        // address of the contract
        "servers(uint256):(string,address,uint256,uint256,uint256,address)", // function signature
        1);                                                                  // first argument, which is the index of the node we are looking for.

    System.out.println("url     : " + result[0]);
    System.out.println("owner   : " + result[1]);
    System.out.println("deposit : " + result[2]);
    System.out.println("props   : " + result[3]);
  }
}
```
### Configure

source : [in3-c/java/examples/Configure.java](https://github.com/slockit/in3-c/blob/master/java/examples/Configure.java)

Changing the default configuration

```c

// In order to change the default configuration, just use the classes inside in3.config package.

package in3;

import in3.*;
import in3.config.*;
import in3.eth1.Block;

public class Configure {
  //
  public static void main(String[] args) {
    // create incubed client
    IN3 in3 = IN3.forChain(Chain.GOERLI); // set it to goerli

    // Setup a Configuration object for the client
    ClientConfiguration clientConfig = in3.getConfig();
    clientConfig.setReplaceLatestBlock(6); // define that latest will be -6
    clientConfig.setAutoUpdateList(false); // prevents node automatic update
    clientConfig.setMaxAttempts(1);        // sets max attempts to 1 before giving up
    clientConfig.setProof(Proof.none);     // does not require proof (not recommended)

    // Setup the NodeConfiguration object for the nodes on a certain chain
    NodeConfiguration nodeConfiguration = new NodeConfiguration(Chain.GOERLI, clientConfig);
    nodeConfiguration.setNeedsUpdate(false);
    nodeConfiguration.setContract("0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f");
    nodeConfiguration.setRegistryId("0x23d5345c5c13180a8080bd5ddbe7cde64683755dcce6e734d95b7b573845facb");

    in3.setConfig(clientConfig);

    Block block = in3.getEth1API().getBlockByNumber(Block.LATEST, true);
    System.out.println(block.getHash());
  }
}
```
### GetBalance

source : [in3-c/java/examples/GetBalance.java](https://github.com/slockit/in3-c/blob/master/java/examples/GetBalance.java)

getting the Balance with or without API

```c

import in3.*;
import in3.eth1.*;
import java.math.BigInteger;
import java.util.*;

public class GetBalance {

  static String AC_ADDR = "0xc94770007dda54cF92009BFF0dE90c06F603a09f";

  public static void main(String[] args) throws Exception {
    // create incubed
    IN3 in3 = IN3.forChain(Chain.MAINNET); // set it to mainnet (which is also dthe default)

    System.out.println("Balance API" + GetBalanceAPI(in3).longValue());

    System.out.println("Balance RPC " + GetBalanceRPC(in3));
  }

  static BigInteger GetBalanceAPI(IN3 in3) {
    return in3.getEth1API().getBalance(AC_ADDR, Block.LATEST);
  }

  static String GetBalanceRPC(IN3 in3) {
    return in3.sendRPC("eth_getBalance", new Object[] {AC_ADDR, "latest"});
  }
}
```
### GetBlockAPI

source : [in3-c/java/examples/GetBlockAPI.java](https://github.com/slockit/in3-c/blob/master/java/examples/GetBlockAPI.java)

getting a block with API

```c

import in3.*;
import in3.eth1.*;
import java.math.BigInteger;
import java.util.*;

public class GetBlockAPI {
  //
  public static void main(String[] args) throws Exception {
    // create incubed
    IN3 in3 = IN3.forChain(Chain.MAINNET); // set it to mainnet (which is also dthe default)

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
### GetBlockRPC

source : [in3-c/java/examples/GetBlockRPC.java](https://github.com/slockit/in3-c/blob/master/java/examples/GetBlockRPC.java)

getting a block without API

```c

import in3.*;
import in3.eth1.*;
import java.math.BigInteger;
import java.util.*;

public class GetBlockRPC {
  //
  public static void main(String[] args) throws Exception {
    // create incubed
    IN3 in3 = IN3.forChain(Chain.MAINNET); // set it to mainnet (which is also the default)

    // read the latest Block without the Transactions.
    String result = in3.sendRPC("eth_getBlockByNumber", new Object[] {"latest", false});

    // print the json-data
    System.out.println("current Block : " + result);
  }
}
```
### GetTransaction

source : [in3-c/java/examples/GetTransaction.java](https://github.com/slockit/in3-c/blob/master/java/examples/GetTransaction.java)

getting a Transaction with or without API

```c

import in3.*;
import in3.eth1.*;
import java.math.BigInteger;
import java.util.*;

public class GetTransaction {

  static String TXN_HASH = "0xdd80249a0631cf0f1593c7a9c9f9b8545e6c88ab5252287c34bc5d12457eab0e";

  public static void main(String[] args) throws Exception {
    // create incubed
    IN3 in3 = IN3.forChain(Chain.MAINNET); // set it to mainnet (which is also dthe default)

    Transaction txn = GetTransactionAPI(in3);
    System.out.println("Transaction API #blockNumber: " + txn.getBlockNumber());

    System.out.println("Transaction RPC :" + GetTransactionRPC(in3));
  }

  static Transaction GetTransactionAPI(IN3 in3) {
    return in3.getEth1API().getTransactionByHash(TXN_HASH);
  }

  static String GetTransactionRPC(IN3 in3) {
    return in3.sendRPC("eth_getTransactionByHash", new Object[] {TXN_HASH});
  }
}
```
### GetTransactionReceipt

source : [in3-c/java/examples/GetTransactionReceipt.java](https://github.com/slockit/in3-c/blob/master/java/examples/GetTransactionReceipt.java)

getting a TransactionReceipt with or without API

```c

import in3.*;
import in3.eth1.*;
import java.math.BigInteger;
import java.util.*;

public class GetTransactionReceipt {
  static String TRANSACTION_HASH = "0xdd80249a0631cf0f1593c7a9c9f9b8545e6c88ab5252287c34bc5d12457eab0e";

  //
  public static void main(String[] args) throws Exception {
    // create incubed
    IN3 in3 = IN3.forChain(Chain.MAINNET); // set it to mainnet (which is also the default)

    TransactionReceipt txn = GetTransactionReceiptAPI(in3);
    System.out.println("TransactionRerceipt API : for txIndex " + txn.getTransactionIndex() + " Block num " + txn.getBlockNumber() + " Gas used " + txn.getGasUsed() + " status " + txn.getStatus());

    System.out.println("TransactionReceipt RPC : " + GetTransactionReceiptRPC(in3));
  }

  static TransactionReceipt GetTransactionReceiptAPI(IN3 in3) {
    return in3.getEth1API().getTransactionReceipt(TRANSACTION_HASH);
  }

  static String GetTransactionReceiptRPC(IN3 in3) {
    return in3.sendRPC("eth_getTransactionReceipt", new Object[] {TRANSACTION_HASH});
  }
}
```
### SendTransaction

source : [in3-c/java/examples/SendTransaction.java](https://github.com/slockit/in3-c/blob/master/java/examples/SendTransaction.java)

Sending Transactions

```c

// In order to send, you need a Signer. The SimpleWallet class is a basic implementation which can be used.

package in3;

import in3.*;
import in3.eth1.*;
import java.io.IOException;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

public class SendTransaction {
  //
  public static void main(String[] args) throws IOException {
    // create incubed
    IN3 in3 = IN3.forChain(Chain.MAINNET); // set it to mainnet (which is also dthe default)

    // create a wallet managing the private keys
    SimpleWallet wallet = new SimpleWallet();

    // add accounts by adding the private keys
    String keyFile      = "myKey.json";
    String myPassphrase = "<secrect>";

    // read the keyfile and decoded the private key
    String account = wallet.addKeyStore(
        Files.readString(Paths.get(keyFile)),
        myPassphrase);

    // use the wallet as signer
    in3.setSigner(wallet);

    String     receipient = "0x1234567890123456789012345678901234567890";
    BigInteger value      = BigInteger.valueOf(100000);

    // create a Transaction
    TransactionRequest tx = new TransactionRequest();
    tx.setFrom(account);
    tx.setTo("0x1234567890123456789012345678901234567890");
    tx.setFunction("transfer(address,uint256)");
    tx.setParams(new Object[] {receipient, value});

    String txHash = in3.getEth1API().sendTransaction(tx);

    System.out.println("Transaction sent with hash = " + txHash);
  }
}
```
### Building

In order to run those examples, you only need a Java SDK installed.

```c
./build.sh
```
will build all examples in this directory.

In order to run a example use

```c
java -cp $IN3/build/lib/in3.jar:. GetBlockAPI
```



## Package in3

#### class BlockID

##### fromHash

 > public static [`BlockID`](#class-blockid) fromHash([`String`](#class-string) hash);

arguments:
```eval_rst
========== ========== 
``String``  **hash**  
========== ========== 
```
##### fromNumber

 > public static [`BlockID`](#class-blockid) fromNumber([`long`](#class-long) number);

arguments:
```eval_rst
======== ============ 
``long``  **number**  
======== ============ 
```
##### getNumber

 > public `Long` getNumber();

##### setNumber

 > public `void` setNumber([`long`](#class-long) block);

arguments:
```eval_rst
======== =========== 
``long``  **block**  
======== =========== 
```
##### getHash

 > public `String` getHash();

##### setHash

 > public `void` setHash([`String`](#class-string) hash);

arguments:
```eval_rst
========== ========== 
``String``  **hash**  
========== ========== 
```
##### toJSON

 > public `String` toJSON();

##### toString

 > public `String` toString();


#### class Chain

Constants for Chain-specs. 

##### MULTICHAIN

support for multiple chains, a client can then switch between different chains (but consumes more memory) 

Type: static `final long`

##### MAINNET

use mainnet 

Type: static `final long`

##### KOVAN

use kovan testnet 

Type: static `final long`

##### TOBALABA

use tobalaba testnet 

Type: static `final long`

##### GOERLI

use goerli testnet 

Type: static `final long`

##### EVAN

use evan testnet 

Type: static `final long`

##### IPFS

use ipfs 

Type: static `final long`

##### VOLTA

use volta test net 

Type: static `final long`

##### LOCAL

use local client 

Type: static `final long`


#### class IN3

This is the main class creating the incubed client. 

The client can then be configured. 

##### IN3

 > public  IN3();

##### getKey

the client key to sign requests 

 > public `native byte[]` getKey();

##### setKey

sets the client key to sign requests 

 > public `native void` setKey([`byte[]`](#class-byte[]) val);

arguments:
```eval_rst
========== ========= 
``byte[]``  **val**  
========== ========= 
```
##### getConfig

returns the current configuration. 

any changes to the configuration will be applied witth the next request. 

 > public [`ClientConfiguration`](#class-clientconfiguration) getConfig();

##### setKey

sets the client key as hexstring to sign requests 

 > public `void` setKey([`String`](#class-string) val);

arguments:
```eval_rst
========== ========= 
``String``  **val**  
========== ========= 
```
##### setSigner

sets the signer or wallet. 

 > public `void` setSigner([`Signer`](#class-signer) signer);

arguments:
```eval_rst
========================= ============ 
`Signer <#class-signer>`_  **signer**  
========================= ============ 
```
##### getSigner

returns the signer or wallet. 

 > public [`Signer`](#class-signer) getSigner();

##### getIpfs

gets the ipfs-api 

 > public [`in3.ipfs.API`](#class-in3.ipfs.api) getIpfs();

##### getEth1API

gets the ethereum-api 

 > public [`in3.eth1.API`](#class-in3.eth1.api) getEth1API();

##### getCrypto

gets the utils/crypto-api 

 > public [`Crypto`](#class-crypto) getCrypto();

##### setStorageProvider

provides the ability to cache content like nodelists, contract codes and validatorlists 

 > public `void` setStorageProvider([`StorageProvider`](#class-storageprovider) val);

arguments:
```eval_rst
=========================================== ========= 
`StorageProvider <#class-storageprovider>`_  **val**  
=========================================== ========= 
```
##### getStorageProvider

provides the ability to cache content 

 > public [`StorageProvider`](#class-storageprovider) getStorageProvider();

##### setTransport

sets The transport interface. 

This allows to fetch the result of the incubed in a different way. 

 > public `void` setTransport([`IN3Transport`](#class-in3transport) newTransport);

arguments:
```eval_rst
================ ================== 
``IN3Transport``  **newTransport**  
================ ================== 
```
##### getTransport

returns the current transport implementation. 

 > public `IN3Transport` getTransport();

##### getChainId

servers to filter for the given chain. 

The chain-id based on EIP-155. 

 > public `native long` getChainId();

##### setChainId

sets the chain to be used. 

The chain-id based on EIP-155. 

 > public `native void` setChainId([`long`](#class-long) val);

arguments:
```eval_rst
======== ========= 
``long``  **val**  
======== ========= 
```
##### send

send a request. 

The request must a valid json-string with method and params 

 > public `String` send([`String`](#class-string) request);

arguments:
```eval_rst
========== ============= 
``String``  **request**  
========== ============= 
```
##### sendobject

send a request but returns a object like array or map with the parsed response. 

The request must a valid json-string with method and params 

 > public `Object` sendobject([`String`](#class-string) request);

arguments:
```eval_rst
========== ============= 
``String``  **request**  
========== ============= 
```
##### sendRPC

send a RPC request by only passing the method and params. 

It will create the raw request from it and return the result. 

 > public `String` sendRPC([`String`](#class-string) method, [`Object[]`](#class-object[]) params);

arguments:
```eval_rst
============ ============ 
``String``    **method**  
``Object[]``  **params**  
============ ============ 
```
##### sendRPCasObject

 > public `Object` sendRPCasObject([`String`](#class-string) method, [`Object[]`](#class-object[]) params, [`boolean`](#class-boolean) useEnsResolver);

arguments:
```eval_rst
============ ==================== 
``String``    **method**          
``Object[]``  **params**          
``boolean``   **useEnsResolver**  
============ ==================== 
```
##### sendRPCasObject

send a RPC request by only passing the method and params. 

It will create the raw request from it and return the result. 

 > public `Object` sendRPCasObject([`String`](#class-string) method, [`Object[]`](#class-object[]) params);

arguments:
```eval_rst
============ ============ 
``String``    **method**  
``Object[]``  **params**  
============ ============ 
```
##### cacheClear

clears the cache. 

 > public `boolean` cacheClear();

##### nodeList

restrieves the node list 

 > public [`IN3Node[]`](#class-in3node) nodeList();

##### sign

request for a signature of an already verified hash. 

 > public [`SignedBlockHash[]`](#class-signedblockhash) sign([`BlockID[]`](#class-blockid[]) blocks, [`String[]`](#class-string[]) address);

arguments:
```eval_rst
============================= ============= 
`BlockID[] <#class-blockid>`_  **blocks**   
``String[]``                   **address**  
============================= ============= 
```
##### forChain

create a Incubed client using the chain-config. 

if chainId is Chain.MULTICHAIN, the client can later be switched between different chains, for all other chains, it will be initialized only with the chainspec for this one chain (safes memory) 

 > public static [`IN3`](#class-in3) forChain([`long`](#class-long) chainId);

arguments:
```eval_rst
======== ============= 
``long``  **chainId**  
======== ============= 
```
##### getVersion

returns the current incubed version. 

 > public static `native String` getVersion();

##### main

 > public static `void` main([`String[]`](#class-string[]) args);

arguments:
```eval_rst
============ ========== 
``String[]``  **args**  
============ ========== 
```

#### class IN3DefaultTransport

##### handle

 > public `byte[][]` handle([`String[]`](#class-string[]) urls, [`byte[]`](#class-byte[]) payload);

arguments:
```eval_rst
============ ============= 
``String[]``  **urls**     
``byte[]``    **payload**  
============ ============= 
```

#### class IN3Node

##### getUrl

 > public `String` getUrl();

##### getAddress

 > public `String` getAddress();

##### getIndex

 > public `int` getIndex();

##### getDeposit

 > public `String` getDeposit();

##### getProps

 > public `long` getProps();

##### getTimeout

 > public `int` getTimeout();

##### getRegisterTime

 > public `int` getRegisterTime();

##### getWeight

 > public `int` getWeight();


#### class Loader

##### loadLibrary

 > public static `void` loadLibrary();


#### class NodeList

##### getNodes

returns an array of IN3Node 

 > public [`IN3Node[]`](#class-in3node) getNodes();


#### class NodeProps

##### NODE_PROP_PROOF

Type: static `final long`

##### NODE_PROP_MULTICHAIN

Type: static `final long`

##### NODE_PROP_ARCHIVE

Type: static `final long`

##### NODE_PROP_HTTP

Type: static `final long`

##### NODE_PROP_BINARY

Type: static `final long`

##### NODE_PROP_ONION

Type: static `final long`

##### NODE_PROP_STATS

Type: static `final long`


#### class SignedBlockHash

##### getBlockHash

 > public `String` getBlockHash();

##### getBlock

 > public `long` getBlock();

##### getR

 > public `String` getR();

##### getS

 > public `String` getS();

##### getV

 > public `long` getV();

##### getMsgHash

 > public `String` getMsgHash();


#### enum Proof

The Proof type indicating how much proof is required. 

The enum type contains the following values:

```eval_rst
============== = =====================================================================
 **none**      0 No Verification.
 **standard**  1 Standard Verification of the important properties.
 **full**      2 Full Verification including even uncles wich leads to higher payload.
============== = =====================================================================
```

#### interface IN3Transport

##### handle

 > public `byte[][]` handle([`String[]`](#class-string[]) urls, [`byte[]`](#class-byte[]) payload);

arguments:
```eval_rst
============ ============= 
``String[]``  **urls**     
``byte[]``    **payload**  
============ ============= 
```

## Package in3.config

#### class ChainConfiguration

Part of the configuration hierarchy for IN3 Client. 

Holds the configuration a node group in a particular Chain. 

##### nodesConfig

Type: [`NodeConfigurationArrayList< , >`](#class-nodeconfiguration)

##### ChainConfiguration

 > public  ChainConfiguration([`long`](#class-long) chain, [`ClientConfiguration`](#class-clientconfiguration) config);

arguments:
```eval_rst
=================================================== ============ 
``long``                                             **chain**   
`ClientConfiguration <#class-clientconfiguration>`_  **config**  
=================================================== ============ 
```
##### getChain

 > public `long` getChain();

##### isNeedsUpdate

 > public `Boolean` isNeedsUpdate();

##### setNeedsUpdate

 > public `void` setNeedsUpdate([`boolean`](#class-boolean) needsUpdate);

arguments:
```eval_rst
=========== ================= 
``boolean``  **needsUpdate**  
=========== ================= 
```
##### getContract

 > public `String` getContract();

##### setContract

 > public `void` setContract([`String`](#class-string) contract);

arguments:
```eval_rst
========== ============== 
``String``  **contract**  
========== ============== 
```
##### getRegistryId

 > public `String` getRegistryId();

##### setRegistryId

 > public `void` setRegistryId([`String`](#class-string) registryId);

arguments:
```eval_rst
========== ================ 
``String``  **registryId**  
========== ================ 
```
##### getWhiteListContract

 > public `String` getWhiteListContract();

##### setWhiteListContract

 > public `void` setWhiteListContract([`String`](#class-string) whiteListContract);

arguments:
```eval_rst
========== ======================= 
``String``  **whiteListContract**  
========== ======================= 
```
##### getWhiteList

 > public `String[]` getWhiteList();

##### setWhiteList

 > public `void` setWhiteList([`String[]`](#class-string[]) whiteList);

arguments:
```eval_rst
============ =============== 
``String[]``  **whiteList**  
============ =============== 
```
##### toJSON

generates a json-string based on the internal data. 

 > public `String` toJSON();

##### toString

 > public `String` toString();


#### class ClientConfiguration

Configuration Object for Incubed Client. 

It holds the state for the root of the configuration tree. Should be retrieved from the client instance as IN3::getConfig() 

##### getRequestCount

 > public `Integer` getRequestCount();

##### setRequestCount

sets the number of requests send when getting a first answer 

 > public `void` setRequestCount([`int`](#class-int) requestCount);

arguments:
```eval_rst
======= ================== 
``int``  **requestCount**  
======= ================== 
```
##### isAutoUpdateList

 > public `Boolean` isAutoUpdateList();

##### setAutoUpdateList

activates the auto update.if true the nodelist will be automaticly updated if the lastBlock is newer 

 > public `void` setAutoUpdateList([`boolean`](#class-boolean) autoUpdateList);

arguments:
```eval_rst
=========== ==================== 
``boolean``  **autoUpdateList**  
=========== ==================== 
```
##### getProof

 > public [`Proof`](#class-proof) getProof();

##### setProof

sets the type of proof used 

 > public `void` setProof([`Proof`](#class-proof) proof);

arguments:
```eval_rst
======================= =========== 
`Proof <#class-proof>`_  **proof**  
======================= =========== 
```
##### getMaxAttempts

 > public `Integer` getMaxAttempts();

##### setMaxAttempts

sets the max number of attempts before giving up 

 > public `void` setMaxAttempts([`int`](#class-int) maxAttempts);

arguments:
```eval_rst
======= ================= 
``int``  **maxAttempts**  
======= ================= 
```
##### getSignatureCount

 > public `Integer` getSignatureCount();

##### setSignatureCount

sets the number of signatures used to proof the blockhash. 

 > public `void` setSignatureCount([`int`](#class-int) signatureCount);

arguments:
```eval_rst
======= ==================== 
``int``  **signatureCount**  
======= ==================== 
```
##### isStats

 > public `Boolean` isStats();

##### setStats

if true (default) the request will be counted as part of the regular stats, if not they are not shown as part of the dashboard. 

 > public `void` setStats([`boolean`](#class-boolean) stats);

arguments:
```eval_rst
=========== =========== 
``boolean``  **stats**  
=========== =========== 
```
##### getFinality

 > public `Integer` getFinality();

##### setFinality

sets the number of signatures in percent required for the request 

 > public `void` setFinality([`int`](#class-int) finality);

arguments:
```eval_rst
======= ============== 
``int``  **finality**  
======= ============== 
```
##### isIncludeCode

 > public `Boolean` isIncludeCode();

##### setIncludeCode

 > public `void` setIncludeCode([`boolean`](#class-boolean) includeCode);

arguments:
```eval_rst
=========== ================= 
``boolean``  **includeCode**  
=========== ================= 
```
##### isKeepIn3

 > public `Boolean` isKeepIn3();

##### setKeepIn3

 > public `void` setKeepIn3([`boolean`](#class-boolean) keepIn3);

arguments:
```eval_rst
=========== ============= 
``boolean``  **keepIn3**  
=========== ============= 
```
##### isUseBinary

 > public `Boolean` isUseBinary();

##### setUseBinary

 > public `void` setUseBinary([`boolean`](#class-boolean) useBinary);

arguments:
```eval_rst
=========== =============== 
``boolean``  **useBinary**  
=========== =============== 
```
##### isUseHttp

 > public `Boolean` isUseHttp();

##### setUseHttp

 > public `void` setUseHttp([`boolean`](#class-boolean) useHttp);

arguments:
```eval_rst
=========== ============= 
``boolean``  **useHttp**  
=========== ============= 
```
##### getMaxCodeCache

 > public `Long` getMaxCodeCache();

##### setMaxCodeCache

sets number of max bytes used to cache the code in memory 

 > public `void` setMaxCodeCache([`long`](#class-long) maxCodeCache);

arguments:
```eval_rst
======== ================== 
``long``  **maxCodeCache**  
======== ================== 
```
##### getTimeout

 > public `Long` getTimeout();

##### setTimeout

specifies the number of milliseconds before the request times out. 

increasing may be helpful if the device uses a slow connection. 

 > public `void` setTimeout([`long`](#class-long) timeout);

arguments:
```eval_rst
======== ============= 
``long``  **timeout**  
======== ============= 
```
##### getMinDeposit

 > public `Long` getMinDeposit();

##### setMinDeposit

sets min stake of the server. 

Only nodes owning at least this amount will be chosen. 

 > public `void` setMinDeposit([`long`](#class-long) minDeposit);

arguments:
```eval_rst
======== ================ 
``long``  **minDeposit**  
======== ================ 
```
##### getNodeProps

 > public `Long` getNodeProps();

##### setNodeProps

 > public `void` setNodeProps([`long`](#class-long) nodeProps);

arguments:
```eval_rst
======== =============== 
``long``  **nodeProps**  
======== =============== 
```
##### getNodeLimit

 > public `Long` getNodeLimit();

##### setNodeLimit

sets the limit of nodes to store in the client. 

 > public `void` setNodeLimit([`long`](#class-long) nodeLimit);

arguments:
```eval_rst
======== =============== 
``long``  **nodeLimit**  
======== =============== 
```
##### getReplaceLatestBlock

 > public `Integer` getReplaceLatestBlock();

##### setReplaceLatestBlock

replaces the *latest* with blockNumber- specified value 

 > public `void` setReplaceLatestBlock([`int`](#class-int) replaceLatestBlock);

arguments:
```eval_rst
======= ======================== 
``int``  **replaceLatestBlock**  
======= ======================== 
```
##### getRpc

 > public `String` getRpc();

##### setRpc

setup an custom rpc source for requests by setting Chain to local and proof to none 

 > public `void` setRpc([`String`](#class-string) rpc);

arguments:
```eval_rst
========== ========= 
``String``  **rpc**  
========== ========= 
```
##### getMaxBlockCache

 > public `Long` getMaxBlockCache();

##### setMaxBlockCache

sets the number of blocks cached in memory 

 > public `void` setMaxBlockCache([`long`](#class-long) maxBlockCache);

arguments:
```eval_rst
======== =================== 
``long``  **maxBlockCache**  
======== =================== 
```
##### getNodesConfig

 > public [`ChainConfigurationHashMap< Long, , >`](#class-chainconfiguration) getNodesConfig();

##### setChainsConfig

 > public `void` setChainsConfig([`HashMap<`](#class-hashmap<) Long, [`ChainConfiguration`](#class-chainconfiguration) >);

arguments:
```eval_rst
=================================================================== ================== 
`ChainConfigurationHashMap< Long, , > <#class-chainconfiguration>`_  **chainsConfig**  
=================================================================== ================== 
```
##### markAsSynced

 > public `void` markAsSynced();

##### isSynced

 > public `boolean` isSynced();

##### toString

 > public `String` toString();

##### toJSON

generates a json-string based on the internal data. 

 > public `String` toJSON();


#### class NodeConfiguration

Configuration Object for Incubed Client. 

It represents the node of a nodelist. 

##### NodeConfiguration

 > public  NodeConfiguration([`ChainConfiguration`](#class-chainconfiguration) config);

arguments:
```eval_rst
================================================= ============ 
`ChainConfiguration <#class-chainconfiguration>`_  **config**  
================================================= ============ 
```
##### getUrl

 > public `String` getUrl();

##### setUrl

 > public `void` setUrl([`String`](#class-string) url);

arguments:
```eval_rst
========== ========= 
``String``  **url**  
========== ========= 
```
##### getProps

 > public `long` getProps();

##### setProps

 > public `void` setProps([`long`](#class-long) props);

arguments:
```eval_rst
======== =========== 
``long``  **props**  
======== =========== 
```
##### getAddress

 > public `String` getAddress();

##### setAddress

 > public `void` setAddress([`String`](#class-string) address);

arguments:
```eval_rst
========== ============= 
``String``  **address**  
========== ============= 
```
##### toString

 > public `String` toString();


#### interface Configuration

an Interface class, which is able to generate a JSON-String. 

##### toJSON

generates a json-string based on the internal data. 

 > public `String` toJSON();


## Package in3.eth1

#### class API

a Wrapper for the incubed client offering Type-safe Access and additional helper functions. 

##### API

creates an eth1.API using the given incubed instance. 

 > public  API([`IN3`](#class-in3) in3);

arguments:
```eval_rst
=================== ========= 
`IN3 <#class-in3>`_  **in3**  
=================== ========= 
```
##### getBlockByNumber

finds the Block as specified by the number. 

use `Block.LATEST` for getting the lastest block. 

 > public [`Block`](#class-block) getBlockByNumber([`long`](#class-long) block, [`boolean`](#class-boolean) includeTransactions);

arguments:
```eval_rst
=========== ========================= ================================================================================================
``long``     **block**                
``boolean``  **includeTransactions**  < the Blocknumber < if true all Transactions will be includes, if not only the transactionhashes
=========== ========================= ================================================================================================
```
##### getBlockByHash

Returns information about a block by hash. 

 > public [`Block`](#class-block) getBlockByHash([`String`](#class-string) blockHash, [`boolean`](#class-boolean) includeTransactions);

arguments:
```eval_rst
=========== ========================= ================================================================================================
``String``   **blockHash**            
``boolean``  **includeTransactions**  < the Blocknumber < if true all Transactions will be includes, if not only the transactionhashes
=========== ========================= ================================================================================================
```
##### getBlockNumber

the current BlockNumber. 

 > public `long` getBlockNumber();

##### getGasPrice

the current Gas Price. 

 > public `long` getGasPrice();

##### getChainId

Returns the EIP155 chain ID used for transaction signing at the current best block. 

Null is returned if not available. 

 > public `String` getChainId();

##### call

calls a function of a smart contract and returns the result. 

 > public `Object` call([`TransactionRequest`](#class-transactionrequest) request, [`long`](#class-long) block);

arguments:
```eval_rst
================================================= ============= =============================================================
`TransactionRequest <#class-transactionrequest>`_  **request**  
``long``                                           **block**    < the transaction to call. < the Block used to for the state.
================================================= ============= =============================================================
```
returns: `Object` : the decoded result. if only one return value is expected the Object will be returned, if not an array of objects will be the result. 



##### estimateGas

Makes a call or transaction, which won't be added to the blockchain and returns the used gas, which can be used for estimating the used gas. 

 > public `long` estimateGas([`TransactionRequest`](#class-transactionrequest) request, [`long`](#class-long) block);

arguments:
```eval_rst
================================================= ============= =============================================================
`TransactionRequest <#class-transactionrequest>`_  **request**  
``long``                                           **block**    < the transaction to call. < the Block used to for the state.
================================================= ============= =============================================================
```
returns: `long` : the gas required to call the function. 



##### getBalance

Returns the balance of the account of given address in wei. 

 > public `BigInteger` getBalance([`String`](#class-string) address, [`long`](#class-long) block);

arguments:
```eval_rst
========== ============= 
``String``  **address**  
``long``    **block**    
========== ============= 
```
##### getCode

Returns code at a given address. 

 > public `String` getCode([`String`](#class-string) address, [`long`](#class-long) block);

arguments:
```eval_rst
========== ============= 
``String``  **address**  
``long``    **block**    
========== ============= 
```
##### getStorageAt

Returns the value from a storage position at a given address. 

 > public `String` getStorageAt([`String`](#class-string) address, [`BigInteger`](#class-biginteger) position, [`long`](#class-long) block);

arguments:
```eval_rst
============== ============== 
``String``      **address**   
``BigInteger``  **position**  
``long``        **block**     
============== ============== 
```
##### getBlockTransactionCountByHash

Returns the number of transactions in a block from a block matching the given block hash. 

 > public `long` getBlockTransactionCountByHash([`String`](#class-string) blockHash);

arguments:
```eval_rst
========== =============== 
``String``  **blockHash**  
========== =============== 
```
##### getBlockTransactionCountByNumber

Returns the number of transactions in a block from a block matching the given block number. 

 > public `long` getBlockTransactionCountByNumber([`long`](#class-long) block);

arguments:
```eval_rst
======== =========== 
``long``  **block**  
======== =========== 
```
##### getFilterChangesFromLogs

Polling method for a filter, which returns an array of logs which occurred since last poll. 

 > public [`Log[]`](#class-log) getFilterChangesFromLogs([`long`](#class-long) id);

arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```
##### getFilterChangesFromBlocks

Polling method for a filter, which returns an array of logs which occurred since last poll. 

 > public `String[]` getFilterChangesFromBlocks([`long`](#class-long) id);

arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```
##### getFilterLogs

Polling method for a filter, which returns an array of logs which occurred since last poll. 

 > public [`Log[]`](#class-log) getFilterLogs([`long`](#class-long) id);

arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```
##### getLogs

Polling method for a filter, which returns an array of logs which occurred since last poll. 

 > public [`Log[]`](#class-log) getLogs([`LogFilter`](#class-logfilter) filter);

arguments:
```eval_rst
=============================== ============ 
`LogFilter <#class-logfilter>`_  **filter**  
=============================== ============ 
```
##### getTransactionByBlockHashAndIndex

Returns information about a transaction by block hash and transaction index position. 

 > public [`Transaction`](#class-transaction) getTransactionByBlockHashAndIndex([`String`](#class-string) blockHash, [`int`](#class-int) index);

arguments:
```eval_rst
========== =============== 
``String``  **blockHash**  
``int``     **index**      
========== =============== 
```
##### getTransactionByBlockNumberAndIndex

Returns information about a transaction by block number and transaction index position. 

 > public [`Transaction`](#class-transaction) getTransactionByBlockNumberAndIndex([`long`](#class-long) block, [`int`](#class-int) index);

arguments:
```eval_rst
======== =========== 
``long``  **block**  
``int``   **index**  
======== =========== 
```
##### getTransactionByHash

Returns the information about a transaction requested by transaction hash. 

 > public [`Transaction`](#class-transaction) getTransactionByHash([`String`](#class-string) transactionHash);

arguments:
```eval_rst
========== ===================== 
``String``  **transactionHash**  
========== ===================== 
```
##### getTransactionCount

Returns the number of transactions sent from an address. 

 > public `BigInteger` getTransactionCount([`String`](#class-string) address, [`long`](#class-long) block);

arguments:
```eval_rst
========== ============= 
``String``  **address**  
``long``    **block**    
========== ============= 
```
##### getTransactionReceipt

Returns the number of transactions sent from an address. 

 > public [`TransactionReceipt`](#class-transactionreceipt) getTransactionReceipt([`String`](#class-string) transactionHash);

arguments:
```eval_rst
========== ===================== 
``String``  **transactionHash**  
========== ===================== 
```
##### getUncleByBlockNumberAndIndex

Returns information about a uncle of a block number and uncle index position. 

Note: An uncle doesn't contain individual transactions. 

 > public [`Block`](#class-block) getUncleByBlockNumberAndIndex([`long`](#class-long) block, [`int`](#class-int) pos);

arguments:
```eval_rst
======== =========== 
``long``  **block**  
``int``   **pos**    
======== =========== 
```
##### getUncleCountByBlockHash

Returns the number of uncles in a block from a block matching the given block hash. 

 > public `long` getUncleCountByBlockHash([`String`](#class-string) block);

arguments:
```eval_rst
========== =========== 
``String``  **block**  
========== =========== 
```
##### getUncleCountByBlockNumber

Returns the number of uncles in a block from a block matching the given block hash. 

 > public `long` getUncleCountByBlockNumber([`long`](#class-long) block);

arguments:
```eval_rst
======== =========== 
``long``  **block**  
======== =========== 
```
##### newBlockFilter

Creates a filter in the node, to notify when a new block arrives. 

To check if the state has changed, call eth_getFilterChanges. 

 > public `long` newBlockFilter();

##### newLogFilter

Creates a filter object, based on filter options, to notify when the state changes (logs). 

To check if the state has changed, call eth_getFilterChanges.

A note on specifying topic filters: Topics are order-dependent. A transaction with a log with topics [A, B] will be matched by the following topic filters:

[] "anything" [A] "A in first position (and anything after)" [null, B] "anything in first position AND B in second position (and anything after)" [A, B] "A in first position AND B in second position (and anything after)" [[A, B], [A, B]] "(A OR B) in first position AND (A OR B) in second position
(and anything after)" 

 > public `long` newLogFilter([`LogFilter`](#class-logfilter) filter);

arguments:
```eval_rst
=============================== ============ 
`LogFilter <#class-logfilter>`_  **filter**  
=============================== ============ 
```
##### uninstallFilter

uninstall filter. 

 > public `boolean` uninstallFilter([`long`](#class-long) filter);

arguments:
```eval_rst
======== ============ 
``long``  **filter**  
======== ============ 
```
##### sendRawTransaction

Creates new message call transaction or a contract creation for signed transactions. 

 > public `String` sendRawTransaction([`String`](#class-string) data);

arguments:
```eval_rst
========== ========== 
``String``  **data**  
========== ========== 
```
returns: `String` : transactionHash 



##### abiEncode

encodes the arguments as described in the method signature using ABI-Encoding. 

 > public `String` abiEncode([`String`](#class-string) signature, [`String[]`](#class-string[]) params);

arguments:
```eval_rst
============ =============== 
``String``    **signature**  
``String[]``  **params**     
============ =============== 
```
##### abiDecode

decodes the data based on the signature. 

 > public `String[]` abiDecode([`String`](#class-string) signature, [`String`](#class-string) encoded);

arguments:
```eval_rst
========== =============== 
``String``  **signature**  
``String``  **encoded**    
========== =============== 
```
##### checksumAddress

converts the given address to a checksum address. 

 > public `String` checksumAddress([`String`](#class-string) address);

arguments:
```eval_rst
========== ============= 
``String``  **address**  
========== ============= 
```
##### checksumAddress

converts the given address to a checksum address. 

Second parameter includes the chainId. 

 > public `String` checksumAddress([`String`](#class-string) address, [`Boolean`](#class-boolean) useChainId);

arguments:
```eval_rst
=========== ================ 
``String``   **address**     
``Boolean``  **useChainId**  
=========== ================ 
```
##### ens

resolve ens-name. 

 > public `String` ens([`String`](#class-string) name);

arguments:
```eval_rst
========== ========== 
``String``  **name**  
========== ========== 
```
##### ens

resolve ens-name. 

Second parameter especifies if it is an address, owner, resolver or hash. 

 > public `String` ens([`String`](#class-string) name, [`ENSMethod`](#class-ensmethod) type);

arguments:
```eval_rst
=============================== ========== 
``String``                       **name**  
`ENSMethod <#class-ensmethod>`_  **type**  
=============================== ========== 
```
##### sendTransaction

sends a Transaction as described by the TransactionRequest. 

This will require a signer to be set in order to sign the transaction. 

 > public `String` sendTransaction([`TransactionRequest`](#class-transactionrequest) tx);

arguments:
```eval_rst
================================================= ======== 
`TransactionRequest <#class-transactionrequest>`_  **tx**  
================================================= ======== 
```
##### call

the current Gas Price. 

 > public `Object` call([`String`](#class-string) to, [`String`](#class-string) function, [`Object...`](#class-object...) params);

arguments:
```eval_rst
============= ============== 
``String``     **to**        
``String``     **function**  
``Object...``  **params**    
============= ============== 
```
returns: `Object` : the decoded result. if only one return value is expected the Object will be returned, if not an array of objects will be the result. 




#### class Block

represents a Block in ethereum. 

##### LATEST

The latest Block Number. 

Type: static `long`

##### EARLIEST

The Genesis Block. 

Type: static `long`

##### getTotalDifficulty

returns the total Difficulty as a sum of all difficulties starting from genesis. 

 > public `BigInteger` getTotalDifficulty();

##### getGasLimit

the gas limit of the block. 

 > public `BigInteger` getGasLimit();

##### getExtraData

the extra data of the block. 

 > public `String` getExtraData();

##### getDifficulty

the difficulty of the block. 

 > public `BigInteger` getDifficulty();

##### getAuthor

the author or miner of the block. 

 > public `String` getAuthor();

##### getTransactionsRoot

the roothash of the merkletree containing all transaction of the block. 

 > public `String` getTransactionsRoot();

##### getTransactionReceiptsRoot

the roothash of the merkletree containing all transaction receipts of the block. 

 > public `String` getTransactionReceiptsRoot();

##### getStateRoot

the roothash of the merkletree containing the complete state. 

 > public `String` getStateRoot();

##### getTransactionHashes

the transaction hashes of the transactions in the block. 

 > public `String[]` getTransactionHashes();

##### getTransactions

the transactions of the block. 

 > public [`Transaction[]`](#class-transaction) getTransactions();

##### getTimeStamp

the unix timestamp in seconds since 1970. 

 > public `long` getTimeStamp();

##### getSha3Uncles

the roothash of the merkletree containing all uncles of the block. 

 > public `String` getSha3Uncles();

##### getSize

the size of the block. 

 > public `long` getSize();

##### getSealFields

the seal fields used for proof of authority. 

 > public `String[]` getSealFields();

##### getHash

the block hash of the of the header. 

 > public `String` getHash();

##### getLogsBloom

the bloom filter of the block. 

 > public `String` getLogsBloom();

##### getMixHash

the mix hash of the block. 

(only valid of proof of work) 

 > public `String` getMixHash();

##### getNonce

the mix hash of the block. 

(only valid of proof of work) 

 > public `String` getNonce();

##### getNumber

the block number 

 > public `long` getNumber();

##### getParentHash

the hash of the parent-block. 

 > public `String` getParentHash();

##### getUncles

returns the blockhashes of all uncles-blocks. 

 > public `String[]` getUncles();

##### hashCode

 > public `int` hashCode();

##### equals

 > public `boolean` equals([`Object`](#class-object) obj);

arguments:
```eval_rst
========== ========= 
``Object``  **obj**  
========== ========= 
```

#### class Log

a log entry of a transaction receipt. 

##### isRemoved

true when the log was removed, due to a chain reorganization. 

false if its a valid log. 

 > public `boolean` isRemoved();

##### getLogIndex

integer of the log index position in the block. 

null when its pending log. 

 > public `int` getLogIndex();

##### gettTansactionIndex

integer of the transactions index position log was created from. 

null when its pending log. 

 > public `int` gettTansactionIndex();

##### getTransactionHash

Hash, 32 Bytes - hash of the transactions this log was created from. 

null when its pending log. 

 > public `String` getTransactionHash();

##### getBlockHash

Hash, 32 Bytes - hash of the block where this log was in. 

null when its pending. null when its pending log. 

 > public `String` getBlockHash();

##### getBlockNumber

the block number where this log was in. 

null when its pending. null when its pending log. 

 > public `long` getBlockNumber();

##### getAddress

20 Bytes - address from which this log originated. 

 > public `String` getAddress();

##### getTopics

Array of 0 to 4 32 Bytes DATA of indexed log arguments. 

(In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256)), except you declared the event with the anonymous specifier.) 

 > public `String[]` getTopics();


#### class LogFilter

Log configuration for search logs. 

##### getFromBlock

 > public `long` getFromBlock();

##### setFromBlock

 > public `void` setFromBlock([`long`](#class-long) fromBlock);

arguments:
```eval_rst
======== =============== 
``long``  **fromBlock**  
======== =============== 
```
##### getToBlock

 > public `long` getToBlock();

##### setToBlock

 > public `void` setToBlock([`long`](#class-long) toBlock);

arguments:
```eval_rst
======== ============= 
``long``  **toBlock**  
======== ============= 
```
##### getAddress

 > public `String` getAddress();

##### setAddress

 > public `void` setAddress([`String`](#class-string) address);

arguments:
```eval_rst
========== ============= 
``String``  **address**  
========== ============= 
```
##### getTopics

 > public `Object[]` getTopics();

##### setTopics

 > public `void` setTopics([`Object[]`](#class-object[]) topics);

arguments:
```eval_rst
============ ============ 
``Object[]``  **topics**  
============ ============ 
```
##### getLimit

 > public `int` getLimit();

##### setLimit

 > public `void` setLimit([`int`](#class-int) limit);

arguments:
```eval_rst
======= =========== 
``int``  **limit**  
======= =========== 
```
##### toString

creates a JSON-String. 

 > public `String` toString();


#### class SimpleWallet

a simple Implementation for holding private keys to sing data or transactions. 

##### addRawKey

adds a key to the wallet and returns its public address. 

 > public `String` addRawKey([`String`](#class-string) data);

arguments:
```eval_rst
========== ========== 
``String``  **data**  
========== ========== 
```
##### addKeyStore

adds a key to the wallet and returns its public address. 

 > public `String` addKeyStore([`String`](#class-string) jsonData, [`String`](#class-string) passphrase);

arguments:
```eval_rst
========== ================ 
``String``  **jsonData**    
``String``  **passphrase**  
========== ================ 
```
##### prepareTransaction

optiional method which allows to change the transaction-data before sending it. 

This can be used for redirecting it through a multisig. 

 > public [`TransactionRequest`](#class-transactionrequest) prepareTransaction([`IN3`](#class-in3) in3, [`TransactionRequest`](#class-transactionrequest) tx);

arguments:
```eval_rst
================================================= ========= 
`IN3 <#class-in3>`_                                **in3**  
`TransactionRequest <#class-transactionrequest>`_  **tx**   
================================================= ========= 
```
##### canSign

returns true if the account is supported (or unlocked) 

 > public `boolean` canSign([`String`](#class-string) address);

arguments:
```eval_rst
========== ============= 
``String``  **address**  
========== ============= 
```
##### sign

signing of the raw data. 

 > public `String` sign([`String`](#class-string) data, [`String`](#class-string) address);

arguments:
```eval_rst
========== ============= 
``String``  **data**     
``String``  **address**  
========== ============= 
```

#### class Transaction

represents a Transaction in ethereum. 

##### getBlockHash

the blockhash of the block containing this transaction. 

 > public `String` getBlockHash();

##### getBlockNumber

the block number of the block containing this transaction. 

 > public `long` getBlockNumber();

##### getChainId

the chainId of this transaction. 

 > public `String` getChainId();

##### getCreatedContractAddress

the address of the deployed contract (if successfull) 

 > public `String` getCreatedContractAddress();

##### getFrom

the address of the sender. 

 > public `String` getFrom();

##### getHash

the Transaction hash. 

 > public `String` getHash();

##### getData

the Transaction data or input data. 

 > public `String` getData();

##### getNonce

the nonce used in the transaction. 

 > public `long` getNonce();

##### getPublicKey

the public key of the sender. 

 > public `String` getPublicKey();

##### getValue

the value send in wei. 

 > public `BigInteger` getValue();

##### getRaw

the raw transaction as rlp encoded data. 

 > public `String` getRaw();

##### getTo

the address of the receipient or contract. 

 > public `String` getTo();

##### getSignature

the signature of the sender - a array of the [ r, s, v] 

 > public `String[]` getSignature();

##### getGasPrice

the gas price provided by the sender. 

 > public `long` getGasPrice();

##### getGas

the gas provided by the sender. 

 > public `long` getGas();


#### class TransactionReceipt

represents a Transaction receipt in ethereum. 

##### getBlockHash

the blockhash of the block containing this transaction. 

 > public `String` getBlockHash();

##### getBlockNumber

the block number of the block containing this transaction. 

 > public `long` getBlockNumber();

##### getCreatedContractAddress

the address of the deployed contract (if successfull) 

 > public `String` getCreatedContractAddress();

##### getFrom

the address of the sender. 

 > public `String` getFrom();

##### getTransactionHash

the Transaction hash. 

 > public `String` getTransactionHash();

##### getTransactionIndex

the Transaction index. 

 > public `int` getTransactionIndex();

##### getTo

20 Bytes - The address of the receiver. 

null when it's a contract creation transaction. 

 > public `String` getTo();

##### getGasUsed

The amount of gas used by this specific transaction alone. 

 > public `long` getGasUsed();

##### getLogs

Array of log objects, which this transaction generated. 

 > public [`Log[]`](#class-log) getLogs();

##### getLogsBloom

256 Bytes - A bloom filter of logs/events generated by contracts during transaction execution. 

Used to efficiently rule out transactions without expected logs 

 > public `String` getLogsBloom();

##### getRoot

32 Bytes - Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork EIP609). 

 > public `String` getRoot();

##### getStatus

success of a Transaction. 

true indicates transaction failure , false indicates transaction success. Set for blocks mined after Byzantium hard fork EIP609, null before. 

 > public `boolean` getStatus();


#### class TransactionRequest

represents a Transaction Request which should be send or called. 

##### getFrom

 > public `String` getFrom();

##### setFrom

 > public `void` setFrom([`String`](#class-string) from);

arguments:
```eval_rst
========== ========== 
``String``  **from**  
========== ========== 
```
##### getTo

 > public `String` getTo();

##### setTo

 > public `void` setTo([`String`](#class-string) to);

arguments:
```eval_rst
========== ======== 
``String``  **to**  
========== ======== 
```
##### getValue

 > public `BigInteger` getValue();

##### setValue

 > public `void` setValue([`BigInteger`](#class-biginteger) value);

arguments:
```eval_rst
============== =========== 
``BigInteger``  **value**  
============== =========== 
```
##### getNonce

 > public `long` getNonce();

##### setNonce

 > public `void` setNonce([`long`](#class-long) nonce);

arguments:
```eval_rst
======== =========== 
``long``  **nonce**  
======== =========== 
```
##### getGas

 > public `long` getGas();

##### setGas

 > public `void` setGas([`long`](#class-long) gas);

arguments:
```eval_rst
======== ========= 
``long``  **gas**  
======== ========= 
```
##### getGasPrice

 > public `long` getGasPrice();

##### setGasPrice

 > public `void` setGasPrice([`long`](#class-long) gasPrice);

arguments:
```eval_rst
======== ============== 
``long``  **gasPrice**  
======== ============== 
```
##### getFunction

 > public `String` getFunction();

##### setFunction

 > public `void` setFunction([`String`](#class-string) function);

arguments:
```eval_rst
========== ============== 
``String``  **function**  
========== ============== 
```
##### getParams

 > public `Object[]` getParams();

##### setParams

 > public `void` setParams([`Object[]`](#class-object[]) params);

arguments:
```eval_rst
============ ============ 
``Object[]``  **params**  
============ ============ 
```
##### setData

 > public `void` setData([`String`](#class-string) data);

arguments:
```eval_rst
========== ========== 
``String``  **data**  
========== ========== 
```
##### getData

creates the data based on the function/params values. 

 > public `String` getData();

##### getTransactionJson

 > public `String` getTransactionJson();

##### getResult

 > public `Object` getResult([`String`](#class-string) data);

arguments:
```eval_rst
========== ========== 
``String``  **data**  
========== ========== 
```

#### enum ENSMethod

The enum type contains the following values:

```eval_rst
============== = 
 **addr**      0 
 **resolver**  1 
 **hash**      2 
 **owner**     3 
============== = 
```

## Package in3.ipfs

#### class API

API for ipfs custom methods. 

To be used along with "Chain.IPFS" on in3 instance. 

##### API

creates a ipfs.API using the given incubed instance. 

 > public  API([`IN3`](#class-in3) in3);

arguments:
```eval_rst
=================== ========= 
`IN3 <#class-in3>`_  **in3**  
=================== ========= 
```
##### get

Returns the content associated with specified multihash on success OR NULL on error. 

 > public `byte[]` get([`String`](#class-string) multihash);

arguments:
```eval_rst
========== =============== 
``String``  **multihash**  
========== =============== 
```
##### put

Returns the IPFS multihash of stored content on success OR NULL on error. 

 > public `String` put([`String`](#class-string) content);

arguments:
```eval_rst
========== ============= 
``String``  **content**  
========== ============= 
```
##### put

Returns the IPFS multihash of stored content on success OR NULL on error. 

 > public `String` put([`byte[]`](#class-byte[]) content);

arguments:
```eval_rst
========== ============= 
``byte[]``  **content**  
========== ============= 
```

## Package in3.ipfs.API

#### enum Enconding

The enum type contains the following values:

```eval_rst
============ = 
 **base64**  0 
 **hex**     1 
 **utf8**    2 
============ = 
```

## Package in3.utils

#### class Account

Pojo that represents the result of an ecrecover operation (see: Crypto class). 

##### getAddress

address from ecrecover operation. 

 > public `String` getAddress();

##### getPublicKey

public key from ecrecover operation. 

 > public `String` getPublicKey();


#### class Crypto

a Wrapper for crypto-related helper functions. 

##### Crypto

 > public  Crypto([`IN3`](#class-in3) in3);

arguments:
```eval_rst
=================== ========= 
`IN3 <#class-in3>`_  **in3**  
=================== ========= 
```
##### signData

returns a signature given a message and a key. 

 > public [`Signature`](#class-signature) signData([`String`](#class-string) msg, [`String`](#class-string) key, [`SignatureType`](#class-signaturetype) sigType);

arguments:
```eval_rst
======================================= ============= 
``String``                               **msg**      
``String``                               **key**      
`SignatureType <#class-signaturetype>`_  **sigType**  
======================================= ============= 
```
##### decryptKey

 > public `String` decryptKey([`String`](#class-string) key, [`String`](#class-string) passphrase);

arguments:
```eval_rst
========== ================ 
``String``  **key**         
``String``  **passphrase**  
========== ================ 
```
##### pk2address

extracts the public address from a private key. 

 > public `String` pk2address([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= 
``String``  **key**  
========== ========= 
```
##### pk2public

extracts the public key from a private key. 

 > public `String` pk2public([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= 
``String``  **key**  
========== ========= 
```
##### ecrecover

extracts the address and public key from a signature. 

 > public [`Account`](#class-account) ecrecover([`String`](#class-string) msg, [`String`](#class-string) sig);

arguments:
```eval_rst
========== ========= 
``String``  **msg**  
``String``  **sig**  
========== ========= 
```
##### ecrecover

extracts the address and public key from a signature. 

 > public [`Account`](#class-account) ecrecover([`String`](#class-string) msg, [`String`](#class-string) sig, [`SignatureType`](#class-signaturetype) sigType);

arguments:
```eval_rst
======================================= ============= 
``String``                               **msg**      
``String``                               **sig**      
`SignatureType <#class-signaturetype>`_  **sigType**  
======================================= ============= 
```
##### signData

returns a signature given a message and a key. 

 > public [`Signature`](#class-signature) signData([`String`](#class-string) msg, [`String`](#class-string) key);

arguments:
```eval_rst
========== ========= 
``String``  **msg**  
``String``  **key**  
========== ========= 
```

#### class JSON

internal helper tool to represent a JSON-Object. 

Since the internal representation of JSON in incubed uses hashes instead of name, the getter will creates these hashes. 

##### get

gets the property 

 > public `Object` get([`String`](#class-string) prop);

arguments:
```eval_rst
========== ========== =========================
``String``  **prop**  the name of the property.
========== ========== =========================
```
returns: `Object` : the raw object. 



##### put

adds values. 

This function will be called from the JNI-Iterface.

Internal use only! 

 > public `void` put([`int`](#class-int) key, [`Object`](#class-object) val);

arguments:
```eval_rst
========== ========= ===================
``int``     **key**  the hash of the key
``Object``  **val**  the value object
========== ========= ===================
```
##### getLong

returns the property as long 

 > public `long` getLong([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
returns: `long` : the long value 



##### getBigInteger

returns the property as BigInteger 

 > public `BigInteger` getBigInteger([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
returns: `BigInteger` : the BigInteger value 



##### getStringArray

returns the property as StringArray 

 > public `String[]` getStringArray([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
returns: `String[]` : the array or null 



##### getString

returns the property as String or in case of a number as hexstring. 

 > public `String` getString([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
returns: `String` : the hexstring 



##### toString

 > public `String` toString();

##### hashCode

 > public `int` hashCode();

##### equals

 > public `boolean` equals([`Object`](#class-object) obj);

arguments:
```eval_rst
========== ========= 
``Object``  **obj**  
========== ========= 
```
##### asStringArray

casts the object to a String[] 

 > public static `String[]` asStringArray([`Object`](#class-object) o);

arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```
##### asBigInteger

 > public static `BigInteger` asBigInteger([`Object`](#class-object) o);

arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```
##### asLong

 > public static `long` asLong([`Object`](#class-object) o);

arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```
##### asInt

 > public static `int` asInt([`Object`](#class-object) o);

arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```
##### asString

 > public static `String` asString([`Object`](#class-object) o);

arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```
##### toJson

 > public static `String` toJson([`Object`](#class-object) ob);

arguments:
```eval_rst
========== ======== 
``Object``  **ob**  
========== ======== 
```
##### appendKey

 > public static `void` appendKey([`StringBuilder`](#class-stringbuilder) sb, [`String`](#class-string) key, [`Object`](#class-object) value);

arguments:
```eval_rst
================= =========== 
``StringBuilder``  **sb**     
``String``         **key**    
``Object``         **value**  
================= =========== 
```

#### class Signature

##### getMessage

 > public `String` getMessage();

##### getMessageHash

 > public `String` getMessageHash();

##### getSignature

 > public `String` getSignature();

##### getR

 > public `String` getR();

##### getS

 > public `String` getS();

##### getV

 > public `long` getV();


#### class TempStorageProvider

a simple Storage Provider storing the cache in the temp-folder. 

##### getItem

returns a item from cache () 

 > public `byte[]` getItem([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= ====================
``String``  **key**  the key for the item
========== ========= ====================
```
returns: `byte[]` : the bytes or null if not found. 



##### setItem

stores a item in the cache. 

 > public `void` setItem([`String`](#class-string) key, [`byte[]`](#class-byte[]) content);

arguments:
```eval_rst
========== ============= ====================
``String``  **key**      the key for the item
``byte[]``  **content**  the value to store
========== ============= ====================
```
##### clear

clear the cache. 

 > public `boolean` clear();


#### enum SignatureType

The enum type contains the following values:

```eval_rst
============== = 
 **eth_sign**  0 
 **raw**       1 
 **hash**      2 
============== = 
```

#### interface Signer

a Interface responsible for signing data or transactions. 

##### prepareTransaction

optiional method which allows to change the transaction-data before sending it. 

This can be used for redirecting it through a multisig. 

 > public [`TransactionRequest`](#class-transactionrequest) prepareTransaction([`IN3`](#class-in3) in3, [`TransactionRequest`](#class-transactionrequest) tx);

arguments:
```eval_rst
================================================= ========= 
`IN3 <#class-in3>`_                                **in3**  
`TransactionRequest <#class-transactionrequest>`_  **tx**   
================================================= ========= 
```
##### canSign

returns true if the account is supported (or unlocked) 

 > public `boolean` canSign([`String`](#class-string) address);

arguments:
```eval_rst
========== ============= 
``String``  **address**  
========== ============= 
```
##### sign

signing of the raw data. 

 > public `String` sign([`String`](#class-string) data, [`String`](#class-string) address);

arguments:
```eval_rst
========== ============= 
``String``  **data**     
``String``  **address**  
========== ============= 
```

#### interface StorageProvider

Provider methods to cache data. 

These data could be nodelists, contract codes or validator changes. 

##### getItem

returns a item from cache () 

 > public `byte[]` getItem([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= ====================
``String``  **key**  the key for the item
========== ========= ====================
```
returns: `byte[]` : the bytes or null if not found. 



##### setItem

stores a item in the cache. 

 > public `void` setItem([`String`](#class-string) key, [`byte[]`](#class-byte[]) content);

arguments:
```eval_rst
========== ============= ====================
``String``  **key**      the key for the item
``byte[]``  **content**  the value to store
========== ============= ====================
```
##### clear

clear the cache. 

 > public `boolean` clear();


