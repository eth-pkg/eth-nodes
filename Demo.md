# Demo guide

## Add Repository Key
```bash
sudo curl -fsSL https://eth-nodes.com/keys/ethnodes-archive-keyring.asc -o /usr/share/keyrings/ethnodes-archive-keyring.asc
```

## Add Repository Source
For the main repository:
```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethnodes-archive-keyring.asc] http://packages.eth-nodes.com/$(lsb_release -cs)-main $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ethnodes.list
```
For the testing repository:
```bash
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethnodes-archive-keyring.asc] http://packages.eth-nodes.com/noble-testing noble main" | sudo tee /etc/apt/sources.list.d/ethnodes.list
```

## Update Package List
```bash
sudo apt update
```

## Install Dependencies
```bash
curl -fsSL https://raw.githubusercontent.com/eth-pkg/eth-nodes/main/scripts/install-java.sh | bash
curl -fsSL https://raw.githubusercontent.com/eth-pkg/eth-nodes/main/scripts/install-nodejs.sh | bash
curl -fsSL https://raw.githubusercontent.com/eth-pkg/eth-nodes/main/scripts/install-dotnet.sh | bash
```

## List Available Packages
```bash
sudo apt list eth-node-<clientname> -a
sudo apt list "eth-node-*" -a
```

## Install Main Package (Regtest Network)
If reinstalling, purge previous installations:
```bash
sudo apt purge eth-node-regtest-full
```
Install the package:
```bash
sudo apt install eth-node-regtest-full
```

## Check Systemd Services
```bash
sudo systemctl status eth-node-<clientname>-<networkname>.service
```

## Verify Local Network
Check block number:
```bash
curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":0}' -H "Content-Type: application/json" http://localhost:8545
```
Check sync status:
```bash
curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":0}' -H "Content-Type: application/json" http://localhost:8545
curl -s -X GET -H "Content-Type: application/json" http://localhost:5052/eth/v1/node/syncing
```

## Submit Transactions
Send a raw transaction:
```bash
curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_sendRawTransaction","params":["0x01f86f8205398085e8d4a5100082520894000000000000000000000000000000000000dead872386f26fc1000080c080a09a4d7c7edb084f4323bdf7dd7f2042a8bf069fd64f32934ee91b50f4398f84a4a017e12b64ab00e30299b01c94e6e297ffbed21752ee7986e0ab5744b6a4a2bf72"],"id":4}' http://localhost:8545
```
Retrieve transaction details (replace `$txHash` with the result hash, e.g., `0xde3a566549b701d2f309534baabea43cb15bc95b80eb6995c1b5eb077d2d4c4c`):
```bash
curl -s -X POST http://localhost:8545 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_getTransactionByHash","params":["'"$txHash"'"],"id":5}'
```

## View Logs
List logs:
```bash
ls /var/logs/eth-node-regtest
```
Monitor logs (example for Lodestar): (replace date with the current date)
```bash
sudo tail -f /var/logs/eth-node-regtest/lodestar/lodestar-year-month-day.log
```

## See installed system.d files 

```bash
sudo cat /lib/systemd/system/eth-node-<clientname>-regtest.service
sudo cat /lib/systemd/system/eth-node-<clientname>-validator-regtest.service
```
