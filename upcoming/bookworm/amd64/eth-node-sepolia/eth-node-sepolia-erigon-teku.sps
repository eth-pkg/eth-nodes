name = "eth-node-erigon-teku-service-sepolia"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: erigon and teku."
conflicts = ["eth-node-sepolia"]
recommends = []
provides = ["eth-node-sepolia"]
suggests = []
depends = []
add_files = []
add_manpages = []
long_doc = """eth-node-sepolia
By installing this package,
it will automatically set up a erigon and teku client pair (consensus and execution client) for connecting
to the Ethereum sepolia network.
"""
