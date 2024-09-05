name = "eth-node-testnet-service-geth"
bin_package = "eth-node-config-testnet-geth"
binary = "/usr/lib/eth-node-config-testnet/bin/run-geth.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd/system/eth-node-testnet-service-geth.service /lib/systemd/system/"]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-config-testnet-geth", "eth-node-testnet-config", "eth-node-testnet"]
summary = "systemd service files for eth-node-geth using eth-node-config-testnet-geth and eth-node-testnet-config"

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