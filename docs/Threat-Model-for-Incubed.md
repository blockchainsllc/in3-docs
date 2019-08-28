# Threat Model for Incubed

## Registry Issues

### Long Time Attack
Status: open

A client is offline for a long time and does not update the NodeList. During this time, a server is convicted and/or removed from the list. The client may now send a request to this server, which means it cannot be convicted anymore and the client has no way to know that.

Solutions:

> CHR: I think that the fallback is often “out of service." What will happen is that those random nodes (A, C) will not respond.
> We (slock.it) could help them update the list in a centralized way.

> But I think the best way is the following:
> Allow nodes to commit to stay in the registry for a fixed amount of time. In that time, they cannot withdraw their funds.
> The client will most likely look for those first, especially those who only occasionally need data from the chain.
 
> SIM: Yes, this could help, but it only protects from regular unregistering. If you convict a server, then this timeout does not help.

> To remove this issue completely, you would need a trusted authority where you could update the NodeList first.
> But for the 100% decentralized way, you can only reduce it by asking multiple servers. Since they will also pass the latest block number when the NodeList changes, the client will find out that it needs to update the NodeList, and by having multiple requests in parallel, it reduces the risk of relying on a manipulated NodeList. The malicious server may return a correct NodeList for an older block when this server was still valid and even receive signatures for this, but the server cannot do so for a newer block number, which can only be found out by asking as many servers as needed.

> Another point is that as long as the signature does not come from the same server, the DataProvider will always check, so even if you request a signature from a server that is not part of the list anymore, the DataProvider will reject this. To use this attack, both the DataProvider and the BlockHashSigner must work together to provide a proof that matches the wrong blockhash.

> CHR: Correct. I think the strategy for clients who have been offline for a while is to first get multiple signed blockhashes from different sources (ideally from bootstrap nodes similar to light clients and then ask for the current list). Actually, we could define the same bootstrap nodes as those currently hard-coded in Parity and Geth.

### Inactive Server Spam Attack
Status: partially solved

Everyone can register a lot of servers that don’t even exist or aren't running. Somebody may even put in a decent deposit. Of course, the client would try to find out whether these nodes were inactive. If an attacker were able to onboard enough inactive servers, the chances for an Incubed client to find a working server would decrease. 

Solutions:

1. **Static Min Deposit**

    There is a min deposit required to register a new node. Even though this may not entirely stop any attacker, but it makes it expensive to register a high number of nodes. 

    *Desicion* : 
    
    Will be implemented in the first release, since it does not create new Riscs.    


2. **Unregister Key**

    At least in the beginning we may give us (for example for the first year) the right to remove inactive nodes. While this goes against the principle of a fully decentralized system, it will help us to learn. If this key has a timeout coded into the smart contract all users can rely on the fact that we will not be able to do this after one year.

    *Desicion* : 
    
    Will be implemented in the first release, at least as a workaround limited  to one year.    


3. **Dynamic Min Deposit**

    To register a server, the owner has to pay a deposit calculated by the formula:

    ```math
    deposit_{min} = \frac{ 86400 \cdot deposit_{average} }{ ( t_{now} - t_{lastRegistered} ) }
    ```
    To avoid some exploitation of the formula, the `deposit_average` gets capped at 50 Ether. This means that the maximum `deposit_min` calculated by this formula is about 4.3 million Ether when trying to register two servers within one block. In the first year, there will also be an enforced deposit limit of 50 Ether, so it will be impossible to rapidly register new servers, giving us more time to react to possible spam attacks (e.g., through voting).

    *Desicion* : 
    
    This dynamic deposit creates new Threads, because an attacker can stop other nodes from registering honest nodes by adding a lot of nodes and so increasing the min deposit. That's why this will not be implemented right now.    


