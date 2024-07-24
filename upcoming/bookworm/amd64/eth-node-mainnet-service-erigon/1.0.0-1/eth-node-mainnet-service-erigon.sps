name = "eth-node-mainnet-service-erigon"
bin_package = "eth-node-erigon-config"
binary = "/usr/bin/run-erigon.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd /lib"]
provides = ["eth-node-mainnet-el-service"]
conflicts = ["eth-node-mainnet-el-service"]
depends=["eth-node-erigon-config", "eth-node-mainnet-config"]
summary = "systemd service files for eth-node-erigon using eth-node-erigon-config and eth-node-mainnet-config"

# TODO debcrafter should do this
# [config."vars"]
# format = "plain"

# [config."vars.toml".ivars.base_dir]
# type = "path"
# file_type = "dir"
# create = { mode = 755, owner = "$service", group = "$service" }
# default = "/var/lib/eth-node-mainnet/erigon"
# priority = "low"
# summary = "Node working directory"