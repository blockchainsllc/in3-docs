*****************
API Reference CMD
*****************

Incubed can be used as a comandline-util or as tool in bash-scripts.
This tool will execute a json-rpc reauest and write the result to std out.

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
-s, -signs     number of signatures to use when verifying.
-b, -block     the blocknumber to use when making calls. could be either ``latest`` (default),``earliest`` or a hexnumbner
-to            the target address of the call
-d, -data      the data for a transaction. 

               This can be a filepath, a 0x-hexvalue or ``-`` to read it from stdin. if a method signature is given and data they 
               will be combined and used as constructor arguments when deploying.

-gas_limit     the gas_limit to use when sending transactions. (default: 100000) 
-value         the value to send when sending a transaction. can be hexvalue or a float/integer with the suffix ``eth`` or ``wei`` like ``1.8eth`` (default: 0)
-w, -wait      if given, ``eth_sendTransaction`` or ``eth_sendRawTransaction`` will not only return the transactionHash after sending, but wait until the transaction is mined and return the transactionreceipt.
-json          if given the result will be returned as json, which is especially important for ``eth_call`` results with complex structres.
-hex           if given the result will be returned as hex.
-debug         if given incubed will output debug information when executing. 

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
     send
        based on the ``-to``, ``-value`` and ``-pk`` a transaction is build and signed and send. 
        if there is another argument after `send`, this would be taken as a function-signature of the smart contract followed by optional argument of the function.
     call
        uses ``eth_call`` to call a function. Following the ``call`` argument the function-signature and its arguments must follow. 
      in3_nodeList
        returns the nodeList of the Incubed NodeRegistry.
      in3_sign
        requests a node to sign.
      in3_stats
        returns the stats of a node.

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

   # get the first transaction of the last block
   in3 eth_getBlockByNumber latest true | jq  '.transactions[0]'

calling a function of a smart contract
**************************************

.. code-block:: sh

   # without arguments
   in3 -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1 call "totalServers():uint256"
   > 5

   # with arguments returning a array of values
   in3 -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1 call "servers(uint256):(string,address,uint,uint,uint,address)" 1
   > https://in3.slock.it/mainnet/nd-1
   > 0x784bfa9eb182c3a02dbeb5285e3dba92d717e07a
   > 65535
   > 65535
   > 0
   > 0x0000000000000000000000000000000000000000


sending a transaction
*********************

.. code-block:: sh

   # sends a transaction to a registerServer-function and signs it with the private given (-pk 0x...)
   in3 -to 0x27a37a1210df14f7e058393d026e2fb53b7cf8c1  -gas 1000000 -pk 0x... send "registerServer(string,uint256)" "https://in3.slock.it/kovan1" 0xFF

deploying a contract
********************

.. code-block:: sh

   # compiling the solidity code, filtering the binary and send it as transaction returning the txhash
   solc --bin ServerRegistry.sol | in3 -gas 5000000 -pk `cat my_private_key.txt` -d - send

   # if you want the address, we would need to wait until the tx is mined and then get the receipt
   solc --bin ServerRegistry.sol | in3 -gas 5000000 -pk `cat my_private_key.txt` -d - -wait send | jq -r .contractAddress

