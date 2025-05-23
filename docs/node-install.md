# Modular Installation Guide (ALPHA release)

This guide covers installing complete node setups with execution, consensus, and validator clients.

## Add testing repo 

#### Ubuntu 24.04 LTS (Noble Numbat)
```bash
# Add repository key
sudo curl -fsSL https://packages.eth-nodes.com/keys/ethnode-archive-keyring.asc -o /usr/share/keyrings/ethnodes-archive-keyring.asc

# Add repository source
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethnodes-archive-keyring.asc] http://packages.eth-nodes.com/noble-testing noble main" | sudo tee -a /etc/apt/sources.list.d/ethnodes.list

# Update package list
sudo apt update
```

## Full Node Installation
```bash
curl -fsSL https://raw.githubusercontent.com/eth-pkg/eth-nodes/main/scripts/install-java.sh | bash
curl -fsSL https://raw.githubusercontent.com/eth-pkg/eth-nodes/main/scripts/install-nodejs.sh | bash
curl -fsSL https://raw.githubusercontent.com/eth-pkg/eth-nodes/main/scripts/install-dotnet.sh | bash
sudo apt install eth-node-regtest-full
```

### Dependencies
Install required dependencies for your chosen clients:
- Java: Required for Besu and Teku
- .NET: Required for Nethermind
- Node.js: Required for Lodestar


## System Locations
- Data: `/var/lib/eth-node-regtest/`
- Logs: `/var/logs/eth-node-regtest/`

## Verification
Check block production:
```bash
curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":0}' -H "Content-Type: application/json" http://localhost:8545
```
