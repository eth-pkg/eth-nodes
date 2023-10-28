name = "eth-node-besu-config-default-@variant"
extends = "eth-node-besu-service-@variant"
provides = ["eth-node-besu-config-{variant}"]
replaces = ["eth-node-besu-config-{variant}"]
conflicts = ["eth-node-besu-config-{variant}"]
summary = "Required configuration options for the besu-service"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
