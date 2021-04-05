# Configuration


When creating a new Incubed Instance you can configure it. The Configuration depends on the registered plugins. This page describes the available configuration parameters.



## chainId

the chainId or the name of a known chain. It defines the nodelist to connect to. *This config is optional.* (default: `"mainnet"`)

 Type: `string | uint`

Possible Values are:

- `mainnet` : Mainnet Chain
- `goerli` : Goerli Testnet
- `ewc` : Energy WebFoundation
- `btc` : Bitcoin
- `ipfs` : ipfs
- `local` : local-chain


*Example:*

```sh
> in3 -c goerli  ....
> in3 --chainId=goerli  ....

```

```js
const in3 = new IN3({
  "chainId": "goerli"
})
```


## finality

the number in percent needed in order reach finality (% of signature of the validators). *This config is optional.*

 Type: `uint | string`

*Example:*

```sh
> in3 -f 50  ....
> in3 --finality=50  ....

```

```js
const in3 = new IN3({
  "finality": 50
})
```


## includeCode

if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards. *This config is optional.*

 Type: `bool`

*Example:*

```sh
> in3 --includeCode  ....

```

```js
const in3 = new IN3({
  "includeCode": true
})
```


## maxAttempts

max number of attempts in case a response is rejected. *This config is optional.* (default: `7`)

 Type: `uint`

*Example:*

```sh
> in3 -a 1  ....
> in3 --maxAttempts=1  ....

```

```js
const in3 = new IN3({
  "maxAttempts": 1
})
```


## keepIn3

if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did. *This config is optional.*

 Type: `bool`

*Example:*

```sh
> in3 -kin3  ....
> in3 --keepIn3  ....

```

```js
const in3 = new IN3({
  "keepIn3": true
})
```


## stats

if true, requests sent will be used for stats. *This config is optional.* (default: `true`)

 Type: `bool`

*Example:*

```sh
> in3 --stats=false  ....

```

```js
const in3 = new IN3({
  "stats": false
})
```


## useBinary

if true the client will use binary format. This will reduce the payload of the responses by about 60% but should only be used for embedded systems or when using the API, since this format does not include the propertynames anymore. *This config is optional.*

 Type: `bool`

*Example:*

```sh
> in3 --useBinary  ....

```

```js
const in3 = new IN3({
  "useBinary": true
})
```


## experimental

iif true the client allows to use use experimental features, otherwise a exception is thrown if those would be used. *This config is optional.*

 Type: `bool`

*Example:*

```sh
> in3 -x  ....
> in3 --experimental  ....

```

```js
const in3 = new IN3({
  "experimental": true
})
```


## timeout

specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection. *This config is optional.* (default: `20000`)

 Type: `uint`

*Example:*

```sh
> in3 --timeout=100000  ....

```

```js
const in3 = new IN3({
  "timeout": 100000
})
```


## proof

if true the nodes should send a proof of the response. If set to none, verification is turned off completly. *This config is optional.* (default: `"standard"`)

 Type: `string`

Possible Values are:

- `none` : no proof will be generated or verfiied. This also works with standard rpc-endpoints.
- `standard` : Stanbdard Proof means all important properties are verfiied
- `full` : In addition to standard, also some rarly needed properties are verfied, like uncles. But this causes a bigger payload.


*Example:*

```sh
> in3 -p none  ....
> in3 --proof=none  ....

```

```js
const in3 = new IN3({
  "proof": "none"
})
```


## replaceLatestBlock

if specified, the blocknumber *latest* will be replaced by blockNumber- specified value. *This config is optional.*

 Type: `uint`

*Example:*

```sh
> in3 -l 6  ....
> in3 --replaceLatestBlock=6  ....

```

```js
const in3 = new IN3({
  "replaceLatestBlock": 6
})
```


## autoUpdateList

if true the nodelist will be automaticly updated if the lastBlock is newer. *This config is optional.* (default: `true`)

 Type: `bool`

*Example:*

```sh
> in3 --autoUpdateList=false  ....

```

```js
const in3 = new IN3({
  "autoUpdateList": false
})
```


## signatureCount

number of signatures requested in order to verify the blockhash. *This config is optional.* (default: `1`)

 Type: `uint`

