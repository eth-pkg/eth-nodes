name = "eth-node-prysm-config-default-@variant"
extends = "eth-node-prysm-service-@variant"
provides = ["eth-node-prysm-config-{variant}"]
replaces = ["eth-node-prysm-config-{variant}"]
conflicts = ["eth-node-prysm-config-{variant}"]
summary = "Required configuration options for prysm"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
