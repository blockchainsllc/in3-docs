# API RPC 

This section describes the behavior for each RPC-method supported with incubed.

The core of incubed is to execute rpc-requests which will be send to the incubed nodes and verified. This means the available RPC-Requests are defined by the clients itself.

- For Ethereum : [https://eth.wiki/json-rpc/API](https://eth.wiki/json-rpc/API)
- For Bitcoin : [https://bitcoincore.org/en/doc/0.18.0/](https://bitcoincore.org/en/doc/0.18.0/)


## in3

There are also some Incubed specific rpc-methods, which will help the clients to bootstrap and update the nodeLists.


The incubed client itself offers special RPC-Methods, which are mostly handled directly inside the client:

### in3_config

changes the configuration of a client. The configuration is passed as the first param and may contain only the values to change.

Parameters:

1. `config`: config-object - a Object with config-params.

The config params support the following properties :


* **autoUpdateList** :`bool` *(optional)*  - if true the nodelist will be automaticly updated if the lastBlock is newer.
    example: true

* **chainId** :`uint32_t` or `string (mainnet/kovan/goerli)` - servers to filter for the given chain. The chain-id based on EIP-155.
    example: 0x1

* **signatureCount** :`uint8_t` *(optional)*  - number of signatures requested.
    example: 2
    
* **finality** :`uint16_t` *(optional)*  - the number in percent needed in order reach finality (% of signature of the validators).
    example: 50

* **includeCode** :`bool` *(optional)*  - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards.
    example: true

* **bootWeights** :`bool` *(optional)*  - if true, the first request (updating the nodelist) will also fetch the current health status and use it for blacklisting unhealthy nodes. This is used only if no nodelist is availabkle from cache.
    example: true

* **maxAttempts** :`uint16_t` *(optional)*  - max number of attempts in case a response is rejected.
    example: 10

* **keepIn3** :`bool` *(optional)*  - if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did.
    example: false

* **key** :`bytes32` *(optional)*  - the client key to sign requests.
    example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7

* **useBinary** :`bool` *(optional)*  - if true the client will use binary format.
    example: false

* **useHttp** :`bool` *(optional)*  - if true the client will try to use http instead of https.
    example: false

* **maxBlockCache** :`uint32_t` *(optional)*  - number of number of blocks cached  in memory.
    example: 100

* **maxCodeCache** :`uint32_t` *(optional)*  - number of max bytes used to cache the code in memory.
    example: 100000

* **timeout** :`uint32_t` *(optional)*  - specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
    example: 100000

* **minDeposit** :`uint64_t` - min stake of the server. Only nodes owning at least this amount will be chosen.

* **nodeProps** :`uint64_t` bitmask *(optional)*  - used to identify the capabilities of the node.

* **nodeLimit** :`uint16_t` *(optional)*  - the limit of nodes to store in the client.
    example: 150

* **proof** :`string (none/standard/full)` *(optional)*  - if true the nodes should send a proof of the response.
    example: true

* **replaceLatestBlock** :`uint8_t` *(optional)*  - if specified, the blocknumber *latest* will be replaced by blockNumber- specified value.
    example: 6

* **requestCount** :`uint8_t` - the number of request send when getting a first answer.
    example: 3

* **rpc** :`string` *(optional)*  - url of one or more rpc-endpoints to use. (list can be comma seperated)

* **servers**/**nodes** : `collection of JSON objects with chain Id (hex string) as key` *(optional)*  - the value of each JSON object defines the nodelist per chain and may contain the following fields:
    
    * **contract** :`address`  - address of the registry contract.
    * **whiteListContract** :`address` *(optional, cannot be combined with whiteList)*  - address of the whiteList contract.
    * **whiteList** :`array of addresses` *(optional, cannot be combined with whiteListContract)*  - manual whitelist.
    * **registryId** :`bytes32`  - identifier of the registry.
    * **needsUpdate** :`bool` *(optional)*  - if set, the nodeList will be updated before next request.
    * **avgBlockTime** :`uint16_t` *(optional)*  - average block time (seconds) for this chain.
    * **verifiedHashes** :`array of JSON objects` *(optional)*  - if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request. MUST contain the following fields:

        * **block** :`uint64_t`  - block number.
        * **hash** : `bytes32`  - verified hash corresponding to block number.

    * **nodeList** :`array of JSON objects` *(optional)*  - manual nodeList, each JSON object may contain the following fields:
    
        * **url** :`string`  - URL of the node.
        * **address** :`address`  - address of the node.
        * **props** :`uint64_t` bitmask *(optional)*  - used to identify the capabilities of the node (defaults to 65535).

Returns:

an boolean confirming that the config has changed.

Example:


Request:
```js
{
	"method": "in3_config",
	"params": [{
		"chainId": "0x5",
		"maxAttempts": 4,
		"nodeLimit": 10,
		"servers": {
			"0x1": {
				"nodeList": [{
						"address": "0x1234567890123456789012345678901234567890",
						"url": "https://mybootnode-A.com",
						"props": "0xFFFF"
					},
					{
						"address": "0x1234567890123456789012345678901234567890",
						"url": "https://mybootnode-B.com",
						"props": "0xFFFF"
					}
				]
			}
		}
	}]
}
```

Response:

```js
{
  "id": 1,
  "result": true
}
```

### in3_abiEncode

based on the [ABI-encoding](https://solidity.readthedocs.io/en/v0.5.3/abi-spec.html) used by solidity, this function encodes the values and returns it as hex-string.

Parameters:

1. `signature`: string - the signature of the function. e.g. `getBalance(uint256)`. The format is the same as used by solidity to create the functionhash. optional you can also add the return type, which in this case is ignored.
2. `params`: array - a array of arguments. the number of arguments must match the arguments in the signature.


Returns:

the ABI-encoded data as hex including the 4 byte function-signature. These data can be used for `eth_call` or to send a transaction.

Request:

```js
{
    "method":"in3_abiEncode",
    "params":[
        "getBalance(address)",
        ["0x1234567890123456789012345678901234567890"]
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": "0xf8b2cb4f0000000000000000000000001234567890123456789012345678901234567890",
}
```


### in3_abiDecode

based on the [ABI-encoding](https://solidity.readthedocs.io/en/v0.5.3/abi-spec.html) used by solidity, this function decodes the bytes given and returns it as array of values.

Parameters:

1. `signature`: string - the signature of the function. e.g. `uint256`, `(address,string,uint256)` or `getBalance(address):uint256`. If the complete functionhash is given, only the return-part will be used.
2. `data`: hex - the data to decode (usually the result of a eth_call)

Returns:

a array (if more then one arguments in the result-type) or the the value after decodeing.

Request:

```js
{
    "method":"in3_abiDecode",
    "params":[
        "(address,uint256)",
        "0x00000000000000000000000012345678901234567890123456789012345678900000000000000000000000000000000000000000000000000000000000000005"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": ["0x1234567890123456789012345678901234567890","0x05"],
}
```


### in3_checksumAddress

Will convert an upper or lowercase Ethereum address to a checksum address.  (See [EIP55](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) )

Parameters:

1. `address`: address - the address to convert.
2. `useChainId`: boolean - if true, the chainId is integrated as well (See [EIP1191](https://github.com/ethereum/EIPs/issues/1121) )

Returns:

the address-string using the upper/lowercase hex characters.

Request:

```js
{
    "method":"in3_checksumAddress",
    "params":[
        "0x1fe2e9bf29aa1938859af64c413361227d04059a",
        false
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": "0x1Fe2E9bf29aa1938859Af64C413361227d04059a"
}
```


### in3_ens

resolves a ens-name.
the domain names consist of a series of dot-separated labels. Each label must be a valid normalised label as described in [UTS46](https://unicode.org/reports/tr46/) with the options `transitional=false` and `useSTD3AsciiRules=true`. For Javascript implementations, a [library](https://www.npmjs.com/package/idna-uts46) is available that normalises and checks names.

Parameters:

1. `name`: string - the domain name UTS46 compliant string.
2. `field`: string - the required data, which could be
    - `addr` - the address ( default )
    - `resolver` - the address of the resolver
    - `hash` - the namehash 
    - `owner` - the owner of the domain




Returns:

the address-string using the upper/lowercase hex characters.

Request:

```js
{
    "method":"in3_ens",
    "params":[
        "cryptokitties.eth",
        "addr"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": "0x06012c8cf97bead5deae237070f9587f8e7a266d"
}
```




### in3_pk2address

extracts the address from a private key.

Parameters:

1. `key`: hex - the 32 bytes private key as hex.

Returns:

the address-string.

Request:

```js
{
    "method":"in3_pk2address",
    "params":[
        "0x0fd65f7da55d811634495754f27ab318a3309e8b4b8a978a50c20a661117435a"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": "0xdc5c4280d8a286f0f9c8f7f55a5a0c67125efcfd"
}
```


### in3_pk2public

extracts the public key from a private key.

Parameters:

1. `key`: hex - the 32 bytes private key as hex.

Returns:

the public key.

Request:

```js
{
    "method":"in3_pk2public",
    "params":[
        "0x0fd65f7da55d811634495754f27ab318a3309e8b4b8a978a50c20a661117435a"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": "0x0903329708d9380aca47b02f3955800179e18bffbb29be3a644593c5f87e4c7fa960983f78186577eccc909cec71cb5763acd92ef4c74e5fa3c43f3a172c6de1"
}
```



### in3_ecrecover

extracts the public key and address from signature.

Parameters:

1. `msg`: hex - the message the signature is based on.
2. `sig`: hex - the 65 bytes signature as hex.
3. `sigtype`: string - the type of the signature data : `eth_sign` (use the prefix and hash it), `raw` (hash the raw data), `hash` (use the already hashed data). Default: `raw`

Returns:

a object with 2 properties:

- `publicKey` : hex - the 64 byte public key
- `address` : address - the 20 byte address

Request:

```js
{
    "method":"in3_ecrecover",
    "params":[
        "0x487b2cbb7997e45b4e9771d14c336b47c87dc2424b11590e32b3a8b9ab327999",
        "0x0f804ff891e97e8a1c35a2ebafc5e7f129a630a70787fb86ad5aec0758d98c7b454dee5564310d497ddfe814839c8babd3a727692be40330b5b41e7693a445b71c",
        "hash"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": {
      "publicKey": "0x94b26bafa6406d7b636fbb4de4edd62a2654eeecda9505e9a478a66c4f42e504c4481bad171e5ba6f15a5f11c26acfc620f802c6768b603dbcbe5151355bbffb",
      "address":"0xf68a4703314e9a9cf65be688bd6d9b3b34594ab4"
   }
}
```

### in3_signData

signs the given data

Parameters:

1. `msg`: hex - the message to sign.
2. `key`: hex - the key (32 bytes) or address (20 bytes) of the signer. If the address is passed, the internal signer needs to support this address.
3. `sigtype`: string - the type of the signature data : `eth_sign` (use the prefix and hash it), `raw` (hash the raw data), `hash` (use the already hashed data). Default: `raw`

Returns:

a object with the following properties:

- `message` : hex - original message used
- `messageHash` : hex - the hash the signature is based on
- `signature`: hex - the signature (65 bytes)
- `r` : hex - the x -value of the EC-Point
- `s` : hex - the y -value of the EC-Point
- `v` : number - the sector (0|1) + 27

Request:

```js
{
    "method":"in3_signData",
    "params":[
        "0x0102030405060708090a0b0c0d0e0f",
        "0xa8b8759ec8b59d7c13ef3630e8530f47ddb47eba12f00f9024d3d48247b62852",
        "raw"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": {
      "message":"0x0102030405060708090a0b0c0d0e0f",
      "messageHash":"0x1d4f6fccf1e27711667605e29b6f15adfda262e5aedfc5db904feea2baa75e67",
      "signature":"0xa5dea9537d27e4e20b6dfc89fa4b3bc4babe9a2375d64fb32a2eab04559e95792264ad1fb83be70c145aec69045da7986b95ee957fb9c5b6d315daa5c0c3e1521b",
      "r":"0xa5dea9537d27e4e20b6dfc89fa4b3bc4babe9a2375d64fb32a2eab04559e9579",
      "s":"0x2264ad1fb83be70c145aec69045da7986b95ee957fb9c5b6d315daa5c0c3e152",
      "v":27
   }
}
```


### in3_decryptKey

decrypts a JSON Keystore file as defined in the [Web3 Secret Storage Definition
](https://github.com/ethereum/wiki/wiki/Web3-Secret-Storage-Definition). The result is the raw private key.

Parameters:

1. `key`: Object - Keydata as object as defined in the keystorefile
2. `passphrase`: String - the password to decrypt it.

Returns:

a raw private key (32 bytes)


Request:

```js
{
    "method": "in3_decryptKey",
    "params": [
        {
            "version": 3,
            "id": "f6b5c0b1-ba7a-4b67-9086-a01ea54ec638",
            "address": "08aa30739030f362a8dd597fd3fcde283e36f4a1",
            "crypto": {
                "ciphertext": "d5c5aafdee81d25bb5ac4048c8c6954dd50c595ee918f120f5a2066951ef992d",
                "cipherparams": {
                    "iv": "415440d2b1d6811d5c8a3f4c92c73f49"
                },
                "cipher": "aes-128-ctr",
                "kdf": "pbkdf2",
                "kdfparams": {
                    "dklen": 32,
                    "salt": "691e9ad0da2b44404f65e0a60cf6aabe3e92d2c23b7410fd187eeeb2c1de4a0d",
                    "c": 16384,
                    "prf": "hmac-sha256"
                },
                "mac": "de651c04fc67fd552002b4235fa23ab2178d3a500caa7070b554168e73359610"
            }
        },
        "test"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": "0x1ff25594a5e12c1e31ebd8112bdf107d217c1393da8dc7fc9d57696263457546"
}
```



### in3_cacheClear

clears the incubed cache (usually found in the .in3-folder)


Request:

```js
{
    "method":"in3_cacheClear",
    "params":[]
}
```

Response:

```js
{
  "id": 1,
  "result": true
}
```


### in3_nodeList

return the list of all registered nodes.

Parameters:

all parameters are optional, but if given a partial NodeList may be returned.

1. `limit`: number - if the number is defined and >0 this method will return a partial nodeList limited to the given number.
2. `seed`: hex - This 32byte hex integer is used to calculate the indexes of the partial nodeList. It is expected to be a random value choosen by the client in order to make the result deterministic.
3. `addresses`: address[] - a optional array of addresses of signers the nodeList must include. 

Returns:

an object with the following properties:

- `nodes`: Node[] - a array of node-values. Each Object has the following properties:

    - `url` : string - the url of the node. Currently only http/https is supported, but in the future this may even support onion-routing or any other protocols.
    - `address` : address - the address of the signer
    - `index`: number - the index within the nodeList of the contract
    - `deposit`: string - the stored deposit
    - `props`: string - the bitset of capabilities as described in the [Node Structure](#node-structure)
    - `timeout`: string - the time in seconds describing how long the deposit would be locked when trying to unregister a node.
    - `registerTime` : string - unix timestamp in seconds when the node has registered.
    - `weight` : string - the weight of a node ( not used yet ) describing the amount of request-points it can handle per second.
    - `proofHash`: hex -  a hash value containing the above values. This hash is explicitly stored in the contract, which enables the client to have only one merkle proof per node instead of verifying each property as its own storage value. The proof hash is build :
        ```js
        return keccak256(
            abi.encodePacked(
                _node.deposit,
                _node.timeout,
                _node.registerTime,
                _node.props,
                _node.signer,
                _node.url
            )
        );
        ```

- `contract` : address - the address of the Incubed-storage-contract. The client may use this information to verify that we are talking about the same contract or throw an exception otherwise.
- `registryId`: hex - the registryId (32 bytes)  of the contract, which is there to verify the correct contract.
- `lastBlockNumber` : number - the blockNumber of the last change of the list (usually the last event). 
- `totalServer` : number - the total numbers of nodes.

if proof is requested, the proof will have the type `accountProof`. In the proof-section only the storage-keys of the `proofHash` will be included.
The required storage keys are calcualted :

- `0x00` - the length of the nodeList or total numbers of nodes.
- `0x01` - the registryId
- per node : ` 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563 + index * 5 + 4`

The blockNumber of the proof must be the latest final block (`latest`- minBlockHeight) and always greater or equal to the `lastBlockNumber` 

This proof section contains the following properties:

- `type` : constant : `accountProof`
- `block` : the serialized blockheader of the latest final block
- `signatures` : a array of signatures from the signers (if requested) of the above block.
- `accounts`: a Object with the addresses of the db-contract as key and Proof as value. The Data Structure of the Proof is exactly the same as the result of - [`eth_getProof`](https://eth.wiki/json-rpc/API#eth_getproof), but it must containi the above described keys
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.




Request:
```js
{
  "method":"in3_nodeList",
  "params":[2,"0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b",[]],
  "in3":{
    "verification":"proof"
  }
}
```

Response:

```js
{
  "id": 1,
  "result": {
    "totalServers": 5,
    "contract": "0x64abe24afbba64cae47e3dc3ced0fcab95e4edd5",
    "lastBlockNumber": 8669495,
    "nodes": [
      {
        "url": "https://in3-v2.slock.it/mainnet/nd-3",
        "address": "0x945F75c0408C0026a3CD204d36f5e47745182fd4",
        "index": 2,
        "deposit": "10000000000000000",
        "props": "29",
        "chainIds": [
          "0x1"
        ],
        "timeout": "3600",
        "registerTime": "1570109570",
        "weight": "2000",
        "proofHash": "27ffb9b7dc2c5f800c13731e7c1e43fb438928dd5d69aaa8159c21fb13180a4c"
      },
      {
        "url": "https://in3-v2.slock.it/mainnet/nd-5",
        "address": "0xbcdF4E3e90cc7288b578329efd7bcC90655148d2",
        "index": 4,
        "deposit": "10000000000000000",
        "props": "29",
        "chainIds": [
          "0x1"
        ],
        "timeout": "3600",
        "registerTime": "1570109690",
        "weight": "2000",
        "proofHash": "d0dbb6f1e28a8b90761b973e678cf8ecd6b5b3a9d61fb9797d187be011ee9ec7"
      }
    ],
    "registryId": "0x423dd84f33a44f60e5d58090dcdcc1c047f57be895415822f211b8cd1fd692e3"
  },
  "in3": {
    "proof": {
      "type": "accountProof",
      "block": "0xf9021ca01...",
      "accounts": {
        "0x64abe24afbba64cae47e3dc3ced0fcab95e4edd5": {
          "accountProof": [
            "0xf90211a0e822...",
            "0xf90211a0f6d0...",
            "0xf90211a04d7b...",
            "0xf90211a0e749...",
            "0xf90211a059cb...",
            "0xf90211a0568f...",
            "0xf8d1a0ac2433...",
            "0xf86d9d33b981..."
          ],
          "address": "0x64abe24afbba64cae47e3dc3ced0fcab95e4edd5",
          "balance": "0xb1a2bc2ec50000",
          "codeHash": "0x18e64869905158477a607a68e9c0074d78f56a9dd5665a5254f456f89d5be398",
          "nonce": "0x1",
          "storageHash": "0x4386ec93bd665ea07d7ed488e8b495b362a31dc4100cf762b22f4346ee925d1f",
          "storageProof": [
            {
              "key": "0x0",
              "proof": [
                "0xf90211a0ccb6d2d5786...",
                "0xf871808080808080800...",
                "0xe2a0200decd9548b62a...05"
              ],
              "value": "0x5"
            },
            {
              "key": "0x1",
              "proof": [
                "0xf90211a0ccb6d2d5786...",
                "0xf89180a010806a37911...",
                "0xf843a0200e2d5276120...423dd84f33a44f60e5d58090dcdcc1c047f57be895415822f211b8cd1fd692e3"
              ],
              "value": "0x423dd84f33a44f60e5d58090dcdcc1c047f57be895415822f211b8cd1fd692e3"
            },
            {
              "key": "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e571",
              "proof": [
                "0xf90211a0ccb6d2d...",
                "0xf871a08b9ff91d8...",
                "0xf843a0206695c25...27ffb9b7dc2c5f800c13731e7c1e43fb438928dd5d69aaa8159c21fb13180a4c"
              ],
              "value": "0x27ffb9b7dc2c5f800c13731e7c1e43fb438928dd5d69aaa8159c21fb13180a4c"
            },
            {
              "key": "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e57b",
              "proof": [
                "0xf90211a0ccb6d2d1...",
                "0xf851a06807310abd...",
                "0xf843a0204d807394...0d0dbb6f1e28a8b90761b973e678cf8ecd6b5b3a9d61fb9797d187be011ee9ec7"
              ],
              "value": "0xd0dbb6f1e28a8b90761b973e678cf8ecd6b5b3a9d61fb9797d187be011ee9ec7"
            }
          ]
        }
      }
    }
  }
}
```



#### Partial NodeLists

if the client requests a partial nodeList and the given limit is smaller then the total amount of nodes, the server needs to pick nodes in a deterministic way. This is done by using the given seed.

1. add all required addresses (if any) to the list.
2. iterate over the indexes until the limit is reached:

    ```ts
    function createIndexes(total: number, limit: number, seed: Buffer): number[] {
      const result: number[] = []              // the result as a list of indexes
      let step = seed.readUIntBE(0, 6)         // first 6 bytes define the step size
      let pos  = seed.readUIntBE(6, 6) % total // next 6 bytes define the offset
      while (result.length < limit) {
        if (result.indexOf(pos) >= 0) {        // if the index is already part of the result
          seed = keccak256(seed)               // we create a new seed by hashing the seed.
          step = seed.readUIntBE(0, 6)         // and change the step-size
        } 
        else
          result.push(pos)
        pos = (pos + step) % total             // use the modulo operator to calculate the next position.
      }
      return result
    }
    ````

### in3_sign

requests a signed blockhash from the node. In most cases these requests will come from other nodes, because the client simply adds the addresses of the requested signers and the processising nodes will then aquire the signatures with this method from the other nodes.

Since each node has a risk of signing a wrong blockhash and getting convicted and losing its deposit, per default nodes will and should not sign blockHash of the last `minBlockHeight` (default: 6) blocks!

Parameters:

1. `blocks`: Object[] - requested blocks. Each block-object has these 2 properties:

    1. `blockNumber` : number - the blockNumber to sign.
    2. `hash` : hex - (optional) the expected hash. This is optional and can be used to check if the expected hash is correct, but as a client you should not rely on it, but only on the hash in the signature.


Returns:

a Object[] with the following properties for each block:

1. `blockHash` : hex - the blockhash signed.
2. `block` : number - the blockNumber
3. `r` : hex - r-value of the signature
3. `s` : hex - s-value of the signature
3. `v` : number- v-value of the signature
3. `msgHash` : the msgHash signed. This Hash is created :

    ```js
    keccak256(
        abi.encodePacked(
            _blockhash,
            _blockNumber,
            registryId
        )
    )
    ```


Request:
```js
{
  "method":"in3_sign",
  "params":[{"blockNumber":8770580}]
}
```

Response:

```js
{
  "id": 1,
  "result": [
    {
      "blockHash": "0xd8189793f64567992eaadefc51834f3d787b03e9a6850b8b9b8003d8d84a76c8",
      "block": 8770580,
      "r": "0x954ed45416e97387a55b2231bff5dd72e822e4a5d60fa43bc9f9e49402019337",
      "s": "0x277163f586585092d146d0d6885095c35c02b360e4125730c52332cf6b99e596",
      "v": 28,
      "msgHash": "0x40c23a32947f40a2560fcb633ab7fa4f3a96e33653096b17ec613fbf41f946ef"
    }
  ],
  "in3": {
    "lastNodeList": 8669495,
    "currentBlock": 8770590
  }
}
```

### in3_whitelist
Returns whitelisted in3-nodes addresses. The whitelist addressed are accquired from whitelist contract that user can specify in request params.

Parameters:

1. `address`: address of whitelist contract

Returns:

- `nodes`: address[] - array of whitelisted nodes addresses.
- `lastWhiteList`: number -  the blockNumber of the last change of the in3 white list event.
- `contract`: address - whitelist contract address.
- `totalServer` : number - the total numbers of whitelist nodes.
- `lastBlockNumber` : number - the blockNumber of the last change of the in3 nodes list (usually the last event). 

If proof requested the proof section contains the following properties:

- `type` : constant : `accountProof`
- `block` : the serialized blockheader of the latest final block
- `signatures` : a array of signatures from the signers (if requested) of the above block.
- `accounts`: a Object with the addresses of the whitelist contract as key and Proof as value. The Data Structure of the Proof is exactly the same as the result of - [`eth_getProof`](https://eth.wiki/json-rpc/API#eth_getproof) and this proof is for proofHash of byte array at storage location 0 in whitelist contract. This byte array is of whitelisted nodes addresses. 
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.

Request:
```js 
{
    "jsonrpc": "2.0",
    "method": "in3_whiteList",
    "params": ["0x08e97ef0a92EB502a1D7574913E2a6636BeC557b"],
    "id": 2,
    "in3": {
        "chainId": "0x5",
         "verification": "proofWithSignature",
         "signatures": [
            "0x45d45e6Ff99E6c34A235d263965910298985fcFe"
        ]
    }
}
```

Response:
```js
{
    "id": 2,
    "result": {
        "totalServers": 2,
        "contract": "0x08e97ef0a92EB502a1D7574913E2a6636BeC557b",
        "lastBlockNumber": 1546354,
        "nodes": [
            "0x1fe2e9bf29aa1938859af64c413361227d04059a",
            "0x45d45e6ff99e6c34a235d263965910298985fcfe"
        ]
    },
    "jsonrpc": "2.0",
    "in3": {
        "execTime": 285,
        "lastValidatorChange": 0,
        "proof": {
            "type": "accountProof",
            "block": "0xf9025ca0082a4e766b4af76b7be75818f25310cbc684ccfbd747a4ccb6cacfb4f870d06ba01dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347940000000000000000000000000000000000000000a0e579ebecc50f46483d58934f2895e22306826e9510728b5a9458f765ad52f0c4a0fe2e2139daa2b8b8cda3d76ac0887987ec5237ec2049ba039f2f60d8201dc44aa0cf55fa4bae8be74e2326813aadac34c7f39d9fa67c4b37a0f1c1f08dfa0d4f43b901000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000010000000000400000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000001831b70c6837a120083323e62845defc6a1b861d883010908846765746888676f312e31332e34856c696e7578000000000000007bec8de63523990c3bb1575ab12876b7c0c58d547971aec5ad9f902ae9808ff148d052f6877598dbb5498ba5231b6a98d2a8e9d053ec681eecf800861676b0e300a00000000000000000000000000000000000000000000000000000000000000000880000000000000000",
            "accounts": {
                "0x08e97ef0a92EB502a1D7574913E2a6636BeC557b": {
                    "accountProof": [
                        "0xf90211a00cb35d3a4253dde597f30682518f94cbac7690d54dc51bb091f67012e606ee1ea065e37ac9eb1773bceb22cc9ec75cf778f6fc9cf50182a0c77be90dc7668976d9a0f99487653c0d8bde493eba5d1a5a3ffdf18b586f3bcbf4effa4ccdf671138df6a0a3e734fdb4718f78635e4627fd4bd8c82f2ab1c4f149f84ac3f4f217e1736e28a0c630e3dfc6b2ce794e7dc656f2d1e4cf99500600ad05ca133d9743a6aefd3572a041d0d563d3442c465d76b59f34bac9f637ccc248eab2da0ff4b3ea2c3c223738a057998484cfe32dc4614bc50b9a7dc84f47a76872e9846bb50b9370c95691c2f1a04d8789dddc9b5e9664d07d09d1deb82299d26bd2f6ba77cc1d94432b9f8ecc89a0dc85869eb80b17566bc54de244cf3be93f52f6a29d8f85786db5518637ce0a69a0bfc183b28f6a678f2ce2b46bddf55b02460b3c64e90d195baaec355adb77345fa00279de24b7e54ec7b5e7a6b870df412a752a80560a40f554b1aa8d89630de07aa0cf288bc9e5ed31382adea2b7d9823636764b1a6b2c1c2acc8e393a658cc794dca024830301aa575af512baf65e2689da32230955180810a8c6f69d7e409a5d7faaa0754b0401fe36129a7eced26d858c5916e4fea71e14833738de2fee6902d055dba0bda3477e9f115402f5bffd6243b49b4587369e96bbe20c7ba02ce7732081f847a0ef91206626dfdf7d557ac7bb90a73902c900b26ff3e56a72980aef66f71f9c3a80",
                        "0xf90211a0d6cce0c7317d26a22e192288b47a5a34ab7aed0b301c249f27a481f5518e4013a05cc0d414a10bdb4a9f1d6ffe6f1dd47cc2a6daca69d046662de6526cc279b440a05332d40bfe849c158f643a5772e73ddfcf088aec6f5c2ab81387b81b5d645819a0c4431b24d011c913bdba8fd743680e43c2f8062ca53ecc5871cb18728c38aedaa0743af64d8069cbb9eebbb59676ff994c6af2df872b368072898bb3da233ccdf1a0591155bc2be76a1c11f8d6d983d198e0c8f7b14c25c9e842d82c8f731f36f59ba0c855553cb0a3e807eb6a799bdb225dade93c05dda2c140c2745b42fa9aa02023a038a1ce0bc1fb703507391fc069320533c6fb5d148bcd6e5dbf520ebffccf3e70a0ca66205070eaf405b27631ab8456959b561016adf9e827d5f5ae8f5ee5cbc75ba0c441c3242e80977935242d37a7c467fcaa7f4827d047b4cfd6ded84128402881a0d321fca44911f9755f8c7d0889c0495581b17cbfbd2bee4c1bae8d201e3c80b6a0a8f1b2bd675fc38183df2d8ac4c34009a30ff6622b6e19cae828a8ef596309fea0c47655639b08cae9669911d07a3155abfdcb0520316621b44488f3b015a95749a01160d4873873a91a4adb8bdcc70164c108149c6cd532e88dd55bc595d4cb29b4a0b826c160282bc72ad28ec91960224119f692af7f4ab9a12e10cd25cb3f095c48a0b35a48e0175f0443a080031c97993e5c1d8e46e8310db14bfa612b8616e718ad80",
                        "0xf90211a0432a3bf286f659650359ae590aa340ce2a2a0d1f60fae509ea9d6a8b90215bfea06b2ab1984e6e8d80eac8d394771a31388f9f33e1548f7d284adeb5af98537ccea0529861b2110d23074ad1a4d2e1b8cf9dd2671a5021fc42c24fd29bac1bd198b6a0f355735de5167100f755d9367e9885dbe3519ecdfea6b7e833cfff2366fbce3aa0652dcb78e9f4648f4aaad9584cf1c1defe6ea037822176763bc37aa72e668233a0b859c67a88f919fd44f9c89a8389790fb2b9ae8c724f97068d312ffa019615b7a01d61365effb1ae10bf5a8fa6339fd08ee2dfcf1c408e0ed5c976742949096c29a0411c3f5a2d1a28cc4a1f42db2c17b393c6f4f6eee5d71ffffbe7f20234b2e779a0848f9e1442280f0442980561db8da240a44e7901907e705fa2f80055dd0c9853a0b152eb66b44bfa0270440f993c7edfe84138c9ab464b69070597617ca3c6db6da0fb4dacb897ae63689ac752cda4141c445a7835109e96d2de8f543e233f40a19ea0338d8f77f033fc36a4a8f693e4f731214fe70aaca9f449cf8a8f4f5e3802edfda0b987f3946a5d0407439fad51cad937e7705c48a07e38bba35ef79472dd08fcc5a02486f4e11355119bcfa5a11bb6e80625b1f7b565e29ae88e0445fdc2ea2d9164a043d4fa67268fd6ef0f74403835673b31c725e4467572596ab637b4799da064a3a08e876ea69875d39b76414027c28d497944103599d92cbefaf9dc37c4b8a14c0780",
                        "0xf8d1a06f998e7193562c27933250e1e72c5a2ff0bf2df556fe478b4436e8b8ac7a7900808080a0de5d6d0bab81e7a0dcc4cfec42503384d17fefff05ba8b6082de08417044aa2b808080a07044d7c1323585aa14ea75c4cfef82b6b3320fa341627b142a9edf7eba6ea42da0223ee97601935bd3d1610a6cbe653d6b7870c1dff46e0b5db3bfdc1d9a53644580a0f7824a944cb1a64517347f54bc73cd5fc9ebd90eecca95e0a68f79d81cc4318a80a061a70db828977db72f5c1ef4808a784a8c51629d6888e5d86ffe583a5fe5f268808080",
                        "0xf85180808080808080a03dd3d6e0c95682f178213fd20364be0395c9e94086eb373fd4aa13ebe4ab3ee280808080808080a0ec5d4cd2b11aaba34c5569cdae245baccd49b7f503a4e4223130d453c00b2e0080",
                        "0xf8679e39ce2fd3705a1089a91865fc977c0a778d01f4f3ba9a0fd6378abecef87ab846f8440180a0f5e650b7122ddd254ecc84d87c04ea99117f12badec917985f5f3335b355cb5ea0640aaa823fe1752d44d83bcfd0081ec6a1dc72bb82223940a621b0ea251b52c4"
                    ],
                    "address": "0x08e97ef0a92eb502a1d7574913e2a6636bec557b",
                    "balance": "0x0",
                    "codeHash": "0x640aaa823fe1752d44d83bcfd0081ec6a1dc72bb82223940a621b0ea251b52c4",
                    "nonce": "0x1",
                    "storageHash": "0xf5e650b7122ddd254ecc84d87c04ea99117f12badec917985f5f3335b355cb5e",
                    "storageProof": [
                        {
                            "key": "0x0",
                            "proof": [
                                "0xf90111a05541df1966b288bce9c5b6f93d564e736f3f984cb3aa4b067ba88e4398bdc86da06483c09a5b5f8f4206d30706bc9d537e01077fcc583bafea8b0f1987a6e78084a04a245b8b7c143b14a7cb72e436df03e1d029f619a2e986108c4ffdb23565b2cb80a0f2800672a0b38a211231189e7ff7c5d466359c3f7195be1601e0ec2dc1cd5f9e8080a0e38ca3fed40d881e90e889d18e237320604485c7260840b108b03b2309088befa0a3167f2a5984b53340a550067602e9d0fc103f83b1b39108cc0c090d879e2c498080a0435071d8aee5a2d7b7fd0de53bfefc129eef08150882fd4f212b4e664920950980a0c7c0421f87cacaa5c81c39cbd7be150c52780feb2c92a62dc62b25dd6dddcdc4808080",
                                "0xf851808080808080808080a02b2bb6a045f22c77b07ecf8b1f7655f7ed4ccb826b16681ccf1965d4b72ad6df8080808080a076424cf5a443e7be91436a36c4d1593c5fe7736fe29acb66bbe8be0ccc7ae78280",
                                "0xf843a0200decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563a1a06aa7bbfbb1778efa33da1ba032cc3a79b9ef57b428441b4de4f1c38c3f258874"
                            ],
                            "value": "0x6aa7bbfbb1778efa33da1ba032cc3a79b9ef57b428441b4de4f1c38c3f258874"
                        }
                    ]
                }
            },
            "signatures": [
                {
                    "blockHash": "0x2d775ab9b1290f487065e612942a84fc2275572e467040eea154fbbae2005c41",
                    "block": 1798342,
                    "r": "0xf6036400705455c1dfb431e1c90b91f3e50815516577f1ebca9a494164b12d17",
                    "s": "0x30e77bc851e02fc79deab63812203b2dfcacd7a83af14a86c8c9d26d95763cc5",
                    "v": 28,
                    "msgHash": "0x7953b8a420bfe9d1c902e2090f533c9b3f73f0f825b7cec247d7d94e548bc5d9"
                }
            ]
        },
        "lastWhiteList": 1546354
    }
}
```

## eth

Standard JSON-RPC calls as described in https://eth.wiki/json-rpc/API.

Whenever a request is made for a response with `verification`: `proof`, the node must provide the proof needed to validate the response result. The proof itself depends on the chain.

For ethereum, all proofs are based on the correct block hash. That's why verification differentiates between [Verifying the blockhash](poa.html) (which depends on the user consensus) the actual result data.

There is another reason why the BlockHash is so important. This is the only value you are able to access from within a SmartContract, because the evm supports a OpCode (`BLOCKHASH`), which allows you to read the last 256 blockhashes, which gives us the chance to verify even the blockhash onchain.

Depending on the method, different proofs are needed, which are described in this document.


Proofs will add a special in3-section to the response containing a `proof`- object. Each `in3`-section of the response containing proofs has a property with a proof-object with the following properties:

*  **type** `string` (required)  - The type of the proof.   
 Must be one of the these values : `'transactionProof`', `'receiptProof`', `'blockProof`', `'accountProof`', `'callProof`', `'logProof`'
*  **block** `string` - The serialized blockheader as hex, required in most proofs. 
*  **finalityBlocks** `array` - The serialized following blockheaders as hex, required in case of finality asked (only relevant for PoA-chains). The server must deliver enough blockheaders to cover more then 50% of the validators. In order to verify them, they must be linkable (with the parentHash).    
*  **transactions** `array` - The list of raw transactions of the block if needed to create a merkle trie for the transactions. 
*  **uncles** `array` - The list of uncle-headers of the block. This will only be set if full verification is required in order to create a merkle tree for the uncles and so prove the uncle_hash.   
*  **merkleProof** `string[]` - The serialized merkle-nodes beginning with the root-node (depending on the content to prove).
*  **merkleProofPrev** `string[]` - The serialized merkle-nodes beginning with the root-node of the previous entry (only for full proof of receipts).   
*  **txProof** `string[]` - The serialized merkle-nodes beginning with the root-node in order to proof the transactionIndex (only needed for transaction receipts).
*  **logProof** [LogProof](#logproof) - The Log Proof in case of a `eth_getLogs`-request.   
*  **accounts** `object` - A map of addresses and their AccountProof.   
*  **txIndex** `integer` - The transactionIndex within the block (for transaactions and receipts).   
*  **signatures** `Signature[]` - Requested signatures.   


### web3_clientVersion

Returns the underlying client version.

See [web3_clientversion](https://eth.wiki/json-rpc/API#web3_clientversion) for spec.

No proof or verification possible.


### web3_sha3

Returns Keccak-256 (not the standardized SHA3-256) of the given data.

See [web3_sha3](https://eth.wiki/json-rpc/API#web3_sha3) for spec.

No proof returned, but the client must verify the result by hashing the request data itself.

### net_version

Returns the current network ID.

See [net_version](https://eth.wiki/json-rpc/API#net_version) for spec.

No proof returned, but the client must verify the result by comparing it to the used chainId.

### eth_blockNumber

Returns the number of the most recent block.

See [eth_blockNumber](https://eth.wiki/json-rpc/API#eth_blockNumber) for spec.

No proof returned, since there is none, but the client should verify the result by comparing it to the current blocks returned from others. With the `blockTime` from the chainspec, including a tolerance, the current blocknumber may be checked if in the proposed range.

### eth_getBlockByNumber

See [block based proof](#eth-getblockbyhash)

### eth_getBlockByHash

Return the block data and proof.

See JSON-RPC-Spec 
- [eth_getBlockByNumber](https://eth.wiki/json-rpc/API#eth_getBlockByNumber) - find block by number.
- [eth_getBlockByHash](https://eth.wiki/json-rpc/API#eth_getBlockByHash) - find block by hash.


The `eth_getBlockBy...` methods return the Block-Data. In this case, all we need is somebody verifying the blockhash, which is done by requiring somebody who stored a deposit and would otherwise lose it, to sign this blockhash.

The verification is then done by simply creating the blockhash and comparing this to the signed one.

The blockhash is calculated by [serializing the blockdata](https://github.com/slockit/in3/blob/master/src/util/serialize.ts#L120) with [rlp](https://github.com/ethereum/wiki/wiki/RLP) and hashing it:

```js
blockHeader = rlp.encode([
  bytes32( parentHash ),
  bytes32( sha3Uncles ),
  address( miner || coinbase ),
  bytes32( stateRoot ),
  bytes32( transactionsRoot ),
  bytes32( receiptsRoot || receiptRoot ),
  bytes256( logsBloom ),
  uint( difficulty ),
  uint( number ),
  uint( gasLimit ),
  uint( gasUsed ),
  uint( timestamp ),
  bytes( extraData ),

  ... sealFields
    ? sealFields.map( rlp.decode )
    : [
      bytes32( b.mixHash ),
      bytes8( b.nonce )
    ]
])
```

For POA-chains, the blockheader will use the `sealFields` (instead of mixHash and nonce) which are already RLP-encoded and should be added as raw data when using rlp.encode.

```js
if (keccak256(blockHeader) !== singedBlockHash) 
  throw new Error('Invalid Block')
```

In case of the `eth_getBlockTransactionCountBy...`, the proof contains the full blockHeader already serilalized plus all transactionHashes. This is needed in order to verify them in a merkle tree and compare them with the `transactionRoot`.


Requests requiring proof for blocks will return a proof of type `blockProof`. Depending on the request, the proof will contain the following properties:

- `type` : constant : `blockProof`
- `signatures` : a array of signatures from the signers (if requested) of the requested block.
- `transactions`: a array of raw transactions of the block. This is only needed the last parameter of the request (includeTransactions) is `false`,  In this case the result only contains the transactionHashes, but in order to verify we need to be able to build the complete merkle-trie, where the raw transactions are needed. If the complete transactions are included the raw transactions can be build from those values.
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.
- `uncles`: only if `fullProof` is requested we add  all blockheaders of the uncles to the proof in order to verify the uncleRoot.

Request:

```js
{
    "method": "eth_getBlockByNumber",
    "params": [
        "0x967a46",
        false
    ],
    "in3": {
      "verification":"proof"
    }
}
```

Response:
```js
{
    "jsonrpc": "2.0",
    "result": {
        "author": "0x00d6cc1ba9cf89bd2e58009741f4f7325badc0ed",
        "difficulty": "0xfffffffffffffffffffffffffffffffe",
        "extraData": "0xde830201088f5061726974792d457468657265756d86312e33302e30827769",
        "gasLimit": "0x7a1200",
        "gasUsed": "0x1ce0f",
        "hash": "0xfeb120ae45f1009e6c2289436d5957c58a15915288ec083658bd044101608f26",
        "logsBloom": "0x0008000...",
        "miner": "0x00d6cc1ba9cf89bd2e58009741f4f7325badc0ed",
        "number": "0x967a46",
        "parentHash": "0xc591335e0cdb6b21dc9af57567a6e075fc6315aff915bd79bf78a2c8815bc657",
        "receiptsRoot": "0xfa2a0b3c0715e798ae41fd4645b0261ae4bf6d2c56f29da6fcc5fbfb7c6f19f8",
        "sealFields": [
            "0x8417098353",
            "0xb841eb80c1a0be2eb7a1c14fc38759a0f9fe9c33121d72003025160a4b35119d495d34d39a9fd7475d28ba863e35f5103ed43e6f13ce31f026d3d29c0d2b1848fb4300"
        ],
        "sha3Uncles": "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
        "size": "0x44e",
        "stateRoot": "0xd618159b6dbd0c6213d90abbf01e06513104f0670cd79503cb2563d7ff116864",
        "timestamp": "0x5c260d4c",
        "totalDifficulty": "0x94373700000000000000000000000484b6f390",
        "transactions": [
            "0x16cfadb6a0a823c623788713cb1eb7d399f89f78d599d416f7b91dca44eeb804",
            "0x91458145d2c47527eee34e891879ac2915b3f8ba6f31911c5234928ae32cb191"
        ],
        "transactionsRoot": "0x4f1249c6378282b1f032cc8c2562712f2450a0bed8ce20bdd2d01b6520feb75a",
        "uncles": []
    },
    "id": 77,
    "in3": {
        "proof": {
            "type": "blockProof",
            "signatures": [ ...  ],
            "transactions": [
                "0xf8ac8201158504a817c8....",
                "0xf9014c8301a3d4843b9ac....",
            ]
        },
        "currentBlock": 9866910,
        "lastNodeList": 8057063,
    }
}
```


### eth_getBlockTransactionCountByHash

See [transaction count proof](#eth-getunclecountbyblocknumber)

### eth_getBlockTransactionCountByNumber

See [transaction count proof](#eth-getunclecountbyblocknumber)

### eth_getUncleCountByBlockHash

See [count proof](#eth-getunclecountbyblocknumber)

### eth_getUncleCountByBlockNumber

return the number of transactions or uncles.

See JSON-RPC-Spec 
- [eth_getBlockTransactionCountByHash](https://eth.wiki/json-rpc/API#eth_getBlockTransactionCountByHash) - number of transaction by block hash.
- [eth_getBlockTransactionCountByNumber](https://eth.wiki/json-rpc/API#eth_getBlockTransactionCountByNumber) - number of transaction by block number.
- [eth_getUncleCountByBlockHash](https://eth.wiki/json-rpc/API#eth_getUncleCountByBlockHash) - number of uncles by block number.
- [eth_getUncleCountByBlockNumber](https://eth.wiki/json-rpc/API#eth_getUncleCountByBlockNumber) - number of uncles by block number.

Requests requiring proof for blocks will return a proof of type `blockProof`.  Depending on the request, the proof will contain the following properties:

- `type` : constant : `blockProof`
- `signatures` : a array of signatures from the signers (if requested) of the requested block.
- `block` : the serialized blockheader
- `transactions`: a array of raw transactions of the block. This is only needed if the number of transactions are requested.
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.
- `uncles`: a array of blockheaders of the uncles of the block. This is only needed if the number of uncles are requested.


### eth_getTransactionByHash

return the transaction data.


See JSON-RPC-Spec 
- [eth_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash) - transaction data by hash.
- [eth_getTransactionByBlockHashAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockHashAndIndex) - transaction data based on blockhash and index
- [eth_getTransactionByBlockNumberAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockNumberAndIndex) - transaction data based on block number and index


```eval_rst
.. graphviz::

    digraph minimal_nonplanar_graphs {
     
    fontname="Helvetica"
      subgraph all {

        node [ fontsize = "12", style="", color=black fontname="Helvetica", shape=record ]

        subgraph block_header {
            label="blockheader" style="" color=black

            bheader[ label="parentHash|...|<tr>transactionRoot|receiptRoot|stateRoot"]
            troot:a -> bheader:tr 
        }

        subgraph cluster_client_registry {
            label="Transaction Trie"  color=lightblue  style=filled

            troot[label="|<a>0x123456|||||"]  
            ta[label="|0x123456||<a>0xabcdef|||"]  
            tb[label="|0x98765||<a>0xfcab34|||"]  
            tval[label="transaction data"]  

            ta:a -> troot:a
            tb:a -> troot:a 
            tval:a -> ta:a
        }


      }
    }

```

In order to prove the transaction data, each transaction of the containing block must be serialized

```js
transaction = rlp.encode([
  uint( tx.nonce ),
  uint( tx.gasPrice ),
  uint( tx.gas || tx.gasLimit ),
  address( tx.to ),
  uint( tx.value ),
  bytes( tx.input || tx.data ),
  uint( tx.v ),
  uint( tx.r ),
  uint( tx.s )
])
``` 

and stored in a merkle tree with `rlp.encode(transactionIndex)` as key or path, since the blockheader only contains the `transactionRoot`, which is the root-hash of the resulting merkle tree. A merkle-proof with the transactionIndex of the target transaction will then be created from this tree.

If the request requires proof (`verification`: `proof`) the node will provide an Transaction Proof as part of the in3-section of the response. 
This proof section contains the following properties:

- `type` : constant : `transactionProof`
- `block` : the serialized blockheader of the requested transaction.
- `signatures` : a array of signatures from the signers (if requested) of the above block.
- `txIndex` : The TransactionIndex as used in the MerkleProof ( not needed if the methode was `eth_getTransactionByBlock...`, since already given)
- `merkleProof`: the serialized nodes of the Transaction trie starting with the root node.
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.

While there is no proof for a non existing transaction, if the request was a  `eth_getTransactionByBlock...` the node must deliver a partial merkle-proof to verify that this node does not exist.

Request:
```js
{
  "method":"eth_getTransactionByHash",
  "params":["0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b"],
  "in3":{
    "verification":"proof"
  }
}
```

Response:

```js
{
  "jsonrpc": "2.0",
  "id": 6,
  "result": {
    "blockHash": "0xf1a2fd6a36f27950c78ce559b1dc4e991d46590683cb8cb84804fa672bca395b",
    "blockNumber": "0xca",
    "from": "0x7e5f4552091a69125d5dfcb7b8c2659029395bdf",
    "gas": "0x55f0",
    "gasPrice": "0x0",
    "hash": "0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b",
    "input": "0x00",
    "value": "0x3e8"
    ...
  },
  "in3": {
    "proof": {
      "type": "transactionProof",
      "block": "0xf901e6a040997a53895b48...", // serialized blockheader
      "merkleProof": [  /* serialized nodes starting with the root-node */
        "0xf868822080b863f86136808255f0942b5ad5c4795c026514f8317c7a215e218dc..."
        "0xcd6cf8203e8001ca0dc967310342af5042bb64c34d3b92799345401b26713b43f..."
      ],
      "txIndex": 0,
      "signatures": [...]
    }
  }
}
```

### eth_getTransactionReceipt

The Receipt of a Transaction.

See JSON-RPC-Spec 
- [eth_getTransactionReceipt](https://eth.wiki/json-rpc/API#eth_gettransactionreceipt) - returns the receipt.


```eval_rst
.. graphviz::

    digraph minimal_nonplanar_graphs {
     
    fontname="Helvetica"
      subgraph all {

        node [ fontsize = "12", style="", color=black fontname="Helvetica", shape=record ]

        subgraph blockheader {
            label="blocheader" style="" color=black

            bheader[ label="parentHash|...|transactionRoot|<tr>receiptRoot|stateRoot"]
            troot:a -> bheader:tr 
        }

        subgraph cluster_client_registry {
            label="Receipt Trie"  color=lightblue  style=filled

            troot[label="|<a>0x123456|||||"]  
            ta[label="|0x123456||<a>0xabcdef|||"]  
            tb[label="|0x98765||<a>0xfcab34|||"]  
            tval[label="transaction receipt"]  

            ta:a -> troot:a
            tb:a -> troot:a 
            tval:a -> ta:a
        }


      }
    }

