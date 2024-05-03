name = "eth-node-geth"
architecture = "any"
summary = "Golang execution layer implementation of the Ethereum protocol."
conflicts = []
recommends = []
provides = ["eth-node-execution-client (= 1)"]
suggests = ["eth-node (= 1)"]
add_files = [
"build/bin/abidump /usr/lib/eth-node-geth/bin",
"build/bin/abigen /usr/lib/eth-node-geth/bin",
"build/bin/blsync /usr/lib/eth-node-geth/bin",
"build/bin/bootnode /usr/lib/eth-node-geth/bin",
"build/bin/clef /usr/lib/eth-node-geth/bin",
"build/bin/devp2p /usr/lib/eth-node-geth/bin",
"build/bin/ethkey /usr/lib/eth-node-geth/bin",
"build/bin/evm /usr/lib/eth-node-geth/bin",
"build/bin/geth /usr/lib/eth-node-geth/bin",
"build/bin/p2psim /usr/lib/eth-node-geth/bin",
"build/bin/rlpdump /usr/lib/eth-node-geth/bin",
]
add_links = ["/usr/lib/eth-node-geth/bin/geth /usr/bin/geth"]
add_manpages = []
long_doc = """
Geth (go-ethereum) is a Go implementation of Ethereum - a gateway into the decentralized web.

Geth has been a core part of Ethereum since the very beginning. Geth was one of the original Ethereum implementations making it the most battle-hardened and tested client.

Geth is an Ethereum execution client meaning it handles transactions, deployment and execution of smart contracts and contains an embedded computer known as the Ethereum Virtual Machine.

Running Geth alongside a consensus client turns a computer into an Ethereum node.
"""
