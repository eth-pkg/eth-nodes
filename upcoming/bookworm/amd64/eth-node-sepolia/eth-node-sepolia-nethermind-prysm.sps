name = "eth-node-nethermind-prysm-service-sepolia"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: nethermind and prysm."
conflicts = ["eth-node-sepolia"]
recommends = []
provides = ["eth-node-sepolia"]
suggests = []
depends = []
add_files = []
add_manpages = []
long_doc = """eth-node-sepolia
By installing this package,
it will automatically set up a nethermind and prysm client pair (consensus and execution client) for connecting
to the Ethereum sepolia network.
"""
