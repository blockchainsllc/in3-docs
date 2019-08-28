# Blockheader Verification
## Ethereum

Since all proofs always include the blockheader, it is crucial to verify the correctness of these data as well. But verification depends on the consensus of the underlying blockchain. (For details, see [Ethereum Verification and MerkleProof](./Ethereum-Verification-and-MerkleProof).)

```eval_rst
.. graphviz::

  digraph minimal_nonplanar_graphs {
    node [style=filled  fontname="Helvetica"]
  fontname="Helvetica"
  edge[ fontname="Helvetica"]

  subgraph cluster_pow {
    label="Proof or Work"  color=lightblue  style=filled
    node [color=white]

    c[label="Client"]

    A[label="Node A"]
    B[label="Node B"]
    C[label="Node C"]

    c -> B[label=""]
    B -> c[label=" response\n + proof  \n + signed\n    header"]
    B -> A[label=" sign"]
    B -> C

  
  }

  subgraph cluster_poa {
    label="Proof of Authority"  color=lightblue  style=filled
    node [color=white]

    _c[label="Client"]

    _B[label="Node"]

    _c -> _B[label=""]
    _B -> _c[label=" response\n + proof  \n + header"]
  }

  subgraph cluster_pos {
    label="Proof of Stake"  color=lightblue  style=filled
    node [color=white]
  rank=same x N V
      
    x[label="Client"]

    N[label="Node"]
    V[label="Node (Validator)"]

    x -> N[label=""]
    N -> x[label=" response\n + proof  \n + header"]

    x -> V[label=" header"]

  
  }

  }


```

### Proof of Work

Currently, the public chain uses proof of work. This makes it very hard to verify the header since anybody can produce such a header. So the only way to verify that the block in question is an accepted block is to let registered nodes sign the blockhash. If they are wrong, they lose their previously stored deposit. For the client, this means that the required security depends on the deposit stored by the nodes.

This is why a client may be configured to require multiple signatures and even a minimal deposit:

```js
client.sendRPC('eth_getBalance', [account, 'latest'], chain, {
  minDeposit: web3.utils.toWei(10,'ether'),
  signatureCount: 3
})
```

The `minDeposit` lets the client preselect only nodes with at least that much deposit.
The `signatureCount` asks for multiple signatures and so increases the security.

Since most clients are small devices with limited bandwith, the client is not asking for the signatures directly from the nodes but, rather, chooses one node and lets this node run a subrequest to get the signatures. This means not only fewer requests for the clients but also that at least one node checks the signatures and "convicts" another if it lied.

### Proof of Authority

The good thing about proof of authority is that there is already a signature included in the blockheader. So if we know who is allowed to sign a block, we do not need an additional blockhash signed. The only critical information we rely on is the list of validators.

Currently, there are two consensus algorithms:

#### Aura

Aura is only used by Parity, and there are two ways to configure it:

- **static list of nodes** (like the Kovan network): in this case, the validatorlist is included in the chain-spec and cannot change, which makes it very easy for a client to verify blockheaders.
- **validator contract**: a contract that offers the function `getValidators()`. Depending on the chain, this contract may contain rules that define how validators may change. But this flexibility comes with a price. It makes it harder for a client to find a secure way to detect validator changes. This is why the proof for such a contract depends on the rules laid out in the contract and is chain-specific. 

#### Clique

Clique is a protocol developed by the Geth team and is now also supported by Parity (see Görli testnet).

Instead of relying on a contract, Clique defines a protocol of how validator nodes may change. All votes are done directly in the blockheader. This makes it easier to prove since it does not rely on any contract. 

The Incubed nodes will check all the blocks for votes and create a `validatorlist` that defines the validatorset for any given blockNumber. This also includes the proof in form of all blockheaders that either voted the new node in or out. This way, the client can ask for the list and automatically update the internal list after it has verified each blockheader and vote. Even though malicious nodes cannot forge the signatures of a validator, they may skip votes in the validatorlist. This is why a validatorlist update should always be done by running multiple requests and merging them together.



## Bitcoin

Bitcoin may be a complete different chain, but there are ways to verify a Bitcoin Blockheader within a Ethereum Smart Contract. This requires a little bit more effort but you can use all the features of Incubed.

### Block Proof

The data we want to verify are mainly Blocks and Transactions. Usually, if we want to get the BlockHeader or the complete block we already know the blockhash. And if we know that this hash is correct, verifying the rest of the block is easy.

