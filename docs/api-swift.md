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
### Account

Account Handling includes handling signers and preparing and signing transacrtion and data.

``` swift
public class Account
```

Signers are Plugins able to create signatures. Those functions will use the registered plugins.



#### pk2address(pk:)

extracts the address from a private key.

``` swift
public func pk2address(pk: String) throws -> String
```

**Example**

``` swift
let result = try Account(in3).pk2address(pk: "0x0fd65f7da55d811634495754f27ab318a3309e8b4b8a978a50c20a661117435a")
// result = "0xdc5c4280d8a286f0f9c8f7f55a5a0c67125efcfd"
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

**Example**

``` swift
let result = try Account(in3).pk2public(pk: "0x0fd65f7da55d811634495754f27ab318a3309e8b4b8a978a50c20a661117435a")
// result = "0x0903329708d9380aca47b02f3955800179e18bffbb29be3a644593c5f87e4c7fa960983f7818\
//          6577eccc909cec71cb5763acd92ef4c74e5fa3c43f3a172c6de1"
```

**Parameters**

  - pk: the 32 bytes private key as hex.

**Returns**

the public key as 64 bytes

#### ecrecover(msg:sig:sigtype:)

extracts the public key and address from signature.

``` swift
public func ecrecover(msg: String, sig: String, sigtype: String? = "raw") throws -> AccountEcrecover
```

**Example**

``` swift
let result = try Account(in3).ecrecover(msg: "0x487b2cbb7997e45b4e9771d14c336b47c87dc2424b11590e32b3a8b9ab327999", sig: "0x0f804ff891e97e8a1c35a2ebafc5e7f129a630a70787fb86ad5aec0758d98c7b454dee5564310d497ddfe814839c8babd3a727692be40330b5b41e7693a445b71c", sigtype: "hash")
// result = 
//          publicKey: "0x94b26bafa6406d7b636fbb4de4edd62a2654eeecda9505e9a478a66c4f42e504c\
//            4481bad171e5ba6f15a5f11c26acfc620f802c6768b603dbcbe5151355bbffb"
//          address: "0xf68a4703314e9a9cf65be688bd6d9b3b34594ab4"
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
public func prepareTx(tx: AccountTransaction) -> Future<String>
```

**Example**

``` swift
Account(in3).prepareTx(tx: AccountTransaction(to: "0x63f666a23cbd135a91187499b5cc51d589c302a0", value: "0x100000000", from: "0xc2b2f4ad0d234b8c135c39eea8409b448e5e496f")) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0xe980851a13b865b38252089463f666a23cbd135a91187499b5cc51d589c302a0850100000000\
//          80018080"
     }
}
 
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

**Example**

``` swift
Account(in3).signTx(tx: "0xe980851a13b865b38252089463f666a23cbd135a91187499b5cc51d589c302a085010000000080018080", from: "0xc2b2f4ad0d234b8c135c39eea8409b448e5e496f") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0xf86980851a13b865b38252089463f666a23cbd135a91187499b5cc51d589c302a08501000000\
//          008026a03c5b094078383f3da3f65773ab1314e89ee76bc41f827f2ef211b2d3449e4435a077755\
//          f8d9b32966e1ad8f6c0e8c9376a4387ed237bdbf2db6e6b94016407e276"
     }
}
 
```

**Parameters**

  - tx: the raw unsigned transactiondata
  - from: the account to sign

**Returns**

the raw transaction with signature.

#### signData(msg:account:msgType:)

signs the given data.

``` swift
public func signData(msg: String, account: String, msgType: String? = "raw") -> Future<AccountSignData>
```

**Example**

``` swift
Account(in3).signData(msg: "0x0102030405060708090a0b0c0d0e0f", account: "0xa8b8759ec8b59d7c13ef3630e8530f47ddb47eba12f00f9024d3d48247b62852", msgType: "raw") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          message: "0x0102030405060708090a0b0c0d0e0f"
//          messageHash: "0x1d4f6fccf1e27711667605e29b6f15adfda262e5aedfc5db904feea2baa75e67"
//          signature: "0xa5dea9537d27e4e20b6dfc89fa4b3bc4babe9a2375d64fb32a2eab04559e95792\
//            264ad1fb83be70c145aec69045da7986b95ee957fb9c5b6d315daa5c0c3e1521b"
//          r: "0xa5dea9537d27e4e20b6dfc89fa4b3bc4babe9a2375d64fb32a2eab04559e9579"
//          s: "0x2264ad1fb83be70c145aec69045da7986b95ee957fb9c5b6d315daa5c0c3e152"
//          v: 27
     }
}
 
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
public func decryptKey(key: String, passphrase: String) throws -> String
```

**Example**

``` swift
let result = try Account(in3).decryptKey(key: {"version":"3,","id":"f6b5c0b1-ba7a-4b67-9086-a01ea54ec638","address":"08aa30739030f362a8dd597fd3fcde283e36f4a1","crypto":{"ciphertext":"d5c5aafdee81d25bb5ac4048c8c6954dd50c595ee918f120f5a2066951ef992d","cipherparams":{"iv":"415440d2b1d6811d5c8a3f4c92c73f49"},"cipher":"aes-128-ctr","kdf":"pbkdf2","kdfparams":{"dklen":32,"salt":"691e9ad0da2b44404f65e0a60cf6aabe3e92d2c23b7410fd187eeeb2c1de4a0d","c":16384,"prf":"hmac-sha256"},"mac":"de651c04fc67fd552002b4235fa23ab2178d3a500caa7070b554168e73359610"}}, passphrase: "test")
// result = "0x1ff25594a5e12c1e31ebd8112bdf107d217c1393da8dc7fc9d57696263457546"
```

**Parameters**

  - key: Keydata as object as defined in the keystorefile
  - passphrase: the password to decrypt it.

**Returns**

a raw private key (32 bytes)

#### createKey(seed:)

Generates 32 random bytes.
If /dev/urandom is available it will be used and should generate a secure random number.
If not the number should not be considered sceure or used in production.

``` swift
public func createKey(seed: String? = nil) throws -> String
```

**Example**

``` swift
let result = try Account(in3).createKey()
// result = "0x6c450e037e79b76f231a71a22ff40403f7d9b74b15e014e52fe1156d3666c3e6"
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

**Example**

``` swift
Account(in3).sign(account: "0x9b2055d370f73ec7d8a03e965129118dc8f5bf83", message: "0xdeadbeaf") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0xa3f20717a250c2b0b729b7e5becbff67fdaef7e0699da4de7ca5895b02a170a12d887fd3b17b\
//          fdce3481f10bea41f45ba9f709d39ce8325427b57afcfc994cee1b"
     }
}
 
```

**Parameters**

  - account: the account to sign with
  - message: the message to sign

**Returns**

the signature (65 bytes) for the given message.

#### signTransaction(tx:)

Signs a transaction that can be submitted to the network at a later time using with eth\_sendRawTransaction.

``` swift
public func signTransaction(tx: AccountTransaction) -> Future<String>
```

**Example**

``` swift
Account(in3).signTransaction(tx: AccountTransaction(data: "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675", from: "0xb60e8dd61c5d32be8058bb8eb970870f07233155", gas: "0x76c0", gasPrice: "0x9184e72a000", to: "0xd46e8dd67c5d32be8058bb8eb970870f07244567", value: "0x9184e72a")) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0xa3f20717a250c2b0b729b7e5becbff67fdaef7e0699da4de7ca5895b02a170a12d887fd3b17b\
//          fdce3481f10bea41f45ba9f709d39ce8325427b57afcfc994cee1b"
     }
}
 
```

**Parameters**

  - tx: transaction to sign

**Returns**

the raw signed transaction

#### addRawKey(pk:)

adds a raw private key as signer, which allows signing transactions.

``` swift
public func addRawKey(pk: String) throws -> String
```

**Example**

``` swift
let result = try Account(in3).addRawKey(pk: "0x1234567890123456789012345678901234567890123456789012345678901234")
// result = "0x2e988a386a799f506693793c6a5af6b54dfaabfb"
```

**Parameters**

  - pk: the 32byte long private key as hex string.

**Returns**

the address of given key.

#### accounts()

returns a array of account-addresss the incubed client is able to sign with.

``` swift
public func accounts() throws -> [String]
```

In order to add keys, you can use [in3\_addRawKey](#in3-addrawkey) or configure them in the config. The result also contains the addresses of any signer signer-supporting the `PLGN_ACT_SIGN_ACCOUNT` action.

**Example**

``` swift
let result = try Account(in3).accounts()
// result = 
//          - "0x2e988a386a799f506693793c6a5af6b54dfaabfb"
//          - "0x93793c6a5af6b54dfaabfb2e988a386a799f5066"
```

**Returns**

the array of addresses of all registered signers.
### Btc

*Important:​ This feature is still experimental and not considered stable yet. In order to use it, you need to set the experimental-flag (-x on the comandline or `"experimental":​true`\!*

``` swift
public class Btc
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

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.

**Example**

``` swift
Btc(in3).getblockheaderAsHex(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 3045022100ae5bd019a63aed404b743c9ebcc77fbaa657e481f745e4...f3255d
     }
}
 
```

**Parameters**

  - hash: The block hash

**Returns**

the blockheader.

#### getblockheader(hash:)

returns the blockheader

``` swift
public func getblockheader(hash: String) -> Future<Btcblockheader?>
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.

**Example**

``` swift
Btc(in3).getblockheader(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          hash: 000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220
//          confirmations: 8268
//          height: 624958
//          version: 536928256
//          versionHex: 2000
//          merkleroot: d786a334ea8c65f39272d5b9be505ac3170f3904842bd52525538a9377b359cb
//          time: 1586333924
//          mediantime: 1586332639
//          nonce: 1985217615
//          bits: 17143b41
//          difficulty: 13912524048945.91
//          chainwork: 00000000000000000000000000000000000000000e4c88b66c5ee78deff0d494
//          nTx: 33
//          previousblockhash: 00000000000000000013cba040837778744ce66961cfcf2e7c34bb3d194c7f49
//          nextblockhash: 0000000000000000000c799dc0e36302db7fbb471711f140dc308508ef19e343
     }
}
 
```

**Parameters**

  - hash: The block hash

**Returns**

the blockheader.

#### getBlockAsHex(hash:)

returns a hex representation of the block

``` swift
public func getBlockAsHex(hash: String) -> Future<String?>
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.

**Example**

``` swift
Btc(in3).getBlockAsHex(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 3045022100ae5bd019a63aed404b743c9ebcc77fbaa657e481f745e4...f3255d
     }
}
 
```

**Parameters**

  - hash: The block hash

**Returns**

the block.

#### getBlock(hash:)

returns the block with transactionhashes

``` swift
public func getBlock(hash: String) -> Future<Btcblock?>
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.

**Example**

``` swift
Btc(in3).getBlock(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          hash: 000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220
//          confirmations: 8268
//          height: 624958
//          version: 536928256
//          versionHex: 2000
//          merkleroot: d786a334ea8c65f39272d5b9be505ac3170f3904842bd52525538a9377b359cb
//          time: 1586333924
//          mediantime: 1586332639
//          nonce: 1985217615
//          bits: 17143b41
//          difficulty: 13912524048945.91
//          chainwork: 00000000000000000000000000000000000000000e4c88b66c5ee78deff0d494
//          tx:
//            - d79ffc80e07fe9e0083319600c59d47afe69995b1357be6e5dba035675780290
//            - ...
//            - 6456819bfa019ba30788620153ea9a361083cb888b3662e2ff39c0f7adf16919
//          nTx: 33
//          previousblockhash: 00000000000000000013cba040837778744ce66961cfcf2e7c34bb3d194c7f49
//          nextblockhash: 0000000000000000000c799dc0e36302db7fbb471711f140dc308508ef19e343
     }
}
 
```

**Parameters**

  - hash: The block hash

**Returns**

the block.

#### getBlockWithTx(hash:)

returns the block with full transactions

``` swift
public func getBlockWithTx(hash: String) -> Future<BtcblockWithTx?>
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.

**Example**

``` swift
Btc(in3).getBlockWithTx(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          hash: 000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220
//          confirmations: 8268
//          height: 624958
//          version: 536928256
//          versionHex: 2000
//          merkleroot: d786a334ea8c65f39272d5b9be505ac3170f3904842bd52525538a9377b359cb
//          time: 1586333924
//          mediantime: 1586332639
//          nonce: 1985217615
//          bits: 17143b41
//          difficulty: 13912524048945.91
//          chainwork: 00000000000000000000000000000000000000000e4c88b66c5ee78deff0d494
//          tx:
//            - d79ffc80e07fe9e0083319600c59d47afe69995b1357be6e5dba035675780290
//            - ...
//            - 6456819bfa019ba30788620153ea9a361083cb888b3662e2ff39c0f7adf16919
//          nTx: 33
//          previousblockhash: 00000000000000000013cba040837778744ce66961cfcf2e7c34bb3d194c7f49
//          nextblockhash: 0000000000000000000c799dc0e36302db7fbb471711f140dc308508ef19e343
     }
}
 
```

**Parameters**

  - hash: The block hash

**Returns**

the block.

#### getRawTransactionAsHex(txid:blockhash:)

returns a hex representation of the tx

``` swift
public func getRawTransactionAsHex(txid: String, blockhash: String? = nil) -> Future<String?>
```

  - verbose `1` or `false`: an object representing the transaction.

**Example**

``` swift
Btc(in3).getRawTransactionAsHex(txid: "f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf", verbosity: true) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 3045022100ae5bd019a63aed404b743c9ebcc77fbaa657e481f745e4...f3255d
     }
}
 
```

**Parameters**

  - txid: The transaction id
  - blockhash: The block in which to look for the transaction

**Returns**

  - verbose `0` or `false`:​ a string that is serialized, hex-encoded data for `txid`

#### getRawTransaction(txid:blockhash:)

returns the raw transaction

``` swift
public func getRawTransaction(txid: String, blockhash: String? = nil) -> Future<Btctransaction?>
```

  - verbose `1` or `false`: an object representing the transaction.

**Example**

