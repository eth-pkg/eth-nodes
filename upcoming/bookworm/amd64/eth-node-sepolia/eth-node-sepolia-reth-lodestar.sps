name = "eth-node-reth-lodestar-service-sepolia"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: reth and lodestar."
conflicts = ["eth-node-sepolia"]
recommends = []
provides = ["eth-node-sepolia"]
suggests = []
depends = ["eth-node-reth", "eth-node-lodestar"]
add_files = []
add_manpages = []
long_doc = """eth-node-sepolia
By installing this package,
it will automatically set up a reth and lodestar client pair (consensus and execution client) for connecting
to the Ethereum sepolia network.
"""
