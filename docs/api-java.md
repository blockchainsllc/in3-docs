# API Reference Java


## Installing

The Incubed Java client uses JNI in order to call native functions. But all the native-libraries are bundled inside the jar-file. This jar file has **no** dependencies and can even be used as a standalone, as in the following example:

```c
java -cp in3.jar in3.IN3 eth_getBlockByNumber latest false
```
### Building

To build the shared library, you need to enable java by using the `-DJAVA=true` flag:

```c
git clone git@github.com:slockit/in3-core.git
mkdir -p in3-core/build
cd in3-core/build
cmake -DJAVA=true .. && make
```
You will find the `in3.jar` in the build/lib - folder.

### Android

In order to use Incubed in android, simply follow these steps:

Step 1: Create a top-level CMakeLists.txt in android project inside the app folder and link this to Gradle. Follow the steps using this [guide](https://developer.android.com/studio/projects/gradle-external-native-builds) on how to link.

The content of the `CMakeLists.txt` should look like this:

```c
cmake_minimum_required(VERSION 3.4.1)

# turn off FAST_MATH in the evm.
ADD_DEFINITIONS(-DIN3_MATH_LITE)

# loop through the required module and create the build-folders
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
Step 2: Clone [in3-core](https://git.slock.it/in3/c/in3-core.git) into the `app`-folder or use this script to clone and update Incubed:

```c
#!/usr/bin/env sh

#github-url for in3-core
IN3_SRC=git@github.com:SlockItEarlyAccess/in3-core.git

cd app

# if it exists we only call git pull
if [ -d in3-core ]; then
    cd in3-core
    git pull
    cd ..
else
# if not we clone it
    git clone $IN3_SRC
fi


# copy the java-sources to the main java path
cp -r in3-core/src/bindings/java/in3 src/main/java/
# but not the native libs, since these will be build
rm -rf src/main/java/in3/native
```
Step 3: Use the methods available in app/src/main/java/in3/IN3.java from android activity to access Incubed functions.

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

       // create incubed
       IN3 in3 = new IN3();

       // configure
       in3.setChainId(0x1);  // set it to mainnet (which is also dthe default)

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
#### Calling Functions of Contracts

The following example shows how to call functions and use the decoded results. Here we get the struct from the registry.

```c
import in3.*;
import in3.eth1.*;

public class HelloIN3 {  
   // 
   public static void main(String[] args) {
       // create incubed
       IN3 in3 = new IN3();

       // configure
       in3.setChainId(0x1);  // set it to mainnet (which is also dthe default)

       // call a contract, which uses eth_call to get the result. 
       Object[] result = (Object[]) in3.getEth1API().call(                                   // call a function of a contract
            "0x2736D225f85740f42D17987100dc8d58e9e16252",                       // address of the contract
            "servers(uint256):(string,address,uint256,uint256,uint256,address)",// function signature
            1);                                                                 // first argument, which is the index of the node we are looking for.

        System.out.println("url     : " + result[0]);
        System.out.println("owner   : " + result[1]);
        System.out.println("deposit : " + result[2]);
        System.out.println("props   : " + result[3]);


       ....
   }
}
```
#### Sending Transactions

In order to send, you need a signer. The SimpleWallet class is a basic implementation that can be used.

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
        // create incubed
        IN3 in3 = new IN3();

        // configure
        in3.setChainId(0x1); // set it to mainnet (which is also dthe default)

        // create a wallet managing the private keys
        SimpleWallet wallet = new SimpleWallet();

        // add accounts by adding the private keys
        String keyFile = "myKey.json";
        String myPassphrase = "<secrect>";

        // read the keyfile and decoded the private key
        String account = wallet.addKeyStore(new String(Files.readAllBytes(Paths.get(keyFile)), StandardCharsets.UTF_8),
                myPassphrase);

        // use the wallet as signer
        in3.setSigner(wallet);

        String receipient = "0x1234567890123456789012345678901234567890";
        BigInteger value = BigInteger.valueOf(100000);

        // create a Transaction
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



## Package in3

#### class Example

##### main

 > public static `void` main([`String[]`](#class-string[]) args);

arguments:
```eval_rst
============= ========== 
``String []``  **args**  
============= ========== 
```

#### class IN3

This is the main class creating the incubed client. 

The client can then be configured. 

##### getCacheTimeout

number of seconds requests can be cached. 

 > public `native int` getCacheTimeout();

##### setCacheTimeout

sets number of seconds requests can be cached. 

 > public `native void` setCacheTimeout([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getNodeLimit

the limit of nodes to store in the client. 

 > public `native int` getNodeLimit();

##### setNodeLimit

sets the limit of nodes to store in the client. 

 > public `native void` setNodeLimit([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getKey

the client key to sign requests 

 > public `native byte []` getKey();

##### setKey

sets the client key to sign requests 

 > public `native void` setKey([`byte[]`](#class-byte[]) val);

arguments:
```eval_rst
=========== ========= 
``byte []``  **val**  
=========== ========= 
```
##### setKey

sets the client key as hexstring to sign requests 

 > public `void` setKey([`String`](#class-string) val);

arguments:
```eval_rst
========== ========= 
``String``  **val**  
========== ========= 
```
##### getMaxCodeCache

number of max bytes used to cache the code in memory 

 > public `native int` getMaxCodeCache();

##### setMaxCodeCache

sets number of max bytes used to cache the code in memory 

 > public `native void` setMaxCodeCache([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getMaxBlockCache

number of blocks cached in memory 

 > public `native int` getMaxBlockCache();

##### setMaxBlockCache

sets the number of blocks cached in memory 

 > public `native void` setMaxBlockCache([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getProof

the type of proof used 

 > public [`Proofnative `](#class-proof) getProof();

##### setProof

sets the type of proof used 

 > public `native void` setProof([`Proof`](#class-proof) val);

arguments:
```eval_rst
======================= ========= 
`Proof <#class-proof>`_  **val**  
======================= ========= 
```
##### getRequestCount

the number of request send when getting a first answer 

 > public `native int` getRequestCount();

##### setRequestCount

sets the number of requests send when getting a first answer 

 > public `native void` setRequestCount([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getSignatureCount

the number of signatures used to proof the blockhash. 

 > public `native int` getSignatureCount();

##### setSignatureCount

sets the number of signatures used to proof the blockhash. 

 > public `native void` setSignatureCount([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getMinDeposit

min stake of the server. 

Only nodes owning at least this amount will be chosen. 

 > public `native long` getMinDeposit();

##### setMinDeposit

sets min stake of the server. 

Only nodes owning at least this amount will be chosen. 

 > public `native void` setMinDeposit([`long`](#class-long) val);

arguments:
```eval_rst
======== ========= 
``long``  **val**  
======== ========= 
```
##### getReplaceLatestBlock

if specified, the blocknumber *latest* will be replaced by blockNumber- specified value 

 > public `native int` getReplaceLatestBlock();

##### setReplaceLatestBlock

replaces the *latest* with blockNumber- specified value 

 > public `native void` setReplaceLatestBlock([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getFinality

the number of signatures in percent required for the request 

 > public `native int` getFinality();

##### setFinality

sets the number of signatures in percent required for the request 

 > public `native void` setFinality([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getMaxAttempts

the max number of attempts before giving up 

 > public `native int` getMaxAttempts();

##### setMaxAttempts

sets the max number of attempts before giving up 

 > public `native void` setMaxAttempts([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
##### getSigner

returns the signer or wallet. 

 > public [`Signer`](#class-signer) getSigner();

##### getEth1API

gets the ethereum-api 

 > public [`in3.eth1.API`](#class-in3.eth1.api) getEth1API();

##### setSigner

sets the signer or wallet. 

 > public `void` setSigner([`Signer`](#class-signer) signer);

arguments:
```eval_rst
========================= ============ 
`Signer <#class-signer>`_  **signer**  
========================= ============ 
```
##### getTimeout

specifies the number of milliseconds before the request times out. 

increasing may be helpful if the device uses a slow connection. 

 > public `native int` getTimeout();

##### setTimeout

specifies the number of milliseconds before the request times out. 

increasing may be helpful if the device uses a slow connection. 

 > public `native void` setTimeout([`int`](#class-int) val);

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
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
##### isAutoUpdateList

if true the nodelist will be automaticly updated if the lastBlock is newer 

 > public `native boolean` isAutoUpdateList();

##### setAutoUpdateList

activates the auto update.if true the nodelist will be automaticly updated if the lastBlock is newer 

 > public `native void` setAutoUpdateList([`boolean`](#class-boolean) val);

arguments:
```eval_rst
=========== ========= 
``boolean``  **val**  
=========== ========= 
```
##### getStorageProvider

provides the ability to cache content 

 > public [`StorageProvider`](#class-storageprovider) getStorageProvider();

##### setStorageProvider

provides the ability to cache content like nodelists, contract codes and validatorlists 

 > public `void` setStorageProvider([`StorageProvider`](#class-storageprovider) val);

arguments:
```eval_rst
=========================================== ========= 
`StorageProvider <#class-storageprovider>`_  **val**  
=========================================== ========= 
```
##### send

send a request. 

The request must a valid json-string with method and params 

 > public `native String` send([`String`](#class-string) request);

arguments:
```eval_rst
========== ============= 
``String``  **request**  
========== ============= 
```
##### sendobject

send a request but returns a object like array or map with the parsed response. 

The request must a valid json-string with method and params 

 > public `native Object` sendobject([`String`](#class-string) request);

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
============= ============ 
``String``     **method**  
``Object []``  **params**  
============= ============ 
```
##### sendRPCasObject

send a RPC request by only passing the method and params. 

It will create the raw request from it and return the result. 

 > public `Object` sendRPCasObject([`String`](#class-string) method, [`Object[]`](#class-object[]) params);

arguments:
```eval_rst
============= ============ 
``String``     **method**  
``Object []``  **params**  
============= ============ 
```
##### IN3

constrcutor. 

creates a new Incubed client. 

 > public  IN3();

##### main

 > public static `void` main([`String[]`](#class-string[]) args);

arguments:
```eval_rst
============= ========== 
``String []``  **args**  
============= ========== 
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

 > public `String []` getStringArray([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= ================
``String``  **key**  the propertyName
========== ========= ================
```
returns: `String []` : the array or null 



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



##### asStringArray

 > public `String []` asStringArray([`Object`](#class-object) o);

arguments:
```eval_rst
========== ======= 
``Object``  **o**  
========== ======= 
```
##### toString

 > public `String` toString();

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

#### class Loader

##### loadLibrary

 > public static `void` loadLibrary();


#### class TempStorageProvider

a simple Storage Provider storing the cache in the temp-folder. 

##### getItem

returns a item from cache () 

 > public `byte []` getItem([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= 
``String``  **key**  
========== ========= 
```
returns: `byte []` : the bytes or null if not found. 



##### setItem

stores a item in the cache. 

 > public `void` setItem([`String`](#class-string) key, [`byte[]`](#class-byte[]) content);

arguments:
```eval_rst
=========== ============= 
``String``   **key**      
``byte []``  **content**  
=========== ============= 
```

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
##### hasAccount

returns true if the account is supported (or unlocked) 

 > public `boolean` hasAccount([`String`](#class-string) address);

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

 > public `byte []` getItem([`String`](#class-string) key);

arguments:
```eval_rst
========== ========= ====================
``String``  **key**  the key for the item
========== ========= ====================
```
returns: `byte []` : the bytes or null if not found. 



##### setItem

stores a item in the cache. 

 > public `void` setItem([`String`](#class-string) key, [`byte[]`](#class-byte[]) content);

arguments:
```eval_rst
=========== ============= ====================
``String``   **key**      the key for the item
``byte []``  **content**  the value to store
=========== ============= ====================
```

## Package in3.eth1

#### class API

a Wrapper for the incubed client offering Type-safe Access and additional helper functions. 

##### API

creates a API using the given incubed instance. 

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

 > public [`Log []`](#class-log) getFilterChangesFromLogs([`long`](#class-long) id);

arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```
##### getFilterChangesFromBlocks

Polling method for a filter, which returns an array of logs which occurred since last poll. 

 > public [`Block []`](#class-block) getFilterChangesFromBlocks([`long`](#class-long) id);

arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```
##### getFilterLogs

Polling method for a filter, which returns an array of logs which occurred since last poll. 

 > public [`Log []`](#class-log) getFilterLogs([`long`](#class-long) id);

arguments:
```eval_rst
======== ======== 
``long``  **id**  
======== ======== 
```
##### getLogs

Polling method for a filter, which returns an array of logs which occurred since last poll. 

 > public [`Log []`](#class-log) getLogs([`LogFilter`](#class-logfilter) filter);

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

 > public `long` uninstallFilter([`long`](#class-long) filter);

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



##### sendTransaction

sends a Transaction as desribed by the TransactionRequest. 

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

 > public `String []` getTransactionHashes();

##### getTransactions

the transactions of the block. 

 > public [`Transaction []`](#class-transaction) getTransactions();

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

 > public `String []` getSealFields();

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

 > public `String []` getUncles();


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

 > public `String []` getTopics();


#### class LogFilter

Log configuration for search logs. 

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
##### hasAccount

returns true if the account is supported (or unlocked) 

 > public `boolean` hasAccount([`String`](#class-string) address);

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

 > public `String []` getSignature();

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

 > public [`Log []`](#class-log) getLogs();

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

##### from

the from address 

Type: `String`

##### to

the recipients address 

Type: `String`

##### data

the data 

Type: `String`

##### value

the value of the transaction 

Type: `BigInteger`

##### nonce

the nonce (transactionCount of the sender) 

Type: `long`

##### gas

the gas to use 

Type: `long`

##### gasPrice

the gas price to use 

Type: `long`

##### function

the signature for the function to call 

Type: `String`

##### params

the params to use for encoding in the data 

Type: `Object []`

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

