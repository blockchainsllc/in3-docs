# API Reference Python


Python bindings and library for in3. Go to our [readthedocs](https://in3.readthedocs.io/) page for more on usage.

This library is based on the [C version of Incubed](http://github.com/slockit/in3-c), which limits the compatibility for Cython, so please contribute by compiling it to your own platform and sending us a pull-request!


## Quickstart

### Install with pip 
 
```python
pip install in3
```

### In3 Client Standalone

```python
import in3

in3_client = in3.Client()
block_number = in3_client.eth.block_number()
print(block_number) # Mainnet's block number

in3_client.eth # ethereum module
in3_client.in3 # in3 module 
```

### Tests
```bash
python tests/test_suite.py
```

### Contributing
1. Read the index and respect the architecture. For additional packages and files please update the index.
2. (Optional) Get the latest `libin3.dylib` from the Gitlab Pipeline on the `in-core` project and replace it in `in3/bind` folder. 
3. Write the changes in a new branch, then make a pull request for the `develop` branch when all tests are passing. Be sure to add new tests to the CI. 

### Index
Explanation of this source code architecture and how it is organized. For more on design-patterns see [here](http://geekswithblogs.net/joycsharp/archive/2012/02/19/design-patterns-for-model.aspx) or on [Martin Fowler's](https://martinfowler.com/eaaCatalog/) Catalog of Patterns of Enterprise Application Architecture.

- **in3.__init__.py**: Library entry point, imports organization. Standard for any pipy package.
- **in3.eth**: Package for Ethereum objects and tools.
- **in3.eth.account**: Api for managing simple wallets and smart-contracts alike.
- **in3.eth.api**: Ethereum tools and Domain Objects.
- **in3.eth.model**: Value Objects for Ethereum. 
- **in3.libin3**: Package for everything related to binding libin3 to python. Libin3 is written in C and can be found [here](https://github.com/slockit/in3-c).
- **in3.libin3.shared**: Native shared libraries for multiple operating systems and platforms.
- **in3.libin3.enum**: Enumerations mapping C definitions to python.
- **in3.libin3.lib_loader**: Bindings using Ctypes.
- **in3.libin3.runtime**: Runtime object, bridging the remote procedure calls to the libin3 instances. 
## Examples

### blocknumber

source : [in3-c/python/examples/blocknumber.py](https://github.com/slockit/in3-c/blob/master/python/examples/blocknumber.py)



```python
### Creating a new instance by chain definition

import in3

kovan = IN3Config()
kovan.chainId = ChainsDefinitions.KOVAN.value
in3_client = In3Client(in3_config=kovan)

in3_client.eth.block_number() # Kovan's block's number
```

### chainId

source : [in3-c/python/examples/chainId.py](https://github.com/slockit/in3-c/blob/master/python/examples/chainId.py)



```python
### Creating a new instance by "string" chainId

from in3py.client.in3_client import In3Client
from in3py.client.in3_client import IN3Config

kovan = IN3Config()
kovan.chainId= "0x2a"
in3_client = In3Client(in3_config=kovan)

in3_client.eth.block_number() # Kovan's block's number
```


### Building 

In order to run those examples, you need to install in3 first

```sh
pip install in3
```

In order to run a example use

```
python blocknumber.py
```


## in3


### Client
```python
Client(self, in3_config: ClientConfig = None)
```

Incubed network client. Connect to the blockchain via a list of bootnodes, then gets the latest list of nodes in
the network and ask a certain number of the to sign the block header of given list, putting their deposit at stake.
Once with the latest list at hand, the client can request any other on-chain information using the same scheme.

**Arguments**:

- `in3_config` _ClientConfig or str_ - (optional) Configuration for the client. If not provided, default is loaded.
  

### ClientConfig
```python
ClientConfig(self,
chainId: str = 'mainnet',
key: str = None,
replaceLatestBlock: int = 8,
signatureCount: int = 3,
finality: int = 70,
minDeposit: int = 10000000000000000,
proof: In3ProofLevel = <In3ProofLevel.STANDARD: 'standard'>,
autoUpdateList: bool = True,
timeout: int = 5000,
includeCode: bool = False,
keepIn3: bool = False,
maxAttempts: int = None,
maxBlockCache: int = None,
maxCodeCache: int = None,
nodeLimit: int = None,
requestCount: int = 1)
```

In3 Client Configuration class.
Determines the behavior of client, which chain to connect to, verification policy, update cycle, minimum number of
signatures collected on every request, and response timeout.
Those are the settings that determine information security levels. Considering integrity is guaranteed by and
confidentiality is not available on public blockchains, these settings will provide a balance between availability,
and financial stake in case of repudiation. The "newer" the block is, or the closest to "latest", the higher are
the chances it gets repudiated (a fork) by the chain, making lower the chances a node will sign on such information
and thus reducing its availability. Up to a certain point, the older the block gets, the highest is its
availability because of the close-to-zero repudiation risk. Blocks older than circa one year are stored in Archive
Nodes, expensive computers, so, despite of the zero repudiation risk, there are not many nodes and they must search
for the requested block in its database, lowering the availability as well. The verification policy enforces an
extra step of security, that proves important in case you have only one response from an archive node
and want to run a local integrity check, just to be on the safe side.

**Arguments**:

- `chainId` _str_ - (optional) - servers to filter for the given chain. The chain-id based on EIP-155. example: 0x1
- `replaceLatestBlock` _int_ - (optional) - if specified, the blocknumber latest will be replaced by blockNumber- specified value example: 6
- `signatureCount` _int_ - (optional) - number of signatures requested example: 2
- `finality` _int_ - (optional) - the number in percent needed in order reach finality (% of signature of the validators) example: 50
- `minDeposit` _int_ - - min stake of the server. Only nodes owning at least this amount will be chosen.
  proof :'none'|'standard'|'full' (optional) - if true the nodes should send a proof of the response
- `autoUpdateList` _bool_ - (optional) - if true the nodelist will be automatically updated if the lastBlock is newer
- `timeout` _int_ - specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection. example: 100000
- `key` _str_ - (optional) - the client key to sign requests example: 0x387a8233c96e1fc0ad5e284353276177af2186e7afa85296f106336e376669f7
- `includeCode` _bool_ - (optional) - if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards
- `maxAttempts` _int_ - (optional) - max number of attempts in case a response is rejected example: 10
- `keepIn3` _bool_ - (optional) - if true, the in3-section of thr response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.
- `maxBlockCache` _int_ - (optional) - number of number of blocks cached in memory example: 100
- `maxCodeCache` _int_ - (optional) - number of max bytes used to cache the code in memory example: 100000
- `nodeLimit` _int_ - (optional) - the limit of nodes to store in the client. example: 150
- `requestCount` _int_ - - Useful to be higher than 1 when using signatureCount <= 1. Then the client check for consensus in answers.
  

### NodeList
```python
NodeList(self, nodes: [<class 'in3.model.In3Node'>], contract: Account,
registryId: str, lastBlockNumber: int, totalServers: int)
```

List of incubed nodes and its metadata, in3 registry contract from which the list was taken,
network/registry id, and last block number in the selected chain.

**Arguments**:

- `nodes` _[In3Node]_ - list of incubed nodes
- `contract` _Account_ - incubed registry contract from which the list was taken
- `registryId` _str_ - uuid of this incubed network. one chain could contain more than one incubed networks.
- `lastBlockNumber` _int_ - last block signed by the network
- `totalServers` _int_ - Total servers number (for integrity?)
  

### In3Node
```python
In3Node(self, url: str, address: Account, index: int, deposit: int,
props: int, timeout: int, registerTime: int, weight: int)
```

Registered remote verifier that attest, by signing the block hash, that the requested block and transaction were
indeed mined are in the correct chain fork.

**Arguments**:

- `url` _str_ - Endpoint to post to example: https://in3.slock.it
- `index` _int_ - Index within the contract example: 13
- `address` _in3.Account_ - Address of the node, which is the public address it iis signing with. example: 0x6C1a01C2aB554930A937B0a2E8105fB47946c679
- `deposit` _int_ - Deposit of the node in wei example: 12350000
- `props` _int_ - Properties of the node. example: 3
- `timeout` _int_ - Time (in seconds) until an owner is able to receive his deposit back after he unregisters himself example: 3600
- `registerTime` _int_ - When the node was registered in (unixtime?)
- `weight` _int_ - Score based on qualitative metadata to base which nodes to ask signatures from.
  

## in3.eth


### EthereumApi
```python
EthereumApi(self, runtime: In3Runtime, chain_id: str)
```

Module based on Ethereum's api and web3.js


### EthAccountApi
```python
EthAccountApi(self, runtime: In3Runtime, factory: EthObjectFactory)
```

Manages wallets and smart-contracts


### in3.eth.model


#### DataTransferObject
```python
DataTransferObject()
```

Map marshalling objects transferred to and from a remote facade, in this case, libin3 rpc api.
For more on design-patterns see [Martin Fowler's](https://martinfowler.com/eaaCatalog/) Catalog of Patterns of Enterprise Application Architecture.


#### Transaction
```python
Transaction(self, From: str, to: str, gas: int, gasPrice: int, hash: str,
data: str, nonce: int, gasLimit: int, blockNumber: int,
transactionIndex: int, blockHash: str, value: int,
signature: str)
```

**Arguments**:

- `From` _hex str_ - Address of the sender account.
- `to` _hex str_ - Address of the receiver account. Left undefined for a contract creation transaction.
- `gas` _int_ - Gas for the transaction miners and execution in wei. Will get multiplied by `gasPrice`. Use in3.eth.account.estimate_gas to get a calculated value. Set too low and the transaction will run out of gas.
- `value` _int_ - Value transferred in wei. The endowment for a contract creation transaction.
- `data` _hex str_ - Either a ABI byte string containing the data of the function call on a contract, or in the case of a contract-creation transaction the initialisation code.
- `gasPrice` _int_ - Price of gas in wei, defaults to in3.eth.gasPrice. Also know as `tx fee price`. Set your gas price too low and your transaction may get stuck. Set too high on your own loss.
  gasLimit (int); Maximum gas paid for this transaction. Set by the client using this rationale if left empty: gasLimit = G(transaction) + G(txdatanonzero) × dataByteLength. Minimum is 21000.
- `nonce` _int_ - Number of transactions mined from this address. Nonce is a value that will make a transaction fail in case it is different from (transaction count + 1). It exists to mitigate replay attacks. This allows to overwrite your own pending transactions by sending a new one with the same nonce. Use in3.eth.account.get_transaction_count to get the latest value.
- `hash` _hex str_ - Keccak of the transaction bytes, not part of the transaction. Also known as receipt, because this field is filled after the transaction is sent, by eth_sendTransaction
- `blockHash` _hex str_ - Block hash that this transaction was mined in. null when its pending.
- `blockNumber` _int_ - Block number that this transaction was mined in. null when its pending.
- `transactionIndex` _int_ - Integer of the transactions index position in the block. null when its pending.
- `signature` _hex str_ - ECDSA of transaction.data, calculated r, s and v concatenated. V is parity set by v = 27 + (r % 2).
  

#### RawTransaction
```python
RawTransaction(self,
From: str,
to: str,
gas: int,
nonce: int,
value: int = None,
data: str = None,
gasPrice: int = None,
gasLimit: int = None,
hash: str = None,
signature: str = None)
```

Unsent transaction. Use to send a new transaction.

**Arguments**:

- `From` _hex str_ - Address of the sender account.
- `to` _hex str_ - Address of the receiver account. Left undefined for a contract creation transaction.
- `gas` _int_ - Gas for the transaction miners and execution in wei. Will get multiplied by `gasPrice`. Use in3.eth.account.estimate_gas to get a calculated value. Set too low and the transaction will run out of gas.
- `value` _int_ - (optional) Value transferred in wei. The endowment for a contract creation transaction.
- `data` _hex str_ - (optional) Either a ABI byte string containing the data of the function call on a contract, or in the case of a contract-creation transaction the initialisation code.
- `gasPrice` _int_ - (optional) Price of gas in wei, defaults to in3.eth.gasPrice. Also know as `tx fee price`. Set your gas price too low and your transaction may get stuck. Set too high on your own loss.
  gasLimit (int); (optional) Maximum gas paid for this transaction. Set by the client using this rationale if left empty: gasLimit = G(transaction) + G(txdatanonzero) × dataByteLength. Minimum is 21000.
- `nonce` _int_ - (optional) Number of transactions mined from this address. Nonce is a value that will make a transaction fail in case it is different from (transaction count + 1). It exists to mitigate replay attacks. This allows to overwrite your own pending transactions by sending a new one with the same nonce. Use in3.eth.account.get_transaction_count to get the latest value.
- `hash` _hex str_ - (optional) Keccak of the transaction bytes, not part of the transaction. Also known as receipt, because this field is filled after the transaction is sent.
- `signature` _hex str_ - (optional) ECDSA of transaction, r, s and v concatenated. V is parity set by v = 27 + (r % 2).
  

#### Filter
```python
Filter(self, fromBlock: int, toBlock: int, address: str, topics: list,
blockhash: str)
```

Filters are event catchers running on the Ethereum Client. Incubed has a client-side implementation.
An event will be stored in case it is within to and from blocks, or in the block of blockhash, contains a
transaction to the designed address, and has a word listed on topics.


#### Account
```python
Account(self, address: str, chain_id: str, secret: str = None)
```

Ethereum address of a wallet or smart-contract

