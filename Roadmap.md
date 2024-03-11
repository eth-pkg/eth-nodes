

# High-level overview:

1. **Eth-node client builds**: Users should be able to `install` on `Debian 12` consensus/execution, and can `verify` the package builds. 
2. **Eth-node configuration builds**: Users should be able to install  `eth-node` and upon installation said nodes should automatically be started **without any required configuration**. Configuration is optional for those who wish to do so, through `dpkg-configure`.  
3. **Ethereum node addons**: Users should be able to add **additional elements to node running**: monitoring, API exposure, and ecosystem packages, which work out of the box with `eth-node` defined in the previous point.
4. **Additional distribution support**: Users should be able to install the above (points 1-3) on other distributions as well (Ubuntu LTS, Fedora latest, Debian 11, etc)
5. **Research**: Additional items, for future roadmap or implemented in current roadmap if possible.


**Definition of reproducibility for this roadmap:** 
Reproducible on the same distribution, with the same architecture, based on same buildinfo should reproduce the same binary. (Debian package repository constantly updates, if dependencies are updated in the main repo, the buildinfo will change)

# 1. Eth-node client builds

## Current progress

* The packaging build system is working (Makefile), but not tested, I propose it is rewritten
* The build environment is isolated properly using Sbuild (chroot), with caveats
* packages do build, some are fully reproducible, and some are not yet. See the reproducible definition. 

## What is missing
* client tests are broken (docker dependency)
* docker under chroot is problematic
* nimbus build is not working
* GitHub workflow for tagging release
* reproducible flags for `besu`, `lodestar`, `nethermind`, `nimbus`, `prysm`, and `teku` are missing
* tests for build system and each package is missing
* repository hosting is working but needs to be reconfigured
* lintian fails

See in more detail on the roadmap: https://github.com/eth-pkg/eth-deb/milestone/1 

## Objective

### Ability to install clients

```bash
REPO_URL=" to be specified"
SIGNATURE_URL=" to be specified"

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL $SIGNATURE_URL -o /etc/apt/keyrings/ethpkg.asc

sudo chmod a+r /etc/apt/keyrings/ethpkg.asc

# Add repository to sources.list
sudo echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ethpkg.asc] $REPO_URL bookworm testing" | tee -a /etc/apt/sources.list/ethpkg.list

# Update package lists
sudo apt-get update


# Install besu
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
# Install erigon
sudo apt install eth-node-erigon
# Install geth
sudo apt install eth-node-geth
# Install erigon
sudo apt install eth-node-erigon

# Install lodestar
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs
sudo apt install eth-node-lodestar


# Install nethermind
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

  # Install the runtime
sudo apt-get update 
sudo apt-get install -y aspnetcore-runtime-7.0

sudo apt install eth-node-nethermind


# Install lighthouse
sudo apt install eth-node-lighthouse
# Install nimbus-eth2
sudo apt install eth-node-nimbus-eth2
# Install prysm
sudo apt install eth-node-prysm

# Install teku
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

# NOTE nodes will be available with PREFIX=eth-node-
# Instead of CLIENT it will be invoked by eth-node-$(CLIENT)
# In the case of teku it will be available as eth-node-teku
```

### Ability to verify builds 

```bash
# or if you have the build recipe
pkbuilder verify --pkg-build-input=<pkg_recipe> --pkg-build-output=<path_to_previous_build_result>
# resusts yes/no
```

As reproducibility is not an easy feat and will entail much more for a full 100% delivery, dependent on Debian missing or working in features, I would like to define what sort of reproducibility this task aims to deliver.
### Running tests

```bash
pkbuilder test --pkg-build-input=<pkg_recipe> --pkg-build-output=<path_to_previous_build_result>

# tests for pkgbuilder itself 
cargo test pkgbuilder
```


## Questions:
* Is the `eth-node-` prefix was chosen, is there a better option
* what `arch` needs to be supported? Defaulting to `amd64`
* Versions to package. Default to latest stable ones.
* Do we want to support light clients in this iteration? No, by default. 

# 2. Eth-node configuration builds

## What is already working 
* systemd services do start, but fail if config files are incorrect
* dependency map for package hierarchy (need to explain)

## What is missing

* configuration downgrade upgrade
* How to handle if a person changes config with dpkg-reconfigure
* time configuration for service
* debcrafter missing TOML support, need to think of workaround or add support to debcrafter
* default configuration for each client

See in more detail on the roadmap: https://github.com/eth-pkg/eth-deb/milestone/2


## Objective

