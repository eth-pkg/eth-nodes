name = "eth-node-besu-lighthouse-service-ephemery"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: besu and lighthouse."
conflicts = ["eth-node-ephemery"]
recommends = []
provides = ["eth-node-ephemery"]
suggests = []
depends = ["eth-node-besu", "eth-node-lighthouse"]
add_files = []
add_manpages = []
long_doc = """eth-node-ephemery
By installing this package,
it will automatically set up a besu and lighthouse client pair (consensus and execution client) for connecting
to the Ethereum ephemery network.
"""
