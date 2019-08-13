*****************
API Reference CMD
*****************

Incubed can be used as a comandline-util or as tool in bash-scripts.
This tool will execute a json-rpc request and write the result to std out.

Usage
#####

.. code-block:: sh

   in3 [options] method [arguments]

-c, -chain     the chain to use. Currently 

                 :mainnet: Mainnet 
                 :kovan: kovan testnet
                 :tobalaba: EWF-Testchain
                 :goerli: Goerli Testchain using clique
                 :local: use the local client on http://localhost:8545
                 :RPCURL: If any other RPC-URL is passed as chain name this is used, but without verification.
                 
-p, -proof     specifies the Verification level: 

                  :none: no proof
                  :standard: standard verification (default)
                  :full: full verification 

-np            short for ``-p none``
-port          specifies the port to run incubed as a server. Opening port 8545 may replace a local parity or geth client.
-s, -signs     number of signatures to use when verifying.
-b, -block     the blocknumber to use when making calls. could be either ``latest`` (default),``earliest`` or a hexnumbner
-pk            the private key as raw as keystorefile
-pwd           password to unlock the key
-to            the target address of the call
-d, -data      the data for a transaction. 

               This can be a filepath, a 0x-hexvalue or ``-`` to read it from stdin. if a method signature is given and data they 
               will be combined and used as constructor arguments when deploying.

-gas           the gas limit to use when sending transactions. (default: 100000) 
-value         the value to send when sending a transaction. can be hexvalue or a float/integer with the suffix ``eth`` or ``wei`` like ``1.8eth`` (default: 0)
-w, -wait      if given, ``eth_sendTransaction`` or ``eth_sendRawTransaction`` will not only return the transactionHash after sending, but wait until the transaction is mined and return the transactionreceipt.
-json          if given the result will be returned as json, which is especially important for ``eth_call`` results with complex structres.
-hex           if given the result will be returned as hex.
-debug         if given incubed will output debug information when executing. 
-ri            reads the response from stdin instead of sending the request allowing offline use cases
-ro            writes the raw response from the node to stdout 

Install
#######

From Binaries
*************

You can download the binaries here:

- :download:`mac os <downloads/osx/in3_osx>`.
- :download:`win64 <downloads/win/in3.exe>`.
- :download:`armv7 <downloads/armv7/in3_armv7>`.
- :download:`armv7hf <downloads/armv7hf/in3_armv7hf>`.
- :download:`linux_x86 <downloads/x86/in3_x86>`.
- :download:`linux_x64 <downloads/x64/in3_x64>`.
- :download:`in3.jar <downloads/in3.jar>`.
- :download:`installer <downloads/install.sh>`.

or just use this one-liner:

.. code-block:: sh

   curl https://in3.readthedocs.io/en/develop/_downloads/install.sh -sSf | sudo sh

From Sources
************

For Building from source, checkout the details https://in3.readthedocs.io/en/develop/api-c.html#requirements .

.. code-block:: sh

   # clone the sources
   git clone https://github.com/slockit/in3-core.git

   # create build-folder
   cd in3-core
   mkdir build && cd build
   cmake -DCMAKE_BUILD_TYPE=Release .. && make in3

   # Install
   make install

From Docker
************

Incubed can be run as docker container. For this pull the container:

--- code-block:: sh

   # run a simple statement
   docker run slockit/in3:latest eth_blockNumber

   # to start it as a server
   docker run -p 8545:8545 slockit/in3:latest -port 8545

   # mount the cache in order to cache nodelists, validatorlists and contract code.
   docker run -v $(pwd)/cache:/root/.in3 -p 8545:8545 slockit/in3:latest -port 8545


Enviroment variables
####################

The following enviroment-variables may be used to define defaults:

.. glossary::

   IN3_PK
      The raw private key used for signing ( same as -pk)
   IN3_CHAIN
      The chain to use (default: mainnet). (same as -c), if a url is passed this server will be used instead.



Methods
#######

As method, the following can be used:

