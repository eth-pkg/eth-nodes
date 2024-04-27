name = "eth-node-prysm"
architecture = "any"
summary = "Prysm: An Ethereum Consensus Implementation Written in Go"
conflicts = []
recommends = []
provides = ["eth-node-consensus-client"]
suggests = ["eth-node"]
add_files = [
"bazel-bin/cmd/beacon-chain/beacon-chain_/beacon-chain /usr/lib/eth-node-prysm/bin",
"bazel-bin/cmd/validator/validator_/validator /usr/lib/eth-node-prysm/bin"
]
add_links = [
"/usr/lib/eth-node-prysm/bin/beacon-chain /usr/bin/beacon-chain",
"/usr/lib/eth-node-prysm/bin/beacon-chain /usr/bin/prysm",
]
add_manpages = []
long_doc = """Prysm
A full-featured client for the Ethereum Proof-of-Stake protocol, written in Go

The Prysm project is a Go implementation of the Ethereum protocol as detailed by its official specification. It contains a full beacon node implementation as well as a validator client for participating in blockchain consensus. Prysm utilizes top tools for production servers and interprocess communication, using Google's gRPC library, BoltDB as an optimized, persistent, key-value store, and libp2p by Protocol Labs for all peer-to-peer networking.

Launched December 1st 2020, eth2 is a publicly accessible network running multiple client implementations participating in Ethereum consensus based on the formal specification for the protocol. The official and only validator deposit contract is 0x00000000219ab540356cbb839cbe05303d7705fa. 
"""