4. **Voting** 

    In addition, the smart contract provides a voting function for removing inactive servers: To vote, a server has to sign a message with a current block and the owner of the server they want to get voted out. Only the latest 256 blockhashes are allowed, so every signature will effectively expire after roughly 1 hour. The power of each vote will be calculated by the amount of time when the server was registered. To make sure that the oldest servers won't get too powerful, the voting power gets capped at one year and won't increase further. The server being voted out will also get an oppositional voting power that is capped at two years.

    For the server to be voted out, the combined voting power of all the servers has to be greater than the oppositional voting power. Also, the accumulated voting power has to be greater than at least 50% of all the chosen voters.

    As with a high amount of registered in3-servers, the handling of all votes would become impossible. We cap the maximum amount of signatures at 24. This means to vote out a server that has been active for more then two years, 24 in3-servers with a lifetime of one month are required to vote. This number decreases when more older servers are voting. This mechanism will prevent the rapid onboarding of many malicious in3-servers that would vote out all regular servers and take control of the in3-nodelist.

    Additionally, we do not allow all servers to vote. Instead, we choose up to 24 servers randomly with the blockhash as a seed. For the vote to succeed, they have to sign on the same blockhash and have enough voting power.

    To "punish" a server owner for having an inactive server, after a successful vote, that individual will lose 1% of their deposit while the rest is locked until their deposit timeout expires, ensuring possible liabilities. Part of this 1% deposit will be used to reimburse the transaction costs; the rest will be burned. To make sure that the transaction will always be paid, a minimum deposit of 10 finney (equal to 0.01 Ether) will be enforced.

    *Desicion*: 
    
    Voting will also create the risc of also Voting against honest nodes. Any node can act honest for a long time and then become a malicious node using their voting power to vote against the remaining honest nodes and so end up kicking all other nodes out. That's why voting will be removed for the first release.    



### Self-Convict Attack
Status: solved

A user may register a mailcious server and even store a deposit, but as soon as they sign a wrong blockhash, they use a second account to convict themself to get the deposit before somebody else can.

Solution:

> SIM: We burn 50% of the depoist. In this case, the attacker would lose 50% of the deposit. But this also means the attacker would get the other half, so the price they would have to pay for lying is up to 50% of their deposit. This should be considered by clients when picking nodes for signatures.

*Desicion*: Accepted and implemented

### Convict Frontrunner Attack
Status: solved

Servers act as watchdogs and automatically call convict if they receive a wrong blockhash. This will cost them some gas to send the transaction. If the block is older than 256 blocks, this may even cost a lot of gas since the server needs to put blockhashes into the BlockhashRegistry first. But they are incentivized to do so, because after successfully convicting, they receive a reward of 50% of the deposit.

A miner or other attacker could now wait for a pending transaction for convict and simply use the data and send the same transaction with a high gas price, which means the transaction would eventually be mined first and the server, after putting so much work into preparing the convict, would get nothing.

Solution:

Convicting a server requires two steps: The first is calling the `convict` function with the block number of the wrongly signed block `keccak256(_blockhash, sender, v, r, s)`. Both the real blockhash and the provided hash will be stored in the smart contract. In the second step, the function `revealConvict` has to be called. The missing information is revealed there, but only the previous sender is able to reproduce the provided hash of the first transaction, thus being able to convict a server.

*Desicion*: Accepted and implemented

## Network Attacks

### Blacklist Attack
Status: partially solved

If the client has no direct internet connection and must rely on a proxy or a phone to make requests, this would give the intermediary the chance to set up a malicious server.

This is done by simply forwarding the request to its own server instead of the requested one. Of course, they may prepare a wrong answer, but they cannot fake the signatures of the blockhash. Instead of sending back any signed hashes, they may return no signatures, which indicates to the client that the chosen nodes were not willing to sign them. The client will then blacklist them and request the signature from other nodes. The proxy or relay could return no signature and repeat that until all are blacklisted and the client finally asks for the signature from a malicious node, which would then give the signature and the response. Since both come from a bad-acting server, they will not convict themself and will thus prepare a proof for a wrong response.

Solutions:

1. **Signing Responses**

    > SIM: First, we may consider signing the response of the DataProvider node, even if this signature cannot be used to convict. However, the client then knows that this response came from the client they requested and was also checked by them. This would reduce the chances of this attack since this would mean that the client picked two random servers that were acting malicious together.

    *Decision*:

    Not implemented yet. Maybe later.    


2. **Reject responses when 50% are blacklisted**

    > If the client blacklisted more than 50% of the nodes, we should stop. The only issue here is that the client does not know whether this is an ‘Inactive Server Spam Attack’ or not. In case of an ‘Inactive Server Spam Attack,’ it would actually be good to blacklist 90% of the servers and still be able to work with the remaining 10%, but if the proxy is the problem, then the client needs to stop blacklisting.

    > CHR: I think the client needs a list of nodes (bootstrape nodes) that should be signed in case the response is no signature at all. No signature at all should default to an untrusted relayer. In this case, it needs to go to trusted relayers. Or ask the untrusted relayer to get a signature from one of the trusted relayers. If they forward the signed reponse, they should become trusted again.

    > SIM: We will allow the client to configure optional trusted nodes, which will always be part of the nodelist and used in case of a blacklist attack. This means in case more than 50% are blacklisted the client may only ask trusted nodes and if they don't respond, instead of blacklisting it will reject the request. While this may work in case of such a attack, it becomes an issue if more than 50% of the registered nodes are inactive and blacklisted.

    *Decision*:

    The option of allowing trusted nodes is implemented. 

