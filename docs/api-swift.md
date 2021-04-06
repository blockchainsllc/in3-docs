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



### Eth

Ethereum API
a collection of ethereum-specific functions.

``` swift
public class Eth
```



#### `blockNumber()`

returns the current blockNumber

``` swift
public func blockNumber() -> Future<UInt64>
```

#### `getTransactionReceipt(hash:)`

returns the TransactionReceipt for the given transsaction hash

``` swift
public func getTransactionReceipt(hash: String) -> Future<EthTransactionReceipt?>
```

  - Paramater hash : the transaction hash
    the result is an optional value depending on the existence of such a Receipt.
### EthTransactionReceipt

a TransactionReceipt

``` swift
public struct EthTransactionReceipt
```



#### `hash`

the transactionhash

``` swift
var hash: String
```
### FileCache

File-Implementation for the cache.

``` swift
public class FileCache: In3Cache
```



[`In3Cache`](/In3Cache)



#### `setEntry(key:value:)`

write the data to the cache using the given key..

``` swift
public func setEntry(key: String, value: Data)
```

#### `getEntry(key:)`

find the data for the given cache-key or `nil`if not found.

``` swift
public func getEntry(key: String) -> Data?
```

#### `clear()`

clears all cache entries

``` swift
public func clear()
```
### Future

``` swift
public class Future<Value>
```



#### `Result`

``` swift
public typealias Result = Swift.Result<Value, Error>
```



#### `observe(using:)`

``` swift
public func observe(using callback: @escaping (Result) -> Void)
```
### In3

The I ncubed client

``` swift
public class In3
```



#### `init(_:)`

``` swift
public init(_ config: In3Config) throws
```



#### `transport`

the transport function

``` swift
var transport: (_ url: String, _ method:String, _ payload:Data?, _ headers: [String], _ cb: @escaping (_ data:TransportResult)->Void) -> Void
```



#### `configure(_:)`

``` swift
public func configure(_ config: In3Config) throws
```

#### `execLocal(_:_:)`

Execute a request directly and local.
This works only for requests which do not need to be send to a server.

``` swift
public func execLocal(_ method: String, _ params: RPCObject) throws -> RPCObject
```

#### `exec(_:_:cb:)`

``` swift
public func exec(_ method: String, _ params: RPCObject, cb: @escaping  (_ result:RequestResult)->Void) throws
```

#### `executeJSON(_:)`

``` swift
public func executeJSON(_ rpc: String) -> String
```
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
### In3Config

The main Incubed Configuration

``` swift
public struct In3Config: Codable
```



`Codable`



#### `init(chainId:finality:includeCode:maxAttempts:keepIn3:stats:useBinary:experimental:timeout:proof:replaceLatestBlock:autoUpdateList:signatureCount:bootWeights:useHttp:minDeposit:nodeProps:requestCount:rpc:nodes:zksync:key:pk:btc:)`

initialize it memberwise

``` swift
public init(chainId: String? = nil, finality: UInt64? = nil, includeCode: Bool? = nil, maxAttempts: UInt64? = nil, keepIn3: Bool? = nil, stats: Bool? = nil, useBinary: Bool? = nil, experimental: Bool? = nil, timeout: UInt64? = nil, proof: String? = nil, replaceLatestBlock: UInt64? = nil, autoUpdateList: Bool? = nil, signatureCount: UInt64? = nil, bootWeights: Bool? = nil, useHttp: Bool? = nil, minDeposit: UInt64? = nil, nodeProps: UInt64? = nil, requestCount: UInt64? = nil, rpc: String? = nil, nodes: Nodes? = nil, zksync: Zksync? = nil, key: String? = nil, pk: String? = nil, btc: Btc? = nil)
```

#### Parameters

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



#### `chainId`

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

#### `finality`

the number in percent needed in order reach finality (% of signature of the validators).

``` swift
var finality: UInt64?
```

Example: `50`

#### `includeCode`

if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth\_getCode() afterwards.

``` swift
var includeCode: Bool?
```

Example: `true`

#### `maxAttempts`

max number of attempts in case a response is rejected.
(default:​ `7`)

``` swift
var maxAttempts: UInt64?
```

