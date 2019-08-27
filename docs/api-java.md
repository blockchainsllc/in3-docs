# API Reference Java

## Installing

The Incubed Java client uses JNI to call native functions, but all the native libraries are bundled inside the jar file. This jar file has **no** dependencies and can even be used as a standalone, as in the following example:

```c
java -cp in3.jar in3.IN3 eth_getBlockByNumber latest false
```
### Downloading

Just download the latest jar-file [here](_downloads/in3.jar).

### Building

To build the shared library, you need to enable Java by using the `-DJAVA=true` flag:

```c
git clone git@github.com:slockit/in3-core.git
mkdir -p in3-core/build
cd in3-core/build
cmake -DJAVA=true .. && make
```

You will find the `in3.jar` in the build/lib folder.

### Android

To use Incubed in Android, simply follow these steps:

Step 1: Create a top-level CMakeLists.txt in Android projects inside the app folder and link this to Gradle. Follow the steps using this [guide](https://developer.android.com/studio/projects/gradle-external-native-builds) on how to link.

The content of the `CMakeLists.txt` should look like this:

```c
cmake_minimum_required(VERSION 3.4.1)

# turn off FAST_MATH in the EVM
ADD_DEFINITIONS(-DIN3_MATH_LITE)

# loop through the required module and create the build folders
for each (module 
  core 
  verifier/eth1/nano 
  verifier/eth1/evm 
  verifier/eth1/basic 
  verifier/eth1/full 
  bindings/java
  third-party/crypto 
  third-party/tommath 
  api/eth1)
        file(MAKE_DIRECTORY in3-core/src/${module}/outputs)
        add_subdirectory( in3-core/src/${module} in3-core/src/${module}/outputs )
endforeach()
```

Step 2: Clone [in3-core](https://git.slock.it/in3/c/in3-core.git) into the `app` folder or use this script to clone and update Incubed:

```c
#!/usr/bin/env sh

#github-url for in3-core
IN3_SRC=git@github.com:SlockItEarlyAccess/in3-core.git

cd app

# if it exists, we only call git pull
if [ -d in3-core ]; then
    cd in3-core
    git pull
    cd ..
else
# if not, we clone it
    git clone $IN3_SRC
fi

# copy the Java sources to the main Java path
cp -r in3-core/src/bindings/java/in3 src/main/java/

# but not the native libs, since these will be built
rm -rf src/main/java/in3/native
```

Step 3: Use the methods available in app/src/main/java/in3/IN3.java from Android activity to access Incubed functions.

Here is an example of how to use it:

[https://github.com/SlockItEarlyAccess/in3-android-example](https://github.com/SlockItEarlyAccess/in3-android-example)

## Examples

### Using Incubed Directly

```c
import in3.IN3;

public class HelloIN3 {  
   // 
   public static void main(String[] args) {
       String blockNumber = args[0]; 

       // create Incubed
       IN3 in3 = new IN3();

       // configure
       in3.setChainId(0x1);  // set it to mainnet (which is also the default)

       // execute the request
       String jsonResult = in3.sendRPC("eth_getBlockByNumber",new Object[]{ blockNumber ,true});

       ....
   }
}
```

### Using the API

Incubed also offers an API for getting information directly in a structured way.

#### Reading Blocks

```c
import java.util.*;
import in3.*;
import in3.eth1.*;

public class HelloIN3 {  
   // 
    public static void main(String[] args) throws Exception {
        // create Incubed
        IN3 in3 = new IN3();

        // configure
        in3.setChainId(0x1); // set it to mainnet (which is also the default)

        // read the latest block, including all transactions
        Block latestBlock = in3.getEth1API().getBlockByNumber(Block.LATEST, true);

        // use the getters to retrieve all containing data
        System.out.println("current BlockNumber : " + latestBlock.getNumber());
        System.out.println("minded at : " + new Date(latestBlock.getTimeStamp()) + " by " + latestBlock.getAuthor());

        // get all transactions from the block
        Transaction[] transactions = latestBlock.getTransactions();

        BigInteger sum = BigInteger.valueOf(0);
        for (int i = 0; i < transactions.length; i++)
            sum = sum.add(transactions[i].getValue());

        System.out.println("total Value transfered in all Transactions : " + sum + " wei");
    }

}
```

#### Calling Functions of Contracts

The following example shows how to call functions and use the decoded results. Here we get the structure from the registry.

```c
import in3.*;
import in3.eth1.*;

public class HelloIN3 {  
   // 
   public static void main(String[] args) {
       // create Incubed
       IN3 in3 = new IN3();

       // configure
       in3.setChainId(0x1);  // set it to mainnet (which is also the default)

       // call a contract, which uses eth_call to get the result
       Object[] result = (Object[]) in3.getEth1API().call(                      // call a function of a contract
            "0x2736D225f85740f42D17987100dc8d58e9e16252",                       // address of the contract
            "servers(uint256):(string,address,uint256,uint256,uint256,address)",// function signature
            1);                                                                 // first argument, which is the index of the node we are looking for

        System.out.println("url     : " + result[0]);
        System.out.println("owner   : " + result[1]);
        System.out.println("deposit : " + result[2]);
        System.out.println("props   : " + result[3]);


       ....
   }
}
```

#### Sending Transactions

To send, you need a signer. The SimpleWallet class is a basic implementation that can be used.

```c
package in3;

import java.io.IOException;
import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

import in3.*;
import in3.eth1.*;

public class Example {
    //
    public static void main(String[] args) throws IOException{
        // create Incubed
        IN3 in3 = new IN3();

        // configure
        in3.setChainId(0x1); // set it to mainnet (which is also the default)

        // create a wallet managing the private keys
        SimpleWallet wallet = new SimpleWallet();

        // add accounts by adding the private keys
        String keyFile = "myKey.json";
        String myPassphrase = "<secrect>";

        // read the key file and decode the private key
        String account = wallet.addKeyStore(new String(Files.readAllBytes(Paths.get(keyFile)), StandardCharsets.UTF_8),
                myPassphrase);

        // use the wallet as signer
        in3.setSigner(wallet);

        String recipient = "0x1234567890123456789012345678901234567890";
        BigInteger value = BigInteger.valueOf(100000);

        // create a transaction
        TransactionRequest tx = new TransactionRequest();
        tx.from = account;
        tx.to = "0x1234567890123456789012345678901234567890";
        tx.function = "transfer(address,uint256)";
        tx.params = new Object[] { receipient, value };

        String txHash = in3.getEth1API().sendTransaction(tx);

        System.out.println("Transaction sent with hash = " + txHash);

    }
}
```

## Package Incubed

#### Class Example

##### main

 > public static `void` main([`String[]`](#class-string[]) args);

Arguments:
```eval_rst
============= ========== 
``String []``  **args**  
============= ========== 
```

#### class IN3

This is the main class creating the Incubed client.

The client can then be configured.

##### getCacheTimeout

The number of seconds requests can be cached.

 > public `native int` getCacheTimeout();

##### setCacheTimeout

Sets the number of seconds requests can be cached.

 > public `native void` setCacheTimeout([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```

##### getNodeLimit

The limit of nodes to store in the client.

 > public `native int` getNodeLimit();

##### setNodeLimit

Sets the limit of nodes to store in the client.

 > public `native void` setNodeLimit([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getKey

The client key to sign requests.

 > public `native byte []` getKey();

##### setKey

Sets the client key to sign requests.

 > public `native void` setKey([`byte[]`](#class-byte[]) val);

Arguments:
```eval_rst
=========== ========= 
``byte []``  **val**  
=========== ========= 
```

##### setKey

Sets the client key as hexstring to sign requests.

 > public `void` setKey([`String`](#class-string) val);

Arguments:
```eval_rst
========== ========= 
``String``  **val**  
========== ========= 
```

##### getMaxCodeCache

Number of max bytes used to cache the code in memory.

 > public `native int` getMaxCodeCache();

##### setMaxCodeCache

Sets number of max bytes used to cache the code in memory.

 > public `native void` setMaxCodeCache([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getMaxBlockCache

Number of blocks cached in memory.

 > public `native int` getMaxBlockCache();

##### setMaxBlockCache

Sets the number of blocks cached in memory.

 > public `native void` setMaxBlockCache([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```

##### getProof

The type of proof used.

 > public [`Proofnative `](#class-proof) getProof();

##### setProof

Sets the type of proof used.

 > public `native void` setProof([`Proof`](#class-proof) val);

Arguments:
```eval_rst
======================= ========= 
`Proof <#class-proof>`_  **val**  
======================= ========= 
```

##### getRequestCount

The number of requests sent when getting a first answer.

 > public `native int` getRequestCount();

##### setRequestCount

Sets the number of requests sent when getting a first answer.

 > public `native void` setRequestCount([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```

##### getSignatureCount

The number of signatures used to proof the blockhash.

 > public `native int` getSignatureCount();

##### setSignatureCount

Sets the number of signatures used to proof the blockhash.

 > public `native void` setSignatureCount([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```

##### getMinDeposit

Minimum stake of the server.

Only nodes owning at least this amount will be chosen.

 > public `native long` getMinDeposit();

##### setMinDeposit

Sets minimum stake of the server.

Only nodes owning at least this amount will be chosen.

 > public `native void` setMinDeposit([`long`](#class-long) val);

Arguments:
```eval_rst
======== ========= 
``long``  **val**  
======== ========= 
```

##### getReplaceLatestBlock

If specified, the blockNumber "latest" will be replaced by blockNumber-(specified value).

 > public `native int` getReplaceLatestBlock();

##### setReplaceLatestBlock

Replaces the "latest" with blockNumber-(specified value).

 > public `native void` setReplaceLatestBlock([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```

##### getFinality

The number of signatures in percent required for the request.

 > public `native int` getFinality();

##### setFinality

Sets the number of signatures in percent required for the request.

 > public `native void` setFinality([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```

##### getMaxAttempts

The max number of attempts before giving up.

 > public `native int` getMaxAttempts();

##### setMaxAttempts

Sets the max number of attempts before giving up.

 > public `native void` setMaxAttempts([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```

##### getSigner

Returns the signer or wallet.

 > public [`Signer`](#class-signer) getSigner();

##### getEth1API

Gets the Ethereum API.

 > public [`in3.eth1.API`](#class-in3.eth1.api) getEth1API();

##### setSigner

Sets the signer or wallet.

 > public `void` setSigner([`Signer`](#class-signer) signer);

Arguments:
```eval_rst
========================= ============ 
`Signer <#class-signer>`_  **signer**  
========================= ============ 
```

##### getTimeout

Specifies the number of milliseconds before the request times out.

Increasing may be helpful if the device uses a slow connection.

 > public `native int` getTimeout();

##### setTimeout

Specifies the number of milliseconds before the request times out.

Increasing may be helpful if the device uses a slow connection.

 > public `native void` setTimeout([`int`](#class-int) val);

Arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```

##### getChainId

Servers to filter for the given chain.

The chainId based on EIP 155.

 > public `native long` getChainId();

##### setChainId

Sets the chain to be used.

The chainId based on EIP 155.

 > public `native void` setChainId([`long`](#class-long) val);

Arguments:
```eval_rst
======== ========= 
``long``  **val**  
======== ========= 
```

##### isAutoUpdateList

If true, the NodeList will be automatically updated if the lastBlock is newer.

 > public `native boolean` isAutoUpdateList();

##### setAutoUpdateList

Activates the auto update. If true, the NodeList will be automatically updated if the lastBlock is newer.

 > public `native void` setAutoUpdateList([`boolean`](#class-boolean) val);

Arguments:
```eval_rst
=========== ========= 
``boolean``  **val**  
=========== ========= 
```

##### getStorageProvider

Provides the ability to cache content.

 > public [`StorageProvider`](#class-storageprovider) getStorageProvider();

##### setStorageProvider

Provides the ability to cache content like NodeLists, contract codes, and validatorlists.

 > public `void` setStorageProvider([`StorageProvider`](#class-storageprovider) val);

Arguments:
```eval_rst
=========================================== ========= 
`StorageProvider <#class-storageprovider>`_  **val**  
=========================================== ========= 
```

##### send

Sends a request. 

The request must be a valid JSON-string with method and params.

 > public `native String` send([`String`](#class-string) request);

Arguments:
```eval_rst
========== ============= 
``String``  **request**  
========== ============= 
```

##### sendobject

Sends a request but returns an object, such as an array or map, with the parsed response.

The request must be a valid JSON-string with method and params.

 > public `native Object` sendobject([`String`](#class-string) request);

Arguments:
```eval_rst
========== ============= 
``String``  **request**  
========== ============= 
```

##### sendRPC

Sends an RPC request by only passing the method and params.

It will create the raw request from it and return the result.

 > public `String` sendRPC([`String`](#class-string) method, [`Object[]`](#class-object[]) params);

Arguments:
```eval_rst
============= ============ 
``String``     **method**  
``Object []``  **params**  
============= ============ 
```

##### sendRPCasObject

Sends an RPC request by only passing the method and params.

It will create the raw request from it and return the result.

 > public `Object` sendRPCasObject([`String`](#class-string) method, [`Object[]`](#class-object[]) params);

Arguments:
```eval_rst
============= ============ 
``String``     **method**  
``Object []``  **params**  
============= ============ 
```

##### IN3

Constructor. 

Creates a new Incubed client.

 > public  IN3();

##### main

 > public static `void` main([`String[]`](#class-string[]) args);

Arguments:
```eval_rst
============= ========== 
``String []``  **args**  
============= ========== 
```

#### class JSON

Internal helper tool to represent a JSON-Object.

Since the internal representation of JSON in Incubed uses hashes instead of names, the getter will create these hashes.

##### get

Gets the property.

 > public `Object` get([`String`](#class-string) prop);

Arguments:
```eval_rst
========== ========== =========================
``String``  **prop**  the name of the property.
========== ========== =========================
```
Returns: `Object`: the raw object. 

##### put

Adds values.

This function will be called from the JNI-Interface.

For internal use only!

 > public `void` put([`int`](#class-int) key, [`Object`](#class-object) val);

Arguments:
```eval_rst
========== ========= ===================
``int``     **key**  the hash of the key
``Object``  **val**  the value object
========== ========= ===================
```

##### getLong

Returns the property as long.

 > public `long` getLong([`String`](#class-string) key);

Arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
Returns: `long`: the long value. 

##### getBigInteger

Returns the property as BigInteger.

 > public `BigInteger` getBigInteger([`String`](#class-string) key);

Arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
Returns: `BigInteger`: the BigInteger value.

##### getStringArray

Returns the property as StringArray.

 > public `String []` getStringArray([`String`](#class-string) key);

Arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
Returns: `String []`: the array or null.

##### getString

Returns the property as string or, in case of a number, as hexstring.

 > public `String` getString([`String`](#class-string) key);

Arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
Returns: `String`: the hexstring.

##### asStringArray

 > public `String []` asStringArray([`Object`](#class-object) o);

Arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```

##### toString

 > public `String` toString();

##### asBigInteger

 > public static `BigInteger` asBigInteger([`Object`](#class-object) o);

Arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```

##### asLong

 > public static `long` asLong([`Object`](#class-object) o);

Arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```

##### asInt

 > public static `int` asInt([`Object`](#class-object) o);

Arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```

##### asString

 > public static `String` asString([`Object`](#class-object) o);

Arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```

##### toJson

 > public static `String` toJson([`Object`](#class-object) ob);

Arguments:
```eval_rst
========== ======== 
``Object``  **ob**  
========== ======== 
```

##### appendKey

 > public static `void` appendKey([`StringBuilder`](#class-stringbuilder) sb, [`String`](#class-string) key, [`Object`](#class-object) value);

Arguments:
```eval_rst
================= =========== 
``StringBuilder``  **sb**     
``String``         **key**    
``Object``         **value**  
================= =========== 
```

#### class Loader

##### loadLibrary

 > public static `void` loadLibrary();

#### class TempStorageProvider

A simple storage provider storing the cache in the temp-folder.

##### getItem

Returns an item from cache ().

 > public `byte []` getItem([`String`](#class-string) key);

Arguments:
```eval_rst
========== ========= 
``String``  **key**  
========== ========= 
```
Returns: `byte []`: the bytes or null if not found.

##### setItem

Stores an item in the cache.

 > public `void` setItem([`String`](#class-string) key, [`byte[]`](#class-byte[]) content);

Arguments:
```eval_rst
=========== ============= 
``String``   **key**      
``byte []``  **content**  
=========== ============= 
```

#### enum Proof

The proof type indicating how much proof is required.

The enum type contains the following values:

```eval_rst
============== = =====================================================================
 **none**      0 No verification.
 **standard**  1 Standard verification of the important properties.
 **full**      2 Full verification, including uncles, which leads to a higher payload.
============== = =====================================================================
```

#### interface Signer

An interface responsible for signing data or transactions.

##### prepareTransaction

Optional method that allows you to change the transaction data before sending it.

This can be used for redirecting it through a multisig.

 > public [`TransactionRequest`](#class-transactionrequest) prepareTransaction([`IN3`](#class-in3) in3, [`TransactionRequest`](#class-transactionrequest) tx);

Arguments:
```eval_rst
================================================= ========= 
`IN3 <#class-in3>`_                                **in3**  
`TransactionRequest <#class-transactionrequest>`_  **tx**   
================================================= ========= 
```

##### hasAccount

Returns true if the account is supported (or unlocked).

 > public `boolean` hasAccount([`String`](#class-string) address);

Arguments:
```eval_rst
========== ============= 
``String``  **address**  
========== ============= 
```

##### sign

Signing of the raw data.

 > public `String` sign([`String`](#class-string) data, [`String`](#class-string) address);

Arguments:
```eval_rst
========== ============= 
``String``  **data**     
``String``  **address**  
========== ============= 
```

#### interface StorageProvider

Provides methods to cache data.

These data could be NodeLists, contract codes, or validator changes.

##### getItem

Returns an item from cache ().

 > public `byte []` getItem([`String`](#class-string) key);

Arguments:
```eval_rst
========== ========= ====================
``String``  **key**  the key for the item
========== ========= ====================
```
Returns: `byte []`: the bytes or null if not found.

##### setItem

Stores an item in the cache.

 > public `void` setItem([`String`](#class-string) key, [`byte[]`](#class-byte[]) content);

Arguments:
```eval_rst
=========== ============= ====================
``String``   **key**      the key for the item
``byte []``  **content**  the value to store
=========== ============= ====================
```

## Package in3.eth1

#### class API

A wrapper for the Incubed client offering type-safe access and additional helper functions.

##### API

Creates an API using the given Incubed instance.

 > public  API([`IN3`](#class-in3) in3);

Arguments:
```eval_rst
=================== ========= 
`IN3 <#class-in3>`_  **in3**  
=================== ========= 
```

##### getBlockByNumber

Finds the block as specified by the number.

Uses `Block.LATEST` for getting the lastest block.

 > public [`Block`](#class-block) getBlockByNumber([`long`](#class-long) block, [`boolean`](#class-boolean) includeTransactions);

Arguments:
```eval_rst
=========== ========================= ================================================================================================
``long``     **block**                
``boolean``  **includeTransactions**  < the blockNumber < if true, all transactions will be included; if not, only the transaction hashes
=========== ========================= ================================================================================================
```

##### getBlockByHash

Returns information about a block by hash.

 > public [`Block`](#class-block) getBlockByHash([`String`](#class-string) blockHash, [`boolean`](#class-boolean) includeTransactions);

Arguments:
```eval_rst
=========== ========================= ================================================================================================
``String``   **blockHash**            
``boolean``  **includeTransactions**  < the blockNumber < if true, all transactions will be included; if not, only the transaction hashes
=========== ========================= ================================================================================================
```

##### getBlockNumber

The current blockNumber.

 > public `long` getBlockNumber();

##### getGasPrice

The current gas price. 

 > public `long` getGasPrice();

##### getChainId

Returns the EIP 155 chainId used for transaction signing at the currently best block.

Null is returned if not available.

 > public `String` getChainId();

##### call

Calls a function of a smart contract and returns the result.

 > public `Object` call([`TransactionRequest`](#class-transactionrequest) request, [`long`](#class-long) block);

Arguments:
```eval_rst
================================================= ============= =============================================================
`TransactionRequest <#class-transactionrequest>`_  **request**  
``long``                                           **block**    < the transaction to call < the block used for the state
================================================= ============= =============================================================
```
Returns: `Object`: the decoded result. If only one return value is expected, the object will be returned. If not, an array of objects will be the result. 

##### estimateGas

Makes a call or transaction that won't be added to the blockchain, as well as returns the used gas, which can be used for estimating the used gas.

 > public `long` estimateGas([`TransactionRequest`](#class-transactionrequest) request, [`long`](#class-long) block);

Arguments:
```eval_rst
================================================= ============= =============================================================
`TransactionRequest <#class-transactionrequest>`_  **request**  
``long``                                           **block**    < the transaction to call < the block used for the state
================================================= ============= =============================================================
```
Returns: `long`: the gas required to call the function.

##### getBalance

Returns the balance of the account of a given address in wei.

 > public `BigInteger` getBalance([`String`](#class-string) address, [`long`](#class-long) block);

Arguments:
```eval_rst
========== ============= 
``String``  **address**  
``long``    **block**    
========== ============= 
```
##### getCode

Returns code at a given address.

 > public `String` getCode([`String`](#class-string) address, [`long`](#class-long) block);

Arguments:
```eval_rst
========== ============= 
``String``  **address**  
``long``    **block**    
========== ============= 
```

##### getStorageAt

Returns the value from a storage position at a given address.

 > public `String` getStorageAt([`String`](#class-string) address, [`BigInteger`](#class-biginteger) position, [`long`](#class-long) block);

Arguments:
```eval_rst
============== ============== 
``String``      **address**   
``BigInteger``  **position**  
``long``        **block**     
============== ============== 
```

##### getBlockTransactionCountByHash

Returns the number of transactions in a block from a block matching the given blockhash.

 > public `long` getBlockTransactionCountByHash([`String`](#class-string) blockHash);

Arguments:
```eval_rst
========== =============== 
``String``  **blockHash**  
========== =============== 
```

##### getBlockTransactionCountByNumber

Returns the number of transactions in a block from a block matching the given blockNumber.

 > public `long` getBlockTransactionCountByNumber([`long`](#class-long) block);

Arguments:
```eval_rst
======== =========== 
``long``  **block**  
======== =========== 
```

##### getFilterChangesFromLogs

Polling method for a filter, which returns an array of logs that occurred since the last poll.

 > public [`Log []`](#class-log) getFilterChangesFromLogs([`long`](#class-long) id);

Arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```

##### getFilterChangesFromBlocks

Polling method for a filter, which returns an array of logs that occurred since the last poll.

 > public [`Block []`](#class-block) getFilterChangesFromBlocks([`long`](#class-long) id);

Arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```

##### getFilterLogs

Polling method for a filter, which returns an array of logs that occurred since the last poll.

 > public [`Log []`](#class-log) getFilterLogs([`long`](#class-long) id);

Arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```
##### getLogs

Polling method for a filter, which returns an array of logs that occurred since the last poll.

 > public [`Log []`](#class-log) getLogs([`LogFilter`](#class-logfilter) filter);

Arguments:
```eval_rst
=============================== ============ 
`LogFilter <#class-logfilter>`_  **filter**  
=============================== ============ 
```

##### getTransactionByBlockHashAndIndex

Returns information about a transaction by blockhash and transaction index position.

 > public [`Transaction`](#class-transaction) getTransactionByBlockHashAndIndex([`String`](#class-string) blockHash, [`int`](#class-int) index);

Arguments:
```eval_rst
========== =============== 
``String``  **blockHash**  
``int``     **index**      
========== =============== 
```

##### getTransactionByBlockNumberAndIndex

Returns information about a transaction by blockNumber and transaction index position.

 > public [`Transaction`](#class-transaction) getTransactionByBlockNumberAndIndex([`long`](#class-long) block, [`int`](#class-int) index);

Arguments:
```eval_rst
======== =========== 
``long``  **block**  
``int``   **index**  
======== =========== 
```

##### getTransactionByHash

Returns information about a transaction requested by transaction hash.

 > public [`Transaction`](#class-transaction) getTransactionByHash([`String`](#class-string) transactionHash);

Arguments:
```eval_rst
========== ===================== 
``String``  **transactionHash**  
========== ===================== 
```

##### getTransactionCount

Returns the number of transactions sent from an address.

 > public `BigInteger` getTransactionCount([`String`](#class-string) address, [`long`](#class-long) block);

Arguments:
```eval_rst
========== ============= 
``String``  **address**  
``long``    **block**    
========== ============= 
```

##### getTransactionReceipt

Returns the number of transactions sent from an address.

 > public [`TransactionReceipt`](#class-transactionreceipt) getTransactionReceipt([`String`](#class-string) transactionHash);

Arguments:
```eval_rst
========== ===================== 
``String``  **transactionHash**  
========== ===================== 
```

##### getUncleByBlockNumberAndIndex

Returns information about an uncle of a blockNumber and uncle index position.

Note: An uncle doesn't contain individual transactions. 

 > public [`Block`](#class-block) getUncleByBlockNumberAndIndex([`long`](#class-long) block, [`int`](#class-int) pos);

Arguments:
```eval_rst
======== =========== 
``long``  **block**  
``int``   **pos**    
======== =========== 
```

##### getUncleCountByBlockHash

Returns the number of uncles in a block from a block matching the given blockhash.

 > public `long` getUncleCountByBlockHash([`String`](#class-string) block);

Arguments:
```eval_rst
========== =========== 
``String``  **block**  
========== =========== 
```

##### getUncleCountByBlockNumber

Returns the number of uncles in a block from a block matching the given blockhash.

 > public `long` getUncleCountByBlockNumber([`long`](#class-long) block);

Arguments:
```eval_rst
======== =========== 
``long``  **block**  
======== =========== 
```

##### newBlockFilter

Creates a filter in the node to notify when a new block arrives.

To check if the state has changed, call eth_getFilterChanges.

 > public `long` newBlockFilter();

##### newLogFilter

Creates a filter object, based on filter options, to notify when the state changes (logs).

To check if the state has changed, call eth_getFilterChanges.

A note on specifying topic filters: Topics are order-dependent. A transaction with a log with topics [A, B] will be matched by the following topic filters:

[] "anything" [A] "A in first position (and anything after)" [null, B] "anything in first position AND B in second position (and anything after)" [A, B] "A in first position AND B in second position (and anything after)" [[A, B], [A, B]] "(A OR B) in first position AND (A OR B) in second position (and anything after)" 

 > public `long` newLogFilter([`LogFilter`](#class-logfilter) filter);

Arguments:
```eval_rst
=============================== ============ 
`LogFilter <#class-logfilter>`_  **filter**  
=============================== ============ 
```

##### uninstallFilter

Uninstalls filter.

 > public `long` uninstallFilter([`long`](#class-long) filter);

Arguments:
```eval_rst
======== ============ 
``long``  **filter**  
======== ============ 
```

##### sendRawTransaction

Creates a new message call transaction or contract creation for signed transactions.

 > public `String` sendRawTransaction([`String`](#class-string) data);

Arguments:
```eval_rst
========== ========== 
``String``  **data**  
========== ========== 
```
Returns: `String`: transaction hash. 

##### sendTransaction

Sends a transaction as described by the transaction request.

This will require a signer to be set to sign the transaction.

 > public `String` sendTransaction([`TransactionRequest`](#class-transactionrequest) tx);

Arguments:
```eval_rst
================================================= ======== 
`TransactionRequest <#class-transactionrequest>`_  **tx**  
================================================= ======== 
```

##### call

The current gas price.

 > public `Object` call([`String`](#class-string) to, [`String`](#class-string) function, [`Object...`](#class-object...) params);

Arguments:
```eval_rst
============= ============== 
``String``     **to**        
``String``     **function**  
``Object...``  **params**    
============= ============== 
```
Returns: `Object`: the decoded result. If only one return value is expected, the object will be returned. If not, an array of objects will be the result. 

#### class Block

Represents a block in Ethereum.

##### LATEST

The latest blockNumber.

Type: static `long`

##### EARLIEST

The genesis block.

Type: static `long`

##### getTotalDifficulty

Returns the total difficulty as a sum of all difficulties, starting from genesis.

 > public `BigInteger` getTotalDifficulty();

##### getGasLimit

The gas limit of the block.

 > public `BigInteger` getGasLimit();

##### getExtraData

The extra data of the block.

 > public `String` getExtraData();

##### getDifficulty

The difficulty of the block.

 > public `BigInteger` getDifficulty();

##### getAuthor

The author or miner of the block.

 > public `String` getAuthor();

##### getTransactionsRoot

The roothash of the Merkle tree containing all transactions of the block.

 > public `String` getTransactionsRoot();

##### getTransactionReceiptsRoot

The roothash of the Merkle tree containing all transaction receipts of the block.

 > public `String` getTransactionReceiptsRoot();

##### getStateRoot

The roothash of the Merkle tree containing the complete state.

 > public `String` getStateRoot();

##### getTransactionHashes

The transaction hashes of the transactions in the block.

 > public `String []` getTransactionHashes();

##### getTransactions

The transactions of the block.

 > public [`Transaction []`](#class-transaction) getTransactions();

##### getTimeStamp

The Unix timestamp in seconds since 1970.

 > public `long` getTimeStamp();

##### getSha3Uncles

The roothash of the Merkle tree containing all uncles of the block.

 > public `String` getSha3Uncles();

##### getSize

The size of the block.

 > public `long` getSize();

##### getSealFields

The seal fields used for proof of authority.

 > public `String []` getSealFields();

##### getHash

The blockhash of the header.

 > public `String` getHash();

##### getLogsBloom

The Bloom filter of the block.

 > public `String` getLogsBloom();

##### getMixHash

The mix hash of the block.

(Only valid for proof of work.) 

 > public `String` getMixHash();

##### getNonce

The mix hash of the block.

(Only valid for proof of work.) 

 > public `String` getNonce();

##### getNumber

The blockNumber.

 > public `long` getNumber();

##### getParentHash

The hash of the parent block.

 > public `String` getParentHash();

##### getUncles

Returns the blockhashes of all uncle blocks.

 > public `String []` getUncles();

#### class Log

A log entry of a transaction receipt.

##### isRemoved

True when the log was removed, due to a chain reorganization.

False if it's a valid log.

 > public `boolean` isRemoved();

##### getLogIndex

Integer of the log index position in the block.

Null when it's a pending log.

 > public `int` getLogIndex();

##### getTransactionIndex

Integer of the transaction index position the log was created from.

Null when it's a pending log.

 > public `int` gettTansactionIndex();

##### getTransactionHash

Hash, 32 bytes; hash of the transactions this log was created from.

Null when it's a pending log.

 > public `String` getTransactionHash();

##### getBlockHash

Hash, 32 bytes; hash of the block where this log was in.

Null when it's a pending log.

 > public `String` getBlockHash();

##### getBlockNumber

The blockNumber where this log was in.

Null when it's a pending log.

 > public `long` getBlockNumber();

##### getAddress

20 bytes, address from which this log originated.

 > public `String` getAddress();

##### getTopics

Array of 0 to 4 32 bytes of data of indexed log arguments.

(In Solidity: The first topic is the hash of the signature of the event (e.g., Deposit(address,bytes32,uint256)), except if you declared the event with the anonymous specifier.)

 > public `String []` getTopics();

#### class LogFilter

Log configuration for search logs.

##### toString

Creates a JSON-String. 

 > public `String` toString();

#### class SimpleWallet

A simple implementation for holding private keys to sign data or transactions.

##### addRawKey

Adds a key to the wallet and returns its public address.

 > public `String` addRawKey([`String`](#class-string) data);

Arguments:
```eval_rst
========== ========== 
``String``  **data**  
========== ========== 
```

##### addKeyStore

Adds a key to the wallet and returns its public address.

 > public `String` addKeyStore([`String`](#class-string) jsonData, [`String`](#class-string) passphrase);

Arguments:
```eval_rst
========== ================ 
``String``  **jsonData**    
``String``  **passphrase**  
========== ================ 
```

##### prepareTransaction

Optional method that allows you to change the transaction data before sending it.

This can be used for redirecting it through a multisig.

 > public [`TransactionRequest`](#class-transactionrequest) prepareTransaction([`IN3`](#class-in3) in3, [`TransactionRequest`](#class-transactionrequest) tx);

Arguments:
```eval_rst
================================================= ========= 
`IN3 <#class-in3>`_                                **in3**  
`TransactionRequest <#class-transactionrequest>`_  **tx**   
================================================= ========= 
```

##### hasAccount

Returns true if the account is supported (or unlocked).

 > public `boolean` hasAccount([`String`](#class-string) address);

Arguments:
```eval_rst
========== ============= 
``String``  **address**  
========== ============= 
```

##### sign

Signing of the raw data.

 > public `String` sign([`String`](#class-string) data, [`String`](#class-string) address);

Arguments:
```eval_rst
========== ============= 
``String``  **data**     
``String``  **address**  
========== ============= 
```

#### class Transaction

Represents a transaction in Ethereum.

##### getBlockHash

The blockhash of the block containing this transaction.

 > public `String` getBlockHash();

##### getBlockNumber

The blockNumber of the block containing this transaction.

 > public `long` getBlockNumber();

##### getChainId

The chainId of this transaction.

 > public `String` getChainId();

##### getCreatedContractAddress

The address of the deployed contract (if successful).

 > public `String` getCreatedContractAddress();

##### getFrom

The address of the sender.

 > public `String` getFrom();

##### getHash

The transaction hash.

 > public `String` getHash();

##### getData

The transaction data or input data.

 > public `String` getData();

##### getNonce

The nonce used in the transaction.

 > public `long` getNonce();

##### getPublicKey

The public key of the sender.

 > public `String` getPublicKey();

##### getValue

The value sent in wei.

 > public `BigInteger` getValue();

##### getRaw

The raw transaction as RLP-encoded data.

 > public `String` getRaw();

##### getTo

The address of the recipient or contract.

 > public `String` getTo();

##### getSignature

The signature of the sender, an array of the [r, s, v].

 > public `String []` getSignature();

##### getGasPrice

The gas price provided by the sender.

 > public `long` getGasPrice();

##### getGas

The gas provided by the sender.

 > public `long` getGas();

#### class TransactionReceipt

Represents a transaction receipt in Ethereum.

##### getBlockHash

The blockhash of the block containing this transaction.

 > public `String` getBlockHash();

##### getBlockNumber

The blockNumber of the block containing this transaction.

 > public `long` getBlockNumber();

##### getCreatedContractAddress

The address of the deployed contract (if successful).

 > public `String` getCreatedContractAddress();

##### getFrom

The address of the sender.

 > public `String` getFrom();

##### getTransactionHash

The transaction hash.

 > public `String` getTransactionHash();

##### getTransactionIndex

The transaction index.

 > public `int` getTransactionIndex();

##### getTo

20 bytes, the address of the receiver. 

Null when it's a contract creation transaction. 

 > public `String` getTo();

##### getGasUsed

The amount of gas used by this specific transaction alone.

 > public `long` getGasUsed();

##### getLogs

Array of log objects that this transaction generated.

 > public [`Log []`](#class-log) getLogs();

##### getLogsBloom

256 bytes, a Bloom filter of logs/events generated by contracts during transaction execution.

Used to efficiently rule out transactions without expected logs.

 > public `String` getLogsBloom();

##### getRoot

32 bytes, Merkle root of the state trie after the transaction has been executed (optional after Byzantium hard fork, EIP 609).

 > public `String` getRoot();

##### getStatus

Success of a transaction.

True indicates transaction failure; false indicates transaction success. Set for blocks mined after Byzantium hard fork, EIP 609, null for before. 

 > public `boolean` getStatus();

#### class TransactionRequest

Represents a transaction request, which should be sent or called.

##### from

The from address.

Type: `String`

##### to

The recipient's address.

Type: `String`

##### data

The data.

Type: `String`

##### value

The value of the transaction.

Type: `BigInteger`

##### nonce

The nonce (transactionCount of the sender).

Type: `long`

##### gas

The gas to use.

Type: `long`

##### gasPrice

The gas price to use.

Type: `long`

##### function

The signature for the function to call.

Type: `String`

##### params

The params to use for encoding in the data.

Type: `Object []`

##### getData

Creates the data based on the function/params values.

 > public `String` getData();

##### getTransactionJson

 > public `String` getTransactionJson();

##### getResult

 > public `Object` getResult([`String`](#class-string) data);

Arguments:
```eval_rst
========== ========== 
``String``  **data**  
========== ========== 
```
