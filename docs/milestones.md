# Features

Incubed comes with a lot of features. This is a summary:

## General

- **Configurable size** : using cmake-options allows to reduce the size down to 300k or even less by removing features like error-messages and so ajust it for embedded devices.
- **Plugin-Architecture** - The client has a small core and a lot of plugin , which makes it highly customizable in size and function. Custom Plugins can be added and extended, allowing to add rpc-methods, signers, transports or verifiers to be added.
- **Signer** - Signer infrastructre allowing to manage keys either locally or as part of the HardwareWallet (NanoLedger support)
- **Ethereum API**: Incubed comes with a type-safe API, which covers all standard JSON-RPC requests (`in3.eth.getBalance('0x52bc44d5378309EE2abF1539BF71dE1b7d7bE3b5')`) as well as an ABI-Encoder and other ethereum features. This API also includes support for signing and sending transactions, as well as calling methods in smart contracts without a complete ABI by simply passing the signature of the method as an argument.
- **Caching Support**: An optional cache enables storage of the results of RPC requests that can automatically be used again within a configurable time span or if the client is offline. This also includes RPC requests, blocks, code, and NodeLists.
- **High Test-coverage** : Incubed is Tested in a CI-Piline with over 80 Jobs and 4500 Tests on a lot of different platforms (win, linux (x86), arm and macos, esp32, ...)

## Nodelist

- **No Single Point of Failure** : A decentralized nodelist allows Incubed to run without any single point of failure or dependency to any CDN or company.
- **Fail-safe Connection**: The Incubed client will connect to any Ethereum blockchain (providing Incubed servers) by randomly selecting nodes within the Incubed network and, if the node cannot be reached or does not deliver verifiable responses, automatically retrying with different nodes.
- **Reputation Management**: Nodes that are not available will be temporarily blacklisted and lose reputation. The selection of a node is based on the weight (or performance) of the node and its availability.
- **Automatic NodeList Updates**: All Incubed nodes are registered in smart contracts on chain and will trigger events if the NodeList changes. Each request will always return the blockNumber of the last event so that the client knows when to update its NodeList.
- **Partial NodeList**: To support small devices, the NodeList can be limited and still be fully verified by basing the selection of nodes deterministically on a client-generated seed.
- **Multichain Support**: Incubed is supporting any Ethereum-based or Bitcoin chain. The client can even run parallel requests to different networks without the need to synchronize first.
- **Preconfigured Boot Nodes**: While you can configure any registry contract, the standard version contains configuration with boot nodes for `mainnet`, `kovan`, `ewf`, `tobalaba`,`btc` and `ipfs`.
- **Network Balancing**: Nodes will balance the network based on load and reputation.

## Verification

- **Full Verification of JSON-RPC Methods**: Incubed is able to fully verify all important JSON-RPC methods. This even includes calling functions in smart contract and verifying their return value (`eth_call`), which means executing each opcode locally in the client to confirm the result.
- **IPFS Support**: Incubed is able to write and read IPFS content and verify the data by hashing and creating the multihash.
- **Bitcoin Support**: Incubed is able connect to the Bitcoin chain verifying Blocks and Transactions
- **Proof Levels**: Incubed supports different proof levels: `none` for no verification, `standard` for verifying only relevant properties, and  `full` for complete verification, including uncle blocks or previous transactions (higher payload).
- **Security Levels**: Configurable number of signatures (for PoW) and minimal deposit stored.
- **PoW Support**: For PoW, blocks are verified based on blockhashes signed by Incubed nodes storing a deposit, which they lose if this blockhash is not correct.
- **PoA Support**: (experimental) For PoA chains (using Aura and clique), blockhashes are verified by extracting the signature from the sealed fields of the blockheader and by using the Aura algorithm to determine the signer from the validatorlist (with static validatorlist or contract-based validators).
- **PoA Clique**: Supports Clique PoA to verify blockheaders.
- **Finality Support**: For PoA chains, the client can require a configurable number of signatures (in percent) to accept them as final.
- **Flexible Transport Layer**: The communication layer between clients and nodes can be overridden, but the layer already supports different transport formats (JSON/CBOR/Incubed).
- **Replace Latest Blocks**: Since most applications per default always ask for the latest block, which cannot be considered final in a PoW chain, a configuration allows applications to automatically use a certain block height to run the request (like six blocks).
- **Signed Requests**: Incubed supports the incentivization layer, which requires signed requests to assign client requests to certain nodes.
- **Full EVM** : Incubed comes with a full EVM-Implementation allowing to verify the outcome of a EVM-tx or call.

## Bindings

### JS/TS

- **JS/TS Bindings** - based on WASM with TS-Interface Incubed can be used as WASM or ASMJS running on all Javascript enviroments (Browser, ReactNative, nodejs, ...)
- **Web3-Support**  - Incubed can be used either as RPCProvider for Web3 or standalone supporting even the same Interfaces as Web3 when working with contracts, allowing a easy transition of exitsting code.
- **No Dependency** - The npm-package comes with zero dependecies, which allows a very small footprint and introduces no additional security risks. 

### Java

- **Java-Bindings**: java version of the Incubed client based on the C sources (using JNI) 
- **Native Android**: Incubed bindings allow to run natively in android based on CMAKE-Config

### Rust

- **Rust-Bindings**: Full native Bindings based on bindgen allowing async and sync usage.

### .NET

- **Dot-Bindings**: Dot-Net Bindings supporting full async request handling and offering the full feature set of incubed.
- **all-platforms** : The dotnet-bindings are available through nuget for linux x86, windows, macos and arm

### Python
- **python**: seamless python-binding with full feature support
- **multi-platform** : The python package includes binaries for all major platforms and architectures ( linux x86, windows, macos and arm )

## Embedded 

- **Zephyr-Support** : Incubed can be fully used with Zephyr-based embedded frameworks
- **Minimal-Requirements** : DRAM : min 50kB (depends on the requests send) and 150-200kb flash 

