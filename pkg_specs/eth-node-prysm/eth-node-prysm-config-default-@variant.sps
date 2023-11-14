name = "eth-node-prysm-config-default-@variant"
extends = "eth-node-prysm-service-@variant"
provides = ["eth-node-prysm-config-{variant}"]
replaces = ["eth-node-prysm-config-{variant}"]
conflicts = ["eth-node-prysm-config-{variant}"]
summary = "Required configuration options for prysm"
add_files = ["debian/postprocess.sh /etc/lib/eth-node-prysm-service-{variant}"]

[config."config.yaml"]
format="yaml"

[config."config.yaml".ivars."execution-endpoint"]
default = "http://localhost:8551"
summary = "Execution endpoint"
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

[config."config.yaml".ivars."jwt-secret"]
summary = "Path to jwt secret"
default = "/data/jwt/{variant}/jwt.hex"
type = "path"
file_type = "regular"
priority = "medium"

[config."config.yaml".ivars.datadir]
summary = "Data dir"
type = "path"
file_type = "dir"
default = "/data/{variant}"
priority = "medium"

[config."config.yaml".postprocess]
command = ["bash", "/etc/eth-node-prysm-service-{variant}/postprocess.sh", "{variant}"]

### TODO need to modify debcrafter as package directories broke this
# External config, defined in another package, the value will be pulled from that package
# name is the name in this package
#[config."config.yaml".evars."../eth-node-service/eth-node-service-@variant"."jwtsecret"]
#name="jwt-secret"

# External config, defined in another package, the value will be pulled from that package
#[config."config.yaml".evars."../eth-node-service/eth-node-service-@variant".datadir]
#name="datadir"


