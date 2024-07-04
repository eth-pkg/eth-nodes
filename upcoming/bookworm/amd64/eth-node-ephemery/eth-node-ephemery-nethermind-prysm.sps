name = "eth-node-nethermind-prysm-service-ephemery"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: nethermind and prysm."
conflicts = ["eth-node-ephemery"]
recommends = []
provides = ["eth-node-ephemery"]
suggests = []
depends = ["eth-node-nethermind", "eth-node-prysm"]
add_files = []
add_manpages = []
long_doc = """eth-node-ephemery
By installing this package,
it will automatically set up a nethermind and prysm client pair (consensus and execution client) for connecting
to the Ethereum ephemery network.
"""