1. We take the first 80 Bytes of the Blockdata, which is the blockHeader and hash it twice with sha256. Since Bitcoin stores the hashes in little endian, we then have to reverse the byteorder.

    ```js
    // btc hash = sha256(sha256(data))
    const hash(data: Buffer)  => crypto.createHash('sha256').update(crypto.createHash('sha256').update(data).digest()).digest()

    const blockData:Buffer = ....
    // take the first 80 bytes, hash them and reverse the order
    const blockHash = hash( blockData.slice(0,80)).reverse()
    ```

2. In order to check the Proof of work in the BlockHeader, we compare the target with the hash:

    ```js
    const target = Buffer.alloc(32)
    // we take the first 3 bytes from the bits-field and use the 4th byte as exponent:
    blockData.copy(target, blockData[75]-3,72,75);
    // the hash must be lower than the target
    if ( target.reverse().compare( blockHash )<0) 
       throw new Error('blockHash must be smaller than the target')
    ```

    > Note : In order to verify that the target is correct, we can :
    > - take the target from a different blockheader in the same 2016 blocks epoch
    > - if we don't have one, we should ask for multiple nodes to make sure we have a correct target.

3. If we want to know if this is final, the Node needs to provide us with additional BlockHeaders on top of the current Block (FinalityHeaders).    

    These header need to be verified the same way. But additionaly we need to check the parentHash:    

    ```js 
    if (!parentHash.reverse().equals( blockData.slice(4,36) ))
      throw new Error('wrong parentHash!')
    ```

4. In order to verify the Transactions (only if we have the complete Block, not only the BlockHeader), we need to read them, hash each one and put them in a merkle tree. If the root of the tree matches the merkleRoot, the transactions are correct.    


    ```js
    // we take each Transactiondata, hash them and put the transactionhashes into a merkle tree
    const merkleRoot = createMerkleRoot ( readTransactions(blockData).map(hash).map(_=>_.reverse()) )

    // compare the root with merkleRoot of the header starting at offset 36
    if (!merkleRoot.equals(blockData.slice(36,68).reverse()))
      throw new Error('Invalid MerkleRoot!')
    ```

### Transaction Proof

In order to Verify a Transaction, we need a Merkle Proof. So the Incubed Server will have create a complete MerkleTree and then pass the other part of the pair as Proof.

Verifying means we start by hashing the transaction and then keep on hashing this result with the next hash from the proof. The last hash must match the merkleRoot.

### Convicting For wrong Blockhashes in the NodeRegistry

Just as the Incubed Client can ask for signed blockhashes in Ethereum, he can do this in Bitcoin as well. The signed payload from the node will have to contain these data:

```java
bytes32 blockhash;
uint256 timestamp;
bytes32 registryId;
```

1. Client requires a Signed Blockhash and the Data Provider Node will ask the chosen node to sign.

2. The Data Provider Node (or Watchdog) will then check the signature. If the signed blockhash is wrong it will start the conviting process:

3. In order to convict the Node needs to provide proof, which is the correct blockheader. But since the BlockHeader does not contain the BlockNumber, we have to use the timestamp. So the correct block as proof must have either the same timestamp or a the last block before the timestamp. Additionally the Node may provide FinalityBlockHeaders. As many as possible, but at least one in order to prove, that the timestamp of the correct block is the closest one.

4. The Registry Contract will then verify:

   - the Signature of the convited Node.
   - the BlockHeaders gives as Proof

   The Verification of the BlockHeader can be done directly in Solitidy, because the EVM offers a precompiled Contract at address `0x2` : sha256, which is needed to calculate the Blockhash. With this in mind we can follow the steps 1-3 as described in [Block Proof](#block-proof) implemented in Solidity.


   While doing so we need to add the difficulties of each block and store the last blockHash and the totalDifficulty for later.

5. Now the convited Server has the chance to also deliver blockheaders to proof that he has signed the correct one.
    
    The simple rule is: If the other node (convited or convitor) is not able to add enough verified BlockHeaders with a higher totalDifficulty within 1 hour, the other party can get the deposit and kick the malicious node out.

    Even though this game could go for a while, if the convicted Node signed a hash, which is not part of the longest chain, it will not be possible to create enough mining power to continue mining enough blocks to keep up with the longest chain in the mainnet. Therefore he will most likely give up right after the first transaction.


  
