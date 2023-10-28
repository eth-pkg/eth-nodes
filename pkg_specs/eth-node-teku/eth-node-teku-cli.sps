name = "eth-node-teku-cli"
architecture = "any"
summary = "Lighthouse binary"
conflicts = []
recommends = ["eth-node-teku-service-@variant"]
provides = ["eth-node-consensus-client"]
suggests = ["eth-node"]
add_files = []
add_manpages = []
long_doc = """ Lighthouse binary
"""
