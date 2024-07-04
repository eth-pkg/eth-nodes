name = "eth-node-erigon-nimbus-eth2-service-holesky"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: erigon and nimbus-eth2."
conflicts = ["eth-node-service-holesky"]
recommends = []
provides = ["eth-node-service-holesky"]
suggests = []
depends = []
add_files = []
add_manpages = []
long_doc = """eth-node-service-holesky
By installing this package,
it will automatically set up a erigon and nimbus-eth2 client pair (consensus and execution client) for connecting
to the Ethereum holesky network.
"""
