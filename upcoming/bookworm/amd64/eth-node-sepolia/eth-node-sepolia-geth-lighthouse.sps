name = "eth-node-geth-lighthouse-service-sepolia"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: geth and lighthouse."
conflicts = ["eth-node-sepolia"]
recommends = []
provides = ["eth-node-sepolia"]
suggests = []
depends = ["eth-node-geth", "eth-node-lighthouse"]
add_files = []
add_manpages = []
long_doc = """eth-node-sepolia
By installing this package,
it will automatically set up a geth and lighthouse client pair (consensus and execution client) for connecting
to the Ethereum sepolia network.
"""