```

The proof works similiar to the transaction proof.

In order to create the proof we need to serialize all transaction receipts 

```js
transactionReceipt = rlp.encode([
  uint( r.status || r.root ),
  uint( r.cumulativeGasUsed ),
  bytes256( r.logsBloom ),
  r.logs.map(l => [
    address( l.address ),
    l.topics.map( bytes32 ),
    bytes( l.data )
  ])
].slice(r.status === null && r.root === null ? 1 : 0))
``` 

and store them in a merkle tree with `rlp.encode(transactionIndex)` as key or path, since the blockheader only contains the `receiptRoot`, which is the root-hash of the resulting merkle tree. A merkle proof with the transactionIndex of the target transaction receipt will then be created from this tree.

Since the merkle proof is only proving the value for the given transactionIndex, we also need to prove that the transactionIndex matches the transactionHash requested. This is done by adding another MerkleProof for the transaction itself as described in the [Transaction Proof](#eth-gettransactionbyhash).


If the request requires proof (`verification`: `proof`) the node will provide an Transaction Proof as part of the in3-section of the response. 
This proof section contains the following properties:

- `type` : constant : `receiptProof`
- `block` : the serialized blockheader of the requested transaction.
- `signatures` : a array of signatures from the signers (if requested) of the above block.
- `txIndex` : The TransactionIndex as used in the MerkleProof
- `txProof` : the serialized nodes of the Transaction trie starting with the root node. This is needed in order to proof that the required transactionHash matches the receipt.
- `merkleProof`: the serialized nodes of the Transaction Receipt trie starting with the root node.
- `merkleProofPrev`: the serialized nodes of the previous Transaction Receipt (if txInxdex>0) trie starting with the root node. This is only needed if full-verification is requested. With a verified previous Receipt we can proof the `usedGas`.
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.


Request:
```js
{
  "method": "eth_getTransactionReceipt",
  "params": [
      "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
  ]
  "in3":{
    "verification":"proof"
  }
}
```

Response:

```js
{
    "result": {
        "blockHash": "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304",
        "blockNumber": "0x8c1e39",
        "contractAddress": null,
        "cumulativeGasUsed": "0x2466d",
        "gasUsed": "0x2466d",
        "logs": [
            {
                "address": "0x85ec283a3ed4b66df4da23656d4bf8a507383bca",
                "blockHash": "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304",
                "blockNumber": "0x8c1e39",
                "data": "0x00000000000...",
                "logIndex": "0x0",
                "removed": false,
                "topics": [
                    "0x9123e6a7c5d144bd06140643c88de8e01adcbb24350190c02218a4435c7041f8",
                    "0xa2f7689fc12ea917d9029117d32b9fdef2a53462c853462ca86b71b97dd84af6",
                    "0x55a6ef49ec5dcf6cd006d21f151f390692eedd839c813a150000000000000000"
                ],
                "transactionHash": "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e",
                "transactionIndex": "0x0",
                "transactionLogIndex": "0x0",
                "type": "mined"
            }
        ],
        "logsBloom": "0x00000000000000000000200000...",
        "root": null,
        "status": "0x1",
        "transactionHash": "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e",
        "transactionIndex": "0x0"
    },
    "in3": {
        "proof": {
            "type": "receiptProof",
            "block": "0xf9023fa019e9d929ab...",
            "txProof": [
                "0xf851a083c8446ab932130..."
            ],
            "merkleProof": [
                "0xf851a0b0f5b7429a54b10..."
            ],
            "txIndex": 0,
            "signatures": [...],
            "merkleProofPrev": [
                "0xf851a0b0f5b7429a54b10..."
            ]
        },
        "currentBlock": 9182894,
        "lastNodeList": 6194869
    }
}
```

### eth_getLogs


Proofs for logs or events.

See JSON-RPC-Spec 
- [eth_getLogs](https://eth.wiki/json-rpc/API#eth_getLogs) - returns all event matching the filter.

Since logs or events are based on the TransactionReceipts, the only way to prove them is by proving the TransactionReceipt each event belongs to.

That's why this proof needs to provide:
- all blockheaders where these events occured
- all TransactionReceipts plus their MerkleProof of the logs
- all MerkleProofs for the transactions in order to prove the transactionIndex

The proof data structure will look like this:

```ts
  Proof {
    type: 'logProof',
    logProof: {
      [blockNr: string]: {  // the blockNumber in hex as key
        block : string  // serialized blockheader
        receipts: {
          [txHash: string]: {  // the transactionHash as key
            txIndex: number // transactionIndex within the block
            txProof: string[] // the merkle Proof-Array for the transaction
            proof: string[] // the merkle Proof-Array for the receipts
          }
        }
      }
    }
  }
