name = "eth-node-nimbus-eth2-regtest"
bin_package = "eth-node-nimbus-eth2"
# TODO not sure why nimbus_beacon_node fails to be included in the PATH on github CI
binary = "/usr/lib/eth-node-nimbus-eth2/bin/nimbus_beacon_node"
## TODO remove http.api from here
conf_param = "--non-interactive --web3-url='http://localhost:8551' --config-file="
user = { name = "eth-node-nimbus-eth2-regtest", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
# Service Fields
after = "multi-user.target"
service_type = "simple"
extra_service_config = """
# no need to specify, these come from debcrafter
# User=eth-node-nimbus-eth2-regtest
# NoNewPrivileges=true
# ProtectHome=true
# PrivateTmp=true
# PrivateDevices=true

# additional flags not specified by debcrafter
CapabilityBoundingSet=
IPAddressDeny=none
LockPersonality=true
PrivateIPC=true
PrivateUsers=true
ProtectClock=true
ProtectControlGroups=true
ProtectHostname=true
ProtectKernelLogs=true
ProtectKernelModules=true
ProtectKernelTunables=true
ProtectProc=invisible
ReadWritePaths=/var/lib/eth-node-regtest/nimbus-eth2
ReadOnlyPaths=/var/lib/eth-node-regtest
RemoveIPC=true
RestrictAddressFamilies=AF_INET AF_INET6 AF_UNIX AF_NETLINK 

RestrictNamespaces=true
RestrictRealtime=true
RestrictSUIDSGID=true
SystemCallArchitectures=native
SystemCallFilter=@system-service
UMask=0077
WorkingDirectory=/var/lib/eth-node-regtest/nimbus-eth2
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = [
    # "debian/scripts/run-nimbus-eth2-service.sh /usr/lib/eth-node-nimbus-eth2-regtest/", 
    # "debian/scripts/run-nimbus-eth2.sh /usr/lib/eth-node-nimbus-eth2-regtest/bin/",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-nimbus-eth2-regtest",
    "debian/tmp/eth-node-nimbus-eth2-regtest.service /lib/systemd/system/",
]
provides = ["eth-node-regtest-cl-service"]
conflicts = ["eth-node-regtest-cl-service"]
depends=["eth-node-regtest-config"]
summary = "service file for eth-node-nimbus-eth2 for network: regtest"

[config."nimbus-eth2-regtest.toml".postprocess]
command = ["bash", "/usr/lib/eth-node-nimbus-eth2-regtest/postprocess.sh"]

[config."nimbus-eth2-regtest.toml"]
format = "toml"


[config."nimbus-eth2-regtest.toml".hvars."DATA_DIR"]
type = "string"
constant = "/var/lib/eth-node-regtest"
store = false

[config."nimbus-eth2-regtest.toml".hvars."JWT_FILE"]
type = "path"
file_type = "regular"
constant = "/etc/eth-node-regtest/jwt.hex"
store = false

[config."nimbus-eth2-regtest.toml".hvars."NETWORK_ID"]
type = "string"
constant = "1337"
store = false

[config."nimbus-eth2-regtest.toml".hvars."TESTNET_DIR"]
type = "string"
constant = "/var/lib/eth-node-regtest/regtest/genesis"
store = false

[config."nimbus-eth2-regtest.toml".hvars."EL_RPC_PORT"]
type = "string"
constant = "8545"
store = false

[config."nimbus-eth2-regtest.toml".hvars."ENGINE_IP"]
type = "string"
constant = "127.0.0.1"
store = false

[config."nimbus-eth2-regtest.toml".hvars."LOG_DIR"]
type = "string"
constant = "/var/logs/eth-node-regtest"
# priority = "low"
ignore_empty = true
# summary = "Base dir for logging"
store = false


[config."nimbus-eth2-regtest.toml".hvars."ENGINE_API_PORT"]
type = "string"
constant = "8551"
store = false
# priority = "low"
# summary = "Port for Execution Layer (EL) and Consensus Layer (CL) communication"

[config."nimbus-eth2-regtest.toml".hvars."ENGINE_SCHEME"]
type = "string"
constant = "http"
store = false
# priority = "low"
# summary = "Scheme for EL and CL communication"

[config."nimbus-eth2-regtest.toml".hvars."ENGINE_HOST"]
type = "string"
constant = "localhost"
store = false
# priority = "low"
# summary = "Host for EL and CL communication"


[config."nimbus-eth2-regtest.toml".hvars."ENDPOINT_URL"]
type = "string"
template = "{/ENGINE_SCHEME}://{/ENGINE_HOST}:{/ENGINE_API_PORT}"
# priority = "low"
ignore_empty = true
# summary = "Base dir for logging"
store = false


[config."nimbus-eth2-regtest.toml".hvars."CL_RPC_PORT"]
type = "string"
constant = "5052"
# priority = "low"
ignore_empty = true
# summary = "Base dir for logging"
store = false 
# [config."nimbus-eth2-regtest.toml".ivars."non_interactive"]
# type = "string"
# default = "true"
# priority = "low"
# ignore_empty = true
# summary = "Do not display interactive prompts. Quit on missing configuration."

[config."nimbus-eth2-regtest.toml".hvars."network"]
type = "string"
template = "{/TESTNET_DIR}"
# priority = "low"
# ignore_empty = true
# summary = "The Eth2 network to join [=mainnet]."

[config."nimbus-eth2-regtest.toml".hvars."data-dir"]
type = "string"
template = "{/DATA_DIR}/nimbus-eth2"
# priority = "low"
# ignore_empty = true
# summary = "The directory where nimbus will store all blockchain data."

### TODO array support 
# [config."nimbus-eth2-regtest.toml".hvars."web3-url"]
# type = "string"
# template = "{/ENDPOINT_URL}"
# # priority = "low"
# # ignore_empty = true
# # summary = "One or more execution layer Engine API URLs."

[config."nimbus-eth2-regtest.toml".hvars."jwt-secret"]
type = "string"
template = "{/JWT_FILE}"
# priority = "low"
# ignore_empty = true
# summary = "A file containing the hex-encoded 256 bit secret key to be used for verifying/generating JWT tokens."

[config."nimbus-eth2-regtest.toml".ivars."nat"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Specify method to use for determining public address. Must be one of: any, none, upnp, pmp, extip:<IP> [=any]."

[config."nimbus-eth2-regtest.toml".ivars."enr-auto-update"]
type = "bool"
default = "false"
priority = "low"
ignore_empty = true
summary = "Discovery can automatically update its ENR with the IP address and UDP port as seen by other nodes it communicates with. This option allows enabling/disabling this functionality [=false]."

[config."nimbus-eth2-regtest.toml".ivars."doppelganger-detection"]
type = "bool"
default = "false"
priority = "low"
ignore_empty = true
summary = "If enabled, the beacon node will wait for 2 epochs to detect a doppelganger before sending an attestation. Helps avoid slashing [=true]."

[config."nimbus-eth2-regtest.toml".ivars."subscribe-all-subnets"]
type = "bool"
default = "true"
priority = "low"
ignore_empty = true
summary = "Subscribe to all subnet topics when gossiping [=false]."

[config."nimbus-eth2-regtest.toml".ivars."rest"]
type = "bool"
default = "true"
priority = "low"
ignore_empty = true
summary = "Enable the REST server [=false]."

[config."nimbus-eth2-regtest.toml".hvars."rest-port"]
type = "uint"
template = "{/CL_RPC_PORT}"
# priority = "low"
# ignore_empty = true
# summary = "Port for the REST server [=5052]."

[config."nimbus-eth2-regtest.toml".ivars."rest-address"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening address of the REST server [=127.0.0.1]."

[config."nimbus-eth2-regtest.toml".ivars."rest-allow-origin"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Limit the access to the REST API to a particular hostname (for CORS-enabled clients such as browsers)."

[config."nimbus-eth2-regtest.toml".ivars."in-process-validators"]
type = "bool"
default = "false"
priority = "low"
ignore_empty = true
summary = "Disable the push model and load the validators in the beacon node itself [=true]."

[config."nimbus-eth2-regtest.toml".hvars."log-file"]
type = "string"
template = "{/LOG_DIR}/nimbus-eth2/nimbus-eth2.log"
# priority = "low"
# ignore_empty = true
# summary = "Specifies a path for the written JSON log file (deprecated)."

#############################################################################################
#############################################################################################
################ All Default options, commented out the used one ############################
####### OPTIONS below are all set to default and provided to be used with debconf ###########
#############################################################################################
#############################################################################################

[config."nimbus-eth2-regtest.toml".ivars."config_file"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Loads the configuration from a TOML file."

[config."nimbus-eth2-regtest.toml".ivars."log_level"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Sets the log level for process and topics (e.g. 'DEBUG; TRACE:discv5,libp2p; REQUIRED:none; DISABLED:none') [=INFO]."

# [config."nimbus-eth2-regtest.toml".ivars."log_file"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Specifies a path for the written JSON log file (deprecated)."

# [config."nimbus-eth2-regtest.toml".ivars."network"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "The Eth2 network to join [=mainnet]."

# [config."nimbus-eth2-regtest.toml".ivars."data_dir"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "The directory where nimbus will store all blockchain data."

[config."nimbus-eth2-regtest.toml".ivars."validators_dir"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "A directory containing validator keystores."

[config."nimbus-eth2-regtest.toml".ivars."verifying_web3_signer_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Remote Web3Signer URL that will be used as a source of validators."

[config."nimbus-eth2-regtest.toml".ivars."proven_block_property"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The field path of a block property that will be sent for verification to the verifying Web3Signer (for example '.execution_payload.fee_recipient')."

[config."nimbus-eth2-regtest.toml".ivars."web3_signer_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Remote Web3Signer URL that will be used as a source of validators."

[config."nimbus-eth2-regtest.toml".ivars."web3_signer_update_interval"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of seconds between validator list updates [=3600]."

[config."nimbus-eth2-regtest.toml".ivars."secrets_dir"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "A directory containing validator keystore passwords."

[config."nimbus-eth2-regtest.toml".ivars."wallets_dir"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "A directory containing wallet files."

# [config."nimbus-eth2-regtest.toml".ivars."web3_url"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "One or more execution layer Engine API URLs."

[config."nimbus-eth2-regtest.toml".ivars."el"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "One or more execution layer Engine API URLs."

[config."nimbus-eth2-regtest.toml".ivars."no_el"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Don't use an EL. The node will remain optimistically synced and won't be able to perform validator duties [=false]."

# [config."nimbus-eth2-regtest.toml".ivars."non_interactive"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Do not display interactive prompts. Quit on missing configuration."

[config."nimbus-eth2-regtest.toml".ivars."netkey_file"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Source of network (secp256k1) private key file (random|<path>) [=random]."

[config."nimbus-eth2-regtest.toml".ivars."insecure_netkey_password"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Use pre-generated INSECURE password for network private key file [=false]."

[config."nimbus-eth2-regtest.toml".ivars."agent_string"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Node agent string which is used as identifier in network [=nimbus]."

# [config."nimbus-eth2-regtest.toml".ivars."subscribe_all_subnets"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Subscribe to all subnet topics when gossiping [=false]."

[config."nimbus-eth2-regtest.toml".ivars."num_threads"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Number of worker threads ('0' = use as many threads as there are CPU cores available) [=0]."

# [config."nimbus-eth2-regtest.toml".ivars."jwt_secret"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "A file containing the hex-encoded 256 bit secret key to be used for verifying/generating JWT tokens."

[config."nimbus-eth2-regtest.toml".ivars."bootstrap_node"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Specifies one or more bootstrap nodes to use when connecting to the network."

[config."nimbus-eth2-regtest.toml".ivars."bootstrap_file"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Specifies a line-delimited file of bootstrap Ethereum network addresses."

[config."nimbus-eth2-regtest.toml".ivars."listen_address"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening address for the Ethereum LibP2P and Discovery v5 traffic [=*]."


[config."nimbus-eth2-regtest.toml".ivars."tcp_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening TCP port for Ethereum LibP2P traffic [=9000]."

[config."nimbus-eth2-regtest.toml".ivars."udp_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening UDP port for node discovery [=9000]."

[config."nimbus-eth2-regtest.toml".ivars."max_peers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The target number of peers to connect to [=160]."

[config."nimbus-eth2-regtest.toml".ivars."hard_max_peers"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The maximum number of peers to connect to. Defaults to maxPeers * 1.5."

# [config."nimbus-eth2-regtest.toml".ivars."nat"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Specify method to use for determining public address. Must be one of: any, none, upnp, pmp, extip:<IP> [=any]."

# [config."nimbus-eth2-regtest.toml".ivars."enr_auto_update"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Discovery can automatically update its ENR with the IP address and UDP port as seen by other nodes. Enable or disable this functionality [=false]."

[config."nimbus-eth2-regtest.toml".ivars."weak_subjectivity_checkpoint"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Weak subjectivity checkpoint in the format block_root:epoch_number."

[config."nimbus-eth2-regtest.toml".ivars."external_beacon_api_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "External beacon API to use for syncing (on empty database)."

[config."nimbus-eth2-regtest.toml".ivars."sync_light_client"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Accelerate sync using light client [=true]."

[config."nimbus-eth2-regtest.toml".ivars."trusted_block_root"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Recent trusted finalized block root to sync from external beacon API (with `--external-beacon-api-url`)."

[config."nimbus-eth2-regtest.toml".ivars."trusted_state_root"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Recent trusted finalized state root to sync from external beacon API (with `--external-beacon-api-url`)."

[config."nimbus-eth2-regtest.toml".ivars."finalized_checkpoint_state"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "SSZ file specifying a recent finalized state."

[config."nimbus-eth2-regtest.toml".ivars."genesis_state"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "SSZ file specifying the genesis state of the network (for networks without a built-in genesis state)."

[config."nimbus-eth2-regtest.toml".ivars."genesis_state_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "URL for obtaining the genesis state of the network (for networks without a built-in genesis state)."

[config."nimbus-eth2-regtest.toml".ivars."finalized_deposit_tree_snapshot"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "SSZ file specifying a recent finalized EIP-4881 deposit tree snapshot."

[config."nimbus-eth2-regtest.toml".ivars."node_name"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "A name for this node that will appear in the logs. Set to 'auto' to generate a persistent ID for each --data-dir."

[config."nimbus-eth2-regtest.toml".ivars."graffiti"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The graffiti value that will appear in proposed blocks. Use a 0x-prefixed hex encoded string to specify raw bytes."

[config."nimbus-eth2-regtest.toml".ivars."metrics"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable the metrics server [=false]."

[config."nimbus-eth2-regtest.toml".ivars."metrics_address"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening address of the metrics server [=127.0.0.1]."

[config."nimbus-eth2-regtest.toml".ivars."metrics_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening HTTP port of the metrics server [=8008]."

[config."nimbus-eth2-regtest.toml".ivars."status_bar"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Display a status bar at the bottom of the terminal screen [=true]."

[config."nimbus-eth2-regtest.toml".ivars."status_bar_contents"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Textual template for the contents of the status bar."

# [config."nimbus-eth2-regtest.toml".ivars."rest"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Enable the REST server [=false]."

# [config."nimbus-eth2-regtest.toml".ivars."rest_port"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Port for the REST server [=5052]."

# [config."nimbus-eth2-regtest.toml".ivars."rest_address"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Listening address of the REST server [=127.0.0.1]."

# [config."nimbus-eth2-regtest.toml".ivars."rest_allow_origin"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Limit the access to the REST API to a particular hostname (for CORS-enabled clients such as browsers)."

[config."nimbus-eth2-regtest.toml".ivars."rest_statecache_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The maximum number of recently accessed states that are kept in memory. Speeds up requests for consecutive slots or epochs. [=3]."

[config."nimbus-eth2-regtest.toml".ivars."rest_statecache_ttl"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The number of seconds to keep recently accessed states in memory [=60]."

[config."nimbus-eth2-regtest.toml".ivars."rest_request_timeout"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The number of seconds to wait until a complete REST request is received [=infinite]."

[config."nimbus-eth2-regtest.toml".ivars."rest_max_body_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum size of REST request body (kilobytes) [=16384]."

[config."nimbus-eth2-regtest.toml".ivars."rest_max_headers_size"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum size of REST request headers (kilobytes) [=128]."

[config."nimbus-eth2-regtest.toml".ivars."keymanager"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable the REST keymanager API [=false]."

[config."nimbus-eth2-regtest.toml".ivars."keymanager_port"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening port for the REST keymanager API [=5052]."

[config."nimbus-eth2-regtest.toml".ivars."keymanager_address"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Listening address for the REST keymanager API [=127.0.0.1]."

[config."nimbus-eth2-regtest.toml".ivars."keymanager_allow_origin"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Limit the access to the Keymanager API to a particular hostname (for CORS-enabled clients such as browsers)."

[config."nimbus-eth2-regtest.toml".ivars."keymanager_token_file"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "A file specifying the authorization token required for accessing the keymanager API."

[config."nimbus-eth2-regtest.toml".ivars."light_client_data_serve"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Serve data for enabling light clients to stay in sync with the network [=true]."

[config."nimbus-eth2-regtest.toml".ivars."light_client_data_import_mode"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Which classes of light client data to import. Must be one of: none, only-new, full (slow startup), on-demand (may miss validator duties) [=only-new]."

[config."nimbus-eth2-regtest.toml".ivars."light_client_data_max_periods"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Maximum number of sync committee periods to retain light client data."

# [config."nimbus-eth2-regtest.toml".ivars."in_process_validators"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "Disable the push model and load the validators in the beacon node itself [=true]."

[config."nimbus-eth2-regtest.toml".ivars."discv5"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable Discovery v5 [=true]."

[config."nimbus-eth2-regtest.toml".ivars."dump"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Write SSZ dumps of blocks, attestations, and states to the data directory [=false]."

[config."nimbus-eth2-regtest.toml".ivars."direct_peer"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "The list of privileged, secure, and known peers to connect to. Requires a non-random netkey-file."

# [config."nimbus-eth2-regtest.toml".ivars."doppelganger_detection"]
# type = "string"
# default = ""
# priority = "low"
# ignore_empty = true
# summary = "If enabled, the beacon node will wait for 2 epochs to detect a doppelganger before sending an attestation. Helps avoid slashing [=true]."

[config."nimbus-eth2-regtest.toml".ivars."validator_monitor_auto"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Monitor validator activity automatically for validators active on this beacon node [=true]."

[config."nimbus-eth2-regtest.toml".ivars."validator_monitor_pubkey"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "One or more validators to monitor. Works best when --subscribe-all-subnets is enabled."

[config."nimbus-eth2-regtest.toml".ivars."validator_monitor_details"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Publish detailed metrics for each validator individually. May incur significant overhead with large numbers of validators [=false]."

[config."nimbus-eth2-regtest.toml".ivars."suggested_fee_recipient"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Suggested fee recipient."

[config."nimbus-eth2-regtest.toml".ivars."suggested_gas_limit"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Suggested gas limit [=defaultGasLimit]."

[config."nimbus-eth2-regtest.toml".ivars."payload_builder"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Enable external payload builder [=false]."

[config."nimbus-eth2-regtest.toml".ivars."payload_builder_url"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Payload builder URL."

[config."nimbus-eth2-regtest.toml".ivars."local_block_value_boost"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Increase execution layer block values for builder bid comparison by a percentage [=10]."

[config."nimbus-eth2-regtest.toml".ivars."history"]
type = "string"
default = ""
priority = "low"
ignore_empty = true
summary = "Retention strategy for historical data (archive/prune) [=HistoryMode.Prune]."
