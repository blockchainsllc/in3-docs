# API Reference Solidity

This page contains a list of function for the registry contracts. 


### NodeRegistryData functions

#### adminRemoveNodeFromRegistry
Removes an in3-node from the nodeList

**Development notice:**
* only callable by the NodeRegistryLogic-contract

**Parameters:**
* _signer `address`: the signer

#### adminSetLogic
Sets the new Logic-contract as owner of the contract. 

**Development notice:**
* only callable by the current Logic-contract / owner
* the `0x00`-address as owner is not supported

**Return Parameters:**
* true when successful

#### adminSetNodeDeposit
Sets the deposit of an existing in3-node

**Development notice:**
* only callable by the NodeRegistryLogic-contract
* used to remove the deposit of a node after he had been convicted

**Parameters:**
* _signer `address`: the signer of the in3-node
* _newDeposit `uint`: the new deposit 

**Return Parameters:**
* true when successful

#### adminSetStage
Sets the stage of a signer

**Development notice:**
* only callable by the current Logic-contract / owner

**Parameters:**
* _signer `address`: the signer of the in3-node
* _stage_ `uint`: the new stage 

**Return Parameters:**
* true when successful

#### adminSetSupportedToken
Sets a new erc20-token as supported token for the in3-nodes.

**Development notice:**
* only callable by the NodeRegistryLogic-contract

**Parameters:**
* _newToken `address`: the address of the new supported token

**Return Parameters:**
* true when successful

#### adminSetTimeout
Sets the new timeout until the deposit of a node can be accessed after he was unregistered. 

**Development notice:**
* only callable by the NodeRegistryLogic-contract

**Parameters:**
* _newTimeout `uint`: the new timeout

**Return Parameters:**
* true when successful

#### adminTransferDeposit
Transfers a certain amount of ERC20-tokens to the provided address

**Development notice:**
* only callable by the NodeRegistryLogic-contract
* reverts when the transfer failed

**Parameters:**
* _to `address`: the address to receive the tokens
* _amount: `uint`: the amount of tokens to be transferred

**Return Parameters:**
* true when successful

#### setConvict
Writes a value to te convictMapping to be used later for revealConvict in the logic contract.

**Development notice:**
* only callable by the NodeRegistryLogic-contract

**Parameters:**
* _hash `bytes32`: the data to be written
* _caller `address`: the address for that called convict in the logic-contract

**Development notice:**
* only callable by the NodeRegistryLogic-contract

#### registerNodeFor
Registers a new node in the nodeList

**Development notice:**
* only callable by the NodeRegistryLogic-contract

**Parameters:**
* _url `string`: the url of the in3-node
* _props `uint192`: the properties of the in3-node
* _signer `address`: the signer address
* _weight `uit64`: the weight
* _owner `address`: the address of the owner
* _deposit `uint`: the deposit in erc20 tokens
* _stage `uint`: the stage the in3-node should have

**Return Parameters:**
* true when successful

#### transferOwnership
Transfers the ownership of an active in3-node

**Development notice:**
* only callable by the NodeRegistryLogic-contract

**Parameters:**
* _signer `address`: the signer of the in3-node
* _newOwner `address`: the address of the new owner

**Return Parameters:**
* true when successful

#### unregisteringNode
Removes a node from the nodeList

**Development notice:**
* only callable by the NodeRegistryLogic-contract
* calls `_unregisterNodeInternal()`

**Parameters:**
* _signer `address`: the signer of the in3-node

**Return Parameters:**
* true when successful

#### updateNode
Updates an existing in3-node 

**Development notice:**
* only callable by the NodeRegistryLogic-contract
* reverts when the an updated url already exists

**Parameters:**
* _signer `address`: the signer of the in3-node
* _url `string`: the new url
* _props `uint192` the new properties
* _weight `uint64` the new weight
* _deposit `uint` the new deposit

**Return Parameters:**
* true when successful

#### getIn3NodeInformation
Returns the In3Node-struct of a certain index

**Parameters:**
* index `uint`: the index-position in the nodes-array

**Return Parameters:**
* the In3Node-struct

