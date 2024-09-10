name = "eth-node-geth-testnet"
bin_package = "eth-node-config-geth-testnet"
binary = "/usr/lib/eth-node-config-testnet/bin/run-geth.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd/system/eth-node-geth-testnet.service /lib/systemd/system/"]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-config-geth-testnet", "eth-node-testnet-config", "eth-node-testnet"]
summary = "systemd service files for eth-node-geth using eth-node-config-geth-testnet and eth-node-testnet-config"

# TODO debcrafter should do this
# [config."vars"]
# format = "plain"

# [config."vars.toml".ivars.base_dir]
# type = "path"
# file_type = "dir"
# create = { mode = 755, owner = "$service", group = "$service" }
# default = "/var/lib/eth-node-testnet/geth"
# priority = "low"
# summary = "Node working directory"