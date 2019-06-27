********************
API Reference Docker
********************

In order to start the incubed-client as a standalone client (allowing others application to connect to it), you can start the container as

.. code-block:: sh

   docker run -d -p 8545:8545  slockit/in3:latest --chainId=mainnet


The application would then accept the following arguments:

.. glossary::
    --nodeLimit
        the limit of nodes to store in the client.

    --keepIn3
        if true, the in3-section of thr response will be kept. Otherwise it will be removed after validating the data. This is useful for debugging or if the proof should be used afterwards.

    --format
        the format for sending the data to the client. Default is json, but using cbor means using only 30-40% of the payload since it is using binary encoding.

    --autoConfig
        if true the config will be adjusted depending on the request
    
    --retryWithoutProof
        if true the request may be handled without proof in case of an error. (use with care!)

    --includeCode
        if true, the request should include the codes of all accounts. otherwise only the codeHash is returned. In this case the client may ask by calling eth_getCode() afterwards

    --maxCodeCache
        number of max bytes used to cache the code in memory

    --maxBlockCache
        number of number of blocks cached  in memory

    --proof
        'none' for no verification, 'standard' for verifying all important fields, 'full'  veryfying all fields even if this means a high payload.

    --signatureCount
        number of signatures requested

    --finality
        percenage of validators signed blockheaders - this is used for PoA (aura)

    --minDeposit
        min stake of the server. Only nodes owning at least this amount will be chosen.

    --replaceLatestBlock
        if specified, the blocknumber *latest* will be replaced by blockNumber- specified value

    --requestCount
        the number of request send when getting a first answer

    --timeout
        specifies the number of milliseconds before the request times out. increasing may be helpful if the device uses a slow connection.

    --chainId
        servers to filter for the given chain. The chain-id based on EIP-155.

    --chainRegistry
        main chain-registry contract

    --mainChain
        main chain-id, where the chain registry is running.

    --autoUpdateList
        if true the nodelist will be automaticly updated if the lastBlock is newer

    --loggerUrl
        a url of RES-Endpoint, the client will log all errors to. The client will post to this endpoint JSON like { id?, level, message, meta? }

