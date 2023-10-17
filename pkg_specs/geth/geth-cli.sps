name = "eth-node-geth-cli"
architecture = "any"
summary = "Go ethereum binary"
conflicts = []
recommends = ["eth-node-geth-service-@variant"]
provides = ["eth-node-execution-client"]
suggests = ["eth-node"]
add_files = []
add_manpages = []
long_doc = """ Go-etheurum binary
"""