### DDoS Attacks
Status: solved (as much as possible)

Since the URLs of the network are known, they may be targets for DDoS attacks.

Solution:

> SIM: Each node is reponsible for protecting itself with services like Cloudflare. Also, the nodes should have an upper limit of concurrent requests they can handle. The response with status 500 should indicate reaching this limit. This will still lead to blacklisting, but this protects the node by not sending more requests.

> CHR: The same is true for bootstrapping nodes of the foundation.



### None Verifying DataProvider
Status: solved (more signatures = more security)

A DataProvider should always check the signatures of the blockhash they received from the signers. Of course, the DataProvider is incentivized to do so because then they can get 50% of their deposit, but after getting the deposit, they are not incentivized to report this to the client. There are two scenarios:

1. The DataProvider receives the signature but does not check it.

    In this case, at least the verification inside the client will fail since the provided blockheader does not match.    

2. The DataProvider works together with the signer.

    In this case, the DataProvider would prepare a wrong blockheader that fits the wrong blockhash and would pass the verification inside the client.

Solution:

> SIM: In this case, only a higher number of signatures could increase security. 

## Privacy

### Private Keys as API Keys

Status: solved

For the scoring model, we are using private keys. The perfect security model would register each client, which is almost impossible on mainnet, especially if you have a lot of devices. Using shared keys will very likely happen, but this a nightmare for security experts.

Solution:

1. Limit the power of such a key so that the worst thing that can happen is a leaked key that can be used by another client, which would then be able to use the score of the server the key is assigned to.    

2. Keep the private key secret and manage the connection to the server only off chain.    

3. Instead of using a private key as API-Key, we keep the private key private and only get a signature from the node of the ecosystem confirming this relationship. This may happen completly offchain and scales much better.    

*Desicion*: clients will not share private keys, but work with a signed approval from the node.

### Filtering of Nodes
Status: partially solved

All nodes are known with their URLs in the NodeRegistry-contract. For countries trying to filter blockchain requests, this makes it easy to add these URLs to blacklists of firewalls, which would stop the Incubed network.

Solution:

> Support Onion-URLs, dynamic IPs, LORA, BLE, and other protocols. The registry may even use the props to indicate the capabilities, so the client can choose which protocol to he is capable to use.

*Decision*: Accepted and prepared, but not fully implemented yet.

### Inspecting Data in Relays or Proxies

For a device like a BLE, a relay (for example, a phone) is used to connect to the internet. Since a relay is able to read the content, it is possible to read the data or even pretend the server is not responding. (See Blacklist Attack above.)
 
Solution:

> Encrypt the data by using the public key of the server. This can only be decrypted by the target server with the private key.

## Risk Calculation

Just like the light client there is not 100% protection from malicious servers. The only way to reach this would be to trust special authority nodes to sign the blockhash. For all other nodes, we must always assume they are trying to find ways to cheat.

The risk of losing the deposit is significantly lower if the DataProvider node and the signing nodes are run by the same attacker. In this case, they will not only skip over checks, but also prepare the data, the proof, and a blockhash that matches the blockheader. If this were the only request and the client had no other anchor, they would accept a malicious response.

Depending on how many malicious nodes have registered themselves and are working together, the risk can be calculated. If 10% of all registered nodes would be run by an attacker (with the same deposit as the rest), the risk of getting a malicious response would be 1% with only one signature. The risk would go down to 0.006% with three signatures:



![50% bad](./image1.png)



In case of an attacker controlling 50% of all nodes, it looks a bit different. Here, one signature would give you a risk of 25% to get a bad response, and it would take more than four signatures to reduce this to under 1%.



![10% bad](./image2.png)



Solution:

> The risk can be reduced by sending two requests in parallel. This way the attacker cannot be sure that their attack would be successful because chances are higher to detect this. If both requests lead to a different result, this conflict can be forwarded to as many servers as possible, where these servers can then check the blockhash and possibly convict the malicious server.