.. glossary::
     <JSON-RPC>-method
        all official supported `JSON-RPC-Method <https://github.com/ethereum/wiki/wiki/JSON-RPC#json-rpc-methods>`_ may be used.
     send <signature> ...args
        based on the ``-to``, ``-value`` and ``-pk`` a transaction is build, signed and send. 
        if there is another argument after `send`, this would be taken as a function-signature of the smart contract followed by optional argument of the function.

        .. code-block:: sh
           
           # send some eth ( requires to set the IN3_PK-variable before)
           in3 send -to 0x1234556 -value 0.5eth  
           # send a tx to a function
           in3 -to 0x5a0b54d5dc17e0aadc383d2db43b0a0d3e029c4c  -gas 1000000 send "registerServer(string,uint256)" "https://in3.slock.it/kovan1" 0xFF

     call <signature> ...args
        uses ``eth_call`` to call a function. Following the ``call`` argument the function-signature and its arguments must follow. 
     in3_nodeList
        returns the nodeList of the Incubed NodeRegistry as json.
     in3_sign <blocknumber>
        requests a node to sign. in order to specify the signer, you need to pass the url like this:

        .. code-block:: sh
           
           # send a tx to a function
           in3 in3_sign -c https://in3.slock.it/mainnet/nd-1 6000000

     in3_stats
        returns the stats of a node. unless you specify the node with ``-c <rpcurl>`` it will pick a random node. 
     abi_encode <signature> ...args
        encodes the arguments as described in the method signature using ABI-Encoding
     abi_decode <signature> data
        decodes the data based on the signature.
     pk2address <privatekey>
        extracts the public address from a private key
     createkey
        generates a raw random private key
     key <keyfile>
        reads the private key from JSON-Keystore file from first argument and returns the private key. This may ask the user to enter the passphrase (unless provided with ``-pwd``.
        In order to unlock the key reuse it within the shell, you can set the enviroment variable like this:

        .. code-block:: sh

           export IN3_PK=`in3 keystore mykeyfile.json` 


Running as Server
#################


While you can use ``in3`` to execute a request, return a result and quit, you can also start it as a server using the specified port ( ``-port 8545`` ) to serve RPC-requests. 
Thiss way you can replace your local parity or geth with a incubed client. All Dapps can then connect to http://localhost:8545. 

.. code-block:: sh

   # starts a server at the standard port for kovan.
   in3 -c kovan -port 8545


Cache
#####

even though incubed does not need a configuration or set up and runs completly stateles, caching already verified data can boost up the performance. That's why ``in3`` uses a cache to store

.. glossary::

     Nodelists
        List of all nodes as verified from the registry
     reputations
        holding the score for each node to improve weights for goot performing nodes
     code
        for ``eth_call`` incubed needs a the code of the contract, but this can be taken from cache if possible. 
     validators
        for PoA-changes the validators and its changes over time will be stored.


Per default incubed will use ``~/.in3`` as folder to cache data. 

If you run the docker container, you need to mount ``/root/.in3`` in to persist the cache.

Signing
#######


While incubed itself uses a abstract definition for signing, at the moment the comandline util only supports raw private keys.
There are 2 way you can specify your private keys that incubed should use to sign transactions.

1. Use the enviroment variable ``IN3_PK``
   this makes it easier to hide the key.

   .. code-block:: sh

      #!/bin/sh

      IN3_PK = `cat my_private_key`

      in3 -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1 -value 3.5eth -wait send
      in3 -to 0x5a0b54d5dc17e0aadc383d2db43b0a0d3e029c4c  -gas 1000000 -pk 0x... send "registerServer(string,uint256)" "https://in3.slock.it/kovan1" 0xFF
  
2. use the ``-pk`` option

   .. code-block:: sh

      in3 -pk 27a37a1210df14f7e058393d27a37a1210df14f7e058393d026e2fb53b7cf8c1 -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1 -value 200eth -wait send
      in3 -pk `cat my_private_key` -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1 -value 200ETH -wait send

usually it is a bad idea to hardcode privatze keys or even to use them as option since this would mean they also appear in the bash history. That's why the first aproach is the recommended one. In the future other signing aproach will be supported.

Autocompletion
##############

If you want autocompletion, simply add these lines to you `.bashrc` or `.bash_profile` : 

.. code-block:: sh
   
   _IN3_WORDS=`in3 autocompletelist`
   complete -W "$_IN3_WORDS" in3

Function Signatures
###################

When using ``send`` or ``call`` the next optional param is the function siignature. This signature describes not only the name of the function to call, but also the types of the arguments and return values.

In general the signature is build by simply removing all names and only keep keep the types:

.. code-block:: js

   <FUNCTION_NAME>(<ARGUMENT_TYPES>):(<RETURN_TYPES>)

it is important to mention, that the type-names must always be the full solidity names. Most most solidity function use aliases. They would need to be replaced with the full type name.

e.g. ``uint`` -> ``uint256`` 






Examples
########

getting the current block
*************************


.. code-block:: sh

   # on a comandline
   in3 eth_blockNumber
   > 8035324

   # for a different chain
   in3 -c kovan eth_blockNumber
   > 11834906

   # getting it as hex
   in3 -c kovan -hex eth_blockNumber
   > 0xb49625

   # as part of shell script
   BLOCK_NUMBER=`in3 eth_blockNumber`


using jq to filter JSON
***********************

.. code-block:: sh

   # get the timestamp of the latest block
   in3 eth_getBlockByNumber latest false | jq -r .timestamp
   > 0x5d162a47

   # get the first transaction of the last block
   in3 eth_getBlockByNumber latest true | jq  '.transactions[0]'
   > {
      "blockHash": "0xe4edd75bf43cd8e334ca756c4df1605d8056974e2575f5ea835038c6d724ab14",
      "blockNumber": "0x7ac96d",
      "chainId": "0x1",
      "condition": null,
      "creates": null,
      "from": "0x91fdebe2e1b68da999cb7d634fe693359659d967",
      "gas": "0x5208",
      "gasPrice": "0xba43b7400",
      "hash": "0x4b0fe62b30780d089a3318f0e5e71f2b905d62111a4effe48992fcfda36b197f",
      "input": "0x",
      "nonce": "0x8b7",
      "publicKey": "0x17f6413717c12dab2f0d4f4a033b77b4252204bfe4ae229a608ed724292d7172a19758e84110a2a926842457c351f8035ce7f6ac1c22ba1b6689fdd7c8eb2a5d",
      "r": "0x1d04ee9e31727824a19a4fcd0c29c0ba5dd74a2f25c701bd5fdabbf5542c014c",
      "raw": "0xf86e8208b7850ba43b7400825208947fb38d6a092bbdd476e80f00800b03c3f1b2d332883aefa89df48ed4008026a01d04ee9e31727824a19a4fcd0c29c0ba5dd74a2f25c701bd5fdabbf5542c014ca043f8df6c171e51bf05036c8fe8d978e182316785d0aace8ecc56d2add157a635",
      "s": "0x43f8df6c171e51bf05036c8fe8d978e182316785d0aace8ecc56d2add157a635",
      "standardV": "0x1",
      "to": "0x7fb38d6a092bbdd476e80f00800b03c3f1b2d332",
      "transactionIndex": "0x0",
      "v": "0x26",
      "value": "0x3aefa89df48ed400"
     }


calling a function of a smart contract
**************************************

.. code-block:: sh

   # without arguments
   in3 -to 0x2736D225f85740f42D17987100dc8d58e9e16252 call "totalServers():uint256"
   > 5

   # with arguments returning a array of values
   in3 -to 0x2736D225f85740f42D17987100dc8d58e9e16252 call "servers(uint256):(string,address,uint256,uint256,uint256,address)" 1
   > https://in3.slock.it/mainnet/nd-1
   > 0x784bfa9eb182c3a02dbeb5285e3dba92d717e07a
   > 65535
   > 65535
   > 0
   > 0x0000000000000000000000000000000000000000

  # with arguments returning a array of values returning as json
   in3 -to 0x2736D225f85740f42D17987100dc8d58e9e16252 -json call "servers(uint256):(string,address,uint256,uint256,uint256,address)" 1
   > ["https://in3.slock.it/mainnet/nd-4","0xbc0ea09c1651a3d5d40bacb4356fb59159a99564","0xffff","0xffff","0x00","0x0000000000000000000000000000000000000000"]


sending a transaction
*********************

.. code-block:: sh

   IN3_PK=`cat my_private_key`

   # sends a transaction to a registerServer-function and signs it with the private given (-pk 0x...)
   in3 -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1  -gas 1000000  send "registerServer(string,uint256)" "https://in3.slock.it/kovan1" 0xFF

deploying a contract
********************

.. code-block:: sh

   # compiling the solidity code, filtering the binary and send it as transaction returning the txhash
   solc --bin ServerRegistry.sol | in3 -gas 5000000 -pk `cat my_private_key.txt` -d - send

   # if you want the address, we would need to wait until the tx is mined and then get the receipt
   solc --bin ServerRegistry.sol | in3 -gas 5000000 -pk `cat my_private_key.txt` -d - -wait send | jq -r .contractAddress

