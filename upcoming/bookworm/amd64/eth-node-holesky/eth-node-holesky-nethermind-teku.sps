name = "eth-node-nethermind-teku-service-holesky"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: nethermind and teku."
conflicts = ["eth-node-holesky"]
recommends = []
provides = ["eth-node-holesky"]
suggests = []
depends = ["eth-node-nethermind", "eth-node-teku"]
add_files = []
add_manpages = []
long_doc = """eth-node-holesky
By installing this package,
it will automatically set up a nethermind and teku client pair (consensus and execution client) for connecting
to the Ethereum holesky network.
"""
