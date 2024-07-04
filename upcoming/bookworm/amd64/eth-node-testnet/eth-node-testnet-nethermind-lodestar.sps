name = "eth-node-nethermind-lodestar-service-testnet"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: nethermind and lodestar."
conflicts = ["eth-node-testnet"]
recommends = []
provides = ["eth-node-testnet"]
suggests = []
depends = ["eth-node-nethermind", "eth-node-lodestar"]
add_files = []
add_manpages = []
long_doc = """eth-node-testnet
By installing this package,
it will automatically set up a nethermind and lodestar client pair (consensus and execution client) for connecting
to the Ethereum testnet network.
"""
