name = "eth-node-execution-client-config-default-@variant"
extends = "eth-node-execution-client-service-@variant"
provides = ["eth-node-execution-client-config-{variant}"]
replaces = ["eth-node-execution-client-config-{variant}"]
conflicts = ["eth-node-execution-client-config-{variant}"]
summary = "Required configuration options for the execution-client-service"

[config."chain_mode"]
format = "plain"

[config."chain_mode".hvars.prune]
type = "uint"
constant = "0"

[config."chain_mode".hvars.txindex]
type = "uint"
constant = "0"
