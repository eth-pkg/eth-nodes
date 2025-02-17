# Modular Installation Guide (ALPHA release)

This guide covers installing complete node setups with execution, consensus, and validator clients.

## Full Node Installation
```bash
sudo apt install eth-node-regtest eth-node-validator-regtest
```

### Dependencies
Install required dependencies for your chosen clients:
- Java: Required for Besu and Teku
- .NET: Required for Nethermind
- Node.js: Required for Lodestar

## Custom Client Combinations
View available options:
```bash
apt-cache depends eth-node-regtest
apt-cache depends eth-node-validator-regtest
```

Install specific combinations:
```bash
sudo apt install eth-node-<el_name>-regtest eth-node-<cl_name>-regtest eth-node-<validator_name>-validator
```

Example combinations:
- Geth + Lighthouse: `sudo apt install eth-node-geth-regtest eth-node-lighthouse-regtest eth-node-lighthouse-validator-regtest`
- Nethermind + Prysm: `sudo apt install eth-node-nethermind-regtest eth-node-prysm-regtest eth-node-prysm-validator-regtest`

## System Locations
- Data: `/var/lib/eth-node-regtest/`
- Logs: `/var/logs/eth-node-regtest/`

## Verification
Check block production:
```bash
curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":0}' -H "Content-Type: application/json" http://localhost:8545
```