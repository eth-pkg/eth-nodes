#!/bin/bash
set -e

get_debconf_value() {
    local package=$1
    local key=$2

    debconf-show "$package" | grep "$key" | awk -F ': ' '{print $2}'
}

setup_package() {
    echo "Creating user and group eth-node-regtest"
    adduser --system --quiet --group eth-node-regtest || true

    package=eth-node-regtest-config
    value=BASE_CONFIG_SECRETS_FILE
    jwt_file=$(get_debconf_value $package $package/$value)

    if [ -z "$jwt_file" ]; then
        jwt_file="/etc/eth-node-regtest/jwt.hex"
    fi

    mkdir -p $(dirname $jwt_file)
    touch $jwt_file

    if [ ! -f "$jwt_file" ] || [ ! -s "$jwt_file" ]; then
        openssl rand -hex 32 | tr -d "\n" | tee "$jwt_file" >/dev/null
    fi

    chmod 750 $jwt_file
    chown -R eth-node-regtest:eth-node-regtest /etc/eth-node-regtest

}

generate_testnet() {
    echo "Generating testnet"

    tmp_dir=$(mktemp -d)

    cd "$tmp_dir"
    ## patch time
    export GENESIS_TIMESTAMP=$(date +%s)
    # ethereum-genesis-generator all \
    #     --values-env /etc/eth-node-regtest/config/values.env --config-dir /etc/eth-node-regtest/config --data-dir data

    mkdir data
    docker run --rm -t -u $UID -v $PWD/data:/data \
        -v /etc/eth-node-regtest/config/values.env:/config/values.env \
        -e GENESIS_TIMESTAMP="$GENESIS_TIMESTAMP" \
        ethpandaops/ethereum-genesis-generator:master all

    mkdir -p /var/lib/eth-node-regtest/regtest

    # lighthouse validator import expects deploy_block instead of deposit_contract_block.txt
    cp data/metadata/deposit_contract_block.txt data/metadata/deploy_block.txt

    cp -R data/jwt /var/lib/eth-node-regtest/regtest
    cp -R data/metadata /var/lib/eth-node-regtest/regtest
    cp -R data/parsed /var/lib/eth-node-regtest/regtest

    mv /var/lib/eth-node-regtest/regtest/metadata /var/lib/eth-node-regtest/regtest/genesis

}

remove_regtest() {
    rm -rf /var/lib/eth-node-regtest/regtest
}

if [ "$1" = "configure" ] || [ "$#" -eq 0 ]; then
    echo "Installing or upgrading the package."
    remove_regtest
    setup_package
fi

if [ "$1" = "postinst" ] || [ "$#" -eq 0 ]; then
    echo "Installing or upgrading the package."
    generate_testnet
fi

if [ "$1" = "remove" ]; then
    echo "Removing the package."
    remove_regtest
fi

exit 0
