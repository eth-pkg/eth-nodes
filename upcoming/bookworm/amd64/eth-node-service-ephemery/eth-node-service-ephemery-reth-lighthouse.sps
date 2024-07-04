name = "eth-node-reth-lighthouse-service-ephemery"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: reth and lighthouse."
conflicts = ["eth-node-service-ephemery"]
recommends = []
provides = ["eth-node-service-ephemery"]
suggests = []
depends = []
add_files = []
add_manpages = []
long_doc = """eth-node-service-ephemery
By installing this package,
it will automatically set up a reth and lighthouse client pair (consensus and execution client) for connecting
to the Ethereum ephemery network.
"""
