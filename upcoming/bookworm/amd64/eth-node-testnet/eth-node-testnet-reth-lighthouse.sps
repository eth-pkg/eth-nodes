name = "eth-node-reth-lighthouse-service-testnet"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: reth and lighthouse."
conflicts = ["eth-node-testnet"]
recommends = []
provides = ["eth-node-testnet"]
suggests = []
depends = ["eth-node-reth", "eth-node-lighthouse"]
add_files = []
add_manpages = []
long_doc = """eth-node-testnet
By installing this package,
it will automatically set up a reth and lighthouse client pair (consensus and execution client) for connecting
to the Ethereum testnet network.
"""
