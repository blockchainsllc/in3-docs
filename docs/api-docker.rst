********************
API Reference Docker
********************

To start the Incubed client as a standalone client (allowing other applications to connect to it), you must start the container as:

.. code-block:: sh

   docker run -d -p 8545:8545  slockit/in3:latest --chainId=mainnet

The application will then accept the following arguments:

--nodeLimit             The limit of nodes to store in the client.
--keepIn3               If true, the IN3-section of the response will be kept. Otherwise, it will be removed 
                        after validating the data. This is useful for debugging or if the proof will be 
                        used afterward.
--format                The format for sending the data to the client. Default is JSON, but using CBOR means
                        using only 30-40% of the payload since it is using binary encoding.
--autoConfig            If true, the configuration will be adjusted depending on the request.
--retryWithoutProof     If true, the request may be handled without proof in case of an error. (Use with care!)
--includeCode           If true, the request should include the codes of all accounts. Otherwise, only the codeHash is returned. In this case, the client may ask by calling eth_getCode() afterward.
--maxCodeCache          Max number of bytes used to cache the code in memory.
--maxBlockCache         Number of blocks cached in memory.
--proof                 'None' for no verification, 'standard' for verifying all important fields, and 'full' for verifying all fields even if this means a high payload.
--signatureCount        Number of signatures requested.
--finality              Percenage of validator-signed blockheaders; this is used for PoA (Aura).
--minDeposit            Minimum stake of the server. Only nodes owning at least this amount will be chosen.
--replaceLatestBlock    If specified, the block number *latest* will be replaced by blockNumber-(specific value).
--requestCount          The number of requests sent when receiving a first answer.
--timeout               Specifies the number of milliseconds before the request times out. Increasing may be helpful if the device uses a slow connection.
--chainId               Servers to filter for the given chain. The chain-ID is based on EIP 155.
--chainRegistry         Mainchain registry contract.
--mainChain             Mainchain ID where the chain registry is running.
--autoUpdateList        If true, the NodeList will be automatically updated if the last block is newer.
--loggerUrl             A URL the RES-endpoint client will log all errors to. The client will post to this endpoint JSON-like (ID?, level, message, meta?)
