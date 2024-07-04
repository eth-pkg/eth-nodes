name = "eth-node-erigon-teku-service-testnet"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: erigon and teku."
conflicts = ["eth-node-testnet"]
recommends = []
provides = ["eth-node-testnet"]
suggests = []
depends = ["eth-node-erigon", "eth-node-teku"]
add_files = []
add_manpages = []
long_doc = """eth-node-testnet
By installing this package,
it will automatically set up a erigon and teku client pair (consensus and execution client) for connecting
to the Ethereum testnet network.
"""
