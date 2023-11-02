name = "eth-node-teku-service-@variant"
bin_package = "eth-node-teku-cli"
binary = "/usr/share/teku/teku"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-teku-config-{variant}", "eth-node-teku-cli"]
provides = ["eth-node-consensus-client-service"]
summary = "Service package for teku"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""