``` swift
Btc(in3).getRawTransaction(txid: "f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf", verbosity: true) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          in_active_chain: true
//          txid: f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf
//          hash: f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf
//          version: 1
//          size: 518
//          vsize: 518
//          weight: 2072
//          locktime: 0
//          vin:
//            - txid: 0a74f6e5f99bc69af80da9f0d9878ea6afbfb5fbb2d43f1ff899bcdd641a098c
//              vout: 0
//              scriptSig:
//                asm: 30440220481f2b3a49b202e26c73ac1b7bce022e4a74aff08473228cc...254874
//                hex: 4730440220481f2b3a49b202e26c73ac1b7bce022e4a74aff08473228...254874
//              sequence: 4294967295
//            - txid: 869c5e82d4dfc3139c8a153d2ee126e30a467cf791718e6ea64120e5b19e5044
//              vout: 0
//              scriptSig:
//                asm: 3045022100ae5bd019a63aed404b743c9ebcc77fbaa657e481f745e4...f3255d
//                hex: 483045022100ae5bd019a63aed404b743c9ebcc77fbaa657e481f745...f3255d
//              sequence: 4294967295
//            - txid: 8a03d29a1b8ae408c94a2ae15bef8329bc3d6b04c063d36b2e8c997273fa8eff
//              vout: 1
//              scriptSig:
//                asm: 304402200bf7c5c7caec478bf6d7e9c5127c71505034302056d1284...0045da
//                hex: 47304402200bf7c5c7caec478bf6d7e9c5127c71505034302056d12...0045da
//              sequence: 4294967295
//          vout:
//            - value: 0.00017571
//              n: 0
//              scriptPubKey:
//                asm: OP_DUP OP_HASH160 53196749b85367db9443ef9a5aec25cf0bdceedf OP_EQUALVERIFY
//                  OP_CHECKSIG
//                hex: 76a91453196749b85367db9443ef9a5aec25cf0bdceedf88ac
//                reqSigs: 1
//                type: pubkeyhash
//                addresses:
//                  - 18aPWzBTq1nzs9o86oC9m3BQbxZWmV82UU
//            - value: 0.00915732
//              n: 1
//              scriptPubKey:
//                asm: OP_HASH160 8bb2b4b848d0b6336cc64ea57ae989630f447cba OP_EQUAL
//                hex: a9148bb2b4b848d0b6336cc64ea57ae989630f447cba87
//                reqSigs: 1
//                type: scripthash
//                addresses:
//                  - 3ERfvuzAYPPpACivh1JnwYbBdrAjupTzbw
//          hex: 01000000038c091a64ddbc99f81f3fd4b2fbb5bfafa68e8...000000
//          blockhash: 000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220
//          confirmations: 15307
//          time: 1586333924
//          blocktime: 1586333924
     }
}
 
```

**Parameters**

  - txid: The transaction id
  - blockhash: The block in which to look for the transaction

**Returns**

  - verbose `0` or `false`:​ a string that is serialized, hex-encoded data for `txid`

#### getblockcount()

Returns the number of blocks in the longest blockchain.

``` swift
public func getblockcount() -> Future<UInt64>
```

**Example**

``` swift
Btc(in3).getblockcount() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 640387
     }
}
 
```

**Returns**

the current blockheight

#### getdifficulty(blocknumber:)

Returns the proof-of-work difficulty as a multiple of the minimum difficulty.

``` swift
public func getdifficulty(blocknumber: UInt64) -> Future<UInt256>
```

  - `blocknumber` is `latest`, `earliest`, `pending` or empty: the difficulty of the latest block (`actual latest block` minus `in3.finality`)

**Example**

``` swift
Btc(in3).getdifficulty(blocknumber: 631910) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 15138043247082.88
     }
}
 
```

**Parameters**

  - blocknumber: Can be the number of a certain block to get its difficulty. To get the difficulty of the latest block use `latest`, `earliest`, `pending` or leave `params` empty (Hint: Latest block always means `actual latest block` minus `in3.finality`)

**Returns**

  - `blocknumber` is a certain number:​ the difficulty of this block

#### proofTarget(target_dap:verified_dap:max_diff:max_dap:limit:)

Whenever the client is not able to trust the changes of the target (which is the case if a block can't be found in the verified target cache *and* the value of the target changed more than the client's limit `max_diff`) he will call this method. It will return additional proof data to verify the changes of the target on the side of the client. This is not a standard Bitcoin rpc-method like the other ones, but more like an internal method.

``` swift
public func proofTarget(target_dap: UInt64, verified_dap: UInt64, max_diff: Int? = 5, max_dap: Int? = 5, limit: Int? = 0) -> Future<[BtcProofTarget]>
```

  - Parameter target\_dap : the number of the difficulty adjustment period (dap) we are looking for

  - Parameter verified\_dap : the number of the closest already verified dap

  - Parameter max\_diff : the maximum target difference between 2 verified daps

  - Parameter max\_dap : the maximum amount of daps between 2 verified daps

**Example**

``` swift
Btc(in3).proofTarget(target_dap: 230, verified_dap: 200, max_diff: 5, max_dap: 5, limit: 15) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          - dap: 205
//            block: 0x04000000e62ef28cb9793f4f9cd2a67a58c1e7b593129b9b...0ab284
//            final: 0x04000000cc69b68b702321adf4b0c485fdb1f3d6c1ddd140...090a5b
//            cbtx: 0x01000000...1485ce370573be63d7cc1b9efbad3489eb57c8...000000
//            cbtxMerkleProof: 0xc72dffc1cb4cbeab960d0d2bdb80012acf7f9c...affcf4
//          - dap: 210
//            block: 0x0000003021622c26a4e62cafa8e434c7e083f540bccc8392...b374ce
//            final: 0x00000020858f8e5124cd516f4d5e6a078f7083c12c48e8cd...308c3d
//            cbtx: 0x01000000...c075061b4b6e434d696e657242332d50314861...000000
//            cbtxMerkleProof: 0xf2885d0bac15fca7e1644c1162899ecd43d52b...93761d
//          - dap: 215
//            block: 0x000000202509b3b8e4f98290c7c9551d180eb2a463f0b978...f97b64
//            final: 0x0000002014c7c0ed7c33c59259b7b508bebfe3974e1c99a5...eb554e
//            cbtx: 0x01000000...90133cf94b1b1c40fae077a7833c0fe0ccc474...000000
//            cbtxMerkleProof: 0x628c8d961adb157f800be7cfb03ffa1b53d3ad...ca5a61
//          - dap: 220
//            block: 0x00000020ff45c783d09706e359dcc76083e15e51839e4ed5...ddfe0e
//            final: 0x0000002039d2f8a1230dd0bee50034e8c63951ab812c0b89...5670c5
//            cbtx: 0x01000000...b98e79fb3e4b88aefbc8ce59e82e99293e5b08...000000
//            cbtxMerkleProof: 0x16adb7aeec2cf254db0bab0f4a5083fb0e0a3f...63a4f4
//          - dap: 225
//            block: 0x02000020170fad0b6b1ccbdc4401d7b1c8ee868c6977d6ce...1e7f8f
//            final: 0x0400000092945abbd7b9f0d407fcccbf418e4fc20570040c...a9b240
//            cbtx: 0x01000000...cf6e8f930acb8f38b588d76cd8c3da3258d5a7...000000
//            cbtxMerkleProof: 0x25575bcaf3e11970ccf835e88d6f97bedd6b85...bfdf46
     }
}
 
```

**Parameters**

  - limit: the maximum amount of daps to return (`0` = no limit) - this is important for embedded devices since returning all daps might be too much for limited memory

**Returns**

A path of daps from the `verified_dap` to the `target_dap` which fulfils the conditions of `max_diff`, `max_dap` and `limit`. Each dap of the path is a `dap`-object with corresponding proof data.

#### getbestblockhash()

Returns the hash of the best (tip) block in the longest blockchain.

``` swift
public func getbestblockhash() -> Future<String>
```

**Example**

``` swift
Btc(in3).getbestblockhash() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 000000000000000000039cbb4e842de0de9651852122b117d7ae6d7ac4fc1df6
     }
}
 
```

**Returns**

the hash of the best block
### Contract

``` swift
public class Contract
```



#### init(in3:abi:abiJSON:at:)

``` swift
public init(in3: In3, abi: [ABI]? = nil, abiJSON: String? = nil, at: String? = nil) throws
```



#### deploy(data:args:account:gas:gasPrice:)

``` swift
public func deploy(data: String, args: [AnyObject], account: String? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil) -> Future<String>
```

#### deployAndWait(data:args:account:gas:gasPrice:)

``` swift
public func deployAndWait(data: String, args: [AnyObject], account: String? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil) -> Future<EthTransactionReceipt>
```

#### createDeployTx(data:args:account:gas:gasPrice:)

``` swift
public func createDeployTx(data: String, args: [AnyObject]? = nil, account: String? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil) throws -> EthTransaction
```

#### call(name:args:block:account:gas:)

``` swift
public func call(name: String, args: [AnyObject], block: UInt64? = nil, account: String? = nil, gas: UInt64? = nil) -> Future<[Any]>
```

#### estimateGas(name:args:account:)

``` swift
public func estimateGas(name: String, args: [AnyObject], account: String? = nil) -> Future<UInt64>
```

#### sendTx(name:args:account:gas:gasPrice:)

``` swift
public func sendTx(name: String, args: [AnyObject], account: String? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil) -> Future<String>
```

#### sendTxAndWait(name:args:account:gas:gasPrice:)

``` swift
public func sendTxAndWait(name: String, args: [AnyObject], account: String? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil) -> Future<EthTransactionReceipt>
```

#### encodeCall(name:args:)

returns the abi encoded arguments as hex string

``` swift
public func encodeCall(name: String, args: [AnyObject]) throws -> String
```

#### createTx(name:args:account:gas:gasPrice:)

``` swift
public func createTx(name: String, args: [AnyObject], account: String? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil) throws -> EthTransaction
```

#### getEvents(eventName:filter:fromBlock:toBlock:topics:)

reads events for the given contract
if the eventName is omitted all events will be returned. ( in this case  filter must be nil \! )

``` swift
public func getEvents(eventName: String? = nil, filter: [String:AnyObject]? = nil, fromBlock: UInt64? = nil, toBlock: UInt64? = nil, topics: [String?]?) -> Future<[EthEvent]>
```
### Eth

Standard JSON-RPC calls as described in https:​//eth.wiki/json-rpc/API.

``` swift
public class Eth
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



#### blockNumber()

returns the number of the most recent block.

``` swift
public func blockNumber() -> Future<UInt64>
```

See [eth\_blockNumber](https://eth.wiki/json-rpc/API#eth_blockNumber) for spec.

No proof returned, since there is none, but the client should verify the result by comparing it to the current blocks returned from others.
With the `blockTime` from the chainspec, including a tolerance, the current blocknumber may be checked if in the proposed range.

**Example**

``` swift
Eth(in3).blockNumber() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0xb8a2a5"
     }
}
 
```

**Returns**

the highest known blocknumber

#### getBlock(blockNumber:)

returns the given Block by number with transactionHashes. if no blocknumber is specified the latest block will be returned.

``` swift
public func getBlock(blockNumber: UInt64? = nil) -> Future<EthBlockdataWithTxHashes?>
```

**Example**

``` swift
Eth(in3).getBlock() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          author: "0x0000000000000000000000000000000000000000"
//          difficulty: "0x2"
//          extraData: 0x696e667572612d696f0000000000000...31570f1e500
//          gasLimit: "0x7a1200"
//          gasUsed: "0x20e145"
//          hash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585"
//          logsBloom: 0x000008000000000000...00400100000000080
//          miner: "0x0000000000000000000000000000000000000000"
//          number: "0x449956"
//          parentHash: "0x2c2a4fcd11aa9aea6b9767651a10e7dbd2bcddbdaba703c74458ad6faf7c2694"
//          receiptsRoot: "0x0240b90272b5600bef7e25d0894868f85125174c2f387ef3236fc9ed9bfb3eff"
//          sealFields:
//            - "0xa00000000000000000000000000000000000000000000000000000000000000000"
//            - "0x880000000000000000"
//          sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347"
//          size: "0x74b"
//          stateRoot: "0xf44699575afd2668060be5ba77e66e1e80edb77ad1b5070969ddfa63da6a4910"
//          timestamp: "0x605aec86"
//          totalDifficulty: "0x6564de"
//          transactions:
//            - "0xcb7edfdb3229c9beeb418ab1ef1a3c9210ecfb22f0157791c3287085d798da58"
//            - "0x0fb803696521ba109c40b3eecb773c93dc6ee891172af0f620c8d44c05198641"
//            - "0x3ef6725cab4470889c3c7d53609a5d4b263701f5891aa98c9ed48b73b6b2fb75"
//            - "0x4010c4c112514756dcdcf14f91117503826dcbe15b03a1636c07aa713da24b8d"
//            - "0xd9c14daa5e2e9cc955534865365ef6bde3045c70e3a984a74c298606c4d67bb5"
//            - "0xfa2326237ba5dcca2127241562be16b68c48fed93d29add8d62f79a00518c2d8"
//          transactionsRoot: "0xddbbd7bf723abdfe885539406540671c2c0eb97684972175ad199258c75416cc"
//          uncles: []
     }
}
 
```

**Parameters**

  - blockNumber: the blockNumber or one of `latest`, `earliest`or `pending`

**Returns**

the blockdata, or in case the block with that number does not exist, `null` will be returned.

#### getBlockWithTx(blockNumber:)

returns the given Block by number with full transaction data. if no blocknumber is specified the latest block will be returned.

``` swift
public func getBlockWithTx(blockNumber: UInt64? = nil) -> Future<EthBlockdata?>
```

**Example**

``` swift
Eth(in3).getBlockWithTx() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          author: "0x0000000000000000000000000000000000000000"
//          difficulty: "0x2"
//          extraData: 0x696e667572612d696f0000000000000...31570f1e500
//          gasLimit: "0x7a1200"
//          gasUsed: "0x20e145"
//          hash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585"
//          logsBloom: 0x000008000000000000...00400100000000080
//          miner: "0x0000000000000000000000000000000000000000"
//          number: "0x449956"
//          parentHash: "0x2c2a4fcd11aa9aea6b9767651a10e7dbd2bcddbdaba703c74458ad6faf7c2694"
//          receiptsRoot: "0x0240b90272b5600bef7e25d0894868f85125174c2f387ef3236fc9ed9bfb3eff"
//          sealFields:
//            - "0xa00000000000000000000000000000000000000000000000000000000000000000"
//            - "0x880000000000000000"
//          sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347"
//          size: "0x74b"
//          stateRoot: "0xf44699575afd2668060be5ba77e66e1e80edb77ad1b5070969ddfa63da6a4910"
//          timestamp: "0x605aec86"
//          totalDifficulty: "0x6564de"
//          transactions:
//            - "0xcb7edfdb3229c9beeb418ab1ef1a3c9210ecfb22f0157791c3287085d798da58"
//            - "0x0fb803696521ba109c40b3eecb773c93dc6ee891172af0f620c8d44c05198641"
//            - "0x3ef6725cab4470889c3c7d53609a5d4b263701f5891aa98c9ed48b73b6b2fb75"
//            - "0x4010c4c112514756dcdcf14f91117503826dcbe15b03a1636c07aa713da24b8d"
//            - "0xd9c14daa5e2e9cc955534865365ef6bde3045c70e3a984a74c298606c4d67bb5"
//            - "0xfa2326237ba5dcca2127241562be16b68c48fed93d29add8d62f79a00518c2d8"
//          transactionsRoot: "0xddbbd7bf723abdfe885539406540671c2c0eb97684972175ad199258c75416cc"
//          uncles: []
     }
}
 
