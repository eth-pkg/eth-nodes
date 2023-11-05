name = "eth-node-besu"
architecture = "any"
summary = "Besu is an Apache 2.0 licensed, MainNet compatible, Ethereum client written in Java."
conflicts = []
recommends = []
provides = []
suggests = ["eth-node"]
add_files = ["build/install/besu /usr/share/eth-node-besu"]
add_links = ["/usr/share/eth-node-besu/besu/bin/besu /usr/bin/besu"]
add_manpages = []
long_doc = """ 
"""
