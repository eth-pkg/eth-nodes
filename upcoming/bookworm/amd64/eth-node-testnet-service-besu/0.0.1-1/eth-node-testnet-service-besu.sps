name = "eth-node-testnet-service-besu"
bin_package = "eth-node-config-testnet-besu"
binary = "/usr/lib/eth-node-config-testnet/bin/run-besu.sh"
conf_param = "--conf-file"
user = { name = "eth-node-testnet-besu", group = true, create = { home = false } }
runtime_dir = { mode = "750" }
add_dirs = ["/var/lib/eth-node-testnet"]
## hack to actually use system.d but let debcrafter manage the user creation
add_files = ["debian/lib/systemd/system/eth-node-testnet-service-besu.service /lib/systemd/system/"]
provides = ["eth-node-testnet-el-service"]
conflicts = ["eth-node-testnet-el-service"]
depends=["eth-node-config-testnet-besu", "eth-node-testnet-config", "eth-node-testnet"]
summary = "systemd service files for eth-node-besu using eth-node-config-testnet-besu and eth-node-testnet-config"
