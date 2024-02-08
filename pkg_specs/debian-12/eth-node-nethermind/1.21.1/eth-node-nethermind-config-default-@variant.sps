name = "eth-node-nethermind-config-default-@variant"
extends = "eth-node-nethermind-service-@variant"
provides = ["eth-node-nethermind-config-{variant}"]
replaces = ["eth-node-nethermind-config-{variant}"]
conflicts = ["eth-node-nethermind-config-{variant}"]
summary = "Required configuration options for the nethermind-service"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
