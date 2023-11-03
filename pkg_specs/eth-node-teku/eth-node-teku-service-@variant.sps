name = "eth-node-teku-service-@variant"
bin_package = "eth-node-teku"
binary = "/usr/share/eth-node-teku/bin/teku"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-teku-config-{variant}", "eth-node-teku"]
provides = ["eth-node-consensus-client-service"]
summary = "Service package for teku"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""

