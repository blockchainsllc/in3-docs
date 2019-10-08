*************************
API Reference Node/Server
*************************

The term in3-server and in3-node are used interchangeably.

Nodes are the backend of Incubed. Each node serves RPC requests to Incubed clients. The node itself runs like a proxy for an Ethereum client (Geth, Parity, etc.), but instead of simply passing the raw response, it will add the required proof needed by the client to verify the response.

To run such a node, you need to have an Ethereum client running where you want to forward the request to. At the moment, the minimum requirement is that this client needs to support ``eth_getProof`` (see http://eips.ethereum.org/EIPS/eip-1186).

You can create your own docker compose file/docker command using our command line descriptions below. But you can also use our tool in3-server-setup to help you through the process.

Command-line Arguments
######################

--autoRegistry-capabilities-multiChain   If true, this node is able to deliver multiple chains.
--autoRegistry-capabilities-proof        If true, this node is able to deliver proofs.
--autoRegistry-capacity                  Max number of parallel requests.
--autoRegistry-deposit                   The deposit you want to store.
--autoRegistry-depositUnit               Unit of the deposit value.
--autoRegistry-url                       The public URL to reach this node.
--cache                                  Cache Merkle tries.
--chain                                  ChainId.
--clientKeys                             A comma-separated list of client keys to use for simulating clients for the watchdog.
--db-database                            Name of the database.
--db-host                                Db-host (default: local host).
--db-password                            Password for db-access.
--db-user                                Username for the db.
--defaultChain                           The default chainId in case the request does not contain one.
--freeScore                              The score for requests without a valid signature.
--handler                                The implementation used to handle the calls.
--help                                   Output usage information.
--id                                     An identifier used in log files for reading the configuration from the database.
--ipfsUrl                                The URL of the IPFS client.
--logging-colors                         If true, colors will be used.
--logging-file                           The path to the log file.
--logging-host                           The host for custom logging.
--logging-level                          Log level.
--logging-name                           The name of the provider.
--logging-type                           The module of the provider.
--maxThreads                             The maximal number of threads running parallel to the processes.
--maxPointsPerMinute                     The Score for one client able to use within one minute, which is used as DOS-Protection.
--maxBlocksSigned                        The max number of blocks signed per in3_sign-request
--maxSignatures                          The max number of signatures to sign per request
--minBlockHeight                         The minimal block height needed to sign.
--persistentFile                         The file name of the file keeping track of the last handled blockNumber.
--privateKey                             The path to the keystore-file for the signer key used to sign blockhashes.
--privateKeyPassphrase                   The password used to decrypt the private key.
--profile-comment                        Comments for the node.
--profile-icon                           URL to an icon or logo of a company offering this node.
--profile-name                           Name of the node or company.
--profile-noStats                        If active, the stats will not be shown (default: false).
--profile-url                            URL of the website of the company.
--registry                               The address of the server registry used to update the NodeList.
--registryRPC                            The URL of the client in case the registry is not on the same chain.
--rpcUrl                                 The URL of the client.
--startBlock                             BlockNumber to start watching the registry.
--timeout                                Number of milliseconds needed to wait before a request times out.
--version                                Output of the version number.
--watchInterval                          The number of seconds before a new event.
--watchdogInterval                       Average time between sending requests to the same node. 0 turns it off (default).


in3-server-setup tool
##########################

The in3-server-setup tool can be found both [online](https://in3-setup.slock.it) and on [DockerHub](https://hub.docker.com/r/slockit/in3-server-setup).
The DockerHub version can be used to avoid relying on our online service, a full source will be released soon.

The tool can be used to generate the private key as well as the docker-compose file for use on the server.

Note: The below guide is a basic example of how to setup and in3 node, no assurances are made as to the security of the setup. Please take measures to protect your private key and server.

Setting up a server on AWS:
    1. Create an account on AWS and create a new EC2 instance
    2. Save the key and SSH into the machine with ```ssh -i "SSH_KEY.pem" user@IP```
    3. Install docker and docker-compose on the EC2 instance
    4. Use scp to transfer the docker-compose file and private key, ```scp -i "SSH_KEY" FILE  user@IP:.```
    5. Run the Ethereum client, for example parity and allow it to sync
    6. Once the client is synced, run the docker-compose file with ```docker-compose up```
    7. Test the in3 node by making a request to the address
    8. Consider using tools such as AWS Shield to protect your server from DOS attacks


Registering Your Own Incubed Node
##########################

If you want to participate in this network and register a node, you need to send a transaction to the registry contract, calling `registerServer(string _url, uint _props)`.

To run an Incubed node, you simply use docker-compose:

First run partiy, and allow the client to sync
.. code-block:: yaml
        version: '2'
        services:
        incubed-parity:
            image: parity:latest                                    # Parity image with the proof function implemented.
            command:
            - --auto-update=none                                    # Do not automatically update the client.
            - --pruning=archive 
            - --pruning-memory=30000                                # Limit storage.
            - --jsonrpc-experimental                                # Currently still needed until EIP 1186 is finalized.

Then run in3 with the below docker-compose file:
.. code-block:: yaml
          version: '2'
                services:
                incubed-server:
                    image: slockit/in3-server:latest
                    volumes:
                    - $PWD/keys:/secure                                     # Directory where the private key is stored.
                    ports:
                    - 8500:8500/tcp                                         # Open the port 8500 to be accessed by the public.
                    command:
                    - --privateKey=/secure/myKey.json                       # Internal path to the key.
                    - --privateKeyPassphrase=dummy                          # Passphrase to unlock the key.
                    - --chain=0x1                                           # Chain (Kovan).
                    - --rpcUrl=http://incubed-parity:8545                   # URL of the Kovan client.
                    - --registry=0xFdb0eA8AB08212A1fFfDB35aFacf37C3857083ca # URL of the Incubed registry.
                    - --autoRegistry-url=http://in3.server:8500             # Check or register this node for this URL.
                    - --autoRegistry-deposit=2                              # Deposit to use when registering.