name = "eth-node-erigon-lodestar-service-ephemery"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: erigon and lodestar."
conflicts = ["eth-node-ephemery"]
recommends = []
provides = ["eth-node-ephemery"]
suggests = []
depends = ["eth-node-erigon", "eth-node-lodestar"]
add_files = []
add_manpages = []
long_doc = """eth-node-ephemery
By installing this package,
it will automatically set up a erigon and lodestar client pair (consensus and execution client) for connecting
to the Ethereum ephemery network.
"""
