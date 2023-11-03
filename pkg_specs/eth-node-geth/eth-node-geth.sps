name = "eth-node-geth"
architecture = "any"
summary = "Go ethereum binary"
conflicts = []
recommends = []
provides = ["eth-node-execution-client"]
suggests = ["eth-node"]
add_files = [
"build/bin/abidump /usr/share/eth-node-geth/bin/abidump",
"build/bin/abigen /usr/share/eth-node-geth/bin/abigen",
"build/bin/bootnode /usr/share/eth-node-geth/bin/bootnode",
"build/bin/clef /usr/share/eth-node-geth/bin/clef",
"build/bin/devp2p /usr/share/eth-node-geth/bin/devp2p",
"build/bin/ethkey /usr/share/eth-node-geth/bin/ethkey",
"build/bin/evm /usr/share/eth-node-geth/bin/evm",
"build/bin/faucet /usr/share/eth-node-geth/bin/faucet",
"build/bin/geth /usr/share/eth-node-geth/bin/geth",
"build/bin/p2psim /usr/share/eth-node-geth/bin/p2psim",
"build/bin/rldump /usr/share/eth-node-geth/bin/rldump",
]
add_manpages = []
long_doc = """ Go-etheurum binary
"""
