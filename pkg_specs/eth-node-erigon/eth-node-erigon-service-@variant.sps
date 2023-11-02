name = "eth-node-erigon-service-@variant"
bin_package = "eth-node-erigon-cli"
binary = "/usr/share/erigon/erigon"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-erigon-config-{variant}", "eth-node-erigon-cli"]
provides = ["eth-node-execution-client-service"]
summary = "Service package for erigon"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""