```

**Parameters**

  - blockNumber: the blockNumber or one of `latest`, `earliest`or `pending`

**Returns**

the blockdata, or in case the block with that number does not exist, `null` will be returned.

#### getBlockByHash(blockHash:)

returns the given Block by hash with transactionHashes

``` swift
public func getBlockByHash(blockHash: String) -> Future<EthBlockdataWithTxHashes?>
```

**Example**

``` swift
Eth(in3).getBlockByHash(blockHash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          author: "0x0000000000000000000000000000000000000000"
//          difficulty: "0x2"
//          extraData: 0x696e667572612d696f0000000000000...31570f1e500
//          gasLimit: "0x7a1200"
//          gasUsed: "0x20e145"
//          hash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585"
//          logsBloom: 0x000008000000000000...00400100000000080
//          miner: "0x0000000000000000000000000000000000000000"
//          number: "0x449956"
//          parentHash: "0x2c2a4fcd11aa9aea6b9767651a10e7dbd2bcddbdaba703c74458ad6faf7c2694"
//          receiptsRoot: "0x0240b90272b5600bef7e25d0894868f85125174c2f387ef3236fc9ed9bfb3eff"
//          sealFields:
//            - "0xa00000000000000000000000000000000000000000000000000000000000000000"
//            - "0x880000000000000000"
//          sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347"
//          size: "0x74b"
//          stateRoot: "0xf44699575afd2668060be5ba77e66e1e80edb77ad1b5070969ddfa63da6a4910"
//          timestamp: "0x605aec86"
//          totalDifficulty: "0x6564de"
//          transactions:
//            - "0xcb7edfdb3229c9beeb418ab1ef1a3c9210ecfb22f0157791c3287085d798da58"
//            - "0x0fb803696521ba109c40b3eecb773c93dc6ee891172af0f620c8d44c05198641"
//            - "0x3ef6725cab4470889c3c7d53609a5d4b263701f5891aa98c9ed48b73b6b2fb75"
//            - "0x4010c4c112514756dcdcf14f91117503826dcbe15b03a1636c07aa713da24b8d"
//            - "0xd9c14daa5e2e9cc955534865365ef6bde3045c70e3a984a74c298606c4d67bb5"
//            - "0xfa2326237ba5dcca2127241562be16b68c48fed93d29add8d62f79a00518c2d8"
//          transactionsRoot: "0xddbbd7bf723abdfe885539406540671c2c0eb97684972175ad199258c75416cc"
//          uncles: []
     }
}
 
```

**Parameters**

  - blockHash: the blockHash of the block

**Returns**

the blockdata, or in case the block with that number does not exist, `null` will be returned.

#### getBlockByHashWithTx(blockHash:)

returns the given Block by hash with full transaction data

``` swift
public func getBlockByHashWithTx(blockHash: String) -> Future<EthBlockdata?>
```

**Example**

``` swift
Eth(in3).getBlockByHashWithTx(blockHash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          author: "0x0000000000000000000000000000000000000000"
//          difficulty: "0x2"
//          extraData: 0x696e667572612d696f0000000000000...31570f1e500
//          gasLimit: "0x7a1200"
//          gasUsed: "0x20e145"
//          hash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585"
//          logsBloom: 0x000008000000000000...00400100000000080
//          miner: "0x0000000000000000000000000000000000000000"
//          number: "0x449956"
//          parentHash: "0x2c2a4fcd11aa9aea6b9767651a10e7dbd2bcddbdaba703c74458ad6faf7c2694"
//          receiptsRoot: "0x0240b90272b5600bef7e25d0894868f85125174c2f387ef3236fc9ed9bfb3eff"
//          sealFields:
//            - "0xa00000000000000000000000000000000000000000000000000000000000000000"
//            - "0x880000000000000000"
//          sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347"
//          size: "0x74b"
//          stateRoot: "0xf44699575afd2668060be5ba77e66e1e80edb77ad1b5070969ddfa63da6a4910"
//          timestamp: "0x605aec86"
//          totalDifficulty: "0x6564de"
//          transactions:
//            - "0xcb7edfdb3229c9beeb418ab1ef1a3c9210ecfb22f0157791c3287085d798da58"
//            - "0x0fb803696521ba109c40b3eecb773c93dc6ee891172af0f620c8d44c05198641"
//            - "0x3ef6725cab4470889c3c7d53609a5d4b263701f5891aa98c9ed48b73b6b2fb75"
//            - "0x4010c4c112514756dcdcf14f91117503826dcbe15b03a1636c07aa713da24b8d"
//            - "0xd9c14daa5e2e9cc955534865365ef6bde3045c70e3a984a74c298606c4d67bb5"
//            - "0xfa2326237ba5dcca2127241562be16b68c48fed93d29add8d62f79a00518c2d8"
//          transactionsRoot: "0xddbbd7bf723abdfe885539406540671c2c0eb97684972175ad199258c75416cc"
//          uncles: []
     }
}
 
```

**Parameters**

  - blockHash: the blockHash of the block

**Returns**

the blockdata, or in case the block with that number does not exist, `null` will be returned.

#### getBlockTransactionCountByHash(blockHash:)

returns the number of transactions. For Spec, see [eth\_getBlockTransactionCountByHash](https:​//eth.wiki/json-rpc/API#eth_getBlockTransactionCountByHash).

``` swift
public func getBlockTransactionCountByHash(blockHash: String) -> Future<String>
```

**Parameters**

  - blockHash: the blockHash of the block

**Returns**

the number of transactions in the block

#### getBlockTransactionCountByNumber(blockNumber:)

returns the number of transactions. For Spec, see [eth\_getBlockTransactionCountByNumber](https:​//eth.wiki/json-rpc/API#eth_getBlockTransactionCountByNumber).

``` swift
public func getBlockTransactionCountByNumber(blockNumber: UInt64) -> Future<String>
```

**Parameters**

  - blockNumber: the blockNumber of the block

**Returns**

the number of transactions in the block

#### getUncleCountByBlockHash(blockHash:)

returns the number of uncles. For Spec, see [eth\_getUncleCountByBlockHash](https:​//eth.wiki/json-rpc/API#eth_getUncleCountByBlockHash).

``` swift
public func getUncleCountByBlockHash(blockHash: String) -> Future<String>
```

**Parameters**

  - blockHash: the blockHash of the block

**Returns**

the number of uncles

#### getUncleCountByBlockNumber(blockNumber:)

returns the number of uncles. For Spec, see [eth\_getUncleCountByBlockNumber](https:​//eth.wiki/json-rpc/API#eth_getUncleCountByBlockNumber).

``` swift
public func getUncleCountByBlockNumber(blockNumber: UInt64) -> Future<String>
```

**Parameters**

  - blockNumber: the blockNumber of the block

**Returns**

the number of uncles

#### getTransactionByBlockHashAndIndex(blockHash:index:)

returns the transaction data.

``` swift
public func getTransactionByBlockHashAndIndex(blockHash: String, index: Int) -> Future<EthTransactiondata>
```

See JSON-RPC-Spec for [eth\_getTransactionByBlockHashAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockHashAndIndex) for more details.

**Example**

``` swift
Eth(in3).getTransactionByBlockHashAndIndex(blockHash: "0x4fc08daf8d670a23eba7a1aca1f09591c19147305c64d25e1ddd3dd43ff658ee", index: "0xd5") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          blockHash: "0x4fc08daf8d670a23eba7a1aca1f09591c19147305c64d25e1ddd3dd43ff658ee"
//          blockNumber: "0xb8a4a9"
//          from: "0xcaa6cfc2ca92cabbdbce5a46901ee8b831e00a98"
//          gas: "0xac6b"
//          gasPrice: "0x1bf08eb000"
//          hash: "0xd635a97452d604f735116d9de29ac946e9987a20f99607fb03516ef267ea0eea"
//          input: 0x095ea7b300000000000000000000000...a7640000
//          nonce: "0xa"
//          to: "0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce"
//          transactionIndex: "0xd5"
//          value: "0x0"
//          type: "0x0"
//          v: "0x25"
//          r: "0xb18e0928c988d898d3217b145d78439072db15ea7de1005a73cf5feaf01a57d4"
//          s: "0x6b530c2613f543f9e26ef9c27a7986c748fbc856aaeacd6000a8ff46d2a2dd78"
     }
}
 
```

**Parameters**

  - blockHash: the blockhash containing the transaction.
  - index: the transactionIndex

**Returns**

the transactiondata or `null` if it does not exist

#### getTransactionByBlockNumberAndIndex(blockNumber:index:)

returns the transaction data.

``` swift
public func getTransactionByBlockNumberAndIndex(blockNumber: UInt64, index: Int) -> Future<EthTransactiondata>
```

See JSON-RPC-Spec for [eth\_getTransactionByBlockNumberAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockNumberAndIndex) for more details.

**Example**

``` swift
Eth(in3).getTransactionByBlockNumberAndIndex(blockNumber: "0xb8a4a9", index: "0xd5") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          blockHash: "0x4fc08daf8d670a23eba7a1aca1f09591c19147305c64d25e1ddd3dd43ff658ee"
//          blockNumber: "0xb8a4a9"
//          from: "0xcaa6cfc2ca92cabbdbce5a46901ee8b831e00a98"
//          gas: "0xac6b"
//          gasPrice: "0x1bf08eb000"
//          hash: "0xd635a97452d604f735116d9de29ac946e9987a20f99607fb03516ef267ea0eea"
//          input: 0x095ea7b300000000000000000000000...a7640000
//          nonce: "0xa"
//          to: "0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce"
//          transactionIndex: "0xd5"
//          value: "0x0"
//          type: "0x0"
//          v: "0x25"
//          r: "0xb18e0928c988d898d3217b145d78439072db15ea7de1005a73cf5feaf01a57d4"
//          s: "0x6b530c2613f543f9e26ef9c27a7986c748fbc856aaeacd6000a8ff46d2a2dd78"
     }
}
 
```

**Parameters**

  - blockNumber: the block number containing the transaction.
  - index: the transactionIndex

**Returns**

the transactiondata or `null` if it does not exist

#### getTransactionByHash(txHash:)

returns the transaction data.

``` swift
public func getTransactionByHash(txHash: String) -> Future<EthTransactiondata>
```

See JSON-RPC-Spec for [eth\_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash) for more details.

**Example**

``` swift
Eth(in3).getTransactionByHash(txHash: "0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          blockHash: "0x4fc08daf8d670a23eba7a1aca1f09591c19147305c64d25e1ddd3dd43ff658ee"
//          blockNumber: "0xb8a4a9"
//          from: "0xcaa6cfc2ca92cabbdbce5a46901ee8b831e00a98"
//          gas: "0xac6b"
//          gasPrice: "0x1bf08eb000"
//          hash: "0xd635a97452d604f735116d9de29ac946e9987a20f99607fb03516ef267ea0eea"
//          input: 0x095ea7b300000000000000000000000...a7640000
//          nonce: "0xa"
//          to: "0x95ad61b0a150d79219dcf64e1e6cc01f0b64c4ce"
//          transactionIndex: "0xd5"
//          value: "0x0"
//          type: "0x0"
//          v: "0x25"
//          r: "0xb18e0928c988d898d3217b145d78439072db15ea7de1005a73cf5feaf01a57d4"
//          s: "0x6b530c2613f543f9e26ef9c27a7986c748fbc856aaeacd6000a8ff46d2a2dd78"
     }
}
 
```

**Parameters**

  - txHash: the transactionHash of the transaction.

**Returns**

the transactiondata or `null` if it does not exist

#### getLogs(filter:)

searches for events matching the given criteria. See [eth\_getLogs](https:​//eth.wiki/json-rpc/API#eth_getLogs) for the spec.

``` swift
public func getLogs(filter: EthFilter) -> Future<[Ethlog]>
```

**Parameters**

  - filter: The filter criteria for the events.

**Returns**

array with all found event matching the specified filter

#### getBalance(account:block:)

gets the balance of an account for a given block

``` swift
public func getBalance(account: String, block: UInt64? = nil) -> Future<UInt256>
```

**Example**

``` swift
Eth(in3).getBalance(account: "0x2e333ec090f1028df0a3c39a918063443be82b2b") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0x20599832af6ec00"
     }
}
 
```

**Parameters**

  - account: address of the account
  - block: the blockNumber or `latest`

**Returns**

the balance

#### getTransactionCount(account:block:)

gets the nonce or number of transaction sent from this account at a given block

``` swift
public func getTransactionCount(account: String, block: UInt64? = nil) -> Future<String>
```

**Example**

``` swift
Eth(in3).getTransactionCount(account: "0x2e333ec090f1028df0a3c39a918063443be82b2b") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0x5"
     }
}
 
```

**Parameters**

  - account: address of the account
  - block: the blockNumber or  `latest`

**Returns**

the nonce

#### getCode(account:block:)

gets the code of a given contract

``` swift
public func getCode(account: String, block: UInt64? = nil) -> Future<String>
```

**Example**

``` swift
Eth(in3).getCode(account: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 0x6080604052348...6c634300050a0040
     }
}
 
```

**Parameters**

  - account: address of the account
  - block: the blockNumber or `latest`

**Returns**

the code as hex

#### getStorageAt(account:key:block:)

gets the storage value of a given key

``` swift
public func getStorageAt(account: String, key: String, block: UInt64? = nil) -> Future<String>
```

**Example**

``` swift
Eth(in3).getStorageAt(account: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f", key: "0x0") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0x19"
     }
}
 
