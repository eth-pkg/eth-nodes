name = "eth-node-lodestar-service-@variant"
bin_package = "lodestar"
binary = "/usr/share/lodestar/lodestar"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-lodestar-config-{variant}", "eth-node-lodestar-cli"]
provides = ["eth-node-consensus-client-service"]
summary = "Service package for lodestar"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""