Example: `1`

#### `keepIn3`

if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did.

``` swift
var keepIn3: Bool?
```

Example: `true`

#### `stats`

if true, requests sent will be used for stats.
(default:​ `true`)

``` swift
var stats: Bool?
```

#### `useBinary`

if true the client will use binary format. This will reduce the payload of the responses by about 60% but should only be used for embedded systems or when using the API, since this format does not include the propertynames anymore.

``` swift
var useBinary: Bool?
```

Example: `true`

#### `experimental`

iif true the client allows to use use experimental features, otherwise a exception is thrown if those would be used.

``` swift
var experimental: Bool?
```

Example: `true`

#### `timeout`

specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
(default:​ `20000`)

``` swift
var timeout: UInt64?
```

Example: `100000`

#### `proof`

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

#### `replaceLatestBlock`

if specified, the blocknumber *latest* will be replaced by blockNumber- specified value.

``` swift
var replaceLatestBlock: UInt64?
```

Example: `6`

#### `autoUpdateList`

if true the nodelist will be automaticly updated if the lastBlock is newer.
(default:​ `true`)

``` swift
var autoUpdateList: Bool?
```

#### `signatureCount`

number of signatures requested in order to verify the blockhash.
(default:​ `1`)

``` swift
var signatureCount: UInt64?
```

Example: `2`

#### `bootWeights`

if true, the first request (updating the nodelist) will also fetch the current health status and use it for blacklisting unhealthy nodes. This is used only if no nodelist is availabkle from cache.
(default:​ `true`)

``` swift
var bootWeights: Bool?
```

Example: `true`

#### `useHttp`

if true the client will try to use http instead of https.

``` swift
var useHttp: Bool?
```

Example: `true`

#### `minDeposit`

min stake of the server. Only nodes owning at least this amount will be chosen.

``` swift
var minDeposit: UInt64?
```

Example: `10000000`

#### `nodeProps`

used to identify the capabilities of the node.

``` swift
var nodeProps: UInt64?
```

Example: `65535`

#### `requestCount`

the number of request send in parallel when getting an answer. More request will make it more expensive, but increase the chances to get a faster answer, since the client will continue once the first verifiable response was received.
(default:​ `2`)

``` swift
var requestCount: UInt64?
```

Example: `3`

#### `rpc`

url of one or more direct rpc-endpoints to use. (list can be comma seperated). If this is used, proof will automaticly be turned off.

``` swift
var rpc: String?
```

Example: `http://loalhost:8545`

#### `nodes`

defining the nodelist. collection of JSON objects with chain Id (hex string) as key.

``` swift
var nodes: Nodes?
```

