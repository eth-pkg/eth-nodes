name = "eth-node-nethermind-lighthouse-service-sepolia"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: nethermind and lighthouse."
conflicts = ["eth-node-sepolia"]
recommends = []
provides = ["eth-node-sepolia"]
suggests = []
depends = ["eth-node-nethermind", "eth-node-lighthouse"]
add_files = []
add_manpages = []
long_doc = """eth-node-sepolia
By installing this package,
it will automatically set up a nethermind and lighthouse client pair (consensus and execution client) for connecting
to the Ethereum sepolia network.
"""
