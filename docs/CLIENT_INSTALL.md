# Individual Client Installation Guide


## Execution Clients

### Besu
Dependencies:
```bash
sudo apt -y install wget curl
wget https://download.oracle.com/java/21/archive/jdk-21.0.2_linux-x64_bin.deb
sudo apt install ./jdk-21.0.2_linux-x64_bin.deb

cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-21/
export PATH=$PATH:$JAVA_HOME/bin
EOF

source /etc/profile.d/jdk.sh
sudo ln -s /usr/lib/jvm/jdk-21-oracle-x64 /usr/lib/jvm/jdk-21
```

Installation:
```bash
sudo apt install eth-node-besu
```

### Erigon
```bash
sudo apt install eth-node-erigon
```

### Geth
```bash
sudo apt install eth-node-geth
```

### Nethermind
Dependencies:
```bash
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install -y aspnetcore-runtime-8.0
```

Installation:
```bash
sudo apt install eth-node-nethermind
```

### Reth
```bash
sudo apt install eth-node-reth
```

## Consensus Clients

### Lighthouse
```bash
sudo apt install eth-node-lighthouse
```

### Lodestar
Dependencies:
```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs
```

Installation:
```bash
sudo apt install eth-node-lodestar
```

### Nimbus-eth2
```bash
sudo apt install eth-node-nimbus-eth2
```

### Prysm
```bash
sudo apt install eth-node-prysm
```

### Teku
Dependencies:
```bash
sudo apt -y install wget curl
wget https://download.oracle.com/java/21/archive/jdk-21.0.2_linux-x64_bin.deb
sudo apt install ./jdk-21.0.2_linux-x64_bin.deb

cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-21/
export PATH=$PATH:$JAVA_HOME/bin
EOF

source /etc/profile.d/jdk.sh
sudo ln -s /usr/lib/jvm/jdk-21-oracle-x64 /usr/lib/jvm/jdk-21
```

Installation:
```bash
sudo apt install eth-node-teku
```

## Validator Clients

### Lighthouse Validator
```bash
sudo apt install eth-node-lighthouse-validator
```

### Lodestar Validator
Dependencies: Same as Lodestar consensus client
```bash
sudo apt install eth-node-lodestar-validator
```

### Nimbus-eth2 Validator
```bash
sudo apt install eth-node-nimbus-eth2-validator
```

### Prysm Validator
```bash
sudo apt install eth-node-prysm-validator
```

### Teku Validator
Dependencies: Same as Teku consensus client
```bash
sudo apt install eth-node-teku-validator
```