*Example:*

```sh
> in3 -s 2  ....
> in3 --signatureCount=2  ....

```

```js
const in3 = new IN3({
  "signatureCount": 2
})
```


## bootWeights

if true, the first request (updating the nodelist) will also fetch the current health status and use it for blacklisting unhealthy nodes. This is used only if no nodelist is availabkle from cache. *This config is optional.* (default: `true`)

 Type: `bool`

*Example:*

```sh
> in3 -bw  ....
> in3 --bootWeights  ....

```

```js
const in3 = new IN3({
  "bootWeights": true
})
```


## useHttp

if true the client will try to use http instead of https. *This config is optional.*

 Type: `bool`

*Example:*

```sh
> in3 --useHttp  ....

```

```js
const in3 = new IN3({
  "useHttp": true
})
```


## minDeposit

min stake of the server. Only nodes owning at least this amount will be chosen. *This config is optional.*

 Type: `uint`

*Example:*

```sh
> in3 --minDeposit=10000000  ....

```

```js
const in3 = new IN3({
  "minDeposit": 10000000
})
```


## nodeProps

used to identify the capabilities of the node. *This config is optional.*

 Type: `uint`

*Example:*

```sh
> in3 --nodeProps=65535  ....

```

```js
const in3 = new IN3({
  "nodeProps": 65535
})
```


## requestCount

the number of request send in parallel when getting an answer. More request will make it more expensive, but increase the chances to get a faster answer, since the client will continue once the first verifiable response was received. *This config is optional.* (default: `2`)

 Type: `uint`

*Example:*

```sh
> in3 -rc 3  ....
> in3 --requestCount=3  ....

```

```js
const in3 = new IN3({
  "requestCount": 3
})
```


## rpc

url of one or more direct rpc-endpoints to use. (list can be comma seperated). If this is used, proof will automaticly be turned off. *This config is optional.*

 Type: `string`

*Example:*

```sh
> in3 --rpc=http://loalhost:8545  ....

```

```js
const in3 = new IN3({
  "rpc": "http://loalhost:8545"
})
```


## nodes

defining the nodelist. collection of JSON objects with chain Id (hex string) as key. *This config is optional.*

 Type: `object`
The nodes object supports the following properties :

* **contract** : `address` - address of the registry contract. (This is the data-contract!)


* **whiteListContract** : `address` *(optional)* - address of the whiteList contract. This cannot be combined with whiteList!


* **whiteList** : `address[]` *(optional)* - manual whitelist.


* **registryId** : `bytes32` - identifier of the registry.


* **needsUpdate** : `bool` *(optional)* - if set, the nodeList will be updated before next request.


* **avgBlockTime** : `uint` *(optional)* - average block time (seconds) for this chain.


* **verifiedHashes** : `object` *(optional)* - if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.
    * **block** : `uint` - block number
    

    * **hash** : `bytes32` - verified hash corresponding to block number.
    



* **nodeList** : `object` *(optional)* - manual nodeList. As Value a array of Node-Definitions is expected.
    * **url** : `string` - URL of the node.
    

    * **address** : `string` - address of the node
    

    * **props** : `uint` - used to identify the capabilities of the node (defaults to 0xFFFF).
    




*Example:*

```sh
> in3 --nodes.contract=0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f  ....

```

```js
const in3 = new IN3({
  "nodes": {
    "contract": "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f",
    "nodeList": [
      {
        "address": "0x45d45e6ff99e6c34a235d263965910298985fcfe",
        "url": "https://in3-v2.slock.it/mainnet/nd-1",
        "props": "0xFFFF"
      }
    ]
  }
})
```


## zksync

configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

 Type: `object`
The zksync object supports the following properties :

* **provider_url** : `string` *(optional)* - url of the zksync-server (if not defined it will be choosen depending on the chain) (default: `"https://api.zksync.io/jsrpc"`)


* **account** : `address` *(optional)* - the account to be used. if not specified, the first signer will be used.


* **sync_key** : `bytes32` *(optional)* - the seed used to generate the sync_key. This way you can explicitly set the pk instead of derriving it from a signer.


* **main_contract** : `address` *(optional)* - address of the main contract- If not specified it will be taken from the server.


