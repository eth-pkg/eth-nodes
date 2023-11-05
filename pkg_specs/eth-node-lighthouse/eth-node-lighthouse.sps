name = "eth-node-lighthouse"
architecture = "any"
summary = "Lighthouse binary"
conflicts = []
recommends = []
provides = ["eth-node-consensus-client"]
suggests = ["eth-node"]
add_files = ["build/bin/lighthouse /usr/share/eth-node-lighthouse/bin"]
add_links = ["/usr/share/eth-node-lighthouse/bin/lighthouse /usr/bin/lighthouse"]

add_manpages = []
long_doc = """ Lighthouse binary
"""
