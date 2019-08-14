# API Reference C

## Overview

The C implementation of the Incubed client is prepared and optimized to run on small embedded devices. Because each device is different, we prepare different modules that should be combined. This allows us to only generate the code needed and reduce requirements for flash and memory.

This is why Incubed consists of different modules. While the core module is always required, additional functions will be prepared by different modules:

### Verifier

Incubed is a minimal verification client, which means that each response needs to be verifiable. Depending on the expected requests and responses, you need to carefully choose which verifier you may need to register. For Ethereum, we have developed three modules:

1. [nano](#module-eth-nano): a minimal module only able to verify transaction receipts (`eth_getTransactionReceipt`).
2. [basic](#module-eth-basic): module able to verify almost all other standard RPC functions (except `eth_call`).
3. [full](#module-eth-full): module able to verify standard RPC functions. It also implements a full EVM to handle `eth_call`.

Depending on the module, you need to register the verifier before using it. This is done by calling the `in3_register...` function like [in3_register_eth_full()](#in3-register-eth-full).

### Transport

To verify responses, you need to be able to send requests. The way to handle them depends heavily on your hardware capabilities. For example, if your device only supports Bluetooth, you may use this connection to deliver the request to a device with an existing internet connection and get the response in the same way, but if your device is able to use a direct internet connection, you may use a curl-library to execute them. This is why the core client only defines function pointer [in3_transport_send](#in3-transport-send), which must handle the requests.

At the moment we offer these modules; other implementations are supported by different hardware modules.

1. [curl](#module-transport-curl): module with a dependency on curl, which executes these requests and supports HTTPS. This module runs a standard OS with curl installed.

### API

While Incubed operates on JSON-RPC level, as a developer, you might want to use a better-structured API to prepare these requests for you. These APIs are optional but make life easier:

1. [**eth**](#module-eth-api): This module offers all standard RPC functions as descriped in the [Ethereum JSON-RPC Specification](https://github.com/ethereum/wiki/wiki/JSON-RPC). In addition, it allows you to sign and encode/decode calls and transactions.
2. [**usn**](#module-usn-api): This module offers basic USN functions like renting, event handling, and message verification.

## Building

While we provide binaries, you can also build from source:

### Requirements

1. CMake
2. Curl: curl is used as transport for command-line tools.
3. Optional: libscrypt, which would be used for unlocking keystore files using `scrypt` as KDF method. If it does not exist, you can still build, but it does not decrypt such keys. 

For osx `brew install libscrypt` and for debian `sudo apt-get install libscrypt-dev`.

Incubed uses cmake for configuring:

```c
mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && make
make install
```
### CMake Options

#### CMD

Builds the command-line utilities.

Type: `BOOL`, Default-Value: `ON`

#### DEBUG

Turns on debug output in the code. This would be required if the tests should output additional debug info.

Type: `BOOL`, Default-Value: `OFF`

#### EVM_GAS

If true, the gas costs are verified when validating an eth_call. This is an optimization since most calls are only interested in the result. EVM_GAS would be required if the contract used gas-dependent opcodes.

Type: `BOOL`, Default-Value: `ON`

#### EXAMPLES

Builds the examples.

Type: `BOOL`, Default-Value: `OFF`

#### FAST_MATH

Math optimizations used in the EVM. This will also increase the file size.

Type: `BOOL`, Default-Value: `OFF`

#### IN3API

Builds the USN-API, which offers better interfaces and additional functions on top of pure verification.

Type: `BOOL`, Default-Value: `ON`

#### JAVA

Builds the java-binding (shared-lib and jar-file).

Type: `BOOL`, Default-Value: `OFF`

#### TEST

Builds the tests and also adds special memory management, which detects memory leaks but will cause slower performance.

Type: `BOOL`, Default-Value: `OFF`

#### TRANSPORTS

Builds transports, which may require extra libraries.

Type: `BOOL`, Default-Value: `ON`

#### WASM

Includes the WASM-Build. To build it, you need Emscripten as your toolchain. You usually also want to turn off other builds in this case.

Type: `BOOL`, Default-Value: `OFF` 

## Examples

### Creating an Incubed Instance

Creating always follow these steps:

```c
#include <client/client.h> // the core client
#include <eth_full.h>      // the full Ethereum verifier containing the EVM
#include <in3_curl.h>      // transport implementation

// register verifiers, in this case a full verifier allowing eth_call
in3_register_eth_full();

// create new client
in3_t* client = in3_new();

// configure storage by using storage-functions from in3_curl, which store the cache in /home/<USER>/.in3
in3_storage_handler_t storage_handler;
storage_handler.get_item = storage_get_item;
storage_handler.set_item = storage_set_item;

client->cacheStorage = &storage_handler;

// configure transport by using curl
client->transport    = send_curl;

// init cache by reading the nodelist from the cache >(if exists)
in3_cache_init(client);

// ready to use ...
```

### Calling a Function

```c
// define a address (20byte)
address_t contract;

// copy the hexcoded string into this address
hex2byte_arr("0x845E484b505443814B992Bf0319A5e8F5e407879", -1, contract, 20);

// ask for the number of servers registered
json_ctx_t* response = eth_call_fn(client, contract, "totalServers():uint256");

// handle response
if (!response) {
  printf("Could not get the response: %s", eth_last_error());
  return;
}

// convert the result to a integer
int number_of_servers = d_int(response->result);

// don't forget the free the response!
free_json(response);

// out put result
printf("Found %i servers registered : \n", number_of_servers);

// now we call a function with a complex result...
for (int i = 0; i < number_of_servers; i++) {

  // get all the details for one server.
  response = eth_call_fn(c, contract, "servers(uint256):(string,address,uint,uint,uint,address)", to_uint256(i));

  // handle error
  if (!response) {
    printf("Could not get the response: %s", eth_last_error());
    return;
  }

  // decode data
  char*    url     = d_get_string_at(response->result, 0); // get the first item of the result (the URL)
  bytes_t* owner   = d_get_bytes_at(response->result, 1);  // get the second item of the result (the owner)
  uint64_t deposit = d_get_long_at(response->result, 2);   // get the third item of the result (the deposit)

  // print values
  printf("Server %i : %s owner = ", i, url);
  ba_print(owner->data, owner->len);
  printf(", deposit = %" PRIu64 "\n", deposit);

  // clean up
  free_json(response);
}
```

## Module API/eth1 

### eth_api.h

Ethereum API. 

This header-file defines prepares the JSON-RPC request, which is then executed and verified by the Incubed client.

Location: src/api/eth1/eth_api.h

#### eth_tx_t

A transaction. 

The stucture contains following fields:

```eval_rst
========================= ======================= =========================================
`bytes32_t <#bytes32-t>`_  **hash**               the blockhash
`bytes32_t <#bytes32-t>`_  **block_hash**         hash of the containing block
``uint64_t``               **block_number**       number of the containing block
`address_t <#address-t>`_  **from**               sender of the transaction
``uint64_t``               **gas**                gas sent along
``uint64_t``               **gas_price**          gas price used
`bytes_t <#bytes-t>`_      **data**               data sent along with the transaction
``uint64_t``               **nonce**              nonce of the transaction
`address_t <#address-t>`_  **to**                 receiver of the address 0x0000. 
                                                  
                                                  Address is used for contract creation.
`uint256_t <#uint256-t>`_  **value**              the value in wei sent
``int``                    **transaction_index**  the transaction index
``uint8_t``                **signature**          signature of the transaction
========================= ======================= =========================================
```

#### eth_block_t

An Ethereum block.

The stucture contains following fields:

```eval_rst
=========================== ======================= ====================================================
``uint64_t``                 **number**             the blockNumber
`bytes32_t <#bytes32-t>`_    **hash**               the blockhash
``uint64_t``                 **gasUsed**            gas used by all the transactions
``uint64_t``                 **gasLimit**           gasLimit
`address_t <#address-t>`_    **author**             the author of the block
`uint256_t <#uint256-t>`_    **difficulty**         the difficulty of the block
`bytes_t <#bytes-t>`_        **extra_data**         the extra_data of the block
``uint8_t``                  **logsBloom**          the logsBloom-data
`bytes32_t <#bytes32-t>`_    **parent_hash**        the hash of the parent-block
`bytes32_t <#bytes32-t>`_    **sha3_uncles**        root hash of the uncle-trie
`bytes32_t <#bytes32-t>`_    **state_root**         root hash of the state-trie
`bytes32_t <#bytes32-t>`_    **receipts_root**      root of the receipts trie
`bytes32_t <#bytes32-t>`_    **transaction_root**   root of the transaction trie
``int``                      **tx_count**           number of transactions in the block
`eth_tx_t * <#eth-tx-t>`_    **tx_data**            array of transaction data or NULL if not requested
`bytes32_t * <#bytes32-t>`_  **tx_hashes**          array of transaction hashes or NULL if not requested
``uint64_t``                 **timestamp**          the Unix timestamp of the block
`bytes_t * <#bytes-t>`_      **seal_fields**        sealed fields
``int``                      **seal_fields_count**  number of sealed fields
=========================== ======================= ====================================================
```

#### eth_log_t

A linked list of Ethereum logs.

The stucture contains the following fields:

```eval_rst
=============================== ======================= ==============================================================
``bool``                         **removed**            true when the log was removed, due to a chain reorganization
                                                        
                                                        false if it's a valid log
``size_t``                       **log_index**          log index position in the block
``size_t``                       **transaction_index**  transaction index position the log was created from
`bytes32_t <#bytes32-t>`_        **transaction_hash**   hash of the transactions this log was created from
`bytes32_t <#bytes32-t>`_        **block_hash**         hash of the block where this log was in
``uint64_t``                     **block_number**       the block number where this log was in
`address_t <#address-t>`_        **address**            address from which this log originated
`bytes_t <#bytes-t>`_            **data**               non-indexed arguments of the log
`bytes32_t * <#bytes32-t>`_      **topics**             array of 0 to 4 32 bytes DATA of indexed log arguments
``size_t``                       **topic_count**        counter for topics
`eth_logstruct , * <#eth-log>`_  **next**               pointer to next log in list or NULL
=============================== ======================= ==============================================================
```

#### eth_getStorageAt

```c
uint256_t eth_getStorageAt(in3_t *in3, address_t account, bytes32_t key, uint64_t block);
```

Returns the storage value of a given address. 

arguments:
```eval_rst
========================= ============= 
`in3_t * <#in3-t>`_        **in3**      
`address_t <#address-t>`_  **account**  
`bytes32_t <#bytes32-t>`_  **key**      
``uint64_t``               **block**    
========================= ============= 
```
returns: [`uint256_t`](#uint256-t)

#### eth_getCode

```c
bytes_t eth_getCode(in3_t *in3, address_t account, uint64_t block);
```

Returns the code of the account of a given address.

(Make sure you free the data point of the result after use.) 

arguments:
```eval_rst
========================= ============= 
`in3_t * <#in3-t>`_        **in3**      
`address_t <#address-t>`_  **account**  
``uint64_t``               **block**    
========================= ============= 
```
returns: [`bytes_t`](#bytes-t)

#### eth_getBalance

```c
uint256_t eth_getBalance(in3_t *in3, address_t account, uint64_t block);
```

Returns the balance of the account of a given address. 

arguments:
```eval_rst
========================= ============= 
`in3_t * <#in3-t>`_        **in3**      
`address_t <#address-t>`_  **account**  
``uint64_t``               **block**    
========================= ============= 
```
returns: [`uint256_t`](#uint256-t)

#### eth_blockNumber

```c
uint64_t eth_blockNumber(in3_t *in3);
```

Returns the current price per gas in wei.

arguments:
```eval_rst
=================== ========= 
`in3_t * <#in3-t>`_  **in3**  
=================== ========= 
```
returns: `uint64_t`

#### eth_gasPrice

```c
uint64_t eth_gasPrice(in3_t *in3);
```

Returns the current blockNumber. If bn==0, an error occured and you should check.

arguments:
```eval_rst
=================== ========= 
`in3_t * <#in3-t>`_  **in3**  
=================== ========= 
```
returns: `uint64_t`

#### eth_getBlockByNumber

```c
eth_block_t* eth_getBlockByNumber(in3_t *in3, uint64_t number, bool include_tx);
```

Returns the block for the given number (if number==0, the latest will be returned).

If result is null, check. Otherwise, make sure to free the result after using it!

arguments:
```eval_rst
=================== ================ 
`in3_t * <#in3-t>`_  **in3**         
``uint64_t``         **number**      
``bool``             **include_tx**  
=================== ================ 
```
returns: [`eth_block_t *`](#eth-block-t)

#### eth_getBlockByHash

```c
eth_block_t* eth_getBlockByHash(in3_t *in3, bytes32_t hash, bool include_tx);
```

Returns the block for the given hash.

If result is null, check. Otherwise, make sure to free the result after using it!

arguments:
```eval_rst
========================= ================ 
`in3_t * <#in3-t>`_        **in3**         
`bytes32_t <#bytes32-t>`_  **hash**        
``bool``                   **include_tx**  
========================= ================ 
```
returns: [`eth_block_t *`](#eth-block-t)

#### eth_getLogs

```c
eth_log_t* eth_getLogs(in3_t *in3, char *fopt);
```

Returns a linked list of logs.

If result is null, check. Otherwise, make sure to free the log, its topics, and data after using it!

arguments:
```eval_rst
=================== ========== 
`in3_t * <#in3-t>`_  **in3**   
``char *``           **fopt**  
=================== ========== 
```
returns: [`eth_log_t *`](#eth-log-t)

#### eth_call_fn

```c
json_ctx_t* eth_call_fn(in3_t *in3, address_t contract, char *fn_sig,...);
```

Returns the result of a function_call. 

If result is null, check. Otherwise, make sure to free the result after using it!

arguments:
```eval_rst
========================= ============== 
`in3_t * <#in3-t>`_        **in3**       
`address_t <#address-t>`_  **contract**  
``char *``                 **fn_sig**    
``...``                                  
========================= ============== 
```
returns: [`json_ctx_t *`](#json-ctx-t)

#### eth_wait_for_receipt

```c
char* eth_wait_for_receipt(in3_t *in3, bytes32_t tx_hash);
```

arguments:
```eval_rst
========================= ============= 
`in3_t * <#in3-t>`_        **in3**      
`bytes32_t <#bytes32-t>`_  **tx_hash**  
========================= ============= 
```
returns: `char *`

#### eth_newFilter

```c
in3_ret_t eth_newFilter(in3_t *in3, json_ctx_t *options);
```

arguments:
```eval_rst
============================= ============= 
`in3_t * <#in3-t>`_            **in3**      
`json_ctx_t * <#json-ctx-t>`_  **options**  
============================= ============= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_newBlockFilter

```c
in3_ret_t eth_newBlockFilter(in3_t *in3);
```

Creates a new block filter with specified options and returns its ID (>0) on success or 0 on failure.

arguments:
```eval_rst
=================== ========= 
`in3_t * <#in3-t>`_  **in3**  
=================== ========= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_newPendingTransactionFilter

```c
in3_ret_t eth_newPendingTransactionFilter(in3_t *in3);
```

Creates a new pending transaction filter with specified options and returns its ID on success or 0 on failure.

arguments:
```eval_rst
=================== ========= 
`in3_t * <#in3-t>`_  **in3**  
=================== ========= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function.

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_uninstallFilter

```c
bool eth_uninstallFilter(in3_t *in3, size_t id);
```

Uninstalls a filter and returns true on success or false on failure.

arguments:
```eval_rst
=================== ========= 
`in3_t * <#in3-t>`_  **in3**  
``size_t``           **id**   
=================== ========= 
```
returns: `bool`

#### eth_getFilterChanges

```c
in3_ret_t eth_getFilterChanges(in3_t *in3, size_t id, bytes32_t **block_hashes, eth_log_t **logs);
```

Sets the logs (for event filter) or blockhashes (for block filter) that match a filter; returns <0 on error, otherwise number of block hashes matched (for block filter) or 0 (for log filer).

arguments:
```eval_rst
============================ ================== 
`in3_t * <#in3-t>`_           **in3**           
``size_t``                    **id**            
`bytes32_t ** <#bytes32-t>`_  **block_hashes**  
`eth_log_t ** <#eth-log-t>`_  **logs**          
============================ ================== 
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_last_error

```c
char* eth_last_error();
```

The current error or null if all is OK.

returns: `char *`

#### as_double

```c
long double as_double(uint256_t d);
```

Converts a , in a long double. 

Important: Since a long double stores max 16 bytes, there is no guarantee to have full precision.

arguments:
```eval_rst
========================= ======= 
`uint256_t <#uint256-t>`_  **d**  
========================= ======= 
```
returns: `long double`

#### as_long

```c
uint64_t as_long(uint256_t d);
```

Converts a , in a long . 

Important: Since a long double stores 8 bytes, this will only use the last 8 bytes of the value.

arguments:
```eval_rst
========================= ======= 
`uint256_t <#uint256-t>`_  **d**  
========================= ======= 
```
returns: `uint64_t`

#### to_uint256

```c
uint256_t to_uint256(uint64_t value);
```

arguments:
```eval_rst
============ =========== 
``uint64_t``  **value**  
============ =========== 
```
returns: [`uint256_t`](#uint256-t)

#### decrypt_key

```c
in3_ret_t decrypt_key(d_token_t *key_data, char *password, bytes32_t dst);
```

arguments:
```eval_rst
=========================== ============== 
`d_token_t * <#d-token-t>`_  **key_data**  
``char *``                   **password**  
`bytes32_t <#bytes32-t>`_    **dst**       
=========================== ============== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### free_log

```c
void free_log(eth_log_t *log);
```

arguments:
```eval_rst
=========================== ========= 
`eth_log_t * <#eth-log-t>`_  **log**  
=========================== ========= 
```

## Module API/usn

### usn_api.h

USN API. 

This header-file defines an easy-to-use function, which is verifying USN-Messages.

Location: src/api/usn/usn_api.h

#### usn_msg_type_t

The enum type contains the following values:

```eval_rst
================== = 
 **USN_ACTION**    0 
 **USN_REQUEST**   1 
 **USN_RESPONSE**  2 
================== = 
```

#### usn_event_type_t

The enum type contains the following values:

```eval_rst
=================== = 
 **BOOKING_NONE**   0 
 **BOOKING_START**  1 
 **BOOKING_STOP**   2 
=================== = 
```

#### usn_booking_handler

```c
typedef int(* usn_booking_handler) (usn_event_t *)
```

returns: `int(*`

#### usn_verify_message

```c
usn_msg_result_t usn_verify_message(usn_device_conf_t *conf, char *message);
```

arguments:
```eval_rst
=========================================== ============= 
`usn_device_conf_t * <#usn-device-conf-t>`_  **conf**     
``char *``                                   **message**  
=========================================== ============= 
```
returns: [`usn_msg_result_t`](#usn-msg-result-t)

#### usn_register_device

```c
in3_ret_t usn_register_device(usn_device_conf_t *conf, char *url);
```

arguments:
```eval_rst
=========================================== ========== 
`usn_device_conf_t * <#usn-device-conf-t>`_  **conf**  
``char *``                                   **url**   
=========================================== ========== 
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### usn_parse_url

```c
usn_url_t usn_parse_url(char *url);
```

arguments:
```eval_rst
========== ========= 
``char *``  **url**  
========== ========= 
```
returns: [`usn_url_t`](#usn-url-t)

#### usn_update_state

```c
unsigned int usn_update_state(usn_device_conf_t *conf, unsigned int wait_time);
```

arguments:
```eval_rst
=========================================== =============== 
`usn_device_conf_t * <#usn-device-conf-t>`_  **conf**       
``unsigned int``                             **wait_time**  
=========================================== =============== 
```
returns: `unsigned int`

#### usn_update_bookings

```c
in3_ret_t usn_update_bookings(usn_device_conf_t *conf);
```

arguments:
```eval_rst
=========================================== ========== 
`usn_device_conf_t * <#usn-device-conf-t>`_  **conf**  
=========================================== ========== 
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### usn_remove_old_bookings

```c
void usn_remove_old_bookings(usn_device_conf_t *conf);
```

arguments:
```eval_rst
=========================================== ========== 
`usn_device_conf_t * <#usn-device-conf-t>`_  **conf**  
=========================================== ========== 
```

#### usn_get_next_event

```c
usn_event_t usn_get_next_event(usn_device_conf_t *conf);
```

arguments:
```eval_rst
=========================================== ========== 
`usn_device_conf_t * <#usn-device-conf-t>`_  **conf**  
=========================================== ========== 
```
returns: [`usn_event_t`](#usn-event-t)

#### usn_rent

```c
in3_ret_t usn_rent(in3_t *c, address_t contract, address_t token, char *url, uint32_t seconds, bytes32_t tx_hash);
```

arguments:
```eval_rst
========================= ============== 
`in3_t * <#in3-t>`_        **c**         
`address_t <#address-t>`_  **contract**  
`address_t <#address-t>`_  **token**     
``char *``                 **url**       
``uint32_t``               **seconds**   
`bytes32_t <#bytes32-t>`_  **tx_hash**   
========================= ============== 
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### usn_return

```c
in3_ret_t usn_return(in3_t *c, address_t contract, char *url, bytes32_t tx_hash);
```

arguments:
```eval_rst
========================= ============== 
`in3_t * <#in3-t>`_        **c**         
`address_t <#address-t>`_  **contract**  
``char *``                 **url**       
`bytes32_t <#bytes32-t>`_  **tx_hash**   
========================= ============== 
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### usn_price

```c
in3_ret_t usn_price(in3_t *c, address_t contract, address_t token, char *url, uint32_t seconds, address_t controller, bytes32_t price);
```

arguments:
```eval_rst
========================= ================ 
`in3_t * <#in3-t>`_        **c**           
`address_t <#address-t>`_  **contract**    
`address_t <#address-t>`_  **token**       
``char *``                 **url**         
``uint32_t``               **seconds**     
`address_t <#address-t>`_  **controller**  
`bytes32_t <#bytes32-t>`_  **price**       
========================= ================ 
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

## Module Bindings/java 

set(CMAKE_JAVA_COMPILE_FLAGS "-source" "1.6" "-target" "1.6")

### in3.h

The entry points for the shared library. 

Location: src/bindings/java/in3.h

#### in3_create

```c
in3_t* in3_create();
```

Creates a new client.

returns: [`in3_t *`](#in3-t)

#### in3_send

```c
int in3_send(in3_t *c, char *method, char *params, char **result, char **error);
```

Sends a request and stores the result in the provided buffer.

arguments:
```eval_rst
=================== ============ 
`in3_t * <#in3-t>`_  **c**       
``char *``           **method**  
``char *``           **params**  
``char **``          **result**  
``char **``          **error**   
=================== ============ 
```
returns: `int`

#### in3_dispose

```c
void in3_dispose(in3_t *a);
```

Frees the references of the client.

arguments:
```eval_rst
=================== ======= 
`in3_t * <#in3-t>`_  **a**  
=================== ======= 
```

## Module CMD/in3 

### in3_storage.h

Storage handler storing cache in the home-dir/.in3.

Location: src/cmd/in3/in3_storage.h

#### storage_get_item

```c
bytes_t* storage_get_item(void *cptr, char *key);
```

arguments:
```eval_rst
========== ========== 
``void *``  **cptr**  
``char *``  **key**   
========== ========== 
```
returns: [`bytes_t *`](#bytes-t)

#### storage_set_item

```c
void storage_set_item(void *cptr, char *key, bytes_t *content);
```

arguments:
```eval_rst
======================= ============= 
``void *``               **cptr**     
``char *``               **key**      
`bytes_t * <#bytes-t>`_  **content**  
======================= ============= 
```

## Module Core 

Main Incubed module defining the interfaces for transport, verifier, and storage.

This module does not have any dependencies and cannot be used without additional modules providing verification and transport.

### cache.h

Handles caching and storage. 

Stores NodeLists and other caches with the storage handler as specified in the client. If no storage handler is specified, nothing will be cached.

Location: src/core/client/cache.h

#### in3_cache_update_nodelist

```c
in3_ret_t in3_cache_update_nodelist(in3_t *c, in3_chain_t *chain);
```

Reads the NodeList from the cache. 

This function is usually called internally to fill the weights and NodeList from the cache. If you call `in3_cache_init`, there is no need to call this explicitly.

arguments:
```eval_rst
=============================== =========== ==================
`in3_t * <#in3-t>`_              **c**      the Incubed client
`in3_chain_t * <#in3-chain-t>`_  **chain**  chain to configure
=============================== =========== ==================
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_cache_store_nodelist

```c
in3_ret_t in3_cache_store_nodelist(in3_ctx_t *ctx, in3_chain_t *chain);
```

Stores the NodeList to the cache. 

It will automatically call if the NodeList or weight of a node has changed, then read from the nodes.

arguments:
```eval_rst
=============================== =========== ===========================
`in3_ctx_t * <#in3-ctx-t>`_      **ctx**    the current Incubed context
`in3_chain_t * <#in3-chain-t>`_  **chain**  the chain updating to cache
=============================== =========== ===========================
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

### client.h

Incubed main client file. 

This includes the definition of the client and used enum values.

Location: src/core/client/client.h

#### IN3_PROTO_VER

```c
#define IN3_PROTO_VER 0x2
```

#### IN3_SIGN_ERR_REJECTED

Return value used by the signer if the the signature-request was rejected.

```c
#define IN3_SIGN_ERR_REJECTED -1
```

#### IN3_SIGN_ERR_ACCOUNT_NOT_FOUND

Return value used by the signer if the requested account was not found.

```c
#define IN3_SIGN_ERR_ACCOUNT_NOT_FOUND -2
```

#### IN3_SIGN_ERR_INVALID_MESSAGE

Return value used by the signer if the message was invalid.

```c
#define IN3_SIGN_ERR_INVALID_MESSAGE -3
```

#### IN3_SIGN_ERR_GENERAL_ERROR

Return value used by the signer for unspecified errors. 

```c
#define IN3_SIGN_ERR_GENERAL_ERROR -4
```

#### in3_chain_type_t

The type of chain. 

For Incubed, a chain can be any distributed network or database with Incubed support. Depending on the chain type, the previously registered verifier will be chosen and used.

The enum type contains the following values:

```eval_rst
===================== = =================
 **CHAIN_ETH**        0 Ethereum chain
 **CHAIN_SUBSTRATE**  1 substrate chain
 **CHAIN_IPFS**       2 IPFS verification
 **CHAIN_BTC**        3 Bitcoin chain
 **CHAIN_IOTA**       4 IOTA chain
 **CHAIN_GENERIC**    5 other chains
===================== = =================
```

#### in3_proof_t

The type of proof. 

Depending on the proof type, different levels of proof will be requested from the node.

The enum type contains the following values:

```eval_rst
==================== = ==================================================
 **PROOF_NONE**      0 no verification
 **PROOF_STANDARD**  1 standard verification of important properties
 **PROOF_FULL**      2 all fields will be validated including uncles
==================== = ==================================================
```

#### in3_verification_t

Verification as delivered by the server. 

This will be part of the in3-request and will be generated based on the proof type. 

The enum type contains the following values:

```eval_rst
======================================= = ===============================
 **VERIFICATION_NEVER**                 0 no verification
 **VERIFICATION_PROOF**                 1 includes the proof of the data
 **VERIFICATION_PROOF_WITH_SIGNATURE**  2 proof + signatures
======================================= = ===============================
```

#### d_signature_type_t

The type of requested signature.

The enum type contains the following values:

```eval_rst
================== = ======================
 **SIGN_EC_RAW**   0 sign the data directly
 **SIGN_EC_HASH**  1 hash and sign the data
================== = ======================
```

#### in3_filter_type_t

The enum type contains the following values:

```eval_rst
==================== = ============================
 **FILTER_EVENT**    0 event filter.
 **FILTER_BLOCK**    1 block filter.
 **FILTER_PENDING**  2 pending filter (unsupported)
==================== = ============================
```

#### in3_request_config_t

The configuration as part of each Incubed request.

This will be generated for each request based on the client configuration. The verifier may access this during verification to check against the request. 

The stucture contains following fields:

```eval_rst
=========================================== ========================= ====================================================================
``uint64_t``                                 **chainId**              the chain to be used
                                                                      
                                                                      this is holding the integer-value of the hexstring
``uint8_t``                                  **includeCode**          if true, the code needed will always be delivered
``uint8_t``                                  **useFullProof**         this flaqg is set if the proof is set to "PROOF_FULL"
``uint8_t``                                  **useBinary**            this flaqg is set; the client should use binary format
`bytes_t * <#bytes-t>`_                      **verifiedHashes**       a list of blockhashes already verified
                                                                      
                                                                      the server will not send any proof for them again
``uint16_t``                                 **verifiedHashesCount**  number of verified blockhashes
``uint16_t``                                 **latestBlock**          the last blockNumber the NodeList changed
``uint16_t``                                 **finality**             number of signatures (in percent) needed to reach finality

`in3_verification_t <#in3-verification-t>`_  **verification**         verification type
`bytes_t * <#bytes-t>`_                      **clientSignature**      the signature of the client with the client key
`bytes_t * <#bytes-t>`_                      **signatures**           the addresses of servers requested to sign the blockhash
``uint8_t``                                  **signaturesCount**      number or addresses
=========================================== ========================= ====================================================================
```

#### in3_node_t

Incubed node configuration. 

This information is read from the registry contract and stored in this structure, representing a server or a node. 

The stucture contains the following fields:

```eval_rst
======================= ============== ================================================================================================
``uint32_t``             **index**     index within the NodeList, which is also used in the contract as a key
`bytes_t * <#bytes-t>`_  **address**   address of the server
``uint64_t``             **deposit**   the deposit stored in the registry contract, which this would lose if it's sent a wrong blockhash
``uint32_t``             **capacity**  the maximum capacity able to handle
``uint64_t``             **props**     a bit set used to identify the capabilities of the server
``char *``               **url**       the URL of the node
======================= ============== ================================================================================================
```

#### in3_node_weight_t

Weight or reputation of a node. 

Based on the past performance of the node, a weight is calculated and given faster nodes, a heigher weight, and a chance when selecting the next node from the NodeList. These weights will also be stored in the cache (if available).

The stucture contains following fields:

```eval_rst
============ ========================= ========================================
``float``     **weight**               current weight
``uint32_t``  **response_count**       counter for responses
``uint32_t``  **total_response_time**  total of all response times
``uint64_t``  **blacklistedUntil**     if >0 this node is blacklisted until k
                                       
                                       k is a Unix timestamp
============ ========================= ========================================
```

#### in3_chain_t

Chain definition inside Incubed. 

For Incubed, a chain can be any distributed network or database with Incubed support. 

The stucture contains following fields:

```eval_rst
=========================================== ==================== =================================================================================================================
``uint64_t``                                 **chainId**         chainId, which could be free or based on the public Ethereum networkId
`in3_chain_type_t <#in3-chain-type-t>`_      **type**            chain type
``uint64_t``                                 **lastBlock**       last blockNumber the NodeList was updated to, which is used to detect changes in the NodeList
``bool``                                     **needsUpdate**     if true, the NodeList should be updated and will trigger an `in3_nodeList`-request before the next request is sent
``int``                                      **nodeListLength**  number of nodes in the NodeList
`in3_node_t * <#in3-node-t>`_                **nodeList**        array of nodes
`in3_node_weight_t * <#in3-node-weight-t>`_  **weights**         stats and weights recorded for each node
`bytes_t ** <#bytes-t>`_                     **initAddresses**   array of addresses of nodes that should always be part of the NodeList
`bytes_t * <#bytes-t>`_                      **contract**        the address of the registry contract
`bytes32_t <#bytes32-t>`_                    **registry_id**     the identifier of the registry
``uint8_t``                                  **version**         version of the chain
`json_ctx_t * <#json-ctx-t>`_                **spec**            optional chain specification, defining the transactions and forks
=========================================== ==================== =================================================================================================================
```

#### in3_storage_get_item

Storage handler function for reading from cache.

```c
typedef bytes_t*(* in3_storage_get_item) (void *cptr, char *key)
```

returns: [`bytes_t *(*`](#bytes-t), the found result. If the key is found, this function should return the values as bytes, otherwise `NULL`.

#### in3_storage_set_item

Storage handler function for writing to the cache. 

```c
typedef void(* in3_storage_set_item) (void *cptr, char *key, bytes_t *value)
```

#### in3_storage_handler_t

Storage handler to handle cache. 

The stucture contains following fields:

```eval_rst
=============================================== ============== ============================================================
`in3_storage_get_item <#in3-storage-get-item>`_  **get_item**  function pointer returning a stored value for the given key
`in3_storage_set_item <#in3-storage-set-item>`_  **set_item**  function pointer setting a stored value for the given key
``void *``                                       **cptr**      custom pointer, which will be passed to functions
=============================================== ============== ============================================================
```

#### in3_sign

Signing function. 

Signs the given data and writes the signature to dst. The return value must be the number of bytes written to dst. In case of an error, a negative value must be returned. It should be one of the IN3_SIGN_ERR... values.

```c
typedef in3_ret_t(* in3_sign) (void *wallet, d_signature_type_t type, bytes_t message, bytes_t account, uint8_t *dst)
```

returns: [`in3_ret_t(*`](#in3-ret-t), the [result-status](#in3-ret-t) of the function.

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_signer_t

The stucture contains following fields:

```eval_rst
======================= ============ 
`in3_sign <#in3-sign>`_  **sign**    
``void *``               **wallet**  
======================= ============ 
```

#### in3_response_t

Response object. 

If the error has a length>0, the response will be rejected.

The stucture contains the following fields:

```eval_rst
=============== ============ ==================================
`sb_t <#sb-t>`_  **error**   a stringbuilder to add any errors
`sb_t <#sb-t>`_  **result**  a stringbuilder to add the result
=============== ============ ==================================
```

#### in3_transport_send

The transport function to be implemented by the transport provider.

```c
typedef in3_ret_t(* in3_transport_send) (char **urls, int urls_len, char *payload, in3_response_t *results)
```

returns: [`in3_ret_t(*`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_filter_t

The stucture contains following fields:

```eval_rst
========================================= ================ ==========================================================
`in3_filter_type_t <#in3-filter-type-t>`_  **type**        filter type: (event, block, or pending)
``char *``                                 **options**     associated filter options
``uint64_t``                               **last_block**  block number
                                                           
                                                           when filter was created or eth_getFilterChanges was called
``void(*``                                 **release**     method to release owned resources
========================================= ================ ==========================================================
```

#### in3_filter_handler_t

The stucture contains following fields:

```eval_rst
================================== =========== ================
`in3_filter_t ** <#in3-filter-t>`_  **array**  
``size_t``                          **count**  array of filters
================================== =========== ================
```

#### in3_t

Incubed configuration. 

This structure holds the configuration and also points to internal resources, such as filters or chain configurations. 

The stucture contains following fields:

```eval_rst
=================================================== ======================== =======================================================================================
``uint32_t``                                         **cacheTimeout**        number of seconds requests can be cached
``uint16_t``                                         **nodeLimit**           the limit of nodes to store in the client
`bytes_t * <#bytes-t>`_                              **key**                 the client key to sign requests
``uint32_t``                                         **maxCodeCache**        number of max bytes used to cache the code in memory
``uint32_t``                                         **maxBlockCache**       number of blocks cached in memory
`in3_proof_t <#in3-proof-t>`_                        **proof**               the type of proof used
``uint8_t``                                          **requestCount**        the number of requests sent when getting a first answer
``uint8_t``                                          **signatureCount**      the number of signatures used to proof the blockhash
``uint64_t``                                         **minDeposit**          minimum stake of the server
                                                                             
                                                                             Only nodes owning at least this amount will be chosen.
``uint16_t``                                         **replaceLatestBlock**  If specified, the blockNumber *latest* will be replaced by blockNumber-(specified value).
``uint16_t``                                         **finality**            the number of signatures in percent required for the request
``uint16_t``                                         **max_attempts**        the max number of attempts before giving up
``uint32_t``                                         **timeout**             specifies the number of milliseconds before the request times out
                                                                             
                                                                             increasing may be helpful if the device uses a slow connection
``uint64_t``                                         **chainId**             servers to filter for the given chain
                                                                             
                                                                             The chain-id based on EIP-155.
``uint8_t``                                          **autoUpdateList**      if true, the NodeList will be automatically updated if the lastBlock is newer
`in3_storage_handler_t * <#in3-storage-handler-t>`_  **cacheStorage**        a cache handler offering two functions (setItem(string,string), getItem(string))
`in3_signer_t * <#in3-signer-t>`_                    **signer**              signer structure managing a wallet
`in3_transport_send <#in3-transport-send>`_          **transport**           the transport handler sending requests
``uint8_t``                                          **includeCode**         includes the code when sending eth_call requests
``uint8_t``                                          **use_binary**          if true, the client will use binary format
``uint8_t``                                          **use_http**            if true, the client will try to use HTTP instead of HTTPS
`in3_chain_t * <#in3-chain-t>`_                      **chains**              chain spec and NodeList definitions
``uint16_t``                                         **chainsCount**         number of configured chains
`in3_filter_handler_t * <#in3-filter-handler-t>`_    **filters**             filter handler
=================================================== ======================== =======================================================================================
```

#### in3_new

```c
in3_t* in3_new();
```

Creates a new Incubed configuration and returns the pointer.

You need to free this instance with `in3_free` after use!

Before using the client, you still need to set the transport and optional the storage handlers:

- Example of initialization:

```c
// register verifiers
in3_register_eth_full();

// create new client
in3_t* client = in3_new();

// configure storage...
in3_storage_handler_t storage_handler;
storage_handler.get_item = storage_get_item;
storage_handler.set_item = storage_set_item;

// configure transport
client->transport    = send_curl;

// configure storage
client->cacheStorage = &storage_handler;

// init cache
in3_cache_init(client);

// ready to use ...
```

returns: [`in3_t *`](#in3-t) : the incubed instance. 

#### in3_client_rpc

```c
in3_ret_t in3_client_rpc(in3_t *c, char *method, char *params, char **result, char **error);
```

Sends a request and stores the result in the provided buffer.

arguments:
```eval_rst
=================== ============ ======================================================================================================================================================
`in3_t * <#in3-t>`_  **c**       the pointer to the Incubed client configuration
``char *``           **method**  the name of the RPC function to call
``char *``           **params**  docs for input parameter v
``char **``          **result**  Pointer to string, which will be set if the request was successful. This will hold the result as json-rpc-string. (Make sure you free this after use!)
``char **``          **error**   pointer to a string containing the error-message. (Make sure you free this after use!)
=================== ============ ======================================================================================================================================================
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_client_register_chain

```c
in3_ret_t in3_client_register_chain(in3_t *client, uint64_t chain_id, in3_chain_type_t type, address_t contract, bytes32_t registry_id, uint8_t version, json_ctx_t *spec);
```

Registers a new chain or replaces an existing one (but keeps the NodeList).

arguments:
```eval_rst
======================================= ================= =========================================
`in3_t * <#in3-t>`_                      **client**       the pointer to the incubed client config.
``uint64_t``                             **chain_id**     the chain id.
`in3_chain_type_t <#in3-chain-type-t>`_  **type**         the verification type of the chain.
`address_t <#address-t>`_                **contract**     contract of the registry.
`bytes32_t <#bytes32-t>`_                **registry_id**  the identifier of the registry.
``uint8_t``                              **version**      the chain version.
`json_ctx_t * <#json-ctx-t>`_            **spec**         chainspec or NULL.
======================================= ================= =========================================
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_client_add_node

```c
in3_ret_t in3_client_add_node(in3_t *client, uint64_t chain_id, char *url, uint64_t props, address_t address);
```

Adds a node to a chain or updates an existing node.

[in] public address of the signer. 

arguments:
```eval_rst
========================= ============== =========================================
`in3_t * <#in3-t>`_        **client**    the pointer to the Incubed client configuration
``uint64_t``               **chain_id**  the chain-id
``char *``                 **url**       URL of the nodes
``uint64_t``               **props**     properties of the node
`address_t <#address-t>`_  **address**   
========================= ============== =========================================
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_client_remove_node

```c
in3_ret_t in3_client_remove_node(in3_t *client, uint64_t chain_id, address_t address);
```

Removes a node from a NodeList.

[in] public address of the signer. 

arguments:
```eval_rst
========================= ============== =========================================
`in3_t * <#in3-t>`_        **client**    the pointer to the Incubed client configuration
``uint64_t``               **chain_id**  the chain-id
`address_t <#address-t>`_  **address**   
========================= ============== =========================================
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_client_clear_nodes

```c
in3_ret_t in3_client_clear_nodes(in3_t *client, uint64_t chain_id);
```

Removes all nodes from the NodeList.

[in] the chain-id. 

arguments:
```eval_rst
=================== ============== =========================================
`in3_t * <#in3-t>`_  **client**    the pointer to the Incubed client configuration
``uint64_t``         **chain_id**  
=================== ============== =========================================
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_free

```c
void in3_free(in3_t *a);
```

Frees the references of the client.

arguments:
```eval_rst
=================== ======= =================================================
`in3_t * <#in3-t>`_  **a**  the pointer to the Incubed client configuration to free
=================== ======= =================================================
```

#### in3_cache_init

```c
in3_ret_t in3_cache_init(in3_t *c);
```

Initializes the cache.

arguments:
```eval_rst
=================== ======= ==================
`in3_t * <#in3-t>`_  **c**  the Incubed client
=================== ======= ==================
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

### context.h

Requests context. 

This is used for each request holding requests and response-pointers.

Location: src/core/client/context.h

#### node_weight_t

The weight of a certain node as a linked list.

The stucture contains following fields:

```eval_rst
=========================================== ============ ===========================================================
`in3_node_t * <#in3-node-t>`_                **node**    the node definition including the URL
`in3_node_weight_t * <#in3-node-weight-t>`_  **weight**  the current weight and blacklisting-stats
``float``                                    **s**       the starting value
``float``                                    **w**       weight value
`weightstruct , * <#weight>`_                **next**    next in the linked list or NULL if this is the last element
=========================================== ============ ===========================================================
```

#### new_ctx

```c
in3_ctx_t* new_ctx(in3_t *client, char *req_data);
```

Creates a new context.

The request data will be parsed and represented in the context.

arguments:
```eval_rst
=================== ============== 
`in3_t * <#in3-t>`_  **client**    
``char *``           **req_data**  
=================== ============== 
```
returns: [`in3_ctx_t *`](#in3-ctx-t)

#### ctx_parse_response

```c
in3_ret_t ctx_parse_response(in3_ctx_t *ctx, char *response_data, int len);
```

arguments:
```eval_rst
=========================== =================== 
`in3_ctx_t * <#in3-ctx-t>`_  **ctx**            
``char *``                   **response_data**  
``int``                      **len**            
=========================== =================== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### free_ctx

```c
void free_ctx(in3_ctx_t *ctx);
```

arguments:
```eval_rst
=========================== ========= 
`in3_ctx_t * <#in3-ctx-t>`_  **ctx**  
=========================== ========= 
```

#### ctx_create_payload

```c
in3_ret_t ctx_create_payload(in3_ctx_t *c, sb_t *sb);
```

arguments:
```eval_rst
=========================== ======== 
`in3_ctx_t * <#in3-ctx-t>`_  **c**   
`sb_t * <#sb-t>`_            **sb**  
=========================== ======== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function.

*Please make sure you check if it was successful (`==IN3_OK`).*

#### ctx_set_error

```c
in3_ret_t ctx_set_error(in3_ctx_t *c, char *msg, in3_ret_t errnumber);
```

arguments:
```eval_rst
=========================== =============== 
`in3_ctx_t * <#in3-ctx-t>`_  **c**          
``char *``                   **msg**        
`in3_ret_t <#in3-ret-t>`_    **errnumber**  
=========================== =============== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### ctx_get_error

```c
in3_ret_t ctx_get_error(in3_ctx_t *ctx, int id);
```

arguments:
```eval_rst
=========================== ========= 
`in3_ctx_t * <#in3-ctx-t>`_  **ctx**  
``int``                      **id**   
=========================== ========= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_client_rpc_ctx

```c
in3_ctx_t* in3_client_rpc_ctx(in3_t *c, char *method, char *params);
```

Sends a request and returns a context used to access the result or errors.

This context MUST be freed with free_ctx(ctx) after use to release the resources.

arguments:
```eval_rst
=================== ============ 
`in3_t * <#in3-t>`_  **c**       
``char *``           **method**  
``char *``           **params**  
=================== ============ 
```
returns: [`in3_ctx_t *`](#in3-ctx-t)

#### free_ctx_nodes

```c
void free_ctx_nodes(node_weight_t *c);
```

arguments:
```eval_rst
=================================== ======= 
`node_weight_t * <#node-weight-t>`_  **c**  
=================================== ======= 
```

#### ctx_nodes_len

```c
int ctx_nodes_len(node_weight_t *root);
```

arguments:
```eval_rst
=================================== ========== 
`node_weight_t * <#node-weight-t>`_  **root**  
=================================== ========== 
```
returns: `int`

### nodelist.h

Handles NodeLists.

Location: src/core/client/nodelist.h

#### in3_nodelist_clear

```c
void in3_nodelist_clear(in3_chain_t *chain);
```

Removes all nodes and their weights from the NodeList.

arguments:
```eval_rst
=============================== =========== 
`in3_chain_t * <#in3-chain-t>`_  **chain**  
=============================== =========== 
```

#### in3_node_list_get

```c
in3_ret_t in3_node_list_get(in3_ctx_t *ctx, uint64_t chain_id, bool update, in3_node_t **nodeList, int *nodeListLength, in3_node_weight_t **weights);
```

Checks if the NodeList is up to date.

If not, it will fetch a new version first (if the needs_update-flag is set).

arguments:
```eval_rst
============================================ ==================== 
`in3_ctx_t * <#in3-ctx-t>`_                   **ctx**             
``uint64_t``                                  **chain_id**        
``bool``                                      **update**          
`in3_node_t ** <#in3-node-t>`_                **nodeList**        
``int *``                                     **nodeListLength**  
`in3_node_weight_t ** <#in3-node-weight-t>`_  **weights**         
============================================ ==================== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_node_list_fill_weight

```c
node_weight_t* in3_node_list_fill_weight(in3_t *c, in3_node_t *all_nodes, in3_node_weight_t *weights, int len, _time_t now, float *total_weight, int *total_found);
```

Filters and fills the weights on a returned linked list.

arguments:
```eval_rst
=========================================== ================== 
`in3_t * <#in3-t>`_                          **c**             
`in3_node_t * <#in3-node-t>`_                **all_nodes**     
`in3_node_weight_t * <#in3-node-weight-t>`_  **weights**       
``int``                                      **len**           
``_time_t``                                  **now**           
``float *``                                  **total_weight**  
``int *``                                    **total_found**   
=========================================== ================== 
```
returns: [`node_weight_t *`](#node-weight-t)

#### in3_node_list_pick_nodes

```c
in3_ret_t in3_node_list_pick_nodes(in3_ctx_t *ctx, node_weight_t **nodes);
```

Picks (based on the configuration) a random number of nodes and returns them as a weights list.

arguments:
```eval_rst
==================================== =========== 
`in3_ctx_t * <#in3-ctx-t>`_           **ctx**    
`node_weight_t ** <#node-weight-t>`_  **nodes**  
==================================== =========== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

### send.h

Handles caching and storage. 

Handles the request. 

Location: src/core/client/send.h

#### in3_send_ctx

```c
in3_ret_t in3_send_ctx(in3_ctx_t *ctx);
```

Executes a request context by picking nodes and sending it.

arguments:
```eval_rst
=========================== ========= 
`in3_ctx_t * <#in3-ctx-t>`_  **ctx**  
=========================== ========= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

### verifier.h

Verification context.

This context is passed to the verifier.

Location: src/core/client/verifier.h

#### in3_verify

Function to verify the result. 

```c
typedef in3_ret_t(* in3_verify) (in3_vctx_t *c)
```

returns: [`in3_ret_t(*`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_pre_handle

```c
typedef in3_ret_t(* in3_pre_handle) (in3_ctx_t *ctx, in3_response_t **response)
```

returns: [`in3_ret_t(*`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_verifier_t

The stucture contains following fields:

```eval_rst
======================================= ================ 
`in3_verify <#in3-verify>`_              **verify**      
``in3_pre_handle``                       **pre_handle**  
`in3_chain_type_t <#in3-chain-type-t>`_  **type**        
`verifierstruct , * <#verifier>`_        **next**        
======================================= ================ 
```

#### in3_get_verifier

```c
in3_verifier_t* in3_get_verifier(in3_chain_type_t type);
```

Returns the verifier for the given chain type.

arguments:
```eval_rst
======================================= ========== 
`in3_chain_type_t <#in3-chain-type-t>`_  **type**  
======================================= ========== 
```
returns: [`in3_verifier_t *`](#in3-verifier-t)

#### in3_register_verifier

```c
void in3_register_verifier(in3_verifier_t *verifier);
```

arguments:
```eval_rst
===================================== ============== 
`in3_verifier_t * <#in3-verifier-t>`_  **verifier**  
===================================== ============== 
```

#### vc_err

```c
in3_ret_t vc_err(in3_vctx_t *vc, char *msg);
```

arguments:
```eval_rst
============================= ========= 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**   
``char *``                     **msg**  
============================= ========= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

### bytes.h

Utility helper on byte arrays.

Location: src/core/util/bytes.h

#### bb_new ()

```c
#define bb_new () bb_newl(32)
```

#### bb_read (_bb_,_i_,_vptr_)

```c
#define bb_read (_bb_,_i_,_vptr_) bb_readl((_bb_), (_i_), (_vptr_), sizeof(*_vptr_))
```

#### bb_read_next (_bb_,_iptr_,_vptr_)

```c
#define bb_read_next (_bb_,_iptr_,_vptr_) do {                                          \
    size_t _l_ = sizeof(*_vptr_);               \
    bb_readl((_bb_), *(_iptr_), (_vptr_), _l_); \
    *(_iptr_) += _l_;                           \
  } while (0)
```

#### bb_readl (_bb_,_i_,_vptr_,_l_)

```c
#define bb_readl (_bb_,_i_,_vptr_,_l_) memcpy((_vptr_), (_bb_)->b.data + (_i_), _l_)
```

#### b_read (_b_,_i_,_vptr_)

```c
#define b_read (_b_,_i_,_vptr_) b_readl((_b_), (_i_), _vptr_, sizeof(*_vptr_))
```

#### b_readl (_b_,_i_,_vptr_,_l_)

```c
#define b_readl (_b_,_i_,_vptr_,_l_) memcpy(_vptr_, (_b_)->data + (_i_), (_l_))
```

#### address_t

Pointer to a 20-byte address.

```c
typedef uint8_t address_t[20]
```

#### bytes32_t

Pointer to a 32-byte word. 

```c
typedef uint8_t bytes32_t[32]
```

#### wlen_t

Number of bytes within a word (minimum 1 byte but usually a uint).

```c
typedef uint_fast8_t wlen_t
```

#### bytes_t

A byte array.

The stucture contains following fields:

```eval_rst
============= ========== =================================
``uint32_t``   **len**   the length of the array in bytes
``uint8_t *``  **data**  the byte-data
============= ========== =================================
```

#### b_new

```c
bytes_t* b_new(char *data, int len);
```

Allocates a new byte array with 0 filled.

arguments:
```eval_rst
========== ========== 
``char *``  **data**  
``int``     **len**   
========== ========== 
```
returns: [`bytes_t *`](#bytes-t)

#### b_print

```c
void b_print(bytes_t *a);
```

Prints the bytes as hex to stdout.

arguments:
```eval_rst
======================= ======= 
`bytes_t * <#bytes-t>`_  **a**  
======================= ======= 
```

#### ba_print

```c
void ba_print(uint8_t *a, size_t l);
```

Prints the bytes as hex to stdout.

arguments:
```eval_rst
============= ======= 
``uint8_t *``  **a**  
``size_t``     **l**  
============= ======= 
```

#### b_cmp

```c
int b_cmp(bytes_t *a, bytes_t *b);
```

Compares 2 byte arrays and returns 1 for equal and 0 for not equal.

arguments:
```eval_rst
======================= ======= 
`bytes_t * <#bytes-t>`_  **a**  
`bytes_t * <#bytes-t>`_  **b**  
======================= ======= 
```
returns: `int`

#### bytes_cmp

```c
int bytes_cmp(bytes_t a, bytes_t b);
```

Compares 2 byte arrays and returns 1 for equal and 0 for not equal.

arguments:
```eval_rst
===================== ======= 
`bytes_t <#bytes-t>`_  **a**  
`bytes_t <#bytes-t>`_  **b**  
===================== ======= 
```
returns: `int`

#### b_free

```c
void b_free(bytes_t *a);
```

Frees the data.

arguments:
```eval_rst
======================= ======= 
`bytes_t * <#bytes-t>`_  **a**  
======================= ======= 
```

#### b_dup

```c
bytes_t* b_dup(bytes_t *a);
```

clones a byte array 

arguments:
```eval_rst
======================= ======= 
`bytes_t * <#bytes-t>`_  **a**  
======================= ======= 
```
returns: [`bytes_t *`](#bytes-t)


#### b_read_byte

```c
uint8_t b_read_byte(bytes_t *b, size_t *pos);
```

Reads a byte on the current position and updates the pos afterward.

arguments:
```eval_rst
======================= ========= 
`bytes_t * <#bytes-t>`_  **b**    
``size_t *``             **pos**  
======================= ========= 
```
returns: `uint8_t`

#### b_read_short

```c
uint16_t b_read_short(bytes_t *b, size_t *pos);
```

Reads a short on the current position and updates the pos afterward.

arguments:
```eval_rst
======================= ========= 
`bytes_t * <#bytes-t>`_  **b**    
``size_t *``             **pos**  
======================= ========= 
```
returns: `uint16_t`

#### b_read_int

```c
uint32_t b_read_int(bytes_t *b, size_t *pos);
```

Reads an integer on the current position and updates the pos afterward.

arguments:
```eval_rst
======================= ========= 
`bytes_t * <#bytes-t>`_  **b**    
``size_t *``             **pos**  
======================= ========= 
```
returns: `uint32_t`

#### b_read_int_be

```c
uint32_t b_read_int_be(bytes_t *b, size_t *pos, size_t len);
```

Reads an unsigned integer as big-endian on the current position and updates the pos afterward.

arguments:
```eval_rst
======================= ========= 
`bytes_t * <#bytes-t>`_  **b**    
``size_t *``             **pos**  
``size_t``               **len**  
======================= ========= 
```
returns: `uint32_t`

#### b_read_long

```c
uint64_t b_read_long(bytes_t *b, size_t *pos);
```

Reads a long on the current position and updates the pos afterward.

arguments:
```eval_rst
======================= ========= 
`bytes_t * <#bytes-t>`_  **b**    
``size_t *``             **pos**  
======================= ========= 
```
returns: `uint64_t`

#### b_new_chars

```c
char* b_new_chars(bytes_t *b, size_t *pos);
```

Creates a new string (needs to be freed) on the current position and updates the pos afterward.

arguments:
```eval_rst
======================= ========= 
`bytes_t * <#bytes-t>`_  **b**    
``size_t *``             **pos**  
======================= ========= 
```
returns: `char *`

#### b_new_dyn_bytes

```c
bytes_t* b_new_dyn_bytes(bytes_t *b, size_t *pos);
```

Reads bytes (which have the length stored as prefix) on the current position and updates the pos afterward.

arguments:
```eval_rst
======================= ========= 
`bytes_t * <#bytes-t>`_  **b**    
``size_t *``             **pos**  
======================= ========= 
```
returns: [`bytes_t *`](#bytes-t)

#### b_new_fixed_bytes

```c
bytes_t* b_new_fixed_bytes(bytes_t *b, size_t *pos, int len);
```

Reads bytes with a fixed length on the current position and updates the pos afterward.

arguments:
```eval_rst
======================= ========= 
`bytes_t * <#bytes-t>`_  **b**    
``size_t *``             **pos**  
``int``                  **len**  
======================= ========= 
```
returns: [`bytes_t *`](#bytes-t)

#### bb_newl

```c
bytes_builder_t* bb_newl(size_t l);
```

arguments:
```eval_rst
========== ======= 
``size_t``  **l**  
========== ======= 
```
returns: [`bytes_builder_t *`](#bytes-builder-t)

#### bb_free

```c
void bb_free(bytes_builder_t *bb);
```

frees a bytebuilder and its content.

arguments:
```eval_rst
======================================= ======== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**  
======================================= ======== 
```

#### bb_check_size

```c
int bb_check_size(bytes_builder_t *bb, size_t len);
```

Internal helper to increase the buffer if needed.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
``size_t``                               **len**  
======================================= ========= 
```
returns: `int`

#### bb_write_chars

```c
void bb_write_chars(bytes_builder_t *bb, char *c, int len);
```

Writes a string to the builder.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
``char *``                               **c**    
``int``                                  **len**  
======================================= ========= 
```

#### bb_write_dyn_bytes

```c
void bb_write_dyn_bytes(bytes_builder_t *bb, bytes_t *src);
```

Writes bytes to the builder with a prefixed length.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
`bytes_t * <#bytes-t>`_                  **src**  
======================================= ========= 
```

#### bb_write_fixed_bytes

```c
void bb_write_fixed_bytes(bytes_builder_t *bb, bytes_t *src);
```

Writes fixed bytes to the builder.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
`bytes_t * <#bytes-t>`_                  **src**  
======================================= ========= 
```

#### bb_write_int

```c
void bb_write_int(bytes_builder_t *bb, uint32_t val);
```

Writes an integer to the builder.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
``uint32_t``                             **val**  
======================================= ========= 
```

#### bb_write_long

```c
void bb_write_long(bytes_builder_t *bb, uint64_t val);
```

Writes long to the builder.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
``uint64_t``                             **val**  
======================================= ========= 
```

#### bb_write_long_be

```c
void bb_write_long_be(bytes_builder_t *bb, uint64_t val, int len);
```

Writes any integer value with the given length of bytes.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
``uint64_t``                             **val**  
``int``                                  **len**  
======================================= ========= 
```

#### bb_write_byte

```c
void bb_write_byte(bytes_builder_t *bb, uint8_t val);
```

Writes a single byte to the builder.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
``uint8_t``                              **val**  
======================================= ========= 
```

#### bb_write_short

```c
void bb_write_short(bytes_builder_t *bb, uint16_t val);
```

Writes a short to the builder.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
``uint16_t``                             **val**  
======================================= ========= 
```

#### bb_write_raw_bytes

```c
void bb_write_raw_bytes(bytes_builder_t *bb, void *ptr, size_t len);
```

Writes the bytes to the builder.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
``void *``                               **ptr**  
``size_t``                               **len**  
======================================= ========= 
```

#### bb_clear

```c
void bb_clear(bytes_builder_t *bb);
```

Resets the content of the builder.

arguments:
```eval_rst
======================================= ======== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**  
======================================= ======== 
```

#### bb_replace

```c
void bb_replace(bytes_builder_t *bb, int offset, int delete_len, uint8_t *data, int data_len);
```

Replaces or deletes a part of the content.

arguments:
```eval_rst
======================================= ================ 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**          
``int``                                  **offset**      
``int``                                  **delete_len**  
``uint8_t *``                            **data**        
``int``                                  **data_len**    
======================================= ================ 
```

#### bb_move_to_bytes

```c
bytes_t* bb_move_to_bytes(bytes_builder_t *bb);
```

Frees the builder and moves the content in a newly created byte structure (which needs to be freed later).

arguments:
```eval_rst
======================================= ======== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**  
======================================= ======== 
```
returns: [`bytes_t *`](#bytes-t)

#### bb_push

```c
void bb_push(bytes_builder_t *bb, uint8_t *data, uint8_t len);
```

arguments:
```eval_rst
======================================= ========== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**    
``uint8_t *``                            **data**  
``uint8_t``                              **len**   
======================================= ========== 
```

#### bb_read_long

```c
uint64_t bb_read_long(bytes_builder_t *bb, size_t *i);
```

arguments:
```eval_rst
======================================= ======== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**  
``size_t *``                             **i**   
======================================= ======== 
```
returns: `uint64_t`

#### bb_read_int

```c
uint32_t bb_read_int(bytes_builder_t *bb, size_t *i);
```

arguments:
```eval_rst
======================================= ======== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**  
``size_t *``                             **i**   
======================================= ======== 
```
returns: `uint32_t`

#### bytes

```c
static bytes_t bytes(uint8_t *a, uint32_t len);
```

arguments:
```eval_rst
============= ========= 
``uint8_t *``  **a**    
``uint32_t``   **len**  
============= ========= 
```
returns: [`bytes_t`](#bytes-t)

#### cloned_bytes

```c
bytes_t cloned_bytes(bytes_t data);
```

arguments:
```eval_rst
===================== ========== 
`bytes_t <#bytes-t>`_  **data**  
===================== ========== 
```
returns: [`bytes_t`](#bytes-t)

#### b_optimize_len

```c
static void b_optimize_len(bytes_t *b);
```

arguments:
```eval_rst
======================= ======= 
`bytes_t * <#bytes-t>`_  **b**  
======================= ======= 
```

### data.h

JSON parser. 

The parser can read from:

- JSON
- bin

When reading from JSON, all '0x'... values will be stored as bytes_t. If the value is lower than 0xFFFFFFF, it is converted as an integer. 

Location: src/core/util/data.h

#### DATA_DEPTH_MAX

The max DEPTH of the JSON-data allowed. 

It will throw an error if reached.

```c
#define DATA_DEPTH_MAX 11
```

#### printX

```c
#define printX printf
```

#### fprintX

```c
#define fprintX fprintf
```

#### snprintX

```c
#define snprintX snprintf
```

#### vprintX

```c
#define vprintX vprintf
```

#### d_type_t

type of a token. 

The enum type contains the following values:

```eval_rst
=============== = =====================================================
 **T_BYTES**    0 content is stored as data ptr
 **T_STRING**   1 content is stored as c-str
 **T_ARRAY**    2 the node is an array with the length stored in length
 **T_OBJECT**   3 the node is an object with properties
 **T_BOOLEAN**  4 boolean with the value stored in len
 **T_INTEGER**  5 an integer with the value stored
 **T_NULL**     6 a NULL value
=============== = =====================================================
```

#### d_key_t

```c
typedef uint16_t d_key_t
```

#### d_token_t

A token holding any kind of value.

Use d_type, d_len or the cast-function to get the value.

The stucture contains following fields:

```eval_rst
============= ========== =====================================================================
``uint32_t``   **len**   the length of the content (or number of properties) depending + type
``uint8_t *``  **data**  the byte or string-data
``d_key_t``    **key**   the key of the property
============= ========== =====================================================================
```

#### str_range_t

Internal type used to represent the range within a string. 

The stucture contains following fields:

```eval_rst
========== ========== ==================================
``char *``  **data**  pointer to the start of the string
``size_t``  **len**   len of the characters
========== ========== ==================================
```

#### json_ctx_t

Parser for JSON or binary-data. 

It needs to freed after usage.

The stucture contains following fields:

```eval_rst
=========================== =============== ============================================================
`d_token_t * <#d-token-t>`_  **result**     the list of all tokens
                                            
                                            the first token is the main token as returned by the parser
``size_t``                   **allocated**  
``size_t``                   **len**        amount of tokens allocated in result
``size_t``                   **depth**      number of tokens in result
``char *``                   **c**          max depth of tokens in result
=========================== =============== ============================================================
```

#### d_iterator_t

Iterator over elements of an array OPF object. 

Usage:

```c
for (d_iterator_t iter = d_iter( parent ); iter.left ; d_iter_next(&iter)) {
  uint32_t val = d_int(iter.token);
}
```

The stucture contains the following fields:

```eval_rst
=========================== =========== =====================
``int``                      **left**   number of result left
`d_token_t * <#d-token-t>`_  **token**  current token
=========================== =========== =====================
```

#### d_to_bytes

```c
bytes_t d_to_bytes(d_token_t *item);
```

Returns the byte-representation of token.

In case of a number, it is returned as big-endian. Booleans as 0x01 or 0x00 and NULL as 0x. Objects or arrays will return 0x.

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
=========================== ========== 
```
returns: [`bytes_t`](#bytes-t)

#### d_bytes_to

```c
int d_bytes_to(d_token_t *item, uint8_t *dst, const int max);
```

Writes the byte-representation to the dst.

For details, see d_to_bytes.

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
``uint8_t *``                **dst**   
``const int``                **max**   
=========================== ========== 
```
returns: `int`

#### d_bytes

```c
bytes_t* d_bytes(const d_token_t *item);
```

Returns the value as bytes. (Carefully make sure that the token is a bytes-type!)

arguments:
```eval_rst
================================== ========== 
`d_token_tconst , * <#d-token-t>`_  **item**  
================================== ========== 
```
returns: [`bytes_t *`](#bytes-t)

#### d_bytesl

```c
bytes_t* d_bytesl(d_token_t *item, size_t l);
```

Returns the value as bytes with length l (may reallocate).

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
``size_t``                   **l**     
=========================== ========== 
```
returns: [`bytes_t *`](#bytes-t)

#### d_string

```c
char* d_string(const d_token_t *item);
```

Converts the value as string.

Make sure the type is string!

arguments:
```eval_rst
================================== ========== 
`d_token_tconst , * <#d-token-t>`_  **item**  
================================== ========== 
```
returns: `char *`

#### d_int

```c
uint32_t d_int(const d_token_t *item);
```

Returns the value as integer (but only if the type is integer).

arguments:
```eval_rst
================================== ========== 
`d_token_tconst , * <#d-token-t>`_  **item**  
================================== ========== 
```
returns: `uint32_t`

#### d_intd

```c
uint32_t d_intd(const d_token_t *item, const uint32_t def_val);
```

Returns the value as integer or if NULL, the default.

Only if type is integer.

arguments:
```eval_rst
================================== ============= 
`d_token_tconst , * <#d-token-t>`_  **item**     
``const uint32_t``                  **def_val**  
================================== ============= 
```
returns: `uint32_t`

#### d_long

```c
uint64_t d_long(const d_token_t *item);
```

Returns the value as long. 

Only if type is integer or bytes, but short enough.

arguments:
```eval_rst
================================== ========== 
`d_token_tconst , * <#d-token-t>`_  **item**  
================================== ========== 
```
returns: `uint64_t`

#### d_longd

```c
uint64_t d_longd(const d_token_t *item, const uint64_t def_val);
```

Returns the value as long or if NULL, the default.

Only if type is integer or bytes, but short enough.

arguments:
```eval_rst
================================== ============= 
`d_token_tconst , * <#d-token-t>`_  **item**     
``const uint64_t``                  **def_val**  
================================== ============= 
```
returns: `uint64_t`

#### d_create_bytes_vec

```c
bytes_t** d_create_bytes_vec(const d_token_t *arr);
```

arguments:
```eval_rst
================================== ========= 
`d_token_tconst , * <#d-token-t>`_  **arr**  
================================== ========= 
```
returns: [`bytes_t **`](#bytes-t)

#### d_type

```c
static d_type_t d_type(const d_token_t *item);
```

Creates an array of bytes from JSON-array.

Type of the token.

arguments:
```eval_rst
================================== ========== 
`d_token_tconst , * <#d-token-t>`_  **item**  
================================== ========== 
```
returns: [`d_type_t`](#d-type-t)

#### d_len

```c
static int d_len(const d_token_t *item);
```

Number of elements in the token (only for object or array, other will return 0).

arguments:
```eval_rst
================================== ========== 
`d_token_tconst , * <#d-token-t>`_  **item**  
================================== ========== 
```
returns: `int`

#### d_eq

```c
bool d_eq(const d_token_t *a, const d_token_t *b);
```

Compares two tokens and if the value is equal.

arguments:
```eval_rst
================================== ======= 
`d_token_tconst , * <#d-token-t>`_  **a**  
`d_token_tconst , * <#d-token-t>`_  **b**  
================================== ======= 
```
returns: `bool`

#### keyn

```c
d_key_t keyn(const char *c, const int len);
```

Generates the keyhash for the given stringrange as defined by len.

arguments:
```eval_rst
================ ========= 
``const char *``  **c**    
``const int``     **len**  
================ ========= 
```
returns: `d_key_t`

#### d_get

```c
d_token_t* d_get(d_token_t *item, const uint16_t key);
```

Returns the token with the given property name (only if item is an object).

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
``const uint16_t``           **key**   
=========================== ========== 
```
returns: [`d_token_t *`](#d-token-t)

#### d_get_or

```c
d_token_t* d_get_or(d_token_t *item, const uint16_t key1, const uint16_t key2);
```

Returns the token with the given property name or if not found, tries the other.

Only if item is an object.

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
``const uint16_t``           **key1**  
``const uint16_t``           **key2**  
=========================== ========== 
```
returns: [`d_token_t *`](#d-token-t)

#### d_get_at

```c
d_token_t* d_get_at(d_token_t *item, const uint32_t index);
```

Returns the token of an array with the given index.

arguments:
```eval_rst
=========================== =========== 
`d_token_t * <#d-token-t>`_  **item**   
``const uint32_t``           **index**  
=========================== =========== 
```
returns: [`d_token_t *`](#d-token-t)

#### d_next

```c
d_token_t* d_next(d_token_t *item);
```

Returns the next sibling of an array or object.

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
=========================== ========== 
```
returns: [`d_token_t *`](#d-token-t)

#### d_prev

```c
d_token_t* d_prev(d_token_t *item);
```

Returns the previous sibling of an array or object.

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
=========================== ========== 
```
returns: [`d_token_t *`](#d-token-t)

#### d_serialize_binary

```c
void d_serialize_binary(bytes_builder_t *bb, d_token_t *t);
```

Writes the token as binary data into the builder.

arguments:
```eval_rst
======================================= ======== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**  
`d_token_t * <#d-token-t>`_              **t**   
======================================= ======== 
```

#### parse_binary

```c
json_ctx_t* parse_binary(bytes_t *data);
```

Parses the data and returns the context with the token, which needs to be freed after usage!

arguments:
```eval_rst
======================= ========== 
`bytes_t * <#bytes-t>`_  **data**  
======================= ========== 
```
returns: [`json_ctx_t *`](#json-ctx-t)

#### parse_binary_str

```c
json_ctx_t* parse_binary_str(char *data, int len);
```

Parses the data and returns the context with the token, which needs to be freed after usage!

arguments:
```eval_rst
========== ========== 
``char *``  **data**  
``int``     **len**   
========== ========== 
```
returns: [`json_ctx_t *`](#json-ctx-t)

#### parse_json

```c
json_ctx_t* parse_json(char *js);
```

Rarses JSON-data, which needs to be freed after usage!

arguments:
```eval_rst
========== ======== 
``char *``  **js**  
========== ======== 
```
returns: [`json_ctx_t *`](#json-ctx-t)

#### free_json

```c
void free_json(json_ctx_t *parser_ctx);
```

Frees the parse-context after usage.

arguments:
```eval_rst
============================= ================ 
`json_ctx_t * <#json-ctx-t>`_  **parser_ctx**  
============================= ================ 
```

#### d_to_json

```c
str_range_t d_to_json(d_token_t *item);
```

Returns the string for an object or array.

This only works for JSON as string. For binary, it will not work!

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
=========================== ========== 
```
returns: [`str_range_t`](#str-range-t)

#### d_create_json

```c
char* d_create_json(d_token_t *item);
```

Creates a JSON-string. 

It does not work for objects if the parsed data is binary!

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
=========================== ========== 
```
returns: `char *`

#### json_create

```c
json_ctx_t* json_create();
```

returns: [`json_ctx_t *`](#json-ctx-t)

#### json_create_null

```c
d_token_t* json_create_null(json_ctx_t *jp);
```

arguments:
```eval_rst
============================= ======== 
`json_ctx_t * <#json-ctx-t>`_  **jp**  
============================= ======== 
```
returns: [`d_token_t *`](#d-token-t)

#### json_create_bool

```c
d_token_t* json_create_bool(json_ctx_t *jp, bool value);
```

arguments:
```eval_rst
============================= =========== 
`json_ctx_t * <#json-ctx-t>`_  **jp**     
``bool``                       **value**  
============================= =========== 
```
returns: [`d_token_t *`](#d-token-t)

#### json_create_int

```c
d_token_t* json_create_int(json_ctx_t *jp, uint64_t value);
```

arguments:
```eval_rst
============================= =========== 
`json_ctx_t * <#json-ctx-t>`_  **jp**     
``uint64_t``                   **value**  
============================= =========== 
```
returns: [`d_token_t *`](#d-token-t)

#### json_create_string

```c
d_token_t* json_create_string(json_ctx_t *jp, char *value);
```

arguments:
```eval_rst
============================= =========== 
`json_ctx_t * <#json-ctx-t>`_  **jp**     
``char *``                     **value**  
============================= =========== 
```
returns: [`d_token_t *`](#d-token-t)

#### json_create_bytes

```c
d_token_t* json_create_bytes(json_ctx_t *jp, bytes_t value);
```

arguments:
```eval_rst
============================= =========== 
`json_ctx_t * <#json-ctx-t>`_  **jp**     
`bytes_t <#bytes-t>`_          **value**  
============================= =========== 
```
returns: [`d_token_t *`](#d-token-t)

#### json_create_object

```c
d_token_t* json_create_object(json_ctx_t *jp);
```

arguments:
```eval_rst
============================= ======== 
`json_ctx_t * <#json-ctx-t>`_  **jp**  
============================= ======== 
```
returns: [`d_token_t *`](#d-token-t)

#### json_create_array

```c
d_token_t* json_create_array(json_ctx_t *jp);
```

arguments:
```eval_rst
============================= ======== 
`json_ctx_t * <#json-ctx-t>`_  **jp**  
============================= ======== 
```
returns: [`d_token_t *`](#d-token-t)

#### json_object_add_prop

```c
d_token_t* json_object_add_prop(d_token_t *object, d_key_t key, d_token_t *value);
```

arguments:
```eval_rst
=========================== ============ 
`d_token_t * <#d-token-t>`_  **object**  
``d_key_t``                  **key**     
`d_token_t * <#d-token-t>`_  **value**   
=========================== ============ 
```
returns: [`d_token_t *`](#d-token-t)

#### json_array_add_value

```c
d_token_t* json_array_add_value(d_token_t *object, d_token_t *value);
```

arguments:
```eval_rst
=========================== ============ 
`d_token_t * <#d-token-t>`_  **object**  
`d_token_t * <#d-token-t>`_  **value**   
=========================== ============ 
```
returns: [`d_token_t *`](#d-token-t)

#### json_get_int_value

```c
int json_get_int_value(char *js, char *prop);
```

Parses the JSON and returns the value as int.

arguments:
```eval_rst
========== ========== 
``char *``  **js**    
``char *``  **prop**  
========== ========== 
```
returns: `int`

#### json_get_str_value

```c
void json_get_str_value(char *js, char *prop, char *dst);
```

Parses the JSON and returns the value as string.

arguments:
```eval_rst
========== ========== 
``char *``  **js**    
``char *``  **prop**  
``char *``  **dst**   
========== ========== 
```

#### json_get_json_value

```c
char* json_get_json_value(char *js, char *prop);
```

Parses the JSON and returns the value as JSON-string.

arguments:
```eval_rst
========== ========== 
``char *``  **js**    
``char *``  **prop**  
========== ========== 
```
returns: `char *`

#### d_get_keystr

```c
char* d_get_keystr(d_key_t k);
```

Returns the string for a key.

This only works if track_keynames was activated before!

arguments:
```eval_rst
=========== ======= 
``d_key_t``  **k**  
=========== ======= 
```
returns: `char *`

#### d_track_keynames

```c
void d_track_keynames(uint8_t v);
```

Activates the keyname-cache, which stores the string for the keys when parsing.

arguments:
```eval_rst
=========== ======= 
``uint8_t``  **v**  
=========== ======= 
```

#### d_clear_keynames

```c
void d_clear_keynames();
```

Deletes the cached keynames.

#### key

```c
static d_key_t key(const char *c);
```

arguments:
```eval_rst
================ ======= 
``const char *``  **c**  
================ ======= 
```
returns: `d_key_t`

#### d_get_stringk

```c
static char* d_get_stringk(d_token_t *r, d_key_t k);
```

Reads token of a property as string.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``d_key_t``                  **k**  
=========================== ======= 
```
returns: `char *`

#### d_get_string

```c
static char* d_get_string(d_token_t *r, char *k);
```

Reads token of a property as string.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``char *``                   **k**  
=========================== ======= 
```
returns: `char *`

#### d_get_string_at

```c
static char* d_get_string_at(d_token_t *r, uint32_t pos);
```

Reads string at given pos of an array.

arguments:
```eval_rst
=========================== ========= 
`d_token_t * <#d-token-t>`_  **r**    
``uint32_t``                 **pos**  
=========================== ========= 
```
returns: `char *`

#### d_get_intk

```c
static uint32_t d_get_intk(d_token_t *r, d_key_t k);
```

Reads token of a property as int. 

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``d_key_t``                  **k**  
=========================== ======= 
```
returns: `uint32_t`

#### d_get_intkd

```c
static uint32_t d_get_intkd(d_token_t *r, d_key_t k, uint32_t d);
```

Reads token of a property as int.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``d_key_t``                  **k**  
``uint32_t``                 **d**  
=========================== ======= 
```
returns: `uint32_t`

#### d_get_int

```c
static uint32_t d_get_int(d_token_t *r, char *k);
```

Reads token of a property as int.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``char *``                   **k**  
=========================== ======= 
```
returns: `uint32_t`

#### d_get_int_at

```c
static uint32_t d_get_int_at(d_token_t *r, uint32_t pos);
```

Reads an int at given pos of an array.

arguments:
```eval_rst
=========================== ========= 
`d_token_t * <#d-token-t>`_  **r**    
``uint32_t``                 **pos**  
=========================== ========= 
```
returns: `uint32_t`

#### d_get_longk

```c
static uint64_t d_get_longk(d_token_t *r, d_key_t k);
```

Reads token of a property as long.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``d_key_t``                  **k**  
=========================== ======= 
```
returns: `uint64_t`

#### d_get_longkd

```c
static uint64_t d_get_longkd(d_token_t *r, d_key_t k, uint64_t d);
```

Reads token of a property as long.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``d_key_t``                  **k**  
``uint64_t``                 **d**  
=========================== ======= 
```
returns: `uint64_t`

#### d_get_long

```c
static uint64_t d_get_long(d_token_t *r, char *k);
```

Reads token of a property as long.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``char *``                   **k**  
=========================== ======= 
```
returns: `uint64_t`

#### d_get_long_at

```c
static uint64_t d_get_long_at(d_token_t *r, uint32_t pos);
```

Reads long at given pos of an array.

arguments:
```eval_rst
=========================== ========= 
`d_token_t * <#d-token-t>`_  **r**    
``uint32_t``                 **pos**  
=========================== ========= 
```
returns: `uint64_t`

#### d_get_bytesk

```c
static bytes_t* d_get_bytesk(d_token_t *r, d_key_t k);
```

Reads token of a property as bytes.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``d_key_t``                  **k**  
=========================== ======= 
```
returns: [`bytes_t *`](#bytes-t)

#### d_get_bytes

```c
static bytes_t* d_get_bytes(d_token_t *r, char *k);
```

Reads token of a property as bytes.

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **r**  
``char *``                   **k**  
=========================== ======= 
```
returns: [`bytes_t *`](#bytes-t)

#### d_get_bytes_at

```c
static bytes_t* d_get_bytes_at(d_token_t *r, uint32_t pos);
```

Reads bytes at given pos of an array.

arguments:
```eval_rst
=========================== ========= 
`d_token_t * <#d-token-t>`_  **r**    
``uint32_t``                 **pos**  
=========================== ========= 
```
returns: [`bytes_t *`](#bytes-t)

#### d_is_binary_ctx

```c
static bool d_is_binary_ctx(json_ctx_t *ctx);
```

Checks if the parser context was created from binary data.

arguments:
```eval_rst
============================= ========= 
`json_ctx_t * <#json-ctx-t>`_  **ctx**  
============================= ========= 
```
returns: `bool`

#### d_get_byteskl

```c
bytes_t* d_get_byteskl(d_token_t *r, d_key_t k, uint32_t minl);
```

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **r**     
``d_key_t``                  **k**     
``uint32_t``                 **minl**  
=========================== ========== 
```
returns: [`bytes_t *`](#bytes-t)

#### d_getl

```c
d_token_t* d_getl(d_token_t *item, uint16_t k, uint32_t minl);
```

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **item**  
``uint16_t``                 **k**     
``uint32_t``                 **minl**  
=========================== ========== 
```
returns: [`d_token_t *`](#d-token-t)

#### d_iter

```c
static d_iterator_t d_iter(d_token_t *parent);
```

Creates an iterator for an object or array.

arguments:
```eval_rst
=========================== ============ 
`d_token_t * <#d-token-t>`_  **parent**  
=========================== ============ 
```
returns: [`d_iterator_t`](#d-iterator-t)

#### d_iter_next

```c
static bool d_iter_next(d_iterator_t *const iter);
```

Fetches the next token and returns a boolean indicating whether there is a next or not.

arguments:
```eval_rst
====================================== ========== 
`d_iterator_t *const <#d-iterator-t>`_  **iter**  
====================================== ========== 
```
returns: `bool`

### debug.h

Logs debug data only if the DEBUG-flag is set.

Location: src/core/util/debug.h

#### dbg_log (msg,...)

#### dbg_log_raw (msg,...)

#### msg_dump

```c
void msg_dump(const char *s, unsigned char *data, unsigned len);
```

arguments:
```eval_rst
=================== ========== 
``const char *``     **s**     
``unsigned char *``  **data**  
``unsigned``         **len**   
=================== ========== 
```

### error.h

Defines the return-values of a function call.

Location: src/core/util/error.h

#### in3_ret_t

ERROR types used as return values.

All values (except IN3_OK) indicate an error.

The enum type contains the following values:

```eval_rst
================== === ============================================================
 **IN3_OK**        0   Success
 **IN3_EUNKNOWN**  -1  Unknown error - usually accompanied with specific error message
 **IN3_ENOMEM**    -2  No memory
 **IN3_ENOTSUP**   -3  Not supported
 **IN3_EINVAL**    -4  Invalid value
 **IN3_EFIND**     -5  Not found
 **IN3_ECONFIG**   -6  Invalid configuration
 **IN3_ELIMIT**    -7  Limit reached
 **IN3_EVERS**     -8  Version mismatch
 **IN3_EINVALDT**  -9  Data invalid (e.g., 
                       
                       invalid/incomplete JSON)
 **IN3_EPASS**     -10 Wrong password
 **IN3_ERPC**      -11 RPC error (e.g., 
                       
                       in3_ctx_t::error set)
 **IN3_ERPCNRES**  -12 RPC no response
 **IN3_EUSNURL**   -13 USN URL parse error
 **IN3_ETRANS**    -14 Transport error
================== === ============================================================
```

### scache.h

Utility helper on byte arrays.

Location: src/core/util/scache.h

#### cache_entry_t

The stucture contains the following fields:

```eval_rst
======================================= =============== 
`bytes_t <#bytes-t>`_                    **key**        
`bytes_t <#bytes-t>`_                    **value**      
``uint8_t``                              **must_free**  
``uint8_t``                              **buffer**     
`cache_entrystruct , * <#cache-entry>`_  **next**       
======================================= =============== 
```

#### in3_cache_get_entry

```c
bytes_t* in3_cache_get_entry(cache_entry_t *cache, bytes_t *key);
```

arguments:
```eval_rst
=================================== =========== 
`cache_entry_t * <#cache-entry-t>`_  **cache**  
`bytes_t * <#bytes-t>`_              **key**    
=================================== =========== 
```
returns: [`bytes_t *`](#bytes-t)

#### in3_cache_add_entry

```c
cache_entry_t* in3_cache_add_entry(cache_entry_t *cache, bytes_t key, bytes_t value);
```

arguments:
```eval_rst
=================================== =========== 
`cache_entry_t * <#cache-entry-t>`_  **cache**  
`bytes_t <#bytes-t>`_                **key**    
`bytes_t <#bytes-t>`_                **value**  
=================================== =========== 
```
returns: [`cache_entry_t *`](#cache-entry-t)

#### in3_cache_free

```c
void in3_cache_free(cache_entry_t *cache);
```

arguments:
```eval_rst
=================================== =========== 
`cache_entry_t * <#cache-entry-t>`_  **cache**  
=================================== =========== 
```

### stringbuilder.h

Simple string buffer used to dynamically add content.

Location: src/core/util/stringbuilder.h

#### sb_add_hexuint (sb,i)

```c
#define sb_add_hexuint (sb,i) sb_add_hexuint_l(sb, i, sizeof(i))
```

#### sb_t

The stucture contains following fields:

```eval_rst
========== ============== 
``char *``  **data**      
``size_t``  **allocated**  
``size_t``  **len**       
========== ============== 
```

#### sb_new

```c
sb_t* sb_new(char *chars);
```

arguments:
```eval_rst
========== =========== 
``char *``  **chars**  
========== =========== 
```
returns: [`sb_t *`](#sb-t)

#### sb_init

```c
sb_t* sb_init(sb_t *sb);
```

arguments:
```eval_rst
================= ======== 
`sb_t * <#sb-t>`_  **sb**  
================= ======== 
```
returns: [`sb_t *`](#sb-t)

#### sb_free

```c
void sb_free(sb_t *sb);
```

arguments:
```eval_rst
================= ======== 
`sb_t * <#sb-t>`_  **sb**  
================= ======== 
```

#### sb_add_char

```c
sb_t* sb_add_char(sb_t *sb, char c);
```

arguments:
```eval_rst
================= ======== 
`sb_t * <#sb-t>`_  **sb**  
``char``           **c**   
================= ======== 
```
returns: [`sb_t *`](#sb-t)

#### sb_add_chars

```c
sb_t* sb_add_chars(sb_t *sb, char *chars);
```

arguments:
```eval_rst
================= =========== 
`sb_t * <#sb-t>`_  **sb**     
``char *``         **chars**  
================= =========== 
```
returns: [`sb_t *`](#sb-t)

#### sb_add_range

```c
sb_t* sb_add_range(sb_t *sb, const char *chars, int start, int len);
```

arguments:
```eval_rst
================= =========== 
`sb_t * <#sb-t>`_  **sb**     
``const char *``   **chars**  
``int``            **start**  
``int``            **len**    
================= =========== 
```
returns: [`sb_t *`](#sb-t)

#### sb_add_key_value

```c
sb_t* sb_add_key_value(sb_t *sb, char *key, char *value, int lv, bool as_string);
```

arguments:
```eval_rst
================= =============== 
`sb_t * <#sb-t>`_  **sb**         
``char *``         **key**        
``char *``         **value**      
``int``            **lv**         
``bool``           **as_string**  
================= =============== 
```
returns: [`sb_t *`](#sb-t)

#### sb_add_bytes

```c
sb_t* sb_add_bytes(sb_t *sb, char *prefix, bytes_t *bytes, int len, bool as_array);
```

arguments:
```eval_rst
======================= ============== 
`sb_t * <#sb-t>`_        **sb**        
``char *``               **prefix**    
`bytes_t * <#bytes-t>`_  **bytes**     
``int``                  **len**       
``bool``                 **as_array**  
======================= ============== 
```
returns: [`sb_t *`](#sb-t)

#### sb_add_hexuint_l

```c
sb_t* sb_add_hexuint_l(sb_t *sb, uintmax_t uint, size_t l);
```

Other types not supported.

arguments:
```eval_rst
================= ========== 
`sb_t * <#sb-t>`_  **sb**    
``uintmax_t``      **uint**  
``size_t``         **l**     
================= ========== 
```
returns: [`sb_t *`](#sb-t)

### utils.h

Utility functions.

Location: src/core/util/utils.h

#### SWAP (a,b)

```c
#define SWAP (a,b) {                \
    void* p = a;   \
    a       = b;   \
    b       = p;   \
  }
```

#### min (a,b)

```c
#define min (a,b) ((a) < (b) ? (a) : (b))
```

#### max (a,b)

```c
#define max (a,b) ((a) > (b) ? (a) : (b))
```

#### optimize_len (a,l)

```c
#define optimize_len (a,l) while (l > 1 && *a == 0) { \
    l--;                     \
    a++;                     \
  }
```

#### TRY (exp)

```c
#define TRY (exp) {                        \
    int _r = (exp);        \
    if (_r < 0) return _r; \
  }
```

#### TRY_SET (var,exp)

```c
#define TRY_SET (var,exp) {                          \
    var = (exp);             \
    if (var < 0) return var; \
  }
```

#### TRY_GOTO (exp)

```c
#define TRY_GOTO (exp) {                          \
    res = (exp);             \
    if (res < 0) goto clean; \
  }
```

#### pb_size_t

```c
typedef uint32_t pb_size_t
```

#### pb_byte_t

```c
typedef uint_least8_t pb_byte_t
```

#### bytes_to_long

```c
uint64_t bytes_to_long(uint8_t *data, int len);
```

Converts the bytes to an unsigned long (at least the last max len bytes).

arguments:
```eval_rst
============= ========== 
``uint8_t *``  **data**  
``int``        **len**   
============= ========== 
```
returns: `uint64_t`

#### bytes_to_int

```c
static uint32_t bytes_to_int(uint8_t *data, int len);
```

Converts the bytes to an unsigned int (at least the last max len bytes).

arguments:
```eval_rst
============= ========== 
``uint8_t *``  **data**  
``int``        **len**   
============= ========== 
```
returns: `uint32_t`

#### c_to_long

```c
uint64_t c_to_long(char *a, int l);
```

Converts a character into a uint64_t.

arguments:
```eval_rst
========== ======= 
``char *``  **a**  
``int``     **l**  
========== ======= 
```
returns: `uint64_t`

#### size_of_bytes

```c
int size_of_bytes(int str_len);
```

The number of bytes used for converting a hex into bytes.

arguments:
```eval_rst
======= ============= 
``int``  **str_len**  
======= ============= 
```
returns: `int`

#### strtohex

```c
uint8_t strtohex(char c);
```

Converts a hexchar to byte (4-bit).

arguments:
```eval_rst
======== ======= 
``char``  **c**  
======== ======= 
```
returns: `uint8_t`

#### u64tostr

```c
const unsigned char* u64tostr(uint64_t value, char *pBuf, int szBuf);
```

Converts a uint64_t to string (char*), buffer-size minimum 21 bytes.

arguments:
```eval_rst
============ =========== 
``uint64_t``  **value**  
``char *``    **pBuf**   
``int``       **szBuf**  
============ =========== 
```
returns: `const unsigned char *`

#### hex2byte_arr

```c
int hex2byte_arr(char *buf, int len, uint8_t *out, int outbuf_size);
```

Convert a C string to a byte array, storing it into an existing buffer.

arguments:
```eval_rst
============= ================= 
``char *``     **buf**          
``int``        **len**          
``uint8_t *``  **out**          
``int``        **outbuf_size**  
============= ================= 
```
returns: `int`

#### hex2byte_new_bytes

```c
bytes_t* hex2byte_new_bytes(char *buf, int len);
```

Convert a C string to a byte array, creating a new buffer.

arguments:
```eval_rst
========== ========= 
``char *``  **buf**  
``int``     **len**  
========== ========= 
```
returns: [`bytes_t *`](#bytes-t)

#### bytes_to_hex

```c
int bytes_to_hex(uint8_t *buffer, int len, char *out);
```

Converts bytes into hex.

arguments:
```eval_rst
============= ============ 
``uint8_t *``  **buffer**  
``int``        **len**     
``char *``     **out**     
============= ============ 
```
returns: `int`

#### sha3

```c
bytes_t* sha3(bytes_t *data);
```

Hashes the bytes and creates a new bytes_t.

arguments:
```eval_rst
======================= ========== 
`bytes_t * <#bytes-t>`_  **data**  
======================= ========== 
```
returns: [`bytes_t *`](#bytes-t)

#### sha3_to

```c
int sha3_to(bytes_t *data, void *dst);
```

Writes 32 bytes to the pointer.

arguments:
```eval_rst
======================= ========== 
`bytes_t * <#bytes-t>`_  **data**  
``void *``               **dst**   
======================= ========== 
```
returns: `int`

#### long_to_bytes

```c
void long_to_bytes(uint64_t val, uint8_t *dst);
```

Converts a long to 8 bytes.

arguments:
```eval_rst
============= ========= 
``uint64_t``   **val**  
``uint8_t *``  **dst**  
============= ========= 
```

#### int_to_bytes

```c
void int_to_bytes(uint32_t val, uint8_t *dst);
```

Converts an int to 4 bytes.

arguments:
```eval_rst
============= ========= 
``uint32_t``   **val**  
``uint8_t *``  **dst**  
============= ========= 
```

#### hash_cmp

```c
int hash_cmp(uint8_t *a, uint8_t *b);
```

Compares 32 bytes and returns 0 if equal.

arguments:
```eval_rst
============= ======= 
``uint8_t *``  **a**  
``uint8_t *``  **b**  
============= ======= 
```
returns: `int`

#### _strdupn

```c
char* _strdupn(char *src, int len);
```

Duplicates the string.

arguments:
```eval_rst
========== ========= 
``char *``  **src**  
``int``     **len**  
========== ========= 
```
returns: `char *`

#### min_bytes_len

```c
int min_bytes_len(uint64_t val);
```

Calculate the minimum number of bytes to represents the len.

arguments:
```eval_rst
============ ========= 
``uint64_t``  **val**  
============ ========= 
```
returns: `int`

## Module Transport/curl 

Add an option.

### in3_curl.h

Transport-handler using libcurl.

Location: src/transport/curl/in3_curl.h

#### send_curl

```c
in3_ret_t send_curl(char **urls, int urls_len, char *payload, in3_response_t *result);
```

arguments:
```eval_rst
===================================== ============== 
``char **``                            **urls**      
``int``                                **urls_len**  
``char *``                             **payload**   
`in3_response_t * <#in3-response-t>`_  **result**    
===================================== ============== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

## Module Transport/http 

For detecting Windows compilers.

target_link_libraries(transport_curl ws2_32 wsock32 pthread )

### in3_http.h

Transport-handler using simple HTTP.

Location: src/transport/http/in3_http.h

#### send_http

```c
in3_ret_t send_http(char **urls, int urls_len, char *payload, in3_response_t *result);
```

arguments:
```eval_rst
===================================== ============== 
``char **``                            **urls**      
``int``                                **urls_len**  
``char *``                             **payload**   
`in3_response_t * <#in3-response-t>`_  **result**    
===================================== ============== 
```
returns: [`in3_ret_t`](#in3-ret-t) the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

## Module Verifier/eth1/basic 

Static lib.

### eth_basic.h

Ethereum nano verification.

Location: src/verifier/eth1/basic/eth_basic.h

#### in3_verify_eth_basic

```c
in3_ret_t in3_verify_eth_basic(in3_vctx_t *v);
```

Entry function to execute the verification context.

arguments:
```eval_rst
============================= ======= 
`in3_vctx_t * <#in3-vctx-t>`_  **v**  
============================= ======= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_verify_tx_values

```c
in3_ret_t eth_verify_tx_values(in3_vctx_t *vc, d_token_t *tx, bytes_t *raw);
```

Verifies internal tx-values.

arguments:
```eval_rst
============================= ========= 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**   
`d_token_t * <#d-token-t>`_    **tx**   
`bytes_t * <#bytes-t>`_        **raw**  
============================= ========= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_verify_eth_getTransaction

```c
in3_ret_t eth_verify_eth_getTransaction(in3_vctx_t *vc, bytes_t *tx_hash);
```

Verifies a transaction.

arguments:
```eval_rst
============================= ============= 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**       
`bytes_t * <#bytes-t>`_        **tx_hash**  
============================= ============= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_verify_account_proof

```c
in3_ret_t eth_verify_account_proof(in3_vctx_t *vc);
```

Verifies account proofs. 

arguments:
```eval_rst
============================= ======== 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**  
============================= ======== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_verify_eth_getBlock

```c
in3_ret_t eth_verify_eth_getBlock(in3_vctx_t *vc, bytes_t *block_hash, uint64_t blockNumber);
```

Verifies a block.

arguments:
```eval_rst
============================= ================= 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**           
`bytes_t * <#bytes-t>`_        **block_hash**   
``uint64_t``                   **blockNumber**  
============================= ================= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_register_eth_basic

```c
void in3_register_eth_basic();
```

This function should only be called once and will register the eth-nano verifier.

#### eth_verify_eth_getLog

```c
in3_ret_t eth_verify_eth_getLog(in3_vctx_t *vc, int l_logs);
```

Verifies logs.

arguments:
```eval_rst
============================= ============ 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**      
``int``                        **l_logs**  
============================= ============ 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_handle_intern

```c
in3_ret_t eth_handle_intern(in3_ctx_t *ctx, in3_response_t **response);
```

This is called before a request is sent.

arguments:
```eval_rst
====================================== ============== 
`in3_ctx_t * <#in3-ctx-t>`_             **ctx**       
`in3_response_t ** <#in3-response-t>`_  **response**  
====================================== ============== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

### signer.h

Ethereum nano verification.

Location: src/verifier/eth1/basic/signer.h

#### eth_set_pk_signer

```c
in3_ret_t eth_set_pk_signer(in3_t *in3, bytes32_t pk);
```

Sets the signer and a pk to the client.

arguments:
```eval_rst
========================= ========= 
`in3_t * <#in3-t>`_        **in3**  
`bytes32_t <#bytes32-t>`_  **pk**   
========================= ========= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

### trie.h

Patricia Merkle tree implementation.

Location: src/verifier/eth1/basic/trie.h

#### trie_node_type_t

Node types.

The enum type contains the following values:

```eval_rst
================= = ============================
 **NODE_EMPTY**   0 empty node
 **NODE_BRANCH**  1 a branch
 **NODE_LEAF**    2 a leaf containing the value
 **NODE_EXT**     3 an extension
================= = ============================
```

#### in3_hasher_t

Hash-function.

```c
typedef void(* in3_hasher_t) (bytes_t *src, uint8_t *dst)
```

#### in3_codec_add_t

Codec to organize the encoding of the nodes.

```c
typedef void(* in3_codec_add_t) (bytes_builder_t *bb, bytes_t *val)
```

#### in3_codec_finish_t

```c
typedef void(* in3_codec_finish_t) (bytes_builder_t *bb, bytes_t *dst)
```

#### in3_codec_decode_size_t

```c
typedef int(* in3_codec_decode_size_t) (bytes_t *src)
```

returns: `int(*`

#### in3_codec_decode_index_t

```c
typedef int(* in3_codec_decode_index_t) (bytes_t *src, int index, bytes_t *dst)
```

returns: `int(*`

#### trie_node_t

Single node in the Merkle trie.

The stucture contains the following fields:

```eval_rst
======================================= ================ ===============================================
``uint8_t``                              **hash**        the hash of the node
`bytes_t <#bytes-t>`_                    **data**        the raw data
`bytes_t <#bytes-t>`_                    **items**       the data as a list
``uint8_t``                              **own_memory**  if true, this is an embedded node with own memory
`trie_node_type_t <#trie-node-type-t>`_  **type**        type of the node
`trie_nodestruct , * <#trie-node>`_      **next**        used as linked list
======================================= ================ ===============================================
```

#### trie_codec_t

The codec used to encode nodes.

The stucture contains following fields:

```eval_rst
===================================== =================== 
`in3_codec_add_t <#in3-codec-add-t>`_  **encode_add**     
``in3_codec_finish_t``                 **encode_finish**  
``in3_codec_decode_size_t``            **decode_size**    
``in3_codec_decode_index_t``           **decode_item**    
===================================== =================== 
```

#### trie_t

A merkle trie implementation.

This is a Patricia Merkle tree. 

The stucture contains the following fields:

```eval_rst
================================= ============ ==============================
`in3_hasher_t <#in3-hasher-t>`_    **hasher**  hash-function
`trie_codec_t * <#trie-codec-t>`_  **codec**   encoding of the nodes
``uint8_t``                        **root**    the root-hash
`trie_node_t * <#trie-node-t>`_    **nodes**   linked list of contained nodes
================================= ============ ==============================
```

#### trie_new

```c
trie_t* trie_new();
```

Creates a new Merkle trie. 

returns: [`trie_t *`](#trie-t)

#### trie_free

```c
void trie_free(trie_t *val);
```

Frees all resources of the trie.

arguments:
```eval_rst
===================== ========= 
`trie_t * <#trie-t>`_  **val**  
===================== ========= 
```

#### trie_set_value

```c
void trie_set_value(trie_t *t, bytes_t *key, bytes_t *value);
```

Sets a value in the trie.

The root-hash will be updated automatically.

arguments:
```eval_rst
======================= =========== 
`trie_t * <#trie-t>`_    **t**      
`bytes_t * <#bytes-t>`_  **key**    
`bytes_t * <#bytes-t>`_  **value**  
======================= =========== 
```

## Module verifier/eth1/full 

Adds gas-calculation.

ADD_DEFINITIONS(-DEVM_GAS).

Adds dependency.

### big.h

Ethereum nano verification.

Location: src/verifier/eth1/full/big.h

#### big_is_zero

```c
uint8_t big_is_zero(uint8_t *data, wlen_t l);
```

arguments:
```eval_rst
=================== ========== 
``uint8_t *``        **data**  
`wlen_t <#wlen-t>`_  **l**     
=================== ========== 
```
returns: `uint8_t`

#### big_shift_left

```c
void big_shift_left(uint8_t *a, wlen_t len, int bits);
```

arguments:
```eval_rst
=================== ========== 
``uint8_t *``        **a**     
`wlen_t <#wlen-t>`_  **len**   
``int``              **bits**  
=================== ========== 
```

#### big_shift_right

```c
void big_shift_right(uint8_t *a, wlen_t len, int bits);
```

arguments:
```eval_rst
=================== ========== 
``uint8_t *``        **a**     
`wlen_t <#wlen-t>`_  **len**   
``int``              **bits**  
=================== ========== 
```

#### big_cmp

```c
int big_cmp(const uint8_t *a, const wlen_t len_a, const uint8_t *b, const wlen_t len_b);
```

arguments:
```eval_rst
========================= =========== 
``const uint8_t *``        **a**      
`wlen_tconst  <#wlen-t>`_  **len_a**  
``const uint8_t *``        **b**      
`wlen_tconst  <#wlen-t>`_  **len_b**  
========================= =========== 
```
returns: `int`

#### big_signed

```c
int big_signed(uint8_t *val, wlen_t len, uint8_t *dst);
```

Returns 0 if the value is positive or 1 if negative.

In this case, the absolute value is copied to dst.

arguments:
```eval_rst
=================== ========= 
``uint8_t *``        **val**  
`wlen_t <#wlen-t>`_  **len**  
``uint8_t *``        **dst**  
=================== ========= 
```
returns: `int`

#### big_int

```c
int32_t big_int(uint8_t *val, wlen_t len);
```

arguments:
```eval_rst
=================== ========= 
``uint8_t *``        **val**  
`wlen_t <#wlen-t>`_  **len**  
=================== ========= 
```
returns: `int32_t`

#### big_add

```c
int big_add(uint8_t *a, wlen_t len_a, uint8_t *b, wlen_t len_b, uint8_t *out, wlen_t max);
```

arguments:
```eval_rst
=================== =========== 
``uint8_t *``        **a**      
`wlen_t <#wlen-t>`_  **len_a**  
``uint8_t *``        **b**      
`wlen_t <#wlen-t>`_  **len_b**  
``uint8_t *``        **out**    
`wlen_t <#wlen-t>`_  **max**    
=================== =========== 
```
returns: `int`

#### big_sub

```c
int big_sub(uint8_t *a, wlen_t len_a, uint8_t *b, wlen_t len_b, uint8_t *out);
```

arguments:
```eval_rst
=================== =========== 
``uint8_t *``        **a**      
`wlen_t <#wlen-t>`_  **len_a**  
``uint8_t *``        **b**      
`wlen_t <#wlen-t>`_  **len_b**  
``uint8_t *``        **out**    
=================== =========== 
```
returns: `int`

#### big_mul

```c
int big_mul(uint8_t *a, wlen_t la, uint8_t *b, wlen_t lb, uint8_t *res, wlen_t max);
```

arguments:
```eval_rst
=================== ========= 
``uint8_t *``        **a**    
`wlen_t <#wlen-t>`_  **la**   
``uint8_t *``        **b**    
`wlen_t <#wlen-t>`_  **lb**   
``uint8_t *``        **res**  
`wlen_t <#wlen-t>`_  **max**  
=================== ========= 
```
returns: `int`

#### big_div

```c
int big_div(uint8_t *a, wlen_t la, uint8_t *b, wlen_t lb, wlen_t sig, uint8_t *res);
```

arguments:
```eval_rst
=================== ========= 
``uint8_t *``        **a**    
`wlen_t <#wlen-t>`_  **la**   
``uint8_t *``        **b**    
`wlen_t <#wlen-t>`_  **lb**   
`wlen_t <#wlen-t>`_  **sig**  
``uint8_t *``        **res**  
=================== ========= 
```
returns: `int`

#### big_mod

```c
int big_mod(uint8_t *a, wlen_t la, uint8_t *b, wlen_t lb, wlen_t sig, uint8_t *res);
```

arguments:
```eval_rst
=================== ========= 
``uint8_t *``        **a**    
`wlen_t <#wlen-t>`_  **la**   
``uint8_t *``        **b**    
`wlen_t <#wlen-t>`_  **lb**   
`wlen_t <#wlen-t>`_  **sig**  
``uint8_t *``        **res**  
=================== ========= 
```
returns: `int`

#### big_exp

```c
int big_exp(uint8_t *a, wlen_t la, uint8_t *b, wlen_t lb, uint8_t *res);
```

arguments:
```eval_rst
=================== ========= 
``uint8_t *``        **a**    
`wlen_t <#wlen-t>`_  **la**   
``uint8_t *``        **b**    
`wlen_t <#wlen-t>`_  **lb**   
``uint8_t *``        **res**  
=================== ========= 
```
returns: `int`

#### big_log256

```c
int big_log256(uint8_t *a, wlen_t len);
```

arguments:
```eval_rst
=================== ========= 
``uint8_t *``        **a**    
`wlen_t <#wlen-t>`_  **len**  
=================== ========= 
```
returns: `int`

### code.h

Code cache. 

Location: src/verifier/eth1/full/code.h

#### in3_get_code

```c
cache_entry_t* in3_get_code(in3_vctx_t *vc, uint8_t *address);
```

arguments:
```eval_rst
============================= ============= 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**       
``uint8_t *``                  **address**  
============================= ============= 
```
returns: [`cache_entry_t *`](#cache-entry-t)

### eth_full.h

Ethereum nano verification.

Location: src/verifier/eth1/full/eth_full.h

#### in3_verify_eth_full

```c
int in3_verify_eth_full(in3_vctx_t *v);
```

Entry function to execute the verification context.

arguments:
```eval_rst
============================= ======= 
`in3_vctx_t * <#in3-vctx-t>`_  **v**  
============================= ======= 
```
returns: `int`

#### in3_register_eth_full

```c
void in3_register_eth_full();
```

This function should only be called once and will register the eth-full verifier.

### evm.h

Main evm-file.

Location: src/verifier/eth1/full/evm.h

#### EVM_ERROR_EMPTY_STACK

The no more elements on the stack.

```c
#define EVM_ERROR_EMPTY_STACK -1
```

#### EVM_ERROR_INVALID_OPCODE

The opcode is not supported.

```c
#define EVM_ERROR_INVALID_OPCODE -2
```

#### EVM_ERROR_BUFFER_TOO_SMALL

Reading data from a position, which is not initialized.

```c
#define EVM_ERROR_BUFFER_TOO_SMALL -3
```

#### EVM_ERROR_ILLEGAL_MEMORY_ACCESS

The memory-offset does not exist.

```c
#define EVM_ERROR_ILLEGAL_MEMORY_ACCESS -4
```

#### EVM_ERROR_INVALID_JUMPDEST

The jump destination is not marked as a valid destination.

```c
#define EVM_ERROR_INVALID_JUMPDEST -5
```

#### EVM_ERROR_INVALID_PUSH

The push data is empty.

```c
#define EVM_ERROR_INVALID_PUSH -6
```

#### EVM_ERROR_UNSUPPORTED_CALL_OPCODE

Error handling the call, usually because static-calls are not allowed to change state.

```c
#define EVM_ERROR_UNSUPPORTED_CALL_OPCODE -7
```

#### EVM_ERROR_TIMEOUT

The EVM ran into a loop.

```c
#define EVM_ERROR_TIMEOUT -8
```

#### EVM_ERROR_INVALID_ENV

The enviroment could not deliver the data.

```c
#define EVM_ERROR_INVALID_ENV -9
```

#### EVM_ERROR_OUT_OF_GAS

Not enough gas to execute the opcode.

```c
#define EVM_ERROR_OUT_OF_GAS -10
```

#### EVM_ERROR_BALANCE_TOO_LOW

Not enough funds to transfer the requested value.

```c
#define EVM_ERROR_BALANCE_TOO_LOW -11
```

#### EVM_ERROR_STACK_LIMIT

Stack limit reached.

```c
#define EVM_ERROR_STACK_LIMIT -12
```

#### EVM_PROP_FRONTIER

```c
#define EVM_PROP_FRONTIER 1
```

#### EVM_PROP_EIP150

```c
#define EVM_PROP_EIP150 2
```

#### EVM_PROP_EIP158

```c
#define EVM_PROP_EIP158 4
```

#### EVM_PROP_CONSTANTINOPL

```c
#define EVM_PROP_CONSTANTINOPL 16
```

#### EVM_PROP_NO_FINALIZE

```c
#define EVM_PROP_NO_FINALIZE 32768
```

#### EVM_PROP_STATIC

```c
#define EVM_PROP_STATIC 256
```

#### EVM_ENV_BALANCE

```c
#define EVM_ENV_BALANCE 1
```

#### EVM_ENV_CODE_SIZE

```c
#define EVM_ENV_CODE_SIZE 2
```

#### EVM_ENV_CODE_COPY

```c
#define EVM_ENV_CODE_COPY 3
```

#### EVM_ENV_BLOCKHASH

```c
#define EVM_ENV_BLOCKHASH 4
```

#### EVM_ENV_STORAGE

```c
#define EVM_ENV_STORAGE 5
```

#### EVM_ENV_BLOCKHEADER

```c
#define EVM_ENV_BLOCKHEADER 6
```

#### EVM_ENV_CODE_HASH

```c
#define EVM_ENV_CODE_HASH 7
```

#### EVM_ENV_NONCE

```c
#define EVM_ENV_NONCE 8
```

#### EVM_DEBUG_BLOCK (...)

#### EVM_CALL_MODE_STATIC

```c
#define EVM_CALL_MODE_STATIC 1
```

#### EVM_CALL_MODE_DELEGATE

```c
#define EVM_CALL_MODE_DELEGATE 2
```

#### EVM_CALL_MODE_CALLCODE

```c
#define EVM_CALL_MODE_CALLCODE 3
```

#### EVM_CALL_MODE_CALL

```c
#define EVM_CALL_MODE_CALL 4
```

#### evm_state

The current state of the EVM. 

The enum type contains the following values:

```eval_rst
======================== = =====================================
 **EVM_STATE_INIT**      0 just initialized but not yet started
 **EVM_STATE_RUNNING**   1 started and still running
 **EVM_STATE_STOPPED**   2 successfully stopped
 **EVM_STATE_REVERTED**  3 stopped, but results must be reverted
======================== = =====================================
```

#### evm_state_t

The current state of the EVM.

#### evm_get_env

This function provides data from the environment.

Depending on the key, the function will set the out_data-pointer to the result. This means the environment is responsible for memory management and also to clean up resources afterward.

```c
typedef int(* evm_get_env) (void *evm, uint16_t evm_key, uint8_t *in_data, int in_len, uint8_t **out_data, int offset, int len)
```

returns: `int(*`

#### storage_t

The stucture contains the following fields:

```eval_rst
=============================================== =========== 
`bytes32_t <#bytes32-t>`_                        **key**    
`bytes32_t <#bytes32-t>`_                        **value**  
`account_storagestruct , * <#account-storage>`_  **next**   
=============================================== =========== 
```

#### logs_t

The stucture contains the following fields:

```eval_rst
========================= ============ 
`bytes_t <#bytes-t>`_      **topics**  
`bytes_t <#bytes-t>`_      **data**    
`logsstruct , * <#logs>`_  **next**    
========================= ============ 
```

#### account_t

The stucture contains the following fields:

```eval_rst
=============================== ============= 
`address_t <#address-t>`_        **address**  
`bytes32_t <#bytes32-t>`_        **balance**  
`bytes32_t <#bytes32-t>`_        **nonce**    
`bytes_t <#bytes-t>`_            **code**     
`storage_t * <#storage-t>`_      **storage**  
`accountstruct , * <#account>`_  **next**     
=============================== ============= 
```

#### evm_t

The stucture contains the following fields:

```eval_rst
===================================== ====================== ======================================================
`bytes_builder_t <#bytes-builder-t>`_  **stack**             
`bytes_builder_t <#bytes-builder-t>`_  **memory**            
``int``                                **stack_size**        
`bytes_t <#bytes-t>`_                  **code**              
``uint32_t``                           **pos**               
`evm_state_t <#evm-state-t>`_          **state**             
`bytes_t <#bytes-t>`_                  **last_returned**     
`bytes_t <#bytes-t>`_                  **return_data**       
``uint32_t *``                         **invalid_jumpdest**  
``uint32_t``                           **properties**        
`evm_get_env <#evm-get-env>`_          **env**               
``void *``                             **env_ptr**           
``uint8_t *``                          **address**           the address of the current storage
``uint8_t *``                          **account**           the address of the code
``uint8_t *``                          **origin**            the address of original sender of the root-transaction
``uint8_t *``                          **caller**            the address of the parent sender
`bytes_t <#bytes-t>`_                  **call_value**        value send
`bytes_t <#bytes-t>`_                  **call_data**         data send in the transaction
`bytes_t <#bytes-t>`_                  **gas_price**         current gas price
===================================== ====================== ======================================================
```

#### evm_stack_push

```c
int evm_stack_push(evm_t *evm, uint8_t *data, uint8_t len);
```

arguments:
```eval_rst
=================== ========== 
`evm_t * <#evm-t>`_  **evm**   
``uint8_t *``        **data**  
``uint8_t``          **len**   
=================== ========== 
```
returns: `int`

#### evm_stack_push_ref

```c
int evm_stack_push_ref(evm_t *evm, uint8_t **dst, uint8_t len);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
``uint8_t **``       **dst**  
``uint8_t``          **len**  
=================== ========= 
```
returns: `int`

#### evm_stack_push_int

```c
int evm_stack_push_int(evm_t *evm, uint32_t val);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
``uint32_t``         **val**  
=================== ========= 
```
returns: `int`

#### evm_stack_push_long

```c
int evm_stack_push_long(evm_t *evm, uint64_t val);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
``uint64_t``         **val**  
=================== ========= 
```
returns: `int`

#### evm_stack_get_ref

```c
int evm_stack_get_ref(evm_t *evm, uint8_t pos, uint8_t **dst);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
``uint8_t``          **pos**  
``uint8_t **``       **dst**  
=================== ========= 
```
returns: `int`

#### evm_stack_pop

```c
int evm_stack_pop(evm_t *evm, uint8_t *dst, uint8_t len);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
``uint8_t *``        **dst**  
``uint8_t``          **len**  
=================== ========= 
```
returns: `int`

#### evm_stack_pop_ref

```c
int evm_stack_pop_ref(evm_t *evm, uint8_t **dst);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
``uint8_t **``       **dst**  
=================== ========= 
```
returns: `int`

#### evm_stack_pop_byte

```c
int evm_stack_pop_byte(evm_t *evm, uint8_t *dst);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
``uint8_t *``        **dst**  
=================== ========= 
```
returns: `int`

#### evm_stack_pop_int

```c
int32_t evm_stack_pop_int(evm_t *evm);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
=================== ========= 
```
returns: `int32_t`

#### evm_stack_peek_len

```c
int evm_stack_peek_len(evm_t *evm);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
=================== ========= 
```
returns: `int`

#### evm_run

```c
int evm_run(evm_t *evm);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
=================== ========= 
```
returns: `int`

#### evm_sub_call

```c
int evm_sub_call(evm_t *parent, uint8_t address[20], uint8_t account[20], uint8_t *value, wlen_t l_value, uint8_t *data, uint32_t l_data, uint8_t caller[20], uint8_t origin[20], uint64_t gas, wlen_t mode, uint32_t out_offset, uint32_t out_len);
```

Handle internal calls.

arguments:
```eval_rst
=================== ================ 
`evm_t * <#evm-t>`_  **parent**      
``uint8_t``          **address**     
``uint8_t``          **account**     
``uint8_t *``        **value**       
`wlen_t <#wlen-t>`_  **l_value**     
``uint8_t *``        **data**        
``uint32_t``         **l_data**      
``uint8_t``          **caller**      
``uint8_t``          **origin**      
``uint64_t``         **gas**         
`wlen_t <#wlen-t>`_  **mode**        
``uint32_t``         **out_offset**  
``uint32_t``         **out_len**     
=================== ================ 
```
returns: `int`

#### evm_ensure_memory

```c
int evm_ensure_memory(evm_t *evm, uint32_t max_pos);
```

arguments:
```eval_rst
=================== ============= 
`evm_t * <#evm-t>`_  **evm**      
``uint32_t``         **max_pos**  
=================== ============= 
```
returns: `int`

#### in3_get_env

```c
int in3_get_env(void *evm_ptr, uint16_t evm_key, uint8_t *in_data, int in_len, uint8_t **out_data, int offset, int len);
```

arguments:
```eval_rst
============== ============== 
``void *``      **evm_ptr**   
``uint16_t``    **evm_key**   
``uint8_t *``   **in_data**   
``int``         **in_len**    
``uint8_t **``  **out_data**  
``int``         **offset**    
``int``         **len**       
============== ============== 
```
returns: `int`

#### evm_call

```c
int evm_call(void *vc, uint8_t address[20], uint8_t *value, wlen_t l_value, uint8_t *data, uint32_t l_data, uint8_t caller[20], uint64_t gas, bytes_t **result);
```

Run a evm-call.

arguments:
```eval_rst
======================== ============= 
``void *``                **vc**       
``uint8_t``               **address**  
``uint8_t *``             **value**    
`wlen_t <#wlen-t>`_       **l_value**  
``uint8_t *``             **data**     
``uint32_t``              **l_data**   
``uint8_t``               **caller**   
``uint64_t``              **gas**      
`bytes_t ** <#bytes-t>`_  **result**   
======================== ============= 
```
returns: `int`

#### evm_print_stack

```c
void evm_print_stack(evm_t *evm, uint64_t last_gas, uint32_t pos);
```

arguments:
```eval_rst
=================== ============== 
`evm_t * <#evm-t>`_  **evm**       
``uint64_t``         **last_gas**  
``uint32_t``         **pos**       
=================== ============== 
```

#### evm_free

```c
void evm_free(evm_t *evm);
```

arguments:
```eval_rst
=================== ========= 
`evm_t * <#evm-t>`_  **evm**  
=================== ========= 
```

#### evm_run_precompiled

```c
int evm_run_precompiled(evm_t *evm, uint8_t address[20]);
```

arguments:
```eval_rst
=================== ============= 
`evm_t * <#evm-t>`_  **evm**      
``uint8_t``          **address**  
=================== ============= 
```
returns: `int`

#### evm_is_precompiled

```c
uint8_t evm_is_precompiled(evm_t *evm, uint8_t address[20]);
```

arguments:
```eval_rst
=================== ============= 
`evm_t * <#evm-t>`_  **evm**      
``uint8_t``          **address**  
=================== ============= 
```
returns: `uint8_t`

#### uint256_set

```c
void uint256_set(uint8_t *src, wlen_t src_len, uint8_t dst[32]);
```

arguments:
```eval_rst
=================== ============= 
``uint8_t *``        **src**      
`wlen_t <#wlen-t>`_  **src_len**  
``uint8_t``          **dst**      
=================== ============= 
```

### gas.h

EVM gas defines.

Location: src/verifier/eth1/full/gas.h

#### op_exec (m,gas)

```c
#define op_exec (m,gas) return m;
```

#### subgas (g)

#### GAS_CC_NET_SSTORE_NOOP_GAS

Once per SSTORE operation if the value doesn't change.

```c
#define GAS_CC_NET_SSTORE_NOOP_GAS 200
```

#### GAS_CC_NET_SSTORE_INIT_GAS

Once per SSTORE operation from clean zero.

```c
#define GAS_CC_NET_SSTORE_INIT_GAS 20000
```

#### GAS_CC_NET_SSTORE_CLEAN_GAS

Once per SSTORE operation from clean non-zero.

```c
#define GAS_CC_NET_SSTORE_CLEAN_GAS 5000
```

#### GAS_CC_NET_SSTORE_DIRTY_GAS

Once per SSTORE operation from dirty.

```c
#define GAS_CC_NET_SSTORE_DIRTY_GAS 200
```

#### GAS_CC_NET_SSTORE_CLEAR_REFUND

Once per SSTORE operation for clearing an originally existing storage slot.

```c
#define GAS_CC_NET_SSTORE_CLEAR_REFUND 15000
```

#### GAS_CC_NET_SSTORE_RESET_REFUND

Once per SSTORE operation for resetting to the original non-zero value.

```c
#define GAS_CC_NET_SSTORE_RESET_REFUND 4800
```

#### GAS_CC_NET_SSTORE_RESET_CLEAR_REFUND

Once per SSTORE operation for resetting to the original zero value.

```c
#define GAS_CC_NET_SSTORE_RESET_CLEAR_REFUND 19800
```

#### G_ZERO

Nothing is paid for operations of the set Wzero.

```c
#define G_ZERO 0
```

#### G_JUMPDEST

JUMP DEST.

```c
#define G_JUMPDEST 1
```

#### G_BASE

This is the amount of gas to pay for operations of the set Wbase.

```c
#define G_BASE 2
```

#### G_VERY_LOW

This is the amount of gas to pay for operations of the set Wverylow.

```c
#define G_VERY_LOW 3
```

#### G_LOW

This is the amount of gas to pay for operations of the set Wlow.

```c
#define G_LOW 5
```

#### G_MID

This is the amount of gas to pay for operations of the set Wmid.

```c
#define G_MID 8
```

#### G_HIGH

This is the amount of gas to pay for operations of the set Whigh.

```c
#define G_HIGH 10
```

#### G_EXTCODE

This is the amount of gas to pay for operations of the set Wextcode.

```c
#define G_EXTCODE 700
```

#### G_BALANCE

This is the amount of gas to pay for a BALANCE operation.

```c
#define G_BALANCE 400
```

#### G_SLOAD

This is paid for an SLOAD operation.

```c
#define G_SLOAD 200
```

#### G_SSET

This is paid for an SSTORE operation when the storage value is set to non-zero from zero.

```c
#define G_SSET 20000
```

#### G_SRESET

This is the amount for an SSTORE operation when the storage value’s zeroness remains unchanged or is set to zero.

```c
#define G_SRESET 5000
```

#### R_SCLEAR

This is the refund given (added into the refund counter) when the storage value is set to zero from non-zero.

```c
#define R_SCLEAR 15000
```

#### R_SELFDESTRUCT

This is the refund given (added into the refund counter) for self-destructing an account.

```c
#define R_SELFDESTRUCT 24000
```

#### G_SELFDESTRUCT

This is the amount of gas to pay for a SELFDESTRUCT operation.

```c
#define G_SELFDESTRUCT 5000
```

#### G_CREATE

This is paid for a CREATE operation.

```c
#define G_CREATE 32000
```

#### G_CODEDEPOSIT

This is paid per byte for a CREATE operation to succeed in placing code into the state.

```c
#define G_CODEDEPOSIT 200
```

#### G_CALL

This is paid for a CALL operation.

```c
#define G_CALL 700
```

#### G_CALLVALUE

This is paid for a non-zero value transfer as part of the CALL operation.

```c
#define G_CALLVALUE 9000
```

#### G_CALLSTIPEND

This is a stipend for the called contract subtracted from Gcallvalue for a non-zero value transfer.

```c
#define G_CALLSTIPEND 2300
```

#### G_NEWACCOUNT

This is paid for a CALL or for a SELFDESTRUCT operation, which creates an account.

```c
#define G_NEWACCOUNT 25000
```

#### G_EXP

This is a partial payment for an EXP operation.

```c
#define G_EXP 10
```

#### G_EXPBYTE

This is a partial payment when multiplied by dlog256(exponent)e for the EXP operation.

```c
#define G_EXPBYTE 50
```

#### G_MEMORY

This is paid for every additional word when expanding memory.

```c
#define G_MEMORY 3
```

#### G_TXCREATE

This is paid by all contract-creating transactions after the Homestead transition.

```c
#define G_TXCREATE 32000
```

#### G_TXDATA_ZERO

This is paid for every zero byte of data or code for a transaction.

```c
#define G_TXDATA_ZERO 4
```

#### G_TXDATA_NONZERO

This is paid for every non-zero byte of data or code for a transaction.

```c
#define G_TXDATA_NONZERO 68
```

#### G_TRANSACTION

This is paid for every transaction.

```c
#define G_TRANSACTION 21000
```

#### G_LOG

This is a partial payment for a LOG operation.

```c
#define G_LOG 375
```

#### G_LOGDATA

This is paid for each byte in a LOG operation’s data.

```c
#define G_LOGDATA 8
```

#### G_LOGTOPIC

This is paid for each topic of a LOG operation.

```c
#define G_LOGTOPIC 375
```

#### G_SHA3

This is paid for each SHA3 operation.

```c
#define G_SHA3 30
```

#### G_SHA3WORD

This is paid for each word (rounded up) for input data to a SHA3 operation.

```c
#define G_SHA3WORD 6
```

#### G_COPY

This is a partial payment for *COPY operations, multiplied by the number of words copied, rounded up.

```c
#define G_COPY 3
```

#### G_BLOCKHASH

This is a payment for a BLOCKHASH operation.

```c
#define G_BLOCKHASH 20
```

#### G_PRE_EC_RECOVER

Precompile EC RECOVER.

```c
#define G_PRE_EC_RECOVER 3000
```

#### G_PRE_SHA256

Precompile SHA256.

```c
#define G_PRE_SHA256 60
```

#### G_PRE_SHA256_WORD

Precompile SHA256 per word.

```c
#define G_PRE_SHA256_WORD 12
```

#### G_PRE_RIPEMD160

Precompile RIPEMD160. 

```c
#define G_PRE_RIPEMD160 600
```

#### G_PRE_RIPEMD160_WORD

Precompile RIPEMD160 per word.

```c
#define G_PRE_RIPEMD160_WORD 120
```

#### G_PRE_IDENTITY

Precompile IDENTITY (copies data).

```c
#define G_PRE_IDENTITY 15
```

#### G_PRE_IDENTITY_WORD

Precompile IDENTIY per word. 

```c
#define G_PRE_IDENTITY_WORD 3
```

#### G_PRE_MODEXP_GQUAD_DIVISOR

Gquaddivisor from modexp precompile for gas calculation.

```c
#define G_PRE_MODEXP_GQUAD_DIVISOR 20
```

#### G_PRE_ECADD

Gas costs for curve addition precompile.

```c
#define G_PRE_ECADD 500
```

#### G_PRE_ECMUL

Gas costs for curve multiplication precompile.

```c
#define G_PRE_ECMUL 40000
```

#### G_PRE_ECPAIRING

Base gas costs for curve pairing precompile.

```c
#define G_PRE_ECPAIRING 100000
```

#### G_PRE_ECPAIRING_WORD

Gas costs regarding curve pairing precompile input length.

```c
#define G_PRE_ECPAIRING_WORD 80000
```

#### EVM_STACK_LIMIT

Max elements of the stack.

```c
#define EVM_STACK_LIMIT 1024
```

#### EVM_MAX_CODE_SIZE

Max size of the code.

```c
#define EVM_MAX_CODE_SIZE 24576
```

#### FRONTIER_G_EXPBYTE

Fork values.

This is a partial payment when multiplied by dlog256(exponent)e for the EXP operation.

```c
#define FRONTIER_G_EXPBYTE 10
```

#### FRONTIER_G_SLOAD

This is a partial payment when multiplied by dlog256(exponent)e for the EXP operation.

```c
#define FRONTIER_G_SLOAD 50
```

## Module Verifier/eth1/nano 

Static lib.

### chainspec.h

Ethereum chain specification.

Location: src/verifier/eth1/nano/chainspec.h

#### BLOCK_LATEST

```c
#define BLOCK_LATEST 0xFFFFFFFFFFFFFFFF
```

#### eth_consensus_type_t

The consensus type.

The enum type contains the following values:

```eval_rst
==================== = ================================
 **ETH_POW**         0 proof of work (Ethash)
 **ETH_POA_AURA**    1 proof of authority using Aura
 **ETH_POA_CLIQUE**  2 proof of authority using Clique
==================== = ================================
```

#### eip_transition_t


The stucture contains the following fields:

```eval_rst
============ ====================== 
``uint64_t``  **transition_block**  
``eip_t``     **eips**              
============ ====================== 
```

#### consensus_transition_t

The stuct contains the following fields:

```eval_rst
=============================================== ====================== 
``uint64_t``                                     **transition_block**  
`eth_consensus_type_t <#eth-consensus-type-t>`_  **type**              
`bytes_t <#bytes-t>`_                            **validators**        
``uint8_t *``                                    **contract**          
=============================================== ====================== 
```

#### chainspec_t

The stucture contains the following fields:

```eval_rst
===================================================== =============================== 
``uint64_t``                                           **network_id**                 
``uint64_t``                                           **account_start_nonce**        
``uint32_t``                                           **eip_transitions_len**        
`eip_transition_t * <#eip-transition-t>`_              **eip_transitions**            
``uint32_t``                                           **consensus_transitions_len**  
`consensus_transition_t * <#consensus-transition-t>`_  **consensus_transitions**      
===================================================== =============================== 
```

#### __attribute__

```c
struct __attribute__((__packed__)) eip_;
```

Defines the flags for the current activated EIPs.

Since it does not make sense to support an EVM defined before Homestead, Homestead's EIP is always turned on!

< REVERT instruction









































 < Bitwise shifting instructions in EVM






































 < Gas cost changes for IO-heavy operations



































 < Simple replay attack protection
































 < EXP cost increase





























 < Contract code size limit


























 < Precompiled contracts for addition and scalar multiplication on the elliptic curve alt_bn128























 < Precompiled contracts for optimal Ate pairing check on the elliptic curve alt_bn128




















 < Big integer modular exponentiation

















 < New opcodes: RETURNDATASIZE and RETURNDATACOPY














 < New opcode STATICCALL











 < Embedding transaction status code in receipts








 < Skinny CREATE2





 < EXTCODEHASH opcode


 < Net gas metering for SSTORE without dirty maps

arguments:
```eval_rst
================  
``(__packed__)``  
================  
```
returns: `struct`

#### chainspec_create_from_json

```c
chainspec_t* chainspec_create_from_json(d_token_t *data);
```

arguments:
```eval_rst
=========================== ========== 
`d_token_t * <#d-token-t>`_  **data**  
=========================== ========== 
```
returns: [`chainspec_t *`](#chainspec-t)

#### chainspec_get_eip

```c
eip_t chainspec_get_eip(chainspec_t *spec, uint64_t block_number);
```

arguments:
```eval_rst
=============================== ================== 
`chainspec_t * <#chainspec-t>`_  **spec**          
``uint64_t``                     **block_number**  
=============================== ================== 
```
returns: `eip_t`

#### chainspec_get_consensus

```c
consensus_transition_t* chainspec_get_consensus(chainspec_t *spec, uint64_t block_number);
```

arguments:
```eval_rst
=============================== ================== 
`chainspec_t * <#chainspec-t>`_  **spec**          
``uint64_t``                     **block_number**  
=============================== ================== 
```
returns: [`consensus_transition_t *`](#consensus-transition-t)

#### chainspec_to_bin

```c
int chainspec_to_bin(chainspec_t *spec, bytes_builder_t *bb);
```

arguments:
```eval_rst
======================================= ========== 
`chainspec_t * <#chainspec-t>`_          **spec**  
`bytes_builder_t * <#bytes-builder-t>`_  **bb**    
======================================= ========== 
```
returns: `int`

#### chainspec_from_bin

```c
chainspec_t* chainspec_from_bin(void *raw);
```

arguments:
```eval_rst
========== ========= 
``void *``  **raw**  
========== ========= 
```
returns: [`chainspec_t *`](#chainspec-t)

#### chainspec_get

```c
chainspec_t* chainspec_get(uint64_t chain_id);
```

arguments:
```eval_rst
============ ============== 
``uint64_t``  **chain_id**  
============ ============== 
```
returns: [`chainspec_t *`](#chainspec-t)

#### chainspec_put

```c
void chainspec_put(uint64_t chain_id, chainspec_t *spec);
```

arguments:
```eval_rst
=============================== ============== 
``uint64_t``                     **chain_id**  
`chainspec_t * <#chainspec-t>`_  **spec**      
=============================== ============== 
```

### eth_nano.h

Ethereum nano verification.

Location: src/verifier/eth1/nano/eth_nano.h

#### in3_verify_eth_nano

```c
in3_ret_t in3_verify_eth_nano(in3_vctx_t *v);
```

Entry function to execute the verification context.

arguments:
```eval_rst
============================= ======= 
`in3_vctx_t * <#in3-vctx-t>`_  **v**  
============================= ======= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_verify_blockheader

```c
in3_ret_t eth_verify_blockheader(in3_vctx_t *vc, bytes_t *header, bytes_t *expected_blockhash);
```

Verifies a blockheader.

arguments:
```eval_rst
============================= ======================== 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**                  
`bytes_t * <#bytes-t>`_        **header**              
`bytes_t * <#bytes-t>`_        **expected_blockhash**  
============================= ======================== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_verify_signature

```c
int eth_verify_signature(in3_vctx_t *vc, bytes_t *msg_hash, d_token_t *sig);
```

Verifies a single-signature blockheader.

This function will return a positive integer with a bitmask holding the bit set according to the address that signed it. This is based on the signatiures in the request-config.

arguments:
```eval_rst
============================= ============== 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**        
`bytes_t * <#bytes-t>`_        **msg_hash**  
`d_token_t * <#d-token-t>`_    **sig**       
============================= ============== 
```
returns: `int`

#### ecrecover_signature

```c
bytes_t* ecrecover_signature(bytes_t *msg_hash, d_token_t *sig);
```

Returns the address of the signature if the msg_hash is correct.

arguments:
```eval_rst
=========================== ============== 
`bytes_t * <#bytes-t>`_      **msg_hash**  
`d_token_t * <#d-token-t>`_  **sig**       
=========================== ============== 
```
returns: [`bytes_t *`](#bytes-t)

#### eth_verify_eth_getTransactionReceipt

```c
in3_ret_t eth_verify_eth_getTransactionReceipt(in3_vctx_t *vc, bytes_t *tx_hash);
```

Verifies a transaction receipt.

arguments:
```eval_rst
============================= ============= 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**       
`bytes_t * <#bytes-t>`_        **tx_hash**  
============================= ============= 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### eth_verify_in3_nodelist

```c
in3_ret_t eth_verify_in3_nodelist(in3_vctx_t *vc, uint32_t node_limit, bytes_t *seed, d_token_t *required_addresses);
```

Verifies the NodeList.

arguments:
```eval_rst
============================= ======================== 
`in3_vctx_t * <#in3-vctx-t>`_  **vc**                  
``uint32_t``                   **node_limit**          
`bytes_t * <#bytes-t>`_        **seed**                
`d_token_t * <#d-token-t>`_    **required_addresses**  
============================= ======================== 
```
returns: [`in3_ret_t`](#in3-ret-t), the [result-status](#in3-ret-t) of the function. 

*Please make sure you check if it was successful (`==IN3_OK`).*

#### in3_register_eth_nano

```c
void in3_register_eth_nano();
```

This function should only be called once and will register the eth-nano verifier.

#### create_tx_path

```c
bytes_t* create_tx_path(uint32_t index);
```

Helper function to rlp-encode the transaction_index.

The result must be freed after use!

arguments:
```eval_rst
============ =========== 
``uint32_t``  **index**  
============ =========== 
```
returns: [`bytes_t *`](#bytes-t)

### merkle.h

Merkle proof verification.

Location: src/verifier/eth1/nano/merkle.h

#### MERKLE_DEPTH_MAX

```c
#define MERKLE_DEPTH_MAX 64
```

#### trie_verify_proof

```c
int trie_verify_proof(bytes_t *rootHash, bytes_t *path, bytes_t **proof, bytes_t *expectedValue);
```

Verifies a Merkle proof. 

expectedValue == NULL: value must not exist
expectedValue.data ==NULL: please copy the data; I want to evaluate it afterward.
expectedValue.data !=NULL: value must match the data.

arguments:
```eval_rst
======================== =================== 
`bytes_t * <#bytes-t>`_   **rootHash**       
`bytes_t * <#bytes-t>`_   **path**           
`bytes_t ** <#bytes-t>`_  **proof**          
`bytes_t * <#bytes-t>`_   **expectedValue**  
======================== =================== 
```
returns: `int`

#### trie_path_to_nibbles

```c
uint8_t* trie_path_to_nibbles(bytes_t path, int use_prefix);
```

Helper function split a path into 4-bit nibbles.

The result must be freed after use!

arguments:
```eval_rst
===================== ================ 
`bytes_t <#bytes-t>`_  **path**        
``int``                **use_prefix**  
===================== ================ 
```
returns: `uint8_t *`: the resulting bytes represent a 4-bit number each and are terminated with a 0xFF.

#### trie_matching_nibbles

```c
int trie_matching_nibbles(uint8_t *a, uint8_t *b);
```

Helper function to find the number of nibbles matching both paths.

arguments:
```eval_rst
============= ======= 
``uint8_t *``  **a**  
``uint8_t *``  **b**  
============= ======= 
```
returns: `int`

#### trie_free_proof

```c
void trie_free_proof(bytes_t **proof);
```

Used to free the NULL-terminated proof-array.

arguments:
```eval_rst
======================== =========== 
`bytes_t ** <#bytes-t>`_  **proof**  
======================== =========== 
```

### rlp.h

RLP-En/Decoding as described in the [Ethereum RLP-Spec](https://github.com/ethereum/wiki/wiki/RLP). 

This decoding works without allocating new memory.

Location: src/verifier/eth1/nano/rlp.h

#### rlp_decode

```c
int rlp_decode(bytes_t *b, int index, bytes_t *dst);
```

This function decodes the given bytes and returns the element with the given index by updating the reference of dst.

The bytes will only hold references and do **not** need to be freed!

```c
bytes_t* tx_raw = serialize_tx(tx);

bytes_t item;

// decodes the tx_raw by letting the item point to range of the first element, which should be the body of a list.
if (rlp_decode(tx_raw, 0, &item) !=2) return -1 ;

// now decode the 4th element (which is the value) and let item point to that range.
if (rlp_decode(&item, 4, &item) !=1) return -1 ;
```
arguments:
```eval_rst
======================= =========== 
`bytes_t * <#bytes-t>`_  **b**      
``int``                  **index**  
`bytes_t * <#bytes-t>`_  **dst**    
======================= =========== 
```
returns: `int`:
- 0: item is out of range
- 1: item found
- 2: list found (you can then decode the same bytes again)

#### rlp_decode_in_list

```c
int rlp_decode_in_list(bytes_t *b, int index, bytes_t *dst);
```

This function expects a list item (like the blockheader as first item and will then find the item within this list).

It is a shortcut for:

```c
// decode the list
if (rlp_decode(b,0,dst)!=2) return 0;
// and the decode the item
return rlp_decode(dst,index,dst);
```
arguments:
```eval_rst
======================= =========== 
`bytes_t * <#bytes-t>`_  **b**      
``int``                  **index**  
`bytes_t * <#bytes-t>`_  **dst**    
======================= =========== 
```
returns: `int`: 
- 0: item is out of range
- 1: item found
- 2: list found (you can then decode the same bytes again)

#### rlp_decode_len

```c
int rlp_decode_len(bytes_t *b);
```

Returns the number of elements found in the data.

arguments:
```eval_rst
======================= ======= 
`bytes_t * <#bytes-t>`_  **b**  
======================= ======= 
```
returns: `int`

#### rlp_decode_item_len

```c
int rlp_decode_item_len(bytes_t *b, int index);
```

Returns the number of bytes of the element specified by index.

arguments:
```eval_rst
======================= =========== 
`bytes_t * <#bytes-t>`_  **b**      
``int``                  **index**  
======================= =========== 
```
returns: `int`: the number of bytes or 0 if not found.

#### rlp_decode_item_type

```c
int rlp_decode_item_type(bytes_t *b, int index);
```

Returns the type of the element specified by index.

arguments:
```eval_rst
======================= =========== 
`bytes_t * <#bytes-t>`_  **b**      
``int``                  **index**  
======================= =========== 
```
returns: `int`: 
- 0: item is out of range
- 1: item found
- 2: list found (you can then decode the same bytes again)

#### rlp_encode_item

```c
void rlp_encode_item(bytes_builder_t *bb, bytes_t *val);
```

Encode an item as single string and add it to the bytes_builder.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
`bytes_t * <#bytes-t>`_                  **val**  
======================================= ========= 
```

#### rlp_encode_list

```c
void rlp_encode_list(bytes_builder_t *bb, bytes_t *val);
```

Encode the value as list of already encoded items.

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**   
`bytes_t * <#bytes-t>`_                  **val**  
======================================= ========= 
```

#### rlp_encode_to_list

```c
bytes_builder_t* rlp_encode_to_list(bytes_builder_t *bb);
```

Converts the data in the builder to a list.

This function is optimized to not increase the memory more than needed and is faster than creating a second builder to encode the data.

arguments:
```eval_rst
======================================= ======== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**  
======================================= ======== 
```
returns: [`bytes_builder_t *`](#bytes-builder-t): the same builder. 

#### rlp_encode_to_item

```c
bytes_builder_t* rlp_encode_to_item(bytes_builder_t *bb);
```

Converts the data in the builder to an rlp-encoded item.

This function is optimized to not increase the memory more than needed and is faster than creating a second builder to encode the data.

arguments:
```eval_rst
======================================= ======== 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**  
======================================= ======== 
```
returns: [`bytes_builder_t *`](#bytes-builder-t): the same builder. 

#### rlp_add_length

```c
void rlp_add_length(bytes_builder_t *bb, uint32_t len, uint8_t offset);
```

Helper to encode the prefix for a value.

arguments:
```eval_rst
======================================= ============ 
`bytes_builder_t * <#bytes-builder-t>`_  **bb**      
``uint32_t``                             **len**     
``uint8_t``                              **offset**  
======================================= ============ 
```

### serialize.h

Serialization of ETH-Objects.

Theincoming tokens will represent their values as properties based on [JSON-RPC](https://github.com/ethereum/wiki/wiki/JSON-RPC). 

Location: src/verifier/eth1/nano/serialize.h

#### BLOCKHEADER_PARENT_HASH

```c
#define BLOCKHEADER_PARENT_HASH 0
```

#### BLOCKHEADER_SHA3_UNCLES

```c
#define BLOCKHEADER_SHA3_UNCLES 1
```

#### BLOCKHEADER_MINER

```c
#define BLOCKHEADER_MINER 2
```

#### BLOCKHEADER_STATE_ROOT

```c
#define BLOCKHEADER_STATE_ROOT 3
```

#### BLOCKHEADER_TRANSACTIONS_ROOT

```c
#define BLOCKHEADER_TRANSACTIONS_ROOT 4
```

#### BLOCKHEADER_RECEIPT_ROOT

```c
#define BLOCKHEADER_RECEIPT_ROOT 5
```

#### BLOCKHEADER_LOGS_BLOOM

```c
#define BLOCKHEADER_LOGS_BLOOM 6
```

#### BLOCKHEADER_DIFFICULTY

```c
#define BLOCKHEADER_DIFFICULTY 7
```

#### BLOCKHEADER_NUMBER

```c
#define BLOCKHEADER_NUMBER 8
```

#### BLOCKHEADER_GAS_LIMIT

```c
#define BLOCKHEADER_GAS_LIMIT 9
```

#### BLOCKHEADER_GAS_USED

```c
#define BLOCKHEADER_GAS_USED 10
```

#### BLOCKHEADER_TIMESTAMP

```c
#define BLOCKHEADER_TIMESTAMP 11
```

#### BLOCKHEADER_EXTRA_DATA

```c
#define BLOCKHEADER_EXTRA_DATA 12
```

#### BLOCKHEADER_SEALED_FIELD1

```c
#define BLOCKHEADER_SEALED_FIELD1 13
```

#### BLOCKHEADER_SEALED_FIELD2

```c
#define BLOCKHEADER_SEALED_FIELD2 14
```

#### BLOCKHEADER_SEALED_FIELD3

```c
#define BLOCKHEADER_SEALED_FIELD3 15
```

#### serialize_tx_receipt

```c
bytes_t* serialize_tx_receipt(d_token_t *receipt);
```

Ceates rlp-encoded raw bytes for a receipt. 

The bytes must be freed with b_free after use!

arguments:
```eval_rst
=========================== ============= 
`d_token_t * <#d-token-t>`_  **receipt**  
=========================== ============= 
```
returns: [`bytes_t *`](#bytes-t)


#### serialize_tx

```c
bytes_t* serialize_tx(d_token_t *tx);
```

creates rlp-encoded raw bytes for a transaction. 

The bytes must be freed with b_free after use!

arguments:
```eval_rst
=========================== ======== 
`d_token_t * <#d-token-t>`_  **tx**  
=========================== ======== 
```
returns: [`bytes_t *`](#bytes-t)


#### serialize_tx_raw

```c
bytes_t* serialize_tx_raw(bytes_t nonce, bytes_t gas_price, bytes_t gas_limit, bytes_t to, bytes_t value, bytes_t data, uint64_t v, bytes_t r, bytes_t s);
```

creates rlp-encoded raw bytes for a transaction from direct values. 

The bytes must be freed with b_free after use! 

arguments:
```eval_rst
===================== =============== 
`bytes_t <#bytes-t>`_  **nonce**      
`bytes_t <#bytes-t>`_  **gas_price**  
`bytes_t <#bytes-t>`_  **gas_limit**  
`bytes_t <#bytes-t>`_  **to**         
`bytes_t <#bytes-t>`_  **value**      
`bytes_t <#bytes-t>`_  **data**       
``uint64_t``           **v**          
`bytes_t <#bytes-t>`_  **r**          
`bytes_t <#bytes-t>`_  **s**          
===================== =============== 
```
returns: [`bytes_t *`](#bytes-t)


#### serialize_account

```c
bytes_t* serialize_account(d_token_t *a);
```

creates rlp-encoded raw bytes for a account. 

The bytes must be freed with b_free after use! 

arguments:
```eval_rst
=========================== ======= 
`d_token_t * <#d-token-t>`_  **a**  
=========================== ======= 
```
returns: [`bytes_t *`](#bytes-t)


#### serialize_block_header

```c
bytes_t* serialize_block_header(d_token_t *block);
```

creates rlp-encoded raw bytes for a blockheader. 

The bytes must be freed with b_free after use!

arguments:
```eval_rst
=========================== =========== 
`d_token_t * <#d-token-t>`_  **block**  
=========================== =========== 
```
returns: [`bytes_t *`](#bytes-t)


#### rlp_add

```c
int rlp_add(bytes_builder_t *rlp, d_token_t *t, int ml);
```

adds the value represented by the token rlp-encoded to the byte_builder. 

arguments:
```eval_rst
======================================= ========= 
`bytes_builder_t * <#bytes-builder-t>`_  **rlp**  
`d_token_t * <#d-token-t>`_              **t**    
``int``                                  **ml**   
======================================= ========= 
```
returns: `int` : 0 if added -1 if the value could not be handled. 
