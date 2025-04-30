name = "eth-node-lighthouse"
architecture = "any"
summary = "An open-source Ethereum consensus client, written in Rust and maintained by Sigma Prime."
conflicts = []
recommends = []
provides = ["eth-node-consensus-client (= 1)"]
suggests = ["eth-node (= 1)"]
add_files = ["target/maxperf/lighthouse /usr/lib/eth-node-lighthouse/bin"]
add_links = ["/usr/lib/eth-node-lighthouse/bin/lighthouse /usr/bin/lighthouse"]

add_manpages = []
long_doc = """
Lighthouse is an Ethereum consensus client that connects
to other Ethereum consensus clients to form a resilient 
and decentralized proof-of-stake blockchain.
"""
