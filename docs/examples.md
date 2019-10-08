# Examples

This is a collection of use cases and examples helping devlopers to copy and paste code to get started.

## TS

### using Web3

Since incubed works with on a JSON-RPC-Level it can easily be used as Provider for Web3:

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

### using Incubed API


Incubed includes a light API, allowinng not only to use all RPC-Methods in a typesafe way, but also to sign transactions and call funnctions of a contract without the web3-library.

For more details see the [API-Doc](api-ts.html#type-client)


```ts


// import in3-Module
import In3Client from 'in3'

// use the In3Client
const in3 = new In3Client({
    proof         : 'standard',
    signatureCount: 1,
    requestCount  : 2,
    chainId       : 'mainnet'
})

// use the api to call a funnction..
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

### Reading event with incubed


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

// use the ABI-String of the smart contract
abi = [{"anonymous":false,"inputs":[{"indexed":false,"name":"name","type":"string"},{"indexed":true,"name":"label","type":"bytes32"},{"indexed":true,"name":"owner","type":"address"},{"indexed":false,"name":"cost","type":"uint256"},{"indexed":false,"name":"expires","type":"uint256"}],"name":"NameRegistered","type":"event"}]

// create a contract-object for a given address
const contract = in3.eth.contractAt(abi, '0xF0AD5cAd05e10572EfcEB849f6Ff0c68f9700455') // ENS contract.

// read all events starting from a specified block until the latest
const logs = await c.events.NameRegistered.getLogs({fromBlock:8022948})) 

// print out the properties of the event.
for (const ev of logs) 
  console.log(`${ev.owner} registered ${ev.name} for ${ev.cost} wei until ${new Date(ev.expires.toNumber()*1000).toString()}`)

...
```


## C

### creating a incubed instance

creating always follow these steps:

```c
#include <client/client.h> // the core client
#include <eth_full.h>      // the full ethereum verifier containing the EVM
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

### calling a function

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
    char*    url     = d_get_string_at(response->result, 0); // get the first item of the result (the url)
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

