name = "eth-node-nimbus-eth2"
architecture = "any"
summary = "Nimbus Eth2 (Beacon Chain)"
conflicts = []
recommends = []
provides = ["eth-node-consensus-client (= 1)"]
suggests = ["eth-node (= 1)"]
add_files = [
    "build/nimbus_beacon_node /usr/lib/eth-node-nimbus-eth2/bin",
    "build/nimbus_validator_client /usr/lib/eth-node-nimbus-eth2/bin",
    "build/deposit_contract /usr/lib/eth-node-nimbus-eth2/bin",
    "build/nimbus_signing_node /usr/lib/eth-node-nimbus-eth2/bin",
    "build/nimbus_light_client /usr/lib/eth-node-nimbus-eth2/bin",
    "docker/dist/README.md.tpl /usr/lib/eth-node-nimbus-eth2/README"
]
add_links = [
    "/usr/lib/eth-node-nimbus-eth2/build/nimbus_beacon_node /usr/bin/nimbus_beacon_node",
]

add_manpages = []
long_doc = """
Nimbus-eth2 is an extremely efficient consensus layer (eth2) client implementation.
 While it's optimised for embedded systems and resource-restricted devices 
 -- including Raspberry Pis, its low resource usage also makes it an excellent choice 
 for any server or desktop (where it simply takes up fewer resources).
"""