* **signer_type** : `string` *(optional)* - type of the account. Must be either `pk`(default), `contract` (using contract signatures) or `create2` using the create2-section. (default: `"pk"`)
Possible Values are:

    - `pk` : Private matching the account is used ( for EOA)
    - `contract` : Contract Signature  based EIP 1271
    - `create2` : create2 optionas are used



* **musig_pub_keys** : `bytes` *(optional)* - concatenated packed public keys (32byte) of the musig signers. if set the pubkey and pubkeyhash will based on the aggregated pubkey. Also the signing will use multiple keys.


* **musig_urls** : `string[]` *(optional)* - a array of strings with urls based on the `musig_pub_keys`. It is used so generate the combined signature by exchaing signature data (commitment and signatureshares) if the local client does not hold this key.


* **create2** : `object` *(optional)* - create2-arguments for sign_type `create2`. This will allow to sign for contracts which are not deployed yet.
    * **creator** : `address` - The address of contract or EOA deploying the contract ( for example the GnosisSafeFactory )
    

    * **saltarg** : `bytes32` - a salt-argument, which will be added to the pubkeyhash and create the create2-salt.
    

    * **codehash** : `bytes32` - the hash of the actual deploy-tx including the constructor-arguments.
    




*Example:*

```sh
> in3 --zksync.account=0x995628aa92d6a016da55e7de8b1727e1eb97d337 --zksync.sync_key=0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816 --zksync.signer_type=contract  ....

```

```js
const in3 = new IN3({
  "zksync": {
    "account": "0x995628aa92d6a016da55e7de8b1727e1eb97d337",
    "sync_key": "0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816",
    "signer_type": "contract"
  }
})
```

```sh
> in3 --zksync.account=0x995628aa92d6a016da55e7de8b1727e1eb97d337 --zksync.sync_key=0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816 --zksync.signer_type=create2  ....

```

```js
const in3 = new IN3({
  "zksync": {
    "account": "0x995628aa92d6a016da55e7de8b1727e1eb97d337",
    "sync_key": "0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816",
    "signer_type": "create2",
    "create2": {
      "creator": "0x6487c3ae644703c1f07527c18fe5569592654bcb",
      "saltarg": "0xb90306e2391fefe48aa89a8e91acbca502a94b2d734acc3335bb2ff5c266eb12",
      "codehash": "0xd6af3ee91c96e29ddab0d4cb9b5dd3025caf84baad13bef7f2b87038d38251e5"
    }
  }
})
```

```sh
> in3 --zksync.account=0x995628aa92d6a016da55e7de8b1727e1eb97d337 --zksync.signer_type=pk --zksync.musig_pub_keys=0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d8160x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816 --zksync.sync_key=0xe8f2ee64be83c0ab9466b0490e4888dbf5a070fd1d82b567e33ebc90457a5734  ....

```

```js
const in3 = new IN3({
  "zksync": {
    "account": "0x995628aa92d6a016da55e7de8b1727e1eb97d337",
    "signer_type": "pk",
    "musig_pub_keys": "0x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d8160x9ad89ac0643ffdc32b2dab859ad0f9f7e4057ec23c2b17699c9b27eff331d816",
    "sync_key": "0xe8f2ee64be83c0ab9466b0490e4888dbf5a070fd1d82b567e33ebc90457a5734",
    "musig_urls": [
      null,
      "https://approver.service.com"
    ]
  }
})
```


## key

the client key to sign requests. (only availble if build with `-DPK_SIGNER=true` , which is on per default) *This config is optional.*

 Type: `bytes32`

*Example:*

```sh
> in3 -k 0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe  ....
> in3 --key=0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe  ....

```

```js
const in3 = new IN3({
  "key": "0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"
})
```


## pk

registers raw private keys as signers for transactions. (only availble if build with `-DPK_SIGNER=true` , which is on per default) *This config is optional.*

 Type: `bytes32|bytes32[]`

*Example:*

```sh
> in3 -pk 0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe  ....
> in3 --pk=0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe  ....

```

```js
const in3 = new IN3({
  "pk": "0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"
})
```


## btc

configure the Bitcoin verification

 Type: `object`
The btc object supports the following properties :

