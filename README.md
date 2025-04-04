# Reproducible builds for Ethereum Ecosystem (Debian/Ubuntu) 

> **IMPORTANT NOTICE**: This project is still a work in progress. Use it at your own risk. Please don't run in production environments yet.

[![regtest daily](https://github.com/eth-pkg/eth-nodes/actions/workflows/regtest-daily.yml/badge.svg)](https://github.com/eth-pkg/eth-nodes/actions/workflows/regtest-daily.yml)

This project provides reproducible Debian packages for Ethereum nodes. Each build generates identical hashes, allowing users to verify package authenticity and integrity. These Debian packages simplify node installation and maintenance on Debian-based systems.

## Quick Start
1. Add the repository key and source
2. Install desired client(s)
3. Configure and run your node

### Repository Setup
Choose your distribution:

#### Debian 12 (bookworm), Ubuntu 24.04 LTS (Noble Numbat)
```bash
# Add repository key
sudo curl -fsSL https://packages.eth-nodes.com/keys/ethnodes-archive-keyring.asc -o /usr/share/keyrings/ethnodes-archive-keyring.asc
# Add repository source
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethnodes-archive-keyring.asc] http://packages.eth-nodes.com/$(lsb_release -cs)-main $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ethnodes.list
# Update package list
sudo apt update
```

## Installation Options

### 1. Full Node Setup
Complete node setup including execution, consensus, and validator clients. Recommended for running a full Ethereum node.
- [Full Installation Guide (ALPHA release on custom testnet)](docs/FULL_NODE_INSTALL.md)

### 2. Individual Clients
Install specific clients for custom configurations:
- [Client Installation Guide](docs/CLIENT_INSTALL.md)

## Available Clients

### Execution Clients
| Client | Package Name | Description |
|--------|--------------|-------------|
| [Besu](https://github.com/hyperledger/besu) | `besu` | Java-based client by Hyperledger |
| [Erigon](https://github.com/ledgerwatch/erigon) | `erigon` | Go client focused on efficiency |
| [Geth](https://github.com/ethereum/go-ethereum) | `geth` | Go-based reference client |
| [Nethermind](https://github.com/NethermindEth/nethermind) | `nethermind` | .NET-based high-performance client |
| [Reth](https://github.com/paradigmxyz/reth) | `reth` | Rust-based next-gen client |

### Consensus/Validator Clients
| Client | Package Name | Description |
|--------|--------------|-------------|
| [Lighthouse](https://github.com/sigp/lighthouse) | `lighthouse` | Rust-based client |
| [Lodestar](https://github.com/ChainSafe/lodestar) | `lodestar` | TypeScript/JavaScript client |
| [Nimbus](https://github.com/status-im/nimbus-eth2) | `nimbus-eth2` | Nim-based lightweight client |
| [Prysm](https://github.com/prysmaticlabs/prysm) | `prysm` | Go-based popular client |
| [Teku](https://github.com/Consensys/teku) | `teku` | Java-based enterprise client |

### Additional Tools
- `ethereum-genesis-generator`: Genesis state generator
- `eth2-testnet-genesis`
- `eth2-val-tools`
- `zcli`

## Documentation
- [Building Guide](docs/BUILDING.md) - Create your own packages
- [Verification Guide](docs/VERIFICATION.md) - Verify package integrity
- [Architecture](docs/ARCHITECTURE.md) - System design details
- [FAQ](docs/FAQ.md) - Common questions and answers

## Contributing
Contributions are welcome! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## License
AGPL v3  
See [LICENSE](LICENSE) for details
