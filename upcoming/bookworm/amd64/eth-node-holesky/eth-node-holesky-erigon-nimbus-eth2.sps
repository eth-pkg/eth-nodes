name = "eth-node-erigon-nimbus-eth2-service-holesky"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: erigon and nimbus-eth2."
conflicts = ["eth-node-holesky"]
recommends = []
provides = ["eth-node-holesky"]
suggests = []
depends = ["eth-node-erigon", "eth-node-nimbus-eth2"]
add_files = []
add_manpages = []
long_doc = """eth-node-holesky
By installing this package,
it will automatically set up a erigon and nimbus-eth2 client pair (consensus and execution client) for connecting
to the Ethereum holesky network.
"""