* **maxDAP** : `uint` *(optional)* - max number of DAPs (Difficulty Adjustment Periods) allowed when accepting new targets. (default: `20`)


* **maxDiff** : `uint` *(optional)* - max increase (in percent) of the difference between targets when accepting new targets. (default: `10`)



*Example:*

```sh
> in3 --btc.maxDAP=30 --btc.maxDiff=5  ....

```

```js
const in3 = new IN3({
  "btc": {
    "maxDAP": 30,
    "maxDiff": 5
  }
})
```


## cmdline options

Those special options are used in the comandline client to pass additional options.



### clearCache

clears the cache before performing any operation.

 Type: `bool`

*Example:*

```sh
> in3 -ccache  ....
> in3 --clearCache  ....

```


### eth

converts the result (as wei) to ether.

 Type: `bool`

*Example:*

```sh
> in3 -e  ....
> in3 --eth  ....

```


### port

if specified it will run as http-server listening to the given port.

 Type: `uint`

*Example:*

```sh
> in3 -port 8545  ....
> in3 --port=8545  ....

```


### allowed-methods

only works if port is specified and declares a comma-seperated list of rpc-methods which are allowed. All other will be rejected.

 Type: `string`

*Example:*

```sh
> in3 -am eth_sign,eth_blockNumber  ....
> in3 --allowed-methods=eth_sign,eth_blockNumber  ....

```


### block

the blocknumber to use when making calls. could be either latest (default),earliest or a hexnumbner

 Type: `uint`

*Example:*

```sh
> in3 -b latest  ....
> in3 --block=latest  ....

```


### to

the target address of the call

 Type: `address`

*Example:*

```sh
> in3 -to 0x7d1c10184fa178ebb5b10a9aa6230a255c5c59f6  ....
> in3 --to=0x7d1c10184fa178ebb5b10a9aa6230a255c5c59f6  ....

```


### from

the sender of a call or tx (only needed if no signer is registered)

 Type: `address`

*Example:*

```sh
> in3 -from 0x7d1c10184fa178ebb5b10a9aa6230a255c5c59f6  ....
> in3 --from=0x7d1c10184fa178ebb5b10a9aa6230a255c5c59f6  ....

```


### data

the data for a transaction. This can be a filepath, a 0x-hexvalue or - for stdin.

 Type: `bytes`

*Example:*

```sh
> in3 -d 0x7d1c101  ....
> in3 --data=0x7d1c101  ....

```


### gas_price

the gas price to use when sending transactions. (default: use eth_gasPrice)

 Type: `uint`

*Example:*

```sh
> in3 -gp 1000000000000  ....
> in3 --gas_price=1000000000000  ....

```


### gas

the gas limit to use when sending transactions. (default: 100000)

 Type: `uint`

*Example:*

```sh
> in3 -gas 100000  ....
> in3 --gas=100000  ....

```


### nonce

the nonce. (default: will be fetched useing eth_getTransactionCount)

 Type: `uint`

*Example:*

```sh
> in3 -nonce 2  ....
> in3 --nonce=2  ....

```


### test

creates a new json-test written to stdout with the name as specified.

 Type: `string`

*Example:*

```sh
> in3 -test test_blockNumber  ....
> in3 --test=test_blockNumber  ....

```


### path

the HD wallet derivation path . We can pass in simplified way as hex string  i.e [44,60,00,00,00] => 0x2c3c000000

 Type: `string`

*Example:*

```sh
> in3 -path 0x2c3c000000  ....
> in3 --path=0x2c3c000000  ....

```


### sigtype

the type of the signature data. (default: `"raw"`)

 Type: `string`

Possible Values are:

- `raw` : hash the raw data
- `hash` : use the already hashed data
- `eth_sign` : use the prefix and hash it


*Example:*

```sh
> in3 -st hash  ....
> in3 --sigtype=hash  ....

```


### password

password to unlock the key

 Type: `string`

*Example:*

```sh
> in3 -pwd MYPASSWORD  ....
> in3 --password=MYPASSWORD  ....

```


### value

the value to send when sending a transaction. can be hexvalue or a float/integer with the suffix eth or wei like 1.8eth (default: 0)

 Type: `uint`

*Example:*

```sh
> in3 -value 0.2eth  ....
> in3 --value=0.2eth  ....

```