```

**Parameters**

  - account: address of the account
  - key: key to look for
  - block: the blockNumber or`latest`

**Returns**

the value of the storage slot.

#### sendTransaction(tx:)

signs and sends a Transaction

``` swift
public func sendTransaction(tx: EthTransaction) -> Future<String>
```

**Parameters**

  - tx: the transactiondata to send

**Returns**

the transactionHash

#### sendTransactionAndWait(tx:)

signs and sends a Transaction, but then waits until the transaction receipt can be verified. Depending on the finality of the nodes, this may take a while, since only final blocks will be signed by the nodes.

``` swift
public func sendTransactionAndWait(tx: EthTransaction) -> Future<EthTransactionReceipt>
```

**Parameters**

  - tx: the transactiondata to send

**Returns**

the transactionReceipt

#### sendRawTransaction(tx:)

sends or broadcasts a prviously signed raw transaction. See [eth\_sendRawTransaction](https:​//eth.wiki/json-rpc/API#eth_sendRawTransaction)

``` swift
public func sendRawTransaction(tx: String) -> Future<String>
```

**Parameters**

  - tx: the raw signed transactiondata to send

**Returns**

the transactionhash

#### estimateGas(tx:block:)

calculates the gas needed to execute a transaction. for spec see [eth\_estimateGas](https:​//eth.wiki/json-rpc/API#eth_estimateGas)

``` swift
public func estimateGas(tx: EthTransaction, block: UInt64? = nil) -> Future<UInt64>
```

**Parameters**

  - tx: the tx-object, which is the same as specified in [eth\_sendTransaction](https://eth.wiki/json-rpc/API#eth_sendTransaction).
  - block: the blockNumber or  `latest`

**Returns**

the amount of gass needed.

#### call(tx:block:)

calls a function of a contract (or simply executes the evm opcodes) and returns the result. for spec see [eth\_call](https:​//eth.wiki/json-rpc/API#eth_call)

``` swift
public func call(tx: EthTransaction, block: UInt64? = nil) -> Future<String>
```

**Example**

``` swift
Eth(in3).call(tx: EthTransaction(to: "0x2736D225f85740f42D17987100dc8d58e9e16252", data: "0x5cf0f3570000000000000000000000000000000000000000000000000000000000000001")) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 0x0000000000000000000000000...
     }
}
 
```

**Parameters**

  - tx: the tx-object, which is the same as specified in [eth\_sendTransaction](https://eth.wiki/json-rpc/API#eth_sendTransaction).
  - block: the blockNumber or  `latest`

**Returns**

the abi-encoded result of the function.

#### getTransactionReceipt(txHash:)

The Receipt of a Transaction. For Details, see [eth\_getTransactionReceipt](https:​//eth.wiki/json-rpc/API#eth_gettransactionreceipt).

``` swift
public func getTransactionReceipt(txHash: String) -> Future<EthTransactionReceipt?>
```

**Example**

``` swift
Eth(in3).getTransactionReceipt(txHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          blockHash: "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304"
//          blockNumber: "0x8c1e39"
//          contractAddress: null
//          cumulativeGasUsed: "0x2466d"
//          gasUsed: "0x2466d"
//          logs:
//            - address: "0x85ec283a3ed4b66df4da23656d4bf8a507383bca"
//              blockHash: "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304"
//              blockNumber: "0x8c1e39"
//              data: 0x00000000000...
//              logIndex: "0x0"
//              removed: false
//              topics:
//                - "0x9123e6a7c5d144bd06140643c88de8e01adcbb24350190c02218a4435c7041f8"
//                - "0xa2f7689fc12ea917d9029117d32b9fdef2a53462c853462ca86b71b97dd84af6"
//                - "0x55a6ef49ec5dcf6cd006d21f151f390692eedd839c813a150000000000000000"
//              transactionHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
//              transactionIndex: "0x0"
//              transactionLogIndex: "0x0"
//              type: mined
//          logsBloom: 0x00000000000000000000200000...
//          root: null
//          status: "0x1"
//          transactionHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
//          transactionIndex: "0x0"
     }
}
 
```

**Parameters**

  - txHash: the transactionHash

**Returns**

the TransactionReceipt or `null`  if it does not exist.
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

The Incubed client

``` swift
public class In3
```



#### init(_:)

initialize with a Configurations

``` swift
public init(_ config: In3Config) throws
```



#### transport

the transport function

``` swift
var transport: (_ url: String, _ method:String, _ payload:Data?, _ headers: [String], _ cb: @escaping (_ data:TransportResult)->Void) -> Void
```



#### configure(_:)

change the configuration.

``` swift
public func configure(_ config: In3Config) throws
```

  - Paramater config : the partial or full Configuration to change.

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

executes a asnychronous request

``` swift
public func exec(_ method: String, _ params: RPCObject, cb: @escaping  (_ result:RequestResult)->Void) throws
```

This requires a transport to be set

**Parameters**

  - method: the rpc-method to call
  - params: the paramas as ROCPobjects
  - cb: the callback which will be called with a Result (either success or error ) when done.

#### executeJSON(_:)

executes a json-rpc encoded request synchonously and returns the result as json-string

``` swift
public func executeJSON(_ rpc: String) -> String
```
### Ipfs

A Node supporting IPFS must support these 2 RPC-Methods for uploading and downloading IPFS-Content. The node itself will run a ipfs-client to handle them.

``` swift
public class Ipfs
```

Fetching ipfs-content can be easily verified by creating the ipfs-hash based on the received data and comparing it to the requested ipfs-hash. Since there is no chance of manipulating the data, there is also no need to put a deposit or convict a node. That's why the registry-contract allows a zero-deposit fot ipfs-nodes.



#### get(ipfshash:encoding:)

Fetches the data for a requested ipfs-hash. If the node is not able to resolve the hash or find the data a error should be reported.

``` swift
public func get(ipfshash: String, encoding: String) -> Future<String>
```

**Example**

``` swift
Ipfs(in3).get(ipfshash: "QmSepGsypERjq71BSm4Cjq7j8tyAUnCw6ZDTeNdE8RUssD", encoding: "utf8") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = I love Incubed
     }
}
 
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

**Example**

``` swift
Ipfs(in3).put(data: "I love Incubed", encoding: "utf8") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = QmSepGsypERjq71BSm4Cjq7j8tyAUnCw6ZDTeNdE8RUssD
     }
}
 
```

**Parameters**

  - data: the content encoded with the specified encoding.
  - encoding: the encoding used for the request. ( `hex` , `base64` or `utf8`)

**Returns**

the ipfs multi hash
### Nodelist

special Incubed nodelist-handling functions. Most of those are only used internally.

``` swift
public class Nodelist
```



#### nodes(limit:seed:addresses:)

fetches and verifies the nodeList from a node

``` swift
public func nodes(limit: Int? = nil, seed: String? = nil, addresses: [String]? = nil) -> Future<NodeListDefinition>
```

**Example**

``` swift
Nodelist(in3).nodes(limit: 2, seed: "0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b", addresses: []) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          totalServers: 5
//          contract: "0x64abe24afbba64cae47e3dc3ced0fcab95e4edd5"
//          registryId: "0x423dd84f33a44f60e5d58090dcdcc1c047f57be895415822f211b8cd1fd692e3"
//          lastBlockNumber: 8669495
//          nodes:
//            - url: https://in3-v2.slock.it/mainnet/nd-3
//              address: "0x945F75c0408C0026a3CD204d36f5e47745182fd4"
//              index: 2
//              deposit: "10000000000000000"
//              props: 29
//              timeout: 3600
//              registerTime: 1570109570
//              weight: 2000
//              proofHash: "0x27ffb9b7dc2c5f800c13731e7c1e43fb438928dd5d69aaa8159c21fb13180a4c"
//            - url: https://in3-v2.slock.it/mainnet/nd-5
//              address: "0xbcdF4E3e90cc7288b578329efd7bcC90655148d2"
//              index: 4
//              deposit: "10000000000000000"
//              props: 29
//              timeout: 3600
//              registerTime: 1570109690
//              weight: 2000
//              proofHash: "0xd0dbb6f1e28a8b90761b973e678cf8ecd6b5b3a9d61fb9797d187be011ee9ec7"
     }
}
 
```

**Parameters**

  - limit: if the number is defined and \>0 this method will return a partial nodeList limited to the given number.
  - seed: this 32byte hex integer is used to calculate the indexes of the partial nodeList. It is expected to be a random value choosen by the client in order to make the result deterministic.
  - addresses: a optional array of addresses of signers the nodeList must include.

**Returns**

the current nodelist

#### signBlockHash(blocks:)

requests a signed blockhash from the node.
In most cases these requests will come from other nodes, because the client simply adds the addresses of the requested signers
and the processising nodes will then aquire the signatures with this method from the other nodes.

``` swift
public func signBlockHash(blocks: NodelistBlocks) -> Future<NodelistSignBlockHash>
```

Since each node has a risk of signing a wrong blockhash and getting convicted and losing its deposit,
per default nodes will and should not sign blockHash of the last `minBlockHeight` (default: 6) blocks\!

**Example**

``` swift
Nodelist(in3).signBlockHash(blocks: NodelistBlocks(blockNumber: 8770580)) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          - blockHash: "0xd8189793f64567992eaadefc51834f3d787b03e9a6850b8b9b8003d8d84a76c8"
//            block: 8770580
//            r: "0x954ed45416e97387a55b2231bff5dd72e822e4a5d60fa43bc9f9e49402019337"
//            s: "0x277163f586585092d146d0d6885095c35c02b360e4125730c52332cf6b99e596"
//            v: 28
//            msgHash: "0x40c23a32947f40a2560fcb633ab7fa4f3a96e33653096b17ec613fbf41f946ef"
     }
}
 
```

**Parameters**

  - blocks: array of requested blocks.

**Returns**

the Array with signatures of all the requires blocks.

#### whitelist(address:)

Returns whitelisted in3-nodes addresses. The whitelist addressed are accquired from whitelist contract that user can specify in request params.

``` swift
public func whitelist(address: String) -> Future<NodelistWhitelist>
```

**Example**

``` swift
Nodelist(in3).whitelist(address: "0x08e97ef0a92EB502a1D7574913E2a6636BeC557b") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          totalServers: 2
//          contract: "0x08e97ef0a92EB502a1D7574913E2a6636BeC557b"
//          lastBlockNumber: 1546354
//          nodes:
//            - "0x1fe2e9bf29aa1938859af64c413361227d04059a"
//            - "0x45d45e6ff99e6c34a235d263965910298985fcfe"
     }
}
 
```

**Parameters**

  - address: address of whitelist contract

**Returns**

the whitelisted addresses
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
### UInt256

a bigint implementation based on tommath to represent big numbers
It is used to represent uint256 values

``` swift
final public class UInt256: CustomStringConvertible, Hashable, Comparable, Decodable, Encodable
```



`Comparable`, `CustomStringConvertible`, `Decodable`, `Encodable`, `Hashable`



#### init()

creates a empt (0)-value

``` swift
public init()
```

#### init(_:)

i nitializes its value from a uint64 type

``` swift
public init(_ v: UInt64)
```

#### init(_:)

inits its value from a Int

``` swift
public required convenience init(_ val: IntegerLiteralType)
```

#### init(_:)

copies the value from another UInt256

``` swift
public init(_ value: UInt256)
```

#### init?(_:radix:)

initialze the value from a string.
if the string starts with '0x' it will interpreted as radix 16
otherwise the default for the radix is 10

``` swift
public init?(_ val: String, radix: Int = 10)
```

**Parameters**

  - radix: the radix or the base to use when parsing the String (10 - decimal, 16 - hex, 2 - binary ... )

#### init(from:)

initializes from a decoder

``` swift
public init(from decoder: Decoder) throws
```



#### doubleValue

returns the value as Double (as close as possible)

``` swift
var doubleValue: Double
```

#### hexValue

the hex representation staring with '0x'

``` swift
var hexValue: String
```

#### uintValue

a unsigned Int representation (if possible)

``` swift
var uintValue: UInt
```

#### uint64Value

a unsigned UInt64 representation (if possible)

``` swift
var uint64Value: UInt64
```

#### description

String representation as decimals

``` swift
var description: String
```



#### encode(to:)

encodes the value to a decoder

``` swift
public func encode(to encoder: Encoder) throws
```

#### hash(into:)

hash of the value

``` swift
public func hash(into hasher: inout Hasher)
```

#### toString(radix:)

a string representation based on the given radix.

``` swift
public func toString(radix: Int = 10) -> String
```

**Parameters**

  - radix: the radix or the base to use when parsing the String (10 - decimal, 16 - hex, 2 - binary ... )

#### compare(other:)

compare 2 UInt256 values
the result is zero if they are equal
negative if the current value is smaller than the given
positive if the current value is higher than the given

``` swift
public func compare(other: UInt256) -> Int32
```

#### add(_:)

adds the given number and returns the sum of both

``` swift
public func add(_ val: UInt256) -> UInt256
```

#### sub(_:)

substracts the given number and returns the difference of both

``` swift
public func sub(_ val: UInt256) -> UInt256
```

#### mul(_:)

multiplies the current with the given number and returns the product of both

``` swift
public func mul(_ val: UInt256) -> UInt256
```

#### div(_:)

divides the current number by the given and return the result

``` swift
public func div(_ val: UInt256) -> UInt256
```

#### mod(_:)

divides the current number by the given and return the rest or module operator

``` swift
public func mod(_ val: UInt256) -> UInt256
```
### Utils

a Collection of utility-function.

``` swift
public class Utils
```



#### abiEncode(signature:params:)

