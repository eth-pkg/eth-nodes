name = "eth-node-consensus-client-config-default-@variant"
extends = "eth-node-consensus-client-service-@variant"
provides = ["eth-node-consensus-client-config-{variant}"]
replaces = ["eth-node-consensus-client-config-{variant}"]
conflicts = ["eth-node-consensus-client-config-{variant}"]
summary = "Required configuration options for consensus-client"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
