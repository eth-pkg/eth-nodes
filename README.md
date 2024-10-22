# Ethereum Node Packaging

[![regtest](https://github.com/eth-pkg/eth-nodes/actions/workflows/regtest.yml/badge.svg)](https://github.com/eth-pkg/eth-nodes/actions/workflows/regtest.yml) 

This project aims to simplify the packaging of various Ethereum nodes for Debian-based systems, providing a streamlined approach to generate Debian packages for multiple Ethereum clients. It is actively under development, and you can check the [roadmap](/Roadmap.md) for upcoming features.

## Table of Contents

- [Installation](#installation)
  - [Debian 12](#add-repository)
  - [Ubuntu 24.04 LTS](#debian-12-bookworm)
  - [Alpha Release](#install-eth-node-regtest-alpha-release)
  - [Install Clients](#install-clients)
    - [besu](#besu)
    - [erigon](#erigon)
    - [geth](#geth)
    - [lodestar](#lodestar)
    - [nethermind](#nethermind)
    - [lighthouse](#lighthouse)
    - [nimbus-eth2](#nimbus-eth2)
    - [prysm](#prysm)
    - [reth](#reth)
    - [teku](#teku)
  - [Install deps](#install-deps)
    - [dotnet](#dotnet) 
    - [java](#java) 
    - [nodejs](#nodejs) 
- [Building Packages](#building-packages)
  - [Prerequisites](#prerequisites)
  - [Building and Verifying Packages](#building-and-verifying-packages)
- [Verifying](#verifying)
- [How It Works](#how-it-works)

## Installation

### Debian 12 (bookworm)

1. **Add the repository signing key:**
    ```bash
    sudo curl -fsSL https://packages.eth-pkg.com/keys/ethpkg-archive-keyring.asc -o /usr/share/keyrings/ethpkg-archive-keyring.asc
    ```

2. **Add the repository to sources.list:**
    ```bash
    sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethpkg-archive-keyring.asc] http://packages.eth-pkg.com/bookworm-main bookworm main" | sudo tee -a /etc/apt/sources.list.d/ethpkg.list
    ```

3. **Update package lists:**
    ```bash
    sudo apt update
    ```
    
### Ubuntu 24.04 LTS (noble numbat)

1. **Add the repository signing key:**
    ```bash
    sudo curl -fsSL https://packages.eth-pkg.com/keys/ethpkg-archive-keyring.asc -o /usr/share/keyrings/ethpkg-archive-keyring.asc
    ```

2. **Add the repository to sources.list:**
    ```bash
    sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethpkg-archive-keyring.asc] http://packages.eth-pkg.com/noble-main noble main" | sudo tee -a /etc/apt/sources.list.d/ethpkg.list
    ```

3. **Update package lists:**
    ```bash
    sudo apt update
    ```

### Install eth-node-regtest (ALPHA RELEASE)

```bash
sudo curl -fsSL https://packages.eth-pkg.com/keys/ethpkg-archive-keyring.asc -o /usr/share/keyrings/ethpkg-archive-keyring.asc
sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethpkg-archive-keyring.asc] http://packages.eth-pkg.com/noble-testing noble main" | sudo tee -a /etc/apt/sources.list.d/ethpkg.list
sudo apt update
```
Note: Please install [Java](#java), [Dotnet](#dotnet), and [Node.js](#nodejs) dependencies for clients whose dependencies depend on them. Currently, these are not auto-installed. 

```bash
# For available options see
apt-cache depends eth-node-regtest
#  Depends: <eth-node-regtest-cl-service>
#    eth-node-lighthouse-regtest
#    eth-node-lodestar-regtest
#    eth-node-nimbus-eth2-regtest
#    eth-node-prysm-regtest
#    eth-node-teku-regtest
#  Depends: <eth-node-regtest-el-service>
#    eth-node-besu-regtest
#    eth-node-erigon-regtest
#    eth-node-geth-regtest
#    eth-node-nethermind-regtest
#    eth-node-reth-regtest
apt-cache depends eth-node-validator-regtest
# eth-node-validator-regtest
# Depends: <eth-node-validator-service-regtest>
#    eth-node-lighthouse-validator-regtest
#    eth-node-lodestar-validator-regtest
#    eth-node-nimbus-eth2-validator-regtest
#    eth-node-prysm-validator-regtest
#    eth-node-teku-validator-regtest
# pick the options you want
sudo apt install eth-node-lodestar-regtest eth-node-besu-regtest eth-node-nimbus-eth2-validator
```
Data directories are under: `/var/lib/eth-node-regtest/`
Logs are under: `/var/logs/eth-node-regtest/`

Wait for a few minutes and check if blocks are produced

```bash
curl -s -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":0}' -H "Content-Type: application/json" http://localhost:8545
```
Check out the [FAQ](/FAQ.md) for more details
    
### Install Clients

Once the repository is added, you can install the clients using `apt`. Note that some clients might require additional runtime dependencies.

<details>
<summary><b>besu</b></summary>

1. **Install Java 21:**
    ```bash
    sudo apt -y install wget curl
    wget https://download.oracle.com/java/21/archive/jdk-21.0.2_linux-x64_bin.deb
    sudo apt install ./jdk-21.0.2_linux-x64_bin.deb
    ```

2. **Set up Java environment:**
    ```bash
    cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
    export JAVA_HOME=/usr/lib/jvm/jdk-21/
    export PATH=\$PATH:\$JAVA_HOME/bin
    EOF

    source /etc/profile.d/jdk.sh
    sudo ln -s /usr/lib/jvm/jdk-21-oracle-x64 /usr/lib/jvm/jdk-21
    java -version
    ```

3. **Install besu:**
    ```bash
    sudo apt install eth-node-besu
    ```

4. **Verify installation:**
    ```bash
    besu --data-path <YOUR_DATA_DIR>
    ```

</details>

<details>
<summary><b>erigon</b></summary>

1. **Install erigon:**
    ```bash
    sudo apt install eth-node-erigon
    ```

2. **Verify installation:**
    ```bash
    erigon
    ```

</details>

<details>
<summary><b>geth</b></summary>

1. **Install geth:**
    ```bash
    sudo apt install eth-node-geth
    ```

2. **Verify installation:**
    ```bash
    geth
    ```

</details>

<details>
<summary><b>lodestar</b></summary>

1. **Install Node.js:**
    ```bash
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    ```

2. **Install lodestar:**
    ```bash
    sudo apt install eth-node-lodestar
    ```

3. **Verify installation:**
    ```bash
    lodestar
    ```

</details>

<details>
<summary><b>nethermind</b></summary>

1. **Install .NET runtime:**
    ```bash
    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update
    sudo apt install -y aspnetcore-runtime-8.0
    ```

2. **Install nethermind:**
    ```bash
    sudo apt install eth-node-nethermind
    ```

3. **Verify installation:**
    ```bash
    nethermind -dd <YOUR_DATA_DIR>
    ```

</details>

<details>
<summary><b>lighthouse</b></summary>

1. **Install lighthouse:**
    ```bash
    sudo apt install eth-node-lighthouse
    ```

2. **Verify installation:**
    ```bash
    lighthouse
    ```

</details>

<details>
<summary><b>nimbus-eth2</b></summary>

1. **Install nimbus-eth2:**
    ```bash
    sudo apt install eth-node-nimbus-eth2
    ```

2. **Verify installation:**
    ```bash
    nimbus_beacon_node
    ```

</details>

<details>
<summary><b>prysm</b></summary>

1. **Install prysm:**
    ```bash
    sudo apt install eth-node-prysm
    ```

2. **Verify installation:**
    ```bash
    beacon-chain
    ```

</details>

<details>
<summary><b>reth</b></summary>

1. **Install reth:**
    ```bash
    sudo apt install eth-node-reth
    ```

2. **Verify installation:**
    ```bash
    reth
    ```

</details>

<details>  
<summary><b>teku</b></summary>

1. **Install Java 21:**
    ```bash
    sudo apt -y install wget curl
    wget https://download.oracle.com/java/21/archive/jdk-21.0.2_linux-x64_bin.deb
    sudo apt install ./jdk-21.0.2_linux-x64_bin.deb
    ```

2. **Set up Java environment:**
    ```bash
    cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
    export JAVA_HOME=/usr/lib/jvm/jdk-21/
    export PATH=\$PATH:\$JAVA_HOME/bin
    EOF

    source /etc/profile.d/jdk.sh
    sudo ln -s /usr/lib/jvm/jdk-21-oracle-x64 /usr/lib/jvm/jdk-21
    java -version
    ```

3. **Install teku:**
    ```bash
    sudo apt install eth-node-teku
    ```

4. **Verify installation:**
    ```bash
    teku
    ```

</details>

### Install deps

<details>
<summary><b>dotnet</b></summary>

    ```bash
        wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
        sudo dpkg -i packages-microsoft-prod.deb
        rm packages-microsoft-prod.deb
        sudo apt update
        sudo apt install -y aspnetcore-runtime-8.0
    ```
</details>


<details>
<summary><b>nodejs</b></summary>

    ```bash
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    ```

</details>

<details>
<summary><b>java</b></summary>

1. **Install Java 21:**
    ```bash
    sudo apt -y install wget curl
    wget https://download.oracle.com/java/21/archive/jdk-21.0.2_linux-x64_bin.deb
    sudo apt install ./jdk-21.0.2_linux-x64_bin.deb
    ```

2. **Set up Java environment:**
    ```bash
    cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
    export JAVA_HOME=/usr/lib/jvm/jdk-21/
    export PATH=\$PATH:\$JAVA_HOME/bin
    EOF

    source /etc/profile.d/jdk.sh
    sudo ln -s /usr/lib/jvm/jdk-21-oracle-x64 /usr/lib/jvm/jdk-21
    java -version
    ```

</details>

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

## Verifying

There are several methods to verify builds:

1. Verify by rebuilding on your own machine.
2. Verify by building using GitHub Actions.
3. Verify that the hashes of distributed packages through apt match those provided in `pkg-builder-verify.toml`.

### Verifying by Rebuilding on Your Machine or Cloud Instance

For detailed instructions, please refer to the section on [how to build packages](#building-packages).

Note that verification cannot be performed inside a Docker image due to the current lack of support for stacking kernel namespaces with sbuild.

### Verifying Builds through GitHub Actions

This method offers weak verifiability because GitHub Actions runners use uniform machines, which increases the likelihood of matching hashes. However, hashes might differ on locally built packages due to non-uniformity of machines. Running this verification is still recommended as it guarantees reproducibility on GitHub Actions and is easy to perform. (note: The built packages are built against multiple machines to check hashes.)

To verify through GitHub Actions:

1. Fork the repository.
2. Select a release to verify (e.g., `releases/bookworm/amd64/eth-node-erigon/2.60.0-1`).
3. Create a branch named `verify/bookworm/amd64/eth-node-erigon/2.60.0-1` (replace `releases` with `verify`).
4. Push the branch to GitHub and create a PR.
5. Wait for the action runner to complete.

Note: You cannot create any branch starting with `verify/*` on this repository to avoid dummy PRs.

### Verifying Package Hashes with `pkg-builder-verify.toml`

Packages distributed through apt or downloadable from GitHub releases can be verified to ensure their hashes match the ones in `pkg-builder-verify.toml`. Follow these steps:

1. **Download the package:**
    ```bash
    mkdir /tmp/tempdir && cd /tmp/tempdir
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

This process utilizes [`debcrafter`](https://github.com/Kixunil/debcrafter) and [`pkg-builder`](https://github.com/eth-pkg/pkg-builder/) to create reproducible environments. `debcrafter` aids in generating reproducible Debian directories from detailed specification files (`.sss` and `.sps`). While `debcrafter` already supports reproducible builds, it doesn't pin environment dependencies, which led to the development of `pkg-builder`. `Pkg-builder` employs `debcrafter` to establish minimal environments for building packages in line with Debian's best practices. This includes tools like `sbuild`, `piuparts`, `lintian`, and `autopkgtest` to ensure fully functional packages.

`pkg-builder` enhances `debcrafter` by adding package pinning, checking against hashes, and supporting multiple programming languages such as C, .NET, Java, Rust, Go, and Nim. It also supports various Linux backends for packaging, including Noble Numbat, Jammy, and Debian 12. Additionally, `pkg-builder` ensures that all tools work together in a uniform manner, addressing the challenge of using these tools consistently and correctly.

`debcrafter` also makes it possible to create modular and dependent Debian packages, simplifying the handling of package relationships. Without `debcrafter`, the `eth-node` project would not be possible.

One significant challenge in Debian packaging is the requirement for a separate git repository per package, which can hinder support for numerous applications. While Debian packaging promotes reproducible builds, this requirement poses some limitations. Furthermore, not everyone uses git repositories, making it difficult to track which packages are updated. Having a monorepo simplifies this by providing a clear view of what is shipped and what is in development. Through `debcrafter`, it is very easy to have one organization’s interconnected packages in one repository and manage different versions, updates, and relationships together without having to rehost the source code of the original packages. Since the source code is just one input to the package process, tracking it in the packaging repository host makes little sense. Simple patching allows for including only the patched files with their patches in the repository, saving cognitive overhead and git space.
