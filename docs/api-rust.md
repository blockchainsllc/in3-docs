# API Reference Rust

#### IN3 Rust API features:
- Cross-platform support tested with cross-rs.
- Unsafe code is isolated to a small subset of the API and should not be required for most use cases.
- The C sources are bundled with the crate and we leverage the rust-bindgen and cmake-rs projects to auto-generate bindings.
- Leak-free verified with Valgrind-memcheck.
- Well-documented API support for Ethereum, Bitcoin, and IPFS.
- Customizable storage, transport, and signing.
- All of IN3’s verification capabilities with examples and much more!



#### Quickstart

##### Add in3 to Cargo manifest
 
Add IN3 and futures_executor (or just any executor of your choice) to your cargo manifest. The in3-rs API is asynchronous and Rust doesn’t have any built-in executors so we need to choose one, and we decided futures_executor is a very good option as it is lightweight and practical to use.
```
[package]
name = "in3-tutorial"
version = "0.0.1"
authors = ["reader@medium.com"]
edition = "2018"

[dependencies]
in3 = "0.1.8"
futures-executor = "0.3.5"
```

Let's begin with the ‘hello-world’ equivalent of the Ethereum JSON-RPC API - eth_blockNumber. This call returns the number of the most recent block in the blockchain. Here’s the complete program:

```
use in3::eth1;
use in3::prelude::*;

fn main() -> In3Result<()> {
   let client = Client::new(chain::MAINNET);
   let mut eth_api = eth1::Api::new(client);
   let number = futures_executor::block_on(eth_api.block_number())?;
   println!("Latest block number => {:?}", number);
   Ok(())
}
```

Now, let’s go through this program line-by-line. We start by creating a JSON-RPC capable Incubed Client instance for the Ethereum mainnet chain. 

    let client = Client::new(chain::MAINNET);

This client is then used to instantiate an Ethereum Api instance which implements the Ethereum JSON-RPC API spec. 

    let mut eth_api = eth1::Api::new(client);

From here, getting the latest block number is as simple as calling the block_number() function on the Ethereum Api instance. As specified before, we need to use futures_executor::block_on to run the future returned by block_number() to completion on the current thread.

    let number = futures_executor::block_on(eth_api.block_number())?;

A complete list of supported functions can be found on the in3-rs crate documentation page at docs.rs.


##### Get an Ethereum block by number

```

use async_std::task;
use in3::prelude::*;

fn main() {
    // configure client and API
    let mut eth_api = Api::new(Client::new(chain::MAINNET));
    // get latest block
    let block: Block = block_on(eth_api.get_block_by_number(BlockNumber::Latest, false))?;
    println!("Block => {:?}", block);
}
```

##### An Ethereum contract call
In this case, we are reading the number of nodes that are registered in the IN3 network deployed on the Ethereum Mainnet at `0x2736D225f85740f42D17987100dc8d58e9e16252`



```
use async_std::task;
use in3::prelude::*;
fn main() {
    // configure client and API
    let mut eth_api = Api::new(Client::new(chain::MAINNET));
    // Setup Incubed contract address 
    let contract: Address =
        serde_json::from_str(r#""0x2736D225f85740f42D17987100dc8d58e9e16252""#).unwrap(); // cannot fail
    // Instantiate an abi encoder for the contract call 
    let mut abi = abi::In3EthAbi::new();
    // Setup the signature to call in this case we are calling totalServers():uint256 from in3-nodes contract
    let params = task::block_on(abi.encode("totalServers():uint256", serde_json::json!([])))
        .expect("failed to ABI encode params");
    // Setup the transaction with contract and signature data
    let txn = CallTransaction {
        to: Some(contract),
        data: Some(params),
        ..Default::default()
    };
    // Execute asynchronous api call. 
    let output: Bytes =
        task::block_on(eth_api.call(txn, BlockNumber::Latest)).expect("ETH call failed");
    // Decode the Bytes output and get the result 
    let output =
        task::block_on(abi.decode("uint256", output)).expect("failed to ABI decode output");
    let total_servers: U256 = serde_json::from_value(output).unwrap(); // cannot fail if ABI decode succeeds
    println!("{:?}", total_servers);

}
```
##### Store a string in IPFS
IPFS is a protocol and peer-to-peer network for storing and sharing data in a distributed file system.
```
fn main() {
    let mut ipfs_api = Api::new(Client::new(chain::IPFS));
    //`put` is an asynchrous request (due to the internal C library). Therefore to block execution
    //we use async_std's block_on function
    match task::block_on(ipfs_api.put("incubed meets rust".as_bytes().into())) {
        Ok(res) => println!("The hash is {:?}", res),
        Err(err) => println!("Failed with error: {}", err),
    }
}
```
##### Ready-To-Run Example
Head over to our sample project on GitHub or simply run:
```
$ git clone https://github.com/hu55a1n1/in3-examples.rs
$ cd in3-examples.rs
$ cargo run
```


### Crate
In3 crate can be found in [crates.io/crates/in3](https://crates.io/crates/in3)


### Api Documentation
Api reference information can be found in [docs.rs/in3/0.0.2/in3](https://docs.rs/in3/0.0.2/in3)