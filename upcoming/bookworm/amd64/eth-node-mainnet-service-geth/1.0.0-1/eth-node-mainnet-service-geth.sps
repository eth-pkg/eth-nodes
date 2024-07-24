name = "eth-node-mainnet-service-geth"
bin_package = "eth-node-geth-config"
binary = "/usr/bin/run-geth.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd /lib"]
provides = ["eth-node-mainnet-el-service"]
conflicts = ["eth-node-mainnet-el-service"]
depends=["eth-node-geth-config", "eth-node-mainnet-config"]
summary = "systemd service files for eth-node-geth using eth-node-geth-config and eth-node-mainnet-config"

# TODO debcrafter should do this
# [config."vars"]
# format = "plain"

# [config."vars.toml".ivars.base_dir]
# type = "path"
# file_type = "dir"
# create = { mode = 755, owner = "$service", group = "$service" }
# default = "/var/lib/eth-node-mainnet/geth"
# priority = "low"
# summary = "Node working directory"