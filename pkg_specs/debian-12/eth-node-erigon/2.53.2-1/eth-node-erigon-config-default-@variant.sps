name = "eth-node-erigon-config-default-@variant"
extends = "eth-node-erigon-service-@variant"
provides = ["eth-node-erigon-config-{variant}"]
replaces = ["eth-node-erigon-config-{variant}"]
conflicts = ["eth-node-erigon-config-{variant}"]
summary = "Required configuration options for the erigon-service"
add_files = ["debian/postprocess.sh /usr/lib/eth-node-erigon-service-{variant}"]

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


# http.api, http.port, authrpc.port, torrent.port, private.api.addr is not quoted properly
# this script fixes the quoting upon save
[config."config.toml".postprocess]
command = ["bash", "/usr/lib/eth-node-erigon-service-{variant}/postprocess.sh", "{variant}"]
