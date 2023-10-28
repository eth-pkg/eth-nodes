name = "eth-node-nimbus-eth2-cli"
architecture = "any"
summary = "Lighthouse binary"
conflicts = []
recommends = ["eth-node-nimbus-eth2-service-@variant"]
provides = ["eth-node-consensus-client"]
suggests = ["eth-node"]
add_files = []
add_manpages = []
long_doc = """ Lighthouse binary
"""
