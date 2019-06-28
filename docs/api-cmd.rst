*****************
API Reference CMD
*****************

Incubed can be used as a comandline-util or as tool in bash-scripts.
This tool will execute a json-rpc reauest and write the result to std out.

Usage
#####

.. code-block:: sh

   in3 [options] method [arguments]

-c, -chain     the chain to use. Currently ``mainnet``(default), ``kovan``, ``tobalaba``, ``goerli`` are predefined.
-p, -proof     specifies the Verification level: 
                  :none: no proof
                  :standard: standard verification (default)
                  :full: full verification 
-s, -signs     number of signatures to use when verifying.
-b, -block     the blocknumber to use when making calls. could be either ``latest`` (default),``earliest`` or a hexnumbner
-to            the target address of the call
-gas_limit     the gas_limit to use when sending transactions. (default: 100000) 
-value         the value to send when sending a transaction. (default: 0)
-wait          if given, ``eth_sendTransaction`` or ``eth_sendRawTransaction`` will not only return the transactionHash after sending, but wait until the transaction is mined and return the transactionreceipt.
-json          if given the result will be returned as json, which is especially important for ``eth_call`` results with complex structres.
-debug         if given incubed will output debug information when executing. 

As method, the following can be used:

.. glossary::
     <JSON-RPC>-method
        all official supported `JSON-RPC-Method <https://github.com/ethereum/wiki/wiki/JSON-RPC#json-rpc-methods>`_ may be used.
     send
        based on the ``-to``, ``-value`` and ``-pk`` a transaction is build and signed and send. 
        if there is another argument after `send`, this would be taken as a function-signature of the smart contract followed by optional argument of the function.
     call
        uses ``eth_call`` to call a function. Following the ``call`` argument the function-signature and its arguments must follow. 

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

   # compiling the solidity code, filtering the binary and send it as transaction
   docker run -v $(pwd)/contracts:/contracts ethereum/solc:0.4.25 --optimize  --combined-json bin /contracts/ServerRegistry.sol \
    | jq -r '.contracts."/contracts/ServerRegistry.sol:ServerRegistry".bin' \
    | in3 -gas 1000000 -pk `cat my_private_key.txt` send \
    | jq .
   
