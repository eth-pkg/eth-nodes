#!/bin/bash

DATE=$(date +%Y%m%d)
S3_BUCKET="https://s3.eu-central-1.amazonaws.com/eth-pkg.com/backup"
CODENAME=$(lsb_release -sc)
DEST="$S3_BUCKET/$CODENAME/$DATE"
WORK_DIR="/tmp/dotnet-deps"
APT_DIR="$WORK_DIR/apt"

download_deps() {
    local package=$1
    local download_dir=$2
    temp_dir=$(mktemp -d)
    cd "$temp_dir"

    apt-get download $package
    apt-get download $(apt-cache depends $package | grep -E 'Depends|Recommends|Suggests' | cut -d ':' -f 2 | tr -d '<>' | sed '/^$/d')

    for file in *.deb; do
        base_name=$(dpkg-deb -f $file Package | sed 's/-[0-9]\+\.[0-9]\+//')
        # version=$(dpkg-deb -f $file Version)
        # arch=$(dpkg-deb -f $file Architecture)
        # mv "$file" "${base_name}_${version}_${arch}.deb"
    done

    mv *.deb $download_dir/
}

produce_deps() {
    cd $APT_DIR
    printf '['
    for file in *; do
        if [ -f "$file" ]; then
            hash=$(sha1sum "$file" | cut -d' ' -f1)
            printf '{name="%s",hash="%s",url="%s/%s"},\n' \
                "${file%.deb}" "$hash" "$DEST" "$file"
        fi
    done
    printf ']'

}

mkdir -p $APT_DIR

download_deps "dotnet-sdk-9.0" $APT_DIR
download_deps "dotnet-hostfxr-9.0" $APT_DIR
produce_deps 

aws s3 cp $APT_DIR s3://eth-pkg.com/backup/$CODENAME/$DATE --recursive
# rm -rf $WORK_DIR
