name = "eth-node-regtest-config"
architecture = "any"
summary = "TODO"
conflicts = []
recommends = []
provides = [""]
suggests = []
depends=[]
add_files = [
    "debian/regtest /var/lib/eth-node-regtest",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-regtest",
]
add_links = []
add_manpages = []
long_doc = """eth-node-regtest-config
"""

[config."regtest.conf"]
format = "plain"
public = true 

[config."regtest.conf".ivars."BASE_CONFIG_NETWORK"]
type = "string"
default = "regtest"
priority = "low"
summary = "Network configuration, set to regtest"

[config."regtest.conf".ivars."BASE_CONFIG_ENGINE_API_PORT"]
type = "string"
default = "8551"
priority = "low"
summary = "Port for Execution Layer (EL) and Consensus Layer (CL) communication"

[config."regtest.conf".ivars."BASE_CONFIG_ENGINE_SCHEME"]
type = "string"
default = "http"
priority = "low"
summary = "Scheme for EL and CL communication"

[config."regtest.conf".ivars."BASE_CONFIG_ENGINE_HOST"]
type = "string"
default = "localhost"
priority = "low"
summary = "Host for EL and CL communication"

[config."regtest.conf".ivars."BASE_CONFIG_ENGINE_IP"]
type = "string"
default = "127.0.0.1"
priority = "low"
summary = "IP address for EL and CL communication"

[config."regtest.conf".ivars."BASE_CONFIG_DATA_DIR"]
type = "string"
default = "/var/lib/eth-node-regtest"
priority = "low"
summary = "Data directory where CL and EL directories are placed"

[config."regtest.conf".hvars."BASE_CONFIG_ENDPOINT_URL"]
type = "string"
template = "{/BASE_CONFIG_ENGINE_SCHEME}://{/BASE_CONFIG_ENGINE_HOST}:{/BASE_CONFIG_ENGINE_API_PORT}"
store = true
# summary = "Endpoint URL for EL and CL communication"

[config."regtest.conf".ivars."BASE_CONFIG_SECRETS_FILE"]
type = "path"
file_type = "regular"
default = "/etc/eth-node-regtest/jwt.hex"
priority = "medium"
summary = "JWT secrets file shared by CL and EL"

[config."regtest.conf".ivars."BASE_CONFIG_CUSTOM_NETWORK_regtest_DIR"]
type = "string"
default = "/var/lib/eth-node-regtest/regtest/genesis"
priority = "low"
summary = "Directory for custom network regtest configuration"

[config."regtest.conf".hvars."BASE_CONFIG_CUSTOM_NETWORK_GENESIS_FILE"]
type = "string"
template = "{/BASE_CONFIG_CUSTOM_NETWORK_regtest_DIR}/genesis.json"
# summary = "Custom network genesis file location"
store = true

[config."regtest.conf".hvars."BASE_CONFIG_CUSTOM_NETWORK_GENESIS_STATE"]
type = "string"
template = "{/BASE_CONFIG_CUSTOM_NETWORK_regtest_DIR}/genesis.ssz"
# summary = "Custom network genesis state location"
store = true 

[config."regtest.conf".hvars."BASE_CONFIG_CUSTOM_NETWORK_CHAINCONFIG"]
type = "string"
template = "{/BASE_CONFIG_CUSTOM_NETWORK_regtest_DIR}/config.yaml"
# summary = "Custom network chain configuration file"
store = true 

[config."regtest.conf".ivars."BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENR"]
type = "string"
default = ""
priority = "low"
summary = "Bootnodes ENR for custom network"

[config."regtest.conf".ivars."BASE_CONFIG_CUSTOM_NETWORK_BOOTNODES_ENODE"]
type = "string"
default = ""
priority = "low"
summary = "Bootnodes ENODE for custom network"

[config."regtest.conf".ivars."BASE_CONFIG_CUSTOM_NETWORK_NETWORK_ID"]
type = "string"
default = ""
priority = "low"
summary = "Network ID for custom network"

[config."regtest.conf".ivars."BASE_CONFIG_EL_METRICS_PORT"]
type = "string"
default = ""
priority = "low"
summary = "Execution Layer (EL) metrics port"

[config."regtest.conf".ivars."BASE_CONFIG_EL_WS_PORT"]
type = "string"
default = ""
priority = "low"
summary = "Execution Layer (EL) WebSocket port"

[config."regtest.conf".ivars."BASE_CONFIG_EL_RPC_PORT"]
type = "string"
default = "8545"
priority = "low"
summary = "Execution Layer (EL) RPC port"

[config."regtest.conf".ivars."BASE_CONFIG_EL_P2P_PORT"]
type = "string"
default = ""
priority = "low"
summary = "Execution Layer (EL) P2P port"

[config."regtest.conf".ivars."BASE_CONFIG_CL_BEACON_API_URL"]
type = "string"
default = ""
priority = "low"
summary = "Consensus Layer (CL) Beacon API URL"

[config."regtest.conf".ivars."BASE_CONFIG_CL_CHECKPPOINT_SYNC_URL"]
type = "string"
default = ""
priority = "low"
summary = "Consensus Layer (CL) checkpoint sync URL"

[config."regtest.conf".ivars."BASE_CONFIG_CL_METRICS_PORT"]
type = "string"
default = ""
priority = "low"
summary = "Consensus Layer (CL) metrics port"

[config."regtest.conf".ivars."BASE_CONFIG_CL_RPC_PORT"]
type = "string"
default = "5052"
priority = "low"
summary = "Consensus Layer (CL) RPC port"

[config."regtest.conf".ivars."BASE_CONFIG_CL_P2P_PORT"]
type = "string"
default = ""
priority = "low"
summary = "Consensus Layer (CL) P2P port"

[config."regtest.conf".ivars."BASE_CONFIG_VALIDATOR_DATADIR"]
type = "string"
default = "/var/lib/eth-node-regtest/validator"
priority = "low"
summary = "Validator data directory"

[config."regtest.conf".hvars."BASE_CONFIG_VALIDATOR_BEACON_RPC_PROVIDER"]
type = "string"
template = "{/BASE_CONFIG_ENGINE_HOST}:4000"
# summary = "Validator beacon RPC provider"
store = true 

[config."regtest.conf".ivars."BASE_CONFIG_VALIDATOR_NUM_VALIDATORS"]
type = "string"
default = "64"
priority = "low"
summary = "Number of validators"

[config."regtest.conf".ivars."BASE_CONFIG_VALIDATOR_SHARED_FEE_RECEIPENT_ADDRESS"]
type = "string"
default = "0x123463a4b065722e99115d6c222f267d9cabb524"
priority = "low"
summary = "Shared fee recipient address for validator"

# going to fill the jwt file with random hex
[config."regtest.conf".postprocess]
command = ["bash", "/usr/lib/eth-node-regtest/postprocess.sh"]