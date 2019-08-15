# Incentivization

*Important: This concept is still in development and discussion and is not yet fully implemented.*

The original idea of blockchain is a permissionless peer-to-peer network in which anybody can participate if they run a node and sync with other peers. Since this is still true, we know that such a node won't run on a small IoT-device.

## Decentralizing Access

This is why a lot of users try remote-nodes to serve their devices. However, this introduces a new single point of failure and the risk of man-in-the-middle attacks. 

So the first step is to decentralize remote nodes by sharing rpc-nodes with other apps. 

```eval_rst
.. graphviz::

  graph minimal_nonplanar_graphs {
    node [style=filled  fontname="Helvetica"]
  fontname="Helvetica"

  subgraph cluster_infura {
    label="centralized"  color=lightblue  style=filled
    node [color=white]

    i[label="infura"]
    __a[label="a"]
    __b[label="b"]
    __c[label="c"]

    i -- __a
    i -- __b
    i -- __c
  }

  subgraph cluster_1 {
      label="centralized per Dapp"  color=lightblue  style=filled
      node [color=white]
      _C[label="C"]
      _B[label="B"]
      _A[label="A"]
      _c[label="c"]
      _b[label="b"]
      _a[label="a"]

      _C -- _c
      _A -- _a
      _B -- _b
    }


    subgraph cluster_0 {
      label="Incubed"  color=lightblue  style=filled
      node [color=white]
      {A B C} -- {a b c}
    }
  }
```




## Incentivization for Nodes

In order to incentivize a node to serve requests to clients, there must be something to gain (payment) or to lose (access to other nodes for its clients).

## Connecting Clients and Server

As a simple rule, we can define this as: 

> **The Incubed network will serve your client requests if you also run an honest node.**

This requires a user to connect a client key (used to sign their requests) with a registered server.
Clients are able to share keys as long as the owner of the node is able to ensure their security. This makes it possible to use one key for the same mobile app or device.
The owner may also register as many keys as they want for their server or even change them from time to time (as long as only one client key points to one server).
The key is registered in a client-contract, holding a mapping of the key to the server address.


```eval_rst
.. graphviz::

    digraph minimal_nonplanar_graphs {
    graph [ rankdir = "LR" ]
    fontname="Helvetica"
      subgraph all {
          label="Registry"

        subgraph cluster_cloud {
            label="cloud"  color=lightblue  style=filled
            node [ fontsize = "12",  color=white style=filled  fontname="Helvetica" ]

            A[label="Server A"]
            B[label="Server B"]
            C[label="Server C"]
      
        }

        subgraph cluster_registry {
            label="ServerRegistry"  color=lightblue  style=filled
            node [ fontsize = "12", shape = "record",  color=black style="" fontname="Helvetica" ]

            sa[label="<f0>Server A|cap:10|<f2>http://rpc.s1.."]
            sb[label="<f0>Server B|cap:100|<f2>http://rpc.s2.."]
            sc[label="<f0>Server C|cap:20|<f2>http://rpc.s3.."]

            sa:f2 -> A
            sb:f2 -> B
            sc:f2 -> C
      
        }


        subgraph cluster_client_registry {
            label="ClientRegistry"  color=lightblue  style=filled
            node [ fontsize = "12", style="", color=black fontname="Helvetica" ]

            ca[label="a"]
            cb[label="b"]
            cc[label="c"]
            cd[label="d"]
            ce[label="e"]

            ca:f0 -> sa:f0
            cb:f0 -> sb:f0
            cd:f0 -> sc:f0
            cc:f0 -> sc:f0
            ce:f0 -> sc:f0
      
        }


      }
    }

```


## Ensuring Client Access

Connecting a client key to a server does not mean the key relies on that server. Instead, the requests are simply served in the same quality as the connected node serves other clients. 
This creates a very strong incentive to deliver to all clients, because if a server node were offline or refused to deliver, eventually other nodes would deliver less or even stop responding to requests coming from the connected clients.

