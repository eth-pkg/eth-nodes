name = "eth-node-teku-config-default-@variant"
extends = "eth-node-teku-service-@variant"
provides = ["eth-node-teku-config-{variant}"]
replaces = ["eth-node-teku-config-{variant}"]
conflicts = ["eth-node-teku-config-{variant}"]
summary = "Required configuration options for teku"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