#### getSignerInformation
Returns the SignerInformation of a signer

**Parameters:**
* _signer `address`: the signer 

**Return Parameters:**
the SignerInformation of a signer

#### totalNodes
Returns the length of the nodeList

**Return Parameters:**
The length of the nodeList

#### adminSetSignerInfo
Sets the SignerInformation-struct for a signer

**Development notice:**
* only callable by the NodeRegistryLogic-contract
* gets used for updating the information after returning the deposit

**Parameters:**
* _signer `address`: the signer 
* _si: `SignerInformation` the struct to be set

**Return Parameters:**
* true when successful

### NodeRegistryLogic functions

#### activateNewLogic
Applies a new update to the logic-contract by setting the pending NodeRegistryLogic-contract as owner to the NodeRegistryData-conract

**Development notice:**
* Only callable after 47 days have passed since the latest update has been proposed

#### adminRemoveNodeFromRegistry
Removes an malicious in3-node from the nodeList

**Development notice:**
* only callable by the admin of the smart contract
* only callable in the 1st year after deployment
* ony usable on registered in3-nodes

**Parameters:**
* _signer `address`: the malicious signer

#### adminUpdateLogic
Proposes an update to the logic contract which can only be applied after 47 days.
This will allow all nodes that don't approve the update to unregister from the registry

**Development notice:**
* only callable by the admin of the smart contract
* does not allow for the 0x0-address to be set as new logic

**Parameters:**
* _newLogic `address`: the malicious signer

#### convict
Must be called before revealConvict and commits a blocknumber and a hash.

**Development notice:**
* The `v`,`r`,`s` parameters are from the signature of the wrong blockhash that the node provided

**Parameters:**
* _hash `bytes32`: `keccak256(wrong blockhash, msg.sender, v, r, s)`; used to prevent frontrunning.

#### registerNode
Registers a new node with the sender as owner

**Development notice:**
* will call the registerNodeInteral function
* the amount of `_deposit` token have be approved by the signer in order for them to be transferred by the logic contract

**Parameters:**
* _url `string`: the url of the node, has to be unique
* _props `uint64`: properties of the node
* _weight `uint64`: how many requests per second the node is able to handle
* _deposit `uint`: amount of supported ERC20 tokens as deposit

#### registerNodeFor
Registers a new node as a owner using a different signer address*

**Development notice:**
* will revert when a wrong signature has been provided which is calculated by the hash of the url, properties, weight and the owner in order to prove that the owner has control over the signer-address he has to sign a message
* will call the registerNodeInteral function
* the amount of `_deposit` token have be approved by the in3-node-owner in order for them to be transferred by the logic contract

**Parameters:**
* _url `string`: the url of the node, has to be unique
* _props `uint64`: properties of the node
* _signer `address`: the signer of the in3-node
* _weight `uint64`: how many requests per second the node is able to handle
* _depositAmount `uint`: the amount of supported ERC20 tokens as deposit
* _v `uint8`: v of the signed message
* _r `bytes32`: r of the signed message
* _s `bytes32`: s of the signed message

#### returnDeposit

Returns the deposit after a node has been removed and it's timeout is over. 

**Development notice:**
* reverts if the deposit is still locked
* reverts when there is nothing to transfer
* reverts when not the owner of the former in3-node

**Parameters:**
* _signer `address`: the signer-address of a former in3-node

#### revealConvict
Reveals the wrongly provided blockhash, so that the node-owner will lose its deposit while the sender will get half of the deposit

**Development notice:**
* reverts when the wrong convict hash (see convict-function) is used
* reverts when the _signer did not sign the block
* reverts when trying to reveal immediately after calling convict
* reverts when trying to convict someone with a correct blockhash
* reverts if a block with that number cannot be found in either the latest 256 blocks or the blockhash registry

**Parameters:**
* _signer `address`: the address that signed the wrong blockhash
* _blockhash `bytes32`: the wrongly provided blockhash
* _blockNumber `uint`: number of the wrongly provided blockhash
* _v `uint8`: v of the signature
* _r `bytes32`: r of the signature
* _s `bytes32`: s of the signature

