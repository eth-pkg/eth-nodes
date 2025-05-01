#!/bin/bash

echo "EthNodes Java 21 Installer"
echo "=========================="
echo "Installing Oracle JDK 21..."

sudo apt -y install wget curl

wget https://download.oracle.com/java/21/archive/jdk-21.0.2_linux-x64_bin.deb
sudo apt install -y ./jdk-21.0.2_linux-x64_bin.deb
rm jdk-21.0.2_linux-x64_bin.deb

cat <<'EOF' | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-21/
export PATH=$PATH:$JAVA_HOME/bin
EOF

source /etc/profile.d/jdk.sh

sudo ln -s /usr/lib/jvm/jdk-21-oracle-x64 /usr/lib/jvm/jdk-21

echo "Verifying Java installation..."
java -version

echo "Java 21 installation complete!"
