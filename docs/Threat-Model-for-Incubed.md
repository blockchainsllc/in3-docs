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
> But for the 100% decentralized way, you can only reduce it by asking multiple servers. Since they will also pass the latest block number when the NodeList changed, the client will find out that it needs to update the NodeList, and by having multiple requests in parallel, it reduces the risk of relying on a manipulated NodeList. The malicious server may return a correct NodeList for an older block when this server was still valid and even get signatures for this, but the server cannot do so for a newer block number, which can only be found out by asking as many servers as needed.

> Another point is that as long as the signature does not come from the same server, the DataProvider will always check, so even if you request a signature from a server that is not part of the list anymore, the DataProvider will reject this. To use this attack, both the DataProvider and the BlockHashSigner must work together to provide a proof that matches the wrong blockhash.

> CHR: Correct. I think the strategy for clients who have been offline for a while is to first get multiple signed blockhashes from different sources (ideally from bootstrap nodes similar to light clients and then ask for the current list). Actually, we could define the same bootstrap nodes as are currently hard-coded in Parity and Geth.

### Inactive Server Spam Attack
Status: solved

Everyone can register a lot of servers that don’t even exist or aren't running. Somebody may even put in a decent deposit. Of course, the client would try to find out whether these nodes were inactive. If an attacker were able to onboard enough inactive servers, the chances for an Incubed client to find a working server would decrease. 

Solutions:

To register a server, the owner has to pay a deposit calculated by the formula:
```math
deposit_{min} = \frac{ 86400 \cdot deposit_{average} }{ ( t_{now} - t_{lastRegistered} ) }
```
To avoid some exploitation of the formula, the `deposit_average` gets capped at 50 Ether. This means that the maximum `deposit_min` calculated by this formula is about 4.3 million Ether when trying to register two servers within one block. In the first year, there will also be an enforced deposit limit of 50 Ether, so it will be impossible to rapidly register new servers, giving us more time to react to possible spam attacks (e.g., through voting).

In addition, the smart contract provides a voting function for removing inactive servers: To vote, a server has to sign a message with a current block and the owner of the server they want to get voted out. Only the latest 256 blockhashes are allowed, so every signature will effectively expire after roughly 1 hour. The power of each vote will be calculated by the amount of time when the server was registered. To make sure that the oldest servers won't get too powerful, the voting power gets capped at one year and won't increase further. The server being voted out will also get an oppositional voting power that is capped at two years.

For the server to be voted out, the combined voting power of all the servers has to be greater than the oppositional voting power. Also, the accumulated voting power has to be greater than at least 50% of all the chosen voters.

As with a high amount of registered in3-servers, the handling of all votes would become impossible. We cap the maximum amount of signatures at 24: This means to vote out a server that has been active for more then two years, 24 in3-servers with a lifetime of one month are required to vote. This number decreases when more older servers are voting. This mechanism will prevent the rapid onboarding of many malicious in3-servers that would vote out all regular servers and take control of the in3-nodelist.

Additionally, we do not allow all servers to vote. Instead, we choose up to 24 servers randomly with the blockhash as seed. For the vote to succeed, they have to sign on the same blockhash and have enough voting power.

To "punish" a server owner for having an inactive server, after a successful vote, that individual will lose 1% of their deposit while the rest gets locked until their deposit timeout expires, ensuring possible liabilities. Part of this 1% deposit will be used to reimburse the transaction costs; the rest will be burned. To make sure that the transaction will always be paid, a minimum deposit of 10 finney (equal to 0.01 Ether) is also enforced.

### Self-Convict Attack
Status: solved

A user may register a mailcious server and even store a deposit, but as soon as they sign a wrong blockhash, they use a second account to convict themself to get the deposit before somebody else can.

Solution:

> SIM: In this case, the attacker would lose 50% of their deposit because it will be burned. But this also means the attacker would get the other half, so the price they would have to pay for lying is up to 50% of their deposit. This should be considered by clients when picking nodes for signatures.

### Convict Frontrunner Attack
Status: solved

Servers act as watchdogs and automatically call convict if they receive a wrong blockhash. This will cost them some gas to send the transaction. If the block is older than 256 blocks, this may even cost a lot of gas since the server needs to put blockhashes into the BlockhashRegistry first. But they are incentivized to do so because after successfully convicting, they receive a reward of 50% of the deposit.

A miner or other attacker could now wait for a pending transaction for convict and simply use the data and send the same transaction with a high gas price, which means the transaction would eventually be mined first and the server, after putting so much work into preparing the convict, would get nothing.

Solution:

Convicting a server requires two steps: The first is calling the `convict` function with the block number of the wrongly signed block and `keccak256(_blockhash, sender, v, r, s)`. Both the real blockhash and the provided hash will be stored in the smart contract. In the second step, the function `revealConvict` has to be called. The missing information is revealed there, but only the previous sender is able to reproduce the provided hash of the first transaction, thus being able to convict a server.

## Network Attacks

### Blacklist Attack
Status: open

