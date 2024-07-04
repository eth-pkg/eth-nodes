name = "eth-node-besu-lighthouse-service-testnet"
architecture = "any"
summary = "Simplified Ethereum node installation for {variant}, supporting clients: besu and lighthouse."
conflicts = ["eth-node-testnet"]
recommends = []
provides = ["eth-node-testnet"]
suggests = []
depends = ["eth-node-besu", "eth-node-lighthouse"]
add_files = []
add_manpages = []
long_doc = """eth-node-testnet
By installing this package,
it will automatically set up a besu and lighthouse client pair (consensus and execution client) for connecting
to the Ethereum testnet network.
"""
# Service related fields
bin_package = "run-besu.sh"
binary = "/usr/lib/eth-node-testnet/bin"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }

# Fields for config file
[config.shared_fields]
format = "plain"

# Variable placed into /etc/eth-node-testnet-besu-lighthouse/shared_fields
[config."shared_fields".hvars."NETWORK"]
ignore_empty = true
store = true
default = "testnet"

# Variable placed into /etc/eth-node-testnet-besu-lighthouse/shared_fields
[config."shared_fields".hvars."ENGINE_API_PORT"]
default = "8551"
priority = "medium"
summary = "Engine api to listen on (consensus - execution client)"