based on the [ABI-encoding](https:​//solidity.readthedocs.io/en/v0.5.3/abi-spec.html) used by solidity, this function encodes the value given and returns it as hexstring.

``` swift
public func abiEncode(signature: String, params: [AnyObject]) throws -> String
```

**Example**

``` swift
let result = try Utils(in3).abiEncode(signature: "getBalance(address)", params: ["0x1234567890123456789012345678901234567890"])
// result = "0xf8b2cb4f0000000000000000000000001234567890123456789012345678901234567890"
```

**Parameters**

  - signature: the signature of the function. e.g. `getBalance(uint256)`. The format is the same as used by solidity to create the functionhash. optional you can also add the return type, which in this case is ignored.
  - params: a array of arguments. the number of arguments must match the arguments in the signature.

**Returns**

the ABI-encoded data as hex including the 4 byte function-signature. These data can be used for `eth_call` or to send a transaction.

#### abiDecode(signature:data:topics:)

based on the [ABI-encoding](https:​//solidity.readthedocs.io/en/v0.5.3/abi-spec.html) used by solidity, this function decodes the bytes given and returns it as array of values.

``` swift
public func abiDecode(signature: String, data: String, topics: String? = nil) throws -> [RPCObject]
```

**Example**

``` swift
let result = try Utils(in3).abiDecode(signature: "(address,uint256)", data: "0x00000000000000000000000012345678901234567890123456789012345678900000000000000000000000000000000000000000000000000000000000000005")
// result = 
//          - "0x1234567890123456789012345678901234567890"
//          - "0x05"
```

**Parameters**

  - signature: the signature of the function. e.g. `uint256`, `(address,string,uint256)` or `getBalance(address):uint256`. If the complete functionhash is given, only the return-part will be used.
  - data: the data to decode (usually the result of a eth\_call)
  - topics: in case of an even the topics (concatinated to max 4x32bytes). This is used if indexed.arguments are used.

**Returns**

a array with the values after decodeing.

#### checksumAddress(address:useChainId:)

Will convert an upper or lowercase Ethereum address to a checksum address.  (See [EIP55](https:​//github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) )

``` swift
public func checksumAddress(address: String, useChainId: Bool? = nil) throws -> String
```

**Example**

``` swift
let result = try Utils(in3).checksumAddress(address: "0x1fe2e9bf29aa1938859af64c413361227d04059a", useChainId: false)
// result = "0x1Fe2E9bf29aa1938859Af64C413361227d04059a"
```

**Parameters**

  - address: the address to convert.
  - useChainId: if true, the chainId is integrated as well (See [EIP1191](https://github.com/ethereum/EIPs/issues/1121) )

**Returns**

the address-string using the upper/lowercase hex characters.

#### toWei(value:unit:)

converts the given value into wei.

``` swift
public func toWei(value: String, unit: String? = "eth") throws -> String
```

**Example**

``` swift
let result = try Utils(in3).toWei(value: "20.0009123", unit: "eth")
// result = "0x01159183c4793db800"
```

**Parameters**

  - value: the value, which may be floating number as string
  - unit: the unit of the value, which must be one of `wei`, `kwei`,  `Kwei`,  `babbage`,  `femtoether`,  `mwei`,  `Mwei`,  `lovelace`,  `picoether`,  `gwei`,  `Gwei`,  `shannon`,  `nanoether`,  `nano`,  `szabo`,  `microether`,  `micro`,  `finney`,  `milliether`,  `milli`,  `ether`,  `eth`,  `kether`,  `grand`,  `mether`,  `gether` or  `tether`

**Returns**

the value in wei as hex.

#### fromWei(value:unit:digits:)

converts a given uint (also as hex) with a wei-value into a specified unit.

``` swift
public func fromWei(value: UInt256, unit: String, digits: Int? = nil) throws -> String
```

**Example**

``` swift
let result = try Utils(in3).fromWei(value: "0x234324abadefdef", unit: "eth", digits: 3)
// result = "0.158"
```

**Parameters**

  - value: the value in wei
  - unit: the unit of the target value, which must be one of `wei`, `kwei`,  `Kwei`,  `babbage`,  `femtoether`,  `mwei`,  `Mwei`,  `lovelace`,  `picoether`,  `gwei`,  `Gwei`,  `shannon`,  `nanoether`,  `nano`,  `szabo`,  `microether`,  `micro`,  `finney`,  `milliether`,  `milli`,  `ether`,  `eth`,  `kether`,  `grand`,  `mether`,  `gether` or  `tether`
  - digits: fix number of digits after the comma. If left out, only as many as needed will be included.

**Returns**

the value as string.

#### cacheClear()

clears the incubed cache (usually found in the .in3-folder)

``` swift
public func cacheClear() throws -> String
```

**Example**

``` swift
let result = try Utils(in3).cacheClear()
// result = true
```

**Returns**

true indicating the success

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

**Example**

``` swift
let result = try Utils(in3).keccak(data: "0x1234567890")
// result = "0x3a56b02b60d4990074262f496ac34733f870e1b7815719b46ce155beac5e1a41"
```

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

**Example**

``` swift
let result = try Utils(in3).sha3(data: "0x1234567890")
// result = "0x3a56b02b60d4990074262f496ac34733f870e1b7815719b46ce155beac5e1a41"
```

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

**Example**

``` swift
let result = try Utils(in3).sha256(data: "0x1234567890")
// result = "0x6c450e037e79b76f231a71a22ff40403f7d9b74b15e014e52fe1156d3666c3e6"
```

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### calcDeployAddress(sender:nonce:)

calculates the address of a contract about to deploy. The address depends on the senders nonce.

``` swift
public func calcDeployAddress(sender: String, nonce: UInt64? = nil) -> Future<String>
```

**Example**

``` swift
Utils(in3).calcDeployAddress(sender: "0x5a0b54d5dc17e0aadc383d2db43b0a0d3e029c4c", nonce: 6054986) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0xba866e7bd2573be3eaf5077b557751bb6d58076e"
     }
}
 
```

**Parameters**

  - sender: the sender of the transaction
  - nonce: the nonce of the sender during deployment

**Returns**

the address of the deployed contract

#### version()

the Network Version (currently 1)

``` swift
public func version() throws -> String
```

**Returns**

the Version number
### Zksync

*Important:​ This feature is still experimental and not considered stable yet. In order to use it, you need to set the experimental-flag (-x on the comandline or `"experimental":​true`\!*

``` swift
public class Zksync
```

the zksync-plugin is able to handle operations to use [zksync](https://zksync.io/) like deposit transfer or withdraw. Also see the \#in3-config on how to configure the zksync-server or account.

Also in order to sign messages you need to set a signer\!

All zksync-methods can be used with `zksync_` or `zk_` prefix.



#### contractAddress()

returns the contract address

``` swift
public func contractAddress() -> Future<ZksyncContractAddress>
```

**Example**

``` swift
Zksync(in3).contractAddress() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          govContract: "0x34460C0EB5074C29A9F6FE13b8e7E23A0D08aF01"
//          mainContract: "0xaBEA9132b05A70803a4E85094fD0e1800777fBEF"
     }
}
 
```

**Returns**

fetches the contract addresses from the zksync server. This request also caches them and will return the results from cahe if available.

#### tokens()

returns the list of all available tokens

``` swift
public func tokens() -> Future<[String:ZksyncTokens]>
```

**Example**

``` swift
Zksync(in3).tokens() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          BAT:
//            address: "0x0d8775f648430679a709e98d2b0cb6250d2887ef"
//            decimals: 18
//            id: 8
//            symbol: BAT
//          BUSD:
//            address: "0x4fabb145d64652a948d72533023f6e7a623c7c53"
//            decimals: 18
//            id: 6
//            symbol: BUSD
//          DAI:
//            address: "0x6b175474e89094c44da98b954eedeac495271d0f"
//            decimals: 18
//            id: 1
//            symbol: DAI
//          ETH:
//            address: "0x0000000000000000000000000000000000000000"
//            decimals: 18
//            id: 0
//            symbol: ETH
     }
}
 
```

**Returns**

a array of tokens-definitions. This request also caches them and will return the results from cahe if available.

#### accountInfo(address:)

returns account\_info from the server

``` swift
public func accountInfo(address: String? = nil) -> Future<ZksyncAccountInfo>
```

**Example**

``` swift
Zksync(in3).accountInfo() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          address: "0x3b2a1bd631d9d7b17e87429a8e78dbbd9b4de292"
//          committed:
//            balances: {}
//            nonce: 0
//            pubKeyHash: sync:0000000000000000000000000000000000000000
//          depositing:
//            balances: {}
//          id: null
//          verified:
//            balances: {}
//            nonce: 0
//            pubKeyHash: sync:0000000000000000000000000000000000000000
     }
}
 
```

**Parameters**

  - address: the account-address. if not specified, the client will try to use its own address based on the signer config.

**Returns**

the current state of the requested account.

#### txInfo(tx:)

returns the state or receipt of the the zksync-tx

``` swift
public func txInfo(tx: String) -> Future<ZksyncTxInfo>
```

**Example**

``` swift
Zksync(in3).txInfo(tx: "sync-tx:e41d2489571d322189246dafa5ebde1f4699f498000000000000000000000000") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          block: null
//          executed: false
//          failReason: null
//          success: null
     }
}
 
```

**Parameters**

  - tx: the txHash of the send tx

**Returns**

the current state of the requested tx.

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

**Example**

``` swift
Zksync(in3).setKey(token: "eth") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = sync:e41d2489571d322189246dafa5ebde1f4699f498
     }
}
 
```

**Parameters**

  - token: the token to pay the gas (either the symbol or the address)

**Returns**

the pubKeyHash, if it was executed successfully

#### pubkeyhash(pubKey:)

returns the current PubKeyHash based on the configuration set.

``` swift
public func pubkeyhash(pubKey: String? = nil) throws -> String
```

**Example**

``` swift
let result = try Zksync(in3).pubkeyhash()
// result = sync:4dcd9bb4463121470c7232efb9ff23ec21398e58
```

**Parameters**

  - pubKey: the packed public key to hash ( if given the hash is build based on the given hash, otherwise the hash is based on the config)

**Returns**

the pubKeyHash

#### pubkey()

returns the current packed PubKey based on the config set.

``` swift
public func pubkey() throws -> String
```

If the config contains public keys for musig-signatures, the keys will be aggregated, otherwise the pubkey will be derrived from the signing key set.

**Example**

``` swift
let result = try Zksync(in3).pubkey()
// result = "0xfca80a469dbb53f8002eb1e2569d66f156f0df24d71bd589432cc7bc647bfc04"
```

**Returns**

the pubKey

#### accountAddress()

returns the address of the account used.

``` swift
public func accountAddress() throws -> String
```

**Example**

``` swift
let result = try Zksync(in3).accountAddress()
// result = "0x3b2a1bd631d9d7b17e87429a8e78dbbd9b4de292"
```

**Returns**

the account used.

#### sign(message:)

returns the schnorr musig signature based on the current config.

``` swift
public func sign(message: String) -> Future<String>
```

This also supports signing with multiple keys. In this case the configuration needs to sets the urls of the other keys, so the client can then excange all data needed in order to create the combined signature.
when exchanging the data with other keys, all known data will be send using `zk_sign` as method, but instead of the raw message a object with those data will be passed.

  - `[0...32]` packed public key

  - `[32..64]` r-value

  - `[64..96]` s-value

**Example**

``` swift
Zksync(in3).sign(message: "0xaabbccddeeff") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0xfca80a469dbb53f8002eb1e2569d66f156f0df24d71bd589432cc7bc647bfc0493f69034c398\
//          0e7352741afa6c171b8e18355e41ed7427f6e706f8432e32e920c3e61e6c3aa00cfe0c202c29a31\
//          b69cd0910a432156a0977c3a5baa404547e01"
     }
}
 
```

**Parameters**

  - message: the message to sign

**Returns**

The return value are 96 bytes of signature:​

#### verify(message:signature:)

returns 0 or 1 depending on the successfull verification of the signature.

``` swift
public func verify(message: String, signature: String) throws -> Int
```

if the `musig_pubkeys` are set it will also verify against the given public keys list.

**Example**

``` swift
let result = try Zksync(in3).verify(message: "0xaabbccddeeff", signature: "0xfca80a469dbb53f8002eb1e2569d66f156f0df24d71bd589432cc7bc647bfc0493f69034c3980e7352741afa6c171b8e18355e41ed7427f6e706f8432e32e920c3e61e6c3aa00cfe0c202c29a31b69cd0910a432156a0977c3a5baa404547e01")
// result = 1
```

**Parameters**

  - message: the message which was supposed to be signed
  - signature: the signature (96 bytes)

**Returns**

1 if the signature(which contains the pubkey as the first 32bytes) matches the message.

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
public func getTokenPrice(token: String) -> Future<Double>
```

**Example**

``` swift
Zksync(in3).getTokenPrice(token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 11320.002167
     }
}
 
```

**Parameters**

  - token: Symbol or address of the token

**Returns**

the token price

#### getTxFee(txType:address:token:)

calculates the fees for a transaction.

``` swift
public func getTxFee(txType: String, address: String, token: String) -> Future<ZksyncTxFee>
```

**Example**

``` swift
Zksync(in3).getTxFee(txType: "Transfer", address: "0xabea9132b05a70803a4e85094fd0e1800777fbef", token: "BAT") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          feeType: TransferToNew
//          gasFee: "47684047990828528"
//          gasPriceWei: "116000000000"
//          gasTxAmount: "350"
//          totalFee: "66000000000000000"
//          zkpFee: "18378682992117666"
     }
}
 
```

**Parameters**

  - txType: The Type of the transaction "Withdraw" or "Transfer"
  - address: the address of the receipient
  - token: the symbol or address of the token to pay

**Returns**

the fees split up into single values

#### syncKey()

returns private key used for signing zksync-transactions

``` swift
public func syncKey() -> Future<String>
```

**Example**

``` swift
Zksync(in3).syncKey() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0x019125314fda133d5bf62cb454ee8c60927d55b68eae8b8b8bd13db814389cd6"
     }
}
 
```

**Returns**

the raw private key configured based on the signers seed

#### deposit(amount:token:approveDepositAmountForERC20:account:)

sends a deposit-transaction and returns the opId, which can be used to tradck progress.

``` swift
public func deposit(amount: UInt256, token: String, approveDepositAmountForERC20: Bool? = nil, account: String? = nil) -> Future<UInt64>
```

**Example**

``` swift
Zksync(in3).deposit(amount: 1000, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 74
     }
}
 
```

**Parameters**

  - amount: the value to deposit in wei (or smallest token unit)
  - token: the token as symbol or address
  - approveDepositAmountForERC20: if true and in case of an erc20-token, the client will send a approve transaction first, otherwise it is expected to be already approved.
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the opId. You can use `zksync_ethop_info` to follow the state-changes.

#### transfer(to:amount:token:account:)

sends a zksync-transaction and returns data including the transactionHash.

``` swift
public func transfer(to: String, amount: UInt256, token: String, account: String? = nil) -> Future<String>
```

**Example**

``` swift
Zksync(in3).transfer(to: 9.814684447173249e+47, amount: 100, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0x58ba1537596739d990a33e4fba3a6fb4e0d612c5de30843a2c415dd1e5edcef1"
     }
}
 
```

**Parameters**

  - to: the receipient of the tokens
  - amount: the value to transfer in wei (or smallest token unit)
  - token: the token as symbol or address
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the transactionHash. use `zksync_tx_info` to check the progress.

#### withdraw(ethAddress:amount:token:account:)

withdraws the amount to the given `ethAddress` for the given token.

``` swift
public func withdraw(ethAddress: String, amount: UInt256, token: String, account: String? = nil) -> Future<String>
```

**Example**

``` swift
Zksync(in3).withdraw(ethAddress: 9.814684447173249e+47, amount: 100, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0x58ba1537596739d990a33e4fba3a6fb4e0d612c5de30843a2c415dd1e5edcef1"
     }
}
 