```


In order to create the proof, we group all events into their blocks and transactions, so we only need to provide the blockheader once per block. 
The merkle-proofs for receipts are created as described in the [Receipt Proof](#eth-gettransactionreceipt).




If the request requires proof (`verification`: `proof`) the node will provide an Transaction Proof as part of the in3-section of the response. 
This proof section contains the following properties:

- `type` : constant : `logProof`
- `logProof` : The proof for all the receipts. This structure contains an object with the blockNumbers as keys. Each block contains the blockheader and the receipt proofs.
- `signatures` : a array of signatures from the signers (if requested) of the above blocks.
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.


Request:
```js
{
  "method": "eth_getLogs",
  "params": [
      {
          "fromBlock": "0x7ae000",
          "toBlock": "0x7af0e4",
          "address": "0x27a37a1210df14f7e058393d026e2fb53b7cf8c1"
      }
  ],
  "in3":{
    "verification":"proof"
  }
}
```

Response:

```js
{
    "jsonrpc": "2.0",
    "result": [
        {
            "address": "0x27a37a1210df14f7e058393d026e2fb53b7cf8c1",
            "blockHash": "0x12657acc9dbca74775efcc09bcd55da769e89fff27a0402e02708a6e69caa3bb",
            "blockNumber": "0x7ae16b",
            "data": "0x0000000000000...",
            "logIndex": "0x0",
            "removed": false,
            "topics": [
                "0x690cd1ace756531abc63987913dcfaf18055f3bd6bb27d3def1cc5319ebc1461"
            ],
            "transactionHash": "0xddc81454b0df60fb31dbefd0fd4c5e8fe4f3daa541c879964500d876056e2976",
            "transactionIndex": "0x0",
            "transactionLogIndex": "0x0",
            "type": "mined"
        },
        {
            "address": "0x27a37a1210df14f7e058393d026e2fb53b7cf8c1",
            "blockHash": "0x2410d512d12e18b2451efe195ece85723b7f39c3f5d706ea112bfcc57c0249d2",
            "blockNumber": "0x7af0e4",
            "data": "0x000000000000000...",
            "logIndex": "0x4",
            "removed": false,
            "topics": [
                "0x690cd1ace756531abc63987913dcfaf18055f3bd6bb27d3def1cc5319ebc1461"
            ],
            "transactionHash": "0x30fe995d61a5491a49e8f1283b36f4cb7fa5d370927bd8784c33e702546a9daa",
            "transactionIndex": "0x4",
            "transactionLogIndex": "0x0",
            "type": "mined"
        }
    ],
    "id": 144,
    "in3": {
        "proof": {
            "type": "logProof",
            "logProof": {
                "0x7ae16b": {
                    "number": 8053099,
                    "receipts": {
                        "0xddc81454b0df60fb31dbefd0fd4c5e8fe4f3daa541c879964500d876056e2976": {
                            "txHash": "0xddc81454b0df60fb31dbefd0fd4c5e8fe4f3daa541c879964500d876056e2976",
                            "txIndex": 0,
                            "proof": [
                                "0xf9020e822080b90208f..."
                            ],
                            "txProof": [
                                "0xf8f7822080b8f2f8f080..."
                            ]
                        }
                    },
                    "block": "0xf9023ea002343274..."
                },
                "0x7af0e4": {
                    "number": 8057060,
                    "receipts": {
                        "0x30fe995d61a5491a49e8f1283b36f4cb7fa5d370927bd8784c33e702546a9daa": {
                            "txHash": "0x30fe995d61a5491a49e8f1283b36f4cb7fa5d370927bd8784c33e702546a9daa",
                            "txIndex": 4,
                            "proof": [
                                "0xf851a039faec6276...",
                                "0xf8b180a0ee82c377...",
                                "0xf9020c20b90208f9..."
                            ],
                            "txProof": [
                                "0xf851a09250840f6b87...",
                                "0xf8b180a04e5257328b...",
                                "0xf8f620b8f3f8f18085..."
                            ]
                        }
                    },
                    "block": "0xf9023ea03837491e4b3b..."
                }
            }
        },
        "lastValidatorChange": 0,
        "lastNodeList": 8057063
    }
}
```



### eth_getBalance

See [account proof](#eth-getstorageat)

### eth_getCode

See [account proof](#eth-getstorageat)

### eth_getTransactionCount

See [account proof](#eth-getstorageat)

### eth_getStorageAt

Returns account based values and proof.

See JSON-RPC-Spec 
- [eth_getBalance](https://eth.wiki/json-rpc/API#eth_getBalance) - returns the balance.
- [eth_getCode](https://eth.wiki/json-rpc/API#eth_getcode) - the byte code of the contract.
- [eth_getTransactionCount](https://eth.wiki/json-rpc/API#eth_gettransactioncount) - the nonce of the account.
- [eth_getStorageAt](https://eth.wiki/json-rpc/API#eth_getstorageat) - the storage value for the given key of the given account.


Each of these account values are stored in the account-object:

```js
account = rlp.encode([
  uint( nonce),
  uint( balance),
  bytes32( storageHash || ethUtil.KECCAK256_RLP),
  bytes32( codeHash || ethUtil.KECCAK256_NULL)
])
```

The proof of an account is created by taking the state merkle tree and creating a MerkleProof. Since all of the above RPC-methods only provide a single value, the proof must contain all four values in order to encode them and verify the value of the MerkleProof. 

For verification, the `stateRoot` of the blockHeader is used and `keccak(accountProof.address)` as the path or key within the merkle tree.

```js
verifyMerkleProof(
 block.stateRoot, // expected merkle root
 keccak(accountProof.address), // path, which is the hashed address
 accountProof.accountProof), // array of Buffer with the merkle-proof-data
 isNotExistend(accountProof) ? null : serializeAccount(accountProof), // the expected serialized account
)
```

In case the account does not exist yet (which is the case if `none` == `startNonce` and `codeHash` == `'0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470'`), the proof may end with one of these nodes:
    
- The last node is a branch, where the child of the next step does not exist.
- The last node is a leaf with a different relative key.

Both would prove that this key does not exist.

For `eth_getStorageAt`, an additional storage proof is required. This is created by using the `storageHash` of the account and creating a MerkleProof using the hash of the storage key (`keccak(key)`) as path.


```js
verifyMerkleProof(
  bytes32( accountProof.storageHash ),   // the storageRoot of the account
  keccak(bytes32(s.key)),  // the path, which is the hash of the key
  s.proof.map(bytes), // array of Buffer with the merkle-proof-data
  s.value === '0x0' ? null : util.rlp.encode(s.value) // the expected value or none to proof non-existence
))
```


```eval_rst
.. graphviz::

    digraph minimal_nonplanar_graphs {
     
    fontname="Helvetica"
      subgraph all {

        node [ fontsize = "12", style="", color=black fontname="Helvetica", shape=record ]

        subgraph cluster_block_header {
            label="Blockheader" color=white  style=filled

            bheader[ label="parentHash|...|<tr>stateRoot|transactionRoot|receiptRoot|..."]
        }

        subgraph cluster_state_trie {
            label="State Trie"  color=lightblue  style=filled

            troot[label="|<a>0x123456|||||<b>0xabcdef"]  
            ta[label="|0x123456||<a>0xabcdef|||"]  
            tb[label="|0x98765||<a>0xfcab34|||"]  
            tval[label="nonce|balance|<sr>storageHash|codeHash"]  

            ta:a -> troot:a
            tb:a -> troot:b 
            tval:a -> ta:a
        }

        subgraph cluster_storage_trie {
            label="Storage Trie"  color=lightblue  style=filled

            sroot[label="|<a>0x123456|||||<b>0xabcdef"]  
            sa[label="|0x123456||<a>0xabcdef|||"]  
            sb[label="|0x98765||<a>0xfcab34|||"]  
            sval[label="storage value"]  

            sa:a -> sroot:a
            sb:a -> sroot:b 
            sval:a -> sa:a
        }

        sroot:a -> tval:sr
        troot:a -> bheader:tr 

      }
    }