#### transferOwnership
Changes the ownership of an in3-node.

**Development notice:**

* reverts when the sender is not the current owner
* reverts when trying to pass ownership to `0x0`
* reverts when trying to change ownership of an inactive node

**Parameters:**
* _signer `address`: the signer-address of the in3-node, used as an identifier
* _newOwner `address`: the new owner

#### unregisteringNode

A node owner can unregister a node, removing it from the nodeList. Doing so will also lock his deposit for the timeout of the node.

**Development notice:**
* reverts when not called by the owner of the node
* reverts when the provided address is not an in3-signer
* reverts when node is not active

**Parameters:**
* _signer `address`: the signer of the in3-node

#### updateNode
Updates a node by changing its props

**Development notice:**
* if there is an additional deposit the owner has to approve the tokenTransfer before
* reverts when trying to change the url to an already existing one
* reverts when the signer does not own a node
* reverts when the sender is not the owner of the node

**Parameters:**
* _signer `address`: the signer-address of the in3-node, used as an identifier
* _url `string`: the url, will be changed if different from the current one
* _props `uint64`: the new properties, will be changed if different from the current one
* _weight `uint64`: the amount of requests per second the node is able to handle
* _additionalDeposit `uint`: additional deposit in supported erc20 tokens

#### maxDepositFirstYear
Returns the current maximum amount of deposit allowed for registering or updating a node

**Return Parameters:**
* `uint` the maximum amount of tokens

#### minDeposit
Returns the current minimal amount of deposit required for registering a new node

**Return Parameters:**
* `uint` the minimal amount of tokens needed for registering a new node

#### supportedToken
Returns the current supported ERC20 token-address

**Return Parameters:**
* `address` the address of the currently supported erc20 token

### BlockHashRegistry functions

#### searchForAvailableBlock
Searches for an already existing snapshot

**Parameters:**
* _startNumber `uint`: the blocknumber to start searching
* _numBlocks `uint`: the number of blocks to search for

**Return Parameters:**
* `uint` returns a blocknumber when a snapshot had been found. It will return 0 if no blocknumber was found. 

#### recreateBlockheaders
Starts with a given blocknumber and its header and tries to recreate a (reverse) chain of blocks. If this has been successful the last blockhash of the header will be added to the smart. contract. It will be checked whether the provided chain is correct by using the reCalculateBlockheaders function.

**Development notice:**
* only usable when the given blocknumber is already in the smart contract
* function is public due to the usage of a dynamic bytes array (not yet supported for external functions)
* reverts when the chain of headers is incorrect
* reverts when there is not parent block already stored in the contract

**Parameters:**
* _blockNumber `uint`: the block number to start recreation from
* _blockheaders `bytes[]`: array with serialized blockheaders in reverse order (youngest -> oldest) => (e.g. 100, 99, 98)

#### saveBlockNumber
Stores a certain blockhash to the state

**Development notice:**
* reverts if the block can't be found inside the evm

**Parameters:**
* _blockNumber `uint`: the blocknumber to be stored

#### snapshot
Stores the currentBlock-1 in the smart contract

#### getRlpUint
Returns the value from the rlp encoded data

**Development notice:**
*This function is limited to only value up to 32 bytes length!

**Parameters:**
* _data `bytes`: the rlp encoded data
* _offset `uint`: the offset

**Return Parameters:**
* value `uint` the value

#### getParentAndBlockhash
Returns the blockhash and the parent blockhash from the provided blockheader

**Parameters:**
* _blockheader `bytes`: a serialized (rlp-encoded) blockheader

**Return Parameters:**
* parentHash `bytes32`
* bhash `bytes32`

#### reCalculateBlockheaders
Starts with a given blockhash and its header and tries to recreate a (reverse) chain of blocks. The array of the blockheaders have to be in reverse order (e.g. [100,99,98,97]).

**Parameters:**
* _blockheaders `bytes[]`: array with serialized blockheaders in reverse order, i.e. from youngest to oldest
* _bHash `bytes32`: blockhash of the 1st element of the _blockheaders-array