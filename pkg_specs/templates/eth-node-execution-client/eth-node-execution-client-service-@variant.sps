name = "eth-node-execution-client-service-@variant"
bin_package = "execution-client"
binary = "/usr/share/execution-client/execution-client"
conf_param = "-conf="
user = { group = true }
depends = ["eth-node-execution-client-config-{variant}", "eth-node-execution-client-cli"]
provides = ["eth-node-execution-client-service"]
summary = "Service package for execution-client"
runtime_dir = { mode = "0755" }


[map_variants.insert_header]
mainnet = ""
