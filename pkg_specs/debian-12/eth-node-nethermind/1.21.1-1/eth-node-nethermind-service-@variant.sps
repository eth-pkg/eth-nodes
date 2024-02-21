name = "eth-node-nethermind-service-@variant"
bin_package = "eth-node-nethermind"
binary = "/usr/bin/nethermind"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-nethermind-config-{variant}", "eth-node-nethermind"]
provides = ["eth-node-execution-client-service"]
summary = "Service package for nethermind"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""
