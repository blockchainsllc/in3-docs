# API Reference Swift

## Classes
### Account

Account Handling includes handling signers and preparing and signing transacrtion and data.

``` swift
public class Account 
```

Signers are Plugins able to create signatures. Those functions will use the registered plugins.



#### createKey(seed:)

Generates 32 random bytes.
If /dev/urandom is available it will be used and should generate a secure random number.
If not the number should not be considered sceure or used in production.

``` swift
public func createKey(seed: String? = nil) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.createKey()
// result = "0x6c450e037e79b76f231a71a22ff40403f7d9b74b15e014e52fe1156d3666c3e6"
```

**Parameters**

  - seed: the seed. If given the result will be deterministic.

**Returns**

the 32byte random data

#### pk2address(pk:)

extracts the address from a private key.

``` swift
public func pk2address(pk: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.pk2address(pk: "0x0fd65f7da55d811634495754f27ab318a3309e8b4b8a978a50c20a661117435a")
// result = "0xdc5c4280d8a286f0f9c8f7f55a5a0c67125efcfd"
```

**Parameters**

  - pk: the 32 bytes private key as hex.

**Returns**

the address

#### pk2public(pk:)

extracts the public key from a private key.

``` swift
public func pk2public(pk: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.pk2public(pk: "0x0fd65f7da55d811634495754f27ab318a3309e8b4b8a978a50c20a661117435a")
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
public func ecrecover(msg: String, sig: String, sigtype: String? = "raw") throws ->  ECRecoverResult 
```

**Example**

``` swift
let result = try in3.account.ecrecover(msg: "0x487b2cbb7997e45b4e9771d14c336b47c87dc2424b11590e32b3a8b9ab327999", sig: "0x0f804ff891e97e8a1c35a2ebafc5e7f129a630a70787fb86ad5aec0758d98c7b454dee5564310d497ddfe814839c8babd3a727692be40330b5b41e7693a445b71c", sigtype: "hash")
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
public func prepareTx(tx: AccountEthTransaction) -> Future<String> 
```

**Example**

``` swift
in3.account.prepareTx(tx: AccountEthTransaction(to: "0x63f666a23cbd135a91187499b5cc51d589c302a0", value: "0x100000000", from: "0xc2b2f4ad0d234b8c135c39eea8409b448e5e496f")) .observe(using: {
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
in3.account.signTx(tx: "0xe980851a13b865b38252089463f666a23cbd135a91187499b5cc51d589c302a085010000000080018080", from: "0xc2b2f4ad0d234b8c135c39eea8409b448e5e496f") .observe(using: {
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
public func signData(msg: String, account: String, msgType: String? = "raw") -> Future<SignResult> 
```

**Example**

``` swift
in3.account.signData(msg: "0x0102030405060708090a0b0c0d0e0f", account: "0xa8b8759ec8b59d7c13ef3630e8530f47ddb47eba12f00f9024d3d48247b62852", msgType: "raw") .observe(using: {
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
public func decryptKey(key: AccountKeyparams, passphrase: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.decryptKey(key: AccountKeyparams(version: "3,", id: "f6b5c0b1-ba7a-4b67-9086-a01ea54ec638", address: "08aa30739030f362a8dd597fd3fcde283e36f4a1", crypto: {"ciphertext":"d5c5aafdee81d25bb5ac4048c8c6954dd50c595ee918f120f5a2066951ef992d","cipherparams":{"iv":"415440d2b1d6811d5c8a3f4c92c73f49"},"cipher":"aes-128-ctr","kdf":"pbkdf2","kdfparams":{"dklen":32,"salt":"691e9ad0da2b44404f65e0a60cf6aabe3e92d2c23b7410fd187eeeb2c1de4a0d","c":16384,"prf":"hmac-sha256"},"mac":"de651c04fc67fd552002b4235fa23ab2178d3a500caa7070b554168e73359610"}), passphrase: "test")
// result = "0x1ff25594a5e12c1e31ebd8112bdf107d217c1393da8dc7fc9d57696263457546"
```

**Parameters**

  - key: the keyparams
  - passphrase: the password to decrypt it.

**Returns**

a raw private key (32 bytes)

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
in3.account.sign(account: "0x9b2055d370f73ec7d8a03e965129118dc8f5bf83", message: "0xdeadbeaf") .observe(using: {
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
public func signTransaction(tx: AccountEthTransaction) -> Future<String> 
```

**Example**

``` swift
in3.account.signTransaction(tx: AccountEthTransaction(data: "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675", from: "0xb60e8dd61c5d32be8058bb8eb970870f07233155", gas: "0x76c0", gasPrice: "0x9184e72a000", to: "0xd46e8dd67c5d32be8058bb8eb970870f07244567", value: "0x9184e72a")) .observe(using: {
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
public func addRawKey(pk: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.addRawKey(pk: "0x1234567890123456789012345678901234567890123456789012345678901234")
// result = "0x2e988a386a799f506693793c6a5af6b54dfaabfb"
```

**Parameters**

  - pk: the 32byte long private key as hex string.

**Returns**

the address of given key.

#### accounts()

returns a array of account-addresss the incubed client is able to sign with.

``` swift
public func accounts() throws ->  [String] 
```

In order to add keys, you can use [in3\_addRawKey](#in3-addrawkey) or configure them in the config. The result also contains the addresses of any signer signer-supporting the `PLGN_ACT_SIGN_ACCOUNT` action.

**Example**

``` swift
let result = try in3.account.accounts()
// result = 
//          - "0x2e988a386a799f506693793c6a5af6b54dfaabfb"
//          - "0x93793c6a5af6b54dfaabfb2e988a386a799f5066"
```

**Returns**

the array of addresses of all registered signers.

#### createKey(seed:)

Generates 32 random bytes.
If /dev/urandom is available it will be used and should generate a secure random number.
If not the number should not be considered sceure or used in production.

``` swift
public func createKey(seed: String? = nil) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.createKey()
// result = "0x6c450e037e79b76f231a71a22ff40403f7d9b74b15e014e52fe1156d3666c3e6"
```

**Parameters**

  - seed: the seed. If given the result will be deterministic.

**Returns**

the 32byte random data

#### pk2address(pk:)

extracts the address from a private key.

``` swift
public func pk2address(pk: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.pk2address(pk: "0x0fd65f7da55d811634495754f27ab318a3309e8b4b8a978a50c20a661117435a")
// result = "0xdc5c4280d8a286f0f9c8f7f55a5a0c67125efcfd"
```

**Parameters**

  - pk: the 32 bytes private key as hex.

**Returns**

the address

#### pk2public(pk:)

extracts the public key from a private key.

``` swift
public func pk2public(pk: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.pk2public(pk: "0x0fd65f7da55d811634495754f27ab318a3309e8b4b8a978a50c20a661117435a")
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
public func ecrecover(msg: String, sig: String, sigtype: String? = "raw") throws ->  ECRecoverResult 
```

**Example**

``` swift
let result = try in3.account.ecrecover(msg: "0x487b2cbb7997e45b4e9771d14c336b47c87dc2424b11590e32b3a8b9ab327999", sig: "0x0f804ff891e97e8a1c35a2ebafc5e7f129a630a70787fb86ad5aec0758d98c7b454dee5564310d497ddfe814839c8babd3a727692be40330b5b41e7693a445b71c", sigtype: "hash")
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
public func prepareTx(tx: EthTransaction) -> Future<String> 
```

**Example**

``` swift
in3.account.prepareTx(tx: EthTransaction(to: "0x63f666a23cbd135a91187499b5cc51d589c302a0", value: "0x100000000", from: "0xc2b2f4ad0d234b8c135c39eea8409b448e5e496f")) .observe(using: {
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
in3.account.signTx(tx: "0xe980851a13b865b38252089463f666a23cbd135a91187499b5cc51d589c302a085010000000080018080", from: "0xc2b2f4ad0d234b8c135c39eea8409b448e5e496f") .observe(using: {
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
public func signData(msg: String, account: String, msgType: String? = "raw") -> Future<SignResult> 
```

**Example**

``` swift
in3.account.signData(msg: "0x0102030405060708090a0b0c0d0e0f", account: "0xa8b8759ec8b59d7c13ef3630e8530f47ddb47eba12f00f9024d3d48247b62852", msgType: "raw") .observe(using: {
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
public func decryptKey(key: Keyparams, passphrase: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.decryptKey(key: Keyparams(version: "3,", id: "f6b5c0b1-ba7a-4b67-9086-a01ea54ec638", address: "08aa30739030f362a8dd597fd3fcde283e36f4a1", crypto: {"ciphertext":"d5c5aafdee81d25bb5ac4048c8c6954dd50c595ee918f120f5a2066951ef992d","cipherparams":{"iv":"415440d2b1d6811d5c8a3f4c92c73f49"},"cipher":"aes-128-ctr","kdf":"pbkdf2","kdfparams":{"dklen":32,"salt":"691e9ad0da2b44404f65e0a60cf6aabe3e92d2c23b7410fd187eeeb2c1de4a0d","c":16384,"prf":"hmac-sha256"},"mac":"de651c04fc67fd552002b4235fa23ab2178d3a500caa7070b554168e73359610"}), passphrase: "test")
// result = "0x1ff25594a5e12c1e31ebd8112bdf107d217c1393da8dc7fc9d57696263457546"
```

**Parameters**

  - key: the keyparams
  - passphrase: the password to decrypt it.

**Returns**

a raw private key (32 bytes)

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
in3.account.sign(account: "0x9b2055d370f73ec7d8a03e965129118dc8f5bf83", message: "0xdeadbeaf") .observe(using: {
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
public func signTransaction(tx: EthTransaction) -> Future<String> 
```

**Example**

``` swift
in3.account.signTransaction(tx: EthTransaction(data: "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f072445675", from: "0xb60e8dd61c5d32be8058bb8eb970870f07233155", gas: "0x76c0", gasPrice: "0x9184e72a000", to: "0xd46e8dd67c5d32be8058bb8eb970870f07244567", value: "0x9184e72a")) .observe(using: {
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
public func addRawKey(pk: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.account.addRawKey(pk: "0x1234567890123456789012345678901234567890123456789012345678901234")
// result = "0x2e988a386a799f506693793c6a5af6b54dfaabfb"
```

**Parameters**

  - pk: the 32byte long private key as hex string.

**Returns**

the address of given key.

#### accounts()

returns a array of account-addresss the incubed client is able to sign with.

``` swift
public func accounts() throws ->  [String] 
```

In order to add keys, you can use [in3\_addRawKey](#in3-addrawkey) or configure them in the config. The result also contains the addresses of any signer signer-supporting the `PLGN_ACT_SIGN_ACCOUNT` action.

**Example**

``` swift
let result = try in3.account.accounts()
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
in3.btc.getblockheaderAsHex(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getblockheader(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getBlockAsHex(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getBlock(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getBlockWithTx(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getRawTransactionAsHex(txid: "f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf") .observe(using: {
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
in3.btc.getRawTransaction(txid: "f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf") .observe(using: {
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
in3.btc.getblockcount() .observe(using: {
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

#### getdifficulty()

Returns the proof-of-work difficulty as a multiple of the minimum difficulty.

``` swift
public func getdifficulty() -> Future<Double> 
```

  - `blocknumber` is `latest`, `earliest`, `pending` or empty: the difficulty of the latest block (`actual latest block` minus `in3.finality`)

**Example**

``` swift
in3.btc.getdifficulty() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 15138043247082.88
     }
}
 
```

**Returns**

  - `blocknumber` is a certain number:​ the difficulty of this block

#### proofTarget(target_dap:verified_dap:max_diff:max_dap:limit:)

Whenever the client is not able to trust the changes of the target (which is the case if a block can't be found in the verified target cache *and* the value of the target changed more than the client's limit `max_diff`) he will call this method. It will return additional proof data to verify the changes of the target on the side of the client. This is not a standard Bitcoin rpc-method like the other ones, but more like an internal method.

``` swift
public func proofTarget(target_dap: UInt64, verified_dap: UInt64, max_diff: Int? = 5, max_dap: Int? = 5, limit: Int? = 0) -> Future<[BtcProofTargetResult]> 
```

  - Parameter target\_dap : the number of the difficulty adjustment period (dap) we are looking for

  - Parameter verified\_dap : the number of the closest already verified dap

  - Parameter max\_diff : the maximum target difference between 2 verified daps

  - Parameter max\_dap : the maximum amount of daps between 2 verified daps

**Example**

``` swift
in3.btc.proofTarget(target_dap: 230, verified_dap: 200, max_diff: 5, max_dap: 5, limit: 15) .observe(using: {
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
in3.btc.getbestblockhash() .observe(using: {
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

#### sendtransaction(from:outputs:utxo:)

sends a transaction to a btc node

``` swift
public func sendtransaction(from: String, outputs: [BtcOutput], utxo: [BtcUtxo]) -> Future<String> 
```

**Parameters**

  - from: the public key derived from the private key used to sign
  - outputs: the desired outputs of the transaction
  - utxo: the utxo used to proove liquidity for the transaction

**Returns**

the transactionhash

#### sendrawtransaction(transaction:)

sends a transaction to a btc node

``` swift
public func sendrawtransaction(transaction: String) -> Future<String> 
```

**Parameters**

  - transaction: the signed raw transaction

**Returns**

the transactionhash

#### getblockheaderAsHex(hash:)

returns a hex representation of the blockheader

``` swift
public func getblockheaderAsHex(hash: String) -> Future<String?> 
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.

**Example**

``` swift
in3.btc.getblockheaderAsHex(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getblockheader(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getBlockAsHex(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getBlock(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getBlockWithTx(hash: "000000000000000000103b2395f6cd94221b10d02eb9be5850303c0534307220") .observe(using: {
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
in3.btc.getRawTransactionAsHex(txid: "f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf") .observe(using: {
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
in3.btc.getRawTransaction(txid: "f3c06e17b04ef748ce6604ad68e5b9f68ca96914b57c2118a1bb9a09a194ddaf") .observe(using: {
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
in3.btc.getblockcount() .observe(using: {
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

#### getdifficulty()

Returns the proof-of-work difficulty as a multiple of the minimum difficulty.

``` swift
public func getdifficulty() -> Future<Double> 
```

  - `blocknumber` is `latest`, `earliest`, `pending` or empty: the difficulty of the latest block (`actual latest block` minus `in3.finality`)

**Example**

``` swift
in3.btc.getdifficulty() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 15138043247082.88
     }
}
 
```

**Returns**

  - `blocknumber` is a certain number:​ the difficulty of this block

#### proofTarget(target_dap:verified_dap:max_diff:max_dap:limit:)

Whenever the client is not able to trust the changes of the target (which is the case if a block can't be found in the verified target cache *and* the value of the target changed more than the client's limit `max_diff`) he will call this method. It will return additional proof data to verify the changes of the target on the side of the client. This is not a standard Bitcoin rpc-method like the other ones, but more like an internal method.

``` swift
public func proofTarget(target_dap: UInt64, verified_dap: UInt64, max_diff: Int? = 5, max_dap: Int? = 5, limit: Int? = 0) -> Future<[BtcProofTargetResult]> 
```

  - Parameter target\_dap : the number of the difficulty adjustment period (dap) we are looking for

  - Parameter verified\_dap : the number of the closest already verified dap

  - Parameter max\_diff : the maximum target difference between 2 verified daps

  - Parameter max\_dap : the maximum amount of daps between 2 verified daps

**Example**

``` swift
in3.btc.proofTarget(target_dap: 230, verified_dap: 200, max_diff: 5, max_dap: 5, limit: 15) .observe(using: {
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
in3.btc.getbestblockhash() .observe(using: {
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

represents a contract with a defined ABI
for the ABI-spec see https:​//docs.soliditylang.org/en/v0.7.4/abi-spec.html?highlight=JSON\#json

``` swift
public class Contract 
```



#### init(in3:abi:abiJSON:at:)

creates a new Contract-Instance
you need to specify either the abi or the abiJson-Property.

``` swift
public init(in3:In3, abi:[ABI]? = nil, abiJSON:String? = nil, at: String?=nil) throws 
```

**Parameters**

  - in3: the Incubed instance
  - abi: the parsed structuured ABI-Definitions
  - abiJSON: the ABI as JSON-String
  - at: address of the deployed contract

#### init(in3:abi:at:)

``` swift
public init(in3:In3, abi:[ABI], at:String?=nil) throws 
```

#### init(in3:abiJSON:at:)

``` swift
public init(in3:In3, abiJSON:String, at:String?=nil) throws 
```

#### init(in3:abi:abiJSON:at:)

creates a new Contract-Instance
you need to specify either the abi or the abiJson-Property.

``` swift
public init(in3:In3, abi:[ABI]? = nil, abiJSON:String? = nil, at: String?=nil) throws 
```

**Parameters**

  - in3: the Incubed instance
  - abi: the parsed structuured ABI-Definitions
  - abiJSON: the ABI as JSON-String
  - at: address of the deployed contract

#### init(in3:abi:at:)

``` swift
public init(in3:In3, abi:[ABI], at:String?=nil) throws 
```

#### init(in3:abiJSON:at:)

``` swift
public init(in3:In3, abiJSON:String, at:String?=nil) throws 
```



#### deploy(data:args:account:gas:gasPrice:)

deploys the contract and returns the transactionhash

``` swift
public func deploy(data: String,  args: [AnyObject]?=nil,  account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) -> Future<String> 
```

**Parameters**

  - data: the bytes as hex of the code to deploy
  - args: the optional arguments of the constructor
  - account: the account to send the transaction from
  - gas: the amount of gas to be used
  - gasPrice: the gasPrice. If not given the current gasPrice will be used.

**Returns**

The TransactionHash

#### deployAndWait(data:args:account:gas:gasPrice:)

deploys the contract and wait until the receipt is available.

``` swift
public func deployAndWait(data: String,  args: [AnyObject]?=nil,  account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) -> Future<EthTransactionReceipt> 
```

**Parameters**

  - data: the bytes as hex of the code to deploy
  - args: the optional arguments of the constructor
  - account: the account to send the transaction from
  - gas: the amount of gas to be used
  - gasPrice: the gasPrice. If not given the current gasPrice will be used.

**Returns**

The TransactionReceipt

#### createDeployTx(data:args:account:gas:gasPrice:)

create a TransactionDefinition which cqan be used to deploy the contract

``` swift
public func createDeployTx(data: String, args: [AnyObject]?=nil, account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) throws -> EthTransaction  
```

**Parameters**

  - data: the bytes as hex of the code to deploy
  - args: the optional arguments of the constructor
  - account: the account to send the transaction from
  - gas: the amount of gas to be used
  - gasPrice: the gasPrice. If not given the current gasPrice will be used.

**Returns**

The Transaction Definition

#### call(name:args:block:account:gas:)

calls a function of the contract by running the code in a local evm.

``` swift
public func call(name: String, args: [AnyObject], block: UInt64? = nil, account:String?=nil,  gas: UInt64?=nil) -> Future<[Any]> 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender
  - gas: the amount of gas to be used as limit

**Returns**

a array witht the return values of the function

#### estimateGas(name:args:account:)

estimates the gas used to send a transaction to the specified function of the contract.

``` swift
public func estimateGas(name: String, args: [AnyObject], account:String?=nil) -> Future<UInt64> 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender

**Returns**

the gas needed to run a tx

#### sendTx(name:args:account:gas:gasPrice:)

sends a transaction to a function of the contract and returns the transactionHash

``` swift
public func sendTx(name: String,  args: [AnyObject],  account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) -> Future<String> 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender
  - gas: the amount of gas to be used as limit
  - gasPrice: the gasPrice. if not set, the current average gasPrice will be used.

**Returns**

the TransactionHash

#### sendTxAndWait(name:args:account:gas:gasPrice:)

sends a transaction to a function of the contract and waits for the receipt.

``` swift
public func sendTxAndWait(name: String,  args: [AnyObject],  account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) -> Future<EthTransactionReceipt> 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender
  - gas: the amount of gas to be used as limit
  - gasPrice: the gasPrice. if not set, the current average gasPrice will be used.

**Returns**

the TransactionReceipt

#### encodeCall(name:args:)

returns the abi encoded arguments as hex string

``` swift
public func encodeCall(name: String, args: [AnyObject]) throws -> String
```

**Parameters**

  - name: the name of the function
  - args: the arguments.

**Returns**

the abi encoded arguments as hex string

#### createTx(name:args:account:gas:gasPrice:)

creates the transaction parameter for a tx to the given function.

``` swift
public func createTx(name: String, args: [AnyObject], account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) throws -> EthTransaction 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender
  - gas: the amount of gas to be used as limit
  - gasPrice: the gasPrice. if not set, the current average gasPrice will be used.

**Returns**

the EthTransaction with the set parameters

#### getEvents(eventName:filter:fromBlock:toBlock:topics:)

reads events for the given contract
if the eventName is omitted all events will be returned. ( in this case  filter must be nil \! )

``` swift
public func getEvents(eventName:String? = nil, filter: [String:AnyObject]? = nil, fromBlock: UInt64? = nil, toBlock: UInt64? = nil, topics: [String?]?) -> Future<[EthEvent]> 
```

**Parameters**

  - eventName: the name of the event  or null if all events should be fetched
  - filter: the dictionary with values to search for. Only valid if the eventName is set and the all values must be indexed arguments\!
  - fromBlock: the BlockNumber to start searching for events. If nil the latest block is used.
  - toBlock: the BlockNumber to end searching for events. If nil the latest block is used.
  - topics: the topics of the block as search criteria.

#### deploy(data:args:account:gas:gasPrice:)

deploys the contract and returns the transactionhash

``` swift
public func deploy(data: String,  args: [AnyObject]?=nil,  account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) -> Future<String> 
```

**Parameters**

  - data: the bytes as hex of the code to deploy
  - args: the optional arguments of the constructor
  - account: the account to send the transaction from
  - gas: the amount of gas to be used
  - gasPrice: the gasPrice. If not given the current gasPrice will be used.

**Returns**

The TransactionHash

#### deployAndWait(data:args:account:gas:gasPrice:)

deploys the contract and wait until the receipt is available.

``` swift
public func deployAndWait(data: String,  args: [AnyObject]?=nil,  account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) -> Future<EthTransactionReceipt> 
```

**Parameters**

  - data: the bytes as hex of the code to deploy
  - args: the optional arguments of the constructor
  - account: the account to send the transaction from
  - gas: the amount of gas to be used
  - gasPrice: the gasPrice. If not given the current gasPrice will be used.

**Returns**

The TransactionReceipt

#### createDeployTx(data:args:account:gas:gasPrice:)

create a TransactionDefinition which cqan be used to deploy the contract

``` swift
public func createDeployTx(data: String, args: [AnyObject]?=nil, account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) throws -> EthTransaction  
```

**Parameters**

  - data: the bytes as hex of the code to deploy
  - args: the optional arguments of the constructor
  - account: the account to send the transaction from
  - gas: the amount of gas to be used
  - gasPrice: the gasPrice. If not given the current gasPrice will be used.

**Returns**

The Transaction Definition

#### call(name:args:block:account:gas:)

calls a function of the contract by running the code in a local evm.

``` swift
public func call(name: String, args: [AnyObject], block: UInt64? = nil, account:String?=nil,  gas: UInt64?=nil) -> Future<[Any]> 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender
  - gas: the amount of gas to be used as limit

**Returns**

a array witht the return values of the function

#### estimateGas(name:args:account:)

estimates the gas used to send a transaction to the specified function of the contract.

``` swift
public func estimateGas(name: String, args: [AnyObject], account:String?=nil) -> Future<UInt64> 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender

**Returns**

the gas needed to run a tx

#### sendTx(name:args:account:gas:gasPrice:)

sends a transaction to a function of the contract and returns the transactionHash

``` swift
public func sendTx(name: String,  args: [AnyObject],  account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) -> Future<String> 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender
  - gas: the amount of gas to be used as limit
  - gasPrice: the gasPrice. if not set, the current average gasPrice will be used.

**Returns**

the TransactionHash

#### sendTxAndWait(name:args:account:gas:gasPrice:)

sends a transaction to a function of the contract and waits for the receipt.

``` swift
public func sendTxAndWait(name: String,  args: [AnyObject],  account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) -> Future<EthTransactionReceipt> 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender
  - gas: the amount of gas to be used as limit
  - gasPrice: the gasPrice. if not set, the current average gasPrice will be used.

**Returns**

the TransactionReceipt

#### encodeCall(name:args:)

returns the abi encoded arguments as hex string

``` swift
public func encodeCall(name: String, args: [AnyObject]) throws -> String
```

**Parameters**

  - name: the name of the function
  - args: the arguments.

**Returns**

the abi encoded arguments as hex string

#### createTx(name:args:account:gas:gasPrice:)

creates the transaction parameter for a tx to the given function.

``` swift
public func createTx(name: String, args: [AnyObject], account:String?=nil, gas: UInt64?=nil, gasPrice: UInt64?=nil) throws -> EthTransaction 
```

**Parameters**

  - name: the name of the function
  - args: the arguments.
  - account: the account to be used as sender
  - gas: the amount of gas to be used as limit
  - gasPrice: the gasPrice. if not set, the current average gasPrice will be used.

**Returns**

the EthTransaction with the set parameters

#### getEvents(eventName:filter:fromBlock:toBlock:topics:)

reads events for the given contract
if the eventName is omitted all events will be returned. ( in this case  filter must be nil \! )

``` swift
public func getEvents(eventName:String? = nil, filter: [String:AnyObject]? = nil, fromBlock: UInt64? = nil, toBlock: UInt64? = nil, topics: [String?]?) -> Future<[EthEvent]> 
```

**Parameters**

  - eventName: the name of the event  or null if all events should be fetched
  - filter: the dictionary with values to search for. Only valid if the eventName is set and the all values must be indexed arguments\!
  - fromBlock: the BlockNumber to start searching for events. If nil the latest block is used.
  - toBlock: the BlockNumber to end searching for events. If nil the latest block is used.
  - topics: the topics of the block as search criteria.
### EQAuthentication

Provides functionality for accessing the Equs Authentication API.

``` swift
public class EQAuthentication 
```



#### register(username:password:completion:)

Registers a personal user

``` swift
public static func register(
        username: String,
        password: String,
        completion: @escaping (Result<EQToken, EQError>) -> Void
    ) 
```

**Parameters**

  - username: The user's username
  - password: The user's password
  - completion: The closure called when the registration is complete

#### signin(username:password:completion:)

Signin method is directly logging into the system as "PDS-OWNER". Every user in the system is a PDS-OWNER.

``` swift
public static func signin(
        username: String,
        password: String,
        completion: @escaping (Result<EQToken, EQError>) -> Void
    ) 
```

**Parameters**

  - username: The username
  - password: The password
  - completion: The closure called when the signin is complete

#### signout(token:completion:)

Signs a user out

``` swift
public static func signout(token: EQToken, completion: @escaping (Result<Bool, EQError>) -> Void) 
```

**Parameters**

  - token: The user auth token
  - completion: The completion handler called after the request
### EQAuthorizationModel

Authorization information as returned in the `EQProfileModel` struct.

``` swift
public class EQAuthorizationModel: Codable 
```



`Codable`



#### authorizationId

A unique authorization identifier.

``` swift
public let authorizationId: String
```

#### roleName

The role of the authorization.

``` swift
public let roleName: String
```

#### identityId

A unique identity identifier.

``` swift
public let identityId: String
```

#### entityId

A unique entity identifier.

``` swift
public let entityId: String
```

#### roleLabel

A displayable user-friendly role name.

``` swift
public let roleLabel: String
```

#### label

A label for the authorization.

``` swift
public let label: String?
```

#### displayName

A displayable user-friendly authorization name.

``` swift
public let displayName: String?
```
### EQBlockchainModel

Blockchain model information.

``` swift
public class EQBlockchainModel: Codable 
```



`Codable`
### EQBuildInfo

Build information for the Equs component.

``` swift
public class EQBuildInfo: Codable 
```



`Codable`
### EQCallerInfo

Caller information for the Equs component.

``` swift
public class EQCallerInfo: Codable 
```



`Codable`
### EQComponentInfo

Returned by a call to `api/pds/info` this
contains data regarding the Personal Data
Service component.

``` swift
public class EQComponentInfo: Codable 
```



`Codable`
### EQErrorHandler

An error handler class to help parse `EQError`s

``` swift
public class EQErrorHandler 
```



#### getErrorMessage(from:)

Gets the error message for an `EQError`

``` swift
public static func getErrorMessage(from error: EQError) -> String 
```

**Parameters**

  - error: The error to parse

**Returns**

The string describing the error
### EQLogger

A logger class for the Equs SDK

``` swift
public class EQLogger 
```



#### shared

A singleton instance of the logger

``` swift
public static let shared 
```



#### configure(minLevel:shouldShowRawData:)

Configures the logger

``` swift
public func configure(minLevel: LogLevel, shouldShowRawData: Bool) 
```

**Parameters**

  - minLevel: The lowest level to log
  - shouldShowRawData: Whether or not the responses should be printed

#### error(service:error:)

Logs an error

``` swift
public func error(service: EQService, error: Error) 
```

**Parameters**

  - service: The service where the error occured
  - error: The error to log

#### info(_:)

Logs an info level log

``` swift
public func info(_ message: String) 
```

**Parameters**

  - message: The message to log

#### log(service:message:)

Logs a log level log

``` swift
public func log(service: EQService, message: String) 
```

**Parameters**

  - service: The service to log from
  - message: The message to log

#### debug(_:)

Logs a debug level message

``` swift
public func debug(_ message: String) 
```

**Parameters**

  - message: The message to log

#### debugData(data:)

Logs data as a pretty printed json object if possible

``` swift
public func debugData(data: Data) 
```

**Parameters**

  - data: The data to logs
### EQPersonalDataService

Provides functionality for using the Equs Personal Data Service API.

``` swift
public class EQPersonalDataService 
```



#### getInfo(completion:)

Returns information about the PDS component.

``` swift
public static func getInfo(completion: @escaping EQNetworkingCompletion<EQComponentInfo>) 
```

**Parameters**

  - completion: The closure called when the request has finished

#### getPDSProfile(token:completion:)

Retreive identity profile

``` swift
public static func getPDSProfile(token: EQToken, completion: @escaping EQNetworkingCompletion<EQProfileModel>) 
```

**Parameters**

  - token: The Authentication token
  - completion: The function called on the request's completion

#### getPDSSummary(token:completion:)

Gets a pds users summary of services

``` swift
public static func getPDSSummary(
        token: EQToken,
        completion: @escaping EQNetworkingCompletion<EQPersonalDataServiceSummary>
    ) 
```

**Parameters**

  - token: The user's auth token
  - completion: The function called on the request's completion

#### createAttributes(token:attributes:completion:)

Adds attributes onto the pds user's account

``` swift
public static func createAttributes(
        token: EQToken,
        attributes: [EQNewAttribute],
        completion: @escaping EQNetworkingCompletion<[EQNewAttributeResponse]>
    ) 
```

**Parameters**

  - token: The user's auth token
  - attributes: The list of attributes to add
  - completion: The function called when the request completes

#### downloadImageFileAttribute(token:fileAttributeId:completion:)

Downloads an image file attribute

``` swift
public static func downloadImageFileAttribute(
        token: EQToken,
        fileAttributeId: EQAttributeId,
        completion: @escaping EQNetworkingCompletion<Data>
    ) 
```

**Parameters**

  - token: The user's auth token
  - fileAttributeId: The file's id
  - completion: The function called when the request completes

#### uploadImageFileAttribute(token:fileAttribute:completion:)

Uploads an image file attirbute

``` swift
public static func uploadImageFileAttribute(
        token: EQToken,
        fileAttribute: EQFileAttribute,
        completion: @escaping EQNetworkingCompletion<EQAttributeId>
    ) 
```

**Parameters**

  - token: The user's auth token
  - fileAttribute: The file attribute
  - completion: The function called when the request completes

#### getAllAttributes(token:completion:)

Gets all a user's attributes

``` swift
public static func getAllAttributes(
        token: EQToken,
        completion: @escaping EQNetworkingCompletion<[EQAttribute]>
    ) 
```

**Parameters**

  - token: The user's auth token
  - completion: The function called when the request completes

#### getServiceDefinitions(token:completion:)

Gets a list of serivce definitions a user can share their data with

``` swift
public static func getServiceDefinitions(
        token: EQToken,
        completion: @escaping EQNetworkingCompletion<[EQServiceDefinition]>
    ) 
```

**Parameters**

  - token: The user's auth token
  - completion: The function called when the request completes

#### getServiceDefinitionById(token:serviceDefintionId:completion:)

Gets a service definition by its ID

``` swift
public static func getServiceDefinitionById(
        token: EQToken,
        serviceDefintionId: String,
        completion: @escaping EQNetworkingCompletion<EQServiceDefinition>
    ) 
```

**Parameters**

  - token: The user's auth token
  - serviceDefintionId: The service defintion ID
  - completion: The function called when the request completes

#### getServices(token:completion:)

Gets a list of services the user is consuming

``` swift
public static func getServices(
        token: EQToken,
        completion: @escaping EQNetworkingCompletion<[EQUserServiceSummary]>
    ) 
```

**Parameters**

  - token: The user's auth token
  - completion: The function called when the request completes

#### getServiceById(token:serviceId:completion:)

Gets a specific service a user is consuming by the service's ID

``` swift
public static func getServiceById(
        token: EQToken,
        serviceId: EQServiceId,
        completion: @escaping EQNetworkingCompletion<EQUserService>
    ) 
```

**Parameters**

  - token: The user's auth token
  - serviceId: The service id
  - completion: The function called when the request completes

#### registerForService(token:serviceDefinitionId:attributes:policies:completion:)

Registers a user for a service

``` swift
public static func registerForService(
        token: EQToken,
        serviceDefinitionId: String,
        attributes: [EQSDAttributeResponse],
        policies: [EQUserPolicyResponse],
        completion: @escaping EQNetworkingCompletion<EQServiceId>
    ) 
```

**Parameters**

  - token: The user's auth token
  - serviceDefinitionId: The service definition the user wants to register for
  - attributes: The user's response to the attribute request from the service defintion
  - policies: The user's repsonse to the policies from the service definition
  - completion: The function called when the request completes

#### activateService(token:serviceId:completion:)

Activates a service a user has registered for

``` swift
public static func activateService(
        token: EQToken,
        serviceId: EQServiceId,
        completion: @escaping EQNetworkingCompletion<Bool>
    ) 
```

**Parameters**

  - token: The user's auth token
  - serviceId: The service id of the serivce the user wants to activate
  - completion: The function called when the request completes

#### terminateService(token:serviceId:completion:)

Terminates a service a user has activated

``` swift
public static func terminateService(
        token: EQToken,
        serviceId: EQServiceId,
        completion: @escaping EQNetworkingCompletion<Bool>
    ) 
```

**Parameters**

  - token: The user's auth token
  - serviceId: The service id of the serivce the user wants to activate
  - completion: The function called when the request completes

#### createPersona(token:personaName:completion:)

Creates a Persona

``` swift
public static func createPersona(
        token: EQToken,
        personaName: String,
        completion: @escaping EQNetworkingCompletion<EQPersonaId>
    ) 
```

**Parameters**

  - token: The user's token
  - personaName: The persona's name
  - completion: The function called when the request completes

#### getAllPersonas(token:completion:)

Gets all of user's personas

``` swift
public static func getAllPersonas(
        token: EQToken,
        completion: @escaping EQNetworkingCompletion<[EQPersona]>
    ) 
```

**Parameters**

  - token: The user's token
  - completion: The function called when the request completes

#### createAttributeForPersona(token:personaId:attribute:completion:)

Creates an attirbute for a persona

``` swift
public static func createAttributeForPersona(
        token: EQToken,
        personaId: EQPersonaId,
        attribute: EQNewPersonaAttribute,
        completion: @escaping EQNetworkingCompletion<EQAttributeId>
    ) 
```

**Parameters**

  - token: The user's token
  - personaId: The persona's id
  - attribute: The attribute to add
  - completion: The function called when the request completes

#### getAttributesForPersona(token:personaId:completion:)

Gets all the attributes for a persona

``` swift
public static func getAttributesForPersona(
        token: EQToken,
        personaId: EQPersonaId,
        completion: @escaping EQNetworkingCompletion<[EQPersonaAttribute]>
    ) 
```

**Parameters**

  - token: The user's token
  - personaId: The persona's id
  - completion: The function called when the request completes

#### registerPersonaForService(token:personaId:serviceRegistration:completion:)

Registers a user persona for

``` swift
public static func registerPersonaForService (
        token: EQToken,
        personaId: EQPersonaId,
        serviceRegistration: EQPersonaServiceRegistration,
        completion: @escaping EQNetworkingCompletion<EQServiceId>
    ) 
```

**Parameters**

  - token: The user's auth token
  - personaId: The persona to register a service for
  - serviceRegistration: The service registration object
  - completion: The function called when the request completes

#### getServicesForPersona(token:personaId:completion:)

Gets all of ther services a persona is registered for

``` swift
public static func getServicesForPersona(
        token: EQToken,
        personaId: EQPersonaId,
        completion: @escaping EQNetworkingCompletion<[EQPersonaService]>
    ) 
```

**Parameters**

  - token: The user's auth token
  - personaId: The persona
  - completion: The function called when the request completes
### EQPersonalDataServiceSummary

Returned by a call to `api/pds/summary` this
contains data summarizing the signed in user's Personal Data
Service.

``` swift
public class EQPersonalDataServiceSummary: Codable 
```



`Codable`
### EQProfileModel

Returned by a call to `api/pds/identities/profile` this
contains data describing the signed in user's Personal Data
Service profile.

``` swift
public class EQProfileModel: Codable 
```



`Codable`
### EQSchema

Equs Schema Component

``` swift
public class EQSchema 
```



#### getAttributeList(token:completion:)

Gets the list of attributes

``` swift
public static func getAttributeList(
        token: EQToken,
        completion: @escaping EQNetworkingCompletion<[EQSchemaAttribute]>
    ) 
```

**Parameters**

  - token: The user's auth token
  - completion: The function called when the request completes
### EQSymKeyModel

Symmetric key information.

``` swift
public class EQSymKeyModel: Codable 
```



`Codable`
### Equs

A singleton to correctly format Equs requests

``` swift
public class Equs 
```



#### shared

The Equs singleton instance

``` swift
public static let shared 
```



#### changeConfiguration(to:)

Changes the Equs endpoint configuration

``` swift
public func changeConfiguration(to configuration: EQEndpointConfiguration) 
```

**Parameters**

  - configuration: The new endpoint to swtich to

#### getConfiguration()

Gets the current configuration for Equs

``` swift
public func getConfiguration() -> EQEndpointConfiguration 
```

**Returns**

The endpoint configuration
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



#### gasPrice()

returns the current gasPrice in wei per gas

``` swift
public func gasPrice() -> Future<UInt64> 
```

**Example**

``` swift
in3.eth.gasPrice() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0x0625900800"
     }
}
 
```

**Returns**

the current gasPrice in wei per gas

#### feeHistory(blockCount:newestBlock:rewardPercentiles:)

base fee per gas and transaction effective priority fee per gas history for the requested block range if available.
The range between headBlock-4 and headBlock is guaranteed to be available while retrieving data from the pending block and older history are optional to support.
For pre-EIP-1559 blocks the gas prices are returned as rewards and zeroes are returned for the base fee per gas

``` swift
public func feeHistory(blockCount: UInt64, newestBlock: UInt64? = nil, rewardPercentiles: [Double]? = nil) -> Future<FeeHistory> 
```

**Parameters**

  - blockCount: Number of blocks in the requested range. Between 1 and 1024 blocks can be requested in a single query. Less than requested may be returned if not all blocks are available.
  - newestBlock: the Highest blockNumber or one of `latest`, `earliest`or `pending`
  - rewardPercentiles: A monotonically increasing list of percentile values to sample from each block's effective priority fees per gas in ascending order, weighted by gas used.

**Returns**

Fee history for the returned block range. This can be a subsection of the requested range if not all blocks are available.

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
in3.eth.blockNumber() .observe(using: {
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
in3.eth.getBlock() .observe(using: {
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
in3.eth.getBlockWithTx() .observe(using: {
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
in3.eth.getBlockByHash(blockHash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585") .observe(using: {
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
in3.eth.getBlockByHashWithTx(blockHash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585") .observe(using: {
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
public func getBlockTransactionCountByHash(blockHash: String) -> Future<Int?> 
```

**Parameters**

  - blockHash: the blockHash of the block

**Returns**

the number of transactions in the block

#### getBlockTransactionCountByNumber(blockNumber:)

returns the number of transactions. For Spec, see [eth\_getBlockTransactionCountByNumber](https:​//eth.wiki/json-rpc/API#eth_getBlockTransactionCountByNumber).

``` swift
public func getBlockTransactionCountByNumber(blockNumber: UInt64) -> Future<Int?> 
```

**Parameters**

  - blockNumber: the blockNumber of the block

**Returns**

the number of transactions in the block

#### getUncleCountByBlockHash(blockHash:)

returns the number of uncles. For Spec, see [eth\_getUncleCountByBlockHash](https:​//eth.wiki/json-rpc/API#eth_getUncleCountByBlockHash).

``` swift
public func getUncleCountByBlockHash(blockHash: String) -> Future<Int?> 
```

**Parameters**

  - blockHash: the blockHash of the block

**Returns**

the number of uncles

#### getUncleCountByBlockNumber(blockNumber:)

returns the number of uncles. For Spec, see [eth\_getUncleCountByBlockNumber](https:​//eth.wiki/json-rpc/API#eth_getUncleCountByBlockNumber).

``` swift
public func getUncleCountByBlockNumber(blockNumber: UInt64) -> Future<Int?> 
```

**Parameters**

  - blockNumber: the blockNumber of the block

**Returns**

the number of uncles

#### getTransactionByBlockHashAndIndex(blockHash:index:)

returns the transaction data.

``` swift
public func getTransactionByBlockHashAndIndex(blockHash: String, index: Int) -> Future<EthTransactiondata?> 
```

See JSON-RPC-Spec for [eth\_getTransactionByBlockHashAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockHashAndIndex) for more details.

**Example**

``` swift
in3.eth.getTransactionByBlockHashAndIndex(blockHash: "0x4fc08daf8d670a23eba7a1aca1f09591c19147305c64d25e1ddd3dd43ff658ee", index: "0xd5") .observe(using: {
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
public func getTransactionByBlockNumberAndIndex(blockNumber: UInt64, index: Int) -> Future<EthTransactiondata?> 
```

See JSON-RPC-Spec for [eth\_getTransactionByBlockNumberAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockNumberAndIndex) for more details.

**Example**

``` swift
in3.eth.getTransactionByBlockNumberAndIndex(blockNumber: "0xb8a4a9", index: "0xd5") .observe(using: {
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
public func getTransactionByHash(txHash: String) -> Future<EthTransactiondata?> 
```

See JSON-RPC-Spec for [eth\_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash) for more details.

**Example**

``` swift
in3.eth.getTransactionByHash(txHash: "0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b") .observe(using: {
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
public func getLogs(filter: EthLogFilter) -> Future<[Ethlog]> 
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
in3.eth.getBalance(account: "0x2e333ec090f1028df0a3c39a918063443be82b2b") .observe(using: {
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
public func getTransactionCount(account: String, block: UInt64? = nil) -> Future<UInt64> 
```

**Example**

``` swift
in3.eth.getTransactionCount(account: "0x2e333ec090f1028df0a3c39a918063443be82b2b") .observe(using: {
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
in3.eth.getCode(account: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f") .observe(using: {
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
in3.eth.getStorageAt(account: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f", key: "0x0") .observe(using: {
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
in3.eth.call(tx: EthTransaction(to: "0x2736D225f85740f42D17987100dc8d58e9e16252", data: "0x5cf0f3570000000000000000000000000000000000000000000000000000000000000001")) .observe(using: {
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
in3.eth.getTransactionReceipt(txHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e") .observe(using: {
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

#### gasPrice()

returns the current gasPrice in wei per gas

``` swift
public func gasPrice() -> Future<UInt64> 
```

**Example**

``` swift
in3.eth.gasPrice() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = "0x0625900800"
     }
}
 
```

**Returns**

the current gasPrice in wei per gas

#### feeHistory(blockCount:newestBlock:rewardPercentiles:)

base fee per gas and transaction effective priority fee per gas history for the requested block range if available.
The range between headBlock-4 and headBlock is guaranteed to be available while retrieving data from the pending block and older history are optional to support.
For pre-EIP-1559 blocks the gas prices are returned as rewards and zeroes are returned for the base fee per gas

``` swift
public func feeHistory(blockCount: UInt64, newestBlock: UInt64? = nil, rewardPercentiles: [Double]? = nil) -> Future<FeeHistory> 
```

**Parameters**

  - blockCount: Number of blocks in the requested range. Between 1 and 1024 blocks can be requested in a single query. Less than requested may be returned if not all blocks are available.
  - newestBlock: the Highest blockNumber or one of `latest`, `earliest`or `pending`
  - rewardPercentiles: A monotonically increasing list of percentile values to sample from each block's effective priority fees per gas in ascending order, weighted by gas used.

**Returns**

Fee history for the returned block range. This can be a subsection of the requested range if not all blocks are available.

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
in3.eth.blockNumber() .observe(using: {
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
in3.eth.getBlock() .observe(using: {
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
in3.eth.getBlockWithTx() .observe(using: {
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
in3.eth.getBlockByHash(blockHash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585") .observe(using: {
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
in3.eth.getBlockByHashWithTx(blockHash: "0x2baa54adcd8a105cdedfd9c6635d48d07b8f0e805af0a5853190c179e5a18585") .observe(using: {
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
public func getBlockTransactionCountByHash(blockHash: String) -> Future<Int?> 
```

**Parameters**

  - blockHash: the blockHash of the block

**Returns**

the number of transactions in the block

#### getBlockTransactionCountByNumber(blockNumber:)

returns the number of transactions. For Spec, see [eth\_getBlockTransactionCountByNumber](https:​//eth.wiki/json-rpc/API#eth_getBlockTransactionCountByNumber).

``` swift
public func getBlockTransactionCountByNumber(blockNumber: UInt64) -> Future<Int?> 
```

**Parameters**

  - blockNumber: the blockNumber of the block

**Returns**

the number of transactions in the block

#### getUncleCountByBlockHash(blockHash:)

returns the number of uncles. For Spec, see [eth\_getUncleCountByBlockHash](https:​//eth.wiki/json-rpc/API#eth_getUncleCountByBlockHash).

``` swift
public func getUncleCountByBlockHash(blockHash: String) -> Future<Int?> 
```

**Parameters**

  - blockHash: the blockHash of the block

**Returns**

the number of uncles

#### getUncleCountByBlockNumber(blockNumber:)

returns the number of uncles. For Spec, see [eth\_getUncleCountByBlockNumber](https:​//eth.wiki/json-rpc/API#eth_getUncleCountByBlockNumber).

``` swift
public func getUncleCountByBlockNumber(blockNumber: UInt64) -> Future<Int?> 
```

**Parameters**

  - blockNumber: the blockNumber of the block

**Returns**

the number of uncles

#### getTransactionByBlockHashAndIndex(blockHash:index:)

returns the transaction data.

``` swift
public func getTransactionByBlockHashAndIndex(blockHash: String, index: Int) -> Future<EthTransactiondata?> 
```

See JSON-RPC-Spec for [eth\_getTransactionByBlockHashAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockHashAndIndex) for more details.

**Example**

``` swift
in3.eth.getTransactionByBlockHashAndIndex(blockHash: "0x4fc08daf8d670a23eba7a1aca1f09591c19147305c64d25e1ddd3dd43ff658ee", index: "0xd5") .observe(using: {
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
public func getTransactionByBlockNumberAndIndex(blockNumber: UInt64, index: Int) -> Future<EthTransactiondata?> 
```

See JSON-RPC-Spec for [eth\_getTransactionByBlockNumberAndIndex](https://eth.wiki/json-rpc/API#eth_getTransactionByBlockNumberAndIndex) for more details.

**Example**

``` swift
in3.eth.getTransactionByBlockNumberAndIndex(blockNumber: "0xb8a4a9", index: "0xd5") .observe(using: {
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
public func getTransactionByHash(txHash: String) -> Future<EthTransactiondata?> 
```

See JSON-RPC-Spec for [eth\_getTransactionByHash](https://eth.wiki/json-rpc/API#eth_getTransactionByHash) for more details.

**Example**

``` swift
in3.eth.getTransactionByHash(txHash: "0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b") .observe(using: {
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
public func getLogs(filter: EthLogFilter) -> Future<[Ethlog]> 
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
in3.eth.getBalance(account: "0x2e333ec090f1028df0a3c39a918063443be82b2b") .observe(using: {
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
public func getTransactionCount(account: String, block: UInt64? = nil) -> Future<UInt64> 
```

**Example**

``` swift
in3.eth.getTransactionCount(account: "0x2e333ec090f1028df0a3c39a918063443be82b2b") .observe(using: {
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
in3.eth.getCode(account: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f") .observe(using: {
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
in3.eth.getStorageAt(account: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f", key: "0x0") .observe(using: {
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
in3.eth.call(tx: EthTransaction(to: "0x2736D225f85740f42D17987100dc8d58e9e16252", data: "0x5cf0f3570000000000000000000000000000000000000000000000000000000000000001")) .observe(using: {
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
in3.eth.getTransactionReceipt(txHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e") .observe(using: {
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
public class FileCache : In3Cache 
```



[`In3Cache`](/In3Cache), [`In3Cache`](/In3Cache), [`In3Cache`](/In3Cache), [`In3Cache`](/In3Cache)



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

#### Result

``` swift
public typealias Result = Swift.Result<Value, Error>
```



#### observe(using:)

``` swift
public func observe(using callback: @escaping (Result) -> Void) 
```

#### observe(using:)

``` swift
public func observe(using callback: @escaping (Result) -> Void) 
```
### IdentitySession

a Session for communicating with the Identity Services

``` swift
public class IdentitySession 
```



#### token

the current token

``` swift
public var token: EQToken? = nil
```

#### equsHelper

returns the Equs Identity Helper

``` swift
public var equsHelper : Equs 
```



#### getSchemaAttributeList()

Gets the list of attributes from a Schema

``` swift
public func getSchemaAttributeList() -> Future<[EQSchemaAttribute]> 
```

#### getPDSInfo()

Returns information about the PDS component.

``` swift
public func getPDSInfo() -> Future<EQComponentInfo>  
```

**Parameters**

  - completion: The closure called when the request has finished

#### getPDSProfile()

Retreive identity profile

``` swift
public func getPDSProfile() -> Future<EQProfileModel> 
```

#### getPDSSummary()

Gets a pds users summary of services

``` swift
public  func getPDSSummary() -> Future<EQPersonalDataServiceSummary> 
```

#### createPDSAttributes(attributes:)

Adds attributes onto the pds user's account

``` swift
public  func createPDSAttributes( attributes: [EQNewAttribute])-> Future<[EQNewAttributeResponse]> 
```

  - attributes: The list of attributes to add

#### downloadPDSImageFileAttribute(fileAttributeId:)

Downloads an image file attribute

``` swift
public  func downloadPDSImageFileAttribute( fileAttributeId: EQAttributeId)-> Future<Data> 
```

**Parameters**

  - fileAttributeId: The file's id

#### uploadPDSImageFileAttribute(fileAttribute:)

Uploads an image file attirbute

``` swift
public func uploadPDSImageFileAttribute(fileAttribute: EQFileAttribute) -> Future<EQAttributeId> 
```

**Parameters**

  - fileAttribute: The file attribute

#### getAllPDSAttributes()

Gets all a user's attributes

``` swift
public  func getAllPDSAttributes()-> Future<[EQAttribute]> 
```

#### getPDSServiceDefinitions()

Gets a list of serivce definitions a user can share their data with

``` swift
public  func getPDSServiceDefinitions()-> Future<[EQServiceDefinition]> 
```

#### getPDSServiceDefinitionById(serviceDefintionId:)

Gets a service definition by its ID

``` swift
public  func getPDSServiceDefinitionById( serviceDefintionId: String)-> Future<EQServiceDefinition> 
```

**Parameters**

  - serviceDefintionId: The service defintion ID

#### getPDSServices()

Gets a list of services the user is consuming

``` swift
public  func getPDSServices()-> Future<[EQUserServiceSummary]> 
```

#### getPDSServiceDefinitionById(serviceId:)

Gets a specific service a user is consuming by the service's ID

``` swift
public  func getPDSServiceDefinitionById( serviceId: String)-> Future<EQUserService> 
```

**Parameters**

  - serviceId: The service id

#### registerForPDSService(serviceDefinitionId:attributes:policies:)

Registers a user for a service

``` swift
public  func registerForPDSService( serviceDefinitionId: String,
                                              attributes: [EQSDAttributeResponse],
                                              policies: [EQUserPolicyResponse])-> Future<EQServiceId> 
```

**Parameters**

  - serviceDefinitionId: The service definition the user wants to register for
  - attributes: The user's response to the attribute request from the service defintion
  - policies: The user's repsonse to the policies from the service definition

#### activatePDSService(serviceId:)

Activates a service a user has registered for

``` swift
public  func activatePDSService(  serviceId: EQServiceId )-> Future<Bool> 
```

**Parameters**

  - serviceId: The service id of the serivce the user wants to activate

#### terminatePDSService(serviceId:)

Terminates a service a user has activated

``` swift
public  func terminatePDSService(  serviceId: EQServiceId )-> Future<Bool> 
```

**Parameters**

  - serviceId: The service id of the serivce the user wants to activate

#### createPersona(personaName:)

Creates a Persona

``` swift
public  func createPersona(  personaName: String )-> Future<EQPersonaId> 
```

**Parameters**

  - personaName: The persona's name

#### getAllPersonas()

Gets all of user's personas

``` swift
public  func getAllPersonas( )-> Future<[EQPersona]> 
```

**Parameters**

  - personaName: The persona's name

#### createPDSAttributeForPersona(personaId:attribute:)

Creates an attirbute for a persona

``` swift
public  func createPDSAttributeForPersona( personaId: EQPersonaId,
                                               attribute: EQNewPersonaAttribute )-> Future<EQAttributeId> 
```

**Parameters**

  - personaId: The persona's id
  - attribute: The attribute to add

#### getPDSAttributesForPersona(personaId:)

Gets all the attributes for a persona

``` swift
public  func getPDSAttributesForPersona( personaId: EQPersonaId)-> Future<[EQPersonaAttribute]> 
```

**Parameters**

  - personaId: The persona's id

#### registerPersonaForPDSService(personaId:serviceRegistration:)

Registers a user persona for

``` swift
public  func registerPersonaForPDSService(         personaId: EQPersonaId,
                                                       serviceRegistration: EQPersonaServiceRegistration)-> Future<EQServiceId> 
```

**Parameters**

  - personaId: The persona to register a service for
  - serviceRegistration: The service registration object

#### getPDSServicesForPersona(personaId:)

Gets all of ther services a persona is registered for

``` swift
public  func getPDSServicesForPersona(         personaId: EQPersonaId)-> Future<[EQPersonaService]> 
```

**Parameters**

  - personaId: The persona
  - serviceRegistration: The service registration object

#### register(username:password:)

Registers a personal user

``` swift
public  func register(
        username: String,
        password: String) ->
        Future<EQToken> 
```

**Parameters**

  - username: The user's username
  - password: The user's password

#### signin(username:password:)

Signin method is directly logging into the system as "PDS-OWNER". Every user in the system is a PDS-OWNER.

``` swift
public  func signin(
        username: String,
        password: String) ->
        Future<EQToken> 
```

**Parameters**

  - username: The username
  - password: The password

#### signout()

Signs a user out

``` swift
public  func signout( )-> Future<Bool> 
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

#### init(_:)

initialize with a Configurations

``` swift
public init(_ config: In3Config) throws 
```



#### account

the Account API

``` swift
public var account : Account 
```

#### account

the Account API

``` swift
public var account : Account 
```

#### btc

the Btc API

``` swift
public var btc : Btc 
```

#### btc

the Btc API

``` swift
public var btc : Btc 
```

#### eth

the Eth API

``` swift
public var eth : Eth 
```

#### eth

the Eth API

``` swift
public var eth : Eth 
```

#### ipfs

the Ipfs API

``` swift
public var ipfs : Ipfs 
```

#### ipfs

the Ipfs API

``` swift
public var ipfs : Ipfs 
```

#### nodelist

the Nodelist API

``` swift
public var nodelist : Nodelist 
```

#### nodelist

the Nodelist API

``` swift
public var nodelist : Nodelist 
```

#### utils

the Utils API

``` swift
public var utils : Utils 
```

#### utils

the Utils API

``` swift
public var utils : Utils 
```

#### vault

the Vault API

``` swift
public var vault : Vault 
```

#### vault

the Vault API

``` swift
public var vault : Vault 
```

#### wallets

the Wallets API

``` swift
public var wallets : Wallets 
```

#### wallets

the Wallets API

``` swift
public var wallets : Wallets 
```

#### zksync

the Zksync API

``` swift
public var zksync : Zksync 
```

#### zksync

the Zksync API

``` swift
public var zksync : Zksync 
```

#### transport

the transport function

``` swift
public var transport: (_ url: String, _ method:String, _ payload:Data?, _ headers: [String], _ cb: @escaping (_ data:TransportResult)->Void) -> Void
```

#### transport

the transport function

``` swift
public var transport: (_ url: String, _ method:String, _ payload:Data?, _ headers: [String], _ cb: @escaping (_ data:TransportResult)->Void) -> Void
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
public func execLocal(_ method: String, _ params: RPCObject...) throws -> RPCObject 
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
public func exec(_ method: String, _ params: RPCObject..., cb: @escaping  (_ result:RequestResult)->Void) throws 
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
public func execLocal(_ method: String, _ params: RPCObject...) throws -> RPCObject 
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
public func exec(_ method: String, _ params: RPCObject..., cb: @escaping  (_ result:RequestResult)->Void) throws 
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
in3.ipfs.get(ipfshash: "QmSepGsypERjq71BSm4Cjq7j8tyAUnCw6ZDTeNdE8RUssD", encoding: "utf8") .observe(using: {
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
in3.ipfs.put(data: "I love Incubed", encoding: "utf8") .observe(using: {
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

#### get(ipfshash:encoding:)

Fetches the data for a requested ipfs-hash. If the node is not able to resolve the hash or find the data a error should be reported.

``` swift
public func get(ipfshash: String, encoding: String) -> Future<String> 
```

**Example**

``` swift
in3.ipfs.get(ipfshash: "QmSepGsypERjq71BSm4Cjq7j8tyAUnCw6ZDTeNdE8RUssD", encoding: "utf8") .observe(using: {
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
in3.ipfs.put(data: "I love Incubed", encoding: "utf8") .observe(using: {
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
### L1Wallets

This module contains specific function for deploying and managing l1-wallets

``` swift
public class L1Wallets 
```



#### read(account:)

reads the data from a contract and returns it as multisig definition.

``` swift
public func read(account: String) -> Future<MsDef> 
```

**Parameters**

  - account: the address of the wallet

**Returns**

the wallet-configuration

#### getHistory(force_update:only_new:account:)

reads the history and all events for the wallet.

``` swift
public func getHistory(force_update: Bool? = nil, only_new: Bool? = nil, account: String? = nil) -> Future<[WalletTx]> 
```

  - Parameter force\_update : if true the history will also be update otherwise it will be taken from the cache and only created if it does not exist yet

  - Parameter only\_new : if true, only new events will be returned

**Example**

``` swift
sdk.wallets.l1.getHistory(force_update: true, only_new: false, account: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          - tx_hash: "0xeecc2675960daec8dcfa2f4bc77f4990d251f3467a498b458ea6c1010ae7b395"
//            block: 8928202
//            layer: eth-4
//            timestamp: 1626161216
//            events:
//              - log_index: 44
//                type: ProxyCreation
//                address: "0xb0d4d3b2fbf42770e8e0cf496c26c6b2b496e962"
//              - log_index: 45
//                type: EnabledModule
//                address: "0xb0d4d3b2fbf42770e8e0cf496c26c6b2b496e962"
//          - tx_hash: "0x5fd643202b943112e799ca60305adbafe70e7f512952eae6dd4c5b00c2f136e5"
//            block: 8946267
//            layer: eth-4
//            timestamp: 1626432263
//            events:
//              - log_index: 27
//                type: ExecutionFailure
//                tx_hash: "0xa27d76a7faeb9b1f7e5caf1cd7cf9abbb73b17a447bac8fb6cec694a1009df0f"
//                gas: 0
//          - tx_hash: "0xb73aab562d8a689b3ccdf904378a95be7e515a2fb17f1b7aec53bce50349959a"
//            block: 8946321
//            layer: eth-4
//            timestamp: 1626433073
//            events:
//              - log_index: 19
//                type: Transfer
//                token: "0x0000000000000000000000000000000000000000"
//                tx_hash: "0x722bf0999e08d45186bbb91d3cb2a80ad453e3fe49e6555fa8641dde7d3333bb"
//                to: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//                amount: "0x2386f26fc10000"
//                from: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//              - log_index: 20
//                type: ExecutionSuccess
//                tx_hash: "0x722bf0999e08d45186bbb91d3cb2a80ad453e3fe49e6555fa8641dde7d3333bb"
//                gas: 0
     }
}
 
```

**Parameters**

  - account: the address of the wallet

**Returns**

a array with all events since the creation of the wallet.

#### getBalance(token:wallet:)

returns the balance for the specified account or wallet

``` swift
public func getBalance(token: String? = "ETH", wallet: String? = nil) -> Future<UInt256> 
```

**Example**

``` swift
sdk.wallets.l1.getBalance(token: "ETH", wallet: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 78187493520
     }
}
 
```

**Parameters**

  - token: The name or address of the token or NULL (or "ETH") if eth-balance is requested.
  - wallet: the wallet or account to be used. I ommited the default-wallet as configured.

**Returns**

the current balance

#### exec(tx:exec:wallet:)

executes or prepares a transaction for a wallet.

``` swift
public func exec(tx: TxData, exec: String? = "send", wallet: String? = nil) -> Future<TxData> 
```

**Parameters**

  - tx: the description of the transaction. As minimum only the inputs are needed.     /// But in order to sign with multiple parties the definition can be passed to combined multiple signatures    ///
  - exec: the execution level when sending transactions trough the wallet.    ///     - `prepare` - the transaction is not signed, but for the multisig signatures all useable signatures are collected.    ///     - `sign` - the raw transaction is signed    ///     - `send` - the transaction is send and the transactionHash is added    ///     - `receipt` - the function will wait until the receipt has been found     ///
  - wallet: the wallet to be used. If ommited,  either the wallet as defined in the input-data is used, or the default-wallet as configured.

**Returns**

the transaction-state

#### deploy(threshold:owners:modules:txparams:)

deploys a wallet on layer1. This function will send the transaction with either the default-wallet (or first wallet ) or the first registered signer account.
It will wait until the transaction is mined. In order to deploy contract you need to configure the mater-copies in the config by stting the `wallet_deploy`- object like

``` swift
public func deploy(threshold: Int, owners: [String], modules: MsDef? = nil, txparams: TxInput? = nil) -> Future<WalletUpdate> 
```

``` js
{ 
  "wallet_deploy": {
    "creator": "0xaa8c54c65c14f132804f0809bdbef19970673709",
    "master_copy": "0xc73248bb521c3331e4efedbb0560e806302024fb",
    "add_module": "0x846A192315882ca369125F82E64e368858663898",
    "master_copy_custody": "0x937c53Cad1619a996645165129620eF2853c76B0",
    "multisend": "0xD473Ac22bF22EE68cB8D3CA529BC60864613e0eD"
  }
}
```

**Example**

``` swift
sdk.wallets.l1.deploy(threshold: 2, owners: ["IA:0x9d646b325787c6d7d612eb37915ca3023eea4dac","A:0x3e8428a44f0a7e3c1f8e00264da96f22f1dec5b9","A:0xbca6f7f77283a78640b09fe6d44b74717b066557"]) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          tx:
//            input:
//              to: "0xaa8c54c65c14f132804f0809bdbef19970673709"
//              from: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//              wallet: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//              data: "0x61b69abd000000000000000000000000c73248bb521c3331e4efedbb0560e806302024\
//                fb00000000000000000000000000000000000000000000000000000000000000400000000\
//                0000000000000000000000000000000000000000000000000000002446efc73ce00000000\
//                0000000000000000000000000000000000000000000000000000012000000000000000000\
//                000000000000000000000000000000000000000000001a000000000000000000000000000\
//                0000000000000000000000000000000000000200000000000000000000000000000000000\
//                0000000000000000000000000000000000000000000000000000000000000000000000000\
//                0000000000000000022000000000000000000000000000000000000000000000000000000\
//                0000000000000000000000000000000000000000000000000000000000000000000000000\
//                0000000000000000000000000000000000000000000000000000000000000000000000000\
//                0000000000000000000000000000000000000000000000000000000000000000000000000\
//                0000000000000000000000000000000000000000000000030000000000000000000000009\
//                d646b325787c6d7d612eb37915ca3023eea4dac0000000000000000000000003e8428a44f\
//                0a7e3c1f8e00264da96f22f1dec5b9000000000000000000000000bca6f7f77283a78640b\
//                09fe6d44b74717b0665570000000000000000000000000000000000000000000000000000\
//                0000000000030000000000000000000000000000000000000000000000000000000000000\
//                0060000000000000000000000000000000000000000000000000000000000000004000000\
//                0000000000000000000000000000000000000000000000000000000004000000000000000\
//                0000000000000000000000000000000000000000000000000000000000000000000000000\
//                00000000000000000000000000000000"
//              gas: "0xe8320"
//            state: receipt
//            receipt:
//              blockHash: "0x268396cdec2ffb623b9f54cbfa61d708815f1bd9f16fae232a2f26df56de26a5"
//              blockNumber: "0x89093d"
//              contractAddress: null
//              cumulativeGasUsed: "0x1ea42a"
//              effectiveGasPrice: "0x3b9aca08"
//              from: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//              gasUsed: "0x5db9d"
//              logs:
//                - address: "0xaa8c54c65c14f132804f0809bdbef19970673709"
//                  blockHash: "0x268396cdec2ffb623b9f54cbfa61d708815f1bd9f16fae232a2f26df56de26a5"
//                  blockNumber: "0x89093d"
//                  data: "0x0000000000000000000000004b5b6284965fca369aada7ecdaee3b190d3d6d43"
//                  logIndex: "0x2e"
//                  removed: false
//                  topics:
//                    - "0xa38789425dbeee0239e16ff2d2567e31720127fbc6430758c1a4efc6aef29f80"
//                  transactionHash: "0x7c4ab2587d35fcabf8ee5280cf8abb22381e95814474cb07696327ad059b1249"
//                  transactionIndex: "0xe"
//              logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000\
//                0000000000000000000000000000000000000000000000000000000000000000000000000\
//                0000000000000000000000000000000000000000000000000000000000000000000000000\
//                0000002000000000000000000000000000000000000008000000000000000000000000000\
//                0000000000000000000000000000000000000000000000000000000008000000000000000\
//                0000000000000000000000000000000000000000000000000000000000000000000000000\
//                0000000000000000002000000000000000000000000000004000000000000000000200000\
//                000000000"
//              status: "0x1"
//              to: "0xaa8c54c65c14f132804f0809bdbef19970673709"
//              transactionHash: "0x7c4ab2587d35fcabf8ee5280cf8abb22381e95814474cb07696327ad059b1249"
//              transactionIndex: "0xe"
//              type: "0x0"
//          wallet:
//            address: "0x4b5b6284965fca369aada7ecdaee3b190d3d6d43"
//            threshold: 2
//            type: l1
//            owners:
//              - roles: 6
//                address: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//              - roles: 4
//                address: "0x3e8428a44f0a7e3c1f8e00264da96f22f1dec5b9"
//              - roles: 4
//                address: "0xbca6f7f77283a78640b09fe6d44b74717b066557"
//            creator: "0xaa8c54c65c14f132804f0809bdbef19970673709"
//            master_copy: "0xc73248bb521c3331e4efedbb0560e806302024fb"
//            master_copy_custody: "0x937c53cad1619a996645165129620ef2853c76b0"
//            create_module: "0x846a192315882ca369125f82e64e368858663898"
//            safetype: IAMO Safe
//            deploy_block: "0x89093d"
     }
}
 
```

**Parameters**

  - threshold: the threshhold of the multisig, which must be reached in order to execute any transaction.
  - owners: array of owner-addresses. Each address may use a prefix to indicate the role (`I`: Initiator, `A`: Approver, `C`: Challenger).
  - modules: the moduledefinitions
  - txparams: the transaction-arguemnts that should be used for the deployment-tx. Currently supported are contain `gasPrice` , `gas`  and `nonce` . If passed as object, they will be used.

**Returns**

the wallert-definition with the deployed address.
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
in3.nodelist.nodes(limit: 2, seed: "0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b", addresses: []) .observe(using: {
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
public func signBlockHash(blocks: In3SignBlock) -> Future<In3SignedBlockHash> 
```

Since each node has a risk of signing a wrong blockhash and getting convicted and losing its deposit,
per default nodes will and should not sign blockHash of the last `minBlockHeight` (default: 6) blocks\!

**Example**

``` swift
in3.nodelist.signBlockHash(blocks: In3SignBlock(blockNumber: 8770580)) .observe(using: {
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
public func whitelist(address: String) -> Future<In3WhiteList> 
```

**Example**

``` swift
in3.nodelist.whitelist(address: "0x08e97ef0a92EB502a1D7574913E2a6636BeC557b") .observe(using: {
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

#### nodes(limit:seed:addresses:)

fetches and verifies the nodeList from a node

``` swift
public func nodes(limit: Int? = nil, seed: String? = nil, addresses: [String]? = nil) -> Future<NodeListDefinition> 
```

**Example**

``` swift
in3.nodelist.nodes(limit: 2, seed: "0xe9c15c3b26342e3287bb069e433de48ac3fa4ddd32a31b48e426d19d761d7e9b", addresses: []) .observe(using: {
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
public func signBlockHash(blocks: In3SignBlock) -> Future<In3SignedBlockHash> 
```

Since each node has a risk of signing a wrong blockhash and getting convicted and losing its deposit,
per default nodes will and should not sign blockHash of the last `minBlockHeight` (default: 6) blocks\!

**Example**

``` swift
in3.nodelist.signBlockHash(blocks: In3SignBlock(blockNumber: 8770580)) .observe(using: {
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
public func whitelist(address: String) -> Future<In3WhiteList> 
```

**Example**

``` swift
in3.nodelist.whitelist(address: "0x08e97ef0a92EB502a1D7574913E2a6636BeC557b") .observe(using: {
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



`Future<Value>`, `Future<Value>`



#### resolve(with:)

``` swift
public func resolve(with value: Value) 
```

#### reject(with:)

``` swift
public func reject(with error: Error) 
```

#### resolve(with:)

``` swift
public func resolve(with value: Value) 
```

#### reject(with:)

``` swift
public func reject(with error: Error) 
```
### SDK

``` swift
public class SDK: In3 
```



[`In3`](/In3), [`In3`](/In3)



#### init(_:)

``` swift
public override init(_ config: In3Config) throws 
```



#### newIdentitySession(serviceUrl:token:)

creates a new Identity Session

``` swift
public func newIdentitySession(serviceUrl: String, token: EQToken? = nil) -> IdentitySession 
```

  - Parameters
    
      - serviceUrl : the Url of the NetID-Service
      - token: a optional token for an existing session.
### UInt256

a bigint implementation based on tommath to represent big numbers
It is used to represent uint256 values

``` swift
final public class UInt256: CustomStringConvertible, Hashable, Comparable, Decodable, Encodable 
```



`Comparable`, `Comparable`, `CustomStringConvertible`, `CustomStringConvertible`, `Decodable`, `Decodable`, `Encodable`, `Encodable`, `Hashable`, `Hashable`



#### init()

creates a empt (0)-value

``` swift
public init() 
```

#### init(_:)

i nitializes its value from a uint64 type

``` swift
public init(_ v:UInt64) 
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

#### init()

creates a empt (0)-value

``` swift
public init() 
```

#### init(_:)

i nitializes its value from a uint64 type

``` swift
public init(_ v:UInt64) 
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
public var doubleValue: Double 
```

#### hexValue

the hex representation staring with '0x'

``` swift
public var hexValue: String 
```

#### uintValue

a unsigned Int representation (if possible)

``` swift
public var uintValue: UInt 
```

#### uint64Value

a unsigned UInt64 representation (if possible)

``` swift
public var uint64Value: UInt64 
```

#### description

String representation as decimals

``` swift
public var description: String 
```

#### doubleValue

returns the value as Double (as close as possible)

``` swift
public var doubleValue: Double 
```

#### hexValue

the hex representation staring with '0x'

``` swift
public var hexValue: String 
```

#### uintValue

a unsigned Int representation (if possible)

``` swift
public var uintValue: UInt 
```

#### uint64Value

a unsigned UInt64 representation (if possible)

``` swift
public var uint64Value: UInt64 
```

#### description

String representation as decimals

``` swift
public var description: String 
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
public func toString(radix: Int  = 10) -> String 
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
public func add(_ val:UInt256) -> UInt256 
```

#### sub(_:)

substracts the given number and returns the difference of both

``` swift
public func sub(_ val:UInt256) -> UInt256 
```

#### mul(_:)

multiplies the current with the given number and returns the product of both

``` swift
public func mul(_ val:UInt256) -> UInt256 
```

#### div(_:)

divides the current number by the given and return the result

``` swift
public func div(_ val:UInt256) -> UInt256 
```

#### mod(_:)

divides the current number by the given and return the rest or module operator

``` swift
public func mod(_ val:UInt256) -> UInt256 
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
public func toString(radix: Int  = 10) -> String 
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
public func add(_ val:UInt256) -> UInt256 
```

#### sub(_:)

substracts the given number and returns the difference of both

``` swift
public func sub(_ val:UInt256) -> UInt256 
```

#### mul(_:)

multiplies the current with the given number and returns the product of both

``` swift
public func mul(_ val:UInt256) -> UInt256 
```

#### div(_:)

divides the current number by the given and return the result

``` swift
public func div(_ val:UInt256) -> UInt256 
```

#### mod(_:)

divides the current number by the given and return the rest or module operator

``` swift
public func mod(_ val:UInt256) -> UInt256 
```
### Utils

a Collection of utility-function.

``` swift
public class Utils 
```



#### cacheClear()

clears the incubed cache (usually found in the .in3-folder)

``` swift
public func cacheClear() throws ->  String 
```

**Example**

``` swift
let result = try in3.utils.cacheClear()
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
public func keccak(data: String) throws ->  String 
```

See [web3\_sha3](https://eth.wiki/json-rpc/API#web3_sha3) for spec.

No proof needed, since the client will execute this locally.

**Example**

``` swift
let result = try in3.utils.keccak(data: "0x1234567890")
// result = "0x3a56b02b60d4990074262f496ac34733f870e1b7815719b46ce155beac5e1a41"
```

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### sha3(data:)

Returns Keccak-256 (not the standardized SHA3-256) of the given data.

``` swift
public func sha3(data: String) throws ->  String 
```

See [web3\_sha3](https://eth.wiki/json-rpc/API#web3_sha3) for spec.

No proof needed, since the client will execute this locally.

**Example**

``` swift
let result = try in3.utils.sha3(data: "0x1234567890")
// result = "0x3a56b02b60d4990074262f496ac34733f870e1b7815719b46ce155beac5e1a41"
```

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### sha256(data:)

Returns sha-256 of the given data.

``` swift
public func sha256(data: String) throws ->  String 
```

No proof needed, since the client will execute this locally.

**Example**

``` swift
let result = try in3.utils.sha256(data: "0x1234567890")
// result = "0x6c450e037e79b76f231a71a22ff40403f7d9b74b15e014e52fe1156d3666c3e6"
```

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### abiEncode(signature:params:)

based on the [ABI-encoding](https:​//solidity.readthedocs.io/en/v0.5.3/abi-spec.html) used by solidity, this function encodes the value given and returns it as hexstring.

``` swift
public func abiEncode(signature: String, params: [AnyObject]) throws ->  String 
```

**Example**

``` swift
let result = try in3.utils.abiEncode(signature: "getBalance(address)", params: ["0x1234567890123456789012345678901234567890"])
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
public func abiDecode(signature: String, data: String, topics: String? = nil) throws ->  [RPCObject] 
```

**Example**

``` swift
let result = try in3.utils.abiDecode(signature: "(address,uint256)", data: "0x00000000000000000000000012345678901234567890123456789012345678900000000000000000000000000000000000000000000000000000000000000005")
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

#### rlpDecode(data:)

rlp decode the data

``` swift
public func rlpDecode(data: String) throws ->  [RPCObject] 
```

**Example**

``` swift
let result = try in3.utils.rlpDecode(data: "0xf83b808508e1409836829c40a86161616135663833353262373034623139653362616338373262343866326537663639356662653681ff82bbbb018080")
// result = 
//          - 0x
//          - "0x08e1409836"
//          - "0x9c40"
//          - "0x61616161356638333532623730346231396533626163383732623438663265376636393566\
//            626536"
//          - "0xff"
//          - "0xbbbb"
//          - "0x01"
//          - 0x
//          - 0x
```

**Parameters**

  - data: input data

**Returns**

a array with the values after decodeing. The result is either a hex-string or an array.

#### checksumAddress(address:useChainId:)

Will convert an upper or lowercase Ethereum address to a checksum address.  (See [EIP55](https:​//github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md) )

``` swift
public func checksumAddress(address: String, useChainId: Bool? = nil) throws ->  String 
```

**Example**

``` swift
let result = try in3.utils.checksumAddress(address: "0x1fe2e9bf29aa1938859af64c413361227d04059a", useChainId: false)
// result = "0x1Fe2E9bf29aa1938859Af64C413361227d04059a"
```

**Parameters**

  - address: the address to convert.
  - useChainId: if true, the chainId is integrated as well (See [EIP1191](https://github.com/ethereum/EIPs/issues/1121) )

**Returns**

the address-string using the upper/lowercase hex characters.

#### parseTxUrl(url:)

parse a ethereum-url based on EIP 681 (https:​//eips.ethereum.org/EIPS/eip-681)

``` swift
public func parseTxUrl(url: String) -> Future<TxInput> 
```

**Example**

``` swift
in3.utils.parseTxUrl(url: "ethereum:0x89205a3a3b2a69de6dbf7f01ed13b2108b2c43e7/transfer?address=0x8e23ee67d1332ad560396262c48ffbb01f93d052&uint256=1") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          to: "0x89205a3a3b2a69de6dbf7f01ed13b2108b2c43e7"
//          fn_sig: transfer(address,uint256)
//          fn_args:
//            - "0x8e23ee67d1332ad560396262c48ffbb01f93d052"
//            - 1
     }
}
 
```

**Parameters**

  - url: the url with the tx-params

#### toWei(value:unit:)

converts the given value into wei.

``` swift
public func toWei(value: String, unit: String? = "eth") throws ->  UInt256 
```

**Example**

``` swift
let result = try in3.utils.toWei(value: "20.0009123", unit: "eth")
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
public func fromWei(value: UInt256, unit: String, digits: Int? = nil) throws ->  Double 
```

**Example**

``` swift
let result = try in3.utils.fromWei(value: "0x234324abadefdef", unit: "eth", digits: 3)
// result = 0.158
```

**Parameters**

  - value: the value in wei
  - unit: the unit of the target value, which must be one of `wei`, `kwei`,  `Kwei`,  `babbage`,  `femtoether`,  `mwei`,  `Mwei`,  `lovelace`,  `picoether`,  `gwei`,  `Gwei`,  `shannon`,  `nanoether`,  `nano`,  `szabo`,  `microether`,  `micro`,  `finney`,  `milliether`,  `milli`,  `ether`,  `eth`,  `kether`,  `grand`,  `mether`,  `gether` or  `tether`
  - digits: fix number of digits after the comma. If left out, only as many as needed will be included.

**Returns**

the value as string.

#### calcDeployAddress(sender:nonce:)

calculates the address of a contract about to deploy. The address depends on the senders nonce.

``` swift
public func calcDeployAddress(sender: String, nonce: UInt64? = nil) -> Future<String> 
```

**Example**

``` swift
in3.utils.calcDeployAddress(sender: "0x5a0b54d5dc17e0aadc383d2db43b0a0d3e029c4c", nonce: 6054986) .observe(using: {
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

#### getNetworkId()

Returns the current network id.

``` swift
public func getNetworkId() -> Future<UInt64> 
```

**Returns**

the network id

#### cacheClear()

clears the incubed cache (usually found in the .in3-folder)

``` swift
public func cacheClear() throws ->  String 
```

**Example**

``` swift
let result = try in3.utils.cacheClear()
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
public func keccak(data: String) throws ->  String 
```

See [web3\_sha3](https://eth.wiki/json-rpc/API#web3_sha3) for spec.

No proof needed, since the client will execute this locally.

**Example**

``` swift
let result = try in3.utils.keccak(data: "0x1234567890")
// result = "0x3a56b02b60d4990074262f496ac34733f870e1b7815719b46ce155beac5e1a41"
```

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### sha3(data:)

Returns Keccak-256 (not the standardized SHA3-256) of the given data.

``` swift
public func sha3(data: String) throws ->  String 
```

See [web3\_sha3](https://eth.wiki/json-rpc/API#web3_sha3) for spec.

No proof needed, since the client will execute this locally.

**Example**

``` swift
let result = try in3.utils.sha3(data: "0x1234567890")
// result = "0x3a56b02b60d4990074262f496ac34733f870e1b7815719b46ce155beac5e1a41"
```

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### sha256(data:)

Returns sha-256 of the given data.

``` swift
public func sha256(data: String) throws ->  String 
```

No proof needed, since the client will execute this locally.

**Example**

``` swift
let result = try in3.utils.sha256(data: "0x1234567890")
// result = "0x6c450e037e79b76f231a71a22ff40403f7d9b74b15e014e52fe1156d3666c3e6"
```

**Parameters**

  - data: data to hash

**Returns**

the 32byte hash of the data

#### abiEncode(signature:params:)

based on the [ABI-encoding](https:​//solidity.readthedocs.io/en/v0.5.3/abi-spec.html) used by solidity, this function encodes the value given and returns it as hexstring.

``` swift
public func abiEncode(signature: String, params: [AnyObject]) throws ->  String 
```

**Example**

``` swift
let result = try in3.utils.abiEncode(signature: "getBalance(address)", params: ["0x1234567890123456789012345678901234567890"])
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
public func abiDecode(signature: String, data: String, topics: String? = nil) throws ->  [RPCObject] 
```

**Example**

``` swift
let result = try in3.utils.abiDecode(signature: "(address,uint256)", data: "0x00000000000000000000000012345678901234567890123456789012345678900000000000000000000000000000000000000000000000000000000000000005")
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
public func checksumAddress(address: String, useChainId: Bool? = nil) throws ->  String 
```

**Example**

``` swift
let result = try in3.utils.checksumAddress(address: "0x1fe2e9bf29aa1938859af64c413361227d04059a", useChainId: false)
// result = "0x1Fe2E9bf29aa1938859Af64C413361227d04059a"
```

**Parameters**

  - address: the address to convert.
  - useChainId: if true, the chainId is integrated as well (See [EIP1191](https://github.com/ethereum/EIPs/issues/1121) )

**Returns**

the address-string using the upper/lowercase hex characters.

#### parseTxUrl(url:)

parse a ethereum-url based on EIP 681 (https:​//eips.ethereum.org/EIPS/eip-681)

``` swift
public func parseTxUrl(url: String) -> Future<TxInput> 
```

**Example**

``` swift
in3.utils.parseTxUrl(url: "ethereum:0x89205a3a3b2a69de6dbf7f01ed13b2108b2c43e7/transfer?address=0x8e23ee67d1332ad560396262c48ffbb01f93d052&uint256=1") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          to: "0x89205a3a3b2a69de6dbf7f01ed13b2108b2c43e7"
//          fn_sig: transfer(address,uint256)
//          fn_args:
//            - "0x8e23ee67d1332ad560396262c48ffbb01f93d052"
//            - 1
     }
}
 
```

**Parameters**

  - url: the url with the tx-params

#### toWei(value:unit:)

converts the given value into wei.

``` swift
public func toWei(value: String, unit: String? = "eth") throws ->  String 
```

**Example**

``` swift
let result = try in3.utils.toWei(value: "20.0009123", unit: "eth")
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
public func fromWei(value: UInt256, unit: String, digits: Int? = nil) throws ->  Double 
```

**Example**

``` swift
let result = try in3.utils.fromWei(value: "0x234324abadefdef", unit: "eth", digits: 3)
// result = 0.158
```

**Parameters**

  - value: the value in wei
  - unit: the unit of the target value, which must be one of `wei`, `kwei`,  `Kwei`,  `babbage`,  `femtoether`,  `mwei`,  `Mwei`,  `lovelace`,  `picoether`,  `gwei`,  `Gwei`,  `shannon`,  `nanoether`,  `nano`,  `szabo`,  `microether`,  `micro`,  `finney`,  `milliether`,  `milli`,  `ether`,  `eth`,  `kether`,  `grand`,  `mether`,  `gether` or  `tether`
  - digits: fix number of digits after the comma. If left out, only as many as needed will be included.

**Returns**

the value as string.

#### calcDeployAddress(sender:nonce:)

calculates the address of a contract about to deploy. The address depends on the senders nonce.

``` swift
public func calcDeployAddress(sender: String, nonce: UInt64? = nil) -> Future<String> 
```

**Example**

``` swift
in3.utils.calcDeployAddress(sender: "0x5a0b54d5dc17e0aadc383d2db43b0a0d3e029c4c", nonce: 6054986) .observe(using: {
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

#### getNetworkId()

Returns the current network id.

``` swift
public func getNetworkId() -> Future<UInt64> 
```

**Returns**

the network id
### Vault

All Vault-services are accessable through this module. The vault services are hosted in a high security data center storing critical personal data and credentials like private keys.
For more Details, see the internal [documentation](https:​//backend-development.git-pages.slock.it/iamo-vault/documentation/apispec.html)

``` swift
public class Vault 
```



#### addUser()

adds a user account in the vault

``` swift
public func addUser() -> Future<AddUser> 
```

**Example**

``` swift
sdk.vault.addUser() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          signature:
//            timestamp: 2021-08-31T16:47
//            value: "0x1688f0b900000000000000000000000005876b8a53f8b9d40268ebcad8fc7c78c1439\
//              33400000000000000000"
//          status: sent
     }
}
 
```

**Returns**

The user creation result

#### getUser()

retrieves a user account in the vault

``` swift
public func getUser() -> Future<User> 
```

**Returns**

The stored user information

#### editUser(email:phone:)

updates a user account in the vault

``` swift
public func editUser(email: String, phone: String? = nil) -> Future<EditUser> 
```

**Example**

``` swift
sdk.vault.editUser(email: "test@dummy.com", phone: "+49 172 1234567890") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          signature:
//            timestamp: 2021-08-31T16:47
//            value: "0x1688f0b900000000000000000000000005876b8a53f8b9d40268ebcad8fc7c78c1439\
//              33400000000000000000"
//          status: sent
     }
}
 
```

**Parameters**

  - email: the user email address
  - phone: the phone number which will be used for 2fa messages

**Returns**

The user update result

#### addUserDevice(name:type:)

Register primary user device

``` swift
public func addUserDevice(name: String, type: String) -> Future<AddUserDevice> 
```

**Example**

``` swift
sdk.vault.addUserDevice(name: "My Personal Phone", type: "Android Phone") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          signature:
//            timestamp: 2021-08-31T16:47
//            value: "0x1688f0b900000000000000000000000005876b8a53f8b9d40268ebcad8fc7c78c1439\
//              33400000000000000000"
//          status: sent
     }
}
 
```

**Parameters**

  - name: Device name
  - type: Device type

**Returns**

Device registration result

#### getUserDevices()

Returns a list of user devices

``` swift
public func getUserDevices() -> Future<UserDevices> 
```

**Example**

``` swift
sdk.vault.getUserDevices() .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          signature:
//            timestamp: 2021-08-31T16:47
//            value: "0x1688f0b900000000000000000000000005876b8a53f8b9d40268ebcad8fc7c78c1439\
//              33400000000000000000"
//          status: sent
//          data: '[{"device_id":"b858ae5a-18e5-4e5d-956d-0bcb066e7fbe","is-current":true,metadata":{"name":"My
//            Phone","type":"Android Phone"}}]'
     }
}
 
```

**Returns**

Device listing result
### Wallet

represents a wallet

``` swift
public class Wallet 
```



#### address

``` swift
public var address: String
```



#### exec(tx:exec:)

executes or prepares a transaction for a wallet.

``` swift
public func exec(tx: TxData, exec: String? = "send") -> Future<TxData> 
```

This is the main function to execute or send a transaction.
The resulting data can be used as input data again. This allows to collect signatures or simply split the preparing of a transaction and the sending.
But in most case simply using the exec-level `receipt` can do it all in one step and return the receipt.

This is an example on how to collect signatures:

``` sh
### sign the transaction with one key and store the tx_data in a file
equs send -to 0x... -value 1.2eth -pk pk1.json --default_exec=prepare > tx.json
 
### this file could now be send to other signers, where they can sign with their keys
equs wallet_exec ./tx.json -pk pk2.json --default_exec=prepare > tx_signed_both.json
 
### now anybody can send the tx and wait for the receipt
equs wallet_exec ./tx_signed_both.json -pk gas_relay.json --default_exec=receipt | jq
```

**Example**

``` swift
sdk.wallets.getWallet(address: account).exec(tx: TxData(input: {"to":"0x9d646b325787c6d7d612eb37915ca3023eea4dac","value":"0x2386f26fc10000"}), exec: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          input:
//            to: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//            sender: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//            value: "0x2386f26fc10000"
//            data: 0x
//            gas: "0x5208"
//            gasPrice: "0x3b9aca0a"
//            nonce: "0x25"
//            wallet: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//          pre_unsigned: "0xea25843b9aca0a825208949d646b325787c6d7d612eb37915ca3023eea4dac\
//            872386f26fc1000080048080"
//          ms:
//            wallet: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//            tx_hash: "0x7b618e20585149583ca4e365b85bc39617a2d9cef58d02999db1e87e44a03073"
//            nonce: 0
//            threshold: 1
//            sign_count: 1
//            signatures:
//              - owner: "0x3e8428a44f0a7e3c1f8e00264da96f22f1dec5b9"
//                roles: 7
//                signature: 0x28983284f32d6...a1f3bf42cf41b397dadd2a6a3d03fe1b
//            allSignatures: 0x28983284f32d...397dadd2a6a3d03fe1b
//            missing: []
//            tx_data: 0x6a761202000000...00000000000
//            tx_to: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//            tx_gas: 321000
//          unsigned: 0xf9020a...0000000000000048080
//          signed: 0xf9024a25...e9016831e8257
//          transactionHash: "0x0643119cccc0ce181eeb45e789f558865c5c85ac3e6f9f0045ce10614522d128"
//          receipt:
//            blockHash: "0x7bac5dc70ff52a04c693bd57a0f18b2a5d3224e192cc7cf849f75b528f90738f"
//            blockNumber: "0x888132"
//            contractAddress: null
//            cumulativeGasUsed: "0x36dd8f"
//            effectiveGasPrice: "0x3b9aca0a"
//            from: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//            gasUsed: "0x1447d"
//            logs: []
//            logsBloom: 0x0000000000...0000000
//            status: "0x0"
//            to: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//            transactionHash: "0x0643119cccc0ce181eeb45e789f558865c5c85ac3e6f9f0045ce10614522d128"
//            transactionIndex: "0x14"
//            type: "0x0"
//          state: receipt
     }
}
 
```

**Parameters**

  - tx: the description of the transaction. As minimum only the inputs are needed.     /// But in order to sign with multiple parties the definition can be passed to combined multiple signatures    ///
  - exec: the execution level when sending transactions trough the wallet.    ///     - `prepare` - the transaction is not signed, but for the multisig signatures all useable signatures are collected.    ///     - `sign` - the raw transaction is signed    ///     - `send` - the transaction is send and the transactionHash is added    ///     - `receipt` - the function will wait until the receipt has been found     ///

**Returns**

the transaction-state

#### getBalance(token:)

returns the balance for the specified account or wallet. If the wallet support l1 and l2 layer, it will return the sum of both.

``` swift
public func getBalance(token: String? = "ETH") -> Future<UInt256> 
```

**Example**

``` swift
sdk.wallets.getWallet(address: account).getBalance(token: "ETH") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 78187493520
     }
}
 
```

**Parameters**

  - token: The name or address of the token or NULL (or "ETH") if eth-balance is requested.

**Returns**

the current balance

#### apply(new_config:exec:)

applies the changes of the specified wallet-config.

``` swift
public func apply(new_config: MsDef, exec: String? = "send") -> Future<WalletUpdate> 
```

This function will use the wallet config passed as first argument and compare it with wallet in the config. For each change a transaction willbe created.
If there are more than one transaction they will be bundled to one transaction useing the multisend-contract ( which must be configured in the wallet\_deploy-section).
This method can be used to update almost any property including updating the master\_copy.

  - Parameter new\_config : The config of the changes of the wallet.

**Example**

``` swift
sdk.wallets.getWallet(address: account).apply(new_config: MsDef(address: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899", threshold: 1, type: "l1l2", owners: [{"roles":7,"address":"0x3e8428a44f0a7e3c1f8e00264da96f22f1dec5b9"},{"roles":6,"address":"0xbca6f7f77283a78640b09fe6d44b74717b066557"}], master_copy: "0xc73248bb521c3331e4efedbb0560e806302024fb", master_copy_custody: "0x937c53cad1619a996645165129620ef2853c76b0", custody: "0xb0d4d3b2fbf42770e8e0cf496c26c6b2b496e962"), exec: "prepare") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          tx:
//            input:
//              to: "0xd473ac22bf22ee68cb8d3ca529bc60864613e0ed"
//              sender: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//              value: 0x
//              data: 0x8d80ff0a000000...00000000000
//              gas: "0x0f4240"
//              gasPrice: "0x3b9aca08"
//              nonce: "0x3d"
//              wallet: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//            pre_unsigned: 0xf901aa3d843b9aca0...00000048080
//            ms:
//              wallet: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//              tx_hash: "0x459ab0b823357161c8c27588f3015ecd2704205549c0470cf8e20c8af284dc2f"
//              nonce: 15
//              threshold: 1
//              sign_count: 1
//              signatures:
//                - owner: "0x3e8428a44f0a7e3c1f8e00264da96f22f1dec5b9"
//                  roles: 7
//                  signature: "0x07988e8369262144eece4f26554e86ada0e36dd5b88bb86ff716421f1542fc8c3\
//                    c3fcf39a15fc9acb7a298f041bc557868b262f6e6312a8ec6c5b2570c596dac1c"
//              allSignatures: "0x07988e8369262144eece4f26554e86ada0e36dd5b88bb86ff716421f1542f\
//                c8c3c3fcf39a15fc9acb7a298f041bc557868b262f6e6312a8ec6c5b2570c596dac1c"
//              missing: []
//              tx_data: 0x6a76120200000...0000000
//              tx_to: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//              tx_gas: 1300000
//            unsigned: 0xf903aa3d843...0000000000000000048080
//            state: unsigned
//          wallet:
//            address: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//            threshold: 1
//            type: l1l2
//            signer: "0x0000000000000000000000000000000000000000000000000000000000000000"
//            owners:
//              - roles: 7
//                address: "0x3e8428a44f0a7e3c1f8e00264da96f22f1dec5b9"
//              - roles: 6
//                address: "0xbca6f7f77283a78640b09fe6d44b74717b066557"
//            creator: "0xaa8c54c65c14f132804f0809bdbef19970673709"
//            master_copy: "0xc73248bb521c3331e4efedbb0560e806302024fb"
//            master_copy_custody: "0x937c53cad1619a996645165129620ef2853c76b0"
//            create_module: "0x846a192315882ca369125f82e64e368858663898"
//            custody: "0xb0d4d3b2fbf42770e8e0cf496c26c6b2b496e962"
//            safetype: IAMO Safe
//            deploy_block: "0x883bca"
     }
}
 
```

**Parameters**

  - exec: the execution level when sending transactions trough the wallet.    ///     - `prepare` - the transaction is not signed, but for the multisig signatures all useable signatures are collected.    ///     - `sign` - the raw transaction is signed    ///     - `send` - the transaction is send and the transactionHash is added    ///     - `receipt` - the function will wait until the receipt has been found     ///

**Returns**

the updated config.

#### getConfig()

returns the wallet from the current configuration.

``` swift
public func getConfig() throws ->  MsDef 
```

**Returns**

the wallet-configuration

#### getOwnersForRole(role:)

returns an array of owners-address with the specified role

``` swift
public func getOwnersForRole(role: Int) -> Future<String> 
```

**Parameters**

  - role: the role of the owner as bitmask

#### getHistory(force_update:only_new:)

reads the history and all events for the wallet.

``` swift
public func getHistory(force_update: Bool? = nil, only_new: Bool? = nil) -> Future<[WalletTx]> 
```

  - Parameter force\_update : if true the history will also be update otherwise it will be taken from the cache and only created if it does not exist yet

  - Parameter only\_new : if true, only new events will be returned

**Example**

``` swift
sdk.wallets.getWallet(address: account).getHistory(force_update: false, only_new: false) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          - tx_hash: "0xeecc2675960daec8dcfa2f4bc77f4990d251f3467a498b458ea6c1010ae7b395"
//            block: 8928202
//            layer: eth-4
//            timestamp: 1626161216
//            events:
//              - log_index: 44
//                type: ProxyCreation
//                address: "0xb0d4d3b2fbf42770e8e0cf496c26c6b2b496e962"
//              - log_index: 45
//                type: EnabledModule
//                address: "0xb0d4d3b2fbf42770e8e0cf496c26c6b2b496e962"
//          - tx_hash: "0x5fd643202b943112e799ca60305adbafe70e7f512952eae6dd4c5b00c2f136e5"
//            block: 8946267
//            layer: eth-4
//            timestamp: 1626432263
//            events:
//              - log_index: 27
//                type: ExecutionFailure
//                tx_hash: "0xa27d76a7faeb9b1f7e5caf1cd7cf9abbb73b17a447bac8fb6cec694a1009df0f"
//                gas: 0
//          - tx_hash: "0xb73aab562d8a689b3ccdf904378a95be7e515a2fb17f1b7aec53bce50349959a"
//            block: 8946321
//            layer: eth-4
//            timestamp: 1626433073
//            events:
//              - log_index: 19
//                type: Transfer
//                token: "0x0000000000000000000000000000000000000000"
//                tx_hash: "0x722bf0999e08d45186bbb91d3cb2a80ad453e3fe49e6555fa8641dde7d3333bb"
//                to: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//                amount: "0x2386f26fc10000"
//                from: "0xe0d93065b8e4eb40336c3679b2751c9ddf33d899"
//              - log_index: 20
//                type: ExecutionSuccess
//                tx_hash: "0x722bf0999e08d45186bbb91d3cb2a80ad453e3fe49e6555fa8641dde7d3333bb"
//                gas: 0
     }
}
 
```

**Returns**

a array with all events since the creation of the wallet.
### Wallets

Wallet Management.

``` swift
public class Wallets 
```

This Module contains a abstraction layer for different kind of wallets, allowing the developer
to send transactions in the same way independend of the configured wallet.
This Module will manage one or more wallet-configurations.



#### l1

the L1Wallets API

``` swift
public var l1 : L1Wallets 
```

#### zk

the ZkWallets API

``` swift
public var zk : ZkWallets 
```



#### getAllWalletDefs()

returns all wallets from the current configuration.

``` swift
public func getAllWalletDefs() throws ->  [MsDef] 
```

**Returns**

the wallet-configuration

#### getWalletDef(account:)

returns the wallet from the current configuration.

``` swift
public func getWalletDef(account: String) throws ->  MsDef? 
```

**Parameters**

  - account: the address of the wallet

**Returns**

the wallet-configuration

#### getAllWalletsAsHex()

returns all wallets as bytes from the current configuration.

``` swift
public func getAllWalletsAsHex() throws ->  [String] 
```

**Returns**

the wallet-configuration

#### getWalletAsHex(account:)

returns the wallet as bytes from the current configuration.

``` swift
public func getWalletAsHex(account: String) throws ->  String? 
```

**Parameters**

  - account: the address of the wallet

**Returns**

the wallet-configuration

#### add(wallet:)

adds a wallet-configuration to the settings. This can be done by calling this function or by using `configure({wallets:​[...]})`. If the wallet already exists, the properties are merged.

``` swift
public func add(wallet: MsDef) throws ->  MsDef 
```

**Parameters**

  - wallet: the config of the wallet

**Returns**

the wallet - definition after merge.

#### getWallet(address:)

Returns a Wallet-Instance to access and send transactions.

``` swift
public func getWallet(address: String) -> Wallet 
```

**Parameters**

  - address: the address of the wallet

#### addWallet(conf:)

adds (or updates) a wallet with the given config and returns the wallet-instance.

``` swift
public func addWallet(conf: MsDef) throws -> Wallet  
```

**Parameters**

  - address: the address of the wallet
### ZkWallets

wallet- function based on the layer2 Wallet for zksync.

``` swift
public class ZkWallets 
```



#### createWalletDef(threshold:owners:)

creates a new Layer 2 Wallet.

``` swift
public func createWalletDef(threshold: Int, owners: [String]) -> Future<ZkWalletDefinitionResult> 
```

This wallet is created directly in Layer 2 (Zksync), but features a full multisig wallet. It also holds the option to deploy contracts to layer 1 if needed. This is the case if,

  - the zksync operator stops its service or censors your tx

  - if the approver service stop running or rejects valid requests

In this case a deployment to Layer 1 may cost some fees, but ensures full access to all funds.

In order to use this the SDK needs to have those properties in `zk_wallet` configured:

  - `zksync.musig_urls` - the url of the approving service

  - `zksync.sync_key` - the seed for the signing key

  - `zksync.create_proof_method` - which creates the proof needed. This should be `zk_wallet_create_signatures` for most cases.

**Example**

``` swift
sdk.wallets.zk.createWalletDef(threshold: 1, owners: ["IA:0x8a91dc2d28b689474298d91899f0c1baf62cb85b","A:0x5a876b8a53f8b9d40268ebcad8fc7c78c1439334"]) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          account: "0x0e8b4fe889b126b9b502b244c9130912510f014f"
//          deploy_tx:
//            data: "0x1688f0b900000000000000000000000005876b8a53f8b9d40268ebcad8fc7c78c14393\
//              340000000000000000000000000000000000000000000000000000000000000060000000000\
//              000000000000000865a7e441ed840fa3336e756b9ad4ba1d65a384c00000000000000000000\
//              000000000000000000000000000000000000000002046efc73ce00000000000000000000000\
//              000000000000000000000000000000000000001200000000000000000000000000000000000\
//              000000000000000000000000000180000000000000000000000000000000000000000000000\
//              000000000000000000100000000000000000000000000000000000000000000000000000000\
//              0000000000000000000000000000000000000000000000000000000000000000000001e0000\
//              000000000000000000000000000000000000000000000000000000000000000000000000000\
//              000000000000000000000000000000000000000000000000000000000000000000000000000\
//              000000000000000000000000000000000000000000000000000000000000000000000000000\
//              000000000000000000000000000000000000000000000000000000000000000000000000000\
//              000000000000000020000000000000000000000008a91dc2d28b689474298d91899f0c1baf6\
//              2cb85b0000000000000000000000005a876b8a53f8b9d40268ebcad8fc7c78c143933400000\
//              000000000000000000000000000000000000000000000000000000000020000000000000000\
//              000000000000000000000000000000000000000000000006000000000000000000000000000\
//              000000000000000000000000000000000000400000000000000000000000000000000000000\
//              000000000000000000000000000000000000000000000000000000000000000000000000000\
//              0000000"
//            to: "0x29a988ca607d8ec6fae32b724d5dbfd3132d708e"
//          create2:
//            creator: "0x29a988ca607d8ec6fae32b724d5dbfd3132d708e"
//            saltarg: "0xfc2bb08be9fef30b6c40afc031bf161e969e3a1afdc04f91a89880dc4645b9c0"
//            codehash: "0x1297c8f6fc77b41b23b2e8c9b51d7c6482e3846444eccecea8426e97e04bb512"
//          musig_pub_keys: "0xf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0\
//            bf13e8f753725ff83d95135257cc4c4df2baa9a962340e134ca8d5520fedb9afab9a"
//          musig_urls:
//            - null
//            - http://localhost:8099
//          wallet:
//            address: "0x0e8b4fe889b126b9b502b244c9130912510f014f"
//            threshold: 1
//            signer: "0xf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13"
//            owners:
//              - roles: 6
//                address: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//              - roles: 4
//                address: "0x5a876b8a53f8b9d40268ebcad8fc7c78c1439334"
     }
}
 
```

**Parameters**

  - threshold: the minimal number of signatures needed for the multisig to approve a transaction. It must be at least one and less or equal to the number of owners.
  - owners: array of owners.     /// Each owner is described by either the address ( with role as approver) or `ROLE:ADDRESS`.     /// Role can be either     /// - `R` - Recovery : this owner can challenge other owners in order to recover, but not approve or initiate a transaction    /// - `A` - Approver: a signature from this owner counts towards the threshhold, but this role alone can not initiate a transaction.    /// - `I` - Initiator: is allowed to initiate a transaction.    ///     /// you can combine multiple Role like `IA:0xab35d7cb3...`     ///

**Returns**

a collection of relevant data you may need for the new wallet

#### storeLayer2WalletConf(wallet:proof:)

updates a wallet configuration, which allows the owner to add or replace keys. Each change needs to be signed by enough owners to reach the threshold.
Those signatures are signing the hashed wallet-configuration, which is build:​

``` swift
public func storeLayer2WalletConf(wallet: ZkWallet, proof: [String]) -> Future<Bool> 
```

  - `address` account\_address (20 bytes)

  - `bytes32` public key signer (32 bytes)

  - `uint32` threshold ( bigendian )

  - for each owner:
    
      - `uint8` role
      - `address` owner address

**Example**

``` swift
sdk.wallets.zk.storeLayer2WalletConf(wallet: ZkWallet(address: "0x0e8b4fe889b126b9b502b244c9130912510f014f", threshold: 1, signer: "0xf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13", owners: [{"roles":6,"address":"0x8a91dc2d28b689474298d91899f0c1baf62cb85b"},{"roles":4,"address":"0x5a876b8a53f8b9d40268ebcad8fc7c78c1439334"}]), proof: ["0xabf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13f7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13"]) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = true
     }
}
 
```

**Parameters**

  - wallet: the new wallet-config.
  - proof: the proof or the signatures of the current owners reaching the threshold. The datastructure depends on the proof\_method, but per default is the result of `zk_wallet_create_signatures`. The signatures need to sign the new structure.

**Returns**

the success confirmation or a error is thrown.

#### walletCreateSignatures(message:account:)

signs a message by as many owners as possible to reach the threshold.

``` swift
public func walletCreateSignatures(message: String, account: String) -> Future<[String]> 
```

**Example**

``` swift
sdk.wallets.zk.walletCreateSignatures(message: "0xf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13e8f753725ff83d95135257cc4c4df2baa9a962340e134ca8d5520fedb9afab9a", account: "0x0e8b4fe889b126b9b502b244c9130912510f014f") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          - "0xabf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13f7f229e7\
//            5842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13"
     }
}
 
```

**Parameters**

  - message: the message to sign
  - account: the account of the wallet

**Returns**

a array of signatures from the owner

#### walletVerifySignatures(message:account:signer:signatures:)

verifies signatures and checks if the threshold is reached.

``` swift
public func walletVerifySignatures(message: String, account: String, signer: String, signatures: [String]) -> Future<Bool> 
```

**Example**

``` swift
sdk.wallets.zk.walletVerifySignatures(message: "0xf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13e8f753725ff83d95135257cc4c4df2baa9a962340e134ca8d5520fedb9afab9a", account: "0x0e8b4fe889b126b9b502b244c9130912510f014f", signer: "0xf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13", signatures: ["0xabf7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13f7f229e75842cbc0225c6ded105349f582d65df8a84fc86dd8f4859157f0bf13"]) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = true
     }
}
 
```

**Parameters**

  - message: the message to sign
  - account: the account of the wallet
  - signer: the public key of the signer
  - signatures: the signatures of the owner

**Returns**

returns true or an error if the signatures are not enough or invalid.
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
public func contractAddress() -> Future<ZkSyncContractDefinition> 
```

**Example**

``` swift
in3.zksync.contractAddress() .observe(using: {
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
public func tokens() -> Future<[String:ZkSyncToken]> 
```

**Example**

``` swift
in3.zksync.tokens() .observe(using: {
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
public func accountInfo(address: String? = nil) -> Future<ZkSyncAccountInfo> 
```

**Example**

``` swift
in3.zksync.accountInfo() .observe(using: {
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
public func txInfo(tx: String) -> Future<ZkSyncTxInfo> 
```

**Example**

``` swift
in3.zksync.txInfo(tx: "sync-tx:e41d2489571d322189246dafa5ebde1f4699f498000000000000000000000000") .observe(using: {
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

#### txData(tx:)

returns the full input data of a transaction. In order to use this, the `rest_api` needs to be set in the config.

``` swift
public func txData(tx: String) -> Future<ZkSyncTxData> 
```

**Example**

``` swift
in3.zksync.txData(tx: "0xc06ddc1c0914e8f9ca4d5bc98f609f7d758f6de2733fdcb8e3ec") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          tx_type: Transfer
//          from: "0x627d8e8c1a663cfea17432ec6dbbd3cc2c8a1f9a"
//          to: "0x03e2c10b74a260f46ab5cf881938c5888a6142df"
//          token: 1
//          amount: "5000000"
//          fee: "2190"
//          block_number: 29588
//          nonce: 20
//          created_at: 2021-06-01T10:32:16.248564
//          fail_reason: null
//          tx:
//            to: "0x03e2c10b74a260f46ab5cf881938c5888a6142df"
//            fee: "2190"
//            from: "0x627d8e8c1a663cfea17432ec6dbbd3cc2c8a1f9a"
//            type: Transfer
//            nonce: 20
//            token: 1
//            amount: "5000000"
//            accountId: 161578
//            signature:
//              pubKey: 91b533af2c430d7ad48db3ccc4ccb54befaff48307180c9a19a369099331d0a6
//              signature: d17637db375a7a587474c8fee519fd7520f6ef98e1370e7a13d5de8176a6d0a22309e24a19dae50dad94ac9634ab3398427cf67abe8408e6c965c6b350b80c02
//            validFrom: 0
//            validUntil: 4294967295
     }
}
 
```

**Parameters**

  - tx: the txHash of the send tx

**Returns**

the data and state of the requested tx.

#### accountHistory(account:ref:limit:)

returns the history of transaction for a given account.

``` swift
public func accountHistory(account: String, ref: String? = nil, limit: Int? = nil) -> Future<[ZksyncZkHistory]> 
```

**Example**

``` swift
in3.zksync.accountHistory(account: "0x9df215737e137acddd0ad99e32f9a6b980ea526d") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          - tx_id: 29411,1
//            hash: sync-tx:e83b1b982b4d8a08a21f87717e85a268e3b3a5305bdf5efc465e7fd8f0ad5335
//            eth_block: null
//            pq_id: null
//            tx:
//              to: "0xb7b2af693a2362c5c7575841ca6eb72ad2aed77f"
//              fee: "11060000000000"
//              from: "0x9df215737e137acddd0ad99e32f9a6b980ea526d"
//              type: Transfer
//              nonce: 1
//              token: ETH
//              amount: "1000000000000000"
//              accountId: 161418
//              signature:
//                pubKey: 74835ee6dd9009b67fd4e4aef4a6f63ee2a597ced5e59f33b019905d1df70d91
//                signature: 407314ebce8ce0217b41a6cf992c7359645215c35afbdf7e18e76c957a14ed20135b7e8e5ca24fb132640141c0b3168b3939571e2363e41639e18b1637f26d02
//              validFrom: 0
//              validUntil: 4294967295
//            success: true
//            fail_reason: null
//            commited: true
//            verified: true
//            created_at: 2021-05-31T11:54:56.248569Z
//          - tx_id: 29376,10
//            hash: sync-tx:5f92999f7bbc5d84fe0d34ebe8b7a0c38f977caece844686d3007bc48e5944e0
//            eth_block: null
//            pq_id: null
//            tx:
//              to: "0xc98fc74a085cd7ecd91d9e8d860a18ef6769d873"
//              fee: "10450000000000"
//              from: "0xb7b2af693a2362c5c7575841ca6eb72ad2aed77f"
//              type: Transfer
//              nonce: 1
//              token: ETH
//              amount: "10000000000000000"
//              accountId: 161391
//              signature:
//                pubKey: 06cce677912252a9eb87090b795e5bd84a079cb398dfec7f6a6645ee456dc721
//                signature: ef83b1519a737107798aa5740998a515c406510b61f176fbbac6f703231968a563551f74f37bf96c2220fd18a68aca128a155b5083333a13cfbbd348c0a75003
//              validFrom: 0
//              validUntil: 4294967295
//            success: true
//            fail_reason: null
//            commited: true
//            verified: true
//            created_at: 2021-05-31T08:11:17.250144Z
//          - tx_id: 29376,5
//            hash: sync-tx:78550bbcaefdfd4cc4275bd1a0168dd73efb1953bb17a9689381fea6729c924e
//            eth_block: null
//            pq_id: null
//            tx:
//              fee: "37500000000000"
//              type: ChangePubKey
//              nonce: 0
//              account: "0xb7b2af693a2362c5c7575841ca6eb72ad2aed77f"
//              feeToken: 0
//              accountId: 161391
//              newPkHash: sync:1ae5a093f285ddd23b54bea2780ef4e9a4e348ea
//              signature:
//                pubKey: 06cce677912252a9eb87090b795e5bd84a079cb398dfec7f6a6645ee456dc721
//                signature: 27f42a850de4dcc6527fea0a9baa5991dabf3c2ce30dae5a6112f03cf614da03bdc2ef7ac107337d17f9e4047e5b18b3e4c46acb6af41f8cfbb2fce43247d500
//              validFrom: 0
//              validUntil: 4294967295
//              ethAuthData:
//                type: CREATE2
//                saltArg: "0xd32a7ec6157d2433c9ae7f4fdc35dfac9bba6f92831d1ca20b09d04d039d8dd7"
//                codeHash: "0x96657bf6bdcbffce06518530907d2d729e4659ad3bc7b5cc1f5c5567d964272c"
//                creatorAddress: "0xaa8c54c65c14f132804f0809bdbef19970673709"
//              ethSignature: null
//            success: true
//            fail_reason: null
//            commited: true
//            verified: true
//            created_at: 2021-05-31T08:09:11.249472Z
//          - tx_id: 29376,0
//            hash: "0xc63566212c1569a0e64b255a07320483ed8476cd36b54aa37d3bd6f93b70f7f8"
//            eth_block: 8680840
//            pq_id: 57181
//            tx:
//              type: Deposit
//              account_id: 161391
//              priority_op:
//                to: "0xb7b2af693a2362c5c7575841ca6eb72ad2aed77f"
//                from: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//                token: ETH
//                amount: "500000000000000000"
//            success: true
//            fail_reason: null
//            commited: true
//            verified: true
//            created_at: 2021-05-31T08:07:31.237817Z
     }
}
 
```

**Parameters**

  - account: the address of the account
  - ref: the reference or start. this could be a tx\_id prefixed with `<` or `>`for newer or older than the specified  tx or `pending` returning all pending tx.
  - limit: the max number of entries to return

**Returns**

the data and state of the requested tx.

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

**Example**

``` swift
in3.zksync.setKey(token: "eth") .observe(using: {
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
public func pubkeyhash(pubKey: String? = nil) throws ->  String 
```

**Example**

``` swift
let result = try in3.zksync.pubkeyhash()
// result = sync:4dcd9bb4463121470c7232efb9ff23ec21398e58
```

**Parameters**

  - pubKey: the packed public key to hash ( if given the hash is build based on the given hash, otherwise the hash is based on the config)

**Returns**

the pubKeyHash

#### pubkey()

returns the current packed PubKey based on the config set.

``` swift
public func pubkey() throws ->  String 
```

If the config contains public keys for musig-signatures, the keys will be aggregated, otherwise the pubkey will be derrived from the signing key set.

**Example**

``` swift
let result = try in3.zksync.pubkey()
// result = "0xfca80a469dbb53f8002eb1e2569d66f156f0df24d71bd589432cc7bc647bfc04"
```

**Returns**

the pubKey

#### accountAddress()

returns the address of the account used.

``` swift
public func accountAddress() throws ->  String 
```

**Example**

``` swift
let result = try in3.zksync.accountAddress()
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
in3.zksync.sign(message: "0xaabbccddeeff") .observe(using: {
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
public func verify(message: String, signature: String) throws ->  Int 
```

if the `musig_pubkeys` are set it will also verify against the given public keys list.

**Example**

``` swift
let result = try in3.zksync.verify(message: "0xaabbccddeeff", signature: "0xfca80a469dbb53f8002eb1e2569d66f156f0df24d71bd589432cc7bc647bfc0493f69034c3980e7352741afa6c171b8e18355e41ed7427f6e706f8432e32e920c3e61e6c3aa00cfe0c202c29a31b69cd0910a432156a0977c3a5baa404547e01")
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
public func ethopInfo(opId: UInt64) -> Future<ZkSyncEthopInfo> 
```

**Example**

``` swift
in3.zksync.ethopInfo(opId: 1) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          block:
//            committed: true
//            blockNumber: 4
//            verified: true
//          executed: true
     }
}
 
```

**Parameters**

  - opId: the opId of a layer-operstion (like depositing)

**Returns**

state of the PriorityOperation

#### getTokenPrice(token:)

returns current token-price

``` swift
public func getTokenPrice(token: String) -> Future<Double> 
```

**Example**

``` swift
in3.zksync.getTokenPrice(token: "WBTC") .observe(using: {
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
public func getTxFee(txType: String, address: String, token: String) -> Future<ZkSyncFeeInfo> 
```

**Example**

``` swift
in3.zksync.getTxFee(txType: "Transfer", address: "0xabea9132b05a70803a4e85094fd0e1800777fbef", token: "BAT") .observe(using: {
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
in3.zksync.syncKey() .observe(using: {
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
public func deposit(amount: UInt256, token: String, approveDepositAmountForERC20: Bool? = nil, account: String? = nil) -> Future<ZkSyncDepositResult> 
```

**Example**

``` swift
in3.zksync.deposit(amount: 1000, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          receipt:
//            blockHash: "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304"
//            blockNumber: "0x8c1e39"
//            contractAddress: null
//            cumulativeGasUsed: "0x2466d"
//            gasUsed: "0x2466d"
//            logs:
//              - address: "0x85ec283a3ed4b66df4da23656d4bf8a507383bca"
//                blockHash: "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304"
//                blockNumber: "0x8c1e39"
//                data: 0x00000000000...
//                logIndex: "0x0"
//                removed: false
//                topics:
//                  - "0x9123e6a7c5d144bd06140643c88de8e01adcbb24350190c02218a4435c7041f8"
//                  - "0xa2f7689fc12ea917d9029117d32b9fdef2a53462c853462ca86b71b97dd84af6"
//                  - "0x55a6ef49ec5dcf6cd006d21f151f390692eedd839c813a150000000000000000"
//                transactionHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
//                transactionIndex: "0x0"
//                transactionLogIndex: "0x0"
//                type: mined
//            logsBloom: 0x00000000000000000000200000...
//            root: null
//            status: "0x1"
//            transactionHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
//            transactionIndex: "0x0"
//          priorityOpId: 74
     }
}
 
```

**Parameters**

  - amount: the value to deposit in wei (or smallest token unit)
  - token: the token as symbol or address
  - approveDepositAmountForERC20: if true and in case of an erc20-token, the client will send a approve transaction first, otherwise it is expected to be already approved.
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the receipt and the receipopId. You can use `zksync_ethop_info` to follow the state-changes.

#### transfer(to:amount:token:account:)

sends a zksync-transaction and returns data including the transactionHash.

``` swift
public func transfer(to: String, amount: UInt256, token: String, account: String? = nil) -> Future<ZksyncZkReceipt> 
```

**Example**

``` swift
in3.zksync.transfer(to: 9.814684447173249e+47, amount: 100, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          type: Transfer
//          accountId: 1
//          from: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//          to: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//          token: 0
//          amount: 10
//          fee: 3780000000000000
//          nonce: 4
//          txHash: sync-tx:40008d91ab92f7c539e45b06e708e186a4b906ad10c4b7a29f855fe02e7e7668
     }
}
 
```

**Parameters**

  - to: the receipient of the tokens
  - amount: the value to transfer in wei (or smallest token unit)
  - token: the token as symbol or address
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the transactionReceipt. use `zksync_tx_info` to check the progress.

#### withdraw(ethAddress:amount:token:account:)

withdraws the amount to the given `ethAddress` for the given token.

``` swift
public func withdraw(ethAddress: String, amount: UInt256, token: String, account: String? = nil) -> Future<ZksyncZkReceipt> 
```

**Example**

``` swift
in3.zksync.withdraw(ethAddress: 9.814684447173249e+47, amount: 100, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          type: Transfer
//          accountId: 1
//          from: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//          to: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//          token: 0
//          amount: 10
//          fee: 3780000000000000
//          nonce: 4
//          txHash: sync-tx:40008d91ab92f7c539e45b06e708e186a4b906ad10c4b7a29f855fe02e7e7668
     }
}
 
```

**Parameters**

  - ethAddress: the receipient of the tokens in L1
  - amount: the value to transfer in wei (or smallest token unit)
  - token: the token as symbol or address
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the transactionReceipt. use `zksync_tx_info` to check the progress.

#### emergencyWithdraw(token:)

withdraws all tokens for the specified token as a onchain-transaction. This is useful in case the zksync-server is offline or tries to be malicious.

``` swift
public func emergencyWithdraw(token: String) -> Future<ZksyncEthTransactionReceipt> 
```

**Example**

``` swift
in3.zksync.emergencyWithdraw(token: "WBTC") .observe(using: {
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
public func aggregatePubkey(pubkeys: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.zksync.aggregatePubkey(pubkeys: "0x0f61bfe164cc43b5a112bfbfb0583004e79dbfafc97a7daad14c5d511fea8e2435065ddd04329ec94be682bf004b03a5a4eeca9bf50a8b8b6023942adc0b3409")
// result = "0x9ce5b6f8db3fbbe66a3bdbd3b4731f19ec27f80ee03ead3c0708798dd949882b"
```

**Parameters**

  - pubkeys: concatinated packed publickeys of the signers. the length of the bytes must be `num_keys * 32`

**Returns**

the compact public Key

#### contractAddress()

returns the contract address

``` swift
public func contractAddress() -> Future<ZkSyncContractDefinition> 
```

**Example**

``` swift
in3.zksync.contractAddress() .observe(using: {
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
public func tokens() -> Future<[String:ZkSyncToken]> 
```

**Example**

``` swift
in3.zksync.tokens() .observe(using: {
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
public func accountInfo(address: String? = nil) -> Future<ZkSyncAccountInfo> 
```

**Example**

``` swift
in3.zksync.accountInfo() .observe(using: {
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
public func txInfo(tx: String) -> Future<ZkSyncTxInfo> 
```

**Example**

``` swift
in3.zksync.txInfo(tx: "sync-tx:e41d2489571d322189246dafa5ebde1f4699f498000000000000000000000000") .observe(using: {
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

#### txData(tx:)

returns the full input data of a transaction. In order to use this, the `rest_api` needs to be set in the config.

``` swift
public func txData(tx: String) -> Future<ZkSyncTxData> 
```

**Example**

``` swift
in3.zksync.txData(tx: "0xc06ddc1c0914e8f9ca4d5bc98f609f7d758f6de2733fdcb8e3ec") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          tx_type: Transfer
//          from: "0x627d8e8c1a663cfea17432ec6dbbd3cc2c8a1f9a"
//          to: "0x03e2c10b74a260f46ab5cf881938c5888a6142df"
//          token: 1
//          amount: "5000000"
//          fee: "2190"
//          block_number: 29588
//          nonce: 20
//          created_at: 2021-06-01T10:32:16.248564
//          fail_reason: null
//          tx:
//            to: "0x03e2c10b74a260f46ab5cf881938c5888a6142df"
//            fee: "2190"
//            from: "0x627d8e8c1a663cfea17432ec6dbbd3cc2c8a1f9a"
//            type: Transfer
//            nonce: 20
//            token: 1
//            amount: "5000000"
//            accountId: 161578
//            signature:
//              pubKey: 91b533af2c430d7ad48db3ccc4ccb54befaff48307180c9a19a369099331d0a6
//              signature: d17637db375a7a587474c8fee519fd7520f6ef98e1370e7a13d5de8176a6d0a22309e24a19dae50dad94ac9634ab3398427cf67abe8408e6c965c6b350b80c02
//            validFrom: 0
//            validUntil: 4294967295
     }
}
 
```

**Parameters**

  - tx: the txHash of the send tx

**Returns**

the data and state of the requested tx.

#### accountHistory(account:ref:limit:)

returns the history of transaction for a given account.

``` swift
public func accountHistory(account: String, ref: String? = nil, limit: Int? = nil) -> Future<[ZkHistory]> 
```

**Example**

``` swift
in3.zksync.accountHistory(account: "0x9df215737e137acddd0ad99e32f9a6b980ea526d") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          - tx_id: 29411,1
//            hash: sync-tx:e83b1b982b4d8a08a21f87717e85a268e3b3a5305bdf5efc465e7fd8f0ad5335
//            eth_block: null
//            pq_id: null
//            tx:
//              to: "0xb7b2af693a2362c5c7575841ca6eb72ad2aed77f"
//              fee: "11060000000000"
//              from: "0x9df215737e137acddd0ad99e32f9a6b980ea526d"
//              type: Transfer
//              nonce: 1
//              token: ETH
//              amount: "1000000000000000"
//              accountId: 161418
//              signature:
//                pubKey: 74835ee6dd9009b67fd4e4aef4a6f63ee2a597ced5e59f33b019905d1df70d91
//                signature: 407314ebce8ce0217b41a6cf992c7359645215c35afbdf7e18e76c957a14ed20135b7e8e5ca24fb132640141c0b3168b3939571e2363e41639e18b1637f26d02
//              validFrom: 0
//              validUntil: 4294967295
//            success: true
//            fail_reason: null
//            commited: true
//            verified: true
//            created_at: 2021-05-31T11:54:56.248569Z
//          - tx_id: 29376,10
//            hash: sync-tx:5f92999f7bbc5d84fe0d34ebe8b7a0c38f977caece844686d3007bc48e5944e0
//            eth_block: null
//            pq_id: null
//            tx:
//              to: "0xc98fc74a085cd7ecd91d9e8d860a18ef6769d873"
//              fee: "10450000000000"
//              from: "0xb7b2af693a2362c5c7575841ca6eb72ad2aed77f"
//              type: Transfer
//              nonce: 1
//              token: ETH
//              amount: "10000000000000000"
//              accountId: 161391
//              signature:
//                pubKey: 06cce677912252a9eb87090b795e5bd84a079cb398dfec7f6a6645ee456dc721
//                signature: ef83b1519a737107798aa5740998a515c406510b61f176fbbac6f703231968a563551f74f37bf96c2220fd18a68aca128a155b5083333a13cfbbd348c0a75003
//              validFrom: 0
//              validUntil: 4294967295
//            success: true
//            fail_reason: null
//            commited: true
//            verified: true
//            created_at: 2021-05-31T08:11:17.250144Z
//          - tx_id: 29376,5
//            hash: sync-tx:78550bbcaefdfd4cc4275bd1a0168dd73efb1953bb17a9689381fea6729c924e
//            eth_block: null
//            pq_id: null
//            tx:
//              fee: "37500000000000"
//              type: ChangePubKey
//              nonce: 0
//              account: "0xb7b2af693a2362c5c7575841ca6eb72ad2aed77f"
//              feeToken: 0
//              accountId: 161391
//              newPkHash: sync:1ae5a093f285ddd23b54bea2780ef4e9a4e348ea
//              signature:
//                pubKey: 06cce677912252a9eb87090b795e5bd84a079cb398dfec7f6a6645ee456dc721
//                signature: 27f42a850de4dcc6527fea0a9baa5991dabf3c2ce30dae5a6112f03cf614da03bdc2ef7ac107337d17f9e4047e5b18b3e4c46acb6af41f8cfbb2fce43247d500
//              validFrom: 0
//              validUntil: 4294967295
//              ethAuthData:
//                type: CREATE2
//                saltArg: "0xd32a7ec6157d2433c9ae7f4fdc35dfac9bba6f92831d1ca20b09d04d039d8dd7"
//                codeHash: "0x96657bf6bdcbffce06518530907d2d729e4659ad3bc7b5cc1f5c5567d964272c"
//                creatorAddress: "0xaa8c54c65c14f132804f0809bdbef19970673709"
//              ethSignature: null
//            success: true
//            fail_reason: null
//            commited: true
//            verified: true
//            created_at: 2021-05-31T08:09:11.249472Z
//          - tx_id: 29376,0
//            hash: "0xc63566212c1569a0e64b255a07320483ed8476cd36b54aa37d3bd6f93b70f7f8"
//            eth_block: 8680840
//            pq_id: 57181
//            tx:
//              type: Deposit
//              account_id: 161391
//              priority_op:
//                to: "0xb7b2af693a2362c5c7575841ca6eb72ad2aed77f"
//                from: "0x9d646b325787c6d7d612eb37915ca3023eea4dac"
//                token: ETH
//                amount: "500000000000000000"
//            success: true
//            fail_reason: null
//            commited: true
//            verified: true
//            created_at: 2021-05-31T08:07:31.237817Z
     }
}
 
```

**Parameters**

  - account: the address of the account
  - ref: the reference or start. this could be a tx\_id prefixed with `<` or `>`for newer or older than the specified  tx or `pending` returning all pending tx.
  - limit: the max number of entries to return

**Returns**

the data and state of the requested tx.

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

**Example**

``` swift
in3.zksync.setKey(token: "eth") .observe(using: {
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
public func pubkeyhash(pubKey: String? = nil) throws ->  String 
```

**Example**

``` swift
let result = try in3.zksync.pubkeyhash()
// result = sync:4dcd9bb4463121470c7232efb9ff23ec21398e58
```

**Parameters**

  - pubKey: the packed public key to hash ( if given the hash is build based on the given hash, otherwise the hash is based on the config)

**Returns**

the pubKeyHash

#### pubkey()

returns the current packed PubKey based on the config set.

``` swift
public func pubkey() throws ->  String 
```

If the config contains public keys for musig-signatures, the keys will be aggregated, otherwise the pubkey will be derrived from the signing key set.

**Example**

``` swift
let result = try in3.zksync.pubkey()
// result = "0xfca80a469dbb53f8002eb1e2569d66f156f0df24d71bd589432cc7bc647bfc04"
```

**Returns**

the pubKey

#### accountAddress()

returns the address of the account used.

``` swift
public func accountAddress() throws ->  String 
```

**Example**

``` swift
let result = try in3.zksync.accountAddress()
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
in3.zksync.sign(message: "0xaabbccddeeff") .observe(using: {
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
public func verify(message: String, signature: String) throws ->  Int 
```

if the `musig_pubkeys` are set it will also verify against the given public keys list.

**Example**

``` swift
let result = try in3.zksync.verify(message: "0xaabbccddeeff", signature: "0xfca80a469dbb53f8002eb1e2569d66f156f0df24d71bd589432cc7bc647bfc0493f69034c3980e7352741afa6c171b8e18355e41ed7427f6e706f8432e32e920c3e61e6c3aa00cfe0c202c29a31b69cd0910a432156a0977c3a5baa404547e01")
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
public func ethopInfo(opId: UInt64) -> Future<ZkSyncEthopInfo> 
```

**Example**

``` swift
in3.zksync.ethopInfo(opId: 1) .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          block:
//            committed: true
//            blockNumber: 4
//            verified: true
//          executed: true
     }
}
 
```

**Parameters**

  - opId: the opId of a layer-operstion (like depositing)

**Returns**

state of the PriorityOperation

#### getTokenPrice(token:)

returns current token-price

``` swift
public func getTokenPrice(token: String) -> Future<Double> 
```

**Example**

``` swift
in3.zksync.getTokenPrice(token: "WBTC") .observe(using: {
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
public func getTxFee(txType: String, address: String, token: String) -> Future<ZkSyncFeeInfo> 
```

**Example**

``` swift
in3.zksync.getTxFee(txType: "Transfer", address: "0xabea9132b05a70803a4e85094fd0e1800777fbef", token: "BAT") .observe(using: {
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
in3.zksync.syncKey() .observe(using: {
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
public func deposit(amount: UInt256, token: String, approveDepositAmountForERC20: Bool? = nil, account: String? = nil) -> Future<ZkSyncDepositResult> 
```

**Example**

``` swift
in3.zksync.deposit(amount: 1000, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          receipt:
//            blockHash: "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304"
//            blockNumber: "0x8c1e39"
//            contractAddress: null
//            cumulativeGasUsed: "0x2466d"
//            gasUsed: "0x2466d"
//            logs:
//              - address: "0x85ec283a3ed4b66df4da23656d4bf8a507383bca"
//                blockHash: "0xea6ee1e20d3408ad7f6981cfcc2625d80b4f4735a75ca5b20baeb328e41f0304"
//                blockNumber: "0x8c1e39"
//                data: 0x00000000000...
//                logIndex: "0x0"
//                removed: false
//                topics:
//                  - "0x9123e6a7c5d144bd06140643c88de8e01adcbb24350190c02218a4435c7041f8"
//                  - "0xa2f7689fc12ea917d9029117d32b9fdef2a53462c853462ca86b71b97dd84af6"
//                  - "0x55a6ef49ec5dcf6cd006d21f151f390692eedd839c813a150000000000000000"
//                transactionHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
//                transactionIndex: "0x0"
//                transactionLogIndex: "0x0"
//                type: mined
//            logsBloom: 0x00000000000000000000200000...
//            root: null
//            status: "0x1"
//            transactionHash: "0x5dc2a9ec73abfe0640f27975126bbaf14624967e2b0b7c2b3a0fb6111f0d3c5e"
//            transactionIndex: "0x0"
//          priorityOpId: 74
     }
}
 
```

**Parameters**

  - amount: the value to deposit in wei (or smallest token unit)
  - token: the token as symbol or address
  - approveDepositAmountForERC20: if true and in case of an erc20-token, the client will send a approve transaction first, otherwise it is expected to be already approved.
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the receipt and the receipopId. You can use `zksync_ethop_info` to follow the state-changes.

#### transfer(to:amount:token:account:)

sends a zksync-transaction and returns data including the transactionHash.

``` swift
public func transfer(to: String, amount: UInt256, token: String, account: String? = nil) -> Future<ZkReceipt> 
```

**Example**

``` swift
in3.zksync.transfer(to: 9.814684447173249e+47, amount: 100, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          type: Transfer
//          accountId: 1
//          from: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//          to: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//          token: 0
//          amount: 10
//          fee: 3780000000000000
//          nonce: 4
//          txHash: sync-tx:40008d91ab92f7c539e45b06e708e186a4b906ad10c4b7a29f855fe02e7e7668
     }
}
 
```

**Parameters**

  - to: the receipient of the tokens
  - amount: the value to transfer in wei (or smallest token unit)
  - token: the token as symbol or address
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the transactionReceipt. use `zksync_tx_info` to check the progress.

#### withdraw(ethAddress:amount:token:account:)

withdraws the amount to the given `ethAddress` for the given token.

``` swift
public func withdraw(ethAddress: String, amount: UInt256, token: String, account: String? = nil) -> Future<ZkReceipt> 
```

**Example**

``` swift
in3.zksync.withdraw(ethAddress: 9.814684447173249e+47, amount: 100, token: "WBTC") .observe(using: {
    switch $0 {
       case let .failure(err):
         print("Failed because : \(err.localizedDescription)")
       case let .success(val):
         print("result : \(val)")
//              result = 
//          type: Transfer
//          accountId: 1
//          from: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//          to: "0x8a91dc2d28b689474298d91899f0c1baf62cb85b"
//          token: 0
//          amount: 10
//          fee: 3780000000000000
//          nonce: 4
//          txHash: sync-tx:40008d91ab92f7c539e45b06e708e186a4b906ad10c4b7a29f855fe02e7e7668
     }
}
 
```

**Parameters**

  - ethAddress: the receipient of the tokens in L1
  - amount: the value to transfer in wei (or smallest token unit)
  - token: the token as symbol or address
  - account: address of the account to send the tx from. if not specified, the first available signer will be used.

**Returns**

the transactionReceipt. use `zksync_tx_info` to check the progress.

#### emergencyWithdraw(token:)

withdraws all tokens for the specified token as a onchain-transaction. This is useful in case the zksync-server is offline or tries to be malicious.

``` swift
public func emergencyWithdraw(token: String) -> Future<EthTransactionReceipt> 
```

**Example**

``` swift
in3.zksync.emergencyWithdraw(token: "WBTC") .observe(using: {
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
public func aggregatePubkey(pubkeys: String) throws ->  String 
```

**Example**

``` swift
let result = try in3.zksync.aggregatePubkey(pubkeys: "0x0f61bfe164cc43b5a112bfbfb0583004e79dbfafc97a7daad14c5d511fea8e2435065ddd04329ec94be682bf004b03a5a4eeca9bf50a8b8b6023942adc0b3409")
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
public struct ABI : Codable 
```



`Codable`, `Codable`



#### hash

``` swift
public var hash:String?
```

#### anonymous

``` swift
public var anonymous: Bool?
```

#### constant

``` swift
public var constant: Bool?
```

#### payable

``` swift
public var payable: Bool?
```

#### stateMutability

``` swift
public var stateMutability: String?
```

#### components

``` swift
public var components: [ABIField]?
```

#### inputs

``` swift
public var inputs: [ABIField]?
```

#### outputs

``` swift
public var outputs: [ABIField]?
```

#### name

``` swift
public var name: String?
```

#### type

``` swift
public var type: String
```

#### internalType

``` swift
public var internalType: String?
```

#### signature

``` swift
public var signature:String 
```

#### inputSignature

``` swift
public var inputSignature:String 
```

#### hash

``` swift
public var hash:String?
```

#### anonymous

``` swift
public var anonymous: Bool?
```

#### constant

``` swift
public var constant: Bool?
```

#### payable

``` swift
public var payable: Bool?
```

#### stateMutability

``` swift
public var stateMutability: String?
```

#### components

``` swift
public var components: [ABIField]?
```

#### inputs

``` swift
public var inputs: [ABIField]?
```

#### outputs

``` swift
public var outputs: [ABIField]?
```

#### name

``` swift
public var name: String?
```

#### type

``` swift
public var type: String
```

#### internalType

``` swift
public var internalType: String?
```

#### signature

``` swift
public var signature:String 
```

#### inputSignature

``` swift
public var inputSignature:String 
```
### ABIField

configure the Bitcoin verification

``` swift
public struct ABIField : Codable 
```



`Codable`, `Codable`



#### internalType

``` swift
public var internalType: String?
```

#### components

``` swift
public var components: [ABIField]?
```

#### indexed

``` swift
public var indexed: Bool?
```

#### name

``` swift
public var name: String
```

#### type

``` swift
public var type: String
```

#### signature

``` swift
public var signature:String 
```

#### internalType

``` swift
public var internalType: String?
```

#### components

``` swift
public var components: [ABIField]?
```

#### indexed

``` swift
public var indexed: Bool?
```

#### name

``` swift
public var name: String
```

#### type

``` swift
public var type: String
```

#### signature

``` swift
public var signature:String 
```
### AccountCipherParams

the cipherparams

``` swift
public struct AccountCipherParams 
```



#### init(iv:)

initialize the AccountCipherParams

``` swift
public init(iv: String) 
```

**Parameters**

  - iv: the iv



#### iv

the iv

``` swift
public var iv: String
```
### AccountCryptoParams

the cryptoparams

``` swift
public struct AccountCryptoParams 
```



#### init(ciphertext:cipherparams:cipher:kdf:kdfparams:mac:)

initialize the AccountCryptoParams

``` swift
public init(ciphertext: String, cipherparams: AccountCipherParams, cipher: String, kdf: String, kdfparams: AccountKdfParams, mac: String) 
```

**Parameters**

  - ciphertext: the cipher text
  - cipherparams: the cipherparams
  - cipher: the cipher
  - kdf: the kdf
  - kdfparams: the kdfparams
  - mac: the mac



#### ciphertext

the cipher text

``` swift
public var ciphertext: String
```

#### cipherparams

the cipherparams

``` swift
public var cipherparams: AccountCipherParams
```

#### cipher

the cipher

``` swift
public var cipher: String
```

#### kdf

the kdf

``` swift
public var kdf: String
```

#### kdfparams

the kdfparams

``` swift
public var kdfparams: AccountKdfParams
```

#### mac

the mac

``` swift
public var mac: String
```
### AccountEthTransaction

the tx-object, which is the same as specified in [eth\_sendTransaction](https:​//eth.wiki/json-rpc/API#eth_sendTransaction).

``` swift
public struct AccountEthTransaction 
```



#### init(to:from:wallet:value:gas:gasPrice:nonce:data:signatures:)

initialize the AccountEthTransaction

``` swift
public init(to: String? = nil, from: String? = nil, wallet: String? = nil, value: UInt256? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil, nonce: UInt64? = nil, data: String? = nil, signatures: String? = nil) 
```

**Parameters**

  - to: receipient of the transaction.
  - from: sender of the address (if not sepcified, the first signer will be the sender)
  - wallet: if specified, the transaction will be send through the specified wallet.
  - value: value in wei to send
  - gas: the gas to be send along
  - gasPrice: the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`
  - nonce: the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`
  - data: the data-section of the transaction
  - signatures: additional signatures which should be used when sending through a multisig



#### to

receipient of the transaction.

``` swift
public var to: String?
```

#### from

sender of the address (if not sepcified, the first signer will be the sender)

``` swift
public var from: String?
```

#### wallet

if specified, the transaction will be send through the specified wallet.

``` swift
public var wallet: String?
```

#### value

value in wei to send

``` swift
public var value: UInt256?
```

#### gas

the gas to be send along

``` swift
public var gas: UInt64?
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
public var gasPrice: UInt64?
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
public var nonce: UInt64?
```

#### data

the data-section of the transaction

``` swift
public var data: String?
```

#### signatures

additional signatures which should be used when sending through a multisig

``` swift
public var signatures: String?
```
### AccountKdfParams

the kdfparams

``` swift
public struct AccountKdfParams 
```



#### init(dklen:salt:c:prf:)

initialize the AccountKdfParams

``` swift
public init(dklen: UInt64, salt: String, c: UInt64, prf: String) 
```

**Parameters**

  - dklen: the dklen
  - salt: the salt
  - c: the c
  - prf: the prf



#### dklen

the dklen

``` swift
public var dklen: UInt64
```

#### salt

the salt

``` swift
public var salt: String
```

#### c

the c

``` swift
public var c: UInt64
```

#### prf

the prf

``` swift
public var prf: String
```
### AccountKeyparams

the keyparams

``` swift
public struct AccountKeyparams 
```



#### init(version:id:address:crypto:)

initialize the AccountKeyparams

``` swift
public init(version: String, id: String, address: String, crypto: AccountCryptoParams) 
```

**Parameters**

  - version: the version
  - id: the id
  - address: the address
  - crypto: the cryptoparams



#### version

the version

``` swift
public var version: String
```

#### id

the id

``` swift
public var id: String
```

#### address

the address

``` swift
public var address: String
```

#### crypto

the cryptoparams

``` swift
public var crypto: AccountCryptoParams
```
### AddUser

The user creation result

``` swift
public struct AddUser 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(signature:status:)

initialize the AddUser

``` swift
public init(signature: VaultSignature, status: String) 
```

**Parameters**

  - signature: signature for policy content
  - status: a enum for status of sending token as `sent`, `error`, `alreadyVerified` or `invalidTarget`



#### signature

signature for policy content

``` swift
public var signature: VaultSignature
```

#### status

a enum for status of sending token as `sent`, `error`, `alreadyVerified` or `invalidTarget`

``` swift
public var status: String
```
### AddUserDevice

Device registration result

``` swift
public struct AddUserDevice 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(signature:status:)

initialize the AddUserDevice

``` swift
public init(signature: VaultSignature, status: String) 
```

**Parameters**

  - signature: signature for policy content
  - status: a enum for status of sending token as `sent`, `error` or `invalidTarget`



#### signature

signature for policy content

``` swift
public var signature: VaultSignature
```

#### status

a enum for status of sending token as `sent`, `error` or `invalidTarget`

``` swift
public var status: String
```
### BtcOutput

the desired outputs of the transaction

``` swift
public struct BtcOutput 
```



#### init(tx_index:value:tx_hash:script:)

initialize the BtcOutput

``` swift
public init(tx_index: UInt64, value: UInt64, tx_hash: String, script: String) 
```

  - Parameter tx\_index : the block hash (same as provided)

  - Parameter tx\_hash : the block hash (same as provided)

**Parameters**

  - value: the block hash (same as provided)
  - script: the block hash (same as provided)



#### tx_index

the block hash (same as provided)

``` swift
public var tx_index: UInt64
```

#### value

the block hash (same as provided)

``` swift
public var value: UInt64
```

#### tx_hash

the block hash (same as provided)

``` swift
public var tx_hash: String
```

#### script

the block hash (same as provided)

``` swift
public var script: String
```
### BtcProofTargetResult

A path of daps from the `verified_dap` to the `target_dap` which fulfils the conditions of `max_diff`, `max_dap` and `limit`. Each dap of the path is a `dap`-object with corresponding proof data.

``` swift
public struct BtcProofTargetResult 
```



#### init(dap:block:final:cbtx:cbtxMerkleProof:)

initialize the BtcProofTargetResult

``` swift
public init(dap: UInt64, block: String, final: String, cbtx: String, cbtxMerkleProof: String) 
```

**Parameters**

  - dap: the difficulty adjustement period
  - block: the first blockheader
  - final: the finality header
  - cbtx: the coinbase transaction as hex
  - cbtxMerkleProof: the coinbasetx merkle proof

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(dap:block:final:cbtx:cbtxMerkleProof:)

initialize the BtcProofTargetResult

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
public var dap: UInt64
```

#### block

the first blockheader

``` swift
public var block: String
```

#### final

the finality header

``` swift
public var final: String
```

#### cbtx

the coinbase transaction as hex

``` swift
public var cbtx: String
```

#### cbtxMerkleProof

the coinbasetx merkle proof

``` swift
public var cbtxMerkleProof: String
```

#### dap

the difficulty adjustement period

``` swift
public var dap: UInt64
```

#### block

the first blockheader

``` swift
public var block: String
```

#### final

the finality header

``` swift
public var final: String
```

#### cbtx

the coinbase transaction as hex

``` swift
public var cbtx: String
```

#### cbtxMerkleProof

the coinbasetx merkle proof

``` swift
public var cbtxMerkleProof: String
```
### BtcTxScriptPubKey

the script pubkey

``` swift
public struct BtcTxScriptPubKey 
```



#### init(asm:hex:reqSigs:type:addresses:)

initialize the BtcTxScriptPubKey

``` swift
public init(asm: String, hex: String, reqSigs: Int? = nil, type: String, addresses: [String]? = nil) 
```

**Parameters**

  - asm: asm
  - hex: hex representation of the script
  - reqSigs: the required signatures
  - type: The type, eg 'pubkeyhash'
  - addresses: Array of address(each representing a bitcoin adress)

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(asm:hex:reqSigs:type:addresses:)

initialize the BtcTxScriptPubKey

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
public var asm: String
```

#### hex

hex representation of the script

``` swift
public var hex: String
```

#### reqSigs

the required signatures

``` swift
public var reqSigs: Int?
```

#### type

The type, eg 'pubkeyhash'

``` swift
public var type: String
```

#### addresses

Array of address(each representing a bitcoin adress)

``` swift
public var addresses: [String]?
```

#### asm

asm

``` swift
public var asm: String
```

#### hex

hex representation of the script

``` swift
public var hex: String
```

#### reqSigs

the required signatures

``` swift
public var reqSigs: Int
```

#### type

The type, eg 'pubkeyhash'

``` swift
public var type: String
```

#### addresses

Array of address(each representing a bitcoin adress)

``` swift
public var addresses: [String]
```
### BtcTxScriptSig

the script

``` swift
public struct BtcTxScriptSig 
```



#### init(asm:hex:)

initialize the BtcTxScriptSig

``` swift
public init(asm: String, hex: String) 
```

**Parameters**

  - asm: the asm-codes
  - hex: hex representation

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(asm:hex:)

initialize the BtcTxScriptSig

``` swift
public init(asm: String, hex: String) 
```

**Parameters**

  - asm: the asm-codes
  - hex: hex representation



#### asm

the asm-codes

``` swift
public var asm: String
```

#### hex

hex representation

``` swift
public var hex: String
```

#### asm

the asm-codes

``` swift
public var asm: String
```

#### hex

hex representation

``` swift
public var hex: String
```
### BtcTxVin

array of json objects of incoming txs to be used

``` swift
public struct BtcTxVin 
```



#### init(txid:vout:scriptSig:sequence:txinwitness:coinbase:)

initialize the BtcTxVin

``` swift
public init(txid: String? = nil, vout: UInt64? = nil, scriptSig: BtcTxScriptSig? = nil, sequence: UInt64, txinwitness: [String]? = nil, coinbase: String? = nil) 
```

**Parameters**

  - txid: the transaction id
  - vout: the index of the transaction out to be used
  - scriptSig: the script
  - sequence: The script sequence number
  - txinwitness: hex-encoded witness data (if any)
  - coinbase: the coinbase

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(txid:vout:scriptSig:sequence:txinwitness:coinbase:)

initialize the BtcTxVin

``` swift
public init(txid: String? = nil, vout: UInt64? = nil, scriptSig: BtcTxScriptSig? = nil, sequence: UInt64, txinwitness: [String]? = nil, coinbase: String? = nil) 
```

**Parameters**

  - txid: the transaction id
  - vout: the index of the transaction out to be used
  - scriptSig: the script
  - sequence: The script sequence number
  - txinwitness: hex-encoded witness data (if any)
  - coinbase: the coinbase



#### txid

the transaction id

``` swift
public var txid: String?
```

#### vout

the index of the transaction out to be used

``` swift
public var vout: UInt64?
```

#### scriptSig

the script

``` swift
public var scriptSig: BtcTxScriptSig?
```

#### sequence

The script sequence number

``` swift
public var sequence: UInt64
```

#### txinwitness

hex-encoded witness data (if any)

``` swift
public var txinwitness: [String]?
```

#### coinbase

the coinbase

``` swift
public var coinbase: String?
```

#### txid

the transaction id

``` swift
public var txid: String?
```

#### vout

the index of the transaction out to be used

``` swift
public var vout: UInt64?
```

#### scriptSig

the script

``` swift
public var scriptSig: BtcTxScriptSig?
```

#### sequence

The script sequence number

``` swift
public var sequence: UInt64
```

#### txinwitness

hex-encoded witness data (if any)

``` swift
public var txinwitness: [String]?
```

#### coinbase

the coinbase

``` swift
public var coinbase: String?
```
### BtcTxVout

array of json objects describing the tx outputs

``` swift
public struct BtcTxVout 
```



#### init(value:n:scriptPubKey:)

initialize the BtcTxVout

``` swift
public init(value: Double, n: Int, scriptPubKey: BtcTxScriptPubKey) 
```

**Parameters**

  - value: The Value in BTC
  - n: the index
  - scriptPubKey: the script pubkey

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(value:n:scriptPubKey:)

initialize the BtcTxVout

``` swift
public init(value: Double, n: Int, scriptPubKey: BtcTxScriptPubKey) 
```

**Parameters**

  - value: The Value in BTC
  - n: the index
  - scriptPubKey: the script pubkey



#### value

The Value in BTC

``` swift
public var value: Double
```

#### n

the index

``` swift
public var n: Int
```

#### scriptPubKey

the script pubkey

``` swift
public var scriptPubKey: BtcTxScriptPubKey
```

#### value

The Value in BTC

``` swift
public var value: Double
```

#### n

the index

``` swift
public var n: Int
```

#### scriptPubKey

the script pubkey

``` swift
public var scriptPubKey: BtcTxScriptPubKey
```
### BtcUtxo

the utxo used to proove liquidity for the transaction

``` swift
public struct BtcUtxo 
```



#### init(tx_index:value:tx_hash:script:)

initialize the BtcUtxo

``` swift
public init(tx_index: UInt64, value: UInt64, tx_hash: String, script: String) 
```

  - Parameter tx\_index : the transaction index that this utxo refers to

  - Parameter tx\_hash : the transaction hash (same as provided)

**Parameters**

  - value: the value
  - script: the script



#### tx_index

the transaction index that this utxo refers to

``` swift
public var tx_index: UInt64
```

#### value

the value

``` swift
public var value: UInt64
```

#### tx_hash

the transaction hash (same as provided)

``` swift
public var tx_hash: String
```

#### script

the script

``` swift
public var script: String
```
### Btcblock

the block.

``` swift
public struct Btcblock 
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.



#### init(hash:confirmations:height:version:versionHex:merkleroot:time:mediantime:nonce:bits:difficulty:chainwork:nTx:tx:previousblockhash:nextblockhash:strippedsize:weight:size:)

initialize the Btcblock

``` swift
public init(hash: String, confirmations: Int, height: UInt64, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: Double, chainwork: String, nTx: Int, tx: [String], previousblockhash: String, nextblockhash: String, strippedsize: Int, weight: Int, size: Int) 
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
  - strippedsize: The block size excluding witness data
  - weight: The block weight as defined in BIP 141
  - size: The block size

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(hash:confirmations:height:version:versionHex:merkleroot:time:mediantime:nonce:bits:difficulty:chainwork:nTx:tx:previousblockhash:nextblockhash:strippedsize:weight:size:)

initialize the Btcblock

``` swift
public init(hash: String, confirmations: Int, height: UInt64, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: Double, chainwork: String, nTx: Int, tx: [String], previousblockhash: String, nextblockhash: String, strippedsize: Int, weight: Int, size: Int) 
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
  - strippedsize: The block size excluding witness data
  - weight: The block weight as defined in BIP 141
  - size: The block size



#### hash

the block hash (same as provided)

``` swift
public var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
public var confirmations: Int
```

#### height

The block height or index

``` swift
public var height: UInt64
```

#### version

The block version

``` swift
public var version: Int
```

#### versionHex

The block version formatted in hexadecimal

``` swift
public var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
public var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var mediantime: UInt64
```

#### nonce

The nonce

``` swift
public var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
public var bits: String
```

#### difficulty

The difficulty

``` swift
public var difficulty: Double
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
public var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
public var nTx: Int
```

#### tx

the array of transactions either as ids (verbose=1) or full transaction (verbose=2)

``` swift
public var tx: [String]
```

#### previousblockhash

The hash of the previous block

``` swift
public var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
public var nextblockhash: String
```

#### strippedsize

The block size excluding witness data

``` swift
public var strippedsize: Int
```

#### weight

The block weight as defined in BIP 141

``` swift
public var weight: Int
```

#### size

The block size

``` swift
public var size: Int
```

#### hash

the block hash (same as provided)

``` swift
public var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
public var confirmations: Int
```

#### height

The block height or index

``` swift
public var height: UInt64
```

#### version

The block version

``` swift
public var version: Int
```

#### versionHex

The block version formatted in hexadecimal

``` swift
public var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
public var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var mediantime: UInt64
```

#### nonce

The nonce

``` swift
public var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
public var bits: String
```

#### difficulty

The difficulty

``` swift
public var difficulty: Double
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
public var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
public var nTx: Int
```

#### tx

the array of transactions either as ids (verbose=1) or full transaction (verbose=2)

``` swift
public var tx: [String]
```

#### previousblockhash

The hash of the previous block

``` swift
public var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
public var nextblockhash: String
```

#### strippedsize

The block size excluding witness data

``` swift
public var strippedsize: Int
```

#### weight

The block weight as defined in BIP 141

``` swift
public var weight: Int
```

#### size

The block size

``` swift
public var size: Int
```
### BtcblockWithTx

the block.

``` swift
public struct BtcblockWithTx 
```

  - verbose `0` or `false`: a hex string with 80 bytes representing the blockheader

  - verbose `1` or `true`: an object representing the blockheader.



#### init(hash:confirmations:height:version:versionHex:merkleroot:time:mediantime:nonce:bits:difficulty:chainwork:nTx:tx:previousblockhash:nextblockhash:strippedsize:weight:size:)

initialize the BtcblockWithTx

``` swift
public init(hash: String, confirmations: Int, height: UInt64, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: Double, chainwork: String, nTx: Int, tx: [Btcblocktransaction], previousblockhash: String, nextblockhash: String, strippedsize: Int, weight: Int, size: Int) 
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
  - strippedsize: The block size excluding witness data
  - weight: The block weight as defined in BIP 141
  - size: The block size

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(hash:confirmations:height:version:versionHex:merkleroot:time:mediantime:nonce:bits:difficulty:chainwork:nTx:tx:previousblockhash:nextblockhash:strippedsize:weight:size:)

initialize the BtcblockWithTx

``` swift
public init(hash: String, confirmations: Int, height: UInt64, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: Double, chainwork: String, nTx: Int, tx: [Btcblocktransaction], previousblockhash: String, nextblockhash: String, strippedsize: Int, weight: Int, size: Int) 
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
  - strippedsize: The block size excluding witness data
  - weight: The block weight as defined in BIP 141
  - size: The block size



#### hash

the block hash (same as provided)

``` swift
public var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
public var confirmations: Int
```

#### height

The block height or index

``` swift
public var height: UInt64
```

#### version

The block version

``` swift
public var version: Int
```

#### versionHex

The block version formatted in hexadecimal

``` swift
public var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
public var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var mediantime: UInt64
```

#### nonce

The nonce

``` swift
public var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
public var bits: String
```

#### difficulty

The difficulty

``` swift
public var difficulty: Double
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
public var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
public var nTx: Int
```

#### tx

the array of transactions either as ids (verbose=1) or full transaction (verbose=2)

``` swift
public var tx: [Btcblocktransaction]
```

#### previousblockhash

The hash of the previous block

``` swift
public var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
public var nextblockhash: String
```

#### strippedsize

The block size excluding witness data

``` swift
public var strippedsize: Int
```

#### weight

The block weight as defined in BIP 141

``` swift
public var weight: Int
```

#### size

The block size

``` swift
public var size: Int
```

#### hash

the block hash (same as provided)

``` swift
public var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
public var confirmations: Int
```

#### height

The block height or index

``` swift
public var height: UInt64
```

#### version

The block version

``` swift
public var version: Int
```

#### versionHex

The block version formatted in hexadecimal

``` swift
public var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
public var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var mediantime: UInt64
```

#### nonce

The nonce

``` swift
public var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
public var bits: String
```

#### difficulty

The difficulty

``` swift
public var difficulty: Double
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
public var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
public var nTx: Int
```

#### tx

the array of transactions either as ids (verbose=1) or full transaction (verbose=2)

``` swift
public var tx: [Btcblocktransaction]
```

#### previousblockhash

The hash of the previous block

``` swift
public var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
public var nextblockhash: String
```

#### strippedsize

The block size excluding witness data

``` swift
public var strippedsize: Int
```

#### weight

The block weight as defined in BIP 141

``` swift
public var weight: Int
```

#### size

The block size

``` swift
public var size: Int
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
public init(hash: String, confirmations: Int, height: UInt64, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: Double, chainwork: String, nTx: Int, previousblockhash: String, nextblockhash: String) 
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

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(hash:confirmations:height:version:versionHex:merkleroot:time:mediantime:nonce:bits:difficulty:chainwork:nTx:previousblockhash:nextblockhash:)

initialize the Btcblockheader

``` swift
public init(hash: String, confirmations: Int, height: UInt64, version: Int, versionHex: String, merkleroot: String, time: UInt64, mediantime: UInt64, nonce: UInt64, bits: String, difficulty: Double, chainwork: String, nTx: Int, previousblockhash: String, nextblockhash: String) 
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
public var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
public var confirmations: Int
```

#### height

The block height or index

``` swift
public var height: UInt64
```

#### version

The block version

``` swift
public var version: Int
```

#### versionHex

The block version formatted in hexadecimal

``` swift
public var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
public var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var mediantime: UInt64
```

#### nonce

The nonce

``` swift
public var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
public var bits: String
```

#### difficulty

The difficulty

``` swift
public var difficulty: Double
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
public var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
public var nTx: Int
```

#### previousblockhash

The hash of the previous block

``` swift
public var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
public var nextblockhash: String
```

#### hash

the block hash (same as provided)

``` swift
public var hash: String
```

#### confirmations

The number of confirmations, or -1 if the block is not on the main chain

``` swift
public var confirmations: Int
```

#### height

The block height or index

``` swift
public var height: UInt64
```

#### version

The block version

``` swift
public var version: Int
```

#### versionHex

The block version formatted in hexadecimal

``` swift
public var versionHex: String
```

#### merkleroot

The merkle root ( 32 bytes )

``` swift
public var merkleroot: String
```

#### time

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var time: UInt64
```

#### mediantime

The median block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var mediantime: UInt64
```

#### nonce

The nonce

``` swift
public var nonce: UInt64
```

#### bits

The bits ( 4 bytes as hex) representing the target

``` swift
public var bits: String
```

#### difficulty

The difficulty

``` swift
public var difficulty: Double
```

#### chainwork

Expected number of hashes required to produce the current chain (in hex)

``` swift
public var chainwork: String
```

#### nTx

The number of transactions in the block.

``` swift
public var nTx: Int
```

#### previousblockhash

The hash of the previous block

``` swift
public var previousblockhash: String
```

#### nextblockhash

The hash of the next block

``` swift
public var nextblockhash: String
```
### Btcblocktransaction

the array of transactions either as ids (verbose=1) or full transaction (verbose=2)

``` swift
public struct Btcblocktransaction 
```



#### init(txid:hex:hash:size:vsize:weight:version:locktime:vin:vout:)

initialize the Btcblocktransaction

``` swift
public init(txid: String, hex: String, hash: String, size: UInt64, vsize: UInt64, weight: UInt64, version: Int, locktime: UInt64, vin: [BtcTxVin], vout: [BtcTxVout]) 
```

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

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(txid:hex:hash:size:vsize:weight:version:locktime:vin:vout:)

initialize the Btcblocktransaction

``` swift
public init(txid: String, hex: String, hash: String, size: UInt64, vsize: UInt64, weight: UInt64, version: Int, locktime: UInt64, vin: [BtcTxVin], vout: [BtcTxVout]) 
```

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



#### txid

txid

``` swift
public var txid: String
```

#### hex

The serialized, hex-encoded data for `txid`

``` swift
public var hex: String
```

#### hash

The transaction hash (differs from txid for witness transactions)

``` swift
public var hash: String
```

#### size

The serialized transaction size

``` swift
public var size: UInt64
```

#### vsize

The virtual transaction size (differs from size for witness transactions)

``` swift
public var vsize: UInt64
```

#### weight

The transaction's weight (between `vsize`\*4-3 and `vsize`\*4)

``` swift
public var weight: UInt64
```

#### version

The version

``` swift
public var version: Int
```

#### locktime

The lock time

``` swift
public var locktime: UInt64
```

#### vin

array of json objects of incoming txs to be used

``` swift
public var vin: [BtcTxVin]
```

#### vout

array of json objects describing the tx outputs

``` swift
public var vout: [BtcTxVout]
```

#### txid

txid

``` swift
public var txid: String
```

#### hex

The serialized, hex-encoded data for `txid`

``` swift
public var hex: String
```

#### hash

The transaction hash (differs from txid for witness transactions)

``` swift
public var hash: String
```

#### size

The serialized transaction size

``` swift
public var size: UInt64
```

#### vsize

The virtual transaction size (differs from size for witness transactions)

``` swift
public var vsize: UInt64
```

#### weight

The transaction's weight (between `vsize`\*4-3 and `vsize`\*4)

``` swift
public var weight: UInt64
```

#### version

The version

``` swift
public var version: Int
```

#### locktime

The lock time

``` swift
public var locktime: UInt64
```

#### vin

array of json objects of incoming txs to be used

``` swift
public var vin: [BtcTxVin]
```

#### vout

array of json objects describing the tx outputs

``` swift
public var vout: [BtcTxVout]
```
### Btctransaction

``` swift
public struct Btctransaction 
```

  - verbose `0` or `false`: a string that is serialized, hex-encoded data for `txid`
  - verbose `1` or `false`: an object representing the transaction.



#### init(txid:in_active_chain:hex:hash:size:vsize:weight:version:locktime:vin:vout:blockhash:confirmations:blocktime:time:)

initialize the Btctransaction

``` swift
public init(txid: String, in_active_chain: Bool? = nil, hex: String, hash: String, size: UInt64, vsize: UInt64, weight: UInt64, version: Int, locktime: UInt64, vin: [BtcTxVin], vout: [BtcTxVout], blockhash: String, confirmations: Int, blocktime: UInt64, time: UInt64) 
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

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(txid:in_active_chain:hex:hash:size:vsize:weight:version:locktime:vin:vout:blockhash:confirmations:blocktime:time:)

initialize the Btctransaction

``` swift
public init(txid: String, in_active_chain: Bool? = nil, hex: String, hash: String, size: UInt64, vsize: UInt64, weight: UInt64, version: Int, locktime: UInt64, vin: [BtcTxVin], vout: [BtcTxVout], blockhash: String, confirmations: Int, blocktime: UInt64, time: UInt64) 
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
public var txid: String
```

#### in_active_chain

Whether specified block is in the active chain or not (only present with explicit "blockhash" argument)

``` swift
public var in_active_chain: Bool?
```

#### hex

The serialized, hex-encoded data for `txid`

``` swift
public var hex: String
```

#### hash

The transaction hash (differs from txid for witness transactions)

``` swift
public var hash: String
```

#### size

The serialized transaction size

``` swift
public var size: UInt64
```

#### vsize

The virtual transaction size (differs from size for witness transactions)

``` swift
public var vsize: UInt64
```

#### weight

The transaction's weight (between `vsize`\*4-3 and `vsize`\*4)

``` swift
public var weight: UInt64
```

#### version

The version

``` swift
public var version: Int
```

#### locktime

The lock time

``` swift
public var locktime: UInt64
```

#### vin

array of json objects of incoming txs to be used

``` swift
public var vin: [BtcTxVin]
```

#### vout

array of json objects describing the tx outputs

``` swift
public var vout: [BtcTxVout]
```

#### blockhash

the block hash

``` swift
public var blockhash: String
```

#### confirmations

The confirmations

``` swift
public var confirmations: Int
```

#### blocktime

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var blocktime: UInt64
```

#### time

Same as "blocktime"

``` swift
public var time: UInt64
```

#### txid

txid

``` swift
public var txid: String
```

#### in_active_chain

Whether specified block is in the active chain or not (only present with explicit "blockhash" argument)

``` swift
public var in_active_chain: Bool?
```

#### hex

The serialized, hex-encoded data for `txid`

``` swift
public var hex: String
```

#### hash

The transaction hash (differs from txid for witness transactions)

``` swift
public var hash: String
```

#### size

The serialized transaction size

``` swift
public var size: UInt64
```

#### vsize

The virtual transaction size (differs from size for witness transactions)

``` swift
public var vsize: UInt64
```

#### weight

The transaction's weight (between `vsize`\*4-3 and `vsize`\*4)

``` swift
public var weight: UInt64
```

#### version

The version

``` swift
public var version: Int
```

#### locktime

The lock time

``` swift
public var locktime: UInt64
```

#### vin

array of json objects of incoming txs to be used

``` swift
public var vin: [BtcTxVin]
```

#### vout

array of json objects describing the tx outputs

``` swift
public var vout: [BtcTxVout]
```

#### blockhash

the block hash

``` swift
public var blockhash: String
```

#### confirmations

The confirmations

``` swift
public var confirmations: Int
```

#### blocktime

The block time in seconds since epoch (Jan 1 1970 GMT)

``` swift
public var blocktime: UInt64
```

#### time

Same as "blocktime"

``` swift
public var time: UInt64
```
### CipherParams

the cipherparams

``` swift
public struct CipherParams 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(iv:)

initialize the CipherParams

``` swift
public init(iv: String) 
```

**Parameters**

  - iv: the iv



#### iv

the iv

``` swift
public var iv: String
```
### CryptoParams

the cryptoparams

``` swift
public struct CryptoParams 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(ciphertext:cipherparams:cipher:kdf:kdfparams:mac:)

initialize the CryptoParams

``` swift
public init(ciphertext: String, cipherparams: CipherParams, cipher: String, kdf: String, kdfparams: KdfParams, mac: String) 
```

**Parameters**

  - ciphertext: the cipher text
  - cipherparams: the cipherparams
  - cipher: the cipher
  - kdf: the kdf
  - kdfparams: the kdfparams
  - mac: the mac



#### ciphertext

the cipher text

``` swift
public var ciphertext: String
```

#### cipherparams

the cipherparams

``` swift
public var cipherparams: CipherParams
```

#### cipher

the cipher

``` swift
public var cipher: String
```

#### kdf

the kdf

``` swift
public var kdf: String
```

#### kdfparams

the kdfparams

``` swift
public var kdfparams: KdfParams
```

#### mac

the mac

``` swift
public var mac: String
```
### DeviceList

json formated list of user registered devices

``` swift
public struct DeviceList 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(device_id:metadata:)

initialize the DeviceList

``` swift
public init(device_id: String, metadata: DeviceMetadata) 
```

  - Parameter device\_id : device uuid

**Parameters**

  - metadata: information about device



#### device_id

device uuid

``` swift
public var device_id: String
```

#### metadata

information about device

``` swift
public var metadata: DeviceMetadata
```
### DeviceMetadata

information about device

``` swift
public struct DeviceMetadata 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(name:type:)

initialize the DeviceMetadata

``` swift
public init(name: String, type: String) 
```

**Parameters**

  - name: device name
  - type: device type



#### name

device name

``` swift
public var name: String
```

#### type

device type

``` swift
public var type: String
```
### ECRecoverResult

the extracted public key and address

``` swift
public struct ECRecoverResult 
```



#### init(publicKey:address:)

initialize the ECRecoverResult

``` swift
public init(publicKey: String, address: String) 
```

**Parameters**

  - publicKey: the public Key of the signer (64 bytes)
  - address: the address

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(publicKey:address:)

initialize the ECRecoverResult

``` swift
public init(publicKey: String, address: String) 
```

**Parameters**

  - publicKey: the public Key of the signer (64 bytes)
  - address: the address



#### publicKey

the public Key of the signer (64 bytes)

``` swift
public var publicKey: String
```

#### address

the address

``` swift
public var address: String
```

#### publicKey

the public Key of the signer (64 bytes)

``` swift
public var publicKey: String
```

#### address

the address

``` swift
public var address: String
```
### EQActivateServiceAttribute

An attribute the user has shared with the service.

``` swift
public struct EQActivateServiceAttribute: Codable 
```



`Codable`



#### attributeName

The internal name of the attribute.

``` swift
public let attributeName: String
```

#### attributeLabel

A displayable user-friendly name for this attribute.

``` swift
public let attributeLabel: String
```

#### attributeId

A unique attribute identifier.

``` swift
public let attributeId: String
```

#### attributeVersion

The current attribute version.

``` swift
public let attributeVersion: String
```

#### attributeVersionHistory

An array listing previous versions.

``` swift
public let attributeVersionHistory: [String]
```

#### consent

Indicates if consent is required or optional.

``` swift
public let consent: Bool
```

#### required

Indicates if this attribute is required or optional.

``` swift
public let required: Bool
```

#### accessEndDate

The date access to this attribute ends, in RFC3339 format.

``` swift
public let accessEndDate: String?
```

#### valueAccessMode

Indicates if this is in value access mode.

``` swift
public let valueAccessMode: Bool
```

#### policies

The list of policies for this attribute.

``` swift
public let policies: [EQActivateServiceAttributePolicy]
```
### EQActivateServiceAttributePolicy

A service attribute policy.

``` swift
public struct EQActivateServiceAttributePolicy: Codable 
```



`Codable`



#### policyName

The internal policy name.

``` swift
public let policyName: String
```

#### policyLabel

A displayable user-friendly policy name.

``` swift
public let policyLabel: String
```

#### policyType

The policy type ("OBLIGATION" or "PERMISSION").

``` swift
public let policyType: String
```

#### description

A displayable user-friendly description of the policy.

``` swift
public let description: String
```

#### response

Indicates if the policy is accepted.

``` swift
public let response: Bool?
```

#### required

Indicates if this policy is required or optional.

``` swift
public let required: Bool
```
### EQActivateServicePolicies

A policy related to the service the user is consuming.

``` swift
public struct EQActivateServicePolicies: Codable 
```



`Codable`



#### policyName

The internal policy name.

``` swift
public let policyName: String
```

#### policyLabel

A displayable user-friendly policy name.

``` swift
public let policyLabel: String
```

#### description

A displayable user-friendly description of the policy.

``` swift
public let description: String
```

#### response

Indicates if the policy is accepted.

``` swift
public let response: Bool
```

#### required

Indicates if this policy is required or optional.

``` swift
public let required: Bool
```
### EQAttribute

A struct for the full pds attribute.

``` swift
public struct EQAttribute: Codable 
```



`Codable`



#### attributeId

A unique attribute identifier.

``` swift
public let attributeId: EQAttributeId
```

#### version

The attribute version.

``` swift
public let version: String
```

#### attributeName

The attribute name.

``` swift
public let attributeName: String
```

#### attributeTypeName

The attribute type.

``` swift
public let attributeTypeName: String
```

#### value

The attribute value.

``` swift
public let value: String?
```

#### attributeLabel

A displayable user-friendly attribute name.

``` swift
public let attributeLabel: String
```

#### proof

The attribute proof.

``` swift
public let proof: String
```

#### proofAlgorithm

The attribute algorithm.

``` swift
public let proofAlgorithm: String
```

#### salt

The cryptographic salt.

``` swift
public let salt: String
```

#### state

The attribute state.

``` swift
public let state: String
```

#### creationDate

The creation date, in RFC 3339 format.

``` swift
public let creationDate: String
```

#### modificationDate

The date of the last modification to this attribute, in RFC 3339 format.

``` swift
public let modificationDate: String
```

#### expirationDate

The date this attribute expires, in RFC 3339 format.

``` swift
public let expirationDate: String
```

#### usedAsProof

Indicates if this attribute is used as proof.

``` swift
public let usedAsProof: Bool
```
### EQAttributeError

A struct for batch errors.

``` swift
public struct EQAttributeError: Codable 
```



`Codable`



#### errorCode

The error code.

``` swift
public let errorCode: String
```

#### message

The error message.

``` swift
public let message: String
```
### EQFileAttribute

A pds file attribute for the user

``` swift
public struct EQFileAttribute: Codable 
```



`Codable`



#### init(attributeName:fileName:fileData:)

Initializer for EQFileAttirbute

``` swift
public init(attributeName: String, fileName: String, fileData: Data) 
```

**Parameters**

  - attributeName: The attribute name (from the schema)
  - fileName: The file's name with extension (.png)
  - fileData: The file's data



#### fileData

The attribute name (from the schema)

``` swift
public let fileData: Data
```

#### attributeName

The file's name with extension (.png)

``` swift
public let attributeName: String
```

#### fileName

The file's data

``` swift
public let fileName: String
```
### EQNewAttribute

Attributes for a Equs user.

``` swift
public struct EQNewAttribute: Codable 
```



`Codable`



#### init(attributeName:value:)

Initializer for EQNewAttribute.

``` swift
public init(attributeName: String, value: String) 
```

**Parameters**

  - attributeName: The attribute name.
  - value: The attribute value.



#### attributeName

The attribute name.

``` swift
public let attributeName: String
```

#### value

The attribute value.

``` swift
public let value: String
```
### EQNewAttributeResponse

Returned by a call to `api/pds/attributes` this
describes the result of adding new attributes.

``` swift
public struct EQNewAttributeResponse: Codable 
```



`Codable`



#### id

A unique identifier.

``` swift
public let id: String?
```

#### attributeName

The attribute name.

``` swift
public let attributeName: String?
```

#### statusCode

The status code.

``` swift
public let statusCode: Int
```

#### error

If an error occurred, this contains the error information.

``` swift
public let error: EQAttributeError?
```
### EQNewFileAttributeResponse

File upload response.

``` swift
public struct EQNewFileAttributeResponse: Codable 
```



`Codable`



#### id

A unique identifier.

``` swift
public let id: EQAttributeId
```
### EQNewPersonaAttribute

A struct used for adding an attribute to a persona.

``` swift
public struct EQNewPersonaAttribute: Codable 
```



`Codable`



#### init(userAttributeId:attributeTypeName:version:)

Initializer for EQNewPersonal Attribute. Used to add an attribute to a persona.

``` swift
public init(userAttributeId: EQAttributeId, attributeTypeName: String, version: Int) 
```

**Parameters**

  - userAttributeId: The attribute's id
  - attributeTypeName: The attributes's type (`'String'`, `'File'`, `'Date'`)
  - version: The attribute's version



#### userAttributeId

The attribute's id

``` swift
public let userAttributeId: EQAttributeId
```

#### attributeTypeName

The attributes's type (`'String'`, `'File'`, `'Date'`)

``` swift
public let attributeTypeName: String
```

#### version

The attribute's version

``` swift
public let version: Int
```
### EQPersona

A persona on a user's PDS

``` swift
public struct EQPersona: Codable 
```



`Codable`



#### personaId

The persona's ID

``` swift
public let personaId: EQPersonaId
```

#### profileName

The persona's name

``` swift
public let profileName: String
```
### EQPersonaAttribute

A perona's attribute

``` swift
public struct EQPersonaAttribute: Codable 
```



`Codable`



#### attributeId

The attirbute's id

``` swift
public let attributeId: EQAttributeId
```

#### userAttributeId

The user attribute id

``` swift
public let userAttributeId: EQAttributeId
```

#### attributeTypeName

The attributes's type (`'String'`, `'File'`, `'Date'`)

``` swift
public let attributeTypeName: String
```

#### version

The attribute's version

``` swift
public let version: Int
```
### EQPersonaService

A service registered for by a persona

``` swift
public struct EQPersonaService: Codable 
```



`Codable`



#### serviceId

The service ID

``` swift
public let serviceId: EQServiceId
```

#### active

Whether or not the service is active

``` swift
public let active: Bool
```

#### userServiceId

The service id that is on the main account object

``` swift
public let userServiceId: String
```

#### serviceDefinitionId

The service Defintion ID

``` swift
public let serviceDefinitionId: String
```
### EQPersonaServiceRegistration

An object for persona service registration

``` swift
public struct EQPersonaServiceRegistration: Codable 
```



`Codable`



#### init(userServiceId:serviceDefinitionId:active:)

Initializer for the persona registration object

``` swift
public init(userServiceId: String, serviceDefinitionId: String, active: Bool = true) 
```

**Parameters**

  - userServiceId: The service of the main user to register
  - serviceDefinitionId: The service definition id
  - active: Whether or not to activate the service



#### userServiceId

The service of the main user to register

``` swift
public let userServiceId: String
```

#### serviceDefinitionId

The service definition id

``` swift
public let serviceDefinitionId: String
```

#### active

Whether or not to activate the service

``` swift
public let active: Bool
```
### EQResponseError

An error from net id server

``` swift
public struct EQResponseError: Codable 
```



`Codable`



#### error

The error object

``` swift
public let error: EQResponseErrorMessage
```

#### statusCode

Service status code

``` swift
public let statusCode: Int
```
### EQResponseErrorMessage

An error message object

``` swift
public struct EQResponseErrorMessage: Codable 
```



`Codable`



#### message

The error message

``` swift
public let message: String?
```

#### errorCode

The error code

``` swift
public let errorCode: String?
```
### EQSDAttribute

An attribute the service definition needs.

``` swift
public struct EQSDAttribute: Codable 
```



`Codable`



#### attributeLabel

The displayable user-friendly attribute name.

``` swift
public let attributeLabel: String
```

#### attributeName

The internal attribute name.

``` swift
public let attributeName: String
```

#### policies

A list of policies used by this attribute.

``` swift
public let policies: [EQSDAttributePolicy]
```

#### required

Indicates if this attribute is required or optional.

``` swift
public let required: Bool
```

#### serviceDefinitionAttributeId

A unique attribute identifier.

``` swift
public let serviceDefinitionAttributeId: String
```
### EQSDAttributePolicy

The attributes and policies requested by the service definition.

``` swift
public struct EQSDAttributePolicy: Codable 
```



`Codable`



#### policyId

A unique policy identifier.

``` swift
public let policyId: String
```

#### policyLabel

The displayable user-friendly policy name.

``` swift
public let policyLabel: String
```

#### policyName

The internal policy name.

``` swift
public let policyName: String
```

#### policyType

The policy type ("OBLIGATION" or "PERMISSION").

``` swift
public let policyType: String
```

#### required

Indicates if this policy is required or optional.

``` swift
public let required: Bool
```
### EQSDAttributeResponse

An object to inform the user's decision on sharing an attribute.

``` swift
public struct EQSDAttributeResponse: Codable 
```



`Codable`



#### init(attributeName:attributeId:policies:)

Initializer

``` swift
public init(attributeName: String, attributeId: String, policies: [EQUserPolicyResponse]) 
```

**Parameters**

  - attributeName: The attribute's name
  - attributeId: The attribute's id
  - policies: The list of reponse's to the policies the attribute will be used under



#### attributeName

The attribute's name.

``` swift
public let attributeName: String
```

#### attributeId

The attribute's id.

``` swift
public let attributeId: String
```

#### policies

The list of reponse's to the policies the attribute will be used under.

``` swift
public let policies: [EQUserPolicyResponse]
```
### EQSDDataProcessingOfficer

The service definition data processing officer.

``` swift
public struct EQSDDataProcessingOfficer: Codable 
```



`Codable`



#### contactEmail

The officer's email address.

``` swift
public let contactEmail: String
```

#### contactPhoneNumber

The officer's phone number.

``` swift
public let contactPhoneNumber: String
```

#### firstName

The officer's first name.

``` swift
public let firstName: String
```

#### lastName

The officer's last name.

``` swift
public let lastName: String
```
### EQSDDataProcessingRole

The service definition data processing role.

``` swift
public struct EQSDDataProcessingRole: Codable 
```



`Codable`



#### role

Indicates the role of the data processor.

``` swift
public let role: String
```
### EQSDPolicy

The policies for the service definition.

``` swift
public struct EQSDPolicy: Codable 
```



`Codable`



#### description

A displayable user-friendly description of the policy.

``` swift
public let description: String
```

#### policyId

A unique policy identifier.

``` swift
public let policyId: String
```

#### policyLabel

The displayable user-friendly policy name.

``` swift
public let policyLabel: String
```

#### policyName

The internal policy name.

``` swift
public let policyName: String
```

#### required

Indicates if the policy is required or optional.

``` swift
public let required: Bool
```
### EQSDProcessingTime

The amount of time the service takes for processing.

``` swift
public struct EQSDProcessingTime: Codable 
```



`Codable`



#### postProcessingStoragePeriod

The post processing storage period, in days.

``` swift
public let postProcessingStoragePeriod: String
```

#### processingPeriod

The processing period, in days.

``` swift
public let processingPeriod: String
```
### EQSDProviderDefinition

The service provider providing the service definition.

``` swift
public struct EQSDProviderDefinition: Codable 
```



`Codable`



#### serviceProviderId

A unique service provider identifier.

``` swift
public let serviceProviderId: String
```

#### serviceProviderLogo

A URL to the service provider's logo graphic.

``` swift
public let serviceProviderLogo: String
```

#### serviceProviderName

The displayable user-friendly service provider name.

``` swift
public let serviceProviderName: String
```

#### serviceProviderUrl

A URL to the service provider's website.

``` swift
public let serviceProviderUrl: String
```
### EQSDValidationDefinition

The definition of the validation for the service.

``` swift
public struct EQSDValidationDefinition: Codable 
```



`Codable`



#### price

The price, in US dollars.

``` swift
public let price: String
```

#### trustedParty

The trusted party associated with this validation.

``` swift
public let trustedParty: EQSDValidationDefinitionTrustedParty
```

#### validationDefinitionId

A unique validation definition identifier.

``` swift
public let validationDefinitionId: String
```

#### validationDefinitionName

A displayable user-friendly validation definition name.

``` swift
public let validationDefinitionName: String
```
### EQSDValidationDefinitionTrustedParty

The trusted party defining the validation definition.

``` swift
public struct EQSDValidationDefinitionTrustedParty: Codable 
```



`Codable`



#### trustedPartyId

A unique trusted party identifier.

``` swift
public let trustedPartyId: String
```

#### trustedPartyLogo

A URL to the trusted party's logo graphic.

``` swift
public let trustedPartyLogo: String
```

#### trustedPartyName

A displayable user-friendly trusted party name.

``` swift
public let trustedPartyName: String
```

#### trustedPartyUrl

A URL to the trusted party's website.

``` swift
public let trustedPartyUrl: String
```
### EQSchemaAttribute

Represents a single piece of information associated with the
signed in user (i.e. first name, bank account number, photo id, etc.)

``` swift
public struct EQSchemaAttribute: Codable 
```



`Codable`



#### name

The internal attribute name.

``` swift
public let name: String
```

#### label

The displayable user-friendly attribute name.

``` swift
public let label: String
```

#### dataType

The data type defined by this attribute ("String", "Date", "File", or "Linked Data").

``` swift
public let dataType: String
```

#### encrypted

Indicates if the data associated with this attribute is encrypted.

``` swift
public let encrypted: Bool
```

#### hint

A human readable description of the attribute.

``` swift
public let hint: String
```

#### state

The current state of the attribute ("ACTIVE" or "PENDING-DELETION").

``` swift
public let state: String
```

#### tags

An array of `String` values used to group related attributes.

``` swift
public let tags: [String]?
```
### EQServiceDefinition

The service definition provided by a service provider.
All `ServiceDefintion` related attributes are prefaced with `EQSD`

``` swift
public struct EQServiceDefinition: Codable 
```



`Codable`



#### attributes

A list of attributes that define the service.

``` swift
public let attributes: [EQSDAttribute]
```

#### creationDate

The date this service was created, in RFC 3339 format.

``` swift
public let creationDate: String
```

#### customerInstanceLimit

The number of times this service can be associated with a customer. For
example, a customer can have more than one bank account. A value of
zero (0) indicates no limit.

``` swift
public let customerInstanceLimit: Int
```

#### createdByIdentityId

The unique identifier of the creating identity.

``` swift
public let createdByIdentityId: String
```

#### dataProcessingOfficer

The data processing officer for this service.

``` swift
public let dataProcessingOfficer: EQSDDataProcessingOfficer
```

#### dataProcessingRole

The role of the data processor.

``` swift
public let dataProcessingRole: EQSDDataProcessingRole
```

#### description

A displayable user-friendly description of the service.

``` swift
public let description: String
```

#### logo

A URL to the service's logo graphic.

``` swift
public let logo: String
```

#### modificationDate

The date of the last modification to this service definition, in RFC 3339 format.

``` swift
public let modificationDate: String
```

#### modifiedBy

The unique identifier of the modifying identity.

``` swift
public let modifiedBy: String
```

#### name

A displayable user-friendly service name.

``` swift
public let name: String
```

#### policies

The list of policies used by this service.

``` swift
public let policies: [EQSDPolicy]
```

#### processingTime

Processing time definitions for this service.

``` swift
public let processingTime: EQSDProcessingTime
```

#### serviceDefinitionId

A unique identifier for this service definition.

``` swift
public let serviceDefinitionId: String
```

#### serviceProvider

The service provider information.

``` swift
public let serviceProvider: EQSDProviderDefinition
```

#### stateLabel

The current state of this service in a displayable user-friendly format.

``` swift
public let stateLabel: String
```

#### stateName

The current state of this service ("ACTIVE", "INACTIVE", "TERMINATED", "PENDING-TERMINATION", and "DRAFT").

``` swift
public let stateName: String
```

#### validationDefinitions

The validation definitions for this service.

``` swift
public let validationDefinitions: [EQSDValidationDefinition]
```

#### version

The service version.

``` swift
public let version: String
```
### EQTokenResponse

A struct to get the token off of a valid register/login request

``` swift
public struct EQTokenResponse: Codable 
```



`Codable`
### EQUserPolicyResponse

An object to inform the user's decision on a policy.

``` swift
public struct EQUserPolicyResponse: Codable 
```



`Codable`



#### init(policyName:response:)

Initializer

``` swift
public init(policyName: String, response: Bool) 
```

**Parameters**

  - policyName: The policy's name
  - response: The user's response to whether or not they accept the policies



#### policyName

The policy's name.

``` swift
public let policyName: String
```

#### response

The user's response to whether or not they accept the policies.

``` swift
public let response: Bool
```
### EQUserService

Returned by a call to `api/pds/services/<service id>`, this
describes a single service the signed in user is consuming.

``` swift
public struct EQUserService: Codable 
```



`Codable`



#### id

A unique service identifier.

``` swift
public let id: String
```

#### serviceDefinitionId

A unique service definition identifier.

``` swift
public let serviceDefinitionId: String
```

#### serviceProvider

Information regarding the service provider.

``` swift
public let serviceProvider: EQSDProviderDefinition
```

#### customerDisplayName

The customer's name displayed to the service provider

``` swift
public let customerDisplayName: String
```

#### state

The current state of the service ("ACTIVE", "INACTIVE", "TERMINATED", "PENDING-TERMINATION", "DRAFT").

``` swift
public let state: String
```

#### creationDate

The date this service was created, in RFC 3339 format.

``` swift
public let creationDate: String
```

#### modificationDate

The date this service was last modified, in RFC 3339 format.

``` swift
public let modificationDate: String
```

#### expirationDate

The date this service expires, in RFC 3339 format.

``` swift
public let expirationDate: String?
```

#### postProcessingEndDate

The date post processing for this service ends, in RFC 3339 format.

``` swift
public let postProcessingEndDate: String?
```

#### initialServiceActivationDate

The date this service was initially activated, in RFC 3339 format.

``` swift
public let initialServiceActivationDate: String?
```

#### attributes

The list of attributes the signed in user has shared with this service.

``` swift
public let attributes: [EQActivateServiceAttribute]
```

#### policies

The list of policies for this service.

``` swift
public let policies: [EQActivateServicePolicies]
```
### EQUserServiceSummary

A summary of a service the signed in user is consuming.

``` swift
public struct EQUserServiceSummary: Codable 
```



`Codable`



#### serviceId

A unique service identifier.

``` swift
public let serviceId: String
```

#### serviceDefinitionId

A unique service definition identifier.

``` swift
public let serviceDefinitionId: String
```

#### serviceDefinitionVersion

The service definition version.

``` swift
public let serviceDefinitionVersion: String
```

#### serviceDefinitionName

A displayable user-friendly service definition name.

``` swift
public let serviceDefinitionName: String
```

#### serviceDefinitionDescription

A displayable user-friendly description.

``` swift
public let serviceDefinitionDescription: String
```

#### serviceProvider

Information regarding the service provider.

``` swift
public let serviceProvider: EQSDProviderDefinition
```

#### state

The current state of the service ("ACTIVE", "INACTIVE", "TERMINATED", "PENDING-TERMINATION", "DRAFT").

``` swift
public let state: String
```

#### expirationDate

The date this service expires, in RFC 3339 format.

``` swift
public let expirationDate: String?
```

#### postProcessingEndDate

The date post processing for this service ends, in RFC 3339 format.

``` swift
public let postProcessingEndDate: String?
```

#### initialServiceActivationDate

The date this service was initially activated, in RFC 3339 format.

``` swift
public let initialServiceActivationDate: String?
```

#### logo

A URL to this service's logo graphic.

``` swift
public let logo: String
```
### EditUser

The user update result

``` swift
public struct EditUser 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(signature:status:)

initialize the EditUser

``` swift
public init(signature: VaultSignature, status: String) 
```

**Parameters**

  - signature: signature for policy content
  - status: a enum for status of sending token as `sent`, `error` or `invalidTarget`



#### signature

signature for policy content

``` swift
public var signature: VaultSignature
```

#### status

a enum for status of sending token as `sent`, `error` or `invalidTarget`

``` swift
public var status: String
```
### EthBlockdata

the blockdata, or in case the block with that number does not exist, `null` will be returned.

``` swift
public struct EthBlockdata 
```



#### init(transactions:number:hash:parentHash:nonce:sha3Uncles:logsBloom:transactionsRoot:stateRoot:receiptsRoot:miner:difficulty:totalDifficulty:extraData:size:gasLimit:gasUsed:timestamp:uncles:baseFeePerGas:)

initialize the EthBlockdata

``` swift
public init(transactions: [EthTransactiondata], number: UInt64, hash: String, parentHash: String, nonce: UInt256? = nil, sha3Uncles: String, logsBloom: String, transactionsRoot: String, stateRoot: String, receiptsRoot: String, miner: String, difficulty: UInt256, totalDifficulty: UInt256, extraData: String, size: UInt64, gasLimit: UInt64, gasUsed: UInt64, timestamp: UInt64, uncles: [String], baseFeePerGas: UInt64? = nil) 
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
  - baseFeePerGas: block fees based on EIP 1559 starting with the London hard fork

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(transactions:number:hash:parentHash:nonce:sha3Uncles:logsBloom:transactionsRoot:stateRoot:receiptsRoot:miner:difficulty:totalDifficulty:extraData:size:gasLimit:gasUsed:timestamp:uncles:baseFeePerGas:)

initialize the EthBlockdata

``` swift
public init(transactions: [EthTransactiondata], number: UInt64, hash: String, parentHash: String, nonce: UInt256? = nil, sha3Uncles: String, logsBloom: String, transactionsRoot: String, stateRoot: String, receiptsRoot: String, miner: String, difficulty: UInt256, totalDifficulty: UInt256, extraData: String, size: UInt64, gasLimit: UInt64, gasUsed: UInt64, timestamp: UInt64, uncles: [String], baseFeePerGas: UInt64? = nil) 
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
  - baseFeePerGas: block fees based on EIP 1559 starting with the London hard fork



#### transactions

Array of transaction objects

``` swift
public var transactions: [EthTransactiondata]
```

#### number

the block number. `null` when its pending block.

``` swift
public var number: UInt64
```

#### hash

hash of the block. `null` when its pending block.

``` swift
public var hash: String
```

#### parentHash

hash of the parent block.

``` swift
public var parentHash: String
```

#### nonce

hash of the generated proof-of-work. `null` when its pending block.

``` swift
public var nonce: UInt256?
```

#### sha3Uncles

SHA3 of the uncles Merkle root in the block.

``` swift
public var sha3Uncles: String
```

#### logsBloom

the bloom filter for the logs of the block. `null` when its pending block.

``` swift
public var logsBloom: String
```

#### transactionsRoot

the root of the transaction trie of the block.

``` swift
public var transactionsRoot: String
```

#### stateRoot

the root of the final state trie of the block.

``` swift
public var stateRoot: String
```

#### receiptsRoot

the root of the receipts trie of the block.

``` swift
public var receiptsRoot: String
```

#### miner

the address of the beneficiary to whom the mining rewards were given.

``` swift
public var miner: String
```

#### difficulty

integer of the difficulty for this block.

``` swift
public var difficulty: UInt256
```

#### totalDifficulty

integer of the total difficulty of the chain until this block.

``` swift
public var totalDifficulty: UInt256
```

#### extraData

the "extra data" field of this block.

``` swift
public var extraData: String
```

#### size

integer the size of this block in bytes.

``` swift
public var size: UInt64
```

#### gasLimit

the maximum gas allowed in this block.

``` swift
public var gasLimit: UInt64
```

#### gasUsed

the total used gas by all transactions in this block.

``` swift
public var gasUsed: UInt64
```

#### timestamp

the unix timestamp for when the block was collated.

``` swift
public var timestamp: UInt64
```

#### uncles

Array of uncle hashes.

``` swift
public var uncles: [String]
```

#### baseFeePerGas

block fees based on EIP 1559 starting with the London hard fork

``` swift
public var baseFeePerGas: UInt64?
```

#### transactions

Array of transaction objects

``` swift
public var transactions: [EthTransactiondata]
```

#### number

the block number. `null` when its pending block.

``` swift
public var number: UInt64
```

#### hash

hash of the block. `null` when its pending block.

``` swift
public var hash: String
```

#### parentHash

hash of the parent block.

``` swift
public var parentHash: String
```

#### nonce

hash of the generated proof-of-work. `null` when its pending block.

``` swift
public var nonce: UInt256?
```

#### sha3Uncles

SHA3 of the uncles Merkle root in the block.

``` swift
public var sha3Uncles: String
```

#### logsBloom

the bloom filter for the logs of the block. `null` when its pending block.

``` swift
public var logsBloom: String
```

#### transactionsRoot

the root of the transaction trie of the block.

``` swift
public var transactionsRoot: String
```

#### stateRoot

the root of the final state trie of the block.

``` swift
public var stateRoot: String
```

#### receiptsRoot

the root of the receipts trie of the block.

``` swift
public var receiptsRoot: String
```

#### miner

the address of the beneficiary to whom the mining rewards were given.

``` swift
public var miner: String
```

#### difficulty

integer of the difficulty for this block.

``` swift
public var difficulty: UInt256
```

#### totalDifficulty

integer of the total difficulty of the chain until this block.

``` swift
public var totalDifficulty: UInt256
```

#### extraData

the "extra data" field of this block.

``` swift
public var extraData: String
```

#### size

integer the size of this block in bytes.

``` swift
public var size: UInt64
```

#### gasLimit

the maximum gas allowed in this block.

``` swift
public var gasLimit: UInt64
```

#### gasUsed

the total used gas by all transactions in this block.

``` swift
public var gasUsed: UInt64
```

#### timestamp

the unix timestamp for when the block was collated.

``` swift
public var timestamp: UInt64
```

#### uncles

Array of uncle hashes.

``` swift
public var uncles: [String]
```

#### baseFeePerGas

block fees based on EIP 1559 starting with the London hard fork

``` swift
public var baseFeePerGas: UInt64?
```
### EthBlockdataWithTxHashes

the blockdata, or in case the block with that number does not exist, `null` will be returned.

``` swift
public struct EthBlockdataWithTxHashes 
```



#### init(transactions:number:hash:parentHash:nonce:sha3Uncles:logsBloom:transactionsRoot:stateRoot:receiptsRoot:miner:difficulty:totalDifficulty:extraData:size:gasLimit:gasUsed:timestamp:uncles:baseFeePerGas:)

initialize the EthBlockdataWithTxHashes

``` swift
public init(transactions: [String], number: UInt64, hash: String, parentHash: String, nonce: UInt256? = nil, sha3Uncles: String, logsBloom: String, transactionsRoot: String, stateRoot: String, receiptsRoot: String, miner: String, difficulty: UInt256, totalDifficulty: UInt256, extraData: String, size: UInt64, gasLimit: UInt64, gasUsed: UInt64, timestamp: UInt64, uncles: [String], baseFeePerGas: UInt64? = nil) 
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
  - baseFeePerGas: block fees based on EIP 1559 starting with the London hard fork

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(transactions:number:hash:parentHash:nonce:sha3Uncles:logsBloom:transactionsRoot:stateRoot:receiptsRoot:miner:difficulty:totalDifficulty:extraData:size:gasLimit:gasUsed:timestamp:uncles:baseFeePerGas:)

initialize the EthBlockdataWithTxHashes

``` swift
public init(transactions: [String], number: UInt64, hash: String, parentHash: String, nonce: UInt256? = nil, sha3Uncles: String, logsBloom: String, transactionsRoot: String, stateRoot: String, receiptsRoot: String, miner: String, difficulty: UInt256, totalDifficulty: UInt256, extraData: String, size: UInt64, gasLimit: UInt64, gasUsed: UInt64, timestamp: UInt64, uncles: [String], baseFeePerGas: UInt64? = nil) 
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
  - baseFeePerGas: block fees based on EIP 1559 starting with the London hard fork



#### transactions

Array of transaction hashes

``` swift
public var transactions: [String]
```

#### number

the block number. `null` when its pending block.

``` swift
public var number: UInt64
```

#### hash

hash of the block. `null` when its pending block.

``` swift
public var hash: String
```

#### parentHash

hash of the parent block.

``` swift
public var parentHash: String
```

#### nonce

hash of the generated proof-of-work. `null` when its pending block.

``` swift
public var nonce: UInt256?
```

#### sha3Uncles

SHA3 of the uncles Merkle root in the block.

``` swift
public var sha3Uncles: String
```

#### logsBloom

the bloom filter for the logs of the block. `null` when its pending block.

``` swift
public var logsBloom: String
```

#### transactionsRoot

the root of the transaction trie of the block.

``` swift
public var transactionsRoot: String
```

#### stateRoot

the root of the final state trie of the block.

``` swift
public var stateRoot: String
```

#### receiptsRoot

the root of the receipts trie of the block.

``` swift
public var receiptsRoot: String
```

#### miner

the address of the beneficiary to whom the mining rewards were given.

``` swift
public var miner: String
```

#### difficulty

integer of the difficulty for this block.

``` swift
public var difficulty: UInt256
```

#### totalDifficulty

integer of the total difficulty of the chain until this block.

``` swift
public var totalDifficulty: UInt256
```

#### extraData

the "extra data" field of this block.

``` swift
public var extraData: String
```

#### size

integer the size of this block in bytes.

``` swift
public var size: UInt64
```

#### gasLimit

the maximum gas allowed in this block.

``` swift
public var gasLimit: UInt64
```

#### gasUsed

the total used gas by all transactions in this block.

``` swift
public var gasUsed: UInt64
```

#### timestamp

the unix timestamp for when the block was collated.

``` swift
public var timestamp: UInt64
```

#### uncles

Array of uncle hashes.

``` swift
public var uncles: [String]
```

#### baseFeePerGas

block fees based on EIP 1559 starting with the London hard fork

``` swift
public var baseFeePerGas: UInt64?
```

#### transactions

Array of transaction hashes

``` swift
public var transactions: [String]
```

#### number

the block number. `null` when its pending block.

``` swift
public var number: UInt64
```

#### hash

hash of the block. `null` when its pending block.

``` swift
public var hash: String
```

#### parentHash

hash of the parent block.

``` swift
public var parentHash: String
```

#### nonce

hash of the generated proof-of-work. `null` when its pending block.

``` swift
public var nonce: UInt256?
```

#### sha3Uncles

SHA3 of the uncles Merkle root in the block.

``` swift
public var sha3Uncles: String
```

#### logsBloom

the bloom filter for the logs of the block. `null` when its pending block.

``` swift
public var logsBloom: String
```

#### transactionsRoot

the root of the transaction trie of the block.

``` swift
public var transactionsRoot: String
```

#### stateRoot

the root of the final state trie of the block.

``` swift
public var stateRoot: String
```

#### receiptsRoot

the root of the receipts trie of the block.

``` swift
public var receiptsRoot: String
```

#### miner

the address of the beneficiary to whom the mining rewards were given.

``` swift
public var miner: String
```

#### difficulty

integer of the difficulty for this block.

``` swift
public var difficulty: UInt256
```

#### totalDifficulty

integer of the total difficulty of the chain until this block.

``` swift
public var totalDifficulty: UInt256
```

#### extraData

the "extra data" field of this block.

``` swift
public var extraData: String
```

#### size

integer the size of this block in bytes.

``` swift
public var size: UInt64
```

#### gasLimit

the maximum gas allowed in this block.

``` swift
public var gasLimit: UInt64
```

#### gasUsed

the total used gas by all transactions in this block.

``` swift
public var gasUsed: UInt64
```

#### timestamp

the unix timestamp for when the block was collated.

``` swift
public var timestamp: UInt64
```

#### uncles

Array of uncle hashes.

``` swift
public var uncles: [String]
```

#### baseFeePerGas

block fees based on EIP 1559 starting with the London hard fork

``` swift
public var baseFeePerGas: UInt64?
```
### EthEvent

``` swift
public struct EthEvent 
```



#### log

``` swift
public var log:Ethlog
```

#### event

``` swift
public var event:String
```

#### values

``` swift
public var values:[String:AnyObject]
```

#### log

``` swift
public var log:Ethlog
```

#### event

``` swift
public var event:String
```

#### values

``` swift
public var values:[String:AnyObject]
```
### EthLogFilter

The filter criteria for the events.

``` swift
public struct EthLogFilter 
```



#### init(fromBlock:toBlock:address:topics:blockhash:)

initialize the EthLogFilter

``` swift
public init(fromBlock: UInt64? = nil, toBlock: UInt64? = nil, address: String? = nil, topics: [String?]? = nil, blockhash: String? = nil) 
```

**Parameters**

  - fromBlock: Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.
  - toBlock: Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.
  - address: Contract address or a list of addresses from which logs should originate.
  - topics: Array of 32 Bytes DATA topics. Topics are order-dependent. Each topic can also be an array of DATA with “or” options.
  - blockhash: With the addition of EIP-234, blockHash will be a new filter option which restricts the logs returned to the single block with the 32-byte hash blockHash. Using blockHash is equivalent to fromBlock = toBlock = the block number with hash blockHash. If blockHash is present in in the filter criteria, then neither fromBlock nor toBlock are allowed.

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(fromBlock:toBlock:address:topics:blockhash:)

initialize the EthLogFilter

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
public var fromBlock: UInt64?
```

#### toBlock

Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.

``` swift
public var toBlock: UInt64?
```

#### address

Contract address or a list of addresses from which logs should originate.

``` swift
public var address: String?
```

#### topics

Array of 32 Bytes DATA topics. Topics are order-dependent. Each topic can also be an array of DATA with “or” options.

``` swift
public var topics: [String?]?
```

#### blockhash

With the addition of EIP-234, blockHash will be a new filter option which restricts the logs returned to the single block with the 32-byte hash blockHash. Using blockHash is equivalent to fromBlock = toBlock = the block number with hash blockHash. If blockHash is present in in the filter criteria, then neither fromBlock nor toBlock are allowed.

``` swift
public var blockhash: String?
```

#### fromBlock

Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.

``` swift
public var fromBlock: UInt64?
```

#### toBlock

Integer block number, or "latest" for the last mined block or "pending", "earliest" for not yet mined transactions.

``` swift
public var toBlock: UInt64?
```

#### address

Contract address or a list of addresses from which logs should originate.

``` swift
public var address: String?
```

#### topics

Array of 32 Bytes DATA topics. Topics are order-dependent. Each topic can also be an array of DATA with “or” options.

``` swift
public var topics: [String?]?
```

#### blockhash

With the addition of EIP-234, blockHash will be a new filter option which restricts the logs returned to the single block with the 32-byte hash blockHash. Using blockHash is equivalent to fromBlock = toBlock = the block number with hash blockHash. If blockHash is present in in the filter criteria, then neither fromBlock nor toBlock are allowed.

``` swift
public var blockhash: String?
```
### EthTransaction

the transactiondata to send

``` swift
public struct EthTransaction 
```



#### init(to:from:wallet:value:gas:gasPrice:nonce:data:signatures:)

initialize the EthTransaction

``` swift
public init(to: String? = nil, from: String? = nil, wallet: String? = nil, value: UInt256? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil, nonce: UInt64? = nil, data: String? = nil, signatures: String? = nil) 
```

**Parameters**

  - to: receipient of the transaction.
  - from: sender of the address (if not sepcified, the first signer will be the sender)
  - wallet: if specified, the transaction will be send through the specified wallet.
  - value: value in wei to send
  - gas: the gas to be send along
  - gasPrice: the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`
  - nonce: the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`
  - data: the data-section of the transaction
  - signatures: additional signatures which should be used when sending through a multisig

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(to:from:wallet:value:gas:gasPrice:nonce:data:signatures:)

initialize the EthTransaction

``` swift
public init(to: String? = nil, from: String? = nil, wallet: String? = nil, value: UInt256? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil, nonce: UInt64? = nil, data: String? = nil, signatures: String? = nil) 
```

**Parameters**

  - to: receipient of the transaction.
  - from: sender of the address (if not sepcified, the first signer will be the sender)
  - wallet: if specified, the transaction will be send through the specified wallet.
  - value: value in wei to send
  - gas: the gas to be send along
  - gasPrice: the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`
  - nonce: the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`
  - data: the data-section of the transaction
  - signatures: additional signatures which should be used when sending through a multisig



#### to

receipient of the transaction.

``` swift
public var to: String?
```

#### from

sender of the address (if not sepcified, the first signer will be the sender)

``` swift
public var from: String?
```

#### wallet

if specified, the transaction will be send through the specified wallet.

``` swift
public var wallet: String?
```

#### value

value in wei to send

``` swift
public var value: UInt256?
```

#### gas

the gas to be send along

``` swift
public var gas: UInt64?
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
public var gasPrice: UInt64?
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
public var nonce: UInt64?
```

#### data

the data-section of the transaction

``` swift
public var data: String?
```

#### signatures

additional signatures which should be used when sending through a multisig

``` swift
public var signatures: String?
```

#### to

receipient of the transaction.

``` swift
public var to: String?
```

#### from

sender of the address (if not sepcified, the first signer will be the sender)

``` swift
public var from: String?
```

#### wallet

if specified, the transaction will be send through the specified wallet.

``` swift
public var wallet: String?
```

#### value

value in wei to send

``` swift
public var value: UInt256?
```

#### gas

the gas to be send along

``` swift
public var gas: UInt64?
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
public var gasPrice: UInt64?
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
public var nonce: UInt64?
```

#### data

the data-section of the transaction

``` swift
public var data: String?
```

#### signatures

additional signatures which should be used when sending through a multisig

``` swift
public var signatures: String?
```
### EthTransactionReceipt

the transactionReceipt

``` swift
public struct EthTransactionReceipt 
```



#### init(blockNumber:blockHash:contractAddress:cumulativeGasUsed:gasUsed:effectiveGasPrice:logs:logsBloom:status:transactionHash:transactionIndex:from:type:to:)

initialize the EthTransactionReceipt

``` swift
public init(blockNumber: UInt64, blockHash: String, contractAddress: String? = nil, cumulativeGasUsed: UInt64, gasUsed: UInt64, effectiveGasPrice: UInt256? = nil, logs: [Ethlog], logsBloom: String, status: Int, transactionHash: String, transactionIndex: Int, from: String, type: Int? = nil, to: String? = nil) 
```

**Parameters**

  - blockNumber: the blockNumber
  - blockHash: blockhash if ther containing block
  - contractAddress: the deployed contract in case the tx did deploy a new contract
  - cumulativeGasUsed: gas used for all transaction up to this one in the block
  - gasUsed: gas used by this transaction.
  - effectiveGasPrice: the efficte gas price
  - logs: array of events created during execution of the tx
  - logsBloom: bloomfilter used to detect events for `eth_getLogs`
  - status: error-status of the tx.  0x1 = success 0x0 = failure
  - transactionHash: requested transactionHash
  - transactionIndex: transactionIndex within the containing block.
  - from: address of the sender.
  - type: the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)
  - to: address of the receiver. null when its a contract creation transaction.

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(blockNumber:blockHash:contractAddress:cumulativeGasUsed:gasUsed:effectiveGasPrice:logs:logsBloom:status:transactionHash:transactionIndex:from:type:to:)

initialize the EthTransactionReceipt

``` swift
public init(blockNumber: UInt64, blockHash: String, contractAddress: String? = nil, cumulativeGasUsed: UInt64, gasUsed: UInt64, effectiveGasPrice: UInt256? = nil, logs: [Ethlog], logsBloom: String, status: Int, transactionHash: String, transactionIndex: Int, from: String, type: Int? = nil, to: String? = nil) 
```

**Parameters**

  - blockNumber: the blockNumber
  - blockHash: blockhash if ther containing block
  - contractAddress: the deployed contract in case the tx did deploy a new contract
  - cumulativeGasUsed: gas used for all transaction up to this one in the block
  - gasUsed: gas used by this transaction.
  - effectiveGasPrice: the efficte gas price
  - logs: array of events created during execution of the tx
  - logsBloom: bloomfilter used to detect events for `eth_getLogs`
  - status: error-status of the tx.  0x1 = success 0x0 = failure
  - transactionHash: requested transactionHash
  - transactionIndex: transactionIndex within the containing block.
  - from: address of the sender.
  - type: the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)
  - to: address of the receiver. null when its a contract creation transaction.



#### blockNumber

the blockNumber

``` swift
public var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
public var blockHash: String
```

#### contractAddress

the deployed contract in case the tx did deploy a new contract

``` swift
public var contractAddress: String?
```

#### cumulativeGasUsed

gas used for all transaction up to this one in the block

``` swift
public var cumulativeGasUsed: UInt64
```

#### gasUsed

gas used by this transaction.

``` swift
public var gasUsed: UInt64
```

#### effectiveGasPrice

the efficte gas price

``` swift
public var effectiveGasPrice: UInt256?
```

#### logs

array of events created during execution of the tx

``` swift
public var logs: [Ethlog]
```

#### logsBloom

bloomfilter used to detect events for `eth_getLogs`

``` swift
public var logsBloom: String
```

#### status

error-status of the tx.  0x1 = success 0x0 = failure

``` swift
public var status: Int
```

#### transactionHash

requested transactionHash

``` swift
public var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
public var transactionIndex: Int
```

#### from

address of the sender.

``` swift
public var from: String
```

#### type

the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)

``` swift
public var type: Int?
```

#### to

address of the receiver. null when its a contract creation transaction.

``` swift
public var to: String?
```

#### blockNumber

the blockNumber

``` swift
public var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
public var blockHash: String
```

#### contractAddress

the deployed contract in case the tx did deploy a new contract

``` swift
public var contractAddress: String?
```

#### cumulativeGasUsed

gas used for all transaction up to this one in the block

``` swift
public var cumulativeGasUsed: UInt64
```

#### gasUsed

gas used by this transaction.

``` swift
public var gasUsed: UInt64
```

#### effectiveGasPrice

the efficte gas price

``` swift
public var effectiveGasPrice: UInt256?
```

#### logs

array of events created during execution of the tx

``` swift
public var logs: [Ethlog]
```

#### logsBloom

bloomfilter used to detect events for `eth_getLogs`

``` swift
public var logsBloom: String
```

#### status

error-status of the tx.  0x1 = success 0x0 = failure

``` swift
public var status: Int
```

#### transactionHash

requested transactionHash

``` swift
public var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
public var transactionIndex: Int
```

#### from

address of the sender.

``` swift
public var from: String
```

#### type

the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)

``` swift
public var type: Int?
```

#### to

address of the receiver. null when its a contract creation transaction.

``` swift
public var to: String?
```
### EthTransactiondata

Array of transaction objects

``` swift
public struct EthTransactiondata 
```



#### init(to:from:value:gas:gasPrice:nonce:blockHash:blockNumber:hash:input:transactionIndex:v:r:s:accessList:type:chainId:maxFeePerGas:maxPriorityFeePerGas:)

initialize the EthTransactiondata

``` swift
public init(to: String, from: String, value: UInt256, gas: UInt64, gasPrice: UInt64, nonce: UInt64, blockHash: String, blockNumber: UInt64, hash: String, input: String, transactionIndex: UInt64, v: String, r: String, s: String, accessList: [EthTxAccessList]? = nil, type: Int? = nil, chainId: UInt64? = nil, maxFeePerGas: UInt64? = nil, maxPriorityFeePerGas: UInt64? = nil) 
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
  - accessList: the list of storage keys accesses as defined in EIP-2930 transactions of type 0x1 or 0x2. Will only be included if the type\>0
  - type: the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)
  - chainId: the chainId the transaction is to operate on.
  - maxFeePerGas: the max Fee gas as defined in EIP-1559
  - maxPriorityFeePerGas: the max priority Fee gas as defined in EIP-1559

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(to:from:value:gas:gasPrice:nonce:blockHash:blockNumber:hash:input:transactionIndex:v:r:s:accessList:type:chainId:maxFeePerGas:maxPriorityFeePerGas:)

initialize the EthTransactiondata

``` swift
public init(to: String, from: String, value: UInt256, gas: UInt64, gasPrice: UInt64, nonce: UInt64, blockHash: String, blockNumber: UInt64, hash: String, input: String, transactionIndex: UInt64, v: String, r: String, s: String, accessList: [EthTxAccessList]? = nil, type: Int? = nil, chainId: UInt64? = nil, maxFeePerGas: UInt64? = nil, maxPriorityFeePerGas: UInt64? = nil) 
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
  - accessList: the list of storage keys accesses as defined in EIP-2930 transactions of type 0x1 or 0x2. Will only be included if the type\>0
  - type: the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)
  - chainId: the chainId the transaction is to operate on.
  - maxFeePerGas: the max Fee gas as defined in EIP-1559
  - maxPriorityFeePerGas: the max priority Fee gas as defined in EIP-1559



#### to

receipient of the transaction.

``` swift
public var to: String
```

#### from

sender or signer of the transaction

``` swift
public var from: String
```

#### value

value in wei to send

``` swift
public var value: UInt256
```

#### gas

the gas to be send along

``` swift
public var gas: UInt64
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
public var gasPrice: UInt64
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
public var nonce: UInt64
```

#### blockHash

blockHash of the block holding this transaction or `null` if still pending.

``` swift
public var blockHash: String
```

#### blockNumber

blockNumber of the block holding this transaction or `null` if still pending.

``` swift
public var blockNumber: UInt64
```

#### hash

transactionHash

``` swift
public var hash: String
```

#### input

data of the transaaction

``` swift
public var input: String
```

#### transactionIndex

index of the transaaction in the block

``` swift
public var transactionIndex: UInt64
```

#### v

recovery-byte of the signature

``` swift
public var v: String
```

#### r

x-value of the EC-Point of the signature

``` swift
public var r: String
```

#### s

y-value of the EC-Point of the signature

``` swift
public var s: String
```

#### accessList

the list of storage keys accesses as defined in EIP-2930 transactions of type 0x1 or 0x2. Will only be included if the type\>0

``` swift
public var accessList: [EthTxAccessList]?
```

#### type

the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)

``` swift
public var type: Int?
```

#### chainId

the chainId the transaction is to operate on.

``` swift
public var chainId: UInt64?
```

#### maxFeePerGas

the max Fee gas as defined in EIP-1559

``` swift
public var maxFeePerGas: UInt64?
```

#### maxPriorityFeePerGas

the max priority Fee gas as defined in EIP-1559

``` swift
public var maxPriorityFeePerGas: UInt64?
```

#### to

receipient of the transaction.

``` swift
public var to: String
```

#### from

sender or signer of the transaction

``` swift
public var from: String
```

#### value

value in wei to send

``` swift
public var value: UInt256
```

#### gas

the gas to be send along

``` swift
public var gas: UInt64
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
public var gasPrice: UInt64
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
public var nonce: UInt64
```

#### blockHash

blockHash of the block holding this transaction or `null` if still pending.

``` swift
public var blockHash: String
```

#### blockNumber

blockNumber of the block holding this transaction or `null` if still pending.

``` swift
public var blockNumber: UInt64
```

#### hash

transactionHash

``` swift
public var hash: String
```

#### input

data of the transaaction

``` swift
public var input: String
```

#### transactionIndex

index of the transaaction in the block

``` swift
public var transactionIndex: UInt64
```

#### v

recovery-byte of the signature

``` swift
public var v: String
```

#### r

x-value of the EC-Point of the signature

``` swift
public var r: String
```

#### s

y-value of the EC-Point of the signature

``` swift
public var s: String
```

#### accessList

the list of storage keys accesses as defined in EIP-2930 transactions of type 0x1 or 0x2. Will only be included if the type\>0

``` swift
public var accessList: [EthTxAccessList]?
```

#### type

the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)

``` swift
public var type: Int?
```

#### chainId

the chainId the transaction is to operate on.

``` swift
public var chainId: UInt64?
```

#### maxFeePerGas

the max Fee gas as defined in EIP-1559

``` swift
public var maxFeePerGas: UInt64?
```

#### maxPriorityFeePerGas

the max priority Fee gas as defined in EIP-1559

``` swift
public var maxPriorityFeePerGas: UInt64?
```
### EthTxAccessList

the list of storage keys accesses as defined in EIP-2930 transactions of type 0x1 or 0x2. Will only be included if the type\>0

``` swift
public struct EthTxAccessList 
```



#### init(address:storageKeys:)

initialize the EthTxAccessList

``` swift
public init(address: String, storageKeys: [String]) 
```

**Parameters**

  - address: the address being accessed.
  - storageKeys: The storage location being accessed.

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(address:storageKeys:)

initialize the EthTxAccessList

``` swift
public init(address: String, storageKeys: [String]) 
```

**Parameters**

  - address: the address being accessed.
  - storageKeys: The storage location being accessed.



#### address

the address being accessed.

``` swift
public var address: String
```

#### storageKeys

The storage location being accessed.

``` swift
public var storageKeys: [String]
```

#### address

the address being accessed.

``` swift
public var address: String
```

#### storageKeys

The storage location being accessed.

``` swift
public var storageKeys: [String]
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

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

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
public var address: String
```

#### blockNumber

the blockNumber

``` swift
public var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
public var blockHash: String
```

#### data

abi-encoded data of the event (all non indexed fields)

``` swift
public var data: String
```

#### logIndex

the index of the even within the block.

``` swift
public var logIndex: Int
```

#### removed

the reorg-status of the event.

``` swift
public var removed: Bool
```

#### topics

array of 32byte-topics of the indexed fields.

``` swift
public var topics: [String]
```

#### transactionHash

requested transactionHash

``` swift
public var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
public var transactionIndex: Int
```

#### transactionLogIndex

index of the event within the transaction.

``` swift
public var transactionLogIndex: Int?
```

#### type

mining-status

``` swift
public var type: String?
```

#### address

the address triggering the event.

``` swift
public var address: String
```

#### blockNumber

the blockNumber

``` swift
public var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
public var blockHash: String
```

#### data

abi-encoded data of the event (all non indexed fields)

``` swift
public var data: String
```

#### logIndex

the index of the even within the block.

``` swift
public var logIndex: Int
```

#### removed

the reorg-status of the event.

``` swift
public var removed: Bool
```

#### topics

array of 32byte-topics of the indexed fields.

``` swift
public var topics: [String]
```

#### transactionHash

requested transactionHash

``` swift
public var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
public var transactionIndex: Int
```

#### transactionLogIndex

index of the event within the transaction.

``` swift
public var transactionLogIndex: Int?
```

#### type

mining-status

``` swift
public var type: String?
```
### FeeHistory

Fee history for the returned block range. This can be a subsection of the requested range if not all blocks are available.

``` swift
public struct FeeHistory 
```



#### init(oldestBlock:baseFeePerGas:gasUsedRatio:reward:)

initialize the FeeHistory

``` swift
public init(oldestBlock: UInt64, baseFeePerGas: [UInt64], gasUsedRatio: [Double], reward: [UInt64]) 
```

**Parameters**

  - oldestBlock: Lowest number block of the returned range.
  - baseFeePerGas: An array of block base fees per gas. This includes the next block after the newest of the returned range, because this value can be derived from the newest block. Zeroes are returned for pre-EIP-1559 blocks.
  - gasUsedRatio: An array of block gas used ratios. These are calculated as the ratio of gasUsed and gasLimit.
  - reward: An array of rewards

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(oldestBlock:baseFeePerGas:gasUsedRatio:reward:)

initialize the FeeHistory

``` swift
public init(oldestBlock: UInt64, baseFeePerGas: [UInt64], gasUsedRatio: [Double], reward: [UInt64]) 
```

**Parameters**

  - oldestBlock: Lowest number block of the returned range.
  - baseFeePerGas: An array of block base fees per gas. This includes the next block after the newest of the returned range, because this value can be derived from the newest block. Zeroes are returned for pre-EIP-1559 blocks.
  - gasUsedRatio: An array of block gas used ratios. These are calculated as the ratio of gasUsed and gasLimit.
  - reward: An array of rewards



#### oldestBlock

Lowest number block of the returned range.

``` swift
public var oldestBlock: UInt64
```

#### baseFeePerGas

An array of block base fees per gas. This includes the next block after the newest of the returned range, because this value can be derived from the newest block. Zeroes are returned for pre-EIP-1559 blocks.

``` swift
public var baseFeePerGas: [UInt64]
```

#### gasUsedRatio

An array of block gas used ratios. These are calculated as the ratio of gasUsed and gasLimit.

``` swift
public var gasUsedRatio: [Double]
```

#### reward

An array of rewards

``` swift
public var reward: [UInt64]
```

#### oldestBlock

Lowest number block of the returned range.

``` swift
public var oldestBlock: UInt64
```

#### baseFeePerGas

An array of block base fees per gas. This includes the next block after the newest of the returned range, because this value can be derived from the newest block. Zeroes are returned for pre-EIP-1559 blocks.

``` swift
public var baseFeePerGas: [UInt64]
```

#### gasUsedRatio

An array of block gas used ratios. These are calculated as the ratio of gasUsed and gasLimit.

``` swift
public var gasUsedRatio: [Double]
```

#### reward

An array of rewards

``` swift
public var reward: [UInt64]
```
### IN3Node

a array of node definitions.

``` swift
public struct IN3Node 
```



#### init(url:address:index:deposit:props:timeout:registerTime:weight:proofHash:)

initialize the IN3Node

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

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(url:address:index:deposit:props:timeout:registerTime:weight:proofHash:)

initialize the IN3Node

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
public var url: String
```

#### address

the address of the signer

``` swift
public var address: String
```

#### index

the index within the nodeList of the contract

``` swift
public var index: UInt64
```

#### deposit

the stored deposit

``` swift
public var deposit: UInt256
```

#### props

the bitset of capabilities as described in the [Node Structure](spec.html#node-structure)

``` swift
public var props: String
```

#### timeout

the time in seconds describing how long the deposit would be locked when trying to unregister a node.

``` swift
public var timeout: UInt64
```

#### registerTime

unix timestamp in seconds when the node has registered.

``` swift
public var registerTime: UInt64
```

#### weight

the weight of a node ( not used yet ) describing the amount of request-points it can handle per second.

``` swift
public var weight: UInt64
```

#### proofHash

a hash value containing the above values.
This hash is explicitly stored in the contract, which enables the client to have only one merkle proof
per node instead of verifying each property as its own storage value.
The proof hash is build `keccak256( abi.encodePacked( deposit, timeout, registerTime, props, signer, url ))`

``` swift
public var proofHash: String
```

#### url

the url of the node. Currently only http/https is supported, but in the future this may even support onion-routing or any other protocols.

``` swift
public var url: String
```

#### address

the address of the signer

``` swift
public var address: String
```

#### index

the index within the nodeList of the contract

``` swift
public var index: UInt64
```

#### deposit

the stored deposit

``` swift
public var deposit: UInt256
```

#### props

the bitset of capabilities as described in the [Node Structure](spec.html#node-structure)

``` swift
public var props: String
```

#### timeout

the time in seconds describing how long the deposit would be locked when trying to unregister a node.

``` swift
public var timeout: UInt64
```

#### registerTime

unix timestamp in seconds when the node has registered.

``` swift
public var registerTime: UInt64
```

#### weight

the weight of a node ( not used yet ) describing the amount of request-points it can handle per second.

``` swift
public var weight: UInt64
```

#### proofHash

a hash value containing the above values.
This hash is explicitly stored in the contract, which enables the client to have only one merkle proof
per node instead of verifying each property as its own storage value.
The proof hash is build `keccak256( abi.encodePacked( deposit, timeout, registerTime, props, signer, url ))`

``` swift
public var proofHash: String
```
### In3Config

The main Incubed Configuration

``` swift
public struct In3Config : Codable 
```



`Codable`, `Codable`



#### init(chainId:finality:includeCode:debug:maxAttempts:keepIn3:stats:useBinary:experimental:timeout:proof:replaceLatestBlock:autoUpdateList:signatureCount:bootWeights:useHttp:minDeposit:nodeProps:requestCount:rpc:nodes:zksync:key:pk:btc:)

initialize it memberwise

``` swift
public init(chainId : String? = nil, finality : Int? = nil, includeCode : Bool? = nil, debug : Bool? = nil, maxAttempts : Int? = nil, keepIn3 : Bool? = nil, stats : Bool? = nil, useBinary : Bool? = nil, experimental : Bool? = nil, timeout : UInt64? = nil, proof : String? = nil, replaceLatestBlock : Int? = nil, autoUpdateList : Bool? = nil, signatureCount : Int? = nil, bootWeights : Bool? = nil, useHttp : Bool? = nil, minDeposit : UInt256? = nil, nodeProps : String? = nil, requestCount : Int? = nil, rpc : String? = nil, nodes : Nodes? = nil, zksync : Zksync? = nil, key : String? = nil, pk : [String]? = nil, btc : Btc? = nil) 
```

**Parameters**

  - chainId: the chainId or the name of a known chain. It defines the nodelist to connect to.
  - finality: the number in percent needed in order reach finality (% of signature of the validators).
  - includeCode: if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth\_getCode() afterwards.
  - debug: if true, debug messages will be written to stderr.
  - maxAttempts: max number of attempts in case a response is rejected.
  - keepIn3: if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did.
  - stats: if true, requests sent will be used for stats.
  - useBinary: if true the client will use binary format. This will reduce the payload of the responses by about 60% but should only be used for embedded systems or when using the API, since this format does not include the propertynames anymore.
  - experimental: if true the client allows to use use experimental features, otherwise a exception is thrown if those would be used.
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

#### init(chainId:finality:includeCode:debug:maxAttempts:keepIn3:stats:useBinary:experimental:timeout:proof:replaceLatestBlock:autoUpdateList:signatureCount:bootWeights:useHttp:minDeposit:nodeProps:requestCount:rpc:nodes:zksync:key:pk:btc:)

initialize it memberwise

``` swift
public init(chainId : String? = nil, finality : Int? = nil, includeCode : Bool? = nil, debug : Bool? = nil, maxAttempts : Int? = nil, keepIn3 : Bool? = nil, stats : Bool? = nil, useBinary : Bool? = nil, experimental : Bool? = nil, timeout : UInt64? = nil, proof : String? = nil, replaceLatestBlock : Int? = nil, autoUpdateList : Bool? = nil, signatureCount : Int? = nil, bootWeights : Bool? = nil, useHttp : Bool? = nil, minDeposit : UInt256? = nil, nodeProps : String? = nil, requestCount : Int? = nil, rpc : String? = nil, nodes : Nodes? = nil, zksync : Zksync? = nil, key : String? = nil, pk : [String]? = nil, btc : Btc? = nil) 
```

**Parameters**

  - chainId: the chainId or the name of a known chain. It defines the nodelist to connect to.
  - finality: the number in percent needed in order reach finality (% of signature of the validators).
  - includeCode: if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth\_getCode() afterwards.
  - debug: if true, debug messages will be written to stderr.
  - maxAttempts: max number of attempts in case a response is rejected.
  - keepIn3: if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did.
  - stats: if true, requests sent will be used for stats.
  - useBinary: if true the client will use binary format. This will reduce the payload of the responses by about 60% but should only be used for embedded systems or when using the API, since this format does not include the propertynames anymore.
  - experimental: if true the client allows to use use experimental features, otherwise a exception is thrown if those would be used.
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
public var chainId : String?
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
public var finality : Int?
```

Example: `50`

#### includeCode

if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth\_getCode() afterwards.

``` swift
public var includeCode : Bool?
```

Example: `true`

#### debug

if true, debug messages will be written to stderr.

``` swift
public var debug : Bool?
```

Example: `true`

#### maxAttempts

max number of attempts in case a response is rejected.
(default:​ `7`)

``` swift
public var maxAttempts : Int?
```

Example: `1`

#### keepIn3

if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did.

``` swift
public var keepIn3 : Bool?
```

Example: `true`

#### stats

if true, requests sent will be used for stats.
(default:​ `true`)

``` swift
public var stats : Bool?
```

#### useBinary

if true the client will use binary format. This will reduce the payload of the responses by about 60% but should only be used for embedded systems or when using the API, since this format does not include the propertynames anymore.

``` swift
public var useBinary : Bool?
```

Example: `true`

#### experimental

if true the client allows to use use experimental features, otherwise a exception is thrown if those would be used.

``` swift
public var experimental : Bool?
```

Example: `true`

#### timeout

specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
(default:​ `20000`)

``` swift
public var timeout : UInt64?
```

Example: `100000`

#### proof

if true the nodes should send a proof of the response. If set to none, verification is turned off completly.
(default:​ `"standard"`)

``` swift
public var proof : String?
```

Possible Values are:

  - `none` : no proof will be generated or verfiied. This also works with standard rpc-endpoints.

  - `standard` : Stanbdard Proof means all important properties are verfiied

  - `full` : In addition to standard, also some rarly needed properties are verfied, like uncles. But this causes a bigger payload.

Example: `none`

#### replaceLatestBlock

if specified, the blocknumber *latest* will be replaced by blockNumber- specified value.

``` swift
public var replaceLatestBlock : Int?
```

Example: `6`

#### autoUpdateList

if true the nodelist will be automaticly updated if the lastBlock is newer.
(default:​ `true`)

``` swift
public var autoUpdateList : Bool?
```

#### signatureCount

number of signatures requested in order to verify the blockhash.
(default:​ `1`)

``` swift
public var signatureCount : Int?
```

Example: `2`

#### bootWeights

if true, the first request (updating the nodelist) will also fetch the current health status and use it for blacklisting unhealthy nodes. This is used only if no nodelist is availabkle from cache.
(default:​ `true`)

``` swift
public var bootWeights : Bool?
```

Example: `true`

#### useHttp

if true the client will try to use http instead of https.

``` swift
public var useHttp : Bool?
```

Example: `true`

#### minDeposit

min stake of the server. Only nodes owning at least this amount will be chosen.

``` swift
public var minDeposit : UInt256?
```

Example: `10000000`

#### nodeProps

used to identify the capabilities of the node.

``` swift
public var nodeProps : String?
```

Example: `"0xffff"`

#### requestCount

the number of request send in parallel when getting an answer. More request will make it more expensive, but increase the chances to get a faster answer, since the client will continue once the first verifiable response was received.
(default:​ `2`)

``` swift
public var requestCount : Int?
```

Example: `3`

#### rpc

url of one or more direct rpc-endpoints to use. (list can be comma seperated). If this is used, proof will automaticly be turned off.

``` swift
public var rpc : String?
```

Example: `http://loalhost:8545`

#### nodes

defining the nodelist. collection of JSON objects with chain Id (hex string) as key.

``` swift
public var nodes : Nodes?
```

Example: \`contract: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f"
nodeList:

  - address: "0x45d45e6ff99e6c34a235d263965910298985fcfe"
    url: https://in3-v2.slock.it/mainnet/nd-1
    props: "0xFFFF"\`

#### zksync

configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

``` swift
public var zksync : Zksync?
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
public var key : String?
```

Example: `"0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"`

#### pk

registers raw private keys as signers for transactions. (only availble if build with `-DPK_SIGNER=true` , which is on per default)

``` swift
public var pk : [String]?
```

Example:

``` 
"0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"
```

#### btc

configure the Bitcoin verification

``` swift
public var btc : Btc?
```

Example: `maxDAP: 30 maxDiff: 5`

#### chainId

the chainId or the name of a known chain. It defines the nodelist to connect to.
(default:​ `"mainnet"`)

``` swift
public var chainId : String?
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
public var finality : Int?
```

Example: `50`

#### includeCode

if true, the request should include the codes of all accounts. otherwise only the the codeHash is returned. In this case the client may ask by calling eth\_getCode() afterwards.

``` swift
public var includeCode : Bool?
```

Example: `true`

#### debug

if true, debug messages will be written to stderr.

``` swift
public var debug : Bool?
```

Example: `true`

#### maxAttempts

max number of attempts in case a response is rejected.
(default:​ `7`)

``` swift
public var maxAttempts : Int?
```

Example: `1`

#### keepIn3

if true, requests sent to the input sream of the comandline util will be send theor responses in the same form as the server did.

``` swift
public var keepIn3 : Bool?
```

Example: `true`

#### stats

if true, requests sent will be used for stats.
(default:​ `true`)

``` swift
public var stats : Bool?
```

#### useBinary

if true the client will use binary format. This will reduce the payload of the responses by about 60% but should only be used for embedded systems or when using the API, since this format does not include the propertynames anymore.

``` swift
public var useBinary : Bool?
```

Example: `true`

#### experimental

if true the client allows to use use experimental features, otherwise a exception is thrown if those would be used.

``` swift
public var experimental : Bool?
```

Example: `true`

#### timeout

specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.
(default:​ `20000`)

``` swift
public var timeout : UInt64?
```

Example: `100000`

#### proof

if true the nodes should send a proof of the response. If set to none, verification is turned off completly.
(default:​ `"standard"`)

``` swift
public var proof : String?
```

Possible Values are:

  - `none` : no proof will be generated or verfiied. This also works with standard rpc-endpoints.

  - `standard` : Stanbdard Proof means all important properties are verfiied

  - `full` : In addition to standard, also some rarly needed properties are verfied, like uncles. But this causes a bigger payload.

Example: `none`

#### replaceLatestBlock

if specified, the blocknumber *latest* will be replaced by blockNumber- specified value.

``` swift
public var replaceLatestBlock : Int?
```

Example: `6`

#### autoUpdateList

if true the nodelist will be automaticly updated if the lastBlock is newer.
(default:​ `true`)

``` swift
public var autoUpdateList : Bool?
```

#### signatureCount

number of signatures requested in order to verify the blockhash.
(default:​ `1`)

``` swift
public var signatureCount : Int?
```

Example: `2`

#### bootWeights

if true, the first request (updating the nodelist) will also fetch the current health status and use it for blacklisting unhealthy nodes. This is used only if no nodelist is availabkle from cache.
(default:​ `true`)

``` swift
public var bootWeights : Bool?
```

Example: `true`

#### useHttp

if true the client will try to use http instead of https.

``` swift
public var useHttp : Bool?
```

Example: `true`

#### minDeposit

min stake of the server. Only nodes owning at least this amount will be chosen.

``` swift
public var minDeposit : UInt256?
```

Example: `10000000`

#### nodeProps

used to identify the capabilities of the node.

``` swift
public var nodeProps : String?
```

Example: `"0xffff"`

#### requestCount

the number of request send in parallel when getting an answer. More request will make it more expensive, but increase the chances to get a faster answer, since the client will continue once the first verifiable response was received.
(default:​ `2`)

``` swift
public var requestCount : Int?
```

Example: `3`

#### rpc

url of one or more direct rpc-endpoints to use. (list can be comma seperated). If this is used, proof will automaticly be turned off.

``` swift
public var rpc : String?
```

Example: `http://loalhost:8545`

#### nodes

defining the nodelist. collection of JSON objects with chain Id (hex string) as key.

``` swift
public var nodes : Nodes?
```

Example: \`contract: "0xac1b824795e1eb1f6e609fe0da9b9af8beaab60f"
nodeList:

  - address: "0x45d45e6ff99e6c34a235d263965910298985fcfe"
    url: https://in3-v2.slock.it/mainnet/nd-1
    props: "0xFFFF"\`

#### zksync

configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

``` swift
public var zksync : Zksync?
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
public var key : String?
```

Example: `"0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"`

#### pk

registers raw private keys as signers for transactions. (only availble if build with `-DPK_SIGNER=true` , which is on per default)

``` swift
public var pk : [String]?
```

Example:

``` 
"0xc9564409cbfca3f486a07996e8015124f30ff8331fc6dcbd610a050f1f983afe"
```

#### btc

configure the Bitcoin verification

``` swift
public var btc : Btc?
```

Example: `maxDAP: 30 maxDiff: 5`



#### createClient()

create a new Incubed Client based on the Configuration

``` swift
public func createClient() throws -> In3 
```

#### createClient()

create a new Incubed Client based on the Configuration

``` swift
public func createClient() throws -> In3 
```
### In3Config.Btc

configure the Bitcoin verification

``` swift
public struct Btc : Codable 
```



`Codable`, `Codable`



#### init(maxDAP:maxDiff:)

initialize it memberwise

``` swift
public init(maxDAP : Int? = nil, maxDiff : Int? = nil) 
```

**Parameters**

  - maxDAP: configure the Bitcoin verification
  - maxDiff: max increase (in percent) of the difference between targets when accepting new targets.

#### init(maxDAP:maxDiff:)

initialize it memberwise

``` swift
public init(maxDAP : Int? = nil, maxDiff : Int? = nil) 
```

**Parameters**

  - maxDAP: configure the Bitcoin verification
  - maxDiff: max increase (in percent) of the difference between targets when accepting new targets.



#### maxDAP

max number of DAPs (Difficulty Adjustment Periods) allowed when accepting new targets.
(default:​ `20`)

``` swift
public var maxDAP : Int?
```

Example: `10`

#### maxDiff

max increase (in percent) of the difference between targets when accepting new targets.
(default:​ `10`)

``` swift
public var maxDiff : Int?
```

Example: `5`

#### maxDAP

max number of DAPs (Difficulty Adjustment Periods) allowed when accepting new targets.
(default:​ `20`)

``` swift
public var maxDAP : Int?
```

Example: `10`

#### maxDiff

max increase (in percent) of the difference between targets when accepting new targets.
(default:​ `10`)

``` swift
public var maxDiff : Int?
```

Example: `5`
### In3Config.Create2

create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.

``` swift
public struct Create2 : Codable 
```



`Codable`, `Codable`



#### init(creator:saltarg:codehash:)

initialize it memberwise

``` swift
public init(creator : String, saltarg : String, codehash : String) 
```

**Parameters**

  - creator: create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.
  - saltarg: a salt-argument, which will be added to the pubkeyhash and create the create2-salt.
  - codehash: the hash of the actual deploy-tx including the constructor-arguments.

#### init(creator:saltarg:codehash:)

initialize it memberwise

``` swift
public init(creator : String, saltarg : String, codehash : String) 
```

**Parameters**

  - creator: create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.
  - saltarg: a salt-argument, which will be added to the pubkeyhash and create the create2-salt.
  - codehash: the hash of the actual deploy-tx including the constructor-arguments.



#### creator

The address of contract or EOA deploying the contract ( for example the GnosisSafeFactory )

``` swift
public var creator : String
```

#### saltarg

a salt-argument, which will be added to the pubkeyhash and create the create2-salt.

``` swift
public var saltarg : String
```

#### codehash

the hash of the actual deploy-tx including the constructor-arguments.

``` swift
public var codehash : String
```

#### creator

The address of contract or EOA deploying the contract ( for example the GnosisSafeFactory )

``` swift
public var creator : String
```

#### saltarg

a salt-argument, which will be added to the pubkeyhash and create the create2-salt.

``` swift
public var saltarg : String
```

#### codehash

the hash of the actual deploy-tx including the constructor-arguments.

``` swift
public var codehash : String
```
### In3Config.NodeList

manual nodeList. As Value a array of Node-Definitions is expected.

``` swift
public struct NodeList : Codable 
```



`Codable`, `Codable`



#### init(url:address:props:)

initialize it memberwise

``` swift
public init(url : String, address : String, props : String) 
```

**Parameters**

  - url: manual nodeList. As Value a array of Node-Definitions is expected.
  - address: address of the node
  - props: used to identify the capabilities of the node (defaults to 0xFFFF).

#### init(url:address:props:)

initialize it memberwise

``` swift
public init(url : String, address : String, props : String) 
```

**Parameters**

  - url: manual nodeList. As Value a array of Node-Definitions is expected.
  - address: address of the node
  - props: used to identify the capabilities of the node (defaults to 0xFFFF).



#### url

URL of the node.

``` swift
public var url : String
```

#### address

address of the node

``` swift
public var address : String
```

#### props

used to identify the capabilities of the node (defaults to 0xFFFF).

``` swift
public var props : String
```

#### url

URL of the node.

``` swift
public var url : String
```

#### address

address of the node

``` swift
public var address : String
```

#### props

used to identify the capabilities of the node (defaults to 0xFFFF).

``` swift
public var props : String
```
### In3Config.Nodes

defining the nodelist. collection of JSON objects with chain Id (hex string) as key.

``` swift
public struct Nodes : Codable 
```



`Codable`, `Codable`



#### init(contract:whiteListContract:whiteList:registryId:needsUpdate:avgBlockTime:verifiedHashes:nodeList:)

initialize it memberwise

``` swift
public init(contract : String? = nil, whiteListContract : String? = nil, whiteList : [String]? = nil, registryId : String? = nil, needsUpdate : Bool? = nil, avgBlockTime : Int? = nil, verifiedHashes : [VerifiedHashes]? = nil, nodeList : [NodeList]? = nil) 
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

#### init(contract:whiteListContract:whiteList:registryId:needsUpdate:avgBlockTime:verifiedHashes:nodeList:)

initialize it memberwise

``` swift
public init(contract : String? = nil, whiteListContract : String? = nil, whiteList : [String]? = nil, registryId : String? = nil, needsUpdate : Bool? = nil, avgBlockTime : Int? = nil, verifiedHashes : [VerifiedHashes]? = nil, nodeList : [NodeList]? = nil) 
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
public var contract : String?
```

#### whiteListContract

address of the whiteList contract. This cannot be combined with whiteList\!

``` swift
public var whiteListContract : String?
```

#### whiteList

manual whitelist.

``` swift
public var whiteList : [String]?
```

#### registryId

identifier of the registry.

``` swift
public var registryId : String?
```

#### needsUpdate

if set, the nodeList will be updated before next request.

``` swift
public var needsUpdate : Bool?
```

#### avgBlockTime

average block time (seconds) for this chain.

``` swift
public var avgBlockTime : Int?
```

#### verifiedHashes

if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.

``` swift
public var verifiedHashes : [VerifiedHashes]?
```

#### nodeList

manual nodeList. As Value a array of Node-Definitions is expected.

``` swift
public var nodeList : [NodeList]?
```

#### contract

address of the registry contract. (This is the data-contract\!)

``` swift
public var contract : String?
```

#### whiteListContract

address of the whiteList contract. This cannot be combined with whiteList\!

``` swift
public var whiteListContract : String?
```

#### whiteList

manual whitelist.

``` swift
public var whiteList : [String]?
```

#### registryId

identifier of the registry.

``` swift
public var registryId : String?
```

#### needsUpdate

if set, the nodeList will be updated before next request.

``` swift
public var needsUpdate : Bool?
```

#### avgBlockTime

average block time (seconds) for this chain.

``` swift
public var avgBlockTime : Int?
```

#### verifiedHashes

if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.

``` swift
public var verifiedHashes : [VerifiedHashes]?
```

#### nodeList

manual nodeList. As Value a array of Node-Definitions is expected.

``` swift
public var nodeList : [NodeList]?
```
### In3Config.VerifiedHashes

if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.

``` swift
public struct VerifiedHashes : Codable 
```



`Codable`, `Codable`



#### init(block:hash:)

initialize it memberwise

``` swift
public init(block : UInt64, hash : String) 
```

**Parameters**

  - block: if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.
  - hash: verified hash corresponding to block number.

#### init(block:hash:)

initialize it memberwise

``` swift
public init(block : UInt64, hash : String) 
```

**Parameters**

  - block: if the client sends an array of blockhashes the server will not deliver any signatures or blockheaders for these blocks, but only return a string with a number. This is automaticly updated by the cache, but can be overriden per request.
  - hash: verified hash corresponding to block number.



#### block

block number

``` swift
public var block : UInt64
```

#### hash

verified hash corresponding to block number.

``` swift
public var hash : String
```

#### block

block number

``` swift
public var block : UInt64
```

#### hash

verified hash corresponding to block number.

``` swift
public var hash : String
```
### In3Config.Zksync

configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

``` swift
public struct Zksync : Codable 
```



`Codable`, `Codable`



#### init(provider_url:rest_api:account:sync_key:main_contract:signer_type:musig_pub_keys:musig_urls:create2:verify_proof_method:create_proof_method:)

initialize it memberwise

``` swift
public init(provider_url : String? = nil, rest_api : String? = nil, account : String? = nil, sync_key : String? = nil, main_contract : String? = nil, signer_type : String? = nil, musig_pub_keys : String? = nil, musig_urls : [String]? = nil, create2 : Create2? = nil, verify_proof_method : String? = nil, create_proof_method : String? = nil) 
```

  - Parameter provider\_url : configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

  - Parameter rest\_api : url of the zksync rest api (if not defined it will be choosen depending on the chain)

  - Parameter sync\_key : the seed used to generate the sync\_key. This way you can explicitly set the pk instead of derriving it from a signer.

  - Parameter main\_contract : address of the main contract- If not specified it will be taken from the server.

  - Parameter signer\_type : type of the account. Must be either `pk`(default), `contract` (using contract signatures) or `create2` using the create2-section.

  - Parameter musig\_pub\_keys : concatenated packed public keys (32byte) of the musig signers. if set the pubkey and pubkeyhash will based on the aggregated pubkey. Also the signing will use multiple keys.

  - Parameter musig\_urls : a array of strings with urls based on the `musig_pub_keys`. It is used so generate the combined signature by exchaing signature data (commitment and signatureshares) if the local client does not hold this key.

  - Parameter verify\_proof\_method : rpc-method, which will be used to verify the incomming proof before cosigning.

  - Parameter create\_proof\_method : rpc-method, which will be used to create the proof needed for cosigning.

**Parameters**

  - account: the account to be used. if not specified, the first signer will be used.
  - create2: create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.

#### init(provider_url:rest_api:account:sync_key:main_contract:signer_type:musig_pub_keys:musig_urls:create2:verify_proof_method:create_proof_method:)

initialize it memberwise

``` swift
public init(provider_url : String? = nil, rest_api : String? = nil, account : String? = nil, sync_key : String? = nil, main_contract : String? = nil, signer_type : String? = nil, musig_pub_keys : String? = nil, musig_urls : [String]? = nil, create2 : Create2? = nil, verify_proof_method : String? = nil, create_proof_method : String? = nil) 
```

  - Parameter provider\_url : configuration for zksync-api  ( only available if build with `-DZKSYNC=true`, which is on per default).

  - Parameter rest\_api : url of the zksync rest api (if not defined it will be choosen depending on the chain)

  - Parameter sync\_key : the seed used to generate the sync\_key. This way you can explicitly set the pk instead of derriving it from a signer.

  - Parameter main\_contract : address of the main contract- If not specified it will be taken from the server.

  - Parameter signer\_type : type of the account. Must be either `pk`(default), `contract` (using contract signatures) or `create2` using the create2-section.

  - Parameter musig\_pub\_keys : concatenated packed public keys (32byte) of the musig signers. if set the pubkey and pubkeyhash will based on the aggregated pubkey. Also the signing will use multiple keys.

  - Parameter musig\_urls : a array of strings with urls based on the `musig_pub_keys`. It is used so generate the combined signature by exchaing signature data (commitment and signatureshares) if the local client does not hold this key.

  - Parameter verify\_proof\_method : rpc-method, which will be used to verify the incomming proof before cosigning.

  - Parameter create\_proof\_method : rpc-method, which will be used to create the proof needed for cosigning.

**Parameters**

  - account: the account to be used. if not specified, the first signer will be used.
  - create2: create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.



#### provider_url

url of the zksync-server (if not defined it will be choosen depending on the chain)
(default:​ `"https:​//api.zksync.io/jsrpc"`)

``` swift
public var provider_url : String?
```

#### rest_api

url of the zksync rest api (if not defined it will be choosen depending on the chain)

``` swift
public var rest_api : String?
```

Example: `https://rinkeby-api.zksync.io/api/v0.1/`

#### account

the account to be used. if not specified, the first signer will be used.

``` swift
public var account : String?
```

#### sync_key

the seed used to generate the sync\_key. This way you can explicitly set the pk instead of derriving it from a signer.

``` swift
public var sync_key : String?
```

#### main_contract

address of the main contract- If not specified it will be taken from the server.

``` swift
public var main_contract : String?
```

#### signer_type

type of the account. Must be either `pk`(default), `contract` (using contract signatures) or `create2` using the create2-section.
(default:​ `"pk"`)

``` swift
public var signer_type : String?
```

Possible Values are:

  - `pk` : Private matching the account is used ( for EOA)

  - `contract` : Contract Signature  based EIP 1271

  - `create2` : create2 optionas are used

#### musig_pub_keys

concatenated packed public keys (32byte) of the musig signers. if set the pubkey and pubkeyhash will based on the aggregated pubkey. Also the signing will use multiple keys.

``` swift
public var musig_pub_keys : String?
```

#### musig_urls

a array of strings with urls based on the `musig_pub_keys`. It is used so generate the combined signature by exchaing signature data (commitment and signatureshares) if the local client does not hold this key.

``` swift
public var musig_urls : [String]?
```

#### create2

create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.

``` swift
public var create2 : Create2?
```

#### verify_proof_method

rpc-method, which will be used to verify the incomming proof before cosigning.

``` swift
public var verify_proof_method : String?
```

#### create_proof_method

rpc-method, which will be used to create the proof needed for cosigning.

``` swift
public var create_proof_method : String?
```

#### provider_url

url of the zksync-server (if not defined it will be choosen depending on the chain)
(default:​ `"https:​//api.zksync.io/jsrpc"`)

``` swift
public var provider_url : String?
```

#### rest_api

url of the zksync rest api (if not defined it will be choosen depending on the chain)

``` swift
public var rest_api : String?
```

Example: `https://rinkeby-api.zksync.io/api/v0.1/`

#### account

the account to be used. if not specified, the first signer will be used.

``` swift
public var account : String?
```

#### sync_key

the seed used to generate the sync\_key. This way you can explicitly set the pk instead of derriving it from a signer.

``` swift
public var sync_key : String?
```

#### main_contract

address of the main contract- If not specified it will be taken from the server.

``` swift
public var main_contract : String?
```

#### signer_type

type of the account. Must be either `pk`(default), `contract` (using contract signatures) or `create2` using the create2-section.
(default:​ `"pk"`)

``` swift
public var signer_type : String?
```

Possible Values are:

  - `pk` : Private matching the account is used ( for EOA)

  - `contract` : Contract Signature  based EIP 1271

  - `create2` : create2 optionas are used

#### musig_pub_keys

concatenated packed public keys (32byte) of the musig signers. if set the pubkey and pubkeyhash will based on the aggregated pubkey. Also the signing will use multiple keys.

``` swift
public var musig_pub_keys : String?
```

#### musig_urls

a array of strings with urls based on the `musig_pub_keys`. It is used so generate the combined signature by exchaing signature data (commitment and signatureshares) if the local client does not hold this key.

``` swift
public var musig_urls : [String]?
```

#### create2

create2-arguments for sign\_type `create2`. This will allow to sign for contracts which are not deployed yet.

``` swift
public var create2 : Create2?
```

#### verify_proof_method

rpc-method, which will be used to verify the incomming proof before cosigning.

``` swift
public var verify_proof_method : String?
```

#### create_proof_method

rpc-method, which will be used to create the proof needed for cosigning.

``` swift
public var create_proof_method : String?
```
### In3SignBlock

array of requested blocks.

``` swift
public struct In3SignBlock 
```



#### init(blockNumber:hash:)

initialize the In3SignBlock

``` swift
public init(blockNumber: UInt64, hash: String? = nil) 
```

**Parameters**

  - blockNumber: the blockNumber to sign
  - hash: the expected hash. This is optional and can be used to check if the expected hash is correct, but as a client you should not rely on it, but only on the hash in the signature.

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(blockNumber:hash:)

initialize the In3SignBlock

``` swift
public init(blockNumber: UInt64, hash: String? = nil) 
```

**Parameters**

  - blockNumber: the blockNumber to sign
  - hash: the expected hash. This is optional and can be used to check if the expected hash is correct, but as a client you should not rely on it, but only on the hash in the signature.



#### blockNumber

the blockNumber to sign

``` swift
public var blockNumber: UInt64
```

#### hash

the expected hash. This is optional and can be used to check if the expected hash is correct, but as a client you should not rely on it, but only on the hash in the signature.

``` swift
public var hash: String?
```

#### blockNumber

the blockNumber to sign

``` swift
public var blockNumber: UInt64
```

#### hash

the expected hash. This is optional and can be used to check if the expected hash is correct, but as a client you should not rely on it, but only on the hash in the signature.

``` swift
public var hash: String?
```
### In3SignedBlockHash

the Array with signatures of all the requires blocks.

``` swift
public struct In3SignedBlockHash 
```



#### init(blockHash:block:r:s:v:msgHash:)

initialize the In3SignedBlockHash

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

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(blockHash:block:r:s:v:msgHash:)

initialize the In3SignedBlockHash

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
public var blockHash: String
```

#### block

the blocknumber

``` swift
public var block: UInt64
```

#### r

r-value of the signature

``` swift
public var r: String
```

#### s

s-value of the signature

``` swift
public var s: String
```

#### v

v-value of the signature

``` swift
public var v: String
```

#### msgHash

the msgHash signed. This Hash is created with `keccak256( abi.encodePacked( _blockhash,  _blockNumber, registryId ))`

``` swift
public var msgHash: String
```

#### blockHash

the blockhash which was signed.

``` swift
public var blockHash: String
```

#### block

the blocknumber

``` swift
public var block: UInt64
```

#### r

r-value of the signature

``` swift
public var r: String
```

#### s

s-value of the signature

``` swift
public var s: String
```

#### v

v-value of the signature

``` swift
public var v: String
```

#### msgHash

the msgHash signed. This Hash is created with `keccak256( abi.encodePacked( _blockhash,  _blockNumber, registryId ))`

``` swift
public var msgHash: String
```
### In3WhiteList

the whitelisted addresses

``` swift
public struct In3WhiteList 
```



#### init(nodes:lastWhiteList:contract:lastBlockNumber:totalServer:)

initialize the In3WhiteList

``` swift
public init(nodes: String, lastWhiteList: UInt64, contract: String, lastBlockNumber: UInt64, totalServer: UInt64) 
```

**Parameters**

  - nodes: array of whitelisted nodes addresses.
  - lastWhiteList: the blockNumber of the last change of the in3 white list event.
  - contract: whitelist contract address.
  - lastBlockNumber: the blockNumber of the last change of the list (usually the last event).
  - totalServer: the total numbers of whitelist nodes.

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(nodes:lastWhiteList:contract:lastBlockNumber:totalServer:)

initialize the In3WhiteList

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
public var nodes: String
```

#### lastWhiteList

the blockNumber of the last change of the in3 white list event.

``` swift
public var lastWhiteList: UInt64
```

#### contract

whitelist contract address.

``` swift
public var contract: String
```

#### lastBlockNumber

the blockNumber of the last change of the list (usually the last event).

``` swift
public var lastBlockNumber: UInt64
```

#### totalServer

the total numbers of whitelist nodes.

``` swift
public var totalServer: UInt64
```

#### nodes

array of whitelisted nodes addresses.

``` swift
public var nodes: String
```

#### lastWhiteList

the blockNumber of the last change of the in3 white list event.

``` swift
public var lastWhiteList: UInt64
```

#### contract

whitelist contract address.

``` swift
public var contract: String
```

#### lastBlockNumber

the blockNumber of the last change of the list (usually the last event).

``` swift
public var lastBlockNumber: UInt64
```

#### totalServer

the total numbers of whitelist nodes.

``` swift
public var totalServer: UInt64
```
### KdfParams

the kdfparams

``` swift
public struct KdfParams 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(dklen:salt:c:prf:)

initialize the KdfParams

``` swift
public init(dklen: UInt64, salt: String, c: UInt64, prf: String) 
```

**Parameters**

  - dklen: the dklen
  - salt: the salt
  - c: the c
  - prf: the prf



#### dklen

the dklen

``` swift
public var dklen: UInt64
```

#### salt

the salt

``` swift
public var salt: String
```

#### c

the c

``` swift
public var c: UInt64
```

#### prf

the prf

``` swift
public var prf: String
```
### Keyparams

the keyparams

``` swift
public struct Keyparams 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(version:id:address:crypto:)

initialize the Keyparams

``` swift
public init(version: String, id: String, address: String, crypto: CryptoParams) 
```

**Parameters**

  - version: the version
  - id: the id
  - address: the address
  - crypto: the cryptoparams



#### version

the version

``` swift
public var version: String
```

#### id

the id

``` swift
public var id: String
```

#### address

the address

``` swift
public var address: String
```

#### crypto

the cryptoparams

``` swift
public var crypto: CryptoParams
```
### MSLimit

limits for sending tokens withtout reaching the threshold

``` swift
public struct MSLimit 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(token:limit:period:current_period:spent:)

initialize the MSLimit

``` swift
public init(token: String, limit: UInt256, period: UInt32, current_period: UInt32, spent: UInt256? = nil) 
```

  - Parameter current\_period : current timeinterval in seconds (current time in s / period)

**Parameters**

  - token: address of the token (0x00000... for eth)
  - limit: max amount (in wei) to spend within the defined period
  - period: timeinterval in seconds for which this limit applies
  - spent: start value for already spent assets



#### token

address of the token (0x00000... for eth)

``` swift
public var token: String
```

#### limit

max amount (in wei) to spend within the defined period

``` swift
public var limit: UInt256
```

#### period

timeinterval in seconds for which this limit applies

``` swift
public var period: UInt32
```

#### current_period

current timeinterval in seconds (current time in s / period)

``` swift
public var current_period: UInt32
```

#### spent

start value for already spent assets

``` swift
public var spent: UInt256?
```
### MsDef

the wallet-configuration

``` swift
public struct MsDef 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(type:address:threshold:signer:owners:creator:saltarg:codehash:musig_pub_keys:sync_key:domain_sep:safetype:rpc_url:rest_url:cosign_url:master_copy:master_copy_custody:custody:create_module:allowed_targets:limits:)

initialize the MsDef

``` swift
public init(type: String? = nil, address: String? = nil, threshold: Int? = nil, signer: String? = nil, owners: [MsOwner]? = nil, creator: String? = nil, saltarg: String? = nil, codehash: String? = nil, musig_pub_keys: String? = nil, sync_key: String? = nil, domain_sep: String? = nil, safetype: String? = nil, rpc_url: String? = nil, rest_url: String? = nil, cosign_url: String? = nil, master_copy: String? = nil, master_copy_custody: String? = nil, custody: String? = nil, create_module: String? = nil, allowed_targets: [String]? = nil, limits: [MSLimit]? = nil) 
```

  - Parameter musig\_pub\_keys : the 64 bytes combination of the users and the remote signers public key - only needed for a l2-wallet using create2

  - Parameter sync\_key : sync\_key the seed for the user key which will be used to create the combined signature - only needed for a l2-wallet using create2

  - Parameter domain\_sep : a optional unique domain\_seperator, which is used to create contract signatures- only needed for a l1-wallet using contract signatures

  - Parameter rpc\_url : the url of the zksync operator (JSON-RPC-Interface) - only needed for l2-wallets

  - Parameter rest\_url : the url of the zksync operator (REST API) - only needed for l2-wallets for history

  - Parameter cosign\_url : the url of the approver service (JSON-RPC-Interface) - only needed for l2-wallets

  - Parameter master\_copy : address of the master\_copy of the wallet

  - Parameter master\_copy\_custody : address of the master\_copy of the custody-module

  - Parameter create\_module : address of the AddAndCreateModule contract

  - Parameter allowed\_targets : target addresses which are allowed to send transactions to without reaching the threshold

**Parameters**

  - type: the type, which can be a combination of `l1`, `l2` or `c`
  - address: the address of the wallet
  - threshold: the minimal number of signatures needed for the multisig to approve a transaction. It must be at least one and less or equal to the number of owners.
  - signer: the public key of the zksync signer
  - owners: the owners of multisig
  - creator: the creator address - only needed for a l2-wallet using create2
  - saltarg: the hash of the init tx - only needed for a l2-wallet using create2
  - codehash: the hash of the contract deploy tx - only needed for a l2-wallet using create2
  - safetype: The Name of the MultiSig Contract - only needed for a l1-wallets to find out which safe we are working with.
  - custody: address of the custody-module
  - limits: limits for sending tokens withtout reaching the threshold



#### type

the type, which can be a combination of `l1`, `l2` or `c`

``` swift
public var type: String?
```

#### address

the address of the wallet

``` swift
public var address: String?
```

#### threshold

the minimal number of signatures needed for the multisig to approve a transaction. It must be at least one and less or equal to the number of owners.

``` swift
public var threshold: Int?
```

#### signer

the public key of the zksync signer

``` swift
public var signer: String?
```

#### owners

the owners of multisig

``` swift
public var owners: [MsOwner]?
```

#### creator

the creator address - only needed for a l2-wallet using create2

``` swift
public var creator: String?
```

#### saltarg

the hash of the init tx - only needed for a l2-wallet using create2

``` swift
public var saltarg: String?
```

#### codehash

the hash of the contract deploy tx - only needed for a l2-wallet using create2

``` swift
public var codehash: String?
```

#### musig_pub_keys

the 64 bytes combination of the users and the remote signers public key - only needed for a l2-wallet using create2

``` swift
public var musig_pub_keys: String?
```

#### sync_key

sync\_key the seed for the user key which will be used to create the combined signature - only needed for a l2-wallet using create2

``` swift
public var sync_key: String?
```

#### domain_sep

a optional unique domain\_seperator, which is used to create contract signatures- only needed for a l1-wallet using contract signatures

``` swift
public var domain_sep: String?
```

#### safetype

The Name of the MultiSig Contract - only needed for a l1-wallets to find out which safe we are working with.

``` swift
public var safetype: String?
```

#### rpc_url

the url of the zksync operator (JSON-RPC-Interface) - only needed for l2-wallets

``` swift
public var rpc_url: String?
```

#### rest_url

the url of the zksync operator (REST API) - only needed for l2-wallets for history

``` swift
public var rest_url: String?
```

#### cosign_url

the url of the approver service (JSON-RPC-Interface) - only needed for l2-wallets

``` swift
public var cosign_url: String?
```

#### master_copy

address of the master\_copy of the wallet

``` swift
public var master_copy: String?
```

#### master_copy_custody

address of the master\_copy of the custody-module

``` swift
public var master_copy_custody: String?
```

#### custody

address of the custody-module

``` swift
public var custody: String?
```

#### create_module

address of the AddAndCreateModule contract

``` swift
public var create_module: String?
```

#### allowed_targets

target addresses which are allowed to send transactions to without reaching the threshold

``` swift
public var allowed_targets: [String]?
```

#### limits

limits for sending tokens withtout reaching the threshold

``` swift
public var limits: [MSLimit]?
```
### MsOwner

the owners of multisig

``` swift
public struct MsOwner 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(roles:address:)

initialize the MsOwner

``` swift
public init(roles: Int, address: String) 
```

**Parameters**

  - roles: the bitmask representing the combined roles.
  - address: address of the owner



#### roles

the bitmask representing the combined roles.

``` swift
public var roles: Int
```

#### address

address of the owner

``` swift
public var address: String
```
### NodeListDefinition

the current nodelist

``` swift
public struct NodeListDefinition 
```



#### init(nodes:contract:registryId:lastBlockNumber:totalServer:)

initialize the NodeListDefinition

``` swift
public init(nodes: [IN3Node], contract: String, registryId: String, lastBlockNumber: UInt64, totalServer: UInt64) 
```

**Parameters**

  - nodes: a array of node definitions.
  - contract: the address of the Incubed-storage-contract. The client may use this information to verify that we are talking about the same contract or throw an exception otherwise.
  - registryId: the registryId (32 bytes)  of the contract, which is there to verify the correct contract.
  - lastBlockNumber: the blockNumber of the last change of the list (usually the last event).
  - totalServer: the total numbers of nodes.

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(nodes:contract:registryId:lastBlockNumber:totalServer:)

initialize the NodeListDefinition

``` swift
public init(nodes: [IN3Node], contract: String, registryId: String, lastBlockNumber: UInt64, totalServer: UInt64) 
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
public var nodes: [IN3Node]
```

#### contract

the address of the Incubed-storage-contract. The client may use this information to verify that we are talking about the same contract or throw an exception otherwise.

``` swift
public var contract: String
```

#### registryId

the registryId (32 bytes)  of the contract, which is there to verify the correct contract.

``` swift
public var registryId: String
```

#### lastBlockNumber

the blockNumber of the last change of the list (usually the last event).

``` swift
public var lastBlockNumber: UInt64
```

#### totalServer

the total numbers of nodes.

``` swift
public var totalServer: UInt64
```

#### nodes

a array of node definitions.

``` swift
public var nodes: [IN3Node]
```

#### contract

the address of the Incubed-storage-contract. The client may use this information to verify that we are talking about the same contract or throw an exception otherwise.

``` swift
public var contract: String
```

#### registryId

the registryId (32 bytes)  of the contract, which is there to verify the correct contract.

``` swift
public var registryId: String
```

#### lastBlockNumber

the blockNumber of the last change of the list (usually the last event).

``` swift
public var lastBlockNumber: UInt64
```

#### totalServer

the total numbers of nodes.

``` swift
public var totalServer: UInt64
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

#### init(_:description:)

initializer

``` swift
public init(_ kind: Kind, description: String? = nil) 
```



#### kind

the error-type

``` swift
public let kind: Kind
```

#### description

the error description

``` swift
public let description: String?
```

#### kind

the error-type

``` swift
public let kind: Kind
```

#### description

the error description

``` swift
public let description: String?
```
### SignResult

the signature

``` swift
public struct SignResult 
```



#### init(message:messageHash:signature:r:s:v:)

initialize the SignResult

``` swift
public init(message: String, messageHash: String, signature: String, r: String, s: String, v: UInt32) 
```

**Parameters**

  - message: original message used
  - messageHash: the hash the signature is based on
  - signature: the signature (65 bytes)
  - r: the x-value of the EC-Point
  - s: the y-value of the EC-Point
  - v: the recovery value (0|1) + 27

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(message:messageHash:signature:r:s:v:)

initialize the SignResult

``` swift
public init(message: String, messageHash: String, signature: String, r: String, s: String, v: UInt32) 
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
public var message: String
```

#### messageHash

the hash the signature is based on

``` swift
public var messageHash: String
```

#### signature

the signature (65 bytes)

``` swift
public var signature: String
```

#### r

the x-value of the EC-Point

``` swift
public var r: String
```

#### s

the y-value of the EC-Point

``` swift
public var s: String
```

#### v

the recovery value (0|1) + 27

``` swift
public var v: UInt32
```

#### message

original message used

``` swift
public var message: String
```

#### messageHash

the hash the signature is based on

``` swift
public var messageHash: String
```

#### signature

the signature (65 bytes)

``` swift
public var signature: String
```

#### r

the x-value of the EC-Point

``` swift
public var r: String
```

#### s

the y-value of the EC-Point

``` swift
public var s: String
```

#### v

the recovery value (0|1) + 27

``` swift
public var v: UInt32
```
### TxData

the description of the transaction. As minimum only the inputs are needed.
But in order to sign with multiple parties the definition can be passed to combined multiple signatures

``` swift
public struct TxData 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(state:input:pre_unsigned:ms:unsigned:unsigned_2fa:signed:signed_2fa:transactionHash:receipt:)

initialize the TxData

``` swift
public init(state: String? = nil, input: TxInput, pre_unsigned: String? = nil, ms: TxMultisigState? = nil, unsigned: String? = nil, unsigned_2fa: String? = nil, signed: String? = nil, signed_2fa: String? = nil, transactionHash: String? = nil, receipt: TxReceipt? = nil) 
```

  - Parameter pre\_unsigned : the raw unsigned tx after applying the transformations, but before chaing the data for the wallet

  - Parameter unsigned\_2fa : message-data in a human readable form, which is usually also signed. This is available only for zksync and if the the signing mode is not create2.

  - Parameter signed\_2fa : the signed 2fa message. (if available)

**Parameters**

  - state: the state of the transaction, which can be `prepared`, `signed`, `sent` and `receipt`.
  - input: the input-data of a transaction
  - ms: the state of the multisig signatures
  - unsigned: the unsigned raw transaction
  - signed: the signed raw transaction. The hash of those bytes must match the transactionHash on chain. This will be created once the signer has signed the tx.
  - transactionHash: hash of the signed transaction. This property will only be added if the transaction has been sent.
  - receipt: transaction receipt containing the success-flag and all events



#### state

the state of the transaction, which can be `prepared`, `signed`, `sent` and `receipt`.

``` swift
public var state: String?
```

#### input

the input-data of a transaction

``` swift
public var input: TxInput
```

#### pre_unsigned

the raw unsigned tx after applying the transformations, but before chaing the data for the wallet

``` swift
public var pre_unsigned: String?
```

#### ms

the state of the multisig signatures

``` swift
public var ms: TxMultisigState?
```

#### unsigned

the unsigned raw transaction

``` swift
public var unsigned: String?
```

#### unsigned_2fa

message-data in a human readable form, which is usually also signed. This is available only for zksync and if the the signing mode is not create2.

``` swift
public var unsigned_2fa: String?
```

#### signed

the signed raw transaction. The hash of those bytes must match the transactionHash on chain. This will be created once the signer has signed the tx.

``` swift
public var signed: String?
```

#### signed_2fa

the signed 2fa message. (if available)

``` swift
public var signed_2fa: String?
```

#### transactionHash

hash of the signed transaction. This property will only be added if the transaction has been sent.

``` swift
public var transactionHash: String?
```

#### receipt

transaction receipt containing the success-flag and all events

``` swift
public var receipt: TxReceipt?
```
### TxInput

the input-data of a transaction

``` swift
public struct TxInput 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(to:from:wallet:value:gas:gasPrice:nonce:data:signatures:type:token:validFrom:validUntil:fn_sig:fn_args:delegate:layer:url:)

initialize the TxInput

``` swift
public init(to: String? = nil, from: String? = nil, wallet: String? = nil, value: UInt256? = nil, gas: UInt64? = nil, gasPrice: UInt64? = nil, nonce: UInt64? = nil, data: String? = nil, signatures: String? = nil, type: String? = nil, token: String? = nil, validFrom: UInt64? = nil, validUntil: UInt64? = nil, fn_sig: String? = nil, fn_args: [AnyObject]? = nil, delegate: Bool? = nil, layer: String? = nil, url: String? = nil) 
```

  - Parameter fn\_sig : the signature of a function to call. together with the fn\_args the abi-encoder will create the data for the transaction to call this function.

  - Parameter fn\_args : array of arguments to be abiencoded, which must match the fn\_sig

**Parameters**

  - to: receipient of the transaction.
  - from: sender of the address (if not sepcified, the first signer will be the sender)
  - wallet: if specified, the transaction will be send through the specified wallet.
  - value: value in wei to send
  - gas: the gas to be send along
  - gasPrice: the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`
  - nonce: the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`
  - data: the data-section of the transaction
  - signatures: additional signatures which should be used when sending through a multisig
  - type: the transaction-type, which is currently only used for l2. Here you can use `Transfer` (default) to transfer token from l2 to l2 or `Withdraw` to transfer from l2 to l1
  - token: the name or address of a ERC20 token to be used. If this is set, the wallet will call the ERC20-transfer instead.
  - validFrom: the unix timestamp in seconds in which this transaction becomes valid. (default 0) currently only available for l2-wallets.
  - validUntil: the max unix timestamp in seconds in until this transaction becomes valid. (default 0xffffffff) currently only available for l2-wallets.
  - delegate: if true the transaction will be handled (if supported) as a delegate call.
  - layer: the layer for execution. Currently only `l1` or `l2` are supported.
  - url: a url specifying the tx based on EIP-681. Example:  ethereum:0x89205a3a3b2a69de6dbf7f01ed13b2108b2c43e7/transfer?address=0x8e23ee67d1332ad560396262c48ffbb01f93d052\&uint256=1



#### to

receipient of the transaction.

``` swift
public var to: String?
```

#### from

sender of the address (if not sepcified, the first signer will be the sender)

``` swift
public var from: String?
```

#### wallet

if specified, the transaction will be send through the specified wallet.

``` swift
public var wallet: String?
```

#### value

value in wei to send

``` swift
public var value: UInt256?
```

#### gas

the gas to be send along

``` swift
public var gas: UInt64?
```

#### gasPrice

the price in wei for one gas-unit. If not specified it will be fetched using `eth_gasPrice`

``` swift
public var gasPrice: UInt64?
```

#### nonce

the current nonce of the sender. If not specified it will be fetched using `eth_getTransactionCount`

``` swift
public var nonce: UInt64?
```

#### data

the data-section of the transaction

``` swift
public var data: String?
```

#### signatures

additional signatures which should be used when sending through a multisig

``` swift
public var signatures: String?
```

#### type

the transaction-type, which is currently only used for l2. Here you can use `Transfer` (default) to transfer token from l2 to l2 or `Withdraw` to transfer from l2 to l1

``` swift
public var type: String?
```

#### token

the name or address of a ERC20 token to be used. If this is set, the wallet will call the ERC20-transfer instead.

``` swift
public var token: String?
```

#### validFrom

the unix timestamp in seconds in which this transaction becomes valid. (default 0) currently only available for l2-wallets.

``` swift
public var validFrom: UInt64?
```

#### validUntil

the max unix timestamp in seconds in until this transaction becomes valid. (default 0xffffffff) currently only available for l2-wallets.

``` swift
public var validUntil: UInt64?
```

#### fn_sig

the signature of a function to call. together with the fn\_args the abi-encoder will create the data for the transaction to call this function.

``` swift
public var fn_sig: String?
```

#### fn_args

array of arguments to be abiencoded, which must match the fn\_sig

``` swift
public var fn_args: [AnyObject]?
```

#### delegate

if true the transaction will be handled (if supported) as a delegate call.

``` swift
public var delegate: Bool?
```

#### layer

the layer for execution. Currently only `l1` or `l2` are supported.

``` swift
public var layer: String?
```

#### url

a url specifying the tx based on EIP-681. Example:​  ethereum:​0x89205a3a3b2a69de6dbf7f01ed13b2108b2c43e7/transfer?address=0x8e23ee67d1332ad560396262c48ffbb01f93d052\&uint256=1

``` swift
public var url: String?
```
### TxMultisigOwnerSignature

the collected signatures

``` swift
public struct TxMultisigOwnerSignature 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(owner:roles:signature:)

initialize the TxMultisigOwnerSignature

``` swift
public init(owner: String, roles: Int, signature: String) 
```

**Parameters**

  - owner: the address of the owner
  - roles: the combined bitmask of the owner-roles (1 - Challenger, 2 - Initiator, 4 - Approver)
  - signature: the signature for the transactionhash



#### owner

the address of the owner

``` swift
public var owner: String
```

#### roles

the combined bitmask of the owner-roles (1 - Challenger, 2 - Initiator, 4 - Approver)

``` swift
public var roles: Int
```

#### signature

the signature for the transactionhash

``` swift
public var signature: String
```
### TxMultisigState

the state of the multisig signatures

``` swift
public struct TxMultisigState 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(wallet:tx_hash:nonce:threshold:sign_count:signatures:missing:allSignatures:tx_data:tx_to:tx_gas:)

initialize the TxMultisigState

``` swift
public init(wallet: String, tx_hash: String, nonce: UInt64? = nil, threshold: Int, sign_count: Int, signatures: [TxMultisigOwnerSignature], missing: [String], allSignatures: String, tx_data: String? = nil, tx_to: String? = nil, tx_gas: UInt64? = nil) 
```

  - Parameter tx\_hash : the Safe Transaction Hash, which must be signed by the owners

  - Parameter sign\_count : the numbers of signatures available

  - Parameter tx\_data : the data which need to be send to the contract. Using this anybody, like a gas relay can send the transaction. Thoses data also contain all the signatures.(only for l1-wallet)

  - Parameter tx\_to : the receipient of the tx, which is the wallet (only for l1-wallet)

  - Parameter tx\_gas : the calculated amount of gas needed to send to the wallet contract in order to execute the tx (only for l1-wallet)

**Parameters**

  - wallet: the address of the wallet used
  - nonce: the nonce of the wallet as taken from the contract (only for l1-wallet)
  - threshold: the threshold of the multisig
  - signatures: the collected signatures
  - missing: list of potential signing owners which could help to reach the threshold
  - allSignatures: the combined and ordered signatures as required by the contracts. Here the Initiator will always come first, other in alphabetical order



#### wallet

the address of the wallet used

``` swift
public var wallet: String
```

#### tx_hash

the Safe Transaction Hash, which must be signed by the owners

``` swift
public var tx_hash: String
```

#### nonce

the nonce of the wallet as taken from the contract (only for l1-wallet)

``` swift
public var nonce: UInt64?
```

#### threshold

the threshold of the multisig

``` swift
public var threshold: Int
```

#### sign_count

the numbers of signatures available

``` swift
public var sign_count: Int
```

#### signatures

the collected signatures

``` swift
public var signatures: [TxMultisigOwnerSignature]
```

#### missing

list of potential signing owners which could help to reach the threshold

``` swift
public var missing: [String]
```

#### allSignatures

the combined and ordered signatures as required by the contracts. Here the Initiator will always come first, other in alphabetical order

``` swift
public var allSignatures: String
```

#### tx_data

the data which need to be send to the contract. Using this anybody, like a gas relay can send the transaction. Thoses data also contain all the signatures.(only for l1-wallet)

``` swift
public var tx_data: String?
```

#### tx_to

the receipient of the tx, which is the wallet (only for l1-wallet)

``` swift
public var tx_to: String?
```

#### tx_gas

the calculated amount of gas needed to send to the wallet contract in order to execute the tx (only for l1-wallet)

``` swift
public var tx_gas: UInt64?
```
### TxReceipt

transaction receipt containing the success-flag and all events

``` swift
public struct TxReceipt 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(blockNumber:blockHash:contractAddress:cumulativeGasUsed:gasUsed:logs:logsBloom:status:transactionHash:transactionIndex:error:committed:verified:)

initialize the TxReceipt

``` swift
public init(blockNumber: UInt64, blockHash: String? = nil, contractAddress: String? = nil, cumulativeGasUsed: UInt64? = nil, gasUsed: UInt64, logs: [Ethlog]? = nil, logsBloom: String? = nil, status: Int, transactionHash: String? = nil, transactionIndex: Int? = nil, error: String? = nil, committed: Bool? = nil, verified: Bool? = nil) 
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
  - error: the error-message in case it failed.
  - committed: true if the transaction was commited and accepted by the zksync-operator
  - verified: true if the transaction was included in a block in layer 1



#### blockNumber

the blockNumber

``` swift
public var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
public var blockHash: String?
```

#### contractAddress

the deployed contract in case the tx did deploy a new contract

``` swift
public var contractAddress: String?
```

#### cumulativeGasUsed

gas used for all transaction up to this one in the block

``` swift
public var cumulativeGasUsed: UInt64?
```

#### gasUsed

gas used by this transaction.

``` swift
public var gasUsed: UInt64
```

#### logs

array of events created during execution of the tx

``` swift
public var logs: [Ethlog]?
```

#### logsBloom

bloomfilter used to detect events for `eth_getLogs`

``` swift
public var logsBloom: String?
```

#### status

error-status of the tx.  0x1 = success 0x0 = failure

``` swift
public var status: Int
```

#### transactionHash

requested transactionHash

``` swift
public var transactionHash: String?
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
public var transactionIndex: Int?
```

#### error

the error-message in case it failed.

``` swift
public var error: String?
```

#### committed

true if the transaction was commited and accepted by the zksync-operator

``` swift
public var committed: Bool?
```

#### verified

true if the transaction was included in a block in layer 1

``` swift
public var verified: Bool?
```
### User

The stored user information

``` swift
public struct User 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(signature:status:data:)

initialize the User

``` swift
public init(signature: VaultSignature, status: String, data: String) 
```

**Parameters**

  - signature: signature for policy content
  - status: a enum for status of sending token as `sent`, `error`, `alreadyVerified` or `invalidTarget`
  - data: json formated data about user



#### signature

signature for policy content

``` swift
public var signature: VaultSignature
```

#### status

a enum for status of sending token as `sent`, `error`, `alreadyVerified` or `invalidTarget`

``` swift
public var status: String
```

#### data

json formated data about user

``` swift
public var data: String
```
### UserDevices

Device listing result

``` swift
public struct UserDevices 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(signature:status:data:)

initialize the UserDevices

``` swift
public init(signature: VaultSignature, status: String, data: DeviceList) 
```

**Parameters**

  - signature: signature for policy content
  - status: a enum for status of sending token as `sent`, `error` or `invalidTarget`
  - data: json formated list of user registered devices



#### signature

signature for policy content

``` swift
public var signature: VaultSignature
```

#### status

a enum for status of sending token as `sent`, `error` or `invalidTarget`

``` swift
public var status: String
```

#### data

json formated list of user registered devices

``` swift
public var data: DeviceList
```
### VaultSignature

signature for policy content

``` swift
public struct VaultSignature 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(timestamp:value:)

initialize the VaultSignature

``` swift
public init(timestamp: String, value: String) 
```

**Parameters**

  - timestamp: ISO8601 UTC DateTime - the signature has been created at
  - value: the signature value



#### timestamp

ISO8601 UTC DateTime - the signature has been created at

``` swift
public var timestamp: String
```

#### value

the signature value

``` swift
public var value: String
```
### WalletTx

a array with all events since the creation of the wallet.

``` swift
public struct WalletTx 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(tx_hash:block:timestamp:layer:events:)

initialize the WalletTx

``` swift
public init(tx_hash: String? = nil, block: UInt64? = nil, timestamp: UInt64, layer: String, events: [WalletTxEvent]) 
```

  - Parameter tx\_hash : the transactionhash of transaction creating those events

**Parameters**

  - block: the blocknumber of transaction creating those events
  - timestamp: the unix timestamp in seconds of the event
  - layer: a identifier for a layer. for l1 this would by `eth-<CHAIN_ID>` for zksync : \`zk-<CONTRACT>\<CHAIN\_ID\>
  - events: a list of events happend within the tx



#### tx_hash

the transactionhash of transaction creating those events

``` swift
public var tx_hash: String?
```

#### block

the blocknumber of transaction creating those events

``` swift
public var block: UInt64?
```

#### timestamp

the unix timestamp in seconds of the event

``` swift
public var timestamp: UInt64
```

#### layer

a identifier for a layer. for l1 this would by `eth-<CHAIN_ID>` for zksync :​ \`zk-<CONTRACT>\<CHAIN\_ID\>

``` swift
public var layer: String
```

#### events

a list of events happend within the tx

``` swift
public var events: [WalletTxEvent]
```
### WalletTxEvent

a list of events happend within the tx

``` swift
public struct WalletTxEvent 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(log_index:type:from:to:amount:old_amount:token:tx_hash:address:challenger:new_address:interval:gas:reason:)

initialize the WalletTxEvent

``` swift
public init(log_index: UInt32? = nil, type: String, from: String? = nil, to: String? = nil, amount: UInt256? = nil, old_amount: UInt256? = nil, token: String? = nil, tx_hash: String? = nil, address: String? = nil, challenger: String? = nil, new_address: String? = nil, interval: UInt32? = nil, gas: UInt32? = nil, reason: String? = nil) 
```

  - Parameter log\_index : the index of the event within a block

  - Parameter old\_amount : the previously set amount.

  - Parameter tx\_hash : the tx\_hash within the wallet

  - Parameter new\_address : the new address to set.

**Parameters**

  - type: the Name of the type. Must be one of `Transfer`, `Approval`, `ApproveHash`, `SignMsg`, `EnabledModule`, `DisabledModule`, `ExecutionFromModuleSuccess`, `ExecutionFromModuleFailure`, `AddedOwner`, `RemovedOwner`, `AddedRoles`, `RemovedRoles`, `RemovedOwnerDuringChallenge`, `ExecutionFailure`, `ExecutionSuccess`, `ChangedMasterCopy`, `AddedToAllowList`, `RemovedFromAllowList`, `ChallengeInitiated`, `ChallengeJoined`, `HeartbeatSuccessful`, `HeartbeatFailed`, `TransactionUnderLimitExecuted`, `LimitChanged`, `LimitAdded` or `ProxyCreation`
  - from: the source of a transfer. only valid for Transfer or Approval-Events
  - to: the recipient of a transfer. only valid for Transfer or Approval-Events
  - amount: the amount of a transfer or other wallet configurations.
  - token: the token-address or 0x0000... if eth.
  - address: the used address of the argument or module. (Does not have the to be the source of the event)
  - challenger: the used address of the challenger.
  - interval: the interval to set
  - gas: gas used for relay
  - reason: reason for a failed tx



#### log_index

the index of the event within a block

``` swift
public var log_index: UInt32?
```

#### type

the Name of the type. Must be one of `Transfer`, `Approval`, `ApproveHash`, `SignMsg`, `EnabledModule`, `DisabledModule`, `ExecutionFromModuleSuccess`, `ExecutionFromModuleFailure`, `AddedOwner`, `RemovedOwner`, `AddedRoles`, `RemovedRoles`, `RemovedOwnerDuringChallenge`, `ExecutionFailure`, `ExecutionSuccess`, `ChangedMasterCopy`, `AddedToAllowList`, `RemovedFromAllowList`, `ChallengeInitiated`, `ChallengeJoined`, `HeartbeatSuccessful`, `HeartbeatFailed`, `TransactionUnderLimitExecuted`, `LimitChanged`, `LimitAdded` or `ProxyCreation`

``` swift
public var type: String
```

#### from

the source of a transfer. only valid for Transfer or Approval-Events

``` swift
public var from: String?
```

#### to

the recipient of a transfer. only valid for Transfer or Approval-Events

``` swift
public var to: String?
```

#### amount

the amount of a transfer or other wallet configurations.

``` swift
public var amount: UInt256?
```

#### old_amount

the previously set amount.

``` swift
public var old_amount: UInt256?
```

#### token

the token-address or 0x0000... if eth.

``` swift
public var token: String?
```

#### tx_hash

the tx\_hash within the wallet

``` swift
public var tx_hash: String?
```

#### address

the used address of the argument or module. (Does not have the to be the source of the event)

``` swift
public var address: String?
```

#### challenger

the used address of the challenger.

``` swift
public var challenger: String?
```

#### new_address

the new address to set.

``` swift
public var new_address: String?
```

#### interval

the interval to set

``` swift
public var interval: UInt32?
```

#### gas

gas used for relay

``` swift
public var gas: UInt32?
```

#### reason

reason for a failed tx

``` swift
public var reason: String?
```
### WalletUpdate

the wallert-definition with the deployed address.

``` swift
public struct WalletUpdate 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(wallet:tx:account:deploy_tx:create2:musig_pub_keys:musig_urls:)

initialize the WalletUpdate

``` swift
public init(wallet: MsDef, tx: TxData? = nil, account: String? = nil, deploy_tx: ZkWalletDeployTx? = nil, create2: ZkWalletCreate2? = nil, musig_pub_keys: String? = nil, musig_urls: [String?]? = nil) 
```

  - Parameter deploy\_tx : the transaction which the user would need to deploy in order to create the wallet in Layer 1. The transaction could be send by anybody as long as it contains those data.

  - Parameter musig\_pub\_keys : the public keys of all the signer of the zksync musig key. This would be the user key first and then the approver-key.

  - Parameter musig\_urls : the list of urls to be used to get the signature to create a schnorr musig signature.

**Parameters**

  - wallet: the current wallet - definition
  - tx: the transaction for making the changes. If null then no changes were needed.
  - account: the address of the wallet
  - create2: the create-arguments you need to configure your wallet for zksync.



#### wallet

the current wallet - definition

``` swift
public var wallet: MsDef
```

#### tx

the transaction for making the changes. If null then no changes were needed.

``` swift
public var tx: TxData?
```

#### account

the address of the wallet

``` swift
public var account: String?
```

#### deploy_tx

the transaction which the user would need to deploy in order to create the wallet in Layer 1. The transaction could be send by anybody as long as it contains those data.

``` swift
public var deploy_tx: ZkWalletDeployTx?
```

#### create2

the create-arguments you need to configure your wallet for zksync.

``` swift
public var create2: ZkWalletCreate2?
```

#### musig_pub_keys

the public keys of all the signer of the zksync musig key. This would be the user key first and then the approver-key.

``` swift
public var musig_pub_keys: String?
```

#### musig_urls

the list of urls to be used to get the signature to create a schnorr musig signature.

``` swift
public var musig_urls: [String?]?
```
### ZkHistory

the data and state of the requested tx.

``` swift
public struct ZkHistory 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(tx_id:hash:eth_block:pq_id:success:fail_reason:commited:verified:created_at:tx:)

initialize the ZkHistory

``` swift
public init(tx_id: String, hash: String, eth_block: UInt64? = nil, pq_id: UInt64? = nil, success: Bool? = nil, fail_reason: String? = nil, commited: Bool, verified: Bool, created_at: String, tx: ZkTxHistoryInput) 
```

  - Parameter tx\_id : the transaction id based on the block-number and the index

  - Parameter eth\_block : the blockNumber of a priority-operation like `Deposit` otherwise this is null

  - Parameter pq\_id : the priority-operation id (for tx like `Deposit`) otherwise this is null

  - Parameter fail\_reason : the error message if failed, otherwise null

  - Parameter created\_at : UTC-Time when the transaction was created

**Parameters**

  - hash: the transaction hash
  - success: the result of the operation
  - commited: true if the tx was received and verified by the zksync-server
  - verified: true if the tx was received and verified by the zksync-server
  - tx: the transaction data



#### tx_id

the transaction id based on the block-number and the index

``` swift
public var tx_id: String
```

#### hash

the transaction hash

``` swift
public var hash: String
```

#### eth_block

the blockNumber of a priority-operation like `Deposit` otherwise this is null

``` swift
public var eth_block: UInt64?
```

#### pq_id

the priority-operation id (for tx like `Deposit`) otherwise this is null

``` swift
public var pq_id: UInt64?
```

#### success

the result of the operation

``` swift
public var success: Bool?
```

#### fail_reason

the error message if failed, otherwise null

``` swift
public var fail_reason: String?
```

#### commited

true if the tx was received and verified by the zksync-server

``` swift
public var commited: Bool
```

#### verified

true if the tx was received and verified by the zksync-server

``` swift
public var verified: Bool
```

#### created_at

UTC-Time when the transaction was created

``` swift
public var created_at: String
```

#### tx

the transaction data

``` swift
public var tx: ZkTxHistoryInput
```
### ZkReceipt

the transactionReceipt. use `zksync_tx_info` to check the progress.

``` swift
public struct ZkReceipt 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(type:accountId:from:to:token:amount:fee:nonce:txHash:tokenId:validFrom:validUntil:)

initialize the ZkReceipt

``` swift
public init(type: String, accountId: UInt64, from: String, to: String, token: UInt64, amount: UInt256, fee: UInt256, nonce: UInt64, txHash: String, tokenId: UInt64, validFrom: UInt64, validUntil: UInt64) 
```

**Parameters**

  - type: the Transaction-Type (`Withdraw`  or `Transfer`)
  - accountId: the id of the sender account
  - from: the address of the sender
  - to: the address of the receipient
  - token: the id of the token used
  - amount: the amount sent
  - fee: the fees paid
  - nonce: the fees paid
  - txHash: the transactionHash, which can be used to track the tx
  - tokenId: the token id
  - validFrom: valid from
  - validUntil: valid until



#### type

the Transaction-Type (`Withdraw`  or `Transfer`)

``` swift
public var type: String
```

#### accountId

the id of the sender account

``` swift
public var accountId: UInt64
```

#### from

the address of the sender

``` swift
public var from: String
```

#### to

the address of the receipient

``` swift
public var to: String
```

#### token

the id of the token used

``` swift
public var token: UInt64
```

#### amount

the amount sent

``` swift
public var amount: UInt256
```

#### fee

the fees paid

``` swift
public var fee: UInt256
```

#### nonce

the fees paid

``` swift
public var nonce: UInt64
```

#### txHash

the transactionHash, which can be used to track the tx

``` swift
public var txHash: String
```

#### tokenId

the token id

``` swift
public var tokenId: UInt64
```

#### validFrom

valid from

``` swift
public var validFrom: UInt64
```

#### validUntil

valid until

``` swift
public var validUntil: UInt64
```
### ZkSyncAccountInfo

the current state of the requested account.

``` swift
public struct ZkSyncAccountInfo 
```



#### init(address:committed:depositing:id:verified:)

initialize the ZkSyncAccountInfo

``` swift
public init(address: String, committed: ZkSyncAccountState, depositing: ZkSyncAccountInfoDepositing, id: UInt64? = nil, verified: ZkSyncAccountState) 
```

**Parameters**

  - address: the address of the account
  - committed: the state of the zksync operator after executing transactions successfully, but not not verified on L1 yet.
  - depositing: the state of all depositing-tx.
  - id: the assigned id of the account, which will be used when encoding it into the rollup.
  - verified: the state after the rollup was verified in L1.

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(address:committed:depositing:id:verified:)

initialize the ZkSyncAccountInfo

``` swift
public init(address: String, committed: ZkSyncAccountState, depositing: ZkSyncAccountInfoDepositing, id: UInt64? = nil, verified: ZkSyncAccountState) 
```

**Parameters**

  - address: the address of the account
  - committed: the state of the zksync operator after executing transactions successfully, but not not verified on L1 yet.
  - depositing: the state of all depositing-tx.
  - id: the assigned id of the account, which will be used when encoding it into the rollup.
  - verified: the state after the rollup was verified in L1.



#### address

the address of the account

``` swift
public var address: String
```

#### committed

the state of the zksync operator after executing transactions successfully, but not not verified on L1 yet.

``` swift
public var committed: ZkSyncAccountState
```

#### depositing

the state of all depositing-tx.

``` swift
public var depositing: ZkSyncAccountInfoDepositing
```

#### id

the assigned id of the account, which will be used when encoding it into the rollup.

``` swift
public var id: UInt64?
```

#### verified

the state after the rollup was verified in L1.

``` swift
public var verified: ZkSyncAccountState
```

#### address

the address of the account

``` swift
public var address: String
```

#### committed

the state of the zksync operator after executing transactions successfully, but not not verified on L1 yet.

``` swift
public var committed: ZkSyncAccountState
```

#### depositing

the state of all depositing-tx.

``` swift
public var depositing: ZkSyncAccountInfoDepositing
```

#### id

the assigned id of the account, which will be used when encoding it into the rollup.

``` swift
public var id: UInt64?
```

#### verified

the state after the rollup was verified in L1.

``` swift
public var verified: ZkSyncAccountState
```
### ZkSyncAccountInfoDepositing

the state of all depositing-tx.

``` swift
public struct ZkSyncAccountInfoDepositing 
```



#### init(balances:)

initialize the ZkSyncAccountInfoDepositing

``` swift
public init(balances: [String:UInt256]) 
```

**Parameters**

  - balances: the token-values.

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(balances:)

initialize the ZkSyncAccountInfoDepositing

``` swift
public init(balances: [String:UInt256]) 
```

**Parameters**

  - balances: the token-values.



#### balances

the token-values.

``` swift
public var balances: [String:UInt256]
```

#### balances

the token-values.

``` swift
public var balances: [String:UInt256]
```
### ZkSyncAccountState

the state of the zksync operator after executing transactions successfully, but not not verified on L1 yet.

``` swift
public struct ZkSyncAccountState 
```



#### init(balances:nonce:pubKeyHash:mintedNfts:nfts:)

initialize the ZkSyncAccountState

``` swift
public init(balances: [String:UInt256], nonce: UInt64, pubKeyHash: String, mintedNfts: [String:UInt256], nfts: [String:UInt256]) 
```

**Parameters**

  - balances: the token-balance
  - nonce: the nonce or transaction count.
  - pubKeyHash: the pubKeyHash set for the requested account or `0x0000...` if not set yet.
  - mintedNfts: the minted NFTs
  - nfts: the minted NFTs

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(balances:nonce:pubKeyHash:mintedNfts:nfts:)

initialize the ZkSyncAccountState

``` swift
public init(balances: [String:UInt256], nonce: UInt64, pubKeyHash: String, mintedNfts: [String:UInt256], nfts: [String:UInt256]) 
```

**Parameters**

  - balances: the token-balance
  - nonce: the nonce or transaction count.
  - pubKeyHash: the pubKeyHash set for the requested account or `0x0000...` if not set yet.
  - mintedNfts: the minted NFTs
  - nfts: the minted NFTs



#### balances

the token-balance

``` swift
public var balances: [String:UInt256]
```

#### nonce

the nonce or transaction count.

``` swift
public var nonce: UInt64
```

#### pubKeyHash

the pubKeyHash set for the requested account or `0x0000...` if not set yet.

``` swift
public var pubKeyHash: String
```

#### mintedNfts

the minted NFTs

``` swift
public var mintedNfts: [String:UInt256]
```

#### nfts

the minted NFTs

``` swift
public var nfts: [String:UInt256]
```

#### balances

the token-balance

``` swift
public var balances: [String:UInt256]
```

#### nonce

the nonce or transaction count.

``` swift
public var nonce: UInt64
```

#### pubKeyHash

the pubKeyHash set for the requested account or `0x0000...` if not set yet.

``` swift
public var pubKeyHash: String
```

#### mintedNfts

the minted NFTs

``` swift
public var mintedNfts: [String:UInt256]
```

#### nfts

the minted NFTs

``` swift
public var nfts: [String:UInt256]
```
### ZkSyncContractDefinition

fetches the contract addresses from the zksync server. This request also caches them and will return the results from cahe if available.

``` swift
public struct ZkSyncContractDefinition 
```



#### init(govContract:mainContract:)

initialize the ZkSyncContractDefinition

``` swift
public init(govContract: String, mainContract: String) 
```

**Parameters**

  - govContract: the address of the govement contract
  - mainContract: the address of the main contract

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(govContract:mainContract:)

initialize the ZkSyncContractDefinition

``` swift
public init(govContract: String, mainContract: String) 
```

**Parameters**

  - govContract: the address of the govement contract
  - mainContract: the address of the main contract



#### govContract

the address of the govement contract

``` swift
public var govContract: String
```

#### mainContract

the address of the main contract

``` swift
public var mainContract: String
```

#### govContract

the address of the govement contract

``` swift
public var govContract: String
```

#### mainContract

the address of the main contract

``` swift
public var mainContract: String
```
### ZkSyncDepositResult

the receipt and the receipopId. You can use `zksync_ethop_info` to follow the state-changes.

``` swift
public struct ZkSyncDepositResult 
```



#### init(receipt:priorityOpId:)

initialize the ZkSyncDepositResult

``` swift
public init(receipt: ZksyncEthTransactionReceipt, priorityOpId: UInt64) 
```

**Parameters**

  - receipt: the transactionreceipt
  - priorityOpId: the operationId to rack to progress

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(receipt:priorityOpId:)

initialize the ZkSyncDepositResult

``` swift
public init(receipt: EthTransactionReceipt, priorityOpId: UInt64) 
```

**Parameters**

  - receipt: the transactionreceipt
  - priorityOpId: the operationId to rack to progress



#### receipt

the transactionreceipt

``` swift
public var receipt: ZksyncEthTransactionReceipt
```

#### priorityOpId

the operationId to rack to progress

``` swift
public var priorityOpId: UInt64
```

#### receipt

the transactionreceipt

``` swift
public var receipt: EthTransactionReceipt
```

#### priorityOpId

the operationId to rack to progress

``` swift
public var priorityOpId: UInt64
```
### ZkSyncEthopInfo

state of the PriorityOperation

``` swift
public struct ZkSyncEthopInfo 
```



#### init(block:executed:)

initialize the ZkSyncEthopInfo

``` swift
public init(block: ZkSyncEthopInfoBlock? = nil, executed: Bool) 
```

**Parameters**

  - block: the block
  - executed: if the operation was executed

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(block:executed:)

initialize the ZkSyncEthopInfo

``` swift
public init(block: ZkSyncEthopInfoBlock? = nil, executed: Bool) 
```

**Parameters**

  - block: the block
  - executed: if the operation was executed



#### block

the block

``` swift
public var block: ZkSyncEthopInfoBlock?
```

#### executed

if the operation was executed

``` swift
public var executed: Bool
```

#### block

the block

``` swift
public var block: ZkSyncEthopInfoBlock?
```

#### executed

if the operation was executed

``` swift
public var executed: Bool
```
### ZkSyncEthopInfoBlock

the block

``` swift
public struct ZkSyncEthopInfoBlock 
```



#### init(committed:verified:blockNumber:)

initialize the ZkSyncEthopInfoBlock

``` swift
public init(committed: Bool, verified: Bool, blockNumber: UInt64? = nil) 
```

**Parameters**

  - committed: state of the operation
  - verified: if the opteration id has been included in the rollup block
  - blockNumber: the blocknumber of the block that included the operation

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(committed:verified:blockNumber:)

initialize the ZkSyncEthopInfoBlock

``` swift
public init(committed: Bool, verified: Bool, blockNumber: UInt64? = nil) 
```

**Parameters**

  - committed: state of the operation
  - verified: if the opteration id has been included in the rollup block
  - blockNumber: the blocknumber of the block that included the operation



#### committed

state of the operation

``` swift
public var committed: Bool
```

#### verified

if the opteration id has been included in the rollup block

``` swift
public var verified: Bool
```

#### blockNumber

the blocknumber of the block that included the operation

``` swift
public var blockNumber: UInt64?
```

#### committed

state of the operation

``` swift
public var committed: Bool
```

#### verified

if the opteration id has been included in the rollup block

``` swift
public var verified: Bool
```

#### blockNumber

the blocknumber of the block that included the operation

``` swift
public var blockNumber: UInt64?
```
### ZkSyncFeeInfo

the fees split up into single values

``` swift
public struct ZkSyncFeeInfo 
```



#### init(feeType:gasFee:gasPriceWei:gasTxAmount:totalFee:zkpFee:)

initialize the ZkSyncFeeInfo

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

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(feeType:gasFee:gasPriceWei:gasTxAmount:totalFee:zkpFee:)

initialize the ZkSyncFeeInfo

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
public var feeType: String
```

#### gasFee

the gas for the core-transaction

``` swift
public var gasFee: UInt64
```

#### gasPriceWei

current gasPrice

``` swift
public var gasPriceWei: UInt64
```

#### gasTxAmount

gasTxAmount

``` swift
public var gasTxAmount: UInt64
```

#### totalFee

total of all fees needed to pay in order to execute the transaction

``` swift
public var totalFee: UInt64
```

#### zkpFee

zkpFee

``` swift
public var zkpFee: UInt64
```

#### feeType

Type of the transaaction

``` swift
public var feeType: String
```

#### gasFee

the gas for the core-transaction

``` swift
public var gasFee: UInt64
```

#### gasPriceWei

current gasPrice

``` swift
public var gasPriceWei: UInt64
```

#### gasTxAmount

gasTxAmount

``` swift
public var gasTxAmount: UInt64
```

#### totalFee

total of all fees needed to pay in order to execute the transaction

``` swift
public var totalFee: UInt64
```

#### zkpFee

zkpFee

``` swift
public var zkpFee: UInt64
```
### ZkSyncToken

a array of tokens-definitions. This request also caches them and will return the results from cahe if available.

``` swift
public struct ZkSyncToken 
```



#### init(address:decimals:id:symbol:)

initialize the ZkSyncToken

``` swift
public init(address: String, decimals: Int, id: UInt64, symbol: String) 
```

**Parameters**

  - address: the address of the ERC2-Contract or 0x00000..000 in case of the native token (eth)
  - decimals: decimals to be used when formating it for human readable representation.
  - id: id which will be used when encoding the token.
  - symbol: symbol for the token

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(address:decimals:id:symbol:)

initialize the ZkSyncToken

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
public var address: String
```

#### decimals

decimals to be used when formating it for human readable representation.

``` swift
public var decimals: Int
```

#### id

id which will be used when encoding the token.

``` swift
public var id: UInt64
```

#### symbol

symbol for the token

``` swift
public var symbol: String
```

#### address

the address of the ERC2-Contract or 0x00000..000 in case of the native token (eth)

``` swift
public var address: String
```

#### decimals

decimals to be used when formating it for human readable representation.

``` swift
public var decimals: Int
```

#### id

id which will be used when encoding the token.

``` swift
public var id: UInt64
```

#### symbol

symbol for the token

``` swift
public var symbol: String
```
### ZkSyncTransactionBlock

the block

``` swift
public struct ZkSyncTransactionBlock 
```



#### init(blockNumber:committed:verified:)

initialize the ZkSyncTransactionBlock

``` swift
public init(blockNumber: UInt64, committed: Bool, verified: Bool) 
```

**Parameters**

  - blockNumber: the blockNumber containing the tx or `null` if still pending
  - committed: true, if the block has been commited
  - verified: true, if the block has been verified

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(blockNumber:committed:verified:)

initialize the ZkSyncTransactionBlock

``` swift
public init(blockNumber: UInt64, committed: Bool, verified: Bool) 
```

**Parameters**

  - blockNumber: the blockNumber containing the tx or `null` if still pending
  - committed: true, if the block has been commited
  - verified: true, if the block has been verified



#### blockNumber

the blockNumber containing the tx or `null` if still pending

``` swift
public var blockNumber: UInt64
```

#### committed

true, if the block has been commited

``` swift
public var committed: Bool
```

#### verified

true, if the block has been verified

``` swift
public var verified: Bool
```

#### blockNumber

the blockNumber containing the tx or `null` if still pending

``` swift
public var blockNumber: UInt64
```

#### committed

true, if the block has been commited

``` swift
public var committed: Bool
```

#### verified

true, if the block has been verified

``` swift
public var verified: Bool
```
### ZkSyncTxData

the data and state of the requested tx.

``` swift
public struct ZkSyncTxData 
```



#### init(block_number:tx_type:from:to:token:amount:fee:nonce:created_at:tx:fail_reason:)

initialize the ZkSyncTxData

``` swift
public init(block_number: UInt64? = nil, tx_type: String, from: String, to: String, token: UInt64, amount: UInt256, fee: UInt256, nonce: UInt64, created_at: String, tx: ZksyncZkTx, fail_reason: String? = nil) 
```

  - Parameter block\_number : the blockNumber containing the tx or `null` if still pending

  - Parameter tx\_type : Type of the transaction. `Transfer`, `ChangePubKey` or `Withdraw`

  - Parameter created\_at : the timestamp as UTC

  - Parameter fail\_reason : the fail reason

**Parameters**

  - from: The sender of the address
  - to: The recipient of the address
  - token: The token id
  - amount: the amount sent
  - fee: the fee payed
  - nonce: the nonce of the account
  - tx: the tx input data

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(block_number:tx_type:from:to:token:amount:fee:nonce:created_at:tx:fail_reason:)

initialize the ZkSyncTxData

``` swift
public init(block_number: UInt64? = nil, tx_type: String, from: String, to: String, token: UInt64, amount: UInt256, fee: UInt256, nonce: UInt64, created_at: String, tx: ZkTx, fail_reason: String? = nil) 
```

  - Parameter block\_number : the blockNumber containing the tx or `null` if still pending

  - Parameter tx\_type : Type of the transaction. `Transfer`, `ChangePubKey` or `Withdraw`

  - Parameter created\_at : the timestamp as UTC

  - Parameter fail\_reason : the fail reason

**Parameters**

  - from: The sender of the address
  - to: The recipient of the address
  - token: The token id
  - amount: the amount sent
  - fee: the fee payed
  - nonce: the nonce of the account
  - tx: the tx input data



#### block_number

the blockNumber containing the tx or `null` if still pending

``` swift
public var block_number: UInt64?
```

#### tx_type

Type of the transaction. `Transfer`, `ChangePubKey` or `Withdraw`

``` swift
public var tx_type: String
```

#### from

The sender of the address

``` swift
public var from: String
```

#### to

The recipient of the address

``` swift
public var to: String
```

#### token

The token id

``` swift
public var token: UInt64
```

#### amount

the amount sent

``` swift
public var amount: UInt256
```

#### fee

the fee payed

``` swift
public var fee: UInt256
```

#### nonce

the nonce of the account

``` swift
public var nonce: UInt64
```

#### created_at

the timestamp as UTC

``` swift
public var created_at: String
```

#### tx

the tx input data

``` swift
public var tx: ZksyncZkTx
```

#### fail_reason

the fail reason

``` swift
public var fail_reason: String?
```

#### block_number

the blockNumber containing the tx or `null` if still pending

``` swift
public var block_number: UInt64?
```

#### tx_type

Type of the transaction. `Transfer`, `ChangePubKey` or `Withdraw`

``` swift
public var tx_type: String
```

#### from

The sender of the address

``` swift
public var from: String
```

#### to

The recipient of the address

``` swift
public var to: String
```

#### token

The token id

``` swift
public var token: UInt64
```

#### amount

the amount sent

``` swift
public var amount: UInt256
```

#### fee

the fee payed

``` swift
public var fee: UInt256
```

#### nonce

the nonce of the account

``` swift
public var nonce: UInt64
```

#### created_at

the timestamp as UTC

``` swift
public var created_at: String
```

#### tx

the tx input data

``` swift
public var tx: ZkTx
```

#### fail_reason

the fail reason

``` swift
public var fail_reason: String?
```
### ZkSyncTxInfo

the current state of the requested tx.

``` swift
public struct ZkSyncTxInfo 
```



#### init(block:executed:success:failReason:)

initialize the ZkSyncTxInfo

``` swift
public init(block: ZkSyncTransactionBlock? = nil, executed: Bool, success: Bool? = nil, failReason: String? = nil) 
```

**Parameters**

  - block: the block
  - executed: true, if the tx has been executed by the operator. If false it is still in the txpool of the operator.
  - success: if executed, this property marks the success of the tx.
  - failReason: if executed and failed this will include an error message

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(block:executed:success:failReason:)

initialize the ZkSyncTxInfo

``` swift
public init(block: ZkSyncTransactionBlock? = nil, executed: Bool, success: Bool? = nil, failReason: String? = nil) 
```

**Parameters**

  - block: the block
  - executed: true, if the tx has been executed by the operator. If false it is still in the txpool of the operator.
  - success: if executed, this property marks the success of the tx.
  - failReason: if executed and failed this will include an error message



#### block

the block

``` swift
public var block: ZkSyncTransactionBlock?
```

#### executed

true, if the tx has been executed by the operator. If false it is still in the txpool of the operator.

``` swift
public var executed: Bool
```

#### success

if executed, this property marks the success of the tx.

``` swift
public var success: Bool?
```

#### failReason

if executed and failed this will include an error message

``` swift
public var failReason: String?
```

#### block

the block

``` swift
public var block: ZkSyncTransactionBlock?
```

#### executed

true, if the tx has been executed by the operator. If false it is still in the txpool of the operator.

``` swift
public var executed: Bool
```

#### success

if executed, this property marks the success of the tx.

``` swift
public var success: Bool?
```

#### failReason

if executed and failed this will include an error message

``` swift
public var failReason: String?
```
### ZkTx

the tx input data

``` swift
public struct ZkTx 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(accountId:from:to:token:amount:fee:nonce:validFrom:validUntil:signature:type:)

initialize the ZkTx

``` swift
public init(accountId: UInt64, from: String, to: String, token: UInt64, amount: UInt256, fee: UInt256, nonce: UInt64, validFrom: UInt64, validUntil: UInt64, signature: ZkTxSignature, type: String? = nil) 
```

**Parameters**

  - accountId: the id of the sender account
  - from: the address of the sender
  - to: the address of the receipient
  - token: the id of the token used
  - amount: the amount sent
  - fee: the fees paid
  - nonce: the fees paid
  - validFrom: timestamp set by the sender when the valid range starts
  - validUntil: timestamp set by the sender when the valid range ends
  - signature: the sync signature
  - type: the transaction type



#### accountId

the id of the sender account

``` swift
public var accountId: UInt64
```

#### from

the address of the sender

``` swift
public var from: String
```

#### to

the address of the receipient

``` swift
public var to: String
```

#### token

the id of the token used

``` swift
public var token: UInt64
```

#### amount

the amount sent

``` swift
public var amount: UInt256
```

#### fee

the fees paid

``` swift
public var fee: UInt256
```

#### nonce

the fees paid

``` swift
public var nonce: UInt64
```

#### validFrom

timestamp set by the sender when the valid range starts

``` swift
public var validFrom: UInt64
```

#### validUntil

timestamp set by the sender when the valid range ends

``` swift
public var validUntil: UInt64
```

#### signature

the sync signature

``` swift
public var signature: ZkTxSignature
```

#### type

the transaction type

``` swift
public var type: String?
```
### ZkTxHistoryEthAuthData

the 2fa euth authorition

``` swift
public struct ZkTxHistoryEthAuthData 
```



#### init(type:saltArg:codeHash:creatorAddress:)

initialize the ZkTxHistoryEthAuthData

``` swift
public init(type: String, saltArg: String? = nil, codeHash: String? = nil, creatorAddress: String? = nil) 
```

**Parameters**

  - type: the type which should be CREATE2, ECDSA
  - saltArg: the hash component (only if type=CREATE2)
  - codeHash: the hash of the deployment-data (only if type=CREATE2)
  - creatorAddress: the address of the the deploying contract (only if type=CREATE2)

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(type:saltArg:codeHash:creatorAddress:)

initialize the ZkTxHistoryEthAuthData

``` swift
public init(type: String, saltArg: String? = nil, codeHash: String? = nil, creatorAddress: String? = nil) 
```

**Parameters**

  - type: the type which should be CREATE2, ECDSA
  - saltArg: the hash component (only if type=CREATE2)
  - codeHash: the hash of the deployment-data (only if type=CREATE2)
  - creatorAddress: the address of the the deploying contract (only if type=CREATE2)



#### type

the type which should be CREATE2, ECDSA

``` swift
public var type: String
```

#### saltArg

the hash component (only if type=CREATE2)

``` swift
public var saltArg: String?
```

#### codeHash

the hash of the deployment-data (only if type=CREATE2)

``` swift
public var codeHash: String?
```

#### creatorAddress

the address of the the deploying contract (only if type=CREATE2)

``` swift
public var creatorAddress: String?
```

#### type

the type which should be CREATE2, ECDSA

``` swift
public var type: String
```

#### saltArg

the hash component (only if type=CREATE2)

``` swift
public var saltArg: String?
```

#### codeHash

the hash of the deployment-data (only if type=CREATE2)

``` swift
public var codeHash: String?
```

#### creatorAddress

the address of the the deploying contract (only if type=CREATE2)

``` swift
public var creatorAddress: String?
```
### ZkTxHistoryInput

the transaction data

``` swift
public struct ZkTxHistoryInput 
```



#### init(type:from:to:token:amount:account:accountId:newPkHash:validFrom:validUntil:signature:fee:feeToken:nonce:priority_op:ethAuthData:)

initialize the ZkTxHistoryInput

``` swift
public init(type: String, from: String? = nil, to: String? = nil, token: String? = nil, amount: UInt256? = nil, account: String? = nil, accountId: UInt64? = nil, newPkHash: String? = nil, validFrom: UInt64? = nil, validUntil: UInt64? = nil, signature: ZkTxSignature? = nil, fee: UInt256? = nil, feeToken: UInt64? = nil, nonce: UInt64? = nil, priority_op: ZkTxHistoryPriorityOp? = nil, ethAuthData: ZkTxHistoryEthAuthData? = nil) 
```

  - Parameter priority\_op : the description of a priority operation like `Deposit`

**Parameters**

  - type: Type of the transaction. `Transfer`, `ChangePubKey` or `Withdraw`
  - from: The sender of the address
  - to: The recipient of the address
  - token: The token id
  - amount: the amount sent
  - account: the account sent from
  - accountId: the account id used
  - newPkHash: the new public Key Hash (only used if the type is CHangePubKey)
  - validFrom: timestamp set by the sender when the valid range starts
  - validUntil: timestamp set by the sender when the valid range ends
  - signature: the sync signature
  - fee: the fee payed
  - feeToken: the token the fee was payed
  - nonce: the nonce of the account
  - ethAuthData: the 2fa euth authorition

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(type:from:to:token:amount:account:accountId:newPkHash:validFrom:validUntil:signature:fee:feeToken:nonce:priority_op:ethAuthData:)

initialize the ZkTxHistoryInput

``` swift
public init(type: String, from: String? = nil, to: String? = nil, token: String? = nil, amount: UInt256? = nil, account: String? = nil, accountId: UInt64? = nil, newPkHash: String? = nil, validFrom: UInt64? = nil, validUntil: UInt64? = nil, signature: ZkTxSignature? = nil, fee: UInt256? = nil, feeToken: UInt64? = nil, nonce: UInt64? = nil, priority_op: ZkTxHistoryPriorityOp? = nil, ethAuthData: ZkTxHistoryEthAuthData? = nil) 
```

  - Parameter priority\_op : the description of a priority operation like `Deposit`

**Parameters**

  - type: Type of the transaction. `Transfer`, `ChangePubKey` or `Withdraw`
  - from: The sender of the address
  - to: The recipient of the address
  - token: The token id
  - amount: the amount sent
  - account: the account sent from
  - accountId: the account id used
  - newPkHash: the new public Key Hash (only used if the type is CHangePubKey)
  - validFrom: timestamp set by the sender when the valid range starts
  - validUntil: timestamp set by the sender when the valid range ends
  - signature: the sync signature
  - fee: the fee payed
  - feeToken: the token the fee was payed
  - nonce: the nonce of the account
  - ethAuthData: the 2fa euth authorition



#### type

Type of the transaction. `Transfer`, `ChangePubKey` or `Withdraw`

``` swift
public var type: String
```

#### from

The sender of the address

``` swift
public var from: String?
```

#### to

The recipient of the address

``` swift
public var to: String?
```

#### token

The token id

``` swift
public var token: String?
```

#### amount

the amount sent

``` swift
public var amount: UInt256?
```

#### account

the account sent from

``` swift
public var account: String?
```

#### accountId

the account id used

``` swift
public var accountId: UInt64?
```

#### newPkHash

the new public Key Hash (only used if the type is CHangePubKey)

``` swift
public var newPkHash: String?
```

#### validFrom

timestamp set by the sender when the valid range starts

``` swift
public var validFrom: UInt64?
```

#### validUntil

timestamp set by the sender when the valid range ends

``` swift
public var validUntil: UInt64?
```

#### signature

the sync signature

``` swift
public var signature: ZkTxSignature?
```

#### fee

the fee payed

``` swift
public var fee: UInt256?
```

#### feeToken

the token the fee was payed

``` swift
public var feeToken: UInt64?
```

#### nonce

the nonce of the account

``` swift
public var nonce: UInt64?
```

#### priority_op

the description of a priority operation like `Deposit`

``` swift
public var priority_op: ZkTxHistoryPriorityOp?
```

#### ethAuthData

the 2fa euth authorition

``` swift
public var ethAuthData: ZkTxHistoryEthAuthData?
```

#### type

Type of the transaction. `Transfer`, `ChangePubKey` or `Withdraw`

``` swift
public var type: String
```

#### from

The sender of the address

``` swift
public var from: String?
```

#### to

The recipient of the address

``` swift
public var to: String?
```

#### token

The token id

``` swift
public var token: String?
```

#### amount

the amount sent

``` swift
public var amount: UInt256?
```

#### account

the account sent from

``` swift
public var account: String?
```

#### accountId

the account id used

``` swift
public var accountId: UInt64?
```

#### newPkHash

the new public Key Hash (only used if the type is CHangePubKey)

``` swift
public var newPkHash: String?
```

#### validFrom

timestamp set by the sender when the valid range starts

``` swift
public var validFrom: UInt64?
```

#### validUntil

timestamp set by the sender when the valid range ends

``` swift
public var validUntil: UInt64?
```

#### signature

the sync signature

``` swift
public var signature: ZkTxSignature?
```

#### fee

the fee payed

``` swift
public var fee: UInt256?
```

#### feeToken

the token the fee was payed

``` swift
public var feeToken: UInt64?
```

#### nonce

the nonce of the account

``` swift
public var nonce: UInt64?
```

#### priority_op

the description of a priority operation like `Deposit`

``` swift
public var priority_op: ZkTxHistoryPriorityOp?
```

#### ethAuthData

the 2fa euth authorition

``` swift
public var ethAuthData: ZkTxHistoryEthAuthData?
```
### ZkTxHistoryPriorityOp

the description of a priority operation like `Deposit`

``` swift
public struct ZkTxHistoryPriorityOp 
```



#### init(from:to:token:amount:)

initialize the ZkTxHistoryPriorityOp

``` swift
public init(from: String, to: String, token: String, amount: UInt256) 
```

**Parameters**

  - from: The sender of the address
  - to: The recipient of the address
  - token: The token id
  - amount: the amount sent

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(from:to:token:amount:)

initialize the ZkTxHistoryPriorityOp

``` swift
public init(from: String, to: String, token: String, amount: UInt256) 
```

**Parameters**

  - from: The sender of the address
  - to: The recipient of the address
  - token: The token id
  - amount: the amount sent



#### from

The sender of the address

``` swift
public var from: String
```

#### to

The recipient of the address

``` swift
public var to: String
```

#### token

The token id

``` swift
public var token: String
```

#### amount

the amount sent

``` swift
public var amount: UInt256
```

#### from

The sender of the address

``` swift
public var from: String
```

#### to

The recipient of the address

``` swift
public var to: String
```

#### token

The token id

``` swift
public var token: String
```

#### amount

the amount sent

``` swift
public var amount: UInt256
```
### ZkTxSignature

the sync signature

``` swift
public struct ZkTxSignature 
```



#### init(pubKey:signature:)

initialize the ZkTxSignature

``` swift
public init(pubKey: String, signature: String) 
```

**Parameters**

  - pubKey: the public key of the signer
  - signature: the signature

#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(pubKey:signature:)

initialize the ZkTxSignature

``` swift
public init(pubKey: String, signature: String) 
```

**Parameters**

  - pubKey: the public key of the signer
  - signature: the signature



#### pubKey

the public key of the signer

``` swift
public var pubKey: String
```

#### signature

the signature

``` swift
public var signature: String
```

#### pubKey

the public key of the signer

``` swift
public var pubKey: String
```

#### signature

the signature

``` swift
public var signature: String
```
### ZkWallet

the new wallet-config.

``` swift
public struct ZkWallet 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(address:threshold:signer:owners:)

initialize the ZkWallet

``` swift
public init(address: String, threshold: Int, signer: String, owners: [ZkWalletOwner]) 
```

**Parameters**

  - address: the address of the wallet
  - threshold: the minimal number of signatures needed for the multisig to approve a transaction. It must be at least one and less or equal to the number of owners.
  - signer: the public key of the zksync signer
  - owners: the owners of multisig



#### address

the address of the wallet

``` swift
public var address: String
```

#### threshold

the minimal number of signatures needed for the multisig to approve a transaction. It must be at least one and less or equal to the number of owners.

``` swift
public var threshold: Int
```

#### signer

the public key of the zksync signer

``` swift
public var signer: String
```

#### owners

the owners of multisig

``` swift
public var owners: [ZkWalletOwner]
```
### ZkWalletCreate2

the create-arguments you need to configure your wallet for zksync.

``` swift
public struct ZkWalletCreate2 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(creator:saltarg:codehash:)

initialize the ZkWalletCreate2

``` swift
public init(creator: String, saltarg: String, codehash: String) 
```

**Parameters**

  - creator: the sender deploying the wallet, which is the factory.
  - saltarg: the hash of the init-transaction and is used together with the pubkeyhash to determine the account address
  - codehash: the hash of the creator-tx, which is the tx send from the factory to deploy the proxy. This also includes the mastercopy as argument



#### creator

the sender deploying the wallet, which is the factory.

``` swift
public var creator: String
```

#### saltarg

the hash of the init-transaction and is used together with the pubkeyhash to determine the account address

``` swift
public var saltarg: String
```

#### codehash

the hash of the creator-tx, which is the tx send from the factory to deploy the proxy. This also includes the mastercopy as argument

``` swift
public var codehash: String
```
### ZkWalletDefinitionResult

a collection of relevant data you may need for the new wallet

``` swift
public struct ZkWalletDefinitionResult 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(account:deploy_tx:create2:musig_pub_keys:musig_urls:wallet:)

initialize the ZkWalletDefinitionResult

``` swift
public init(account: String, deploy_tx: ZkWalletDeployTx, create2: ZkWalletCreate2, musig_pub_keys: String, musig_urls: [String?]? = nil, wallet: MsDef) 
```

  - Parameter deploy\_tx : the transaction which the user would need to deploy in order to create the wallet in Layer 1. The transaction could be send by anybody as long as it contains those data.

  - Parameter musig\_pub\_keys : the public keys of all the signer of the zksync musig key. This would be the user key first and then the approver-key.

  - Parameter musig\_urls : the list of urls to be used to get the signature to create a schnorr musig signature.

**Parameters**

  - account: the address of the wallet
  - create2: the create-arguments you need to configure your wallet for zksync.
  - wallet: the wallet setup



#### account

the address of the wallet

``` swift
public var account: String
```

#### deploy_tx

the transaction which the user would need to deploy in order to create the wallet in Layer 1. The transaction could be send by anybody as long as it contains those data.

``` swift
public var deploy_tx: ZkWalletDeployTx
```

#### create2

the create-arguments you need to configure your wallet for zksync.

``` swift
public var create2: ZkWalletCreate2
```

#### musig_pub_keys

the public keys of all the signer of the zksync musig key. This would be the user key first and then the approver-key.

``` swift
public var musig_pub_keys: String
```

#### musig_urls

the list of urls to be used to get the signature to create a schnorr musig signature.

``` swift
public var musig_urls: [String?]?
```

#### wallet

the wallet setup

``` swift
public var wallet: MsDef
```
### ZkWalletDeployTx

the transaction which the user would need to deploy in order to create the wallet in Layer 1. The transaction could be send by anybody as long as it contains those data.

``` swift
public struct ZkWalletDeployTx 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(data:to:)

initialize the ZkWalletDeployTx

``` swift
public init(data: String, to: String) 
```

**Parameters**

  - data: the data to send to the factory
  - to: the recipient, which is the factory



#### data

the data to send to the factory

``` swift
public var data: String
```

#### to

the recipient, which is the factory

``` swift
public var to: String
```
### ZkWalletOwner

the owners of multisig

``` swift
public struct ZkWalletOwner 
```



#### init?(json:)

initializes from json

``` swift
public init?(json: String) throws 
```

**Parameters**

  - json: the json-string

#### init(roles:address:)

initialize the ZkWalletOwner

``` swift
public init(roles: Int, address: String) 
```

**Parameters**

  - roles: the bitmask representing the combined roles.
  - address: address of the owner



#### roles

the bitmask representing the combined roles.

``` swift
public var roles: Int
```

#### address

address of the owner

``` swift
public var address: String
```
### ZksyncEthTransactionReceipt

the transactionreceipt

``` swift
public struct ZksyncEthTransactionReceipt 
```



#### init(blockNumber:blockHash:contractAddress:cumulativeGasUsed:gasUsed:effectiveGasPrice:logs:logsBloom:status:transactionHash:transactionIndex:from:type:to:)

initialize the ZksyncEthTransactionReceipt

``` swift
public init(blockNumber: UInt64, blockHash: String, contractAddress: String? = nil, cumulativeGasUsed: UInt64, gasUsed: UInt64, effectiveGasPrice: UInt256? = nil, logs: [ZksyncEthlog], logsBloom: String, status: Int, transactionHash: String, transactionIndex: Int, from: String, type: Int? = nil, to: String? = nil) 
```

**Parameters**

  - blockNumber: the blockNumber
  - blockHash: blockhash if ther containing block
  - contractAddress: the deployed contract in case the tx did deploy a new contract
  - cumulativeGasUsed: gas used for all transaction up to this one in the block
  - gasUsed: gas used by this transaction.
  - effectiveGasPrice: the efficte gas price
  - logs: array of events created during execution of the tx
  - logsBloom: bloomfilter used to detect events for `eth_getLogs`
  - status: error-status of the tx.  0x1 = success 0x0 = failure
  - transactionHash: requested transactionHash
  - transactionIndex: transactionIndex within the containing block.
  - from: address of the sender.
  - type: the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)
  - to: address of the receiver. null when its a contract creation transaction.



#### blockNumber

the blockNumber

``` swift
public var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
public var blockHash: String
```

#### contractAddress

the deployed contract in case the tx did deploy a new contract

``` swift
public var contractAddress: String?
```

#### cumulativeGasUsed

gas used for all transaction up to this one in the block

``` swift
public var cumulativeGasUsed: UInt64
```

#### gasUsed

gas used by this transaction.

``` swift
public var gasUsed: UInt64
```

#### effectiveGasPrice

the efficte gas price

``` swift
public var effectiveGasPrice: UInt256?
```

#### logs

array of events created during execution of the tx

``` swift
public var logs: [ZksyncEthlog]
```

#### logsBloom

bloomfilter used to detect events for `eth_getLogs`

``` swift
public var logsBloom: String
```

#### status

error-status of the tx.  0x1 = success 0x0 = failure

``` swift
public var status: Int
```

#### transactionHash

requested transactionHash

``` swift
public var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
public var transactionIndex: Int
```

#### from

address of the sender.

``` swift
public var from: String
```

#### type

the transaction type (0 = legacy tx, 1 = EIP-2930, 2= EIP-1559)

``` swift
public var type: Int?
```

#### to

address of the receiver. null when its a contract creation transaction.

``` swift
public var to: String?
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
public var address: String
```

#### blockNumber

the blockNumber

``` swift
public var blockNumber: UInt64
```

#### blockHash

blockhash if ther containing block

``` swift
public var blockHash: String
```

#### data

abi-encoded data of the event (all non indexed fields)

``` swift
public var data: String
```

#### logIndex

the index of the even within the block.

``` swift
public var logIndex: Int
```

#### removed

the reorg-status of the event.

``` swift
public var removed: Bool
```

#### topics

array of 32byte-topics of the indexed fields.

``` swift
public var topics: [String]
```

#### transactionHash

requested transactionHash

``` swift
public var transactionHash: String
```

#### transactionIndex

transactionIndex within the containing block.

``` swift
public var transactionIndex: Int
```

#### transactionLogIndex

index of the event within the transaction.

``` swift
public var transactionLogIndex: Int?
```

#### type

mining-status

``` swift
public var type: String?
```
### ZksyncZkHistory

the data and state of the requested tx.

``` swift
public struct ZksyncZkHistory 
```



#### init(tx_id:hash:eth_block:pq_id:success:fail_reason:commited:verified:created_at:tx:)

initialize the ZksyncZkHistory

``` swift
public init(tx_id: String, hash: String, eth_block: UInt64? = nil, pq_id: UInt64? = nil, success: Bool? = nil, fail_reason: String? = nil, commited: Bool, verified: Bool, created_at: String, tx: ZkTxHistoryInput) 
```

  - Parameter tx\_id : the transaction id based on the block-number and the index

  - Parameter eth\_block : the blockNumber of a priority-operation like `Deposit` otherwise this is null

  - Parameter pq\_id : the priority-operation id (for tx like `Deposit`) otherwise this is null

  - Parameter fail\_reason : the error message if failed, otherwise null

  - Parameter created\_at : UTC-Time when the transaction was created

**Parameters**

  - hash: the transaction hash
  - success: the result of the operation
  - commited: true if the tx was received and verified by the zksync-server
  - verified: true if the tx was received and verified by the zksync-server
  - tx: the transaction data



#### tx_id

the transaction id based on the block-number and the index

``` swift
public var tx_id: String
```

#### hash

the transaction hash

``` swift
public var hash: String
```

#### eth_block

the blockNumber of a priority-operation like `Deposit` otherwise this is null

``` swift
public var eth_block: UInt64?
```

#### pq_id

the priority-operation id (for tx like `Deposit`) otherwise this is null

``` swift
public var pq_id: UInt64?
```

#### success

the result of the operation

``` swift
public var success: Bool?
```

#### fail_reason

the error message if failed, otherwise null

``` swift
public var fail_reason: String?
```

#### commited

true if the tx was received and verified by the zksync-server

``` swift
public var commited: Bool
```

#### verified

true if the tx was received and verified by the zksync-server

``` swift
public var verified: Bool
```

#### created_at

UTC-Time when the transaction was created

``` swift
public var created_at: String
```

#### tx

the transaction data

``` swift
public var tx: ZkTxHistoryInput
```
### ZksyncZkReceipt

the transactionReceipt. use `zksync_tx_info` to check the progress.

``` swift
public struct ZksyncZkReceipt 
```



#### init(type:accountId:from:to:token:amount:fee:nonce:txHash:tokenId:validFrom:validUntil:)

initialize the ZksyncZkReceipt

``` swift
public init(type: String, accountId: UInt64, from: String, to: String, token: UInt64, amount: UInt256, fee: UInt256, nonce: UInt64, txHash: String, tokenId: UInt64, validFrom: UInt64, validUntil: UInt64) 
```

**Parameters**

  - type: the Transaction-Type (`Withdraw`  or `Transfer`)
  - accountId: the id of the sender account
  - from: the address of the sender
  - to: the address of the receipient
  - token: the id of the token used
  - amount: the amount sent
  - fee: the fees paid
  - nonce: the fees paid
  - txHash: the transactionHash, which can be used to track the tx
  - tokenId: the token id
  - validFrom: valid from
  - validUntil: valid until



#### type

the Transaction-Type (`Withdraw`  or `Transfer`)

``` swift
public var type: String
```

#### accountId

the id of the sender account

``` swift
public var accountId: UInt64
```

#### from

the address of the sender

``` swift
public var from: String
```

#### to

the address of the receipient

``` swift
public var to: String
```

#### token

the id of the token used

``` swift
public var token: UInt64
```

#### amount

the amount sent

``` swift
public var amount: UInt256
```

#### fee

the fees paid

``` swift
public var fee: UInt256
```

#### nonce

the fees paid

``` swift
public var nonce: UInt64
```

#### txHash

the transactionHash, which can be used to track the tx

``` swift
public var txHash: String
```

#### tokenId

the token id

``` swift
public var tokenId: UInt64
```

#### validFrom

valid from

``` swift
public var validFrom: UInt64
```

#### validUntil

valid until

``` swift
public var validUntil: UInt64
```
### ZksyncZkTx

the tx input data

``` swift
public struct ZksyncZkTx 
```



#### init(accountId:from:to:token:amount:fee:nonce:validFrom:validUntil:signature:type:)

initialize the ZksyncZkTx

``` swift
public init(accountId: UInt64, from: String, to: String, token: UInt64, amount: UInt256, fee: UInt256, nonce: UInt64, validFrom: UInt64, validUntil: UInt64, signature: ZkTxSignature, type: String? = nil) 
```

**Parameters**

  - accountId: the id of the sender account
  - from: the address of the sender
  - to: the address of the receipient
  - token: the id of the token used
  - amount: the amount sent
  - fee: the fees paid
  - nonce: the fees paid
  - validFrom: timestamp set by the sender when the valid range starts
  - validUntil: timestamp set by the sender when the valid range ends
  - signature: the sync signature
  - type: the transaction type



#### accountId

the id of the sender account

``` swift
public var accountId: UInt64
```

#### from

the address of the sender

``` swift
public var from: String
```

#### to

the address of the receipient

``` swift
public var to: String
```

#### token

the id of the token used

``` swift
public var token: UInt64
```

#### amount

the amount sent

``` swift
public var amount: UInt256
```

#### fee

the fees paid

``` swift
public var fee: UInt256
```

#### nonce

the fees paid

``` swift
public var nonce: UInt64
```

#### validFrom

timestamp set by the sender when the valid range starts

``` swift
public var validFrom: UInt64
```

#### validUntil

timestamp set by the sender when the valid range ends

``` swift
public var validUntil: UInt64
```

#### signature

the sync signature

``` swift
public var signature: ZkTxSignature
```

#### type

the transaction type

``` swift
public var type: String?
```
## Enums
### EQError

An error enum to assist with Equs related errors

``` swift
public enum EQError: Error 
```



`Error`



#### invalidRequest

The request is not valid.

``` swift
case invalidRequest
```

#### unableToParseResponse

The response could not be parsed.

``` swift
case unableToParseResponse(String = "Could not parse response")
```

#### invalidBody

The body is not valid.

``` swift
case invalidBody(String = "Could not create body")
```

#### invalidURL

The URL is not valid.

``` swift
case invalidURL(String = "Could not create url")
```

#### responseError

An HTTPStatus response error.

``` swift
case responseError(HTTPStatus)
```

#### batchError

A batch error.

``` swift
case batchError([EQNewAttributeResponse])
```

#### netIdError

A NetID error.

``` swift
case netIdError(EQResponseError)
```

#### custom

A custom error.

``` swift
case custom(Error)
```
### EQLogger.LogLevel

Different levels of logging

``` swift
public enum LogLevel: Int 
```



`Int`



#### debug

Debug level information, the most verbose logging.

``` swift
case debug = 0
```

#### info

Informational data only.

``` swift
case info = 1
```

#### log

Log data only.

``` swift
case log = 2
```

#### error

Errors only. The least verbose logging.

``` swift
case error = 3
```

#### none

No logging.

``` swift
case none = 4
```
### EQService

Equs services

``` swift
public enum EQService: String, CaseIterable 
```



`CaseIterable`, `String`



#### pds

Personal Data Service API

``` swift
case pds = "/pds"
```

#### sp

Service Provider API

``` swift
case sp = "/sp"
```

#### blockchain

Blockchain API

``` swift
case blockchain = "/blockchain"
```

#### tp

Trusted Party API

``` swift
case tp = "/tp"
```

#### admin

Administration API

``` swift
case admin = "/admin"
```

#### auth

Authorization API

``` swift
case auth = "/auth"
```

#### schema

Schema API

``` swift
case schema = "/schema"
```

#### notification

Notification API

``` swift
case notification = "/notification"
```

#### persona

Persona API

``` swift
case persona = "/persona"
```
### HTTPStatus

Enum for HTTP Status code

``` swift
public enum HTTPStatus 
```



#### informalResponse

Informal response.

``` swift
case informalResponse
```

#### success

Indicates success.

``` swift
case success
```

#### redirect

A redirect.

``` swift
case redirect
```

#### clientError

A client error occurred.

``` swift
case clientError
```

#### serverError

A server error occurred.

``` swift
case serverError
```

#### unknown

Unknown status.

``` swift
case unknown
```
### IncubedError

Base Incubed errors

``` swift
public enum IncubedError: Error 
```



`Error`, `Error`, `LocalizedError`, `LocalizedError`



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



#### errorDescription

``` swift
public var errorDescription: String? 
```

#### errorDescription

``` swift
public var errorDescription: String? 
```

#### errorDescription

``` swift
public var errorDescription: String? 
```

#### errorDescription

``` swift
public var errorDescription: String? 
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
case invalidParams(String)
```

#### invalidRequest

invalid Request

``` swift
case invalidRequest(String)
```

#### applicationError

application Error

``` swift
case applicationError(String)
```

#### invalidMethod

invalid Method

``` swift
case invalidMethod
```

#### invalidParams

invalid Params

``` swift
case invalidParams(String)
```

#### invalidRequest

invalid Request

``` swift
case invalidRequest(String)
```

#### applicationError

application Error

``` swift
case applicationError(String)
```
### RPCObject

Wrapper enum for a rpc-object, which could be different kinds

``` swift
public enum RPCObject: Equatable 
```



`Equatable`, `Equatable`



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
case string(String)
```

#### integer

a Integer

``` swift
case integer(Int)
```

#### double

a Doucle-Value

``` swift
case double(Double)
```

#### bool

a Boolean

``` swift
case bool(Bool)
```

#### list

a Array or List of RPC-Objects

``` swift
case list([RPCObject])
```

#### dictionary

a JSON-Object represented as Dictionary with properties as keys and their values as RPCObjects

``` swift
case dictionary([String: RPCObject])
```

#### none

a JSON `null` value.

``` swift
case none
```

#### string

a String value

``` swift
case string(String)
```

#### integer

a Integer

``` swift
case integer(Int)
```

#### double

a Doucle-Value

``` swift
case double(Double)
```

#### bool

a Boolean

``` swift
case bool(Bool)
```

#### list

a Array or List of RPC-Objects

``` swift
case list([RPCObject])
```

#### dictionary

a JSON-Object represented as Dictionary with properties as keys and their values as RPCObjects

``` swift
case dictionary([String: RPCObject])
```



#### asObject()

``` swift
public func asObject<T>() -> T  
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
case success(_ data:RPCObject)
```

#### error

failed request with the msg describiung the error

``` swift
case error(_ msg:String)
```

#### success

success full respons with the data as result.

``` swift
case success(_ data:RPCObject)
```

#### error

failed request with the msg describiung the error

``` swift
case error(_ msg:String)
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
case success(_ data:Data, _ time:Int)
```

**Parameters**

  - data: the raw data
  - time: the time in milliseconds to execute the request

#### error

failed response

``` swift
case error(_ msg:String, _ httpStatus:Int)
```

**Parameters**

  - msg: the error-message
  - httpStatus: the http status code

#### success

successful response

``` swift
case success(_ data:Data, _ time:Int)
```

**Parameters**

  - data: the raw data
  - time: the time in milliseconds to execute the request

#### error

failed response

``` swift
case error(_ msg:String, _ httpStatus:Int)
```

**Parameters**

  - msg: the error-message
  - httpStatus: the http status code
## Interfaces
### EQEndpointConfiguration

The protocol needed to configure Equs for a different endpoint

``` swift
public protocol EQEndpointConfiguration 
```



#### baseURL

The base URL.

``` swift
var baseURL: String 
```

#### servicePath

The service path.

``` swift
var servicePath: [EQService: String] 
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
func getEntry(key:String)->Data?
```

#### setEntry(key:​value:​)

write the data to the cache using the given key..

``` swift
func setEntry(key:String,value:Data)->Void
```

#### clear()

clears all cache entries

``` swift
func clear()->Void
```

#### getEntry(key:​)

find the data for the given cache-key or `nil`if not found.

``` swift
func getEntry(key:String)->Data?
```

#### setEntry(key:​value:​)

write the data to the cache using the given key..

``` swift
func setEntry(key:String,value:Data)->Void
```

#### clear()

clears all cache entries

``` swift
func clear()->Void
```
