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

```c
import org.json.*;
import in3.IN3;

public class HelloIN3 {  
   // 
   public static void main(String[] args) {
       String blockNumber = args[0]; 
       IN3 in3 = new IN3();
       JSONObject result = new JSONObject(in3.sendRPC("eth_getBlockByNumber",{ blockNumber ,true})));
       ....
   }
}
```



## Package in3.api

#### class Block


## Package in3

#### class IN3

##### getCacheTimeout

```java
native int in3.IN3.getCacheTimeout();
```

number of seconds requests can be cached. 

returns: `native int`

##### setCacheTimeout

```java
native void in3.IN3.setCacheTimeout(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getNodeLimit

```java
native int in3.IN3.getNodeLimit();
```

the limit of nodes to store in the client. 

returns: `native int`

##### setNodeLimit

```java
native void in3.IN3.setNodeLimit(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getKey

```java
native byte [] in3.IN3.getKey();
```

the client key to sign requests 

returns: `native byte []`

##### setKey

```java
native void in3.IN3.setKey(byte[] val);
```

arguments:
```eval_rst
=========== ========= 
``byte []``  **val**  
=========== ========= 
```
returns: `native void`

##### getMaxCodeCache

```java
native int in3.IN3.getMaxCodeCache();
```

number of max bytes used to cache the code in memory 

returns: `native int`

##### setMaxCodeCache

```java
native void in3.IN3.setMaxCodeCache(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getMaxBlockCache

```java
native int in3.IN3.getMaxBlockCache();
```

number of number of blocks cached in memory 

returns: `native int`

##### setMaxBlockCache

```java
native void in3.IN3.setMaxBlockCache(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getProof

```java
native Proof in3.IN3.getProof();
```

the type of proof used 

returns: [`Proofnative `](#proof)

##### setProof

```java
native void in3.IN3.setProof(Proof val);
```

arguments:
```eval_rst
================= ========= 
`Proof <#proof>`_  **val**  
================= ========= 
```
returns: `native void`

##### getRequestCount

```java
native int in3.IN3.getRequestCount();
```

the number of request send when getting a first answer 

returns: `native int`

##### setRequestCount

```java
native void in3.IN3.setRequestCount(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getSignatureCount

```java
native int in3.IN3.getSignatureCount();
```

the number of signatures used to proof the blockhash. 

returns: `native int`

##### setSignatureCount

```java
native void in3.IN3.setSignatureCount(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getMinDeposit

```java
native long in3.IN3.getMinDeposit();
```

min stake of the server. 

Only nodes owning at least this amount will be chosen. 

returns: `native long`

##### setMinDeposit

```java
native void in3.IN3.setMinDeposit(long val);
```

arguments:
```eval_rst
======== ========= 
``long``  **val**  
======== ========= 
```
returns: `native void`

##### getReplaceLatestBlock

```java
native int in3.IN3.getReplaceLatestBlock();
```

if specified, the blocknumber *latest* will be replaced by blockNumber- specified value 

returns: `native int`

##### setReplaceLatestBlock

```java
native void in3.IN3.setReplaceLatestBlock(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getFinality

```java
native int in3.IN3.getFinality();
```

the number of signatures in percent required for the request 

returns: `native int`

##### setFinality

```java
native void in3.IN3.setFinality(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getMaxAttempts

```java
native int in3.IN3.getMaxAttempts();
```

the max number of attempts before giving up 

returns: `native int`

##### setMaxAttempts

```java
native void in3.IN3.setMaxAttempts(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getTimeout

```java
native int in3.IN3.getTimeout();
```

specifies the number of milliseconds before the request times out. 

increasing may be helpful if the device uses a slow connection. 

returns: `native int`

##### setTimeout

```java
native void in3.IN3.setTimeout(int val);
```

arguments:
```eval_rst
======= ========= 
``int``  **val**  
======= ========= 
```
returns: `native void`

##### getChainId

```java
native long in3.IN3.getChainId();
```

servers to filter for the given chain. 

The chain-id based on EIP-155. 

returns: `native long`

##### setChainId

```java
native void in3.IN3.setChainId(long val);
```

arguments:
```eval_rst
======== ========= 
``long``  **val**  
======== ========= 
```
returns: `native void`

##### isAutoUpdateList

```java
native boolean in3.IN3.isAutoUpdateList();
```

if true the nodelist will be automaticly updated if the lastBlock is newer 

returns: `native boolean`

##### setAutoUpdateList

```java
native void in3.IN3.setAutoUpdateList(boolean val);
```

arguments:
```eval_rst
=========== ========= 
``boolean``  **val**  
=========== ========= 
```
returns: `native void`

##### getStorageProvider

```java
native StorageProvider in3.IN3.getStorageProvider();
```

provides the ability to cache content 

returns: [`StorageProvidernative `](#storageprovider)

##### setStorageProvider

```java
native void in3.IN3.setStorageProvider(StorageProvider val);
```

arguments:
```eval_rst
===================================== ========= 
`StorageProvider <#storageprovider>`_  **val**  
===================================== ========= 
```
returns: `native void`

##### send

```java
native String in3.IN3.send(String request);
```

send a request. 

The request must a valid json-string with method and params 

arguments:
```eval_rst
========== ============= 
``String``  **request**  
========== ============= 
```
returns: `native String`

##### sendRPC

```java
String in3.IN3.sendRPC(String method, Object[] params);
```

arguments:
```eval_rst
============= ============ 
``String``     **method**  
``Object []``  **params**  
============= ============ 
```
returns: `String`

##### IN3

```java
in3.IN3.IN3();
```

returns: ``


#### enum Proof

The enum type contains the following values:

```eval_rst
============== = ==================================================
 **none**      0 No Verification.
 **standard**  1 Standard Verification of the important properties.
 **full**      2 
============== = ==================================================
```

#### interface StorageProvider

##### getItem

```java
byte [] in3.StorageProvider.getItem(String key);
```

arguments:
```eval_rst
========== ========= 
``String``  **key**  
========== ========= 
```
returns: `byte []`

##### setItem

```java
void in3.StorageProvider.setItem(String key, byte[] content);
```

arguments:
```eval_rst
=========== ============= 
``String``   **key**      
``byte []``  **content**  
=========== ============= 
```