```




If the request requires proof (`verification`: `proof`) the node will provide an Account Proof as part of the in3-section of the response.
This proof section contains the following properties:

- `type` : constant : `accountProof`
- `block` : the serialized blockheader of the requested block (the last parameter of the request)
- `signatures` : a array of signatures from the signers (if requested) of the above block.
- `accounts`: a Object with the addresses of all required accounts (in this case it is only one account) as key and Proof as value. The DataStructure of the Proof for each account is exactly the same as the result of - [`eth_getProof`](https://eth.wiki/json-rpc/API#eth_getproof). 
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.

**Example**

Request:
```js
{
    "method": "eth_getStorageAt",
    "params": [
        "0x27a37a1210Df14f7E058393d026e2fB53B7cf8c1",
        "0x0",
        "latest"
    ],
    "in3": {
      "verification":"proof"
    }
}
```

Response:
```js
{
    "id": 77,
    "jsonrpc": "2.0",
    "result": "0x5",
    "in3": {
        "proof": {
            "type": "accountProof",
            "block": "0xf90246...",
            "signatures": [...],
            "accounts": {
                "0x27a37a1210Df14f7E058393d026e2fB53B7cf8c1": {
                    "accountProof": [
                        "0xf90211a0bf....",
                        "0xf90211a092....",
                        "0xf90211a0d4....",
                        "0xf90211a084....",
                        "0xf9019180a0...."
                    ],
                    "address": "0x27a37a1210df14f7e058393d026e2fb53b7cf8c1",
                    "balance": "0x11c37937e08000",
                    "codeHash": "0x3b4e727399e02beb6c92e8570b4ccdd24b6a3ef447c89579de5975edd861264e",
                    "nonce": "0x1",
                    "storageHash": "0x595b6b8bfaad7a24d0e5725ba86887c81a9d99ece3afcce1faf508184fcbe681",
                    "storageProof": [
                        {
                            "key": "0x0",
                            "proof": [
                                "0xf90191a08e....",
                                "0xf871808080....",
                                "0xe2a0200decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e56305"
                            ],
                            "value": "0x5"
                        }
                    ]
                }
            }
        },
        "currentBlock": 9912897,
        "lastNodeList": 8057063
    }
}
```

### eth_estimateGas

See [call proof](#eth-call)

### eth_call

calls a function of a contract (or simply executes the evm opcodes).

See JSON-RPC-Spec 
- [eth_call](https://eth.wiki/json-rpc/API#eth_call) - executes a function and returns the result.
- [eth_estimateGas](https://eth.wiki/json-rpc/API#eth_estimateGas) - executes a function and returns the gas used.


Verifying the result of an `eth_call` is a little bit more complex because the response is a result of executing opcodes in the vm. The only way to do so is to reproduce it and execute the same code. That's why a call proof needs to provide all data used within the call. This means:

- All referred accounts including the code (if it is a contract), storageHash, nonce and balance.
- All storage keys that are used (this can be found by tracing the transaction and collecting data based on the `SLOAD`-opcode).
- All blockdata, which are referred at (besides the current one, also the `BLOCKHASH`-opcodes are referring to former blocks). 

For verifying, you need to follow these steps:

1. Serialize all used blockheaders and compare the blockhash with the signed hashes. (See [BlockProof](#blockproof))

2. Verify all used accounts and their storage as showed in [Account Proof](#account-proof).

3. Create a new [VM](https://github.com/ethereumjs/ethereumjs-vm) with a MerkleTree as state and fill in all used value in the state:


```js 
  // create new state for a vm
  const state = new Trie()
  const vm = new VM({ state })

  // fill in values
  for (const adr of Object.keys(accounts)) {
    const ac = accounts[adr]

    // create an account-object
    const account = new Account([ac.nonce, ac.balance, ac.stateRoot, ac.codeHash])

    // if we have a code, we will set the code
    if (ac.code) account.setCode( state, bytes( ac.code ))

    // set all storage-values
    for (const s of ac.storageProof)
      account.setStorage( state, bytes32( s.key ), rlp.encode( bytes32( s.value )))

    // set the account data
    state.put( address( adr ), account.serialize())
  }

  // add listener on each step to make sure it uses only values found in the proof
  vm.on('step', ev => {
     if (ev.opcode.name === 'SLOAD') {
        const contract = toHex( ev.address ) // address of the current code
        const storageKey = bytes32( ev.stack[ev.stack.length - 1] ) // last element on the stack is the key
        if (!getStorageValue(contract, storageKey))
          throw new Error(`incomplete data: missing key ${storageKey}`)
     }
     /// ... check other opcodes as well
  })

  // create a transaction
  const tx = new Transaction(txData)

  // run it
  const result = await vm.runTx({ tx, block: new Block([block, [], []]) })

  // use the return value
  return result.vm.return
