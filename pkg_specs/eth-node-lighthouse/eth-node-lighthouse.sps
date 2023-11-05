name = "eth-node-lighthouse"
architecture = "any"
summary = "Lighthouse binary"
conflicts = []
recommends = []
provides = ["eth-node-consensus-client"]
suggests = ["eth-node"]
add_files = ["lighthouse /usr/share/eth-node-lighthouse"]
add_links = ["/usr/share/eth-node-lighthouse/lighthouse /usr/bin/lighthouse"]

add_manpages = []
long_doc = """ Lighthouse binary
"""
