# IN3-Protocol

This document describes the communication between a incubed client and a incubed node. This communication is based on requests which use extended [JSON-RPC](https://www.jsonrpc.org/specification)-Format. Especially for ethereum-based requests this means each node also accepts all standard requests as defined at [Ethereum JSON-RPC](https://github.com/ethereum/wiki/wiki/JSON-RPC) , which also includes handling Bulk-requests. 

Each request may add an optional `in3` property defining the verification behavior for incubed.


## Incubed Requests

Requests without a `in3` property will also get a response without `in3`. This allows any incubed node to also act as a raw ethereum json-rpc endpoint. The `in3` property in the request is defined as following:  

*  **chainId** `string<hex>` - the requested [chainId](#chainid). This property is optinal, but should always be specified in case a node may support multiple chains. In this case the default of the node would be used, which may end up in a undefined behavior since the client can not know the default. 

*  **includeCode** `boolean` - applies only for `eth_call`-requests. if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards   

*  **verifiedHashes** `string<bytes32>[]` - if the client sends a array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This allows to client to skip requiring signed blockhashes for blocks already verified.

*  **latestBlock** `integer` - if specified, the blocknumber `latest` will be replaced by blockNumber- specified value. This allows the incubed client to define finality for PoW-Chains, which is important, since the `latest`-block can not considered final and therefore it would be unlikely to find nodes willing to sign a blockhash for such a block.    

*  **useRef** `boolean` - if true binary-data (starting with a 0x) will be refered if occuring again. This decreases the payload especially for recurring data such as merkle proofs. If supported the server ( and client) will keep track of each binary value storing them in a temporary array. If the previously used value is used again the server replaces it with `:<index>` the client then resolves such refs by lookups in the temp array.   

*  **useBinary** `boolean` - if true binary-data will be used. This format is optimzed for embedded devices and reduces the payload to about 30%. For details see [the Binary-spec](#binary-format)

*  **useFullProof** `boolean` - if true all data in the response will be proven, which leads to a higher payload. The result depends on the method called and will be specified there.

*  **finality** `number` - For PoA-Chains it will deliver additional proof to reach finaliy.  if given, the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.   

*  **verification** `string` - defines the kind of proof the client is asking for   
 Must be one of the these values : 
    - `'never`' : no proof will be delivered (default). Also no `in3`-property will be added to the response, but only the raw json-rpc response will be returned 
    - `'proof`' : The proof will be created including blockheader, but without any signed blockhashes
    - `'proofWithSignature`' : The returned proof will also includ signed blockhashes as required in `signatures`

*  **signatures** `string<address>[]` - a list of addresses(as 20bytes in hex) requested to sign the blockhash.    

A Example of an incubed request may look like this:

```json
{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "eth_getTransactionByHash",
    "params": ["0xf84cfb78971ebd940d7e4375b077244e93db2c3f88443bb93c561812cfed055c"],
    "in3": {
        "chainId": "0x1",
        "verification": "proofWithSignature",
        "signatures":["0x784bfa9eb182C3a02DbeB5285e3dBa92d717E07a"]
  }
}
```


## Incubed Responses

Each incubed node responses is based on JSON-RPC, but also adds then `in3` -property. If the request does not contain a `in3`-property or does not require proof, the response must also omit the `in3` property.

If the proof is requested, the `in3`-property is defined with the following properties:

*  **proof** [Proof](#proofs) - the Proof-data, which depends on the requested method. For more details, see the [Proofs](#proofs) section.

*  **lastNodeList** `number` - the blocknumber for the last block updating the nodelist. This blocknumber should be used to indicate changes in the nodelist. If the client has a smaller blocknumber he should update the nodeList.  

*  **lastValidatorChange** `number` - only for PoA-chains. the blocknumber of the last change of the validatorList. If the client has a smaller number he needs to update the validatorlist first. For details see [PoA Validations](#poa-validations)   

*  **currentBlock** `number` - the current blocknumber. This number may be stored in the client in order to run sanity checks for `latest` blocks or `eth_blockNumber`, since they cannot be verified directly.   

An example of such a response would look like this:

```json
{
  "jsonrpc": "2.0",
  "result": {
    "blockHash": "0x2dbbac3abe47a1d0a7843d378fe3b8701ca7892f530fd1d2b13a46b202af4297",
    "blockNumber": "0x79fab6",
    "chainId": "0x1",
    "condition": null,
    "creates": null,
    "from": "0x2c5811cb45ba9387f2e7c227193ad10014960bfc",
    "gas": "0x186a0",
    "gasPrice": "0x4a817c800",
    "hash": "0xf84cfb78971ebd940d7e4375b077244e93db2c3f88443bb93c561812cfed055c",
    "input": "0xa9059cbb000000000000000000000000290648fc6f2cb27a2a81dc35a429090872991b92000000000000000000000000000000000000000000000015af1d78b58c400000",
    "nonce": "0xa8",
    "publicKey": "0x6b30c392dda89d58866bf2c1bedf8229d12c6ae3589d82d0f52ae588838a475aacda64775b7a1b376935d732bb8022630a01c4926e71171eeda938b644d83365",
    "r": "0x4666976b528fc7802edd9330b935c7d48fce0144ce97ade8236da29878c1aa96",
    "raw": "0xf8ab81a88504a817c800830186a094d3ebdaea9aeac98de723f640bce4aa07e2e4419280b844a9059cbb000000000000000000000000290648fc6f2cb27a2a81dc35a429090872991b92000000000000000000000000000000000000000000000015af1d78b58c40000025a04666976b528fc7802edd9330b935c7d48fce0144ce97ade8236da29878c1aa96a05089dca7ecf7b061bec3cca7726aab1fcb4c8beb51517886f91c9b0ca710b09d",
    "s": "0x5089dca7ecf7b061bec3cca7726aab1fcb4c8beb51517886f91c9b0ca710b09d",
    "standardV": "0x0",
    "to": "0xd3ebdaea9aeac98de723f640bce4aa07e2e44192",
    "transactionIndex": "0x3e",
    "v": "0x25",
    "value": "0x0"
  },
  "id": 2,
  "in3": {
    "proof": {
      "type": "transactionProof",
      "block": "0xf90219a03d050deecd980b16cad9752133333ccdface463cc69e784f32dd981e2e751e34a01dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d4934794829bd824b016326a401d083b33d092293333a830a012892951590f62f4b2802f88e8fddc09c951ad2cac23803e07c4f11e01991907a018a21c8413fc7fc29f09d12f75515993ab38858bfa9e5632670cbba3358f0cfaa02fc4436c96ae4d100921c20b5cb601252de68ddde159bc89f3353555eff0ccccb901009034d281f0400b0920d21f7795b09d8c2b9cd48a939ce476aa84f486c68855684c0804a304a444a17c0ca4420e32a3b29a8218802d9fab5112a82b8d60e12203400084c2a236149a4a44905e120540a1478261a55a399229fe046595236900025de213ea6a000612901d6008080a6f773755182105c9100048a40eb458808a0334a2c5927a9308f300962916898c861a888d8d780508061c2bc54c866078216042497a0cd05dfa65948b8dc4144ca64144883c2422a5280848021328d8a8e41602890d122b0110c27bc014193502a7690d40e00f03a879080b0073f1ae4ab0232b93630c068ecb7b4b923de0012566855524a000502c87906480151e81d2b032870709c2784add128379fab6837a3f58837a12f8845d0b4673987070796520e4b883e5bda9e7a59ee4bb99e9b1bc9329ad43a0e21b342112a946b58fa2f50739166c20aed4647d3ad8e37210d451fb8b243870888f95c17c0647e1f9",
      "merkleProof": [
        "0xf90131a00150ff50e29f3df34b89870f183c85a82a73f21722d7e6c787e663159f165010a0b8c56f207a223067c7ae5df7420221327c32f89f36cef8a14c33e5a4e67be9cfa0112091138bbf6bde2e20c88b08d10f8ea08ec298f2daac34d76fc8e248379dc5a0c737a71d34faa7c864930707ac7870b2c7cc28e7d489d21330acfa8deb72d805a075811c4bdef2cc74095e57cacce23debab8ea8e6d8937932678d2fd444367ea9a0e79e4e445e517b7b31ad626acabec77a6e0c846207b91f01ac33e804af096325a07065708e1a9e9b865dbd5e19e521224ae554a5d3064257e5401d7cad900f555aa01a71ef57896ce378fd51bf44a1d0b538d3587d9aecdbf3c6c7f6794bbb0f0fa8a0d720eecae23cd40af5c534b90b00f33b7ec0638b11cc7809058110bf984a02d48080808080808080",
        "0xf90211a0f4a5e4a1197190f910e4a026f50bd6a169716b52be42c99ddb043ad9b4da6117a09ad1def70dd1d991331d013719cca31d35111cf75d3046dffdc9d1897ecfce29a01ada8fa2d6a7f9b44394a0d7fafe8a59810e48596e1258adb57ca51a6a014024a0eeb2d6482d696d623ae7f868aa3463790041c4863f1d47f84d6629f2d5ee88c5a0f1c04c4bc88aa5f24c7e5ac401c5246cf17834e7e68d4b2c9b656a37f510aff1a040446d66c0039c4806ee13da02ebe408abab366332ec2355367ca0dec5aab273a0775b1f53ad22fdcb6fef814d34b910be6a2e6463febb174d4f2064626baf639fa0bb1668055775f8ba59bf071465ffe68db4f916a7eb0ea07126b71d3e30a8fd70a08ad25a05847cdeec5261154c5ae89f03f2a8a813e8804983c677dc0d39e26bfca0a0c6f9e3e55cabbe3a9c0c6713aeb4e70135b9abe21b50bb6e04e6f4a09888d5a011d5422e577e357d26390492378b9328518b263310574b1e0d9e322031485a22a0c2f4f15a1ba6585a87a0dcca7b45dc0bbcd72830df61888d7abf16fef6a4df72a02bf0d1675ebf1c1f2af6793edf748e3184c2ac5522a6640a1b04d3b7bad7e23ca0c80cf2596da4c35f6c5e5348791c64c10d80ccd7668d6ef73a2454f0f11a0f59a03e54112466dbd3791d6e1e281d25470b884c96406e39bd83e8a806cfc8e60219a00e2cc674fa10aefb4dea53ac114e28c6353d30b315d4ba280ab4741920a60ce280",
        "0xf8b020b8adf8ab81a88504a817c800830186a094d3ebdaea9aeac98de723f640bce4aa07e2e4419280b844a9059cbb000000000000000000000000290648fc6f2cb27a2a81dc35a429090872991b92000000000000000000000000000000000000000000000015af1d78b58c40000025a04666976b528fc7802edd9330b935c7d48fce0144ce97ade8236da29878c1aa96a05089dca7ecf7b061bec3cca7726aab1fcb4c8beb51517886f91c9b0ca710b09d"
      ],
      "txIndex": 62,
      "signatures": [
        {
          "blockHash": "0x2dbbac3abe47a1d0a7843d378fe3b8701ca7892f530fd1d2b13a46b202af4297",
          "block": 7994038,
          "r": "0xef73a527ae8d38b595437e6436bd4fa037d50550bf3840ad0cd3c6ca641a951e",
          "s": "0x6a5815db16c12b890347d42c014d19b60e1605d2e8e64b729f89e662f9ce706b",
          "v": 27,
          "msgHash": "0xa8fc6e2564e496efc5fd7db8e70f03fd50af53e092f47c98329c84c96026fdff"
        }
      ]
    },
    "currentBlock": 7994124,
    "lastValidatorChange": 0,
    "lastNodeList": 6619795
  }
}
```

## ChainId

Incubed support multiple chains and a client may even run request to different chains in parallel. While in most cases a chain refers to a specific running blockchain, chainIds may also refer to abstract networks such as ipfs. So then definition of a chain in the context of incubed is simply a distributed data domain offering verifieable api-functions implemented in a in3-node.

Each Chain is identified by a `uint64` identifier written as hex-value. (without leading zeros)
Since incubed started with ethereum, the chainIds for public ethereum-chains are based on the intrinsic chainId of the ethereum-chain. See https://chainid.network .

For each Chain incubed manages a list of nodes as stored in the [server registry](#registry) and a chainspec describing the verification. These chainspecs are hold in the client as they specify the rules how responses may be validated.

## Registry

As Incubed aims for a fully decentralized access to the blockchain, the registry is implemented as a ethereum smart contract. 

This contract serves different purposes. Primary it serves to manage all the incubed nodes, i.e. it manages both the onboarding and also unregistering process. In order to do so, it also has to manage the deposits: reverting when the amount of provided ether is smaller than the current minimum deposit; but also locking and/or sending back deposits after a servers leaves the in3-netwerk.

In addition, the contract is also used to secure the in3-netwerk by providing functions to convict servers that provided a wrongly signed block and also having a function to vote out inactive servers.

### Node structure

Each Incubed node must be registered in the ServerRegistry in order to be known to the network. A node or server is defined as 

*  **url** `string` - the public url of the node, which must accept JSON-RPC Requests.

*  **owner** `address` - the owner of the node with the permission to edit or remove the node.  

*  **signer** `address` - the address used when signing blockhashes. This address must be unique withitn the nodeList.   

*  **timeout** `uint64` - timeout after which the owner is allowed to receive his stored deposit. This information is also important for the client, since a invalid blockhash-signature can only convicted as long as the server is registered. A long timout may give a higher security since the node can not lie and unregister right away.

*  **deposit** `uint256` - the deposit stored for the node, which the node will lose if it signes a wrong blockhash.

*  **props** `uint64` - a bitmask defining the capabilities of the node:

    - `0x01` : **proof** :  the node is able to deliver proof, if not set it may only server pure Ethereum JSON/RPC, thus also simple remote nodes may be registered as incubed nodes.
    - `0x02` : **multichain** : the same rpc endpoint may also accept requests for different chains.
    - `0x04` : **archive** : if set, the node is able to support archive requests returning older states. If not only a pruned node is running.
    - `0x08` : **http** : if set the node will also server requests on standardn http even if the url specifies https. This is relevant for small embedded devices trying to save resources by not having to run the TLS.
    - `0x10` : **binary** : if set, the node accepts request with `binary:true`. This reduces the payload to about 30% for embedded devices.

    More properties will be added in future versions.

*  **unregisterTime** `uint64` - the earliest timestamp when the node can unregister itself by calling `confirmUnregisteringServer`.  This will only be set after the node requests a unregister. For the client nodes with a `unregisterTime` set have a less trust, since he will not be able to convict after this timestamp.

*  **registerTime** `uint64` - the timestamp, when the server was registered.

*  **weight** `uint64` - the number of parallel requests this node may accept. A higher number indicates a stronger node, which will be used withtin the incentivication layer to calculate the score.

The following functions are offered within the registry:


### NodeRegistry functions

//TODO add interface for new contract.

### BlockHashRegistry functions

## Binary Format

Since Incubed is optimized for embedded devices, server may not only support JSON, but a special binary-format. 
You may wonder why we don't want to use any existing binary serialisation for json like cbor or others. The reason is simply, because we do not need to support all features JSON offers. The following features are not supported:
- no escape sequences (this allows to use the string without copying it)
- no float support (at least for now)
- no string litersals starting with `0x` since this is always considered as hexcoded bytes
- no propertyNames within the same object with the same key hash.

Since we are able to accept these restrictions, we can keep the json-parser simple.
This binary-format is highly optimized for small devices and will reduce the payload to about 30%. This is achieved with following optimizations:

* All strings starting with `0x`are interpreted as binary data and stored as such, which reduces the size of the data to 50%.
* Recurring byte-values will use references to previous data, which reduces the payload especially for merkle proofs.
* All propertyNames of JSON-Objects are hashed to a 16bit-value, reducing the size of the data to a signifivant amount. (depending on the propertyName).

  the hash is calculated very easy like this:
  ```c
  static d_key_t key(const char* c) {
    uint16_t val = 0, l = strlen(c);
    for (; l; l--, c++) val ^= *c | val << 7;
    return val;
  }
  ````


```eval_rst
.. note:: A very important limitation is the fact, that property names are stored as 16bit hashes, which decreases the payload, but does not allow to restore the full json without knowing all property names! 
```

The binary format is based on JSON-structure, but uses a RLP-encoding aproach. Each node or value is represented by a these 4 values:

*  **key** `uint16_t` - the key hash of the property. This value will only passed before the property node, if the structure is a property of a JSON-Object. 
*  **type** `d_type_t` - 3 bit : defining the type of the element.
*  **len** `uint32_t` - 5 bit : the length of the data (for bytes/string/array/object). For (boolean or integer) the length will specify the value. 
*  **data** `bytes_t` - the bytes or value of the node (only for strings or bytes)


```eval_rst
.. graphviz::

    digraph g{
      rankdir=LR;

      node[fontname="Helvetica",   shape=record, color=lightblue ]
      propHash[label="key|16 bit", style=dashed]
      type[label="type|{type (3bit) | len (5bit)}"]
      len2[label="len ext",  style=dashed]
      data[label="data",  style=dashed]
      propHash -> type -> len2 -> data
    }


```


The serialization depends on the type, which is defined in the first 3 bits of the first byte of the element:

```c
d_type_t type = *val >> 5;     // first 3 bits define the type
uint8_t  len  = *val & 0x1F;   // the other 5 bits  (0-31) the length
```

the `len` depends on ther size of the data. so the last 5 bit of the first bytes are interpreted as following:

* `0x00` - `0x1c` : the length is taken as is from the 5 bits.
* `0x1d` - `0x1f` : the length is taken by reading the value of the next `len - 0x1c` bytes.  

After the type-byte and optional length bytes the 2 bytes representing the property hash is added, but only if the elemtent is a property of a JSON-object.    

Depending on these type the length will be used to read the next bytes:

* `0x0` : **binary data** - This would be a value or property with binary data. The `len` will be used to read the number of bytes as binary data.
* `0x1` : **string data** - This would be a value or property with string data. The `len` will be used to read the number of bytes (+1) as string. The string will always be null-terminated, since it will allow small devices to use the data directly instead copying memory in RAM.
* `0x2` : **array** - represents a array node, where the `len` represents the number of elements in the array. The array elements will be added right after the array-node.
* `0x3` : **object** - a JSON-object with `len` properties comming next. In this case the properties following this element will have a leading `key` specified.
* `0x4` : **boolean** - boolean value where `len` must be either `0x1`= `true` or `0x0` = `false`. if `len > 1` this element is a copy of a previous node and may reference the same data. 
* `0x5` : **integer** - a integer-value with max 29 bit (since the 3 bits are used for the type). if the value is higher than `0x20000000`, it will be stored as binary data.
* `0x6` : **null** - represents a null-value. if this value has a `len`> 0 it will indicate the beginning of data, where `len` will be used to specify the number of elements to follow. This is optional, but helps small devices to allocate the right amount of memory.


## Communication

Incubed requests follow a simple request/response schema allowing even devices with a small bandwith to retrieve all required data with one request. But there are exceptions when a additional need to fetched.

These are:

1. **Changes in the NodeRegistry**    

    Changes in the NodeRegistry are based on one of the following event : 
    
    - `LogNodeRegistered`
    - `LogNodeRemoved`
    - `LogNodeChanged`

    The server needs to watch for events from the `NodeRegistry` contract, and update the nodelist when needed.
    
    Changes are detected by the client by comparing the blocknumber of the latest change with the last known blocknumber. Since each response will include the `lastNodeList` a client may detect this change after receiving the data. The client is then expected to call `in3_nodeList` to update its nodeList before sending out the next request. In case the node is not able proof the new nodeList, client may blacklist such a node.

## Proofs

## RPC-Methods Ethereum 

This section describes the behavior for each standard-rpc-method.


### web3_clientVersion

Returns the underlying client version.

See [web3_clientversion](https://github.com/ethereum/wiki/wiki/JSON-RPC#web3_clientversion) for spec.
No Proof or verifiaction possible.


### web3_sha3

Returns Keccak-256 (not the standardized SHA3-256) of the given data.

See [web3_sha3](https://github.com/ethereum/wiki/wiki/JSON-RPC#web3_sha3) for spec.
No Proof returned, but the client must verify the result by hashing the request data itself.

### net_version

Returns the current network id.

See [net_version](https://github.com/ethereum/wiki/wiki/JSON-RPC#net_version) for spec.
No Proof returned, but the client must verify the result by comparing it to the used chainId.

### eth_blockNumber

Returns the number of most recent block.

See [eth_blockNumber](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_blockNumber) for spec.
No Proof returned, since there is none, but the client should verify the result by comparing it to the current blocks returned from other. With the `blockTime` from the chainspec including a tolerance the cuurrent blocknumber may be checked if in the proposed range.

### eth_getBalance

Returns the balance of the account of given address.

See [eth_getBalance](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getBalance) for spec.

A AccountProof, since there is none, but the client should verify the result by comparing it to the current blocks returned from other. With the `blockTime` from the chainspec including a tolerance the cuurrent blocknumber may be checked if in the proposed range.










## PoA Validations