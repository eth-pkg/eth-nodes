name = "eth-node-besu-prysm-service-mainnet"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: besu and prysm."
conflicts = ["eth-node-mainnet"]
recommends = []
provides = ["eth-node-mainnet"]
suggests = []
depends = []
add_files = []
add_manpages = []
long_doc = """eth-node-mainnet
By installing this package,
it will automatically set up a besu and prysm client pair (consensus and execution client) for connecting
to the Ethereum mainnet network.
"""
