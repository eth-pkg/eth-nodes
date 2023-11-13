name = "eth-node-prysm-service-@variant"
bin_package = "eth-node-prysm"
binary = "/usr/bin/prysm-beacon-chain"
conf_param = "--{variant} --config-file="
user = { group = true, create = { home = true} }
depends = ["eth-node-prysm-config-{variant}", "eth-node-prysm"]
conflicts = ["eth-node-execution-client-service-{variant}"]
provides = ["eth-node-execution-client-service-{variant}"]

summary = "Service package for prysm"

[extra_groups."eth-node-{variant}"]
create=false

[config."config.yaml"]
format="yaml"

[config."config.yaml".ivars.datadir]
default = "/data/{variant}"
summary = "Data dir"
type = "string"
priority = "medium"

[config."config.yaml".ivars."execution-endpoint"]
default = "http://localhost:8551"
summary = "Execution endpoint"
type = "string"
priority = "medium"

[config."config.yaml".ivars."jwt-secret"]
default = "/data/jwt/{variant}/jwt.hex"
summary = "Path to JWT file"
type = "string"
priority = "medium"

[config."config.yaml".ivars."genesis-state"]
default = "genesis.ssz"
summary = "Genesis state"
type = "string"
priority = "medium"

[config."config.yaml".ivars."checkpoint-sync-url"]
default = "https://sepolia.beaconstate.info"
summary = "Checkpoint sync url"
type = "string"
priority = "medium"

[config."config.yaml".ivars."genesis-beacon-api-url"]
default = "https://sepolia.beaconstate.info"
summary = "Genesis beacon API URL"
type = "string"
priority = "medium"

