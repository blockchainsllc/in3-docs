# Decentralizing Central Services

*Important: This concept is still in early development, meaning it has not been implemented yet.*

Many dApps still require some off-chain services, such as search functions running on a server, which, of course, can be seen as a single point of failure. To decentralize these dApp-specific services, they must fulfill the following criteria:

1. **Stateless**: Since requests may be sent to different servers, they cannot hold a user's state, which would only be available on one node.
2. **Deterministic**: All servers need to produce the exact same result.

If these requirements are met, the service can be registered, defining the server behavior in a docker image.

```eval_rst
.. graphviz::

    digraph minimal_nonplanar_graphs {
    graph [ rankdir = "LR" ]
    fontname="Helvetica"

    subgraph all {
        label="Registry"

        subgraph cluster_client_registry {
            label="ServiceRegistry"  color=lightblue  style=filled
            node [ fontsize = "12", style="",  shape = "record" color=black fontname="Helvetica" ]

            M[label="<f0>Matrix|matrix/matrix:latest|wasm"]
            S[label="<f0>Search|slockit/search:latest|wasm"]
            W[label="<f0>Whisper|whisper:latest|wasm"]
        }


        subgraph cluster_registry {
            label="ServerRegistry"  color=lightblue  style=filled
            node [ fontsize = "12", shape = "record",  color=black style="" fontname="Helvetica" ]

            sa[label="<f0>Server A|<offer>offer|<rewards>rewards|<f2>http://rpc.s1.."]
            sb[label="<f0>Server B|<offer>offer|<rewards>rewards|<f2>http://rpc.s2.."]
            sc[label="<f0>Server C|<offer>offer|<rewards>rewards|<f2>http://rpc.s3.."]

            sa:offer -> M:f0 [color=darkgreen]
            sa:offer -> S:f0 [color=darkgreen]
            sb:offer -> W:f0 [color=darkgreen]
            sc:offer -> W:f0 [color=darkgreen]

            M:f0  -> sa:rewards [color=orange]
            M:f0  -> sb:rewards [color=orange]
            W:f0  -> sc:rewards [color=orange]


        }


        subgraph cluster_cloud {
            label="cloud"  color=lightblue  style=filled
            node [ fontsize = "12",  color=white style=filled  fontname="Helvetica" ]

            A[label="Server A"]
            A -> {       
                AM[label="Matrix", shape=record]
                AS[label="Search", shape=record]
            }

            B[label="Server B"]
            {B C} -> {       
                BW[label="Whisper", shape=record]
            }
            C[label="Server C"]
    
        }
    }}

```

## Incentivization

Each server can define (1) a list of services to offer or (2) a list of services to reward.

The main idea is simply the following:

> **If you run my service, I will run yours.**

Each server can specifiy which services we would like to see used. If another server offers them, we will also run at least as many rewarded services as the other node.

## Verification

Each service specifies a verifier, which is a Wasm module (specified through an IPFS hash). This Wasm offers two functions:

```js
function minRequests():number

function verify(request:RPCRequest[], responses:RPCResponse[])
```

A minimal version could simply ensure that two requests were running and then compare them. If different, the Wasm could check with the home server and "convict" the nodes.

### Convicting

Convicting on chain cannot be done, but each server is able to verify the result and, if false, downgrade the score.
