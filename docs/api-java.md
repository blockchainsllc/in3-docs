# API Reference Java


## Installing

The Incubed Java client uses JNI in order to call native functions. That's why to use it you need to put the shared library in the path where java will be able to find it.

The shared library (`in3.dll` (windows), `libin3.so` (linux) or `libin3.dylib` (osx) ), can either be downloaded (make sure you know your targetsystem) or build from sources.

like

```c
java -Djava.library.path="path_to_in3;${env_var:PATH}" HelloIN3.class
```
### Building

For building the shared library you need to enable java by using the `-DJAVA=true` flag:

```c
git clone git@github.com:slockit/in3-core.git
mkdir -p in3-core/build
cd in3-core/build
cmake -DJAVA=true .. && make
```
You will find the `in3.jar` and the `libin3.so` in the build/lib - folder.

### Android

In order to use incubed in android simply follow this example:

[https://github.com/SlockItEarlyAccess/in3-android-example](https://github.com/SlockItEarlyAccess/in3-android-example)

## Example

### Using Incubed directly

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

Incubed also offers a API for getting Information directly in a structured way.

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

        // create a API instance which uses our incubed.
        EthAPI api = new EthAPI(in3);

        // read the latest Block including all Transactions.
        Block latestBlock = api.getBlockByNumber(Block.LATEST, true);

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

This Example shows how to call functions and use the decoded results. Here we get the struct from the registry.

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

       // create a API instance which uses our incubed.
       EthAPI api = new EthAPI(in3);

       // call a contract, which uses eth_call to get the result. 
       Object[] result = (Object[]) api.call(                                   // call a function of a contract
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



## Package in3

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

 > public [`StorageProvidernative `](#class-storageprovider) getStorageProvider();

##### setStorageProvider

provides the ability to cache content like nodelists, contract codes and validatorlists 

 > public `native void` setStorageProvider([`StorageProvider`](#class-storageprovider) val);

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

#### enum Proof

The enum type contains the following values:

```eval_rst
============== = ====================================================================
 **none**      0 
 **standard**  1 No Verification.
 **full**      2 Standard Verification of the important properties. 
                 
                 Full Verification including even uncles wich leads to higher payload
============== = ====================================================================
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

##### main

 > public static `void` main([`String[]`](#class-string[]) args);

arguments:
```eval_rst
============= ========== 
``String []``  **args**  
============= ========== 
```

#### class EthAPI

a Wrapper for the incubed client offering Type-safe Access and additional helper functions. 

##### EthAPI

creates a API using the given incubed instance. 

 > public  EthAPI([`IN3`](#class-in3) in3);

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
##### getBlockNumber

the current BlockNumber. 

 > public `long` getBlockNumber();

##### getGasPrice

the current Gas Price. 

 > public `long` getGasPrice();

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



##### main

 > public static `void` main([`String[]`](#class-string[]) args);

arguments:
```eval_rst
============= ========== 
``String []``  **args**  
============= ========== 
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

##### privateKey

the private Key to use for signing 

Type: `String`

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

