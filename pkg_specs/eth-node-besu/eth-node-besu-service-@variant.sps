name = "eth-node-besu-service-@variant"
bin_package = "eth-node-besu"
binary = "/usr/share/besu/besu"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-besu-config-{variant}", "eth-node-besu"]
provides = ["eth-node-execution-client"]
summary = "Service package for besu"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""
