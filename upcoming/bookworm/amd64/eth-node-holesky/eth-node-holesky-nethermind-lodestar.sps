name = "eth-node-nethermind-lodestar-service-holesky"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: nethermind and lodestar."
conflicts = ["eth-node-holesky"]
recommends = []
provides = ["eth-node-holesky"]
suggests = []
depends = []
add_files = []
add_manpages = []
long_doc = """eth-node-holesky
By installing this package,
it will automatically set up a nethermind and lodestar client pair (consensus and execution client) for connecting
to the Ethereum holesky network.
"""
