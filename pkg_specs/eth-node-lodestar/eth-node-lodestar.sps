name = "eth-node-lodestar"
architecture = "any"
summary = "TypeScript Implementation of Ethereum Consensus "
conflicts = []
recommends = []
provides = ["eth-node-consensus-client"]
suggests = ["eth-node"]
add_files = ["lodestar /usr/bin", "packages /usr/bin"]
add_manpages = []
long_doc = """
Lodestar is a TypeScript implementation of the Ethereum Consensus specification developed by ChainSafe Systems.
"""
