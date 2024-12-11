#!/bin/bash

# Directory for downloads
DOWNLOAD_DIR="~/.pkg-builder/dotnet"
mkdir -p "$DOWNLOAD_DIR"

#!/bin/bash

# Directory for downloads
DOWNLOAD_DIR="./packages"
mkdir -p "$DOWNLOAD_DIR"

PACKAGES=(
    "netstandard-targeting-pack"
    "dotnet-targeting-pack"
    "dotnet-runtime-deps"
    "dotnet-host"
    "dotnet-hostfxr"
    "dotnet-runtime"
    "aspnetcore-targeting-pack"
    "aspnetcore-runtime"
    "dotnet-sdk"
)
DOWNLOAD_DIR=~/.pkg-builder/dotnet
mkdir -p $DOWNLOAD_DIR
for package in "${PACKAGES[@]}"; do
    package_name=$(apt search "$package" 2>/dev/null | grep -o "^$package[^/]*" | sort -V | tail -n1)
    cd $DOWNLOAD_DIR && apt download $package_name
    cd -
done

# Iterate over all files in current directory
for file in "$DOWNLOAD_DIR"/*.deb; do
    if [ -f "$file" ]; then
        hash=$(shasum $file | cut -d' ' -f1)
        filename=$(basename $file)
        name="${filename%%_*}"
        url="https://s3.eu-central-1.amazonaws.com/eth-pkg.com/backup/20241212/$filename"
        echo "{ name = \"$filename\", hash = \"$hash\", url=\"$url\"},"
    fi
done