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

*  **whiteList** `address` - If specified, the incubed server will respond with `lastWhiteList`, which will indicate the last block number of whitelist contract event.

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
        "whiteList": "0x08e97ef0a92EB502a1D7574913E2a6636BeC557b",
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

* **lastWhiteList** `number` - The blocknumber for the last block updating the whitelist nodes in whitelist contract. This blocknumber could be used to detect if there is any change in whitelist nodes. If the client has a smaller blocknumber, it should update the white list.

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
    "lastNodeList": 6619795,
    "lastWhiteList": 1546354
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
    - **data** ( `0x80` ) : If set, the node will provide rpc responses (at least without proof).
    - **stats** ( `0x100` ) : If set, the node will provide and endpoint for delivering metrics, which is usually the `/metrics`- endpoint, which can be used by prometheus to fetch statistics.
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