```

In the future, we will be using the same approach to verify calls with ewasm.

If the request requires proof (`verification`: `proof`) the node will provide an Call Proof as part of the in3-section of the response. Details on how create the proof can be found in the [CallProof-Chapter](#call-proof).
This proof section contains the following properties:

- `type` : constant : `callProof`
- `block` : the serialized blockheader of the requested block (the last parameter of the request)
- `signatures` : a array of signatures from the signers (if requested) of the above block.
- `accounts`: a Object with the addresses of all accounts required to run the call as keys. This includes also all storage values (SLOAD) including proof used. The DataStructure of the Proof for each account is exactly the same as the result of - [`eth_getProof`](https://eth.wiki/json-rpc/API#eth_getproof). 
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.


Request:
```js
{
    "method": "eth_call",
    "params": [
        {
            "to": "0x2736D225f85740f42D17987100dc8d58e9e16252",
            "data": "0x5cf0f3570000000000000000000000000000000000000000000000000000000000000001"
        },
        "latest"
    ],
    "in3": {
      "verification":"proof"
    }
}
```

Response:
```js
{
    "result": "0x0000000000000000000000000...",
    "in3": {
        "proof": {
            "type": "callProof",
            "block": "0xf90215a0c...",
            "signatures": [...],
            "accounts": {
                "0x2736D225f85740f42D17987100dc8d58e9e16252": {
                    "accountProof": [
                        "0xf90211a095...",
                        "0xf90211a010...",
                        "0xf90211a062...",
                        "0xf90211a091...",
                        "0xf90211a03a...",
                        "0xf901f1a0d1...",
                        "0xf8b18080808..."
                    ],
                    "address": "0x2736d225f85740f42d17987100dc8d58e9e16252",
                    "balance": "0x4fffb",
                    "codeHash": "0x2b8bdc59ce78fd8c248da7b5f82709e04f2149c39e899c4cdf4587063da8dc69",
                    "nonce": "0x1",
                    "storageHash": "0xbf904e79d4ebf851b2380d81aab081334d79e231295ae1b87f2dd600558f126e",
                    "storageProof": [
                        {
                            "key": "0x0",
                            "proof": [
                                "0xf901f1a0db74...",
                                "0xf87180808080...",
                                "0xe2a0200decd9....05"
                            ],
                            "value": "0x5"
                        },
                        {
                            "key": "0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e569",
                            "proof": [
                                "0xf901f1a0db74...",
                                "0xf891a0795a99...",
                                "0xe2a020ab8540...43"
                            ],
                            "value": "0x43"
                        },
                        {
                            "key": "0xaaab8540682e3a537d17674663ea013e92c83fdd69958f314b4521edb3b76f1a",
                            "proof": [
                                "0xf901f1a0db747...",
                                "0xf891808080808...",
                                "0xf843a0207bd5ee..."
                            ],
                            "value": "0x68747470733a2f2f696e332e736c6f636b2e69742f6d61696e6e65742f6e642d"
                        }
                    ]
                }
            }
        },
        "currentBlock": 8040612,
        "lastNodeList": 6619795
    }
}
```



### eth_accounts
### eth_sign
### eth_sendTransaction

See JSON-RPC-Spec 
- [eth_accounts](https://eth.wiki/json-rpc/API#eth_accounts) - returns the unlocked accounts.
- [eth_sign](https://eth.wiki/json-rpc/API#eth_sign) - signs data with an unlocked account.
- [eth_sendTransaction](https://eth.wiki/json-rpc/API#eth_sendTransaction) - signs and sends a transaction.

Signing is **not supported** since the nodes are serving a public rpc-enpoint. These methods will return a error. The client may still support those methods, but handle those requests internally.

### eth_sendRawTransaction

See JSON-RPC-Spec 
- [eth_sendRawTransaction](https://eth.wiki/json-rpc/API#eth_sendRawTransaction) - sends a prviously signed transaction.

This Method does not require any proof. (even if requested). Clients must at least verify the returned transactionHash by hashing the rawTransaction data. To know whether the transaction was actually broadcasted and mined, the client needs to run a second request `eth_getTransactionByHash` which should contain the blocknumber as soon as this is mined.

[registerNode]:../html/api-solidity.html#registernode
[registerNodeFor]:../html/api-solidity.html#id2
[supportedToken]:../html/api-solidity.html#supportedtoken
[minDeposit]:../html/api-solidity.html#mindeposit
[maxDepositFirstYear]:../html/api-solidity.html#maxdepositfirstyear
[unregisteringNode]:../html/api-solidity.html#id4
[convict]:../html/api-solidity.html#convict
[revealConvict]:../html/api-solidity.html#revealconvict
[returnDeposit]:../html/api-solidity.html#returndeposit
[snapshot]:../html/api-solidity.html#snapshot
[saveBlockNumber]:../html/api-solidity.html#saveblocknumber
[recreateBlockheaders]:../html/api-solidity.html#recreateblockheaders

## ipfs

A Node supporting IPFS must support these 2 RPC-Methods for uploading and downloading IPFS-Content. The node itself will run a ipfs-client to handle them.

Fetching ipfs-content can be easily verified by creating the ipfs-hash based on the received data and comparing it to the requested ipfs-hash. Since there is no chance of manipulating the data, there is also no need to put a deposit or convict a node. That's why the registry-contract allows a zero-deposit fot ipfs-nodes.


### ipfs_get

Fetches the data for a requested ipfs-hash. If the node is not able to resolve the hash or find the data a error should be reported.

No proof or verification needed on the server side.

Parameters:

1. `ipfshash`: string - the ipfs multi hash
2. `encoding`: the encoding used for the response. ( `hex` , `base64` or `utf8`)

Returns:

the content matching the requested hash.

Request:

```js
{
    "method":"ipfs_get",
    "params":[
        "QmSepGsypERjq71BSm4Cjq7j8tyAUnCw6ZDTeNdE8RUssD",
        "utf8"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": "I love Incubed",
}
```


### ipfs_put

Stores ipfs-content to the ipfs network.
Important! As a client there is no garuantee that a node made this content available. ( just like `eth_sendRawTransaction` will only broadcast it). Even if the node stores the content there is no gurantee it will do it forever. 


Parameters:

1. `data`: string - the content encoded with the specified encoding.
2. `encoding`: the encoding used for the response. ( `hex` , `base64` or `utf8`)

Returns:

 the ipfs multi hash

Request:

```js
{
    "method":"ipfs_put",
    "params":[
        "I love Incubed",
        "utf8"
    ]
}
```

Response:

```js
{
  "id": 1,
  "result": "QmSepGsypERjq71BSm4Cjq7j8tyAUnCw6ZDTeNdE8RUssD",
}
```




## btc

For bitcoin incubed follows the specification as defined in [https://bitcoincore.org/en/doc/0.18.0/](https://bitcoincore.org/en/doc/0.18.0/).
Internally the in3-server will add proofs as part of the responses. The proof data differs between the methods. You will read which proof data will be provided and how the data can be used to prove the result for each method.

Proofs will add a special `in3`-section to the response containing a `proof`- object. This object will contain parts of or all of the following properties:

*  **block**
*  **final**
*  **txIndex**
*  **merkleProof**
*  **cbtx**
*  **cbtxMerkleProof**



### btc_getblockheader

Returns data of block header for given block hash. The returned level of details depends on the argument verbosity.


Parameters:

1. `hash`             : (string, required) The block hash
2. `verbosity`        : (number or boolean, optional, default=1) 0 or false for the hex-encoded data, 1 or true for a json object
3. `in3.finality`     : (number, required) defines the amount of finality headers
4. `in3.verification` : (string, required) defines the kind of proof the client is asking for (must be `never` or `proof`)


Returns:


- verbose `0` or `false`: a hex string with 80 bytes representing the blockheader
- verbose `1` or `true`: an object representing the blockheader:

    - `hash`: hex - the block hash (same as provided)
    - `confirmations`: number -  The number of confirmations, or -1 if the block is not on the main chain
    - `height`: number : The block height or index
    - `version`: number - The block version
    - `versionHex`: hex - The block version formatted in hexadecimal
    - `merkleroot`: hex - The merkle root ( 32 bytes )
    - `time`: number - The block time in seconds since epoch (Jan 1 1970 GMT)
    - `mediantime`: number - The median block time in seconds since epoch (Jan 1 1970 GMT)
    - `nonce`: number -  The nonce
    - `bits`: hex - The bits ( 4 bytes as hex) representing the target
    - `difficulty`: number - The difficulty
    - `chainwork`: hex -  Expected number of hashes required to produce the current chain (in hex)
    - `nTx`: number - The number of transactions in the block.
    - `previousblockhash`: hex - The hash of the previous block
    - `nextblockhash`: hex - The hash of the next block



The `proof`-object contains the following properties:

- `final`: hex - the finality headers, which are hexcoded bytes of the following headers (80 bytes each) concatenated, the number depends on the requested finality (`finality`-property in the `in3`-section of the request)
- `cbtx`:  hex - the serialized coinbase transaction of the block (this is needed to get the verified block number)
- `cbtxMerkleProof`: hex - the merkle proof of the coinbase transaction, proofing the correctness of the cbtx.

The finality headers from the `final`-field will be used to perform a [finality proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#finality-proof). To verify the block number we are going to perform a [block number proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#block-number-proof) using the coinbase transaction (`cbtx`-field) and the [merkle proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#transaction-proof-merkle-proof) for the coinbase transaction (`cbtxMerkleProof`-field).

**Example**

Request:

```js
{
    "jsonrpc": "2.0",
    "id":1,
    "method": "getblockheader",
    "params": ["000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220", true],
    "in3":{
        "finality":8,
        "verification":"proof"
    }
}
```


Response:

```js
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": {
        "hash": "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220",
        "confirmations": 8268,
        "height": 624958,
        "version": 536928256,
        "versionHex": "2000e000",
        "merkleroot": "d786a334ea8c65f39272d5b9be505ac3170f3904842bd52525538a9377b359cb",
        "time": 1586333924,
        "mediantime": 1586332639,
        "nonce": 1985217615,
        "bits": "17143b41",
        "difficulty": 13912524048945.91,
        "chainwork": "00000000000000000000000000000000000000000e4c88b66c5ee78deff0d494",
        "nTx": 33,
        "previousblockhash": "00000000000000000013cba040837778744ce66961cfcf2e7c34bb3d194c7f49",
        "nextblockhash": "0000000000000000000c799dc0e36302db7fbb471711f140dc308508ef19e343"
    },
    "in3": {
        "proof": {
            "final": "0x00e0ff2720723034053c305058beb92ed010...276470",
            "cbtx": "0x0100000000010100000000000000000000000...39da2fc",
            "cbtxMerkleProof": "0x6a8077bb4ce76b71d7742ddd368770279a64667b...52e688"
        }
    }
}
```


### btc_getblock

Returns data of block for given block hash. The returned level of details depends on the argument verbosity.


Parameters:

1. `blockhash`          : (string, required) The block hash
2. `verbosity`          : (number or boolean, optional, default=true) 0 or false for hex-encoded data, 1 or true for a json object, and 2 for json object **with** transaction data
3. `in3.finality`       : (number, required) defines the amount of finality headers
4. `in3.verification`   : (string, required) defines the kind of proof the client is asking for (must be `never` or `proof`)

Returns

- verbose `0` or `false` : a string that is serialized, hex-encoded data for block hash
- verbose `1` or `true`: an object representing the block:

    - `hash`: hex - the block hash (same as provided)
    - `confirmations` : number -  The number of confirmations, or -1 if the block is not on the main chain
    - `size`:
    - `strippedsize`: 
    - `weight`: 
    - `height`: number - The block height or index
    - `version`: number - The block version
    - `versionHex`: hex - The block version formatted in hexadecimal
    - `merkleroot`: hex - The merkle root ( 32 bytes )
    - `tx`: array of string - The transaction ids
    - `time`: number - The block time in seconds since epoch (Jan 1 1970 GMT)
    - `mediantime`: number - The median block time in seconds since epoch (Jan 1 1970 GMT)
    - `nonce`: number -  The nonce
    - `bits`: hex - The bits ( 4 bytes as hex) representing the target
    - `difficulty`: number - The difficulty
    - `chainwork`: hex -  Expected number of hashes required to produce the current chain (in hex)
    - `nTx`: number - The number of transactions in the block.
    - `previousblockhash`: hex - The hash of the previous block
    - `nextblockhash`: hex - The hash of the next block

- verbose `2`: an object representing the block with information about each transaction:

    - `...`: same output as `verbosity`=`1`
    - `tx`: array of objects - The transactions in the format of the `getrawtransaction` RPC. `tx` result is different from `verbosity`=`1`
    - `...`: same output as `verbosity`=`1`


The `proof`-object contains the following properties:

- `final`: hex - the finality headers, which are hexcoded bytes of the following headers (80 bytes each) concatenated, the number depends on the requested finality (`finality`-property in the `in3`-section of the request)
- `cbtx`:  hex - the serialized coinbase transaction of the block (this is needed to get the verified block number)
- `cbtxMerkleProof`: hex - the merkle proof of the coinbase transaction, proofing the correctness of the cbtx.

The finality headers from the `final`-field will be used to perform a [finality proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#finality-proof). To verify the block number we are going to perform a [block number proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#block-number-proof) using the coinbase transaction (`cbtx`-field) and the [merkle proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#transaction-proof-merkle-proof) for the coinbase transaction (`cbtxMerkleProof`-field).

**Example**

Request:

```js
{
    "jsonrpc": "2.0",
    "id":1,
    "method": "getblock",
    "params":  ["00000000000000000000140a7289f3aada855dfd23b0bb13bb5502b0ca60cdd7", true],
    "in3":{
        "finality":8,
        "verification":"proof"
    }
}
```


Response:

```js
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": {
        "hash": "00000000000000000000140a7289f3aada855dfd23b0bb13bb5502b0ca60cdd7",
        "confirmations": 8226,
        "strippedsize": 914732,
        "size": 1249337,
        "weight": 3993533,
        "height": 625000,
        "version": 1073733632,
        "versionHex": "3fffe000",
        "merkleroot": "4d51591497f1d646070f9f9fdeb50dc338e2a8bb9a5cb721c55f452938165ff8",
        "tx": [
            "d79ffc80e07fe9e0083319600c59d47afe69995b1357be6e5dba035675780290",
            ...
            "6456819bfa019ba30788620153ea9a361083cb888b3662e2ff39c0f7adf16919"
        ],
        "time": 1586364107,
        "mediantime": 1586361287,
        "nonce": 3963275925,
        "bits": "171320bc",
        "difficulty": 14715214060656.53,
        "chainwork": "00000000000000000000000000000000000000000e4eba1824303796d776922b",
        "nTx": 2626,
        "previousblockhash": "000000000000000000068fb1ddc43ca83bc4bfb23444f7236992cfc565d40e08",
        "nextblockhash": "00000000000000000010b3d94671593da669b25fecf7005de38dc2b2fa208dc7"
    },
    "in3": {
        "proof": {
            "final": "0x00e00020d7cd60cab00255bb13bbb023fd5d85daaa...bbd60f",
            "cbtx": "0x0100000000010100000000000000000000000000000000...4ddd5c",
            "cbtxMerkleProof": "0xa22e7468d9bf239167ff6f97d066818b4a5278d29fc13dbcbd5...4b2f3a"
        }
    }
}
            
