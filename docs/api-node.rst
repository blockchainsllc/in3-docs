********************
API Reference Node
********************

Nodes are the backend of incubed. Each node serves RPC-Requests to incubed clients. The node itself is running like a proxy for a ethereum client (geth, parity, ....) but instead just passing the raw response, it will add the required proof needed by the client to verify the response.

In order to run such a node, you need have at ethereum client running where you want to forward the request to. At the moment the only minimum requirements is thast this client needs to support ``eth_getProof`` ( See http://eips.ethereum.org/EIPS/eip-1186 ).

Comandline arguments
####################

--autoRegistry-capabilities-multiChain   if true, this node is able to deliver multiple chains
--autoRegistry-capabilities-proof        if true, this node is able to deliver proofs
--autoRegistry-capacity                  max number of parallel requests
--autoRegistry-deposit                   the deposit you want ot store
--autoRegistry-depositUnit               unit of the deposit value
--autoRegistry-url                       the public url to reach this node
--cache                                  cache merkle tries
--chain                                  chainId
--clientKeys                             a comma sepearted list of client keys to use for simulating clients for the watchdog
--db-database                            name of the database
--db-host                                db-host (default = localhost)
--db-password                            password for db-access
--db-user                                username for the db
--defaultChain                           the default chainId in case the request does not contain one.
--freeScore                              the score for requests without a valid signature
--handler                                the impl used to handle the calls
--help                                   Output usage information
--id                                     a identifier used in logfiles as also for reading the config from the database
--ipfsUrl                                the url of the ipfs-client
--logging-colors                         if true colors will be used
--logging-file                           the path to the logile
--logging-host                           the host for custom logging
--logging-level                          Loglevel
--logging-name                           the name of the provider
--logging-type                           the module of the provider
--maxThreads                             the maximal number of threads ofr running parallel processes
--minBlockHeight                         the minimal blockheight in order to sign
--persistentFile                         the filename of the file keeping track of the last handled blocknumber
--privateKey                             the private key used to sign blockhashes. this can be either a 0x-prefixed string with the raw private key or the path to a key-file.
--privateKeyPassphrase                   the password used to decrpyt the private key
--profile-comment                        comments for the node
--profile-icon                           url to a icon or logo of company offering this node
--profile-name                           name of the node or company
--profile-noStats                        if active the stats will not be shown (default:false)
--profile-url                            url of the website of the company
--registry                               the address of the server registry used in order to update the nodeList
--registryRPC                            the url of the client in case the registry is not on the same chain.
--rpcUrl                                 the url of the client
--startBlock                             blocknumber to start watching the registry
--timeout                                number of milliseconds to wait before a request gets a timeout
--version                                Output the version number
--watchInterval                          the number of seconds of the interval for checking for new events
--watchdogInterval                       average time between sending requests to the same node. 0 turns it off (default)


Registering a own in3-node
##########################

If you want to participate in this network and also register a node, you need to send a transaction to the registry-contract calling `registerServer(string _url, uint _props)`.


To run a incubed node, you simply use docker-compose:

.. code-block:: yaml

        version: '2'
        services:
        incubed-server:
            image: slockit/in3-server:latest
            volumes:
            - $PWD/keys:/secure                                     # directory where the private key is stored 
            ports:
            - 8500:8500/tcp                                         # open the port 8500 to be accessed by public
            command:
            - --privateKey=/secure/myKey.json                       # internal path to the key
            - --privateKeyPassphrase=dummy                          # passphrase to unlock the key
            - --chain=0x1                                           # chain (kovan)
            - --rpcUrl=http://incubed-parity:8545                   # url of the kovan-client
            - --registry=0xFdb0eA8AB08212A1fFfDB35aFacf37C3857083ca # url of the incubed-registry 
            - --autoRegistry-url=http://in3.server:8500             # check or register this node for this url
            - --autoRegistry-deposit=2                              # deposit to use when registering

        incubed-parity:
            image: parity:latest                                    # parity-image with the getProof-function implemented
            command:
            - --auto-update=none                                    # do not automaticly update the client
            - --pruning=archive 
            - --pruning-memory=30000                                # limit storage
            - --jsonrpc-experimental                                # currently still needed until the EIP 1186 is finalised





