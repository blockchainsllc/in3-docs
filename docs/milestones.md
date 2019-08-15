# Roadmap

Incubed implements two versions: 
 - **TypeScript / JavaScript**: optimized for dApps, web apps or mobile apps.
 - **Embedded C**: optimized for microcontrollers and all other use cases.

## V1.2 Stable: Q3 2019

This was the first stable release, which was published after Devcon. It contains full verification of all relevant Ethereum rpc-calls (except eth_call for eWasm-Contracts), but there is no payment or incentivization included yet.

- **Failsafe Connection**: The Incubed client will connect to any ethereum-blockchain (providing in3-servers) by randomly selecting nodes within the Incubed network and automatically retrying with different nodes, if the node cannot be reached or does not deliver verifiable responses.
- **Reputation Management**: Nodes that are not available will be automatically temporarily blacklisted and lose reputation. The selection of a node is based on the weight (or performance) of the node and its availability.
- **Automatic NodeList Updates**: All Incubed nodes are registered in smart contracts on chain and will trigger events if the NodeList changes. Each request will always return the blockNumber of the last event so that the client knows when to update its NodeList.
- **Partial Nodelist**: To support small devices, the NodeList can be limited and still be fully verified by basing the selection of nodes deterministically on a client-generated seed.
- **Multichain Support**: Incubed is currently supporting any Ethereum-based chain. The client can even run parallel requests to different networks without the need to synchronize first.
- **Preconfigured Boot Nodes**: While you can configure any registry contract, the standard version contains configuration with boot nodes for `mainnet`, `kovan`, `evan`, `tobalaba`, and `ipfs`.
- **Full Verification of JSON-RPC Methods**: Incubed is able to fully verify all important JSON-RPC methods. This even includes calling functions in smart contract and verifying their return value (`eth_call`), which means executing each opcode locally in the client to confirm the result.
- **IPFS Support**: Incubed is able to write and read IPFS content and verify the data by hashing and creating the multihash.
- **Caching Support**: An optional cache enables storage of the results of RPC requests that can automatically be used again within a configurable time span or if the client is offline. This also includes RPC requests, blocks, code, and NodeLists.
- **Custom Configuration**: The client is highly customizable. For each request, a configuration can be explicitly passed or adjusted through events (`client.on('beforeRequest',...)`). This allows the proof level or number of requests to be sent to be optimized  depending on the context.
- **Proof Levels**: Incubed supports different proof levels: `none` for no verification, `standard` for verifying only relevant properties, and  `full` for complete verification, including uncle blocks or previous transactions (higher payload).
- **Security Levels**: Configurable number of signatures (for PoW) and minimal deposit stored.
- **PoW Support**: For PoW, blocks are verified based on blockhashes signed by Incubed nodes storing a deposit, which they lose if this blockhash is not correct.
- **PoA Support**: For PoA chains (using Aura), blockhashes are verified by extracting the signature from the sealed fields of the blockheader and by using the Aura algorithm to determine the signer from the validatorlist (with static validatorlist or contract-based validators).
- **Finality Support**: For PoA chains, the client can require a configurable number of signatures (in percent) to accept them as final.
- **Flexible Transport Layer**: The communication layer between clients and nodes can be overridden, but the layer already supports different transport formats (JSON/CBOR/in3).
- **Replace Latest Blocks**: Since most applications per default always ask for the latest block, which cannot be considered as final in a PoW chain, a configuration allows applications to automatically use a certain block height to run the request (like six blocks).
- **Light Ethereum API**: Incubed comes with a type-safe simple API, which covers all standard JSON RPC requests (`in3.eth.getBalance('0x52bc44d5378309EE2abF1539BF71dE1b7d7bE3b5')` ). This API also includes support for signing and sending transactions as well as calling methods in smart contracts without a complete ABI by simply passing the signature of the method as an argument.
- **TypeScript Support**: Because Incubed is written 100% in TypeScript, you get all the advantages of a type-safe toolchain.
- **Integrations**: Incubed has been successfully tested in all major browsers, Node.js, and even React Native.

## V1.2 Incentivization: Q3 2019

This release will introduce the incentivization layer, which should help provide more nodes to create the decentralized network.

- **PoA Clique**: Supports Clique PoA to verify blockheader.
- **Signed Requests**: Incubed supports the incentivization layer, which requires signed requests to assign client requests to certain nodes.
- **Network Balancing**: Nodes will balance the network based on load and reputation.

## V1.3 eWasm: Q1 2020

For `eth_call` verification, the client and server must be able to execute the code. This release adds the ability to support eWasm contracts.

- **eWasm**: Supports eWasm contracts in eth_call.

## V1.4 Substrate: Q3 2020

Supports Polkadot or any substrate-based chains.

- **Substrate**: Framework support.
- **Runtime-Optimization**: Using precompiled runtimes.

## V1.5 Services: Q1 2021

Generic interface enables any deterministic service (such as docker-container) to be decentralized and verified.
