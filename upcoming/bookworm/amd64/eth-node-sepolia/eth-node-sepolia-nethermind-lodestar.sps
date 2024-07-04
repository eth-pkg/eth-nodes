name = "eth-node-nethermind-lodestar-service-sepolia"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: nethermind and lodestar."
conflicts = ["eth-node-sepolia"]
recommends = []
provides = ["eth-node-sepolia"]
suggests = []
depends = []
add_files = []
add_manpages = []
long_doc = """eth-node-sepolia
By installing this package,
it will automatically set up a nethermind and lodestar client pair (consensus and execution client) for connecting
to the Ethereum sepolia network.
"""