To actually find out which node delivers to clients, each server node uses one of the client keys to send test requests and measure the availability based on verified responses.

```eval_rst
.. graphviz::

    digraph minimal_nonplanar_graphs {
      node [style=filled  fontname="Helvetica"]
    fontname="Helvetica"

    ratio=0.8;

    subgraph cluster_1 {
        label="Verifying Nodes"  color=lightblue  style=filled
        node [color=white]
        ranksep=900000;
    //    rank=same
        A -> {B C D E }
        B -> {A C D E }
        C -> {A B D E }
        D -> {A B C E }
        E -> {A B C D  }
      }


    }

```


The servers measure the `$ A_{availability}$` by checking periodically (about every hour in order to make sure a malicious server is not only responding to test requests). These requests may be sent through an anonymous network like tor.

Based on the long-term (>1 day) and short-term (<1 day) availibility, the score is calculated as:

```math
A = \frac{ R_{received} }{ R_{sent} }
```

In order to balance long-term and short-term availability, each node measures both and calculates a factor for the score. This factor should ensure that short-term avilability will not drop the score immediately, but keep it up for a while before dropping. Long-term availibility will be rewarded by dropping the score slowly.

```math
A =  1 - ( 1 - \frac{A_{long} + 5 \cdot A_{short}}6 )^{10} 
```

- `$ A_{long}$` - The ratio between valid requests received and sent within the last month.
- `$ A_{short}$` - The ratio between valid requests received and sent within the last 24 hours.

![](./graphAvailable.png)

Depending on the long-term availibility the disconnected node will lose its score over time.


The final score is then calulated:

```math
score =  \frac{ A \cdot D_{weight} \cdot C_{max}}{weight}
```

- `$ A$` - The availibility of the node.
- `$ weight$` - The weight of the incoming request from that server's clients (see LoadBalancing).
- `$ C_{max}$` - The maximal number of open or parallel requests the server can handle (will be taken from the registry).
- `$ D_{weight}$` - The weight of the deposit of the node.

This score is then used as the priority for incoming requests. This is done by keeping track of the number of currently open or serving requests. Whenever a new request comes in, the node does the following:

1. Checks the signature. 
2. Calculates the score based on the score of the node it is connected to.
3. Accepts or rejects the request.

```js
if ( score < openRequests ) reject()
```

This way, nodes reject requests with a lower score when the load increases. For a client, this means if you have a low score and the load in the network is high, your clients may get rejected often and will have to wait longer for responses. If the node has a score of 0, they are blacklisted.

## Deposit

Storing a high deposit brings more security to the network. This is important for proof-of-work chains.
In order to reflect the benefit in the score, the client multiplies it with the `$ D_{weight}$` (the deposit weight).

```math
D_{weight} = \frac1{1 + e^{1-\frac{3 D}{D_{avg}}}}
```

- `$ D$` - The stored deposit of the node.
- `$ D_{avg}$` - The average deposit of all nodes.

A node without any deposit will only receive 26.8% of the max cap, while any node with an average deposit gets 88% and above and quickly reaches 99%.

![](./depositWeight.png)


## LoadBalancing

In an optimal network, each server would handle an equal amount and all clients would have an equal share. In order to prevent situations where 80% of the requests come from clients belonging to the same node, we need to decrease the score for clients sending more requests than their shares.
Thus, for each node the weight can be calculated by:

```math
weight_n =  \frac{{\displaystyle\sum_{i=0}^n} C_i \cdot R_n } { {\displaystyle\sum_{i=0}^n} R_i \cdot C_n  } 
```
- `$ R_n$` - The number of requests served to one of the clients connected to the node.
- `$ {\displaystyle\sum_{i=0}^n} R_i$` - The total number of requests served. 
- `$ {\displaystyle\sum_{i=0}^n} C_i$` - The total number of capacities of the registered servers.
- `$ C_n$` - The capacity of the registered node. 

Each node will update the `$ score$` and the `$weight$` for the other nodes after each check in order to prioritize incoming requests.

