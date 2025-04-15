#!/bin/bash
set -e

# Configuration variables
BASE_DIR="/var/lib/eth-node-regtest"
SCRIPTS_BASE_DIR="/usr/lib/eth-node-regtest"
LOG_DIR="/var/logs/eth-node-regtest"
CONFIG_DIR="/etc/eth-node-regtest"
REGTEST_DIR="${BASE_DIR}/regtest"
REGTEST_CONFIG_DIR="${CONFIG_DIR}/regtest/config"
DEFAULT_JWT_FILE="${CONFIG_DIR}/jwt.hex"
PACKAGE="eth-node-regtest-config"
JWT_VALUE_KEY="BASE_CONFIG_SECRETS_FILE"

# Helper functions
get_debconf_value() {
    local package=$1
    local key=$2
    debconf-show "$package" | grep "$key" | awk -F ': ' '{print $2}'
}

setup_clients() {
    local client=$1
    local group=$2
    local client_sub_dir=$3
    local client_dir="${BASE_DIR}/${client_sub_dir}"
    local client_log_dir="${LOG_DIR}/${client_sub_dir}"
    local client_user="eth-node-${client}-regtest"
    local group_name="eth-node-${group}-regtest"
    local scripts="$SCRIPTS_BASE_DIR/$client_sub_dir/*"

    echo "Creating ${client_dir} directory"
    mkdir -p "${client_dir}"
    echo "Setting ownership of ${client_dir} to ${client_user}:${group_name}"
    chown -R "${client_user}:${group_name}" "${client_dir}"

    mkdir -p "${client_log_dir}"
    chown -R "${client_user}:${group_name}" "${client_log_dir}"

    echo "Adding ${client_user} to eth-node-regtest group"
    usermod -aG eth-node-regtest "${client_user}" || true

    chmod a+x $scripts
}

setup_package() {
    echo "Creating user and group eth-node-regtest"
    adduser --system --quiet --group eth-node-regtest || true

    # Get JWT file path or use default
    jwt_file=$(get_debconf_value "${PACKAGE}" "${PACKAGE}/${JWT_VALUE_KEY}")
    if [ -z "$jwt_file" ]; then
        jwt_file="${DEFAULT_JWT_FILE}"
    fi

    mkdir -p "$(dirname "$jwt_file")"
    touch "$jwt_file"

    if [ ! -f "$jwt_file" ] || [ ! -s "$jwt_file" ]; then
        openssl rand -hex 32 | tr -d "\n" | tee "$jwt_file" >/dev/null
    fi

    chmod 750 "$jwt_file"
    chown -R eth-node-regtest:eth-node-regtest "${CONFIG_DIR}"
}

generate_testnet() {
    echo "Generating testnet"
    local tmp_dir=$(mktemp -d)
    local data_dir="${tmp_dir}/data"

    cd "$tmp_dir"

    # Set genesis timestamp
    export GENESIS_TIMESTAMP=$(date +%s)

    # Generate ethereum genesis
    ethereum-genesis-generator all \
        --values-env "${REGTEST_CONFIG_DIR}/values.env" \
        --config-dir "${REGTEST_CONFIG_DIR}" \
        --data-dir "${data_dir}"

    # Docker alternative (commented out)
    # mkdir -p "${data_dir}"
    # docker run --rm -t -u $UID -v "$PWD/${data_dir}:/${data_dir}" \
    #   -v "${REGTEST_CONFIG_DIR}/values.env:/config/values.env" \
    #   -e GENESIS_TIMESTAMP="$GENESIS_TIMESTAMP" \
    #   ethpandaops/ethereum-genesis-generator:master all

    mkdir -p "${REGTEST_DIR}"

    # Prepare lighthouse validator data
    cp "${data_dir}/metadata/deposit_contract_block.txt" "${data_dir}/metadata/deploy_block.txt"

    # Copy generated data to regtest directory
    cp -R "${data_dir}/jwt" "${REGTEST_DIR}"
    cp -R "${data_dir}/metadata" "${REGTEST_DIR}"
    cp -R "${data_dir}/parsed" "${REGTEST_DIR}"
    mv "${REGTEST_DIR}/metadata" "${REGTEST_DIR}/genesis"

    # Clean up and set permissions
    rm -rf "${tmp_dir}"
    chown -R eth-node-regtest:eth-node-regtest "${BASE_DIR}"
}

remove_regtest() {
    rm -rf "${BASE_DIR}"
}

# Main execution logic
if [ "$1" = "configure" ] || [ "$#" -eq 0 ]; then
    echo "Installing or upgrading the package."
    remove_regtest
    setup_package
fi

if [ "$1" = "postinst" ] || [ "$#" -eq 0 ]; then
    echo "Installing or upgrading the package."
    generate_testnet
    setup_clients "besu" "besu" "besu"
    setup_clients "lighthouse" "lighthouse" "lighthouse"
    setup_clients "lighthouse-val" "lighthouse-val" "lighthouse-validator"
fi

if [ "$1" = "remove" ]; then
    echo "Removing the package."
    remove_regtest
fi

exit 0
