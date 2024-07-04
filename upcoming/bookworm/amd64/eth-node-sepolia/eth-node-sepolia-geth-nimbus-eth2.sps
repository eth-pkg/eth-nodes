name = "eth-node-geth-nimbus-eth2-service-sepolia"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: geth and nimbus-eth2."
conflicts = ["eth-node-sepolia"]
recommends = []
provides = ["eth-node-sepolia"]
suggests = []
depends = ["eth-node-geth", "eth-node-nimbus-eth2"]
add_files = []
add_manpages = []
long_doc = """eth-node-sepolia
By installing this package,
it will automatically set up a geth and nimbus-eth2 client pair (consensus and execution client) for connecting
to the Ethereum sepolia network.
"""
