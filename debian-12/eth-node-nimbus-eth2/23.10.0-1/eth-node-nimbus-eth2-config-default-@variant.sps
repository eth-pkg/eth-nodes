name = "eth-node-nimbus-eth2-config-default-@variant"
extends = "eth-node-nimbus-eth2-service-@variant"
provides = ["eth-node-nimbus-eth2-config-{variant}"]
replaces = ["eth-node-nimbus-eth2-config-{variant}"]
conflicts = ["eth-node-nimbus-eth2-config-{variant}"]
summary = "Required configuration options for nimbus-eth2"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
