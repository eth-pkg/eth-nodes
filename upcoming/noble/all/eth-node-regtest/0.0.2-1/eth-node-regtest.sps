name = "eth-node-regtest"
architecture = "all"
summary = "TODO"
conflicts = []
recommends = []
provides = []
suggests = []
depends=["eth-node-regtest-config (>= 0.0.3)", "eth-node-regtest-config (<< 0.0.3)"]
add_files = []
add_links = []
add_manpages = []
long_doc = """eth-node-regtest
Package that install two random Ethereum consensus and execution client and
starts them running.
This package comes without validator. If you would like to have validator running
please install eth-node-regtest-with-validator instead.
"""