```


### btc_getrawtransaction

Returns the raw transaction data. The returned level of details depends on the argument verbosity.


Parameters:

1. `txid`            : (string, required) The transaction id
2. `verbosity`       : (number or boolean, optional, default=1) 0 or false for the hex-encoded data for `txid`, 1 or true for a json object with information about `txid`
3. `blockhash`       : (string, optional) The block in which to look for the transaction
4. `in3.finality`    : (number, required) defines the amount of finality headers
5. `in3.verification`: (string, required) defines the kind of proof the client is asking for (must be `never` or `proof`)

Returns:

- verbose `0` or `false`: a string that is serialized, hex-encoded data for `txid`
- verbose `1` or `false`: an object representing the transaction:

    - `in_active_chain`: boolean - Whether specified block is in the active chain or not (only present with explicit "blockhash" argument)
    - `hex`: string - The serialized, hex-encoded data for `txid`
    - `txid`: string - The transaction id (same as provided)
    - `hash`: string - The transaction hash (differs from txid for witness transactions)
    - `size`: number - The serialized transaction size
    - `vsize`: number - The virtual transaction size (differs from size for witness transactions)
    - `weight`: number - The transaction's weight (between `vsize`\*4-3 and `vsize`\*4)
    - `version`: number - The version
    - `locktime`: number - The lock time
    - `vin`: array of json objects
        - `txid`: number - The transaction id
        - `vout`: number
        - `scriptSig`: json objectt - The script
            - `asm`: string - asm
            - `hex`: string - hex
        - `sequence`: number - The script sequence number
        - `txinwitness`: array of string - hex-encoded witness data (if any)
    - `vout`: array of json objects
        - `value`: number - The value in BTC
        - `n`: number - index
        - `scriptPubKey`: json object
            - `asm`: string - asm
            - `hex`: string - hex
            - `reqSigs`: number - The required sigs 
            - `type`: string - The type, eg 'pubkeyhash' 
            - `addresses`: json array of string
                - `address`: string - bitcoin address
    - `blockhash`: string - the block hash
    - `confirmations`: number - The confirmations
    - `blocktime`: number - The block time in seconds since epoch (Jan 1 1970 GMT)
    - `time`: number - Same as "blocktime"

The `proof`-object contains the following properties:

- `block`: hex - a hex string with 80 bytes representing the blockheader
- `final`: hex - the finality headers, which are hexcoded bytes of the following headers (80 bytes each) concatenated, the number depends on the requested finality (`finality`-property in the `in3`-section of the request)
- `txIndex`: number - index of the transaction (`txIndex`=`0` for coinbase transaction, necessary to create/verify the merkle proof)
- `merkleProof`: hex - the merkle proof of the requested transaction, proving the correctness of the transaction
- `cbtx`:  hex - the serialized coinbase transaction of the block (this is needed to get the verified block number)
- `cbtxMerkleProof`: hex - the merkle proof of the coinbase transaction, proving the correctness of the `cbtx`


The block header from the `block`-field and the finality headers from the `final`-field will be used to perform a [finality proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#finality-proof). By doing a [merkle proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#transaction-proof-merkle-proof) using the `txIndex`-field and the `merkleProof`-field the correctness of the requested transation can be proven. Furthermore we are going to perform a [block number proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#block-number-proof) using the coinbase transaction (`cbtx`-field) and the [merkle proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#transaction-proof-merkle-proof) for the coinbase transaction (`cbtxMerkleProof`-field). 

**Example**

Request:

```js
{
    "jsonrpc": "2.0",
    "id":1,
    "method": "getrawtransaction",
    "params":  ["f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf", 
                true, 
                "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220"],
    "in3":{
        "finality":8,
        "verification":"proof"
    }
}
```


Response:

```js
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": {
        "in_active_chain": true,
        "txid": "f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf",
        "hash": "f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf",
        "version": 1,
        "size": 518,
        "vsize": 518,
        "weight": 2072,
        "locktime": 0,
        "vin": [
            {
                "txid": "0a74f6e5f99bc69af80da9f0d9878ea6afbfb5fbb2d43f1ff899bcdd641a098c",
                "vout": 0,
                "scriptSig": {
                    "asm": "30440220481f2b3a49b202e26c73ac1b7bce022e4a74aff08473228cc...254874",
                    "hex": "4730440220481f2b3a49b202e26c73ac1b7bce022e4a74aff08473228...254874"
                },
                "sequence": 4294967295
            },
            {
                "txid": "869c5e82d4dfc3139c8a153d2ee126e30a467cf791718e6ea64120e5b19e5044",
                "vout": 0,
                "scriptSig": {
                    "asm": "3045022100ae5bd019a63aed404b743c9ebcc77fbaa657e481f745e4...f3255d",
                    "hex": "483045022100ae5bd019a63aed404b743c9ebcc77fbaa657e481f745...f3255d"
                },
                "sequence": 4294967295
            },
            {
                "txid": "8a03d29a1b8ae408c94a2ae15bef8329bc3d6b04c063d36b2e8c997273fa8eff",
                "vout": 1,
                "scriptSig": {
                    "asm": "304402200bf7c5c7caec478bf6d7e9c5127c71505034302056d1284...0045da",
                    "hex": "47304402200bf7c5c7caec478bf6d7e9c5127c71505034302056d12...0045da"
                },
                "sequence": 4294967295
            }
        ],
        "vout": [
            {
                "value": 0.00017571,
                "n": 0,
                "scriptPubKey": {
                    "asm": "OP_DUP OP_HASH160 53196749b85367db9443ef9a5aec25cf0bdceedf OP_EQUALVERIFY OP_CHECKSIG",
                    "hex": "76a91453196749b85367db9443ef9a5aec25cf0bdceedf88ac",
                    "reqSigs": 1,
                    "type": "pubkeyhash",
                    "addresses": [
                        "18aPWzBTq1nzs9o86oC9m3BQbxZWmV82UU"
                    ]
                }
            },
            {
                "value": 0.00915732,
                "n": 1,
                "scriptPubKey": {
                    "asm": "OP_HASH160 8bb2b4b848d0b6336cc64ea57ae989630f447cba OP_EQUAL",
                    "hex": "a9148bb2b4b848d0b6336cc64ea57ae989630f447cba87",
                    "reqSigs": 1,
                    "type": "scripthash",
                    "addresses": [
                        "3ERfvuzAYPPpACivh1JnwYbBdrAjupTzbw"
                    ]
                }
            }
        ],
        "hex": "01000000038c091a64ddbc99f81f3fd4b2fbb5bfafa68e8...000000"
        "blockhash": "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220",
        "confirmations": 15307,
        "time": 1586333924,
        "blocktime": 1586333924
    },
    "in3": {
        "proof": {
            "block": "0x00e00020497f4c193dbb347c2ecfcf6169e64c747877...045476",
            "final": "0x00e0ff2720723034053c305058beb92ed0101b2294cd...276470",
            "txIndex": 7,
            "merkleProof": "0x348d4bb04943400a80f162c4ef64b746bc4af0...52e688",
            "cbtx": "0x010000000001010000000000000000000000000000000...9da2fc",
            "cbtxMerkleProof": "0x6a8077bb4ce76b71d7742ddd368770279a...52e688"
        }
    }
}
```


### btc_getblockcount

Returns the number of blocks in the longest blockchain.


Parameters:

1. `in3.finality`     : (number, required) defines the amount of finality headers
2. `in3.verification` : (string, required) defines the kind of proof the client is asking for (must be `never` or `proof`)


Returns: Since we can't prove the finality of the latest block we consider the `current block count` - `amount of finality` (set in `in3.finality`-field) as the latest block. The number of this block will be returned. Setting `in3.finality`=`0` will return the actual current block count.

The `proof`-object contains the following properties:

- `block`: hex - a hex string with 80 bytes representing the blockheader
- `final`: hex - the finality headers, which are hexcoded bytes of the following headers (80 bytes each) concatenated, the number depends on the requested finality (`finality`-property in the `in3`-section of the request)
- `cbtx`:  hex - the serialized coinbase transaction of the block (this is needed to get the verified block number)
- `cbtxMerkleProof`: hex - the merkle proof of the coinbase transaction, proving the correctness of the `cbtx`


The server is not able to prove the finality for the latest block (obviously there are no finality headers available yet). Instead the server will fetch the number of the latest block and subtracts the amount of finality headers (set in `in3.finality`-field) and returns the result to the client (the result is considered as the latest block number). By doing so the server is able to provide finality headers. \
The block header from the `block`-field and the finality headers from the `final`-field will be used to perform a [finality proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#finality-proof). Having a verified block header (and therefore a verified merkle root) enables the possibility of a [block number proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#block-number-proof) using the coinbase transaction (`cbtx`-field) and the [merkle proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#transaction-proof-merkle-proof) for the coinbase transaction (`cbtxMerkleProof`-field).

The client can set `in3.finality` equal to `0` to get the actual latest block number. **Caution**: This block is not final and could no longer be part of the blockchain later on due to the possibility of a fork. Additionally, there may already be a newer block that the server does not yet know about due to latency in the network.

**Example**

The actual latest block is block `#640395` and `in3.finality` is set to `8`. The server is going to calculate `640395` - `8` and returns `640387` as the latest block number to the client. The headers of block `640388`..`640395` will be returned as finality headers.