If the client has no direct internet connection and must rely on a proxy or a phone to make requests, this would give the intermediary the chance to set up a malicious server.

This is done by simply forwarding the request to its own server instead of the requested one. Of course, they may prepare a wrong answer, but they cannot fake the signatures of the blockhash. Instead of sending back any signed hashes, they may return no signatures, which indicates to the client that those were not willing to sign them. Then the client will blacklist them and request the signature from other nodes. The proxy or relay could return no signature and repeat that until all are blacklisted and the client finally asks for the signature from a malicious node, which would then give the signature and the response. Since both come from a bad-acting server, they will not convict themself and will thus prepare a proof for a wrong response.

Solutions:

> First, we may consider signing the response of the DataProvider node, even if this signature cannot be used to convict, but then the client knows that this response came from the client they requested and was also checked by them. This would reduce the chances of this attack since this would mean that the client picked two random servers that were acting malicious together.

> If the client blacklisted more than 50% of the nodes, they should stop. The only issue here is that the client does not know whether this is an ‘Inactive Server Spam Attack’ or not. In case of an ‘Inactive Server Spam Attack,’ it would actually be good to blacklist 90% of the servers and still be able to work with the remaining 10%, but if the proxy is the problem, then the client needs to stop blacklisting.

> CHR: I think the client needs a list of nodes (bootstrape nodes) that should be signed in case the response is no signature at all. No signature at all should default to an untrusted relayer. In this case, it needs to go to trusted relayers. Or ask the untrusted relayer to get a signature from one of the trusted relayers. If they forward the signed reponse, they should become trusted again.

### DDoS Attacks

Since the URLs of the network are known, they may be targets for DDoS attacks.

Solution:

> Each node is reponsible for protecting itself with services like Cloudflare. Also, the nodes should have an upper limit of concurrent requests they can handle. The response with status 500 should indicate reaching this limit. This will still lead to blacklisting, but this protects the node by not sending more requests.

> CHR: The same is true for bootstrapping nodes of the foundation.

### None Verifying DataProvider

A DataProvider should always check the signatures of the blockhash they received from the signers. Of course, the DataProvider is incentivized to do so because then they can get their deposit, but after getting the deposit, they are not incentivized to report this to the client. There are two scenarios:

1. The DataProvider receives the signature but does not check it.
In this case, at least the verification inside the client will fail since the provided blockheader does not match.

2. The DataProvider works together with the signer.
In this case, the DataProvider would prepare a wrong blockheader that fits the wrong blockhash and would pass the verification inside the client.

Solution:

> SIM: In this case, only a higher number of signatures could increase security.

## Privacy

### Private Keys as API Keys

For the scoring model, we are using private keys. The perfect security model would be registering each client, which is almost impossible on mainnet, especially if you have a lot of devices. Using shared keys will very likely happen, but this a nightmare for security experts.

Solution:

1. Limit the power of such a key so that the worst thing that can happen is a leaked key that can be used by another client, which would then be able to use the score of the server the key is assigned to.

2. Keep the private key secretly and manage the connection to the server only off chain.

### Filtering of Nodes

All nodes are known with their URLs in the ServerRegistry-contract. For countries trying to filter blockchain requests, this makes it easy to add these URLs to blacklists of firewalls, which would stop the Incubed network.

Solution:

> Support Onion-URLs, dynamic IPs, LORA, BLE, and other protocols.
 
### Inspecting Data in Relays or Proxies

For a device like a BLE, a relay (for example, a phone) is used to connect to the internet. Since a relay is able to read the content, it is possible to read the data or even pretend the server is not responding. (See Blacklist Attack above.)
 
Solution:

> Encrypt the data by using the public key of the server. This can only be decrypted by the target server with the private key.

## Risk Calculation

Just like the light client there is not 100% protection from malicious servers. The only way to reach this would be to trust special authority nodes for signing the blockhash. For all other nodes, we must always assume they are trying to find ways to cheat.

The risk of losing the deposit is significantly lower if the DataProvider node and the signing nodes are run by the same attacker. In this case, they will not only skip checks but also prepare the data, the proof, and a blockhash that matches the blockheader. If this were the only request and the client had no other anchor, they would accept a malicious response.

Depending on how many malicious nodes have registered themselves and are working together, the risk can be calculated. If 10% of all registered nodes would be run by an attacker (with the same deposit as the rest), the risk of getting a malicious response would be 1% with only one signature. The risk would go down to 0.006% with three signatures:



![Alt text](./image1.png)



In case of an attacker controlling 50% of all nodes, it looks a bit different. Here, one signature would give you a risk of 25% to get a bad response, and it would take more than four signatures to reduce this to under 1%.



![Alt text](./image2.png)



Solution:

> The risk can be reduced by sending two requests in parallel. This way the attacker cannot be sure that their attack would be successful because chances are higher to detect this. If both requests lead to a different result, this conflict can be forwarded to as many servers as possible, where these servers can then check the blockhash and possibly convict the malicious server.
