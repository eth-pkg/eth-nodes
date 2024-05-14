# Ethereum Node Packaging

This initiative streamlines the process of packaging diverse Ethereum nodes for Debian-based systems. It offers a systematic approach to generate Debian packages for various Ethereum clients.

The project is still under active development, check out the [roadmap](/Roadmap.md) for upcoming features. 

## Installing clients 

Clients are available for bookworm/amd64, Ubuntu builds are in progress. 

### Add repository 

```bash 
sudo curl -fsSL http://packages.eth-pkg.com/keys/ethpkg-archive-keyring.asc -o /usr/share/keyrings/ethpkg-archive-keyring.asc

# Add repository to sources.list
sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ethpkg-archive-keyring.asc] http://packages.eth-pkg.com bookworm main" | tee -a /etc/apt/sources.list.d/ethpkg.list

# Update package lists
sudo apt update
```

With the repository added, client releases are now available to be simply istalled using apt. Some clients might need additional runtime dependencies. 

### besu 
```bash
sudo apt -y install wget curl
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
sudo apt install ./jdk-17_linux-x64_bin.deb

cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-17/
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

source /etc/profile.d/jdk.sh
sudo ln -s /usr/lib/jvm/jdk-17-oracle-x64  /usr/lib/jvm/jdk-17
java -version

sudo apt install eth-node-besu 
```

Check if besu is available in PATH

```bash
besu --data-path <YOUR_DATA_DIR>
```

### erigon

```bash 
sudo apt install eth-node-erigon
```

Check if erigon is available in PATH

```bash
erigon
```

### geth

```bash
sudo apt install eth-node-geth
```

Check if geth is available in PATH

```bash
geth
```

### lodestar
```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt install -y nodejs
sudo apt install eth-node-lodestar
```


Check if lodestar is available in PATH

```bash
lodestar
```

### nethermind
```bash
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update 
sudo apt install -y aspnetcore-runtime-7.0

sudo apt install eth-node-nethermind
```


Check if nethermind is available in PATH

```bash
nethermind -dd <YOUR_DATA_DIR>
```

### lighthouse
```bash
sudo apt install eth-node-lighthouse
```

Check if lighthouse is installed

```bash
lighthouse
```

### nimbus-eth2

```bash
sudo apt install eth-node-nimbus-eth2
```

Check if nimbus is available in PATH
```bash
nimbus_beacon_node
```

### prysm

```bash
sudo apt install eth-node-prysm
```

Check if prysm is available in PATH
```bash
beacon-chain
```

### teku

```bash 
sudo apt -y install wget curl
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
sudo apt install ./jdk-17_linux-x64_bin.deb

cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-17/
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

source /etc/profile.d/jdk.sh
sudo ln -s /usr/lib/jvm/jdk-17-oracle-x64  /usr/lib/jvm/jdk-17
java -version

sudo apt install eth-node-teku
```

Check if teku is available in PATH
```bash
teku
```

## Building packages

### Prerequisites

Begin by installing `pkg-builder`. Refer to the README for installation instructions: [https://github.com/eth-pkg/pkg-builder](https://github.com/eth-pkg/pkg-builder)

### Building Debian Packages and verifying the build

```bash
# Change into the directory which you want to package
cd debian-12/amd64/eth-node-nimbus-eth2/24.3.0-1
# Create an environment once for each distribution/architecture pairing
pkg-builder env create 

# This command installs dependencies, downloads source code, builds the client, and conducts tests against it
# Note: Autopkgtests and piuparts may require elevated permissions
pkg-builder package 

# To verify a successful build without running tests, you can use this command

pkg-builder verify 
```

If you're not building but simply ensuring the built client matches a specific hash:

```bash
debian-12/amd64/eth-node-nimbus-eth2/24.3.0-1
# Create an environment once for each distribution/architecture pairing
pkg-builder env create 

# Verify the successful build without running tests
pkg-builder verify
```

## Verifying distributed packages 

For more details and options of verification refer to `verify.md` in corresponding client release.  

```bash
mkdir /tmp/tempdir | cd -
sudo apt download <package_name>
sha1sum  <package_name>*.deb
```

Check the appropriate folder `pkg-builder-verify.toml` for hash. 

So for example if you want to verify teku 
```bash
sudo apt download eth-node-teku
# Get:1 http://packages.eth-pkg.com bookworm/main amd64 eth-node-teku amd64 24.4.0-1 [176 MB]
sha1sum eth-node-teku_24.4.0-1_amd64.deb # 541013cb73f767d94e19169c5685d01f8d145803
cat releases/bookworm/amd64/eth-node-teku/24.4.0-1/pkg-builder-verify.toml # check if the hash is indeed the same
```

## How It Works

This process leverages [`debcrafter`](https://github.com/Kixunil/debcrafter) and [`pkg-builder`](https://github.com/eth-pkg/pkg-builder/) to establish reproducible environments. Debcrafter aids in creating reproducible Debian directories based on detailed specification files ending with `.sss` and `.sps`. Meanwhile, pkg-builder utilizes debcrafter, and extends it to setup minimal environments to build and adheres to Debian's best practices, including `sbuild`, `piuparts`, `lintian`, and `autopkgtest`, to build the packages and test them thoroughly, ensuring they are not merely packages but functional ones.

Currently, a significant obstacle in Debian packaging is the requirement for a separate git repository per package, which might hinder the support for numerous applications. Despite Debian packaging already facilitating reproducible builds, this aspect is still in its infancy. This project aims to adhere to distribution best practices to the fullest extent possible, only deviating when necessary or when certain support structures are not yet in place.
