name = "eth-node-nethermind-teku-service-testnet"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: nethermind and teku."
conflicts = ["eth-node-testnet"]
recommends = []
provides = ["eth-node-testnet"]
suggests = []
depends = ["eth-node-nethermind", "eth-node-teku"]
add_files = []
add_manpages = []
long_doc = """eth-node-testnet
By installing this package,
it will automatically set up a nethermind and teku client pair (consensus and execution client) for connecting
to the Ethereum testnet network.
"""