Request:

```js
{
    "jsonrpc": "2.0",
    "id":1,
    "method": "getblockcount",
    "params": [],
    "in3":{
        "finality":8,
        "verification":"proof"
    }
}
```


Response:

```js
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": 640387,
    "in3": {
        "proof": {
            "block": "0x0000e020bd3eecbd741522e1aa78cd7b375744590502939aef9b...9c8b18",
            "final": "0x00008020f61dfcc47a6daed717b12221855196dee02d844ebb9c...774f4c",
            "cbtx": "0x02000000000101000000000000000000000000000000000000000...000000",
            "cbtxMerkleProof": "0xa3d607b274770911e53f06dbdb76440580ff968239...0ba297"
        }
    }
}
```


### btc_getbestblockhash

Returns the hash of the best (tip) block in the longest blockchain.

Parameters:

1. `in3.finality`      : (number, required) defines the amount of finality headers
2. `in3.verification`  : (string, required) defines the kind of proof the client is asking for (must be `never` or `proof`)


Returns: Since we can't prove the finality of the latest block we consider the `current block count` - `amount of finality` (set in `in3.finality`-field) as the latest block. The hash of this block will be returned. Setting `in3.finality`=`0` will return will return the hash of the actual latest block.

The `proof`-object contains the following properties:

