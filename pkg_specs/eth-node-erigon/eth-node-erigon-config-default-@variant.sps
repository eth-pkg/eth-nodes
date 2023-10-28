name = "eth-node-erigon-config-default-@variant"
extends = "eth-node-erigon-service-@variant"
provides = ["eth-node-erigon-config-{variant}"]
replaces = ["eth-node-erigon-config-{variant}"]
conflicts = ["eth-node-erigon-config-{variant}"]
summary = "Required configuration options for the erigon-service"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
