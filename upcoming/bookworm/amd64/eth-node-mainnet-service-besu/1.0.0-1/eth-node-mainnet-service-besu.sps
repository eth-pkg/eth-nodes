name = "eth-node-mainnet-service-besu"
summary = "TODO"
bin_package = "eth-node-besu-config"
binary = "/usr/bin/run-besu.sh"
conf_param = "--conf-file"
user = { group = true, create = { home = false } }
runtime_dir = { mode = "750" }
extra_service_config = """
"""
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd /lib"]
provides = ["eth-node-mainnet-el-service"]
conflicts = ["eth-node-mainnet-el-service"]
depends=["eth-node-besu-config", "eth-node-mainnet-config"]