- `block`: hex - a hex string with 80 bytes representing the blockheader
- `final`: hex - the finality headers, which are hexcoded bytes of the following headers (80 bytes each) concatenated, the number depends on the requested finality (`finality`-property in the `in3`-section of the request)
- `cbtx`:  hex - the serialized coinbase transaction of the block (this is needed to get the verified block number)
- `cbtxMerkleProof`: hex - the merkle proof of the coinbase transaction, proving the correctness of the `cbtx`

The server is not able to prove the finality for the latest block (obviously there are no finality headers available yet). Instead the server will fetch the number of the latest block and subtracts the amount of finality headers (set in `in3.finality`-field) and returns the hash of this block to the client (the result is considered as the latest block hash). By doing so the server is able to provide finality headers. \
The block header from the `block`-field and the finality headers from the `final`-field will be used to perform a [finality proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#finality-proof). Having a verified block header (and therefore a verified merkle root) enables the possibility of a [block number proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#block-number-proof) using the coinbase transaction (`cbtx`-field) and the [merkle proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#transaction-proof-merkle-proof) for the coinbase transaction (`cbtxMerkleProof`-field).

The client can set `in3.finality` equal to `0` to get the actual latest block hash. **Caution**: This block is not final and could no longer be part of the blockchain later on due to the possibility of a fork. Additionally, there may already be a newer block that the server does not yet know about due to latency in the network.

**Example**

The actual latest block is block `#640395` and `in3.finality` is set to `8`. The server is going to calculate `640395` - `8` and returns the hash of block `#640387` to the client. The headers of block `640388`..`640395` will be returned as finality headers.


Request:

```js
{
    "jsonrpc": "2.0",
    "id":1,
    "method": "getbestblockhash",
    "params": [],
    "in3":{
        "finality":8,
        "verification":"proof"
    }
}
```

Response:

```js
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": "000000000000000000039cbb4e842de0de9651852122b117d7ae6d7ac4fc1df6",
    "in3": {
        "proof": {
           "block": "0x0000e020bd3eecbd741522e1aa78cd7b375744590502939aef9b...9c8b18",
            "final": "0x00008020f61dfcc47a6daed717b12221855196dee02d844ebb9...774f4c",
            "cbtx": "0x0200000000010100000000000000000000000000000000000000...000000",
            "cbtxMerkleProof": "0xa3d607b274770911e53f06dbdb76440580ff96823...0ba297"
        }
    }
}
```


### btc_getdifficulty

Returns the proof-of-work difficulty as a multiple of the minimum difficulty.


Parameters:

1. `blocknumber`       : (string or number, optional) 
Can be the number of a certain block to get its difficulty. To get the difficulty of the latest block use `latest`, `earliest`, `pending` or leave `params` empty (Hint: Latest block always means `actual latest block` minus `in3.finality`)
2. `in3.finality`      : (number, required) defines the amount of finality headers
3. `in3.verification`  : (string, required) defines the kind of proof the client is asking for (must be `never` or `proof`)


Returns:
- `blocknumber` is a certain number: the difficulty of this block
- `blocknumber` is `latest`, `earliest`, `pending` or empty: the difficulty of the latest block (`actual latest block` minus `in3.finality`)

The `proof`-object contains the following properties:

- `block`: hex - a hex string with 80 bytes representing the blockheader
- `final`: hex - the finality headers, which are hexcoded bytes of the following headers (80 bytes each) concatenated, the number depends on the requested finality (`finality`-property in the `in3`-section of the request)
- `cbtx`:  hex - the serialized coinbase transaction of the block (this is needed to get the verified block number)
- `cbtxMerkleProof`: hex - the merkle proof of the coinbase transaction, proving the correctness of the `cbtx`

In case the client requests the diffictuly of a certain block (`blocknumber` is a certain number) the `block`-field will contain the block header of this block and the `final`-field the corresponding finality headers. In case the client requests the difficulty of the latest block the server is not able to prove the finality for this block (obviously there are no finality headers available yet). The server considers the latest block minus `in3.finality` as the latest block and returns its difficulty. For both cases the block header from the `block`-field and the finality headers from the `final`-field will be used to perform a [finality proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#finality-proof). Having a verified block header (and therefore a verified merkle root) enables the possibility of a [block number proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#block-number-proof) using the coinbase transaction (`cbtx`-field) and the [merkle proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#transaction-proof-merkle-proof) for the coinbase transaction (`cbtxMerkleProof`-field).

The result itself (the difficulty) can be verified in two ways:
- by converting the difficulty into a target and check whether the block hash is lower than the target (since we proved the finality we consider the block hash as verified)
- by converting the difficulty and the bits (part of the block header) into a target and check if both targets are similar (they will not be equal since the target of the bits is not getting saved with full precision)


**Example**

Request:

```js
{
    "jsonrpc": "2.0",
    "id":1,
    "method": "getdifficulty",
    "params": [631910],
    "in3":{
        "finality":8,
        "verification":"proof"
    }
}
```

Response:

```js
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": 15138043247082.88,
    "in3": {
        "proof": {
            "block": "0x00000020aa7531df9e14536f3c92fb9479cfc4025...eeb15d",
            "final": "0x0000ff3fdfdb13f86b9bce93f6c111feccecf4eb5...3c5846",
            "cbtx": "0x010000000001010000000000000000000000000000...000000",
            "cbtxMerkleProof": "0x48de085910879b0f201b320a7dbcb65...b02414"
        }
    }
}
```


### btc_in3_proofTarget

Whenever the client is not able to trust the changes of the target (which is the case if a block can't be found in the verified target cache *and* the value of the target changed more than the client's limit `max_diff`) he will call this method. It will return additional proof data to verify the changes of the target on the side of the client.

Parameters:

1. `target_dap`        : (string or number, required) the number of the difficulty adjustment period (dap) we are looking for
2. `verified_dap`      : (string or number, required) the number of the closest already verified dap
3. `max_diff`          : (string or number, required) the maximum target difference between 2 verified daps
4. `max_dap`           : (string or number, required) the maximum amount of daps between 2 verified daps
5. `limit`             : (string or number, optional) the maximum amount of daps to return (`0` = no limit) - this is important for embedded devices since returning all daps might be too much for limited memory
6. `in3.finality`      : (number, required) defines the amount of finality headers
7. `in3.verification`  : (string, required) defines the kind of proof the client is asking for (must be `never` or `proof`)

Hints:

- difference between `target_dap` and `verified_dap` should be greater than `1`
- `target_dap` and `verified_dap` have to be greater than `0`
- `limit` will be set to `40` internaly when the parameter is equal to `0` or greater than `40`
- `max_dap` can't be equal to `0`
- `max_diff` equal to `0` means no tolerance regarding the change of the target - the path will contain every dap between `target_dap` and `verified_dap` (under consideration of `limit`)
- total possible amount of finality headers (`in3.finaliy` \* `limit`) can't be greater than `1000`
- changes of a target will always be accepted if it decreased from one dap to another (i.e. difficulty to mine a block increased)
- in case a dap that we want to verify next (i.e. add it to the path) is only 1 dap apart from a verified dap (i.e. `verified_dap` or latest dap of the path) *but* not within the given limit (`max_diff`) it will still be added to the path (since we can't do even smaller steps)

Returns: A path of daps from the `verified_dap` to the `target_dap` which fulfils the conditions of `max_diff`, `max_dap` and `limit`. Each dap of the path is a `dap`-object with corresponding proof data. 


The `dap`-object contains the following properties:

- `dap`: number - the numer of the difficulty adjustment period
- `block`: hex - a hex string with 80 bytes representing the  (always the first block of a dap)
- `final`: hex - the finality headers, which are hexcoded bytes of the following headers (80 bytes each) concatenated, the number depends on the requested finality (`finality`-property in the `in3`-section of the request)
- `cbtx`:  hex - the serialized coinbase transaction of the block (this is needed to get the verified block number)
- `cbtxMerkleProof`: hex - the merkle proof of the coinbase transaction, proving the correctness of the `cbtx`

The goal is to verify the target of the `target_dap`. We will use the daps of the result to verify the target step by step starting with `verified_dap`. The block header from the `block`-field and the finality headers from the `final`-field will be used to perform a [finality proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#finality-proof). This allows us to consider the target of the block header as verified. Therefore we have a verified target for this `dap`. Having a verified block header (and therefore a verified merkle root) enables the possibility of a [block number proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#block-number-proof) using the coinbase transaction (`cbtx`-field) and the [merkle proof](https://git.slock.it/in3/doc/-/blob/19-documentation-verification-process/docs/bitcoin.md#transaction-proof-merkle-proof) for the coinbase transaction (`cbtxMerkleProof`-field). This proof is needed to verify the dap number (`dap`). Having a verified dap number allows us to verify the mapping between the target and the dap number.

**Example**

Request:

```js
{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "in3_proofTarget",
    "params": [230,200,5,5,15],
    "in3":{
                "finality" : 8,
                "verification":"proof"
        }
}
```

Response:

```js
{
    "id": 1,
    "jsonrpc": "2.0",
    "result": [
        {
            "dap": 205,
            "block": "0x04000000e62ef28cb9793f4f9cd2a67a58c1e7b593129b9b...0ab284",
            "final": "0x04000000cc69b68b702321adf4b0c485fdb1f3d6c1ddd140...090a5b",
            "cbtx": "0x01000000...1485ce370573be63d7cc1b9efbad3489eb57c8...000000",
            "cbtxMerkleProof": "0xc72dffc1cb4cbeab960d0d2bdb80012acf7f9c...affcf4"
        },
        {
            "dap": 210,
            "block": "0x0000003021622c26a4e62cafa8e434c7e083f540bccc8392...b374ce",
            "final": "0x00000020858f8e5124cd516f4d5e6a078f7083c12c48e8cd...308c3d",
            "cbtx": "0x01000000...c075061b4b6e434d696e657242332d50314861...000000",
            "cbtxMerkleProof": "0xf2885d0bac15fca7e1644c1162899ecd43d52b...93761d"
        },
        {
            "dap": 215,
            "block": "0x000000202509b3b8e4f98290c7c9551d180eb2a463f0b978...f97b64",
            "final": "0x0000002014c7c0ed7c33c59259b7b508bebfe3974e1c99a5...eb554e",
            "cbtx": "0x01000000...90133cf94b1b1c40fae077a7833c0fe0ccc474...000000",
            "cbtxMerkleProof": "0x628c8d961adb157f800be7cfb03ffa1b53d3ad...ca5a61"
        },
        {
            "dap": 220,
            "block": "0x00000020ff45c783d09706e359dcc76083e15e51839e4ed5...ddfe0e",
            "final": "0x0000002039d2f8a1230dd0bee50034e8c63951ab812c0b89...5670c5",
            "cbtx": "0x01000000...b98e79fb3e4b88aefbc8ce59e82e99293e5b08...000000",
            "cbtxMerkleProof": "0x16adb7aeec2cf254db0bab0f4a5083fb0e0a3f...63a4f4"
        },
        {
            "dap": 225,
            "block": "0x02000020170fad0b6b1ccbdc4401d7b1c8ee868c6977d6ce...1e7f8f",
            "final": "0x0400000092945abbd7b9f0d407fcccbf418e4fc20570040c...a9b240",
            "cbtx": "0x01000000...cf6e8f930acb8f38b588d76cd8c3da3258d5a7...000000",
            "cbtxMerkleProof": "0x25575bcaf3e11970ccf835e88d6f97bedd6b85...bfdf46"
        }
    ],
    "in3": {
        "lastNodeList": 3101668,
        "execTime": 2760,
        "rpcTime": 172,
        "rpcCount": 1,
        "currentBlock": 3101713,
        "version": "2.1.0"
    }
}
```

*Graph to visualize the usage of proofTarget* 
 