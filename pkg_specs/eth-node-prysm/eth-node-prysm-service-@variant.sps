name = "eth-node-prysm-service-@variant"
bin_package = "eth-node-prysm-cli"
binary = "/usr/share/prysm/prysm"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-prysm-config-{variant}", "eth-node-prysm-cli"]
provides = ["eth-node-consensus-client-service"]
summary = "Service package for prysm"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""

