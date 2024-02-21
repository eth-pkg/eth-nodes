# Ethereum Node Packaging

This project is designed to simplify the process of packaging different Ethereum nodes for Debian-based systems. It provides a structured way to create Debian packages for multiple Ethereum clients. 

## Usage

### Build debian packages

#### Create sbuild env 

Sbuild env
```bash
bash build-systems/v1/create-chroot-no-deps.sh bookworm amd64
```
Sbuild env for java/besu
```bash
bash build-systems/v1/create-chroot-oracle-jdk.sh  bookworm amd64
```

Sbuild env for dotnet/nethermind
```bash
bash build-systems/v1/create-chroot-dotnet.sh  bookworm amd64
```

Sbuild env for node.js/lodestar
```bash
bash build-systems/v1/create-chroot-node.sh  bookworm amd64
```

Sbuild env for lighthouse/docker
```bash
bash build-systems/v1/create-chroot-docker.sh  bookworm amd64
```

**Build the Debian Packages**: Build Debian packages for each client using the generated variables.
   ```bash
   make build PACKAGE=eth-node VERSION=0.1-1
   make build PACKAGE=eth-node-besu VERSION=23.10.1-1
   make build PACKAGE=eth-node-erigon VERSION=2.53.2-1
   make build PACKAGE=eth-node-geth VERSION=1.13.4-1
   make build PACKAGE=eth-node-lighthouse VERSION=4.5.0-1
   make build PACKAGE=eth-node-lodestar VERSION=1.11.3-1
   make build PACKAGE=eth-node-nethermind VERSION=1.21.1-1
   make build PACKAGE=eth-node-nimbus-eth2 VERSION=23.10.0-1
   make build PACKAGE=eth-node-prysm VERSION=4.1.1-1
   make build PACKAGE=eth-node-service VERSION=0.1-1
   make build PACKAGE=eth-node-teku VERSION=23.10.0-1

   ```
  This will generate the appropiate .deb files for each package.


