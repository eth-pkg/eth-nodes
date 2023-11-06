name = "eth-node-geth-config-default-@variant"
extends = "eth-node-geth-service-@variant"
provides = ["eth-node-geth-config-{variant}"]
replaces = ["eth-node-geth-config-{variant}"]
conflicts = ["eth-node-geth-config-{variant}"]
summary = "Required configuration options for the geth-service"