```

**Parameters**

  - ethAddress: the receipient of the tokens in L1
  - amount: the value to transfer in wei (or smallest token unit)
  - token: the token as symbol or address
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the transactionHash. use `zksync_tx_info` to check the progress.

#### emergencyWithdraw(token:)

withdraws all tokens for the specified token as a onchain-transaction. This is useful in case the zksync-server is offline or tries to be malicious.

``` swift
public func emergencyWithdraw(token: String) -> Future<ZksyncTransactionReceipt>
```

**Example**

``` swift
Zksync(in3).emergencyWithdraw(token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          blockHash: "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304"
//          blockNumber: "0x8c1e39"
//          contractAddress: null
//          cumulativeGasUsed: "0x2466d"
//          gasUsed: "0x2466d"
//          logs:
//            - address: "0x85ec283a3ed4b66df4da23656d4bf8a507383bca"
//              blockHash: "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304"
//              blockNumber: "0x8c1e39"
//              data: 0x00000000000...
//              logIndex: "0x0"
//              removed: false
//              topics:
//                - "0x9123e6a7c5d144bd06140643c88de8e01adcbb24350190c02218a4435c7041f8"
//                - "0xa2f7689fc12ea917d9029117d32b9fdef2a53462c853462ca86b71b97dd84af6"
//                - "0x55a6ef49ec5dcf6cd006d21f151f390692eedd839c813a150000000000000000"
//              transactionHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
//              transactionIndex: "0x0"
//              transactionLogIndex: "0x0"
//              type: mined
//          logsBloom: 0x00000000000000000000200000...
//          root: null
//          status: "0x1"
//          transactionHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
//          transactionIndex: "0x0"
     }
}
 
```

**Parameters**

  - token: the token as symbol or address

**Returns**

the transactionReceipt

#### aggregatePubkey(pubkeys:)

calculate the public key based on multiple public keys signing together using schnorr musig signatures.

``` swift
public func aggregatePubkey(pubkeys: String) throws -> String
```

**Example**

``` swift
let result = try Zksync(in3).aggregatePubkey(pubkeys: "0x0f61bfe164cc43b5a112bfbfb0583004e79dbfafc97a7daad14c5d511fea8e2435065ddd04329ec94be682bf004b03a5a4eeca9bf50a8b8b6023942adc0b3409")
// result = "0x9ce5b6f8db3fbbe66a3bdbd3b4731f19ec27f80ee03ead3c0708798dd949882b"
```

**Parameters**

  - pubkeys: concatinated packed publickeys of the signers. the length of the bytes must be `num_keys * 32`

**Returns**

the compact public Key
## Structs
### ABI

a function, event or a

``` swift
public struct ABI: Codable
```



`Codable`



#### hash

``` swift
var hash: String?
```

#### anonymous

``` swift
var anonymous: Bool?
```

#### constant

``` swift
var constant: Bool?
```

#### payable

``` swift
var payable: Bool?
```

#### stateMutability

``` swift
var stateMutability: String?
```

#### components

``` swift
var components: [ABIField]?
```

#### inputs

``` swift
var inputs: [ABIField]?
```

#### outputs

``` swift
var outputs: [ABIField]?
```

#### name

``` swift
var name: String?
```

#### type

``` swift
var type: String
```

#### internalType

``` swift
var internalType: String?
```

#### signature

``` swift
var signature: String
```

#### inputSignature

``` swift
var inputSignature: String
```
### ABIField

configure the Bitcoin verification

``` swift
public struct ABIField: Codable
```



`Codable`



#### internalType

``` swift
var internalType: String?
```

#### components

``` swift
var components: [ABIField]?
```

#### indexed

``` swift
var indexed: Bool?
```

#### name

``` swift
var name: String
```

#### type

``` swift
var type: String
```

#### signature

``` swift
var signature: String
```
### AccountEcrecover

the extracted public key and address

``` swift
public struct AccountEcrecover
```



#### init(publicKey:address:)

initialize the AccountEcrecover

``` swift
public init(publicKey: String, address: String)
```

**Parameters**

  - publicKey: the public Key of the signer (64 bytes)
  - address: the address



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
### AccountSignData

the signature

``` swift
public struct AccountSignData
```



#### init(message:messageHash:signature:r:s:v:)

initialize the AccountSignData

``` swift
public init(message: String, messageHash: String, signature: String, r: String, s: String, v: String)
```

**Parameters**

  - message: original message used
  - messageHash: the hash the signature is based on
  - signature: the signature (65 bytes)
  - r: the x-value of the EC-Point
  - s: the y-value of the EC-Point
  - v: the recovery value (0|1) + 27



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
### AccountTransaction

the tx-object, which is the same as specified in [eth\_sendTransaction](https:​//eth.wiki/json-rpc/API#eth_sendTransaction).

``` swift
public struct AccountTransaction
```



#### init(to:from:value:gas:gasPrice:nonce:data:)

initialize the AccountTransaction

``` swift
public init(to: String? = nil, from: String? = nil, value: UInt256? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil, nonce: UInt64? = nil, data: String? = nil)
```

**Parameters**

  - to: receipient of the transaction.
  - from: sender of the address (if not sepcified, the first signer will be the sender)
  - value: value in wei to send
  - gas: the gas to be send along
  - gasPrice: the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`
  - nonce: the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`
  - data: the data-section of the transaction



#### to

receipient of the transaction.

``` swift
var to: String?
```

#### from

sender of the address (if not sepcified, the first signer will be the sender)

``` swift
var from: String?
```

#### value

value in wei to send

``` swift
var value: UInt256?
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
### BtcProofTarget

A path of daps from the `verified_dap` to the `target_dap` which fulfils the conditions of `max_diff`, `max_dap` and `limit`. Each dap of the path is a `dap`-object with corresponding proof data.

``` swift
public struct BtcProofTarget
```



#### init(dap:block:final:cbtx:cbtxMerkleProof:)

initialize the BtcProofTarget

``` swift
public init(dap: UInt64, block: String, final: String, cbtx: String, cbtxMerkleProof: String)
```

**Parameters**

  - dap: the difficulty adjustement period
  - block: the first blockheader
  - final: the finality header
  - cbtx: the coinbase transaction as hex
  - cbtxMerkleProof: the coinbasetx merkle proof



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



#### init(asm:hex:reqSigs:type:addresses:)

initialize the BtcScriptPubKey

``` swift
public init(asm: String, hex: String, reqSigs: Int, type: String, addresses: [String])
```

**Parameters**

  - asm: asm
  - hex: hex representation of the script
  - reqSigs: the required signatures
  - type: The type, eg 'pubkeyhash'
  - addresses: Array of address(each representing a bitcoin adress)



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
var reqSigs: Int
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



#### init(asm:hex:)

initialize the BtcScriptSig

``` swift
public init(asm: String, hex: String)
```

**Parameters**

  - asm: the asm-codes
  - hex: hex representation



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



#### init(txid:vout:scriptSig:sequence:txinwitness:)

initialize the BtcVin

``` swift
public init(txid: String, vout: UInt64, scriptSig: BtcScriptSig, sequence: UInt64, txinwitness: [String])
```

**Parameters**

  - txid: the transaction id
  - vout: the index of the transaction out to be used
  - scriptSig: the script
  - sequence: The script sequence number
  - txinwitness: hex-encoded witness data (if any)



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



#### init(value:n:scriptPubKey:)

initialize the BtcVout

``` swift
public init(value: Double, n: Int, scriptPubKey: BtcScriptPubKey)
```

**Parameters**

  - value: The Value in BTC
  - n: the index
  - scriptPubKey: the script pubkey



#### value

The Value in BTC

``` swift
var value: Double
```

#### n

the index

``` swift
var n: Int
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



#### init(hash:confirmations:height:version:versionHex:merkleroot:time:mediantime:nonce:bits:difficulty:chainwork:nTx:tx:previousblockhash:nextblockhash:)

initialize the Btcblock

``` swift
public init(hash: String, confirmations: Int, height: UInt256, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: UInt256, chainwork: String, nTx: Int, tx: [String], previousblockhash: String, nextblockhash: String)
```

**Parameters**

  - hash: the block hash (same as provided)
  - confirmations: The number of confirmations, or -1 if the block is not on the main chain
  - height: The block height or index
  - version: The block version
  - versionHex: The block version formatted in hexadecimal
  - merkleroot: The merkle root ( 32 bytes )
  - time: The block time in seconds since epoch (Jan 1 1970 GMT)
  - mediantime: The median block time in seconds since epoch (Jan 1 1970 GMT)
  - nonce: The nonce
  - bits: The bits ( 4 bytes as hex) representing the target
  - difficulty: The difficulty
  - chainwork: Expected number of hashes required to produce the current chain (in hex)
  - nTx: The number of transactions in the block.
  - tx: the array of transactions either as ids (verbose=1) or full transaction (verbose=2)
  - previousblockhash: The hash of the previous block
  - nextblockhash: The hash of the next block



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
var height: UInt256
```

#### version

The block version

``` swift
var version: Int
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
var difficulty: UInt256
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
var nTx: Int
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



#### init(hash:confirmations:height:version:versionHex:merkleroot:time:mediantime:nonce:bits:difficulty:chainwork:nTx:tx:previousblockhash:nextblockhash:)

initialize the BtcblockWithTx

``` swift
public init(hash: String, confirmations: Int, height: UInt64, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: UInt256, chainwork: String, nTx: Int, tx: [Btctransaction], previousblockhash: String, nextblockhash: String)
```

**Parameters**

  - hash: the block hash (same as provided)
  - confirmations: The number of confirmations, or -1 if the block is not on the main chain
  - height: The block height or index
  - version: The block version
  - versionHex: The block version formatted in hexadecimal
  - merkleroot: The merkle root ( 32 bytes )
  - time: The block time in seconds since epoch (Jan 1 1970 GMT)
  - mediantime: The median block time in seconds since epoch (Jan 1 1970 GMT)
  - nonce: The nonce
  - bits: The bits ( 4 bytes as hex) representing the target
  - difficulty: The difficulty
  - chainwork: Expected number of hashes required to produce the current chain (in hex)
  - nTx: The number of transactions in the block.
  - tx: the array of transactions either as ids (verbose=1) or full transaction (verbose=2)
  - previousblockhash: The hash of the previous block
  - nextblockhash: The hash of the next block



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
var version: Int
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
var difficulty: UInt256
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
var nTx: Int
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



#### init(hash:confirmations:height:version:versionHex:merkleroot:time:mediantime:nonce:bits:difficulty:chainwork:nTx:previousblockhash:nextblockhash:)

initialize the Btcblockheader

``` swift
public init(hash: String, confirmations: Int, height: UInt64, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: UInt256, chainwork: String, nTx: Int, previousblockhash: String, nextblockhash: String)
```

**Parameters**

  - hash: the block hash (same as provided)
  - confirmations: The number of confirmations, or -1 if the block is not on the main chain
  - height: The block height or index
  - version: The block version
  - versionHex: The block version formatted in hexadecimal
  - merkleroot: The merkle root ( 32 bytes )
  - time: The block time in seconds since epoch (Jan 1 1970 GMT)
  - mediantime: The median block time in seconds since epoch (Jan 1 1970 GMT)
  - nonce: The nonce
  - bits: The bits ( 4 bytes as hex) representing the target
  - difficulty: The difficulty
  - chainwork: Expected number of hashes required to produce the current chain (in hex)
  - nTx: The number of transactions in the block.
  - previousblockhash: The hash of the previous block
  - nextblockhash: The hash of the next block



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
var version: Int
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
var difficulty: UInt256
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
var nTx: Int
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



#### init(txid:in_active_chain:hex:hash:size:vsize:weight:version:locktime:vin:vout:blockhash:confirmations:blocktime:time:)

initialize the Btctransaction

``` swift
public init(txid: String, in_active_chain: Bool, hex: String, hash: String, size: UInt64, vsize: UInt64, weight: UInt64, version: Int, locktime: UInt64, vin: [BtcVin], vout: [BtcVout], blockhash: String, confirmations: Int, blocktime: UInt64, time: UInt64)
```

  - Parameter in\_active\_chain : Whether specified block is in the active chain or not (only present with explicit "blockhash" argument)

**Parameters**

  - txid: txid
  - hex: The serialized, hex-encoded data for `txid`
  - hash: The transaction hash (differs from txid for witness transactions)
  - size: The serialized transaction size
  - vsize: The virtual transaction size (differs from size for witness transactions)
  - weight: The transaction's weight (between `vsize`\*4-3 and `vsize`\*4)
  - version: The version
  - locktime: The lock time
  - vin: array of json objects of incoming txs to be used
  - vout: array of json objects describing the tx outputs
  - blockhash: the block hash
  - confirmations: The confirmations
  - blocktime: The block time in seconds since epoch (Jan 1 1970 GMT)
  - time: Same as "blocktime"



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
var version: Int
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



#### init(transactions:number:hash:parentHash:nonce:sha3Uncles:logsBloom:transactionsRoot:stateRoot:receiptsRoot:miner:difficulty:totalDifficulty:extraData:size:gasLimit:gasUsed:timestamp:uncles:)

initialize the EthBlockdata

``` swift
public init(transactions: [EthTransactiondata], number: UInt64, hash: String, parentHash: String, nonce: UInt256, sha3Uncles: String, logsBloom: String, transactionsRoot: String, stateRoot: String, receiptsRoot: String, miner: String, difficulty: UInt256, totalDifficulty: UInt256, extraData: String, size: UInt64, gasLimit: UInt64, gasUsed: UInt64, timestamp: UInt64, uncles: [String])
```

**Parameters**

  - transactions: Array of transaction objects
  - number: the block number. `null` when its pending block.
  - hash: hash of the block. `null` when its pending block.
  - parentHash: hash of the parent block.
  - nonce: hash of the generated proof-of-work. `null` when its pending block.
  - sha3Uncles: SHA3 of the uncles Merkle root in the block.
  - logsBloom: the bloom filter for the logs of the block. `null` when its pending block.
  - transactionsRoot: the root of the transaction trie of the block.
  - stateRoot: the root of the final state trie of the block.
  - receiptsRoot: the root of the receipts trie of the block.
  - miner: the address of the beneficiary to whom the mining rewards were given.
  - difficulty: integer of the difficulty for this block.
  - totalDifficulty: integer of the total difficulty of the chain until this block.
  - extraData: the "extra data" field of this block.
  - size: integer the size of this block in bytes.
  - gasLimit: the maximum gas allowed in this block.
  - gasUsed: the total used gas by all transactions in this block.
  - timestamp: the unix timestamp for when the block was collated.
  - uncles: Array of uncle hashes.



#### transactions

Array of transaction objects

``` swift
var transactions: [EthTransactiondata]
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
var nonce: UInt256
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
var difficulty: UInt256
```

#### totalDifficulty

integer of the total difficulty of the chain until this block.

``` swift
var totalDifficulty: UInt256
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

#### uncles

Array of uncle hashes.

``` swift
var uncles: [String]
```
### EthBlockdataWithTxHashes

the blockdata, or in case the block with that number does not exist, `null` will be returned.

``` swift
public struct EthBlockdataWithTxHashes
```



