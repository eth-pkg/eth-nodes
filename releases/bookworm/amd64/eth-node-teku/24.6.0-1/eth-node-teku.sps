name = "eth-node-teku"
architecture = "any"
summary = "Teku is a Java implementation of the Ethereum 2.0 Beacon Chain."
conflicts = []
recommends = []
provides = ["eth-node-consensus-client (= 1)"]
suggests = ["eth-node (= 1)"]
add_files = ["/build/install/teku /usr/lib/eth-node-teku"]
add_links = ["/usr/lib/eth-node-teku/teku/bin/teku /usr/bin/teku"]
add_manpages = []
long_doc = """
Teku is an open source Ethereum consensus client (previously called an Ethereum 2.0 client) written in Java.
Teku contains a full beacon node implementation and a validator client for participating in proof of stake consensus.
What can you do with Teku?

Teku supports the following features:

    Running the beacon node synchronization and consensus.
    Proposing and attesting to blocks.
    Enterprise-focused metrics using Prometheus.
    A REST API for managing consensus layer node operations.
    External key management for managing validator signing keys.
"""
