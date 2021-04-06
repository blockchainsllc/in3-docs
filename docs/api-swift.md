# API Reference Swift

The swift binding contains binaries are only available for macos and ios. ( for now)

## Install


TODO

## Usage

In order to use incubed, you need to add the In3-Package as dependency and import into your code:

```swift
import In3

// configure and create a client.
let in3 = try In3Config(chainId: "mainnet", requestCount:1).createClient()

// use the Eth-Api to execute requests
Eth(in3).getTransactionReceipt(hash: "0xe3f6f3a73bccd73b77a7b9e9096fe07b9341e7d1d8f1ad8b8e5207f2fe349fa0").observe(using: {
            switch $0 {
            case let .failure(err):
                print("Failed to get the tx : \(err)")
            case let .success( tx ):
                if let tx = tx {
                    print("Found tx with txhash \(tx.hash)")
                } else {
                    print("Tx does not exist")
                }
            }
        })
```
## Classes
### BtcAPI

*Important:​ This feature is still experimental and not considered stable yet. In order to use it, you need to set the experimental-flag (-x on the comandline or `"experimental":​true`\!*

``` swift
public class BtcAPI
```

For bitcoin incubed follows the specification as defined in <https://bitcoincore.org/en/doc/0.18.0/>.
Internally the in3-server will add proofs as part of the responses. The proof data differs between the methods. You will read which proof data will be provided and how the data can be used to prove the result for each method.

Proofs will add a special `in3`-section to the response containing a `proof`- object. This object will contain parts or all of the following properties:

  - **block**

  - **final**

  - **txIndex**

  - **merkleProof**

  - **cbtx**

  - **cbtxMerkleProof**



#### getblockheaderAsHex(hash:)

returns a hex representation of the blockheader

``` swift
public func getblockheaderAsHex(hash: String) -> Future<String?>
```

**Parameters**

  - hash: The block hash

**Returns**

the blockheader.     /// - verbose `0` or `false`:​ a hex string with 80 bytes representing the blockheader    /// - verbose `1` or `true`:​ an object representing the blockheader.    ///

#### getblockheader(hash:)

returns the blockheader

``` swift
public func getblockheader(hash: String) -> Future<Btcblockheader?>
```

**Parameters**

  - hash: The block hash

**Returns**

the blockheader.     /// - verbose `0` or `false`:​ a hex string with 80 bytes representing the blockheader    /// - verbose `1` or `true`:​ an object representing the blockheader.    ///

#### getBlockAsHex(hash:)

returns a hex representation of the block

``` swift
public func getBlockAsHex(hash: String) -> Future<String?>
```

**Parameters**

  - hash: The block hash

**Returns**

the block.     /// - verbose `0` or `false`:​ a hex string with 80 bytes representing the blockheader    /// - verbose `1` or `true`:​ an object representing the blockheader.    ///

#### getBlock(hash:)

returns the block with transactionhashes

``` swift
public func getBlock(hash: String) -> Future<Btcblock?>
```

**Parameters**

  - hash: The block hash

**Returns**

the block.     /// - verbose `0` or `false`:​ a hex string with 80 bytes representing the blockheader    /// - verbose `1` or `true`:​ an object representing the blockheader.    ///

#### getBlockWithTx(hash:)

returns the block with full transactions

``` swift
public func getBlockWithTx(hash: String) -> Future<BtcblockWithTx?>
```

**Parameters**

  - hash: The block hash

**Returns**

the block.     /// - verbose `0` or `false`:​ a hex string with 80 bytes representing the blockheader    /// - verbose `1` or `true`:​ an object representing the blockheader.    ///

#### getRawTransactionAsHex(txid:blockhash:)

returns a hex representation of the tx

``` swift
public func getRawTransactionAsHex(txid: String, blockhash: String? = nil) -> Future<String?>
```

**Parameters**

  - txid: The transaction id
  - blockhash: The block in which to look for the transaction

**Returns**

  - verbose `0` or `false`:​ a string that is serialized, hex-encoded data for `txid`    /// - verbose `1` or `false`:​ an object representing the transaction.            ///

#### getRawTransaction(txid:blockhash:)

returns the raw transaction

``` swift
public func getRawTransaction(txid: String, blockhash: String? = nil) -> Future<Btctransaction?>
```

**Parameters**

  - txid: The transaction id
  - blockhash: The block in which to look for the transaction

**Returns**

  - verbose `0` or `false`:​ a string that is serialized, hex-encoded data for `txid`    /// - verbose `1` or `false`:​ an object representing the transaction.            ///

#### getblockcount()

Returns the number of blocks in the longest blockchain.

``` swift
public func getblockcount() -> Future<UInt64>
```

**Returns**

the current blockheight

#### getdifficulty(blocknumber:)

Returns the proof-of-work difficulty as a multiple of the minimum difficulty.

``` swift
public func getdifficulty(blocknumber: UInt64) -> Future<UInt64>
```

**Parameters**

  - blocknumber: Can be the number of a certain block to get its difficulty. To get the difficulty of the latest block use `latest`, `earliest`, `pending` or leave `params` empty (Hint: Latest block always means `actual latest block` minus `in3.finality`)

**Returns**

  - `blocknumber` is a certain number:​ the difficulty of this block    /// - `blocknumber` is `latest`, `earliest`, `pending` or empty:​ the difficulty of the latest block (`actual latest block` minus `in3.finality`)    ///

#### proofTarget(target_dap:verified_dap:max_diff:max_dap:limit:)

Whenever the client is not able to trust the changes of the target (which is the case if a block can't be found in the verified target cache *and* the value of the target changed more than the client's limit `max_diff`) he will call this method. It will return additional proof data to verify the changes of the target on the side of the client. This is not a standard Bitcoin rpc-method like the other ones, but more like an internal method.

``` swift
public func proofTarget(target_dap: UInt64, verified_dap: UInt64, max_diff: UInt64? = 5, max_dap: UInt64? = 5, limit: UInt64? = 0) -> Future<[BtcProofTarget]>
```

  - Parameter target\_dap : the number of the difficulty adjustment period (dap) we are looking for

  - Parameter verified\_dap : the number of the closest already verified dap

  - Parameter max\_diff : the maximum target difference between 2 verified daps

  - Parameter max\_dap : the maximum amount of daps between 2 verified daps

**Parameters**

  - limit: the maximum amount of daps to return (`0` = no limit) - this is important for embedded devices since returning all daps might be too much for limited memory

**Returns**

A path of daps from the `verified_dap` to the `target_dap` which fulfils the conditions of `max_diff`, `max_dap` and `limit`. Each dap of the path is a `dap`-object with corresponding proof data.

#### getbestblockhash()

Returns the hash of the best (tip) block in the longest blockchain.

``` swift
public func getbestblockhash() -> Future<String>
```

**Returns**

the hash of the best block
### EthAPI

Standard JSON-RPC calls as described in https:​//eth.wiki/json-rpc/API.

``` swift
public class EthAPI
```

Whenever a request is made for a response with `verification`: `proof`, the node must provide the proof needed to validate the response result. The proof itself depends on the chain.

For ethereum, all proofs are based on the correct block hash. That's why verification differentiates between [Verifying the blockhash](poa.html) (which depends on the user consensus) the actual result data.

There is another reason why the BlockHash is so important. This is the only value you are able to access from within a SmartContract, because the evm supports a OpCode (`BLOCKHASH`), which allows you to read the last 256 blockhashes, which gives us the chance to verify even the blockhash onchain.

Depending on the method, different proofs are needed, which are described in this document.

Proofs will add a special in3-section to the response containing a `proof`- object. Each `in3`-section of the response containing proofs has a property with a proof-object with the following properties:

  - **type** `string` (required)  - The type of the proof.  
    Must be one of the these values : `'transactionProof`', `'receiptProof`', `'blockProof`', `'accountProof`', `'callProof`', `'logProof`'

  - **block** `string` - The serialized blockheader as hex, required in most proofs.

  - **finalityBlocks** `array` - The serialized following blockheaders as hex, required in case of finality asked (only relevant for PoA-chains). The server must deliver enough blockheaders to cover more then 50% of the validators. In order to verify them, they must be linkable (with the parentHash).

  - **transactions** `array` - The list of raw transactions of the block if needed to create a merkle trie for the transactions.

  - **uncles** `array` - The list of uncle-headers of the block. This will only be set if full verification is required in order to create a merkle tree for the uncles and so prove the uncle\_hash.

  - **merkleProof** `string[]` - The serialized merkle-nodes beginning with the root-node (depending on the content to prove).

  - **merkleProofPrev** `string[]` - The serialized merkle-nodes beginning with the root-node of the previous entry (only for full proof of receipts).

  - **txProof** `string[]` - The serialized merkle-nodes beginning with the root-node in order to proof the transactionIndex (only needed for transaction receipts).

  - **logProof** [LogProof](#logproof) - The Log Proof in case of a `eth_getLogs`-request.

  - **accounts** `object` - A map of addresses and their AccountProof.

  - **txIndex** `integer` - The transactionIndex within the block (for transaactions and receipts).

  - **signatures** `Signature[]` - Requested signatures.



#### clientVersion()

Returns the underlying client version. See [web3\_clientversion](https:​//eth.wiki/json-rpc/API#web3_clientversion) for spec.

``` swift
public func clientVersion() -> Future<String>
```

**Returns**

when connected to the incubed-network, `Incubed/<Version>` will be returned, but in case of a direct enpoint, its's version will be used.

#### keccak(data:)

Returns Keccak-256 (not the standardized SHA3-256) of the given data.

``` swift
public func keccak(data: String) throws -> String
```

See [web3\_sha3](https://eth.wiki/json-rpc/API#web3_sha3) for spec.

No proof needed, since the client will execute this locally.

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### sha3(data:)

Returns Keccak-256 (not the standardized SHA3-256) of the given data.

``` swift
public func sha3(data: String) throws -> String
```

See [web3\_sha3](https://eth.wiki/json-rpc/API#web3_sha3) for spec.

No proof needed, since the client will execute this locally.

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### sha256(data:)

Returns sha-256 of the given data.

``` swift
public func sha256(data: String) throws -> String
```

No proof needed, since the client will execute this locally.

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### version()

the Network Version (currently 1)

``` swift
public func version() throws -> String
```

**Returns**

the Version number

#### createKey(seed:)

Generates 32 random bytes.
If /dev/urandom is available it will be used and should generate a secure random number.
If not the number should not be considered sceure or used in production.

``` swift
public func createKey(seed: String? = nil) throws -> String
```

**Parameters**

  - seed: the seed. If given the result will be deterministic.

**Returns**

the 32byte random data

#### sign(account:message:)

The sign method calculates an Ethereum specific signature with:​

``` swift
public func sign(account: String, message: String) -> Future<String>
```

``` js
sign(keccak256("\x19Ethereum Signed Message:\n" + len(message) + message))).
```

By adding a prefix to the message makes the calculated signature recognisable as an Ethereum specific signature. This prevents misuse where a malicious DApp can sign arbitrary data (e.g. transaction) and use the signature to impersonate the victim.

For the address to sign a signer must be registered.

**Parameters**

  - account: the account to sign with
  - message: the message to sign

**Returns**

the signature (65 bytes) for the given message.

#### signTransaction(tx:)

Signs a transaction that can be submitted to the network at a later time using with eth\_sendRawTransaction.

``` swift
public func signTransaction(tx: EthTransaction) -> Future<String>
```

**Parameters**

  - tx: transaction to sign

**Returns**

the raw signed transaction

#### blockNumber()

returns the number of the most recent block.

``` swift
public func blockNumber() -> Future<String>
```

See [eth\_blockNumber](https://eth.wiki/json-rpc/API#eth_blockNumber) for spec.

No proof returned, since there is none, but the client should verify the result by comparing it to the current blocks returned from others.
With the `blockTime` from the chainspec, including a tolerance, the current blocknumber may be checked if in the proposed range.

#### getBlockByNumber(blockNumber:fullTx:)

returns information about a block by block number.

``` swift
public func getBlockByNumber(blockNumber: UInt64, fullTx: Bool) -> Future<EthBlockdata>
```

See [eth\_getBlockByNumber](https://eth.wiki/json-rpc/API#eth_getBlockByNumber) for spec.

**Parameters**

  - blockNumber: the blockNumber or one of `latest`, `earliest`or `pending`
  - fullTx: if true the full transactions are contained in the result.

**Returns**

the blockdata, or in case the block with that number does not exist, `null` will be returned.

#### getBlockByHash(blockHash:fullTx:)

Returns information about a block by hash.

``` swift
public func getBlockByHash(blockHash: String, fullTx: Bool) -> Future<String>
```

See [eth\_getBlockByHash](https://eth.wiki/json-rpc/API#eth_getBlockByHash) for spec.

**Parameters**

  - blockHash: the blockHash of the block
  - fullTx: if true the full transactions are contained in the result.

#### getBlockTransactionCountByHash(blockHash:)

returns the number of transactions. For Spec, see [eth\_getBlockTransactionCountByHash](https:​//eth.wiki/json-rpc/API#eth_getBlockTransactionCountByHash).

``` swift
public func getBlockTransactionCountByHash(blockHash: String) -> Future<String>
```

**Parameters**

  - blockHash: the blockHash of the block

#### getBlockTransactionCountByNumber(blockNumber:)

returns the number of transactions. For Spec, see [eth\_getBlockTransactionCountByNumber](https:​//eth.wiki/json-rpc/API#eth_getBlockTransactionCountByNumber).

``` swift
public func getBlockTransactionCountByNumber(blockNumber: UInt64) -> Future<String>
```

**Parameters**

  - blockNumber: the blockNumber of the block

#### getUncleCountByBlockHash(blockHash:)

returns the number of uncles. For Spec, see [eth\_getUncleCountByBlockHash](https:​//eth.wiki/json-rpc/API#eth_getUncleCountByBlockHash).

``` swift
public func getUncleCountByBlockHash(blockHash: String) -> Future<String>
```

**Parameters**

  - blockHash: the blockHash of the block

#### getUncleCountByBlockNumber(blockNumber:)

returns the number of uncles. For Spec, see [eth\_getUncleCountByBlockNumber](https:​//eth.wiki/json-rpc/API#eth_getUncleCountByBlockNumber).

``` swift
public func getUncleCountByBlockNumber(blockNumber: UInt64) -> Future<String>
```

**Parameters**

  - blockNumber: the blockNumber of the block

#### getTransactionByBlockHashAndIndex(blockHash:index:)

returns the transaction data.

``` swift
public func getTransactionByBlockHashAndIndex(blockHash: String, index: UInt64) -> Future<String>
```

See JSON-RPC-Spec for [eth\_getTransactionByBlockHashAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockHashAndIndex) for more details.

**Parameters**

  - blockHash: the blockhash containing the transaction.
  - index: the transactionIndex

#### getTransactionByBlockNumberAndIndex(blockNumber:index:)

returns the transaction data.

``` swift
public func getTransactionByBlockNumberAndIndex(blockNumber: UInt64, index: UInt64) -> Future<String>
```

See JSON-RPC-Spec for [eth\_getTransactionByBlockNumberAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockNumberAndIndex) for more details.

**Parameters**

  - blockNumber: the block number containing the transaction.
  - index: the transactionIndex

#### getTransactionByHash(txHash:)

returns the transaction data.

``` swift
public func getTransactionByHash(txHash: String) -> Future<String>
```

See JSON-RPC-Spec for [eth\_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash) for more details.

**Parameters**

  - txHash: the transactionHash of the transaction.

#### getLogs(filter:)

searches for events matching the given criteria. See [eth\_getLogs](https:​//eth.wiki/json-rpc/API#eth_getLogs) for the spec.

``` swift
public func getLogs(filter: EthFilter) -> Future<String>
```

**Parameters**

  - filter: The filter criteria for the events.

#### getBalance(account:block:)

gets the balance of an account for a given block

``` swift
public func getBalance(account: String, block: UInt64) -> Future<String>
```

**Parameters**

  - account: address of the account
  - block: the blockNumber or one of `latest`, `earliest`or `pending`

#### getTransactionCount(account:block:)

gets the nonce or number of transaction sent from this account at a given block

``` swift
public func getTransactionCount(account: String, block: UInt64) -> Future<String>
```

**Parameters**

  - account: address of the account
  - block: the blockNumber or one of `latest`, `earliest`or `pending`

#### getCode(account:block:)

gets the code of a given contract

``` swift
public func getCode(account: String, block: UInt64) -> Future<String>
```

**Parameters**

  - account: address of the account
  - block: the blockNumber or one of `latest`, `earliest`or `pending`

#### getStorageAt(account:key:block:)

gets the storage value of a given key

``` swift
public func getStorageAt(account: String, key: String, block: UInt64) -> Future<String>
```

**Parameters**

  - account: address of the account
  - key: key to look for
  - block: the blockNumber or one of `latest`, `earliest`or `pending`

#### sendTransaction(tx:)

signs and sends a Transaction

``` swift
public func sendTransaction(tx: EthTransaction) -> Future<String>
```

**Parameters**

  - tx: the transactiondata to send

#### sendTransactionAndWait(tx:)

signs and sends a Transaction, but then waits until the transaction receipt can be verified. Depending on the finality of the nodes, this may take a while, since only final blocks will be signed by the nodes.

``` swift
public func sendTransactionAndWait(tx: EthTransaction) -> Future<String>
```

**Parameters**

  - tx: the transactiondata to send

#### sendRawTransaction(tx:)

sends or broadcasts a prviously signed raw transaction. See [eth\_sendRawTransaction](https:​//eth.wiki/json-rpc/API#eth_sendRawTransaction)

``` swift
public func sendRawTransaction(tx: String) -> Future<String>
```

**Parameters**

  - tx: the raw signed transactiondata to send

#### estimateGas(tx:block:)

calculates the gas needed to execute a transaction. for spec see [eth\_estimateGas](https:​//eth.wiki/json-rpc/API#eth_estimateGas)

``` swift
public func estimateGas(tx: EthTransaction, block: UInt64) -> Future<String>
```

**Parameters**

  - tx: the tx-object, which is the same as specified in [eth\_sendTransaction](https://eth.wiki/json-rpc/API#eth_sendTransaction).
  - block: the blockNumber or one of `latest`, `earliest`or `pending`

#### call(tx:block:)

calls a function of a contract (or simply executes the evm opcodes) and returns the result. for spec see [eth\_call](https:​//eth.wiki/json-rpc/API#eth_call)

``` swift
public func call(tx: EthTx, block: UInt64) -> Future<String>
```

**Parameters**

  - tx: the tx-object, which is the same as specified in [eth\_sendTransaction](https://eth.wiki/json-rpc/API#eth_sendTransaction).
  - block: the blockNumber or one of `latest`, `earliest`or `pending`

#### getTransactionReceipt(txHash:)

The Receipt of a Transaction. For Details, see [eth\_getTransactionReceipt](https:​//eth.wiki/json-rpc/API#eth_gettransactionreceipt).

``` swift
public func getTransactionReceipt(txHash: String) -> Future<String>
```

**Parameters**

  - txHash: the transactionHash
### FileCache

File-Implementation for the cache.

``` swift
public class FileCache: In3Cache
```



[`In3Cache`](/In3Cache)



#### setEntry(key:value:)

write the data to the cache using the given key..

``` swift
public func setEntry(key: String, value: Data)
```

#### getEntry(key:)

find the data for the given cache-key or `nil`if not found.

``` swift
public func getEntry(key: String) -> Data?
```

#### clear()

clears all cache entries

``` swift
public func clear()
```
### Future

``` swift
public class Future<Value>
```



#### Result

``` swift
public typealias Result = Swift.Result<Value, Error>
```



#### observe(using:)

``` swift
public func observe(using callback: @escaping (Result) -> Void)
```
### In3

The I ncubed client

``` swift
public class In3
```



#### init(_:)

``` swift
public init(_ config: In3Config) throws
```



#### transport

the transport function

``` swift
var transport: (_ url: String, _ method:String, _ payload:Data?, _ headers: [String], _ cb: @escaping (_ data:TransportResult)->Void) -> Void
```



#### configure(_:)

``` swift
public func configure(_ config: In3Config) throws
```

#### execLocal(_:_:)

Execute a request directly and local.
This works only for requests which do not need to be send to a server.

``` swift
public func execLocal(_ method: String, _ params: RPCObject) throws -> RPCObject
```

#### execLocal(_:_:)

Execute a request directly and local.
This works only for requests which do not need to be send to a server.

``` swift
public func execLocal(_ method: String, _ params: [RPCObject]) throws -> RPCObject
```

#### exec(_:_:cb:)

``` swift
public func exec(_ method: String, _ params: RPCObject, cb: @escaping  (_ result:RequestResult)->Void) throws
```

#### executeJSON(_:)

``` swift
public func executeJSON(_ rpc: String) -> String
```
### In3API

There are also some Incubed specific rpc-methods, which will help the clients to bootstrap and update the nodeLists.

``` swift
public class In3API
```

The incubed client itself offers special RPC-Methods, which are mostly handled directly inside the client:



#### abiEncode(signature:params:)

based on the [ABI-encoding](https:​//solidity.readthedocs.io/en/v0.5.3/abi-spec.html) used by solidity, this function encodes the value given and returns it as hexstring.

``` swift
public func abiEncode(signature: String, params: [AnyObject]) throws -> String
```

**Parameters**

  - signature: the signature of the function. e.g. `getBalance(uint256)`. The format is the same as used by solidity to create the functionhash. optional you can also add the return type, which in this case is ignored.
  - params: a array of arguments. the number of arguments must match the arguments in the signature.

**Returns**

the ABI-encoded data as hex including the 4 byte function-signature. These data can be used for `eth_call` or to send a transaction.

#### abiDecode(signature:data:)

based on the [ABI-encoding](https:​//solidity.readthedocs.io/en/v0.5.3/abi-spec.html) used by solidity, this function decodes the bytes given and returns it as array of values.

``` swift
public func abiDecode(signature: String, data: String) throws -> [RPCObject]
```

**Parameters**

  - signature: the signature of the function. e.g. `uint256`, `(address,string,uint256)` or `getBalance(address):uint256`. If the complete functionhash is given, only the return-part will be used.
  - data: the data to decode (usually the result of a eth\_call)

**Returns**

a array with the values after decodeing.

#### checksumAddress(address:useChainId:)

Will convert an upper or lowercase Ethereum address to a checksum address.  (See [EIP55](https:​//github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) )

``` swift
public func checksumAddress(address: String, useChainId: Bool? = nil) throws -> String
```

**Parameters**

  - address: the address to convert.
  - useChainId: if true, the chainId is integrated as well (See [EIP1191](https://github.com/ethereum/EIPs/issues/1121) )

**Returns**

the address-string using the upper/lowercase hex characters.

#### ens(name:field:)

resolves a ens-name.
the domain names consist of a series of dot-separated labels. Each label must be a valid normalised label as described in [UTS46](https:​//unicode.org/reports/tr46/) with the options `transitional=false` and `useSTD3AsciiRules=true`.
For Javascript implementations, a [library](https:​//www.npmjs.com/package/idna-uts46) is available that normalises and checks names.

``` swift
public func ens(name: String, field: String? = "addr") -> Future<String>
```

**Parameters**

  - name: the domain name UTS46 compliant string.
  - field: the required data, which could be one of ( `addr` - the address, `resolver` - the address of the resolver, `hash` - the namehash, `owner` - the owner of the domain)

**Returns**

the value of the specified field

#### toWei(value:unit:)

converts the given value into wei.

``` swift
public func toWei(value: String, unit: String? = "eth") throws -> String
```

**Parameters**

  - value: the value, which may be floating number as string
  - unit: the unit of the value, which must be one of `wei`, `kwei`,  `Kwei`,  `babbage`,  `femtoether`,  `mwei`,  `Mwei`,  `lovelace`,  `picoether`,  `gwei`,  `Gwei`,  `shannon`,  `nanoether`,  `nano`,  `szabo`,  `microether`,  `micro`,  `finney`,  `milliether`,  `milli`,  `ether`,  `eth`,  `kether`,  `grand`,  `mether`,  `gether` or  `tether`

**Returns**

the value in wei as hex.

#### fromWei(value:unit:digits:)

converts a given uint (also as hex) with a wei-value into a specified unit.

``` swift
public func fromWei(value: String, unit: String, digits: UInt64? = nil) throws -> String
```

**Parameters**

  - value: the value in wei
  - unit: the unit of the target value, which must be one of `wei`, `kwei`,  `Kwei`,  `babbage`,  `femtoether`,  `mwei`,  `Mwei`,  `lovelace`,  `picoether`,  `gwei`,  `Gwei`,  `shannon`,  `nanoether`,  `nano`,  `szabo`,  `microether`,  `micro`,  `finney`,  `milliether`,  `milli`,  `ether`,  `eth`,  `kether`,  `grand`,  `mether`,  `gether` or  `tether`
  - digits: fix number of digits after the comma. If left out, only as many as needed will be included.

**Returns**

the value as string.

#### pk2address(pk:)

extracts the address from a private key.

``` swift
public func pk2address(pk: String) throws -> String
```

**Parameters**

  - pk: the 32 bytes private key as hex.

**Returns**

the address

#### pk2public(pk:)

extracts the public key from a private key.

``` swift
public func pk2public(pk: String) throws -> String
```

**Parameters**

  - pk: the 32 bytes private key as hex.

**Returns**

the public key as 64 bytes

#### ecrecover(msg:sig:sigtype:)

extracts the public key and address from signature.

``` swift
public func ecrecover(msg: String, sig: String, sigtype: String? = "raw") throws -> In3Ecrecover
```

**Parameters**

  - msg: the message the signature is based on.
  - sig: the 65 bytes signature as hex.
  - sigtype: the type of the signature data : `eth_sign` (use the prefix and hash it), `raw` (hash the raw data), `hash` (use the already hashed data). Default: `raw`

**Returns**

the extracted public key and address

#### prepareTx(tx:)

prepares a Transaction by filling the unspecified values and returens the unsigned raw Transaction.

``` swift
public func prepareTx(tx: In3Transaction) -> Future<String>
```

**Parameters**

  - tx: the tx-object, which is the same as specified in [eth\_sendTransaction](https://eth.wiki/json-rpc/API#eth_sendTransaction).

**Returns**

the unsigned raw transaction as hex.

#### signTx(tx:from:)

signs the given raw Tx (as prepared by in3\_prepareTx ). The resulting data can be used in `eth_sendRawTransaction` to publish and broadcast the transaction.

``` swift
public func signTx(tx: String, from: String) -> Future<String>
```

**Parameters**

  - tx: the raw unsigned transactiondata
  - from: the account to sign

**Returns**

the raw transaction with signature.

#### signData(msg:account:msgType:)

signs the given data.

``` swift
public func signData(msg: String, account: String, msgType: String? = "raw") -> Future<In3SignData>
```

**Parameters**

  - msg: the message to sign.
  - account: the account to sign if the account is a bytes32 it will be used as private key
  - msgType: the type of the signature data : `eth_sign` (use the prefix and hash it), `raw` (hash the raw data), `hash` (use the already hashed data)

**Returns**

the signature

#### decryptKey(key:passphrase:)

decrypts a JSON Keystore file as defined in the [Web3 Secret Storage Definition](https:​//github.com/ethereum/wiki/wiki/Web3-Secret-Storage-Definition). The result is the raw private key.

``` swift
public func decryptKey(key: Object, passphrase: String) throws -> String
```

**Parameters**

  - key: Keydata as object as defined in the keystorefile
  - passphrase: the password to decrypt it.

**Returns**

a raw private key (32 bytes)

#### cacheClear()

clears the incubed cache (usually found in the .in3-folder)

``` swift
public func cacheClear() throws -> String
```

**Returns**

true indicating the success

#### nodeList(limit:seed:addresses:)

fetches and verifies the nodeList from a node

``` swift
public func nodeList(limit: UInt64? = nil, seed: String? = nil, addresses: [Address]? = nil) -> Future<String>
```

**Parameters**

  - limit: if the number is defined and \>0 this method will return a partial nodeList limited to the given number.
  - seed: this 32byte hex integer is used to calculate the indexes of the partial nodeList. It is expected to be a random value choosen by the client in order to make the result deterministic.
  - addresses: a optional array of addresses of signers the nodeList must include.

#### sign(blocks:)

requests a signed blockhash from the node.
In most cases these requests will come from other nodes, because the client simply adds the addresses of the requested signers
and the processising nodes will then aquire the signatures with this method from the other nodes.

``` swift
public func sign(blocks: In3Blocks) -> Future<String>
```

Since each node has a risk of signing a wrong blockhash and getting convicted and losing its deposit,
per default nodes will and should not sign blockHash of the last `minBlockHeight` (default: 6) blocks\!

**Parameters**

  - blocks: array of requested blocks.

#### whitelist(address:)

Returns whitelisted in3-nodes addresses. The whitelist addressed are accquired from whitelist contract that user can specify in request params.

``` swift
public func whitelist(address: String) -> Future<String>
```

**Parameters**

  - address: address of whitelist contract

#### addRawKey(pk:)

adds a raw private key as signer, which allows signing transactions.

``` swift
public func addRawKey(pk: String) -> Future<String>
```

**Parameters**

  - pk: the 32byte long private key as hex string.

#### accounts()

returns a array of account-addresss the incubed client is able to sign with. In order to add keys, you can use [in3\_addRawKey](#in3-addrawkey) or configure them in the config. The result also contains the addresses of any signer signer-supporting the `PLGN_ACT_SIGN_ACCOUNT` action.

``` swift
public func accounts() -> Future<String>
```
### IpfsAPI

A Node supporting IPFS must support these 2 RPC-Methods for uploading and downloading IPFS-Content. The node itself will run a ipfs-client to handle them.

``` swift
public class IpfsAPI
```

Fetching ipfs-content can be easily verified by creating the ipfs-hash based on the received data and comparing it to the requested ipfs-hash. Since there is no chance of manipulating the data, there is also no need to put a deposit or convict a node. That's why the registry-contract allows a zero-deposit fot ipfs-nodes.



#### get(ipfshash:encoding:)

Fetches the data for a requested ipfs-hash. If the node is not able to resolve the hash or find the data a error should be reported.

``` swift
public func get(ipfshash: String, encoding: String) -> Future<String>
```

**Parameters**

  - ipfshash: the ipfs multi hash
  - encoding: the encoding used for the response. ( `hex` , `base64` or `utf8`)

**Returns**

the content matching the requested hash encoded in the defined encoding.

#### put(data:encoding:)

Stores ipfs-content to the ipfs network.
Important\! As a client there is no garuantee that a node made this content available. ( just like `eth_sendRawTransaction` will only broadcast it).
Even if the node stores the content there is no gurantee it will do it forever.

``` swift
public func put(data: String, encoding: String) -> Future<String>
```

**Parameters**

  - data: the content encoded with the specified encoding.
  - encoding: the encoding used for the request. ( `hex` , `base64` or `utf8`)

**Returns**

the ipfs multi hash
### Promise

``` swift
public class Promise<Value>: Future<Value>
```



`Future<Value>`



#### resolve(with:)

``` swift
public func resolve(with value: Value)
```

#### reject(with:)

``` swift
public func reject(with error: Error)
```
### ZksyncAPI

*Important:​ This feature is still experimental and not considered stable yet. In order to use it, you need to set the experimental-flag (-x on the comandline or `"experimental":​true`\!*

``` swift
public class ZksyncAPI
```

the zksync-plugin is able to handle operations to use [zksync](https://zksync.io/) like deposit transfer or withdraw. Also see the \#in3-config on how to configure the zksync-server or account.

Also in order to sign messages you need to set a signer\!

All zksync-methods can be used with `zksync_` or `zk_` prefix.



#### contractAddress()

returns the contract address

``` swift
public func contractAddress() -> Future<String>
```

#### tokens()

returns the list of all available tokens

``` swift
public func tokens() -> Future<String>
```

#### accountInfo(address:)

returns account\_info from the server

``` swift
public func accountInfo(address: String? = nil) -> Future<String>
```

**Parameters**

  - address: the account-address. if not specified, the client will try to use its own address based on the signer config.

#### txInfo(tx:)

returns the state or receipt of the the zksync-tx

``` swift
public func txInfo(tx: String) -> Future<String>
```

**Parameters**

  - tx: the txHash of the send tx

#### setKey(token:)

sets the signerkey based on the current pk or as configured in the config.
You can specify the key by either

``` swift
public func setKey(token: String) -> Future<String>
```

  - setting a signer ( the sync key will be derrived through a signature )

  - setting the seed directly ( `sync_key` in the config)

  - setting the `musig_pub_keys` to generate the pubKeyHash based on them

  - setting the `create2` options and the sync-key will generate the account based on the pubKeyHash

we support 3 different signer types (`signer_type` in the `zksync` config) :

1.  `pk` - Simple Private Key
    If a signer is set (for example by setting the pk), incubed will derrive the sync-key through a signature and use it
2.  `contract` - Contract Signature
    In this case a preAuth-tx will be send on L1 using the signer. If this contract is a mutisig, you should make sure, you have set the account explicitly in the config and also activate the multisig-plugin, so the transaction will be send through the multisig.
3.  `create2` - Create2 based Contract

<!-- end list -->

**Parameters**

  - token: the token to pay the gas (either the symbol or the address)

#### pubkeyhash(pubKey:)

returns the current PubKeyHash based on the configuration set.

``` swift
public func pubkeyhash(pubKey: String? = nil) -> Future<String>
```

**Parameters**

  - pubKey: the packed public key to hash ( if given the hash is build based on the given hash, otherwise the hash is based on the config)

#### pubkey()

returns the current packed PubKey based on the config set.

``` swift
public func pubkey() -> Future<String>
```

If the config contains public keys for musig-signatures, the keys will be aggregated, otherwise the pubkey will be derrived from the signing key set.

#### accountAddress()

returns the address of the account used.

``` swift
public func accountAddress() -> Future<String>
```

#### sign(message:)

returns the schnorr musig signature based on the current config.

``` swift
public func sign(message: String) -> Future<String>
```

This also supports signing with multiple keys. In this case the configuration needs to sets the urls of the other keys, so the client can then excange all data needed in order to create the combined signature.
when exchanging the data with other keys, all known data will be send using `zk_sign` as method, but instead of the raw message a object with those data will be passed.

**Parameters**

  - message: the message to sign

#### verify(message:signature:)

returns 0 or 1 depending on the successfull verification of the signature.

``` swift
public func verify(message: String, signature: String) -> Future<String>
```

if the `musig_pubkeys` are set it will also verify against the given public keys list.

**Parameters**

  - message: the message which was supposed to be signed
  - signature: the signature (96 bytes)

#### ethopInfo(opId:)

returns the state or receipt of the the PriorityOperation

``` swift
public func ethopInfo(opId: UInt64) -> Future<String>
```

**Parameters**

  - opId: the opId of a layer-operstion (like depositing)

#### getTokenPrice(token:)

returns current token-price

``` swift
public func getTokenPrice(token: String) -> Future<String>
```

**Parameters**

  - token: Symbol or address of the token

#### getTxFee(txType:address:token:)

calculates the fees for a transaction.

``` swift
public func getTxFee(txType: String, address: String, token: String) -> Future<String>
```

**Parameters**

  - txType: The Type of the transaction "Withdraw" or "Transfer"
  - address: the address of the receipient
  - token: the symbol or address of the token to pay

#### syncKey()

returns private key used for signing zksync-transactions

``` swift
public func syncKey() -> Future<String>
```

#### deposit(amount:token:approveDepositAmountForERC20:account:)

sends a deposit-transaction and returns the opId, which can be used to tradck progress.

``` swift
public func deposit(amount: UInt64, token: String, approveDepositAmountForERC20: Bool? = nil, account: String? = nil) -> Future<String>
```

**Parameters**

  - amount: the value to deposit in wei (or smallest token unit)
  - token: the token as symbol or address
  - approveDepositAmountForERC20: if true and in case of an erc20-token, the client will send a approve transaction first, otherwise it is expected to be already approved.
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

#### transfer(to:amount:token:account:)

sends a zksync-transaction and returns data including the transactionHash.

``` swift
public func transfer(to: String, amount: UInt64, token: String, account: String? = nil) -> Future<String>
```

**Parameters**

  - to: the receipient of the tokens
  - amount: the value to transfer in wei (or smallest token unit)
  - token: the token as symbol or address
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

#### withdraw(ethAddress:amount:token:account:)

withdraws the amount to the given `ethAddress` for the given token.

``` swift
public func withdraw(ethAddress: String, amount: UInt64, token: String, account: String? = nil) -> Future<String>
```

**Parameters**

  - ethAddress: the receipient of the tokens in L1
  - amount: the value to transfer in wei (or smallest token unit)
  - token: the token as symbol or address
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

#### emergencyWithdraw(token:)

withdraws all tokens for the specified token as a onchain-transaction. This is useful in case the zksync-server is offline or tries to be malicious.

``` swift
public func emergencyWithdraw(token: String) -> Future<String>
```

**Parameters**

  - token: the token as symbol or address

#### aggregatePubkey(pubkeys:)

calculate the public key based on multiple public keys signing together using schnorr musig signatures.

``` swift
public func aggregatePubkey(pubkeys: String) -> Future<String>
```

**Parameters**

  - pubkeys: concatinated packed publickeys of the signers. the length of the bytes must be `num_keys * 32`
## Structs
### BtcProofTarget

A path of daps from the `verified_dap` to the `target_dap` which fulfils the conditions of `max_diff`, `max_dap` and `limit`. Each dap of the path is a `dap`-object with corresponding proof data.

``` swift
public struct BtcProofTarget
```



#### dap

the difficulty adjustement period

``` swift
var dap: UInt64
```

#### block

the first blockheader

``` swift
var block: String
```

#### final

the finality header

``` swift
var final: String
```

#### cbtx

the coinbase transaction as hex

``` swift
var cbtx: String
```

#### cbtxMerkleProof

the coinbasetx merkle proof

``` swift
var cbtxMerkleProof: String
```
### BtcScriptPubKey

the script pubkey

``` swift
public struct BtcScriptPubKey
```



#### asm

asm

``` swift
var asm: String
```

#### hex

hex representation of the script

``` swift
var hex: String
```

#### reqSigs

the required signatures

``` swift
var reqSigs: UInt64
```

#### type

The type, eg 'pubkeyhash'

``` swift
var type: String
```

#### addresses

Array of address(each representing a bitcoin adress)

``` swift
var addresses: [String]
```
### BtcScriptSig

the script

``` swift
public struct BtcScriptSig
```



#### asm

the asm-codes

``` swift
var asm: String
```

#### hex

hex representation

``` swift
var hex: String
```
### BtcVin

array of json objects of incoming txs to be used

``` swift
public struct BtcVin
```



#### txid

the transaction id

``` swift
var txid: String
```

#### vout

the index of the transaction out to be used

``` swift
var vout: UInt64
```

#### scriptSig

the script

``` swift
var scriptSig: BtcScriptSig
```

#### sequence

The script sequence number

``` swift
var sequence: UInt64
```

#### txinwitness

hex-encoded witness data (if any)

``` swift
var txinwitness: [String]
```
### BtcVout

array of json objects describing the tx outputs

``` swift
public struct BtcVout
```



#### value

The Value in BTC

``` swift
var value: UInt64
```

#### n

the index

``` swift
var n: UInt64
```

#### scriptPubKey

the script pubkey

``` swift
var scriptPubKey: BtcScriptPubKey
```
### Btcblock

the block.

``` swift
public struct Btcblock
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.



#### hash

the block hash (same as provided)

``` swift
var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
var confirmations: Int
```

#### height

The block height or index

``` swift
var height: UInt64
```

#### version

The block version

``` swift
var version: UInt64
```

#### versionHex

The block version formatted in hexadecimal

``` swift
var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
var mediantime: UInt64
```

#### nonce

The nonce

``` swift
var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
var bits: String
```

#### difficulty

The difficulty

``` swift
var difficulty: UInt64
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
var chainwork: UInt64
```

#### nTx

The number of transactions in the block.

``` swift
var nTx: UInt64
```

#### tx

the array of transactions either as ids (verbose=1) or full transaction (verbose=2)

``` swift
var tx: [String]
```

#### previousblockhash

The hash of the previous block

``` swift
var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
var nextblockhash: String
```
### BtcblockWithTx

the block.

``` swift
public struct BtcblockWithTx
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.



#### hash

the block hash (same as provided)

``` swift
var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
var confirmations: Int
```

#### height

The block height or index

``` swift
var height: UInt64
```

#### version

The block version

``` swift
var version: UInt64
```

#### versionHex

The block version formatted in hexadecimal

``` swift
var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
var mediantime: UInt64
```

#### nonce

The nonce

``` swift
var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
var bits: String
```

#### difficulty

The difficulty

``` swift
var difficulty: UInt64
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
var chainwork: UInt64
```

#### nTx

The number of transactions in the block.

``` swift
var nTx: UInt64
```

#### tx

the array of transactions either as ids (verbose=1) or full transaction (verbose=2)

``` swift
var tx: [Btctransaction]
```

#### previousblockhash

The hash of the previous block

``` swift
var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
var nextblockhash: String
```
### Btcblockheader

the blockheader.

``` swift
public struct Btcblockheader
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.



#### hash

the block hash (same as provided)

``` swift
var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
var confirmations: Int
```

#### height

The block height or index

``` swift
var height: UInt64
```

#### version

The block version

``` swift
var version: UInt64
```

#### versionHex

The block version formatted in hexadecimal

``` swift
var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
var mediantime: UInt64
```

#### nonce

The nonce

``` swift
var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
var bits: String
```

#### difficulty

The difficulty

``` swift
var difficulty: UInt64
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
var chainwork: UInt64
```

#### nTx

The number of transactions in the block.

``` swift
var nTx: UInt64
```

#### previousblockhash

The hash of the previous block

``` swift
var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
var nextblockhash: String
```
### Btctransaction

the array of transactions either as ids (verbose=1) or full transaction (verbose=2)

``` swift
public struct Btctransaction
```



#### txid

txid

``` swift
var txid: String
```

#### in_active_chain

Whether specified block is in the active chain or not (only present with explicit "blockhash" argument)

``` swift
var in_active_chain: Bool
```

#### hex

The serialized, hex-encoded data for `txid`

``` swift
var hex: String
```

#### hash

The transaction hash (differs from txid for witness transactions)

``` swift
var hash: String
```

#### size

The serialized transaction size

``` swift
var size: UInt64
```

#### vsize

The virtual transaction size (differs from size for witness transactions)

``` swift
var vsize: UInt64
```

#### weight

The transaction's weight (between `vsize`\*4-3 and `vsize`\*4)

``` swift
var weight: UInt64
```

#### version

The version

``` swift
var version: UInt64
```

#### locktime

The lock time

``` swift
var locktime: UInt64
```

#### vin

array of json objects of incoming txs to be used

``` swift
var vin: [BtcVin]
```

#### vout

array of json objects describing the tx outputs

``` swift
var vout: [BtcVout]
```

#### blockhash

the block hash

``` swift
var blockhash: String
```

#### confirmations

The confirmations

``` swift
var confirmations: Int
```

#### blocktime

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
var blocktime: UInt64
```

#### time

Same as "blocktime"

``` swift
var time: UInt64
```
### EthBlockdata

the blockdata, or in case the block with that number does not exist, `null` will be returned.

``` swift
public struct EthBlockdata
```



#### number

the block number. `null` when its pending block.

``` swift
var number: UInt64
```

#### hash

hash of the block. `null` when its pending block.

``` swift
var hash: String
```

#### parentHash

hash of the parent block.

``` swift
var parentHash: String
```

#### nonce

hash of the generated proof-of-work. `null` when its pending block.

``` swift
var nonce: UInt64
```

#### sha3Uncles

SHA3 of the uncles Merkle root in the block.

``` swift
var sha3Uncles: String
```

#### logsBloom

the bloom filter for the logs of the block. `null` when its pending block.

``` swift
var logsBloom: String
```

#### transactionsRoot

the root of the transaction trie of the block.

``` swift
var transactionsRoot: String
```

#### stateRoot

the root of the final state trie of the block.

``` swift
var stateRoot: String
```

#### receiptsRoot

the root of the receipts trie of the block.

``` swift
var receiptsRoot: String
```

#### miner

the address of the beneficiary to whom the mining rewards were given.

``` swift
var miner: String
```

#### difficulty

integer of the difficulty for this block.

``` swift
var difficulty: UInt64
```

#### totalDifficulty

integer of the total difficulty of the chain until this block.

``` swift
var totalDifficulty: UInt64
```

#### extraData

the "extra data" field of this block.

``` swift
var extraData: String
```

#### size

integer the size of this block in bytes.

``` swift
var size: UInt64
```

#### gasLimit

the maximum gas allowed in this block.

``` swift
var gasLimit: UInt64
```

#### gasUsed

the total used gas by all transactions in this block.

``` swift
var gasUsed: UInt64
```

#### timestamp

the unix timestamp for when the block was collated.

``` swift
var timestamp: UInt64
```

#### transactions

Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter.

``` swift
var transactions: [Transaction]
```

#### uncles

Array of uncle hashes.

``` swift
var uncles: String
```
### EthFilter

The filter criteria for the events.

``` swift
public struct EthFilter
```



#### fromBlock

Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.

``` swift
var fromBlock: UInt64?
```

#### toBlock

Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.

``` swift
var toBlock: UInt64?
```

#### address

Contract address or a list of addresses from which logs should originate.

``` swift
var address: String?
```

#### topics

Array of 32 Bytes DATA topics. Topics are order-dependent. Each topic can also be an array of DATA with “or” options.

``` swift
var topics: String?
```

#### blockhash

With the addition of EIP-234, blockHash will be a new filter option which restricts the logs returned to the single block with the 32-byte hash blockHash. Using blockHash is equivalent to fromBlock = toBlock = the block number with hash blockHash. If blockHash is present in in the filter criteria, then neither fromBlock nor toBlock are allowed.

``` swift
var blockhash: String?
```
### EthTransaction

transaction to sign

``` swift
public struct EthTransaction
```



#### to

receipient of the transaction.

``` swift
var to: String
```

#### from

sender of the address (if not sepcified, the first signer will be the sender)

``` swift
var from: String
```

#### value

value in wei to send

``` swift
var value: UInt64?
```

#### gas

the gas to be send along

``` swift
var gas: UInt64?
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
var gasPrice: UInt64?
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
var nonce: UInt64?
```

#### data

the data-section of the transaction

``` swift
var data: String?
```
### EthTx

the tx-object, which is the same as specified in [eth\_sendTransaction](https:​//eth.wiki/json-rpc/API#eth_sendTransaction).

``` swift
public struct EthTx
```



#### to

address of the contract

``` swift
var to: String
```

#### from

sender of the address

``` swift
var from: String?
```

#### value

value in wei to send

``` swift
var value: UInt64?
```

#### gas

the gas to be send along

``` swift
var gas: UInt64?
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
var gasPrice: UInt64?
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
var nonce: UInt64?
```

#### data

the data-section of the transaction, which includes the functionhash and the abi-encoded arguments

``` swift
var data: String?
```
### In3Blocks

array of requested blocks.

``` swift
public struct In3Blocks
```



#### blockNumber

the blockNumber to sign

``` swift
var blockNumber: UInt64
```

#### hash

the expected hash. This is optional and can be used to check if the expected hash is correct, but as a client you should not rely on it, but only on the hash in the signature.

``` swift
var hash: String?
```
### In3Config

The main Incubed Configuration

``` swift
public struct In3Config: Codable
```



`Codable`



#### init(chainId:finality:includeCode:maxAttempts:keepIn3:stats:useBinary:experimental:timeout:proof:replaceLatestBlock:autoUpdateList:signatureCount:bootWeights:useHttp:minDeposit:nodeProps:requestCount:rpc:nodes:zksync:key:pk:btc:)

initialize it memberwise

``` swift
public init(chainId: String? = nil, finality: UInt64? = nil, includeCode: Bool? = nil, maxAttempts: UInt64? = nil, keepIn3: Bool? = nil, stats: Bool? = nil, useBinary: Bool? = nil, experimental: Bool? = nil, timeout: UInt64? = nil, proof: String? = nil, replaceLatestBlock: UInt64? = nil, autoUpdateList: Bool? = nil, signatureCount: UInt64? = nil, bootWeights: Bool? = nil, useHttp: Bool? = nil, minDeposit: UInt64? = nil, nodeProps: UInt64? = nil, requestCount: UInt64? = nil, rpc: String? = nil, nodes: Nodes? = nil, zksync: Zksync? = nil, key: String? = nil, pk: String? = nil, btc: Btc? = nil)
```

**Parameters**

  - chainId: the chainId or the name of a known chain. It defines the nodelist to connect to.
  - finality: the number in percent needed in order reach finality (% of signature of the validators).
  - includeCode: if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth\_getCode() afterwards.
  - maxAttempts: max number of attempts in case a response is rejected.
  - keepIn3: if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did.
  - stats: if true, requests sent will be used for stats.
  - useBinary: if true the client will use binary format. This will reduce the payload of the responses by about 60% but should only be used for embedded systems or when using the API, since this format does not include the propertynames anymore.
  - experimental: iif true the client allows to use use experimental features, otherwise a exception is thrown if those would be used.
  - timeout: specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
  - proof: if true the nodes should send a proof of the response. If set to none, verification is turned off completly.
  - replaceLatestBlock: if specified, the blocknumber *latest* will be replaced by blockNumber- specified value.
  - autoUpdateList: if true the nodelist will be automaticly updated if the lastBlock is newer.
  - signatureCount: number of signatures requested in order to verify the blockhash.
  - bootWeights: if true, the first request (updating the nodelist) will also fetch the current health status and use it for blacklisting unhealthy nodes. This is used only if no nodelist is availabkle from cache.
  - useHttp: if true the client will try to use http instead of https.
  - minDeposit: min stake of the server. Only nodes owning at least this amount will be chosen.
  - nodeProps: used to identify the capabilities of the node.
  - requestCount: the number of request send in parallel when getting an answer. More request will make it more expensive, but increase the chances to get a faster answer, since the client will continue once the first verifiable response was received.
  - rpc: url of one or more direct rpc-endpoints to use. (list can be comma seperated). If this is used, proof will automaticly be turned off.
  - nodes: defining the nodelist. collection of JSON objects with chain Id (hex string) as key.
  - zksync: configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).
  - key: the client key to sign requests. (only availble if build with `-DPK_SIGNER=true` , which is on per default)
  - pk: registers raw private keys as signers for transactions. (only availble if build with `-DPK_SIGNER=true` , which is on per default)
  - btc: configure the Bitcoin verification



#### chainId

the chainId or the name of a known chain. It defines the nodelist to connect to.
(default:​ `"mainnet"`)

``` swift
var chainId: String?
```

Possible Values are:

  - `mainnet` : Mainnet Chain

  - `goerli` : Goerli Testnet

  - `ewc` : Energy WebFoundation

  - `btc` : Bitcoin

  - `ipfs` : ipfs

  - `local` : local-chain

Example: `goerli`

#### finality

the number in percent needed in order reach finality (% of signature of the validators).

``` swift
var finality: UInt64?
```

Example: `50`

#### includeCode

if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth\_getCode() afterwards.

``` swift
var includeCode: Bool?
```

Example: `true`

#### maxAttempts

max number of attempts in case a response is rejected.
(default:​ `7`)

``` swift
var maxAttempts: UInt64?
```

Example: `1`

#### keepIn3

if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did.

``` swift
var keepIn3: Bool?
```

Example: `true`

#### stats

if true, requests sent will be used for stats.
(default:​ `true`)

``` swift
var stats: Bool?
```

#### useBinary

if true the client will use binary format. This will reduce the payload of the responses by about 60% but should only be used for embedded systems or when using the API, since this format does not include the propertynames anymore.

``` swift
var useBinary: Bool?
```

Example: `true`

#### experimental

iif true the client allows to use use experimental features, otherwise a exception is thrown if those would be used.

``` swift
var experimental: Bool?
```

Example: `true`

#### timeout

specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
(default:​ `20000`)

``` swift
var timeout: UInt64?
```

Example: `100000`

#### proof

if true the nodes should send a proof of the response. If set to none, verification is turned off completly.
(default:​ `"standard"`)

``` swift
var proof: String?
```

Possible Values are:

  - `none` : no proof will be generated or verfiied. This also works with standard rpc-endpoints.

  - `standard` : Stanbdard Proof means all important properties are verfiied

  - `full` : In addition to standard, also some rarly needed properties are verfied, like uncles. But this causes a bigger payload.

Example: `none`

#### replaceLatestBlock

if specified, the blocknumber *latest* will be replaced by blockNumber- specified value.

``` swift
var replaceLatestBlock: UInt64?
```

Example: `6`

#### autoUpdateList

if true the nodelist will be automaticly updated if the lastBlock is newer.
(default:​ `true`)

``` swift
var autoUpdateList: Bool?
```

#### signatureCount

number of signatures requested in order to verify the blockhash.
(default:​ `1`)

``` swift
var signatureCount: UInt64?
```

Example: `2`

#### bootWeights

if true, the first request (updating the nodelist) will also fetch the current health status and use it for blacklisting unhealthy nodes. This is used only if no nodelist is availabkle from cache.
(default:​ `true`)

``` swift
var bootWeights: Bool?
```

Example: `true`

#### useHttp

if true the client will try to use http instead of https.

``` swift
var useHttp: Bool?
```

Example: `true`

#### minDeposit

min stake of the server. Only nodes owning at least this amount will be chosen.

``` swift
var minDeposit: UInt64?
```

Example: `10000000`

#### nodeProps

used to identify the capabilities of the node.

``` swift
var nodeProps: UInt64?
```

Example: `65535`

#### requestCount

the number of request send in parallel when getting an answer. More request will make it more expensive, but increase the chances to get a faster answer, since the client will continue once the first verifiable response was received.
(default:​ `2`)

``` swift
var requestCount: UInt64?
```

Example: `3`

#### rpc

url of one or more direct rpc-endpoints to use. (list can be comma seperated). If this is used, proof will automaticly be turned off.

``` swift
var rpc: String?
```

Example: `http://loalhost:8545`

#### nodes

defining the nodelist. collection of JSON objects with chain Id (hex string) as key.

``` swift
var nodes: Nodes?
```

Example: \`contract: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f"
nodeList:

  - address: "0x45d45e6ff99e6c34a235d263965910298985fcfe"
    url: https://in3-v2.slock.it/mainnet/nd-1
    props: "0xFFFF"\`

#### zksync

configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

``` swift
var zksync: Zksync?
```

Example:

``` 
account: "0x995628aa92d6a016da55e7de8b1727e1eb97d337"
sync_key: "0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816"
signer_type: contract
account: "0x995628aa92d6a016da55e7de8b1727e1eb97d337"
sync_key: "0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816"
signer_type: create2
create2:
  creator: "0x6487c3ae644703c1f07527c18fe5569592654bcb"
  saltarg: "0xb90306e2391fefe48aa89a8e91acbca502a94b2d734acc3335bb2ff5c266eb12"
  codehash: "0xd6af3ee91c96e29ddab0d4cb9b5dd3025caf84baad13bef7f2b87038d38251e5"
account: "0x995628aa92d6a016da55e7de8b1727e1eb97d337"
signer_type: pk
musig_pub_keys: 0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d8160x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816
sync_key: "0xe8f2ee64be83c0ab9466b0490e4888dbf5a070fd1d82b567e33ebc90457a5734"
musig_urls:
  - null
  - https://approver.service.com
```

#### key

the client key to sign requests. (only availble if build with `-DPK_SIGNER=true` , which is on per default)

``` swift
var key: String?
```

Example: `"0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"`

#### pk

registers raw private keys as signers for transactions. (only availble if build with `-DPK_SIGNER=true` , which is on per default)

``` swift
var pk: String?
```

Example:

``` 
"0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"
```

#### btc

configure the Bitcoin verification

``` swift
var btc: Btc?
```

Example: `maxDAP: 30 maxDiff: 5`



#### createClient()

create a new Incubed Client based on the Configuration

``` swift
public func createClient() throws -> In3
```
### In3Config.Btc

configure the Bitcoin verification

``` swift
public struct Btc: Codable
```



`Codable`



#### init(maxDAP:maxDiff:)

initialize it memberwise

``` swift
public init(maxDAP: UInt64? = nil, maxDiff: UInt64? = nil)
```

**Parameters**

  - maxDAP: configure the Bitcoin verification
  - maxDiff: max increase (in percent) of the difference between targets when accepting new targets.



#### maxDAP

max number of DAPs (Difficulty Adjustment Periods) allowed when accepting new targets.
(default:​ `20`)

``` swift
var maxDAP: UInt64?
```

Example: `10`

#### maxDiff

max increase (in percent) of the difference between targets when accepting new targets.
(default:​ `10`)

``` swift
var maxDiff: UInt64?
```

Example: `5`
### In3Config.Create2

create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.

``` swift
public struct Create2: Codable
```



`Codable`



#### init(creator:saltarg:codehash:)

initialize it memberwise

``` swift
public init(creator: String, saltarg: String, codehash: String)
```

**Parameters**

  - creator: create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.
  - saltarg: a salt-argument, which will be added to the pubkeyhash and create the create2-salt.
  - codehash: the hash of the actual deploy-tx including the constructor-arguments.



#### creator

The address of contract or EOA deploying the contract ( for example the GnosisSafeFactory )

``` swift
var creator: String
```

#### saltarg

a salt-argument, which will be added to the pubkeyhash and create the create2-salt.

``` swift
var saltarg: String
```

#### codehash

the hash of the actual deploy-tx including the constructor-arguments.

``` swift
var codehash: String
```
### In3Config.NodeList

manual nodeList. As Value a array of Node-Definitions is expected.

``` swift
public struct NodeList: Codable
```



`Codable`



#### init(url:address:props:)

initialize it memberwise

``` swift
public init(url: String, address: String, props: UInt64)
```

**Parameters**

  - url: manual nodeList. As Value a array of Node-Definitions is expected.
  - address: address of the node
  - props: used to identify the capabilities of the node (defaults to 0xFFFF).



#### url

URL of the node.

``` swift
var url: String
```

#### address

address of the node

``` swift
var address: String
```

#### props

used to identify the capabilities of the node (defaults to 0xFFFF).

``` swift
var props: UInt64
```
### In3Config.Nodes

defining the nodelist. collection of JSON objects with chain Id (hex string) as key.

``` swift
public struct Nodes: Codable
```



`Codable`



#### init(contract:whiteListContract:whiteList:registryId:needsUpdate:avgBlockTime:verifiedHashes:nodeList:)

initialize it memberwise

``` swift
public init(contract: String, whiteListContract: String? = nil, whiteList: String? = nil, registryId: String, needsUpdate: Bool? = nil, avgBlockTime: UInt64? = nil, verifiedHashes: [VerifiedHashes]? = nil, nodeList: [NodeList]? = nil)
```

**Parameters**

  - contract: defining the nodelist. collection of JSON objects with chain Id (hex string) as key.
  - whiteListContract: address of the whiteList contract. This cannot be combined with whiteList\!
  - whiteList: manual whitelist.
  - registryId: identifier of the registry.
  - needsUpdate: if set, the nodeList will be updated before next request.
  - avgBlockTime: average block time (seconds) for this chain.
  - verifiedHashes: if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.
  - nodeList: manual nodeList. As Value a array of Node-Definitions is expected.



#### contract

address of the registry contract. (This is the data-contract\!)

``` swift
var contract: String
```

#### whiteListContract

address of the whiteList contract. This cannot be combined with whiteList\!

``` swift
var whiteListContract: String?
```

#### whiteList

manual whitelist.

``` swift
var whiteList: String?
```

#### registryId

identifier of the registry.

``` swift
var registryId: String
```

#### needsUpdate

if set, the nodeList will be updated before next request.

``` swift
var needsUpdate: Bool?
```

#### avgBlockTime

average block time (seconds) for this chain.

``` swift
var avgBlockTime: UInt64?
```

#### verifiedHashes

if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.

``` swift
var verifiedHashes: [VerifiedHashes]?
```

#### nodeList

manual nodeList. As Value a array of Node-Definitions is expected.

``` swift
var nodeList: [NodeList]?
```
### In3Config.VerifiedHashes

if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.

``` swift
public struct VerifiedHashes: Codable
```



`Codable`



#### init(block:hash:)

initialize it memberwise

``` swift
public init(block: UInt64, hash: String)
```

**Parameters**

  - block: if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.
  - hash: verified hash corresponding to block number.



#### block

block number

``` swift
var block: UInt64
```

#### hash

verified hash corresponding to block number.

``` swift
var hash: String
```
### In3Config.Zksync

configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

``` swift
public struct Zksync: Codable
```



`Codable`



#### init(provider_url:account:sync_key:main_contract:signer_type:musig_pub_keys:musig_urls:create2:)

initialize it memberwise

``` swift
public init(provider_url: String? = nil, account: String? = nil, sync_key: String? = nil, main_contract: String? = nil, signer_type: String? = nil, musig_pub_keys: String? = nil, musig_urls: [String]? = nil, create2: Create2? = nil)
```

  - Parameter provider\_url : configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

  - Parameter sync\_key : the seed used to generate the sync\_key. This way you can explicitly set the pk instead of derriving it from a signer.

  - Parameter main\_contract : address of the main contract- If not specified it will be taken from the server.

  - Parameter signer\_type : type of the account. Must be either `pk`(default), `contract` (using contract signatures) or `create2` using the create2-section.

  - Parameter musig\_pub\_keys : concatenated packed public keys (32byte) of the musig signers. if set the pubkey and pubkeyhash will based on the aggregated pubkey. Also the signing will use multiple keys.

  - Parameter musig\_urls : a array of strings with urls based on the `musig_pub_keys`. It is used so generate the combined signature by exchaing signature data (commitment and signatureshares) if the local client does not hold this key.

**Parameters**

  - account: the account to be used. if not specified, the first signer will be used.
  - create2: create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.



#### provider_url

url of the zksync-server (if not defined it will be choosen depending on the chain)
(default:​ `"https:​//api.zksync.io/jsrpc"`)

``` swift
var provider_url: String?
```

#### account

the account to be used. if not specified, the first signer will be used.

``` swift
var account: String?
```

#### sync_key

the seed used to generate the sync\_key. This way you can explicitly set the pk instead of derriving it from a signer.

``` swift
var sync_key: String?
```

#### main_contract

address of the main contract- If not specified it will be taken from the server.

``` swift
var main_contract: String?
```

#### signer_type

type of the account. Must be either `pk`(default), `contract` (using contract signatures) or `create2` using the create2-section.
(default:​ `"pk"`)

``` swift
var signer_type: String?
```

Possible Values are:

  - `pk` : Private matching the account is used ( for EOA)

  - `contract` : Contract Signature  based EIP 1271

  - `create2` : create2 optionas are used

#### musig_pub_keys

concatenated packed public keys (32byte) of the musig signers. if set the pubkey and pubkeyhash will based on the aggregated pubkey. Also the signing will use multiple keys.

``` swift
var musig_pub_keys: String?
```

#### musig_urls

a array of strings with urls based on the `musig_pub_keys`. It is used so generate the combined signature by exchaing signature data (commitment and signatureshares) if the local client does not hold this key.

``` swift
var musig_urls: [String]?
```

#### create2

create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.

``` swift
var create2: Create2?
```
### In3Ecrecover

the extracted public key and address

``` swift
public struct In3Ecrecover
```



#### publicKey

the public Key of the signer (64 bytes)

``` swift
var publicKey: String
```

#### address

the address

``` swift
var address: String
```
### In3SignData

the signature

``` swift
public struct In3SignData
```



#### message

original message used

``` swift
var message: String
```

#### messageHash

the hash the signature is based on

``` swift
var messageHash: String
```

#### signature

the signature (65 bytes)

``` swift
var signature: String
```

#### r

the x-value of the EC-Point

``` swift
var r: String
```

#### s

the y-value of the EC-Point

``` swift
var s: String
```

#### v

the recovery value (0|1) + 27

``` swift
var v: String
```
### In3Transaction

the tx-object, which is the same as specified in [eth\_sendTransaction](https:​//eth.wiki/json-rpc/API#eth_sendTransaction).

``` swift
public struct In3Transaction
```



#### to

receipient of the transaction.

``` swift
var to: String
```

#### from

sender of the address (if not sepcified, the first signer will be the sender)

``` swift
var from: String
```

#### value

value in wei to send

``` swift
var value: UInt64?
```

#### gas

the gas to be send along

``` swift
var gas: UInt64?
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
var gasPrice: UInt64?
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
var nonce: UInt64?
```

#### data

the data-section of the transaction

``` swift
var data: String?
```
### RPCError

Error of a RPC-Request

``` swift
public struct RPCError
```



#### init(_:description:)

initializer

``` swift
public init(_ kind: Kind, description: String? = nil)
```



#### kind

the error-type

``` swift
let kind: Kind
```

#### description

the error description

``` swift
let description: String?
```
## Enums
### IncubedError

Base Incubed errors

``` swift
public enum IncubedError
```



`Error`



#### config

Configuration Error, which is only thrown within the Config or initializer of the In3

``` swift
case config(message: String)
```

#### rpc

error during rpc-execution

``` swift
case rpc(message: String)
```

#### convert

error during converting the response to a target

``` swift
case convert(message: String)
```
### RPCError.Kind

the error type

``` swift
public enum Kind
```



#### invalidMethod

invalid Method

``` swift
case invalidMethod
```

#### invalidParams

invalid Params

``` swift
case invalidParams(: String)
```

#### invalidRequest

invalid Request

``` swift
case invalidRequest(: String)
```

#### applicationError

application Error

``` swift
case applicationError(: String)
```
### RPCObject

Wrapper enum for a rpc-object, which could be different kinds

``` swift
public enum RPCObject
```



`Equatable`



#### init(_:)

Wrap a String as Value

``` swift
public init(_ value: AnyObject)
```

#### init(_:)

Wrap a String as Value

``` swift
public init(_ array: [AnyObject])
```

#### init(_:)

Wrap a String as Value

``` swift
public init(_ value: String)
```

#### init(_:)

Wrap a Integer as Value

``` swift
public init(_ value: Int)
```

#### init(_:)

Wrap a Integer as Value

``` swift
public init(_ value: UInt64)
```

#### init(_:)

Wrap a Double as Value

``` swift
public init(_ value: Double)
```

#### init(_:)

Wrap a Bool as Value

``` swift
public init(_ value: Bool)
```

#### init(_:)

Wrap a String -Array as Value

``` swift
public init(_ value: [String])
```

#### init(_:)

Wrap a Integer -Array as Value

``` swift
public init(_ value: [Int])
```

#### init(_:)

Wrap a Object with String values as Value

``` swift
public init(_ value: [String: String])
```

#### init(_:)

Wrap a Object with Integer values as Value

``` swift
public init(_ value: [String: Int])
```

#### init(_:)

Wrap a Object with RPCObject values as Value

``` swift
public init(_ value: [String: RPCObject])
```

#### init(_:)

Wrap a Array or List of RPCObjects as Value

``` swift
public init(_ value: [RPCObject])
```



#### none

a JSON `null` value.

``` swift
case none
```

#### string

a String value

``` swift
case string(: String)
```

#### integer

a Integer

``` swift
case integer(: Int)
```

#### double

a Doucle-Value

``` swift
case double(: Double)
```

#### bool

a Boolean

``` swift
case bool(: Bool)
```

#### list

a Array or List of RPC-Objects

``` swift
case list(: [RPCObject])
```

#### dictionary

a JSON-Object represented as Dictionary with properties as keys and their values as RPCObjects

``` swift
case dictionary(: [String: RPCObject])
```
### RequestResult

result of a RPC-Request

``` swift
public enum RequestResult
```



#### success

success full respons with the data as result.

``` swift
case success(_ data: RPCObject)
```

#### error

failed request with the msg describiung the error

``` swift
case error(_ msg: String)
```
### TransportResult

the result of a Transport operation.
it will only be used internally to report the time and http-status of the response, before verifying the result.

``` swift
public enum TransportResult
```



#### success

successful response

``` swift
case success(_ data: Data, _ time: Int)
```

**Parameters**

  - data: the raw data
  - time: the time in milliseconds to execute the request

#### error

failed response

``` swift
case error(_ msg: String, _ httpStatus: Int)
```

**Parameters**

  - msg: the error-message
  - httpStatus: the http status code
## Interfaces
### In3Cache

Protocol for Cache-Implementation.
The cache is used to store data like nodelists and their reputations, contract codes and more.
those calls a synchronous calls and should be fast.
in order to set the cache, use the `In3.cache`-property.

``` swift
public protocol In3Cache
```



#### getEntry(key:​)

find the data for the given cache-key or `nil`if not found.

``` swift
func getEntry(key: String) -> Data?
```

#### setEntry(key:​value:​)

write the data to the cache using the given key..

``` swift
func setEntry(key: String, value: Data) -> Void
```

#### clear()

clears all cache entries

``` swift
func clear() -> Void
```
