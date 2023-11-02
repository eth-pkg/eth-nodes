name = "eth-node-lighthouse-service-@variant"
bin_package = "eth-node-lighthouse-cli"
binary = "/usr/share/lighthouse/lighthouse"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-lighthouse-config-{variant}", "eth-node-lighthouse-cli"]
provides = ["eth-node-consensus-client-service"]
summary = "Service package for lighthouse"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""