```bash
REPO_URL=" to be specified"
SIGNATURE_URL=" to be specified"

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL $SIGNATURE_URL -o /etc/apt/keyrings/ethpkg.asc

sudo chmod a+r /etc/apt/keyrings/ethpkg.asc

# Add repository to sources.list
sudo echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ethpkg.asc] $REPO_URL bookworm testing" | tee -a /etc/apt/sources.list/ethpkg.list

# Update package lists
sudo apt-get update

# Install dependencies (node.js, dotnet, java) to satisfy dependencies
# If you know which client pairs you want, you can ignore the dependencies if not needed
## Install Java
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

# Install node.js
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

# Install dotnet
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

  # Install the runtime
sudo apt-get update 
sudo apt-get install -y aspnetcore-runtime-7.0

# Install any of the following

# 1.1
sudo apt install eth-node

# 1.2 OR pick any two nodes
sudo apt install eth-node-lighthouse-service eth-node-erigon-service

# 1.3.1 OR specify one consensus client and let the other one be picked
sudo apt install eth-node-lighthouse eth-node # This will pick an execution client

# 1.3.1 OR specify one consensus client and let the other one be picked alternative
sudo apt install eth-node-lighthouse eth-node-execution-client # This will pick also an execution client

# 1.3.1 OR specify one execution client and let the other one be picked
sudo apt install eth-node-erigon eth-node # This will pick a consensus client

# 1.3.1 OR specify one execution client and let the other one be picked alternative
sudo apt install eth-node-erigon eth-node-consensus-client # This will pick also a consensus client

# 1.4 Specify the configuration you wish to install
# pick config based on network 
# and sub pick config based network
# NOTE this might differ in syntax
sudo apt install eth-node-lighthouse-service eth-node-lighthouse-service-config-default-sepolia eth-node-erigon-service eth-node-erigon-service-config-default-sepolia

## Usage ## 
# 2.1 See the running service based on the client
systemctl status eth-node-lighthouse-service

# 2.1 Reconfigure
sudo dpkg-reconfigure eth-node-lighthouse-service-config-default-sepolia


# Based on network
apt install eth-node # defaults to mainnet
apt install eth-node-mainnet
apt install eth-node-sepolia
apt install eth-node-goerli
apt install eth-node-ephemary
```

## Open questions:
* Which network to support by configs? Client support varies by the network [mainnet, sepolia, ephemary, goerli, layer 2 test networks, private networks]. Defaulting to ephemary and goerli. 

# 3 Eth-node ecosystem packages

## What is done

Nothing is done on this front. I didn't include this part in my original proposal.

## Objective

```bash
REPO_URL=" to be specified"
SIGNATURE_URL=" to be specified"

sudo install -m 0755 -d /etc/apt/keyrings

sudo curl -fsSL $SIGNATURE_URL -o /etc/apt/keyrings/ethpkg.asc

sudo chmod a+r /etc/apt/keyrings/ethpkg.asc

# Add repository to sources.list
sudo echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/ethpkg.asc] $REPO_URL bookworm testing" | tee -a /etc/apt/sources.list/ethpkg.list

# Update package lists
sudo apt-get update

# Install any of the following

# Example
# Note the API for this is not yet known, this WILL BE CHANGED
# Install Prometheus as a dependency and configure it against eth-node, also install eth-node as a dependency
sudo apt install eth-node-monitoring-prometheus
# Install influxdb as a dependency and configure it against eth-node, also install eth-node as a dependency
sudo apt install eth-node-monitoring-influxdb
# Install grafana as a dependency and configure it against eth-node, also Install eth-node as a dependency
sudo apt install eth-node-monitoring-grafana
# Install nginx as a dependency and configure it against eth-node, also install eth-node as a dependency
sudo apt install eth-node-api-nginx
# Install tor as a dependency and configure it against eth-node, also install eth-node as a dependency
sudo apt install eth-node-api-tor
# Install dshackle as a dependency and configure it against eth-node, also install eth-node as a dependency
sudo apt install eth-node-api-dshackle
# Install haproxy as a dependency and configure it against eth-node, also install eth-node as a dependency
sudo apt install eth-node-api-haproxy
# Install certbot as a dependency and configure it against eth-node, also install eth-node as a dependency
sudo apt install eth-node-api-certbot

# OR 
sudo apt install eth-node-monitoring
# OR 
sudo apt install eth-node-api
```

## What is missing 

Tasks will be added onto roadmap: https://github.com/eth-pkg/eth-deb/milestone/3


# 4. Additional distribution support

## What is done

Nothing is done on this front. I did build packages for Debian 10 and Debian 11, Debian 11 has some packaging caveats, that are not working as well as on latest Debian version.

## What is missing

Tasks will be added onto roadmap: https://github.com/eth-pkg/eth-deb/milestone/4


## Deliverable
* Ubuntu LTS packages (Same as above, eth-node builds, eth-node configuration builds, eth-node add-ons)
* Debian 11 packages (Same as above, eth-node builds, eth-node configuration builds, eth-node add-ons)
* Fedora support (Same as above but for Fedora latest, eth-node builds, eth-node configuration builds, eth-node add-ons). Note for fedora, the reproducibility is not researched, but I expect that similar approach as debian can be implemented, with both the pkgbuilder and sbuild.



# Research 

See tasks under roadmap: https://github.com/eth-pkg/eth-deb/milestone/3