### wait

if given, instead returning the transaction, it will wait until the transaction is mined and return the transactionreceipt.

 Type: `bool`

*Example:*

```sh
> in3 -w  ....
> in3 --wait  ....

```


### json

if given the result will be returned as json, which is especially important for eth_call results with complex structres.

 Type: `bool`

*Example:*

```sh
> in3 -json  ....
> in3 --json  ....

```


### hex

if given the result will be returned as hex.

 Type: `bool`

*Example:*

```sh
> in3 -hex  ....
> in3 --hex  ....

```


### debug

if given incubed will output debug information when executing.

 Type: `bool`

*Example:*

```sh
> in3 -debug  ....
> in3 --debug  ....

```


### quiet

quiet. no additional output.

 Type: `bool`

*Example:*

```sh
> in3 -q  ....
> in3 --quiet  ....

```


### human

human readable, which removes the json -structure and oly displays the values.

 Type: `bool`

*Example:*

```sh
> in3 -h  ....
> in3 --human  ....

```


### test-request

runs test request when showing in3_weights

 Type: `bool`

*Example:*

```sh
> in3 -tr  ....
> in3 --test-request  ....

```


### test-health-request

runs test request including health-check when showing in3_weights

 Type: `bool`

*Example:*

```sh
> in3 -thr  ....
> in3 --test-health-request  ....

```


### multisig

adds a multisig as signer this needs to be done in the right order! (first the pk then the multisaig(s) )

 Type: `address`

*Example:*

```sh
> in3 -ms 0x7d1c10184fa178ebb5b10a9aa6230a255c5c59f6  ....
> in3 --multisig=0x7d1c10184fa178ebb5b10a9aa6230a255c5c59f6  ....

```


### ms.signatures

add additional signatures, which will be useds when sending through a multisig!

 Type: `bytes`

*Example:*

```sh
> in3 -sigs 8.270446144388933e+124  ....
> in3 --ms.signatures=8.270446144388933e+124  ....

```


### response.in

read response from stdin

 Type: `bool`

*Example:*

```sh
> in3 -ri  ....
> in3 --response.in  ....

```


### response.out

write raw response to stdout

 Type: `bool`

*Example:*

```sh
> in3 -ro  ....
> in3 --response.out  ....

```


### file.in

reads a prerecorded request from the filepath and executes it with the recorded data. (great for debugging)

 Type: `string`

*Example:*

```sh
> in3 -fi record.txt  ....
> in3 --file.in=record.txt  ....

```


### file.out

records a request and writes the reproducable data in a file (including all cache-data, timestamps ...)

 Type: `string`

*Example:*

```sh
> in3 -fo record.txt  ....
> in3 --file.out=record.txt  ....

```


### nodelist

a coma seperated list of urls (or address:url) to be used as fixed nodelist

 Type: `string`

*Example:*

```sh
> in3 -nl https://in3-v2.slock.it/mainnet/nd-1,https://mainnet.incubed.net  ....
> in3 --nodelist=https://in3-v2.slock.it/mainnet/nd-1,https://mainnet.incubed.net  ....

```


### bootnodes

a coma seperated list of urls (or address:url) to be used as boot nodes

 Type: `string`

*Example:*

```sh
> in3 -bn https://in3-v2.slock.it/mainnet/nd-1,https://mainnet.incubed.net  ....
> in3 --bootnodes=https://in3-v2.slock.it/mainnet/nd-1,https://mainnet.incubed.net  ....

```


### onlysign

only sign, don't send the raw Transaction

 Type: `bool`

*Example:*

```sh
> in3 -os  ....
> in3 --onlysign  ....

```


### noproof

alias for --proof=none

 Type: `bool`

*Example:*

```sh
> in3 -np  ....
> in3 --noproof  ....

```


### nostats

alias for --stats=false, which will mark all requests as not counting in the stats

 Type: `bool`

*Example:*

```sh
> in3 -ns  ....
> in3 --nostats  ....

```


### version

displays the version

 Type: `bool`

*Example:*

```sh
> in3 -v  ....
> in3 --version  ....

```


### help

displays this help message

 Type: `bool`

*Example:*

```sh
> in3 -h  ....
> in3 --help  ....

```

