name = "eth-node-reth-testnet"
bin_package = "eth-node-config-reth-testnet"
binary = "/usr/lib/eth-node-config-testnet/bin/run-reth.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd/system/eth-node-reth-testnet.service /lib/systemd/system/"]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-config-reth-testnet", "eth-node-testnet-config", "eth-node-testnet"]
summary = "systemd service files for eth-node-reth using eth-node-config-reth-testnet and eth-node-testnet-config"

# TODO debcrafter should do this
# [config."vars"]
# format = "plain"

# [config."vars.toml".ivars.base_dir]
# type = "path"
# file_type = "dir"
# create = { mode = 755, owner = "$service", group = "$service" }
# default = "/var/lib/eth-node-testnet/reth"
# priority = "low"
# summary = "Node working directory"