#### init(transactions:number:hash:parentHash:nonce:sha3Uncles:logsBloom:transactionsRoot:stateRoot:receiptsRoot:miner:difficulty:totalDifficulty:extraData:size:gasLimit:gasUsed:timestamp:uncles:)

initialize the EthBlockdataWithTxHashes

``` swift
public init(transactions: [String], number: UInt64, hash: String, parentHash: String, nonce: UInt256, sha3Uncles: String, logsBloom: String, transactionsRoot: String, stateRoot: String, receiptsRoot: String, miner: String, difficulty: UInt256, totalDifficulty: UInt256, extraData: String, size: UInt64, gasLimit: UInt64, gasUsed: UInt64, timestamp: UInt64, uncles: [String])
```

**Parameters**

  - transactions: Array of transaction hashes
  - number: the block number. `null` when its pending block.
  - hash: hash of the block. `null` when its pending block.
  - parentHash: hash of the parent block.
  - nonce: hash of the generated proof-of-work. `null` when its pending block.
  - sha3Uncles: SHA3 of the uncles Merkle root in the block.
  - logsBloom: the bloom filter for the logs of the block. `null` when its pending block.
  - transactionsRoot: the root of the transaction trie of the block.
  - stateRoot: the root of the final state trie of the block.
  - receiptsRoot: the root of the receipts trie of the block.
  - miner: the address of the beneficiary to whom the mining rewards were given.
  - difficulty: integer of the difficulty for this block.
  - totalDifficulty: integer of the total difficulty of the chain until this block.
  - extraData: the "extra data" field of this block.
  - size: integer the size of this block in bytes.
  - gasLimit: the maximum gas allowed in this block.
  - gasUsed: the total used gas by all transactions in this block.
  - timestamp: the unix timestamp for when the block was collated.
  - uncles: Array of uncle hashes.



#### transactions

Array of transaction hashes

``` swift
var transactions: [String]
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
var nonce: UInt256
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
var difficulty: UInt256
```

#### totalDifficulty

integer of the total difficulty of the chain until this block.

``` swift
var totalDifficulty: UInt256
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

#### uncles

Array of uncle hashes.

``` swift
var uncles: [String]
```
### EthEvent

``` swift
public struct EthEvent
```



#### log

``` swift
var log: Ethlog
```

#### event

``` swift
var event: String
```

#### values

``` swift
var values: [String:AnyObject]
```
### EthFilter

The filter criteria for the events.

``` swift
public struct EthFilter
```



#### init(fromBlock:toBlock:address:topics:blockhash:)

initialize the EthFilter

``` swift
public init(fromBlock: UInt64? = nil, toBlock: UInt64? = nil, address: String? = nil, topics: [String?]? = nil, blockhash: String? = nil)
```

**Parameters**

  - fromBlock: Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.
  - toBlock: Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.
  - address: Contract address or a list of addresses from which logs should originate.
  - topics: Array of 32 Bytes DATA topics. Topics are order-dependent. Each topic can also be an array of DATA with “or” options.
  - blockhash: With the addition of EIP-234, blockHash will be a new filter option which restricts the logs returned to the single block with the 32-byte hash blockHash. Using blockHash is equivalent to fromBlock = toBlock = the block number with hash blockHash. If blockHash is present in in the filter criteria, then neither fromBlock nor toBlock are allowed.



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
var topics: [String?]?
```

#### blockhash

With the addition of EIP-234, blockHash will be a new filter option which restricts the logs returned to the single block with the 32-byte hash blockHash. Using blockHash is equivalent to fromBlock = toBlock = the block number with hash blockHash. If blockHash is present in in the filter criteria, then neither fromBlock nor toBlock are allowed.

``` swift
var blockhash: String?
```
### EthTransaction

the transactiondata to send

``` swift
public struct EthTransaction
```



#### init(to:from:value:gas:gasPrice:nonce:data:)

initialize the EthTransaction

``` swift
public init(to: String? = nil, from: String? = nil, value: UInt256? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil, nonce: UInt64? = nil, data: String? = nil)
```

**Parameters**

  - to: receipient of the transaction.
  - from: sender of the address (if not sepcified, the first signer will be the sender)
  - value: value in wei to send
  - gas: the gas to be send along
  - gasPrice: the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`
  - nonce: the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`
  - data: the data-section of the transaction



#### to

receipient of the transaction.

``` swift
var to: String?
```

#### from

sender of the address (if not sepcified, the first signer will be the sender)

``` swift
var from: String?
```

#### value

value in wei to send

``` swift
var value: UInt256?
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
### EthTransactionReceipt

the transactionReceipt

``` swift
public struct EthTransactionReceipt
```



#### init(blockNumber:blockHash:contractAddress:cumulativeGasUsed:gasUsed:logs:logsBloom:status:transactionHash:transactionIndex:)

initialize the EthTransactionReceipt

``` swift
public init(blockNumber: UInt64, blockHash: String, contractAddress: String? = nil, cumulativeGasUsed: UInt64, gasUsed: UInt64, logs: [Ethlog], logsBloom: String, status: Int, transactionHash: String, transactionIndex: Int)
```

**Parameters**

  - blockNumber: the blockNumber
  - blockHash: blockhash if ther containing block
  - contractAddress: the deployed contract in case the tx did deploy a new contract
  - cumulativeGasUsed: gas used for all transaction up to this one in the block
  - gasUsed: gas used by this transaction.
  - logs: array of events created during execution of the tx
  - logsBloom: bloomfilter used to detect events for `eth_getLogs`
  - status: error-status of the tx.  0x1 = success 0x0 = failure
  - transactionHash: requested transactionHash
  - transactionIndex: transactionIndex within the containing block.



#### blockNumber

the blockNumber

``` swift
var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
var blockHash: String
```

#### contractAddress

the deployed contract in case the tx did deploy a new contract

``` swift
var contractAddress: String?
```

#### cumulativeGasUsed

gas used for all transaction up to this one in the block

``` swift
var cumulativeGasUsed: UInt64
```

#### gasUsed

gas used by this transaction.

``` swift
var gasUsed: UInt64
```

#### logs

array of events created during execution of the tx

``` swift
var logs: [Ethlog]
```

#### logsBloom

bloomfilter used to detect events for `eth_getLogs`

``` swift
var logsBloom: String
```

#### status

error-status of the tx.  0x1 = success 0x0 = failure

``` swift
var status: Int
```

#### transactionHash

requested transactionHash

``` swift
var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
var transactionIndex: Int
```
### EthTransactiondata

Array of transaction objects

``` swift
public struct EthTransactiondata
```



#### init(to:from:value:gas:gasPrice:nonce:blockHash:blockNumber:hash:input:transactionIndex:v:r:s:)

initialize the EthTransactiondata

``` swift
public init(to: String, from: String, value: UInt256, gas: UInt64, gasPrice: UInt64, nonce: UInt64, blockHash: String, blockNumber: UInt64, hash: String, input: String, transactionIndex: UInt64, v: String, r: String, s: String)
```

**Parameters**

  - to: receipient of the transaction.
  - from: sender or signer of the transaction
  - value: value in wei to send
  - gas: the gas to be send along
  - gasPrice: the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`
  - nonce: the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`
  - blockHash: blockHash of the block holding this transaction or `null` if still pending.
  - blockNumber: blockNumber of the block holding this transaction or `null` if still pending.
  - hash: transactionHash
  - input: data of the transaaction
  - transactionIndex: index of the transaaction in the block
  - v: recovery-byte of the signature
  - r: x-value of the EC-Point of the signature
  - s: y-value of the EC-Point of the signature



#### to

receipient of the transaction.

``` swift
var to: String
```

#### from

sender or signer of the transaction

``` swift
var from: String
```

#### value

value in wei to send

``` swift
var value: UInt256
```

#### gas

the gas to be send along

``` swift
var gas: UInt64
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
var gasPrice: UInt64
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
var nonce: UInt64
```

#### blockHash

blockHash of the block holding this transaction or `null` if still pending.

``` swift
var blockHash: String
```

#### blockNumber

blockNumber of the block holding this transaction or `null` if still pending.

``` swift
var blockNumber: UInt64
```

#### hash

transactionHash

``` swift
var hash: String
```

#### input

data of the transaaction

``` swift
var input: String
```

#### transactionIndex

index of the transaaction in the block

``` swift
var transactionIndex: UInt64
```

#### v

recovery-byte of the signature

``` swift
var v: String
```

#### r

x-value of the EC-Point of the signature

``` swift
var r: String
```

#### s

y-value of the EC-Point of the signature

``` swift
var s: String
```
### Ethlog

array with all found event matching the specified filter

``` swift
public struct Ethlog
```



#### init(address:blockNumber:blockHash:data:logIndex:removed:topics:transactionHash:transactionIndex:transactionLogIndex:type:)

initialize the Ethlog

``` swift
public init(address: String, blockNumber: UInt64, blockHash: String, data: String, logIndex: Int, removed: Bool, topics: [String], transactionHash: String, transactionIndex: Int, transactionLogIndex: Int? = nil, type: String? = nil)
```

**Parameters**

  - address: the address triggering the event.
  - blockNumber: the blockNumber
  - blockHash: blockhash if ther containing block
  - data: abi-encoded data of the event (all non indexed fields)
  - logIndex: the index of the even within the block.
  - removed: the reorg-status of the event.
  - topics: array of 32byte-topics of the indexed fields.
  - transactionHash: requested transactionHash
  - transactionIndex: transactionIndex within the containing block.
  - transactionLogIndex: index of the event within the transaction.
  - type: mining-status



#### address

the address triggering the event.

``` swift
var address: String
```

#### blockNumber

the blockNumber

``` swift
var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
var blockHash: String
```

#### data

abi-encoded data of the event (all non indexed fields)

``` swift
var data: String
```

#### logIndex

the index of the even within the block.

``` swift
var logIndex: Int
```

#### removed

the reorg-status of the event.

``` swift
var removed: Bool
```

#### topics

array of 32byte-topics of the indexed fields.

``` swift
var topics: [String]
```

#### transactionHash

requested transactionHash

``` swift
var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
var transactionIndex: Int
```

#### transactionLogIndex

index of the event within the transaction.

``` swift
var transactionLogIndex: Int?
```

#### type

mining-status

``` swift
var type: String?
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
public init(chainId: String? = nil, finality: Int? = nil, includeCode: Bool? = nil, maxAttempts: Int? = nil, keepIn3: Bool? = nil, stats: Bool? = nil, useBinary: Bool? = nil, experimental: Bool? = nil, timeout: UInt64? = nil, proof: String? = nil, replaceLatestBlock: Int? = nil, autoUpdateList: Bool? = nil, signatureCount: Int? = nil, bootWeights: Bool? = nil, useHttp: Bool? = nil, minDeposit: UInt256? = nil, nodeProps: String? = nil, requestCount: Int? = nil, rpc: String? = nil, nodes: Nodes? = nil, zksync: Zksync? = nil, key: String? = nil, pk: String? = nil, btc: Btc? = nil)
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
var finality: Int?
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
var maxAttempts: Int?
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
var replaceLatestBlock: Int?
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
var signatureCount: Int?
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
var minDeposit: UInt256?
```

Example: `10000000`

#### nodeProps

used to identify the capabilities of the node.

``` swift
var nodeProps: String?
```

Example: `"0xffff"`

#### requestCount

the number of request send in parallel when getting an answer. More request will make it more expensive, but increase the chances to get a faster answer, since the client will continue once the first verifiable response was received.
(default:​ `2`)

``` swift
var requestCount: Int?
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
public init(maxDAP: Int? = nil, maxDiff: Int? = nil)
```

**Parameters**

  - maxDAP: configure the Bitcoin verification
  - maxDiff: max increase (in percent) of the difference between targets when accepting new targets.



#### maxDAP

max number of DAPs (Difficulty Adjustment Periods) allowed when accepting new targets.
(default:​ `20`)

``` swift
var maxDAP: Int?
```

Example: `10`

#### maxDiff

max increase (in percent) of the difference between targets when accepting new targets.
(default:​ `10`)

``` swift
var maxDiff: Int?
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
public init(url: String, address: String, props: String)
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
var props: String
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
public init(contract: String, whiteListContract: String? = nil, whiteList: [String]? = nil, registryId: String, needsUpdate: Bool? = nil, avgBlockTime: Int? = nil, verifiedHashes: [VerifiedHashes]? = nil, nodeList: [NodeList]? = nil)
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
var whiteList: [String]?
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
var avgBlockTime: Int?
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
### Node

a array of node definitions.

``` swift
public struct Node
```



#### init(url:address:index:deposit:props:timeout:registerTime:weight:proofHash:)

initialize the Node

``` swift
public init(url: String, address: String, index: UInt64, deposit: UInt256, props: String, timeout: UInt64, registerTime: UInt64, weight: UInt64, proofHash: String)
```

