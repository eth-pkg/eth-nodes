name = "eth-node-nimbus-eth2-service-@variant"
bin_package = "eth-node-nimbus-eth2-cli"
binary = "/usr/share/nimbus-eth2/nimbus-eth2"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-nimbus-eth2-config-{variant}", "eth-node-nimbus-eth2-cli"]
provides = ["eth-node-consensus-client-service"]
summary = "Service package for nimbus-eth2"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""

