name = "eth-node-lodestar-config-default-@variant"
extends = "eth-node-lodestar-service-@variant"
provides = ["eth-node-lodestar-config-{variant}"]
replaces = ["eth-node-lodestar-config-{variant}"]
conflicts = ["eth-node-lodestar-config-{variant}"]
summary = "Required configuration options for lodestar"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
