name = "eth-node-reth"
architecture = "any"
summary = "Modular, contributor-friendly and blazing-fast implementation of the Ethereum protocol"
conflicts = []
recommends = []
provides = ["eth-node-execution-client (= 1)"]
suggests = ["eth-node (= 1)"]
add_files = ["target/maxperf/reth /usr/lib/eth-node-reth/bin"]
add_links = ["/usr/lib/eth-node-reth/bin/reth /usr/bin/reth"]

add_manpages = []
long_doc = """
Reth (short for Rust Ethereum, pronunciation) is a new Ethereum full node implementation 
that is focused on being user-friendly, highly modular, as well as being fast and efficient. 
Reth is an Execution Layer (EL) and is compatible with all Ethereum Consensus Layer (CL) 
implementations that support the Engine API. It is originally built and driven forward by Paradigm, 
and is licensed under the Apache and MIT licenses.
"""
