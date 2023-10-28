name = "eth-node-besu-service-@variant"
bin_package = "besu"
binary = "/usr/share/besu/besu"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-besu-config-{variant}", "eth-node-besu-cli"]
provides = ["eth-node-execution-client-service"]
summary = "Service package for besu"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""
