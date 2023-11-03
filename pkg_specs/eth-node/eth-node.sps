name = "eth-node"
architecture = "all"
summary = "Simplified Ethereum node installation"
conflicts = []
recommends = []
provides = []
suggests = []
depends = ["eth-node-execution-client", "eth-node-consensus-client"]
add_files = []
add_manpages = []
long_doc = """This virtual package simplifies the installation of essential
dependencies required for running an Ethereum node. By installing this package, you
can easily set up and configure any available Ethereum execution client or consensus
client. It helps in the process of preparing your system for Ethereum network
participation and provides a convenient starting point for node deployment and
management.

Whether you intend to run an Ethereum node for development, testing, or production
purposes, the "eth-node" package ensures that the necessary dependencies are in
place, simplifying the setup process and improving your overall experience with
Ethereum blockchain technologies.
"""

