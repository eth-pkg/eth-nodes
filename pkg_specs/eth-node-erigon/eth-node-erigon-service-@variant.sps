name = "eth-node-erigon-service-@variant"
bin_package = "eth-node-erigon"
binary = "/usr/bin/erigon"
conf_param = "-config="
user = { group = true, create = { home = true } }
depends = ["eth-node-erigon-config-{variant}", "eth-node-erigon"]
provides = ["eth-node-execution-client-service"]
summary = "Service package for erigon"
runtime_dir = { mode = "0755" }

[config."config.toml"]
format = "toml"

[config."config.toml".ivars.datadir]
summary = "Data dir"
type = "path"
file_type = "dir"
default = "/data/{variant}"
priority = "medium"

[config."config.toml".ivars.chain]
summary = "Network_id"
type = "string"
default = "{variant}"
priority = "medium"

[config."config.toml".ivars.port]
summary = "Port"
type = "uint"
default = "30303"
priority = "medium"

[config."config.toml".ivars."http.port"]
summary = "Http port"
type = "uint"
default = "8545"
priority = "medium"

[config."config.toml".ivars."authrpc.port"]
summary = "Authrpc.port"
type = "uint"
default = "8551"
priority = "medium"

[config."config.toml".ivars."torrent.port"]
summary = "torrent.port"
type = "uint"
default = "42069"
priority = "medium"

[config."config.toml".ivars."private.api.addr"]
summary = "private.api.addr"
type = "string"
default = "127.0.0.1:9090"
priority = "medium"

[config."config.toml".ivars.http]
summary = "http"
type = "bool"
default = "true"
priority = "medium"

[config."config.toml".ivars.ws]
summary = "ws"
type = "bool"
default = "true"
priority = "medium"

[config."config.toml".ivars."http.api"]
type = "string"
summary = "http.api"
#default = ["eth", "debug", "net", "trace", "web3", "erigon"]
# use comma seperated list, debcrafter doesn't support arrays yet
default = "eth, debug, net, trace, web3, erigon"
priority = "medium"

# http.api, http.port, authrpc.port, torrent.port, private.api.addr is not quoted properly
# this script fixes the quoting upon save
[config."config.toml".postprocess]
command = ["bash", "/usr/lib/eth-node-erigon/bin/fix-service-config.sh"]
