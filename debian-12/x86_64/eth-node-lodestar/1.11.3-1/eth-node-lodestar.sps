name = "eth-node-lodestar"
architecture = "any"
summary = "TypeScript Implementation of Ethereum Consensus "
conflicts = []
recommends = []
provides = ["eth-node-consensus-client (= 1)"]
suggests = ["eth-node (= 1)"]
# node-gyp, not entirely sure if needed, let's add it 
depends = ["python3"]
add_files = [
    "debian/lodestar /usr/lib/eth-node-lodestar/bin", 
    "packages /usr/lib/eth-node-lodestar",
    "node_modules /usr/lib/eth-node-lodestar"
    ]
add_links = ["/usr/lib/eth-node-lodestar/bin/lodestar /usr/bin/lodestar"]
add_manpages = []
long_doc = """
Lodestar is a TypeScript implementation of the 
Ethereum Consensus specification developed by ChainSafe Systems.
"""