**Parameters**

  - url: the url of the node. Currently only http/https is supported, but in the future this may even support onion-routing or any other protocols.
  - address: the address of the signer
  - index: the index within the nodeList of the contract
  - deposit: the stored deposit
  - props: the bitset of capabilities as described in the [Node Structure](spec.html#node-structure)
  - timeout: the time in seconds describing how long the deposit would be locked when trying to unregister a node.
  - registerTime: unix timestamp in seconds when the node has registered.
  - weight: the weight of a node ( not used yet ) describing the amount of request-points it can handle per second.
  - proofHash: a hash value containing the above values. This hash is explicitly stored in the contract, which enables the client to have only one merkle proof per node instead of verifying each property as its own storage value. The proof hash is build `keccak256( abi.encodePacked( deposit, timeout, registerTime, props, signer, url ))`



#### url

the url of the node. Currently only http/https is supported, but in the future this may even support onion-routing or any other protocols.

``` swift
var url: String
```

#### address

the address of the signer

``` swift
var address: String
```

#### index

the index within the nodeList of the contract

``` swift
var index: UInt64
```

#### deposit

the stored deposit

``` swift
var deposit: UInt256
```

#### props

the bitset of capabilities as described in the [Node Structure](spec.html#node-structure)

``` swift
var props: String
```

#### timeout

the time in seconds describing how long the deposit would be locked when trying to unregister a node.

``` swift
var timeout: UInt64
```

#### registerTime

unix timestamp in seconds when the node has registered.

``` swift
var registerTime: UInt64
```

#### weight

the weight of a node ( not used yet ) describing the amount of request-points it can handle per second.

``` swift
var weight: UInt64
```

#### proofHash

a hash value containing the above values.
This hash is explicitly stored in the contract, which enables the client to have only one merkle proof
per node instead of verifying each property as its own storage value.
The proof hash is build `keccak256( abi.encodePacked( deposit, timeout, registerTime, props, signer, url ))`

``` swift
var proofHash: String
```
### NodeListDefinition

the current nodelist

``` swift
public struct NodeListDefinition
```



#### init(nodes:contract:registryId:lastBlockNumber:totalServer:)

initialize the NodeListDefinition

``` swift
public init(nodes: [Node], contract: String, registryId: String, lastBlockNumber: UInt64, totalServer: UInt64)
```

**Parameters**

  - nodes: a array of node definitions.
  - contract: the address of the Incubed-storage-contract. The client may use this information to verify that we are talking about the same contract or throw an exception otherwise.
  - registryId: the registryId (32 bytes)  of the contract, which is there to verify the correct contract.
  - lastBlockNumber: the blockNumber of the last change of the list (usually the last event).
  - totalServer: the total numbers of nodes.



#### nodes

a array of node definitions.

``` swift
var nodes: [Node]
```

#### contract

the address of the Incubed-storage-contract. The client may use this information to verify that we are talking about the same contract or throw an exception otherwise.

``` swift
var contract: String
```

#### registryId

the registryId (32 bytes)  of the contract, which is there to verify the correct contract.

``` swift
var registryId: String
```

#### lastBlockNumber

the blockNumber of the last change of the list (usually the last event).

``` swift
var lastBlockNumber: UInt64
```

#### totalServer

the total numbers of nodes.

``` swift
var totalServer: UInt64
```
### NodelistBlocks

array of requested blocks.

``` swift
public struct NodelistBlocks
```



#### init(blockNumber:hash:)

initialize the NodelistBlocks

``` swift
public init(blockNumber: UInt64, hash: String? = nil)
```

**Parameters**

  - blockNumber: the blockNumber to sign
  - hash: the expected hash. This is optional and can be used to check if the expected hash is correct, but as a client you should not rely on it, but only on the hash in the signature.



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
### NodelistSignBlockHash

the Array with signatures of all the requires blocks.

``` swift
public struct NodelistSignBlockHash
```



#### init(blockHash:block:r:s:v:msgHash:)

initialize the NodelistSignBlockHash

``` swift
public init(blockHash: String, block: UInt64, r: String, s: String, v: String, msgHash: String)
```

**Parameters**

  - blockHash: the blockhash which was signed.
  - block: the blocknumber
  - r: r-value of the signature
  - s: s-value of the signature
  - v: v-value of the signature
  - msgHash: the msgHash signed. This Hash is created with `keccak256( abi.encodePacked( _blockhash,  _blockNumber, registryId ))`



#### blockHash

the blockhash which was signed.

``` swift
var blockHash: String
```

#### block

the blocknumber

``` swift
var block: UInt64
```

#### r

r-value of the signature

``` swift
var r: String
```

#### s

s-value of the signature

``` swift
var s: String
```

#### v

v-value of the signature

``` swift
var v: String
```

#### msgHash

the msgHash signed. This Hash is created with `keccak256( abi.encodePacked( _blockhash,  _blockNumber, registryId ))`

``` swift
var msgHash: String
```
### NodelistWhitelist

the whitelisted addresses

``` swift
public struct NodelistWhitelist
```



#### init(nodes:lastWhiteList:contract:lastBlockNumber:totalServer:)

initialize the NodelistWhitelist

``` swift
public init(nodes: String, lastWhiteList: UInt64, contract: String, lastBlockNumber: UInt64, totalServer: UInt64)
```

**Parameters**

  - nodes: array of whitelisted nodes addresses.
  - lastWhiteList: the blockNumber of the last change of the in3 white list event.
  - contract: whitelist contract address.
  - lastBlockNumber: the blockNumber of the last change of the list (usually the last event).
  - totalServer: the total numbers of whitelist nodes.



#### nodes

array of whitelisted nodes addresses.

``` swift
var nodes: String
```

#### lastWhiteList

the blockNumber of the last change of the in3 white list event.

``` swift
var lastWhiteList: UInt64
```

#### contract

whitelist contract address.

``` swift
var contract: String
```

#### lastBlockNumber

the blockNumber of the last change of the list (usually the last event).

``` swift
var lastBlockNumber: UInt64
```

#### totalServer

the total numbers of whitelist nodes.

``` swift
var totalServer: UInt64
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
### ZksyncAccountInfo

the current state of the requested account.

``` swift
public struct ZksyncAccountInfo
```



#### init(address:commited:depositing:id:verified:)

initialize the ZksyncAccountInfo

``` swift
public init(address: String, commited: ZksyncCommited, depositing: ZksyncDepositing, id: UInt64, verified: ZksyncVerified)
```

**Parameters**

  - address: the address of the account
  - commited: the state of the zksync operator after executing transactions successfully, but not not verified on L1 yet.
  - depositing: the state of all depositing-tx.
  - id: the assigned id of the account, which will be used when encoding it into the rollup.
  - verified: the state after the rollup was verified in L1.



#### address

the address of the account

``` swift
var address: String
```

#### commited

the state of the zksync operator after executing transactions successfully, but not not verified on L1 yet.

``` swift
var commited: ZksyncCommited
```

#### depositing

the state of all depositing-tx.

``` swift
var depositing: ZksyncDepositing
```

#### id

the assigned id of the account, which will be used when encoding it into the rollup.

``` swift
var id: UInt64
```

#### verified

the state after the rollup was verified in L1.

``` swift
var verified: ZksyncVerified
```
### ZksyncCommited

the state of the zksync operator after executing transactions successfully, but not not verified on L1 yet.

``` swift
public struct ZksyncCommited
```



#### init(balances:nonce:pubKeyHash:)

initialize the ZksyncCommited

``` swift
public init(balances: [String:UInt256], nonce: UInt64, pubKeyHash: String)
```

**Parameters**

  - balances: the token-balance
  - nonce: the nonce or transaction count.
  - pubKeyHash: the pubKeyHash set for the requested account or `0x0000...` if not set yet.



#### balances

the token-balance

``` swift
var balances: [String:UInt256]
```

#### nonce

the nonce or transaction count.

``` swift
var nonce: UInt64
```

#### pubKeyHash

the pubKeyHash set for the requested account or `0x0000...` if not set yet.

``` swift
var pubKeyHash: String
```
### ZksyncContractAddress

fetches the contract addresses from the zksync server. This request also caches them and will return the results from cahe if available.

``` swift
public struct ZksyncContractAddress
```



#### init(govContract:mainContract:)

initialize the ZksyncContractAddress

``` swift
public init(govContract: String, mainContract: String)
```

**Parameters**

  - govContract: the address of the govement contract
  - mainContract: the address of the main contract



#### govContract

the address of the govement contract

``` swift
var govContract: String
```

#### mainContract

the address of the main contract

``` swift
var mainContract: String
```
### ZksyncDepositing

the state of all depositing-tx.

``` swift
public struct ZksyncDepositing
```



#### init(balances:)

initialize the ZksyncDepositing

``` swift
public init(balances: [String:UInt256])
```

**Parameters**

  - balances: the token-values.



#### balances

the token-values.

``` swift
var balances: [String:UInt256]
```
### ZksyncEthlog

array of events created during execution of the tx

``` swift
public struct ZksyncEthlog
```



#### init(address:blockNumber:blockHash:data:logIndex:removed:topics:transactionHash:transactionIndex:transactionLogIndex:type:)

initialize the ZksyncEthlog

``` swift
public init(address: String, blockNumber: UInt64, blockHash: String, data: String, logIndex: Int, removed: Bool, topics: [String], transactionHash: String, transactionIndex: Int, transactionLogIndex: Int? = nil, type: String? = nil)
```

**Parameters**

  - address: the address triggering the event.
  - blockNumber: the blockNumber
  - blockHash: blockhash if ther containing block
  - data: abi-encoded data of the event (all non indexed fields)
  - logIndex: the index of the even within the block.
  - removed: the reorg-status of the event.
  - topics: array of 32byte-topics of the indexed fields.
  - transactionHash: requested transactionHash
  - transactionIndex: transactionIndex within the containing block.
  - transactionLogIndex: index of the event within the transaction.
  - type: mining-status



#### address

the address triggering the event.

``` swift
var address: String
```

#### blockNumber

the blockNumber

``` swift
var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
var blockHash: String
```

#### data

abi-encoded data of the event (all non indexed fields)

``` swift
var data: String
```

#### logIndex

the index of the even within the block.

``` swift
var logIndex: Int
```

#### removed

the reorg-status of the event.

``` swift
var removed: Bool
```

#### topics

array of 32byte-topics of the indexed fields.

``` swift
var topics: [String]
```

#### transactionHash

requested transactionHash

``` swift
var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
var transactionIndex: Int
```

#### transactionLogIndex

index of the event within the transaction.

``` swift
var transactionLogIndex: Int?
```

#### type

mining-status

``` swift
var type: String?
```
### ZksyncTokens

a array of tokens-definitions. This request also caches them and will return the results from cahe if available.

``` swift
public struct ZksyncTokens
```



#### init(address:decimals:id:symbol:)

initialize the ZksyncTokens

``` swift
public init(address: String, decimals: Int, id: UInt64, symbol: String)
```

**Parameters**

  - address: the address of the ERC2-Contract or 0x00000..000 in case of the native token (eth)
  - decimals: decimals to be used when formating it for human readable representation.
  - id: id which will be used when encoding the token.
  - symbol: symbol for the token



#### address

the address of the ERC2-Contract or 0x00000..000 in case of the native token (eth)

``` swift
var address: String
```

#### decimals

decimals to be used when formating it for human readable representation.

``` swift
var decimals: Int
```

#### id

id which will be used when encoding the token.

``` swift
var id: UInt64
```

#### symbol

symbol for the token

``` swift
var symbol: String
```
### ZksyncTransactionReceipt

the transactionReceipt

``` swift
public struct ZksyncTransactionReceipt
```



#### init(blockNumber:blockHash:contractAddress:cumulativeGasUsed:gasUsed:logs:logsBloom:status:transactionHash:transactionIndex:)

initialize the ZksyncTransactionReceipt

``` swift
public init(blockNumber: UInt64, blockHash: String, contractAddress: String? = nil, cumulativeGasUsed: UInt64, gasUsed: UInt64, logs: [ZksyncEthlog], logsBloom: String, status: Int, transactionHash: String, transactionIndex: Int)
```

**Parameters**

  - blockNumber: the blockNumber
  - blockHash: blockhash if ther containing block
  - contractAddress: the deployed contract in case the tx did deploy a new contract
  - cumulativeGasUsed: gas used for all transaction up to this one in the block
  - gasUsed: gas used by this transaction.
  - logs: array of events created during execution of the tx
  - logsBloom: bloomfilter used to detect events for `eth_getLogs`
  - status: error-status of the tx.  0x1 = success 0x0 = failure
  - transactionHash: requested transactionHash
  - transactionIndex: transactionIndex within the containing block.



#### blockNumber

the blockNumber

``` swift
var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
var blockHash: String
```

#### contractAddress

the deployed contract in case the tx did deploy a new contract

``` swift
var contractAddress: String?
```

#### cumulativeGasUsed

gas used for all transaction up to this one in the block

``` swift
var cumulativeGasUsed: UInt64
```

#### gasUsed

gas used by this transaction.

``` swift
var gasUsed: UInt64
```

#### logs

array of events created during execution of the tx

``` swift
var logs: [ZksyncEthlog]
```

#### logsBloom

bloomfilter used to detect events for `eth_getLogs`

``` swift
var logsBloom: String
```

#### status

error-status of the tx.  0x1 = success 0x0 = failure

``` swift
var status: Int
```

#### transactionHash

requested transactionHash

``` swift
var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
var transactionIndex: Int
```
### ZksyncTxFee

the fees split up into single values

``` swift
public struct ZksyncTxFee
```



#### init(feeType:gasFee:gasPriceWei:gasTxAmount:totalFee:zkpFee:)

initialize the ZksyncTxFee

``` swift
public init(feeType: String, gasFee: UInt64, gasPriceWei: UInt64, gasTxAmount: UInt64, totalFee: UInt64, zkpFee: UInt64)
```

**Parameters**

  - feeType: Type of the transaaction
  - gasFee: the gas for the core-transaction
  - gasPriceWei: current gasPrice
  - gasTxAmount: gasTxAmount
  - totalFee: total of all fees needed to pay in order to execute the transaction
  - zkpFee: zkpFee



#### feeType

Type of the transaaction

``` swift
var feeType: String
```

#### gasFee

the gas for the core-transaction

``` swift
var gasFee: UInt64
```

#### gasPriceWei

current gasPrice

``` swift
var gasPriceWei: UInt64
```

#### gasTxAmount

gasTxAmount

``` swift
var gasTxAmount: UInt64
```

#### totalFee

total of all fees needed to pay in order to execute the transaction

``` swift
var totalFee: UInt64
```

#### zkpFee

zkpFee

``` swift
var zkpFee: UInt64
```
### ZksyncTxInfo

the current state of the requested tx.

``` swift
public struct ZksyncTxInfo
```



#### init(block:executed:success:failReason:)

initialize the ZksyncTxInfo

``` swift
public init(block: UInt64, executed: Bool, success: Bool, failReason: String)
```

**Parameters**

  - block: the blockNumber containing the tx or `null` if still pending
  - executed: true, if the tx has been executed by the operator. If false it is still in the txpool of the operator.
  - success: if executed, this property marks the success of the tx.
  - failReason: if executed and failed this will include an error message



#### block

the blockNumber containing the tx or `null` if still pending

``` swift
var block: UInt64
```

#### executed

true, if the tx has been executed by the operator. If false it is still in the txpool of the operator.

``` swift
var executed: Bool
```

#### success

if executed, this property marks the success of the tx.

``` swift
var success: Bool
```

#### failReason

if executed and failed this will include an error message

``` swift
var failReason: String
```
### ZksyncVerified

the state after the rollup was verified in L1.

``` swift
public struct ZksyncVerified
```



#### init(balances:nonce:pubKeyHash:)

initialize the ZksyncVerified

``` swift
public init(balances: [String:UInt256], nonce: UInt64, pubKeyHash: String)
```

**Parameters**

  - balances: the token-balances.
  - nonce: the nonce or transaction count.
  - pubKeyHash: the pubKeyHash set for the requested account or `0x0000...` if not set yet.



#### balances

the token-balances.

``` swift
var balances: [String:UInt256]
```

#### nonce

the nonce or transaction count.

``` swift
var nonce: UInt64
```

#### pubKeyHash

the pubKeyHash set for the requested account or `0x0000...` if not set yet.

``` swift
var pubKeyHash: String
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

Wrap a UInt256 as Value

``` swift
public init(_ value: UInt256)
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

Wrap a String -Array as Value

``` swift
public init(_ value: [String?])
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



#### asObject()

``` swift
public func asObject<T>() -> T
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
