name = "eth-node-besu-nimbus-eth2-service-ephemery"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: besu and nimbus-eth2."
conflicts = ["eth-node-ephemery"]
recommends = []
provides = ["eth-node-ephemery"]
suggests = []
depends = ["eth-node-besu", "eth-node-nimbus-eth2"]
add_files = []
add_manpages = []
long_doc = """eth-node-ephemery
By installing this package,
it will automatically set up a besu and nimbus-eth2 client pair (consensus and execution client) for connecting
to the Ethereum ephemery network.
"""
