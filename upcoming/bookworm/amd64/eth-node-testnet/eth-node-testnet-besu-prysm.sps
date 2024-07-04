name = "eth-node-besu-prysm-service-testnet"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: besu and prysm."
conflicts = ["eth-node-testnet"]
recommends = []
provides = ["eth-node-testnet"]
suggests = []
depends = ["eth-node-besu", "eth-node-prysm"]
add_files = []
add_manpages = []
long_doc = """eth-node-testnet
By installing this package,
it will automatically set up a besu and prysm client pair (consensus and execution client) for connecting
to the Ethereum testnet network.
"""
