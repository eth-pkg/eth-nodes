name = "eth-node-geth-service-@variant"
bin_package = "eth-node-geth"
binary = "/usr/bin/geth"
# geth requires that the name of the network passed as parameter
conf_param = "--{variant} --config="
user = { group = true, create = { home = true } }
depends = ["eth-node-geth-config-{variant}", "eth-node-geth"]
provides = ["eth-node-execution-client-service"]
summary = "Service package for geth"
runtime_dir = { mode = "0755" }
# Copy the default generated config used by geth and name is as config.toml
# config packages will be patching this default config
add_files = ["build/config/{variant}.toml config.toml"]
