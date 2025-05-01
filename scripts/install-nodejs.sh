#!/bin/bash

echo "EthNodes Node.js LTS Installer"
echo "=============================="
echo "Installing Node.js LTS version..."

sudo apt-get install -y curl

curl -fsSL https://deb.nodesource.com/setup_lts.x -o nodesource_setup.sh
sudo -E bash nodesource_setup.sh

sudo apt-get install -y nodejs

echo "Verifying Node.js installation..."
node -v
npm -v

echo "Node.js installation complete!"
