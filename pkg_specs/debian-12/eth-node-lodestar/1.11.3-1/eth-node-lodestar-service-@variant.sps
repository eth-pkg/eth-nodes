name = "eth-node-lodestar-service-@variant"
bin_package = "eth-node-lodestar"
binary = "/usr/bin/lodestar"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-lodestar-config-{variant}", "eth-node-lodestar"]
provides = ["eth-node-consensus-client-service"]
summary = "Service package for lodestar"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""

