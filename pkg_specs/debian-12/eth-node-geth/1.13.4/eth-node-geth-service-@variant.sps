name = "eth-node-geth-service-@variant"
bin_package = "eth-node-geth"
binary = "/usr/bin/geth"
conf_param = "--{variant} --config="
user = { group = true, create = { home = true } }
depends = ["eth-node-geth-config-{variant}", "eth-node-geth"]
provides = ["eth-node-execution-client-service"]
summary = "Service package for geth"
runtime_dir = { mode = "0755" }
add_files = ["build/config/{variant}.toml /etc/eth-node-geth-service-{variant}/examples/"]

[config."config.toml"]
format = "toml"

[config."config.toml".ivars.DataDir]

