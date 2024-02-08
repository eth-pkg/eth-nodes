name = "eth-node-lighthouse-config-default-@variant"
extends = "eth-node-lighthouse-service-@variant"
provides = ["eth-node-lighthouse-config-{variant}"]
replaces = ["eth-node-lighthouse-config-{variant}"]
conflicts = ["eth-node-lighthouse-config-{variant}"]
summary = "Required configuration options for lighthouse"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
