# Ethereum Node Packaging

This project aims to simplify the packaging of various Ethereum nodes for Debian-based systems, providing a streamlined approach to generate Debian packages for multiple Ethereum clients. It is actively under development, and you can check the [roadmap](/Roadmap.md) for upcoming features.

## Table of Contents

- [Installation](#installation)
  - [Add Repository](#add-repository)
  - [Install Clients](#install-clients)
    - [Besu](#besu)
    - [Erigon](#erigon)
    - [Geth](#geth)
    - [Lodestar](#lodestar)
    - [Nethermind](#nethermind)
    - [Lighthouse](#lighthouse)
    - [Nimbus-eth2](#nimbus-eth2)
    - [Prysm](#prysm)
    - [Teku](#teku)
- [Building Packages](#building-packages)
  - [Prerequisites](#prerequisites)
  - [Building and Verifying Packages](#building-and-verifying-packages)
- [Verifying Distributed Packages](#verifying-distributed-packages)
- [How It Works](#how-it-works)

## Installation

### Add Repository

1. **Add the repository signing key:**
    ```bash
    sudo curl -fsSL https://packages.eth-pkg.com/keys/ethpkg-archive-keyring.asc -o /usr/share/keyrings/ethpkg-archive-keyring.asc
    ```

2. **Add the repository to sources.list:**
    ```bash
    sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethpkg-archive-keyring.asc] http://packages.eth-pkg.com bookworm main" | sudo tee -a /etc/apt/sources.list.d/ethpkg.list
    ```

3. **Update package lists:**
    ```bash
    sudo apt update
    ```

### Install Clients

Once the repository is added, you can install the clients using `apt`. Note that some clients might require additional runtime dependencies.

#### Besu

1. **Install Java 17:**
    ```bash
    sudo apt -y install wget curl
    wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
    sudo apt install ./jdk-17_linux-x64_bin.deb
    ```

2. **Set up Java environment:**
    ```bash
    cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
    export JAVA_HOME=/usr/lib/jvm/jdk-17/
    export PATH=\$PATH:\$JAVA_HOME/bin
    EOF

    source /etc/profile.d/jdk.sh
    sudo ln -s /usr/lib/jvm/jdk-17-oracle-x64 /usr/lib/jvm/jdk-17
    java -version
    ```

3. **Install Besu:**
    ```bash
    sudo apt install eth-node-besu
    ```

4. **Verify installation:**
    ```bash
    besu --data-path <YOUR_DATA_DIR>
    ```

#### Erigon

1. **Install Erigon:**
    ```bash
    sudo apt install eth-node-erigon
    ```

2. **Verify installation:**
    ```bash
    erigon
    ```

#### Geth

1. **Install Geth:**
    ```bash
    sudo apt install eth-node-geth
    ```

2. **Verify installation:**
    ```bash
    geth
    ```

#### Lodestar

1. **Install Node.js:**
    ```bash
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    ```

2. **Install Lodestar:**
    ```bash
    sudo apt install eth-node-lodestar
    ```

3. **Verify installation:**
    ```bash
    lodestar
    ```

#### Nethermind

1. **Install .NET runtime:**
    ```bash
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update
    sudo apt install -y aspnetcore-runtime-7.0
    ```

2. **Install Nethermind:**
    ```bash
    sudo apt install eth-node-nethermind
    ```

3. **Verify installation:**
    ```bash
    nethermind -dd <YOUR_DATA_DIR>
    ```

#### Lighthouse

1. **Install Lighthouse:**
    ```bash
    sudo apt install eth-node-lighthouse
    ```

2. **Verify installation:**
    ```bash
    lighthouse
    ```

#### Nimbus-eth2

1. **Install Nimbus-eth2:**
    ```bash
    sudo apt install eth-node-nimbus-eth2
    ```

2. **Verify installation:**
    ```bash
    nimbus_beacon_node
    ```

#### Prysm

1. **Install Prysm:**
    ```bash
    sudo apt install eth-node-prysm
    ```

2. **Verify installation:**
    ```bash
    beacon-chain
    ```

#### Teku

1. **Install Java 17:**
    ```bash
    sudo apt -y install wget curl
    wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
    sudo apt install ./jdk-17_linux-x64_bin.deb
    ```

2. **Set up Java environment:**
    ```bash
    cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
    export JAVA_HOME=/usr/lib/jvm/jdk-17/
    export PATH=\$PATH:\$JAVA_HOME/bin
    EOF

    source /etc/profile.d/jdk.sh
    sudo ln -s /usr/lib/jvm/jdk-17-oracle-x64 /usr/lib/jvm/jdk-17
    java -version
    ```

3. **Install Teku:**
    ```bash
    sudo apt install eth-node-teku
    ```

4. **Verify installation:**
    ```bash
    teku
    ```

## Building Packages

### Prerequisites

To begin building packages, you need to install `pkg-builder`. Refer to the [pkg-builder README](https://github.com/eth-pkg/pkg-builder) for installation instructions.

### Building and Verifying Packages

1. **Navigate to the directory you want to package:**
    ```bash
    cd debian-12/amd64/eth-node-nimbus-eth2/24.3.0-1
    ```

2. **Create an environment:**
    ```bash
    pkg-builder env create
    ```

3. **Build the package:**
    ```bash
    pkg-builder package
    ```

4. **Verify the build:**
    ```bash
    pkg-builder verify --no-package true
    ```


## Verifying Packages downloaded through apt

For more detailed verification options, refer to `verify.md` in the corresponding client release.

1. **Download the package:**
    ```bash
    mkdir /tmp/tempdir | cd -
    sudo apt download <package_name>
    ```

2. **Check the SHA1 sum:**
    ```bash
    sha1sum <package_name>*.deb
    ```

3. **Verify the hash:**
    ```bash
    cat releases/bookworm/amd64/<package_name>/pkg-builder-verify.toml
    ```

Example for Teku:
```bash
sudo apt download eth-node-teku
sha1sum eth-node-teku_24.4.0-1_amd64.deb
cat releases/bookworm/amd64/eth-node-teku/24.4.0-1/pkg-builder-verify.toml
```

## How It Works

This process leverages [`debcrafter`](https://github.com/Kixunil/debcrafter) and [`pkg-builder`](https://github.com/eth-pkg/pkg-builder/) to establish reproducible environments. `Debcrafter` helps in creating reproducible Debian directories based on detailed specification files (`.sss` and `.sps`). `Pkg-builder` uses `debcrafter` to set up minimal environments for building packages according to Debian's best practices, including `sbuild`, `piuparts`, `lintian`, and `autopkgtest`, to ensure fully functional packages.

A key challenge in Debian packaging is the need for a separate git repository per package, which can limit support for many applications. While Debian packaging facilitates reproducible builds, at some level, this project aims to adhere closely to best practices while extending where reproducibility is missing, only deviating when necessary.