The capacity of a node is the maximal number of parallel requests it can handle and is stored in the ServerRegistry. This way, all clients know the cap and will weigh the nodes accordingly, which leads to stronger servers. A node declaring a high capacity will gain a higher score, and its clients will receive more reliable responses. On the other hand, if a node cannot deliver the load, it may lose its availability as well as its score.

## Free Access

Each node may allow free access for clients without any signature. A special option `--freeScore=2` is used when starting the server. For any client requests without a signature, this `$score$` is used. Setting this value to 0 would not allow any free clients.

```
  if (!signature) score = conf.freeScore
```

A low value for freeScore would serve requests only if the current load or the open requests are less than this number, which would mean that getting a response from the network without signing may take longer as the client would have to send a lot of requests until they are lucky enough to get a response if the load is high. Chances are higher if the load is very low.

## Convict

Even though servers are allowed to register without a deposit, convicting is still a hard punishment. In this case, the server is not part of the registry anymore and all its connected clients are treated as not having a signature. The device or app will likely stop working or be extremely slow (depending on the freeScore configured in all the nodes).

## Handling conflicts

In case of a conflict, each client now has at least one server it knows it can trust since it is run by the same owner. This makes it impossible for attackers to use blacklist-attacks or other threats which can be solved by requiring a response from the "home"-node.

## Payment

Each registered node creates its own ecosystem with its own score. All the clients belonging to this ecosystem will be served only as well as the score of the ecosystem allows. However, a good score can not only be achieved with a good performance, but also by paying for it. 

For all the payments, a special contract is created. Here, anybody can create their own ecosystem even without running a node. Instead, they can pay for it. 
The payment will work as follows:

The user will choose a price and time range (these values can always be increased later). Depending on the price, they also achieve voting power, thus creating a reputation for the registered nodes. 

Each node is entitled to its portion of the balance in the payment contract, and can, at any given time, send a transaction to extract its share. 
The share depends on the current reputation of the node.

```math
payment_n =  \frac{weight_n \cdot reputation_n \cdot balance_{total}} { weight_{total} } 
```

Why should a node treat a paying client better than others?

Because the higher the price a user paid, the higher the voting power, which they may use to upgrade or downgrade the reputation of the node. This reputation will directly influence the payment to the node.

That's why, for a node, the score of a client depends on what follows:

```math
score_c =  \frac{ paid_c \cdot requests_{total}} { requests_c \cdot paid_{total} + 1} 
```

The score would be 1 if the payment a node receives has the same percentage of requests from an ecosystem as the payment of the ecosystem represented relative to the total payment per month. So, paying a higher price would increase its score. 

## Client Identification

As a requirement for identification, each client needs to generate a unique private key, which must never leave the device.

In order to securely identify a client as belonging to an ecosystem, each request needs two signatures:

1. **The Ecosystem-Proof**    
   This proof consists of the following information:
   
   ```js
   proof = rlp.encode(
      bytes32(registry_id),      // The unique ID of the registry.
      address(client_address),   // The public address of a client.
      uint(ttl),                 // Unix timestamp when this proof expires. 
      bytes(signature)           // The signature with the signer-key of the ecosystem. The message hash is created by rlp.encode, the client_address, and the ttl. 
   )
   ```
   
   For the client, this means they should always store such a proof on the device. If the ttl expires, they need to renew it. 
   If the ecosystem is a server, it may send a request to the server. If the ecosystem is a payer, this needs to happen in a custom way.
   
2. **The Client-Proof**    
   This must be created for each request. Here the client will create a hash of the request (simply by adding the `method`, `params` and a `timestamp`-field) and sign this with its private key.
   
   ```js
   message_hash = keccack(
      request.method 
      + JSON.stringify(request.params)
      + request.timestamp 
   )
   ```
   
With each request, the client needs to send both proofs.


The server may cache the ecosystem-proof, but it needs to verify the client signature with each request, thus ensuring the identity of the sending client.
  .
