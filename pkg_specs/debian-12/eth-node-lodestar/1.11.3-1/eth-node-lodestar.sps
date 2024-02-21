name = "eth-node-lodestar"
architecture = "any"
summary = "TypeScript Implementation of Ethereum Consensus "
conflicts = []
recommends = []
provides = ["eth-node-consensus-client"]
suggests = ["eth-node"]
add_files = ["lodestar /usr/share/eth-node-lodestar/bin", "packages /usr/share/eth-node-lodestar/packages"]
add_links = ["/usr/share/eth-node-lodestar/bin/lodestar /usr/bin/lodestar"]
add_manpages = []
long_doc = """
Lodestar is a TypeScript implementation of the Ethereum Consensus specification developed by ChainSafe Systems.
"""
