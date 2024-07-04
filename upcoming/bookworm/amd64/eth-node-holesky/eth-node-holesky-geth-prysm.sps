name = "eth-node-geth-prysm-service-holesky"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: geth and prysm."
conflicts = ["eth-node-holesky"]
recommends = []
provides = ["eth-node-holesky"]
suggests = []
depends = ["eth-node-geth", "eth-node-prysm"]
add_files = []
add_manpages = []
long_doc = """eth-node-holesky
By installing this package,
it will automatically set up a geth and prysm client pair (consensus and execution client) for connecting
to the Ethereum holesky network.
"""
