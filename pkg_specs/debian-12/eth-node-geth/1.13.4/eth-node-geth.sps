name = "eth-node-geth"
architecture = "any"
summary = "Go ethereum binary"
conflicts = []
recommends = []
provides = ["eth-node-execution-client"]
suggests = ["eth-node"]
add_files = [
"build/bin/abidump /usr/lib/eth-node-geth/bin",
"build/bin/abigen /usr/lib/eth-node-geth/bin",
"build/bin/bootnode /usr/lib/eth-node-geth/bin",
"build/bin/clef /usr/lib/eth-node-geth/bin",
"build/bin/devp2p /usr/lib/eth-node-geth/bin",
"build/bin/ethkey /usr/lib/eth-node-geth/bin",
"build/bin/evm /usr/lib/eth-node-geth/bin",
"build/bin/faucet /usr/lib/eth-node-geth/bin",
"build/bin/geth /usr/lib/eth-node-geth/bin",
"build/bin/p2psim /usr/lib/eth-node-geth/bin",
"build/bin/rlpdump /usr/lib/eth-node-geth/bin",
]
add_links = ["/usr/lib/eth-node-geth/bin/geth /usr/bin/geth"]
add_manpages = []
long_doc = """ Go-etheurum binary
"""