Example: \`contract: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f"
nodeList:

  - address: "0x45d45e6ff99e6c34a235d263965910298985fcfe"
    url: https://in3-v2.slock.it/mainnet/nd-1
    props: "0xFFFF"\`

#### `zksync`

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

#### `key`

the client key to sign requests. (only availble if build with `-DPK_SIGNER=true` , which is on per default)

``` swift
var key: String?
```

Example: `"0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"`

#### `pk`

registers raw private keys as signers for transactions. (only availble if build with `-DPK_SIGNER=true` , which is on per default)

``` swift
var pk: String?
```

Example:

``` 
"0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"
```

#### `btc`

configure the Bitcoin verification

``` swift
var btc: Btc?
```

Example: `maxDAP: 30 maxDiff: 5`



#### `createClient()`

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



#### `init(maxDAP:maxDiff:)`

initialize it memberwise

``` swift
public init(maxDAP: UInt64? = nil, maxDiff: UInt64? = nil)
```

#### Parameters

  - maxDAP: configure the Bitcoin verification
  - maxDiff: max increase (in percent) of the difference between targets when accepting new targets.



#### `maxDAP`

max number of DAPs (Difficulty Adjustment Periods) allowed when accepting new targets.
(default:​ `20`)

``` swift
var maxDAP: UInt64?
```

Example: `10`

#### `maxDiff`

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



#### `init(creator:saltarg:codehash:)`

initialize it memberwise

``` swift
public init(creator: String, saltarg: String, codehash: String)
```

#### Parameters

  - creator: create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.
  - saltarg: a salt-argument, which will be added to the pubkeyhash and create the create2-salt.
  - codehash: the hash of the actual deploy-tx including the constructor-arguments.



#### `creator`

The address of contract or EOA deploying the contract ( for example the GnosisSafeFactory )

``` swift
var creator: String
```

#### `saltarg`

a salt-argument, which will be added to the pubkeyhash and create the create2-salt.

``` swift
var saltarg: String
```

#### `codehash`

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



#### `init(url:address:props:)`

initialize it memberwise

``` swift
public init(url: String, address: String, props: UInt64)
```

#### Parameters

  - url: manual nodeList. As Value a array of Node-Definitions is expected.
  - address: address of the node
  - props: used to identify the capabilities of the node (defaults to 0xFFFF).



#### `url`

URL of the node.

``` swift
var url: String
```

#### `address`

address of the node

``` swift
var address: String
```

#### `props`

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



#### `init(contract:whiteListContract:whiteList:registryId:needsUpdate:avgBlockTime:verifiedHashes:nodeList:)`

initialize it memberwise

``` swift
public init(contract: String, whiteListContract: String? = nil, whiteList: String? = nil, registryId: String, needsUpdate: Bool? = nil, avgBlockTime: UInt64? = nil, verifiedHashes: [VerifiedHashes]? = nil, nodeList: [NodeList]? = nil)
```

#### Parameters

  - contract: defining the nodelist. collection of JSON objects with chain Id (hex string) as key.
  - whiteListContract: address of the whiteList contract. This cannot be combined with whiteList\!
  - whiteList: manual whitelist.
  - registryId: identifier of the registry.
  - needsUpdate: if set, the nodeList will be updated before next request.
  - avgBlockTime: average block time (seconds) for this chain.
  - verifiedHashes: if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.
  - nodeList: manual nodeList. As Value a array of Node-Definitions is expected.



#### `contract`

address of the registry contract. (This is the data-contract\!)

``` swift
var contract: String
```

#### `whiteListContract`

address of the whiteList contract. This cannot be combined with whiteList\!

``` swift
var whiteListContract: String?
```

#### `whiteList`

manual whitelist.

``` swift
var whiteList: String?
```

#### `registryId`

identifier of the registry.

``` swift
var registryId: String
```

#### `needsUpdate`

if set, the nodeList will be updated before next request.

``` swift
var needsUpdate: Bool?
```

#### `avgBlockTime`

average block time (seconds) for this chain.

``` swift
var avgBlockTime: UInt64?
```

#### `verifiedHashes`

if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.

``` swift
var verifiedHashes: [VerifiedHashes]?
```

#### `nodeList`

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



#### `init(block:hash:)`

initialize it memberwise

``` swift
public init(block: UInt64, hash: String)
```

#### Parameters

  - block: if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.
  - hash: verified hash corresponding to block number.



#### `block`

block number

``` swift
var block: UInt64
```

#### `hash`

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



#### `init(provider_url:account:sync_key:main_contract:signer_type:musig_pub_keys:musig_urls:create2:)`

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

#### Parameters

  - account: the account to be used. if not specified, the first signer will be used.
  - create2: create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.



#### `provider_url`

url of the zksync-server (if not defined it will be choosen depending on the chain)
(default:​ `"https:​//api.zksync.io/jsrpc"`)

``` swift
var provider_url: String?
```

#### `account`

the account to be used. if not specified, the first signer will be used.

``` swift
var account: String?
```

#### `sync_key`

the seed used to generate the sync\_key. This way you can explicitly set the pk instead of derriving it from a signer.

``` swift
var sync_key: String?
```

#### `main_contract`

address of the main contract- If not specified it will be taken from the server.

``` swift
var main_contract: String?
```

#### `signer_type`

type of the account. Must be either `pk`(default), `contract` (using contract signatures) or `create2` using the create2-section.
(default:​ `"pk"`)

``` swift
var signer_type: String?
```

Possible Values are:

  - `pk` : Private matching the account is used ( for EOA)

  - `contract` : Contract Signature  based EIP 1271

  - `create2` : create2 optionas are used

#### `musig_pub_keys`

concatenated packed public keys (32byte) of the musig signers. if set the pubkey and pubkeyhash will based on the aggregated pubkey. Also the signing will use multiple keys.

``` swift
var musig_pub_keys: String?
```

#### `musig_urls`

a array of strings with urls based on the `musig_pub_keys`. It is used so generate the combined signature by exchaing signature data (commitment and signatureshares) if the local client does not hold this key.

``` swift
var musig_urls: [String]?
```

#### `create2`

create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.

``` swift
var create2: Create2?
```
### IncubedError

Base Incubed errors

``` swift
public enum IncubedError
```



`Error`



#### `config`

Configuration Error, which is only thrown within the Config or initializer of the In3

``` swift
case config(message: String)
```

#### `rpc`

error during rpc-execution

``` swift
case rpc(message: String)
```

#### `convert`

error during converting the response to a target

``` swift
case convert(message: String)
```
### Promise

``` swift
public class Promise<Value>: Future<Value>
```



`Future<Value>`



#### `resolve(with:)`

``` swift
public func resolve(with value: Value)
```

#### `reject(with:)`

``` swift
public func reject(with error: Error)
```
### RPCError

Error of a RPC-Request

``` swift
public struct RPCError
```



#### `init(_:description:)`

initializer

``` swift
public init(_ kind: Kind, description: String? = nil)
```



#### `kind`

the error-type

``` swift
let kind: Kind
```

#### `description`

the error description

``` swift
let description: String?
```
### RPCError.Kind

the error type

``` swift
public enum Kind
```



#### `invalidMethod`

invalid Method

``` swift
case invalidMethod
```

#### `invalidParams`

invalid Params

``` swift
case invalidParams(: String)
```

#### `invalidRequest`

invalid Request

``` swift
case invalidRequest(: String)
```

#### `applicationError`

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



#### `init(_:)`

Wrap a String as Value

``` swift
public init(_ value: String)
```

#### `init(_:)`

Wrap a Integer as Value

``` swift
public init(_ value: Int)
```

#### `init(_:)`

Wrap a Double as Value

``` swift
public init(_ value: Double)
```

#### `init(_:)`

Wrap a Bool as Value

``` swift
public init(_ value: Bool)
```

#### `init(_:)`

Wrap a String -Array as Value

``` swift
public init(_ value: [String])
```

#### `init(_:)`

Wrap a Integer -Array as Value

``` swift
public init(_ value: [Int])
```

#### `init(_:)`

Wrap a Object with String values as Value

``` swift
public init(_ value: [String: String])
```

#### `init(_:)`

Wrap a Object with Integer values as Value

``` swift
public init(_ value: [String: Int])
```

#### `init(_:)`

Wrap a Object with RPCObject values as Value

``` swift
public init(_ value: [String: RPCObject])
```

#### `init(_:)`

Wrap a Array or List of RPCObjects as Value

``` swift
public init(_ value: [RPCObject])
```



#### `none`

a JSON `null` value.

``` swift
case none
```

#### `string`

a String value

``` swift
case string(: String)
```

#### `integer`

a Integer

``` swift
case integer(: Int)
```

#### `double`

a Doucle-Value

``` swift
case double(: Double)
```

#### `bool`

a Boolean

``` swift
case bool(: Bool)
```

#### `list`

a Array or List of RPC-Objects

``` swift
case list(: [RPCObject])
```

#### `dictionary`

a JSON-Object represented as Dictionary with properties as keys and their values as RPCObjects

``` swift
case dictionary(: [String: RPCObject])
```
### RequestResult

result of a RPC-Request

``` swift
public enum RequestResult
```



#### `success`

success full respons with the data as result.

``` swift
case success(_ data: RPCObject)
```

#### `error`

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



#### `success`

successful response

``` swift
case success(_ data: Data, _ time: Int)
```

#### Parameters

  - data: the raw data
  - time: the time in milliseconds to execute the request

#### `error`

failed response

``` swift
case error(_ msg: String, _ httpStatus: Int)
```

#### Parameters

  - msg: the error-message
  - httpStatus: the http status code
