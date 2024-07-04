name = "eth-node-erigon-prysm-service-mainnet"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: erigon and prysm."
conflicts = ["eth-node-service-mainnet"]
recommends = []
provides = ["eth-node-service-mainnet"]
suggests = []
depends = []
add_files = []
add_manpages = []
long_doc = """eth-node-service-mainnet
By installing this package,
it will automatically set up a erigon and prysm client pair (consensus and execution client) for connecting
to the Ethereum mainnet network.
"""
