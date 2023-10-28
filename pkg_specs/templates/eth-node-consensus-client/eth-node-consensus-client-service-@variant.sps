name = "eth-node-consensus-client-service-@variant"
bin_package = "consensus-client"
binary = "/usr/share/consensus-client/consensus-client"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-consensus-client-config-{variant}", "eth-node-consensus-client-cli"]
provides = ["eth-node-consensus-client-service"]
summary = "Service package for consensus-client"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""

