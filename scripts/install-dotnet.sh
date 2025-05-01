#!/bin/bash

echo "EthNodes .NET 9 Installer"
echo "========================="

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
    VERSION_ID=$VERSION_ID
fi

echo "Detected distribution: $DISTRO $VERSION_ID"

if [ "$DISTRO" = "debian" ] || [ "$DISTRO" = "bookworm" ]; then
    echo "Installing .NET for Debian..."

    wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt-get update
    sudo apt-get install -y aspnetcore-runtime-9.0
else
    echo "Installing .NET for Ubuntu..."

    sudo add-apt-repository ppa:dotnet/backports
    sudo apt-get update
    sudo apt-get install -y aspnetcore-runtime-9.0
fi

echo "Verifying .NET installation..."
dotnet --list-runtimes

echo ".NET 9 installation complete!"
