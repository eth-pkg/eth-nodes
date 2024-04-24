name = "eth-node-nimbus-eth2"
architecture = "any"
summary = "Nimbus Eth2 (Beacon Chain)"
conflicts = []
recommends = []
provides = ["eth-node-consensus-client"]
suggests = ["eth-node"]
add_files = [
    "build /usr/lib/eth-node-nimbus-eth2/lib",
    "scripts/run-beacon-node.sh /usr/lib/eth-node-nimbus-eth2/bin",
    "docker/dist/README.md.tpl /usr/lib/eth-node-nimbus-eth2/README"
]
add_links = ["/usr/lib/eth-node-nimbus-eth2/bin/run-beacon-node /usr/bin/run-beacon-node"]

add_manpages = []
long_doc = """
Nimbus-eth2 is an extremely efficient consensus layer (eth2) client implementation.
 While it's optimised for embedded systems and resource-restricted devices 
 -- including Raspberry Pis, its low resource usage also makes it an excellent choice 
 for any server or desktop (where it simply takes up fewer resources).
"""
