# IN3-Protocol

This document describes the communication between a Incubed client and a Incubed node. This communication is based on requests that use extended [JSON-RPC](https://www.jsonrpc.org/specification)-Format. Especially for ethereum-based requests, this means each node also accepts all standard requests as defined at [Ethereum JSON-RPC](https://github.com/ethereum/wiki/wiki/JSON-RPC), which also includes handling Bulk-requests. 

Each request may add an optional `in3` property defining the verification behavior for Incubed.


## Incubed Requests

Requests without an `in3` property will also get a response without `in3`. This allows any Incubed node to also act as a raw ethereum JSON-RPC endpoint. The `in3` property in the request is defined as the following:  

*  **chainId** `string<hex>` - The requested [chainId](#chainid). This property is optional, but should always be specified in case a node may support multiple chains. In this case, the default of the node would be used, which may end up in an undefined behavior since the client cannot know the default. 

*  **includeCode** `boolean` - Applies only for `eth_call`-requests. If true, the request should include the codes of all accounts. Otherwise only the the codeHash is returned. In this case, the client may ask by calling eth_getCode() afterwards.   

*  **verifiedHashes** `string<bytes32>[]` - If the client sends an array of blockhashes, the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This allows the client to skip requiring signed blockhashes for blocks already verified.

*  **latestBlock** `integer` - If specified, the blocknumber `latest` will be replaced by a blockNumber-specified value. This allows the Incubed client to define finality for PoW-Chains, which is important, since the `latest`-block cannot be considered final and therefore it would be unlikely to find nodes willing to sign a blockhash for such a block.    

*  **useRef** `boolean` - If true, binary-data (starting with a 0x) will be referred if occurring again. This decreases the payload especially for recurring data such as merkle proofs. If supported, the server (and client) will keep track of each binary value storing them in a temporary array. If the previously used value is used again, the server replaces it with `:<index>`. The client then resolves such refs by lookups in the temporary array.   

*  **useBinary** `boolean` - If true, binary-data will be used. This format is optimzed for embedded devices and reduces the payload to about 30%. For details see [the Binary-spec](#binary-format).

*  **useFullProof** `boolean` - If true, all data in the response will be proven, which leads to a higher payload. The result depends on the method called and will be specified there.

*  **finality** `number` - For PoA-Chains, it will deliver additional proof to reach finality.  If given, the server will deliver the blockheaders of the following blocks until at least the number in percent of the validators is reached.   

*  **verification** `string` - Defines the kind of proof the client is asking for. Must be one of the these values: 
    - `'never`' : No proof will be delivered (default). Also no `in3`-property will be added to the response, but only the raw JSON-RPC response will be returned. 
    - `'proof`' : The proof will be created including a blockheader, but without any signed blockhashes.

*  **signers** `string<address>[]` - A list of addresses (as 20bytes in hex) requested to sign the blockhash.    

A example of an Incubed request may look like this:

```json
{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "eth_getTransactionByHash",
    "params": ["0xf84cfb78971ebd940d7e4375b077244e93db2c3f88443bb93c561812cfed055c"],
    "in3": {
        "chainId": "0x1",
        "verification": "proof",
        "signers":["0x784bfa9eb182C3a02DbeB5285e3dBa92d717E07a"]
  }
}
```


## Incubed Responses

Each Incubed node response is based on JSON-RPC, but also adds the `in3` property. If the request does not contain a `in3` property or does not require proof, the response must also omit the `in3` property.

If the proof is requested, the `in3` property is defined with the following properties:

*  **proof** [Proof](#proofs) - The Proof-data, which depends on the requested method. For more details, see the [Proofs](#proofs) section.

*  **lastNodeList** `number` - The blocknumber for the last block updating the nodeList. This blocknumber should be used to indicate changes in the nodeList. If the client has a smaller blocknumber, it should update the nodeList.  

*  **lastValidatorChange** `number` - The blocknumber of the last change of the validatorList (only for PoA-chains). If the client has a smaller number, it needs to update the validatorlist first. For details, see [PoA Validations](#poa-validations)   

*  **currentBlock** `number` - The current blocknumber. This number may be stored in the client in order to run sanity checks for `latest` blocks or `eth_blockNumber`, since they cannot be verified directly.   

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

Incubed supports multiple chains and a client may even run requests to different chains in parallel. While, in most cases, a chain refers to a specific running blockchain, chainIds may also refer to abstract networks such as ipfs. So, the definition of a chain in the context of Incubed is simply a distributed data domain offering verifiable api-functions implemented in an in3-node.

Each chain is identified by a `uint64` identifier written as hex-value (without leading zeros). Since incubed started with ethereum, the chainIds for public ethereum-chains are based on the intrinsic chainId of the ethereum-chain. See https://chainid.network.

For each chain, Incubed manages a list of nodes as stored in the [server registry](#registry) and a chainspec describing the verification. These chainspecs are held in the client, as they specify the rules about how responses may be validated.

## Registry

As Incubed aims for fully decentralized access to the blockchain, the registry is implemented as an ethereum smart contract. 

This contract serves different purposes. Primarily, it manages all the Incubed nodes, both the onboarding and also unregistering process. In order to do so, it must also manage the deposits: reverting when the amount of provided ether is smaller than the current minimum deposit; but also locking and/or sending back deposits after a server leaves the in3-network.

In addition, the contract is also used to secure the in3-network by providing functions to "convict" servers that provided a wrongly signed block, and also having a function to vote out inactive servers.

### Register and Unregister of nodes

#### Register

There are two ways of registering a new node in the registry: either calling [`registerNode()`][registerNode]  or by calling [`registerNodeFor()`][registerNodeFor]. Both functions share some common parameters that have to be provided: 
* `url` the url of the to be registered node 
* `props` the properties of the node 
* `weight` the amount of requests per second the node is capable of handling
* `deposit` the deposit of the node in ERC20 tokens. 

Those described parameters are sufficient when calling [`registerNode()`][registerNode] and will register a new node in the registry with the sender of the transaction as the owner. However, if the designated signer and the owner should use different keys, [`registerNodeFor()`][registerNodeFor] has to be called. In addition to the already described parameters, this function also needs a certain signature (i.e. `v`, `r`, `s`). This signature has to be created by hashing the url, the properties, the weight and the designated owner (i.e. `keccack256(url,properties,weight,owner)`) and signing it with the privateKey of the signer. After this has been done, the owner then can call [`registerNodeFor()`][registerNodeFor] and register the node. 

However, in order for the register to succeed, at least the correct amount of deposit has to be approved by the designated owner of the node. The supported token can be received by calling [`supportedToken()`][supportedToken] the registry contract. The same approach also applied to the minimal amount of tokens needed for registering by calling [`minDeposit()`][minDeposit]. 

In addition to that, during the first year after deployment there is also a maximum deposit for each node. This can be received by calling [`maxDepositFirstYear()`][maxDepositFirstYear]. Providing a deposit greater then this will result in a failure when trying to register. 

#### Unregister a node 

In order to remove a node from the registry, the function [`unregisteringNode()`][unregisteringNode] can be used, but is only callable by the owner the node. 

While after a successful call the node will be removed from the nodeList immediately, the deposit of the former node will still be locked for the next 40 days after this function had been called. After the timeout is over, the function [`returnDeposit()`][returnDeposit] can be called in order to get the deposit back. 
The reason for that decision is simple: this approach makes sure that there is enough time to convict a malicious node even after he unregistered his node.   

### Convicting a node

After a malicious node signed a wrong blockhash, he can be convicted resulting in him loosing the whole deposit while the caller receives 50% of the deposit. There are two steps needed for the process to succeed: calling [`convict()`][convict] and [`revealConvict()`][revealConvict]. 

#### calling convict

The first step for convicting a malicious node is calling the [`convict()`][convict]-function. This function will store a specific hash within the smart contract. 

The hash needed for convicting requires some parameters:
* `blockhash` the wrongly blockhash that got signed the by malicious node
* `sender` the account that sends this transaction
* `v` v of the signature of the wrong block
* `r` r of the signature of the wrong block
* `s` s of the signature of the wrong block

All those values are getting hashed (`keccack256(blockhash,sender,v,r,s`) and are stored within the smart contract. 

#### calling revealConvcit 

This function requires that at least 2 blocks have passed since [`convict()`][convict] was called. This mechanic reduces the risks of successful frontrunning attacks. 

In addition, there are more requirements for successfully convicting a malicious node: 
* the blocknumber of the wrongly signed block has to be either within the latest 256 blocks or be stored within the BlockhashRegistry. 
* the malicious node provided a signature for the wong block and it was signed by the node
* the specific hash of the convict-call can be recreated (i.e. the caller provided the very same parameters again)
* the malicious node is either currently active or did not withdraw his deposit yet

If the [`revealConvict()`][revealConvict]-call passes, the malicious node will be removed immediately from the nodeList. As a reward for finding a malicious node the caller receives 50% of the deposit of the malicious node. The remaining 50% will stay within the nodeRegistry, but nobody will be able to access/transfer them anymore.  

#### recreating blockheaders

When a malicious node returns a block that is not within the latest 256 blocks, the BlockhashRegistry has to be used. 

There are different functions to store a blockhash and its number in the registry:
* [`snapshot`][snapshot] stores the blockhash and its number of the previous block
* [`saveBlockNumber`][saveBlockNumber] stores a blockhash and its number from the latest 256 blocks
* [`recreateBlockheaders`][recreateBlockheaders] starts from an already stored block and recreates a chain of blocks. Stores the last block at the end. 

In order to reduce the costs of convicting, both [`snapshot`][snapshot] and [`saveBlockNumber`][saveBlockNumber] are the cheapest options, but are limited to the latest 256 blocks. 

Recreating a chain of blocks is way more expensive, but is provides the possibility to recreate way older blocks. It requires the blocknumber of an already stored hash in the smart contract as first parameter. As a second parameter an array of serialized blockheaders have to be provided. This array has to start with the blockheader of the stored block and then the previous blockheaders in reverse order (e.g. `100`,`99`,`98`). The smart contract will try to recreate the chain by comparing both the provided (hashed) headers with the calculated parent and also by comparing the extracted blocknumber with the calculated one. After the smart contracts successfully recreates the provided chain, the blockhash of the last element gets stored within the smart contract. 

### Updating the NodeRegistry 

In ethereum the deployed code of an already existing smart contract cannot be changed. This means, that as soon as the Registry smart contract gets updated, the address would change which would result in changing the address of the smart contract containing the nodeList in each client and device. 

```eval_rst
.. graphviz::

    digraph G {
        node [color=lightblue, fontname="Helvetica"];

        logic     [label="NodeRegistryLogic"  ,style=filled];
        db        [label="NodeRegistryData"  ,style=filled ];
        blockHash [label="BlockHashRegistry"               ];
        
        logic -> db       [ label="owns", fontname="Helvetica" ];
        logic -> blockHash[ label="uses", fontname="Helvetica" ];
    }

```

In order to solve this issue, the registry is divided between two different deployed smart contracts: 
* `NodeRegistryData`: a smart contract to store the nodeList 
* `NodeRegistryLogic`: a smart contract that has the logic needed to run the registry

There is a special relationship between those two smart contracts: The NodeRegistryLogic "owns" the NodeRegistryData. This means, that only he is allowed to call certain functions of the NodeRegistryData. In our case this means all writing operations, i.e. he is the only entity that is allowed to actually be allowed to store data within the smart contract. We are using this approach to make sure that only the NodeRegistryLogic can call the register, update and remove functions of the NodeRegistryData. In addition, he is the only one allowed to change the ownership to a new contract. Doing so results in the old NodeRegistryLogic to lose write access. 

In the NodeRegistryLogic there are 2 special parameters for the update process: 
* `updateTimeout`: a timestamp that defines when it's possible to update the registry to the new contract
* `pendingNewLogic`: the address of the already deployed new NodeRegistryLogic contract for the updated registry

When an update of the Registry is needed, the function `adminUpdateLogic` gets called by the owner of the NodeRegistryLogic. This function will set the address of the new pending contract and also set a timeout of 47 days until the new logic can be applied to the NodeRegistryData contract. After 47 days everyone is allowed to call `activateNewLogic` resulting in an update of the registry. 

The timeout of accessing the deposit of a node after removing it from the nodeList is only 40 days. In case a node owner dislikes the pending registry, he has 7 days to unregister in order to be able to get his deposit back before the new update can be applied. 

### Node structure
 
Each Incubed node must be registered in the NodeRegistry in order to be known to the network. A node or server is defined as: 

*  **url** `string` - The public url of the node, which must accept JSON-RPC requests.

*  **owner** `address` - The owner of the node with the permission to edit or remove the node.  

*  **signer** `address` - The address used when signing blockhashes. This address must be unique within the nodeList.   

*  **timeout** `uint64` - Timeout after which the owner is allowed to receive its stored deposit. This information is also important for the client, since an invalid blockhash-signature can only "convict" as long as the server is registered. A long timeout may provide higher security since the node can not lie and unregister right away.

*  **deposit** `uint256` - The deposit stored for the node, which the node will lose if it signs a wrong blockhash.

*  **props** `uint192` - A bitmask defining the capabilities of the node:

    - **proof** ( `0x01` )  :  The node is able to deliver proof. If not set, it may only serve pure ethereum JSON/RPC. Thus, simple remote nodes may also be registered as Incubed nodes.
    - **multichain** ( `0x02` ) : The same RPC endpoint may also accept requests for different chains. if this is set the `chainId`-prop in the request in required.
    - **archive** ( `0x04` ) : If set, the node is able to support archive requests returning older states. If not, only a pruned node is running.
    -  **http** ( `0x08` ) : If set, the node will also serve requests on standard http even if the url specifies https. This is relevant for small embedded devices trying to save resources by not having to run the TLS.
    - **binary** (`0x10` )  : If set, the node accepts request with `binary:true`. This reduces the payload to about 30% for embedded devices.
    - **onion** ( `0x20` ) : If set, the node is reachable through onionrouting and url will be a onion url.
    - **signer** ( `0x40` ) : If set, the node will sign blockhashes.
    - **proofer** ( `0x80` ) : If set, the node will provide rpc and proofs.
    - **minBlockHeight** ( `0x0100000000` - `0xFF00000000` ):  : The min number of blocks this node is willing to sign. if this number is low (like <6) the risk of signing unindentially a wrong blockhash because of reorgs is high. The default should be 10)
       ```js
       minBlockHeight = props >> 32 & 0xFF
       ```
    More capabilities will be added in future versions.

*  **unregisterTime** `uint64` - The earliest timestamp when the node can unregister itself by calling `confirmUnregisteringServer`.  This will only be set after the node requests an unregister. The client nodes with an `unregisterTime` set have less trust, since they will not be able to convict after this timestamp.

*  **registerTime** `uint64` - The timestamp, when the server was registered.

*  **weight** `uint64` - The number of parallel requests this node may accept. A higher number indicates a stronger node, which will be used within the incentivization layer to calculate the score.

## Binary Format

Since Incubed is optimized for embedded devices, a server can not only support JSON, but a special binary-format. 
You may wonder why we don't want to use any existing binary serialization for JSON like CBOR or others. The reason is simply: because we do not need to support all the features JSON offers. The following features are not supported:
- no escape sequences (this allows use of the string without copying it)
- no float support (at least for now)
- no string literals starting with `0x` since this is always considered as hexcoded bytes
- no propertyNames within the same object with the same key hash

Since we are able to accept these restrictions, we can keep the JSON-parser simple.
This binary-format is highly optimized for small devices and will reduce the payload to about 30%. This is achieved with the following optimizations:

* All strings starting with `0x`are interpreted as binary data and stored as such, which reduces the size of the data to 50%.
* Recurring byte-values will use references to previous data, which reduces the payload, especially for merkle proofs.
* All propertyNames of JSON-objects are hashed to a 16bit-value, reducing the size of the data to a signifivant amount (depending on the propertyName).

  The hash is calculated very easily like this:
  ```c
  static d_key_t key(const char* c) {
    uint16_t val = 0, l = strlen(c);
    for (; l; l--, c++) val ^= *c | val << 7;
    return val;
  }
  ````


```eval_rst
.. note:: A very important limitation is the fact that property names are stored as 16bit hashes, which decreases the payload, but does not allow for the restoration of the full json without knowing all property names! 
```

The binary format is based on JSON-structure, but uses a RLP-encoding approach. Each node or value is represented by these four values:

*  **key** `uint16_t` - The key hash of the property. This value will only pass before the property node if the structure is a property of a JSON-object. 
*  **type** `d_type_t` - 3 bit : defining the type of the element.
*  **len** `uint32_t` - 5 bit : the length of the data (for bytes/string/array/object). For (boolean or integer) the length will specify the value. 
*  **data** `bytes_t` - The bytes or value of the node (only for strings or bytes).


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

The `len` depends on the size of the data. So, the last 5 bit of the first bytes are interpreted as follows:

* `0x00` - `0x1c` : The length is taken as is from the 5 bits.
* `0x1d` - `0x1f` : The length is taken by reading the big-endian value of the next `len - 0x1c` bytes (len ext).  

After the type-byte and optional length bytes, the 2 bytes representing the property hash is added, but only if the element is a property of a JSON-object.    

Depending on these types, the length will be used to read the next bytes:

* `0x0` : **binary data** - This would be a value or property with binary data. The `len` will be used to read the number of bytes as binary data.
* `0x1` : **string data** - This would be a value or property with string data. The `len` will be used to read the number of bytes (+1) as string. The string will always be null-terminated, since it will allow small devices to use the data directly instead of copying memory in RAM.
* `0x2` : **array** - Represents an array node, where the `len` represents the number of elements in the array. The array elements will be added right after the array-node.
* `0x3` : **object** - A JSON-object with `len` properties coming next. In this case the properties following this element will have a leading `key` specified.
* `0x4` : **boolean** - Boolean value where `len` must be either `0x1`= `true` or `0x0` = `false`. If `len > 1` this element is a copy of a previous node and may reference the same data. The index of the source node will then be `len-2`.
* `0x5` : **integer** - An integer-value with max 29 bit (since the 3 bits are used for the type). If the value is higher than `0x20000000`, it will be stored as binary data.
* `0x6` : **null** - Represents a null-value. If this value has a `len`> 0 it will indicate the beginning of data, where `len` will be used to specify the number of elements to follow. This is optional, but helps small devices to allocate the right amount of memory.


## Communication

Incubed requests follow a simple request/response schema allowing even devices with a small bandwith to retrieve all the required data with one request. But there are exceptions when additional data need to be fetched.

These are:

1. **Changes in the NodeRegistry**    

    Changes in the NodeRegistry are based on one of the following events: 
    
    - `LogNodeRegistered`
    - `LogNodeRemoved`
    - `LogNodeChanged`

    The server needs to watch for events from the `NodeRegistry` contract, and update the nodeList when needed.
    
    Changes are detected by the client by comparing the blocknumber of the latest change with the last known blocknumber. Since each response will include the `lastNodeList`, a client may detect this change after receiving the data. The client is then expected to call `in3_nodeList` to update its nodeList before sending out the next request. In the event that the node is not able to proof the new nodeList, the client may blacklist such a node.

  ```eval_rst
    .. uml::

      Client -> NodeA: Request
      NodeA --> Client: Response with lastNodeList

      Client --> Client: check if lastNodeList increased

      Client -> NodeB: Request in3_nodeList
      NodeB --> Client: verify and update nodeList and lastNodeList


  ```


2. **Changes in the ValidatorList**    

    This only applies to PoA-chains where the client needs a defined and verified validatorList. Depending on the consensus, changes in the validatorList must be detected by the node and indicated with the `lastValidatorChange` on each response. This `lastValidatorChange` holds the last blocknumber of a change in the validatorList.  
    
    Changes are detected by the client by comparing the blocknumber of the latest change with the last known blocknumber. Since each response will include the `lastValidatorChange` a client may detect this change after receiving the data or in case of an unverifiable response. The client is then expected to call `in3_validatorList` to update its list before sending out the next request. In the event that the node is not able to proof the new nodeList, the client may blacklist such a node.

3. **Failover**    

    It is also good to have a second request in the event that a valid response is not delivered. This could happen if a node does not respond at all or the response cannot be validated. In both cases, the client may blacklist the node for a while and send the same request to another node.


## RPC Specification

This section describes the behavior for each RPC-method.


### Incubed

There are also some Incubed specific rpc-methods, which will help the clients to bootstrap and update the nodeLists.


#### in3_nodeList

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
- `accounts`: a Object with the addresses of the db-contract as key and Proof as value. The Data Structure of the Proof is exactly the same as the result of - [`eth_getProof`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getproof), but it must containi the above described keys
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



##### Partial NodeLists

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

#### in3_sign

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

### Ethereum 1.x

Standard JSON-RPC calls as described in https://github.com/ethereum/wiki/wiki/JSON-RPC.

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


#### web3_clientVersion

Returns the underlying client version.

See [web3_clientversion](https://github.com/ethereum/wiki/wiki/JSON-RPC#web3_clientversion) for spec.

No proof or verification possible.


#### web3_sha3

Returns Keccak-256 (not the standardized SHA3-256) of the given data.

See [web3_sha3](https://github.com/ethereum/wiki/wiki/JSON-RPC#web3_sha3) for spec.

No proof returned, but the client must verify the result by hashing the request data itself.

#### net_version

Returns the current network ID.

See [net_version](https://github.com/ethereum/wiki/wiki/JSON-RPC#net_version) for spec.

No proof returned, but the client must verify the result by comparing it to the used chainId.

#### eth_blockNumber

Returns the number of the most recent block.

See [eth_blockNumber](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_blockNumber) for spec.

No proof returned, since there is none, but the client should verify the result by comparing it to the current blocks returned from others. With the `blockTime` from the chainspec, including a tolerance, the current blocknumber may be checked if in the proposed range.

#### eth_getBlockByNumber

See [block based proof](#eth-getblockbyhash)

#### eth_getBlockByHash

Return the block data and proof.

See JSON-RPC-Spec 
- [eth_getBlockByNumber](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getBlockByNumber) - find block by number.
- [eth_getBlockByHash](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getBlockByHash) - find block by hash.


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


#### eth_getBlockTransactionCountByHash

See [transaction count proof](#eth-getunclecountbyblocknumber)

#### eth_getBlockTransactionCountByNumber

See [transaction count proof](#eth-getunclecountbyblocknumber)

#### eth_getUncleCountByBlockHash

See [count proof](#eth-getunclecountbyblocknumber)

#### eth_getUncleCountByBlockNumber

return the number of transactions or uncles.

See JSON-RPC-Spec 
- [eth_getBlockTransactionCountByHash](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getBlockTransactionCountByHash) - number of transaction by block hash.
- [eth_getBlockTransactionCountByNumber](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getBlockTransactionCountByNumber) - number of transaction by block number.
- [eth_getUncleCountByBlockHash](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getUncleCountByBlockHash) - number of uncles by block number.
- [eth_getUncleCountByBlockNumber](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getUncleCountByBlockNumber) - number of uncles by block number.

Requests requiring proof for blocks will return a proof of type `blockProof`.  Depending on the request, the proof will contain the following properties:

- `type` : constant : `blockProof`
- `signatures` : a array of signatures from the signers (if requested) of the requested block.
- `block` : the serialized blockheader
- `transactions`: a array of raw transactions of the block. This is only needed if the number of transactions are requested.
- `finalityBlocks`: a array of blockHeaders which were mined after the requested block. The number of blocks depends on the request-property `finality`. If this is not specified, this property will not be defined.
- `uncles`: a array of blockheaders of the uncles of the block. This is only needed if the number of uncles are requested.


#### eth_getTransactionByHash

return the transaction data.


See JSON-RPC-Spec 
- [eth_getTransactionByHash](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getTransactionByHash) - transaction data by hash.
- [eth_getTransactionByBlockHashAndIndex](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getTransactionByBlockHashAndIndex) - transaction data based on blockhash and index
- [eth_getTransactionByBlockNumberAndIndex](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getTransactionByBlockNumberAndIndex) - transaction data based on block number and index


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

#### eth_getTransactionReceipt

The Receipt of a Transaction.

See JSON-RPC-Spec 
- [eth_getTransactionReceipt](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_gettransactionreceipt) - returns the receipt.


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

#### eth_getLogs


Proofs for logs or events.

See JSON-RPC-Spec 
- [eth_getLogs](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getLogs) - returns all event matching the filter.

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



#### eth_getBalance

See [account proof](#eth-getstorageat)

#### eth_getCode

See [account proof](#eth-getstorageat)

#### eth_getTransactionCount

See [account proof](#eth-getstorageat)

#### eth_getStorageAt

Returns account based values and proof.

See JSON-RPC-Spec 
- [eth_getBalance](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getBalance) - returns the balance.
- [eth_getCode](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getcode) - the byte code of the contract.
- [eth_getTransactionCount](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_gettransactioncount) - the nonce of the account.
- [eth_getStorageAt](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getstorageat) - the storage value for the given key of the given account.


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
- `accounts`: a Object with the addresses of all required accounts (in this case it is only one account) as key and Proof as value. The DataStructure of the Proof for each account is exactly the same as the result of - [`eth_getProof`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getproof). 
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

#### eth_estimateGas

See [call proof](#eth-call)

#### eth_call

calls a function of a contract (or simply executes the evm opcodes).

See JSON-RPC-Spec 
- [eth_call](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_call) - executes a function and returns the result.
- [eth_estimateGas](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_estimateGas) - executes a function and returns the gas used.


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
- `accounts`: a Object with the addresses of all accounts required to run the call as keys. This includes also all storage values (SLOAD) including proof used. The DataStructure of the Proof for each account is exactly the same as the result of - [`eth_getProof`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_getproof). 
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



#### eth_accounts
#### eth_sign
#### eth_sendTransaction

See JSON-RPC-Spec 
- [eth_accounts](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_accounts) - returns the unlocked accounts.
- [eth_sign](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign) - signs data with an unlocked account.
- [eth_sendTransaction](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sendTransaction) - signs and sends a transaction.

Signing is **not supported** since the nodes are serving a public rpc-enpoint. These methods will return a error. The client may still support those methods, but handle those requests internally.

#### eth_sendRawTransaction

See JSON-RPC-Spec 
- [eth_sendRawTransaction](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sendRawTransaction) - sends a prviously signed transaction.

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