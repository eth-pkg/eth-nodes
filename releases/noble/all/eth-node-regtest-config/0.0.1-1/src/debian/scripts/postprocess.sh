#!/bin/bash
set -e

get_debconf_value() {
    local package=$1
    local key=$2
    
    debconf-show "$package" | grep "$key" | awk -F ': ' '{print $2}'
}

setup_defaults(){
    echo <<EOF >>config/defaults.env
    export PRESET_BASE="${PRESET_BASE:-mainnet}"
export CHAIN_ID="${CHAIN_ID:-1337}"
export DEPOSIT_CONTRACT_ADDRESS="${DEPOSIT_CONTRACT_ADDRESS:-0x4242424242424242424242424242424242424242}"
export EL_AND_CL_MNEMONIC="${EL_AND_CL_MNEMONIC:-sleep moment list remain like wall lake industry canvas wonder ecology elite duck salad naive syrup frame brass utility club odor country obey pudding}"
# additional validator, already deposited 32 eth
export CL_ADDITIONAL_VALIDATORS="additional_validators.txt"
export CL_EXEC_BLOCK="${CL_EXEC_BLOCK:-0}"
export SLOT_DURATION_IN_SECONDS="${SLOT_DURATION_IN_SECONDS:-12}"
export DEPOSIT_CONTRACT_BLOCK="${DEPOSIT_CONTRACT_BLOCK:-0x0000000000000000000000000000000000000000000000000000000000000000}"
export NUMBER_OF_VALIDATORS="${NUMBER_OF_VALIDATORS:-320}"
export GENESIS_FORK_VERSION="${GENESIS_FORK_VERSION:-0x10000000}"
export ALTAIR_FORK_VERSION="${ALTAIR_FORK_VERSION:-0x20000000}"
export BELLATRIX_FORK_VERSION="${BELLATRIX_FORK_VERSION:-0x30000000}"
export CAPELLA_FORK_VERSION="${CAPELLA_FORK_VERSION:-0x40000000}"
export DENEB_FORK_VERSION="${DENEB_FORK_VERSION:-0x50000000}"
export ELECTRA_FORK_VERSION="${ELECTRA_FORK_VERSION:-0x60000000}"
export ELECTRA_FORK_EPOCH="${ELECTRA_FORK_EPOCH:-2000}"
export EIP7594_FORK_VERSION="${EIP7594_FORK_VERSION:-0x70000000}"
export EIP7594_FORK_EPOCH="${EIP7594_FORK_EPOCH:-99999}"
#export EOF_ACTIVATION_EPOCH="${EOF_ACTIVATION_EPOCH:-99999}"
export WITHDRAWAL_TYPE="${WITHDRAWAL_TYPE:-0x00}"
export WITHDRAWAL_ADDRESS="${WITHDRAWAL_ADDRESS:-0xf97e180c050e5Ab072211Ad2C213Eb5AEE4DF134}"
export BEACON_STATIC_ENR="${BEACON_STATIC_ENR:-enr:-Iq4QJk4WqRkjsX5c2CXtOra6HnxN-BMXnWhmhEQO9Bn9iABTJGdjUOurM7Btj1ouKaFkvTRoju5vz2GPmVON2dffQKGAX53x8JigmlkgnY0gmlwhLKAlv6Jc2VjcDI1NmsxoQK6S-Cii_KmfFdUJL2TANL3ksaKUnNXvTCv1tLwXs0QgIN1ZHCCIyk}"
export SHADOW_FORK_RPC="${SHADOW_FORK_RPC:-}" # http://docker.for.mac.localhost:8545
export SHADOW_FORK_FILE="${SHADOW_FORK_FILE:-}" # /config/el/latest_block.json
export GENESIS_TIMESTAMP="${GENESIS_TIMESTAMP:-0}"
export GENESIS_DELAY="${GENESIS_DELAY:-60}"
export GENESIS_GASLIMIT="${GENESIS_GASLIMIT:-25000000}"
export MAX_PER_EPOCH_ACTIVATION_CHURN_LIMIT="${MAX_PER_EPOCH_ACTIVATION_CHURN_LIMIT:-8}"
export CHURN_LIMIT_QUOTIENT="${CHURN_LIMIT_QUOTIENT:-65536}"
export EJECTION_BALANCE="${EJECTION_BALANCE:-16000000000}"
export ETH1_FOLLOW_DISTANCE="${ETH1_FOLLOW_DISTANCE:-2048}"
export MIN_VALIDATOR_WITHDRAWABILITY_DELAY="${MIN_VALIDATOR_WITHDRAWABILITY_DELAY:-256}"
export SHARD_COMMITTEE_PERIOD="${SHARD_COMMITTEE_PERIOD:-256}"
export SAMPLES_PER_SLOT="${SAMPLES_PER_SLOT:-8}"
export CUSTODY_REQUIREMENT="${CUSTODY_REQUIREMENT:-4}"
export DATA_COLUMN_SIDECAR_SUBNET_COUNT="${DATA_COLUMN_SIDECAR_SUBNET_COUNT:-128}"
export MAX_BLOBS_PER_BLOCK="${MAX_BLOBS_PER_BLOCK:-6}"
export EL_PREMINE_ADDRS="${EL_PREMINE_ADDRS:-"{}"}"
export ADDITIONAL_PRELOADED_CONTRACTS="${ADDITIONAL_PRELOADED_CONTRACTS:-"{}"}" # '{"0x123463a4B065722E99115D6c222f267d9cABb524": {"balance": "1ETH","code": "0x123465","storage": {},"nonce": 0,"secretKey": "0x"}}'
EOF
}

setup_package(){
    echo "Creating user and group eth-node-regtest"
    adduser --system --quiet --group eth-node-regtest || true

    package=eth-node-regtest-config
    value=BASE_CONFIG_SECRETS_FILE
    jwt_file=$(get_debconf_value $package $package/$value)

    if [ -z "$jwt_file" ];then 
        jwt_file="/etc/eth-node-regtest/jwt.hex"
    fi 

    mkdir -p $(dirname $jwt_file)
    touch $jwt_file

    if [ ! -f "$jwt_file" ] || [ ! -s "$jwt_file" ]; then
        openssl rand -hex 32 | tr -d "\n" | tee "$jwt_file" >/dev/null
    fi

    chmod 750 $jwt_file

}

generate_testnet(){
    echo "Generating testnet"

    tmp_dir=$(mktemp -d)

    cd "$tmp_dir"
    mkdir config
    setup_defaults
    cp -R /etc/eth-node-regtest-config/config . 
    ls -al config
    ethereum-genesis-generator all 

    mkdir -p /var/lib/eth-node-regtest/regtest

    # lighthouse validator import expects deploy_block instead of deposit_contract_block.txt
    cp data/metadata/deposit_contract_block.txt data/metadata/deploy_block.txt

    cp -R data/jwt /var/lib/eth-node-regtest/regtest
    cp -R data/metadata /var/lib/eth-node-regtest/regtest
    cp -R data/parsed /var/lib/eth-node-regtest/regtest

    mv /var/lib/eth-node-regtest/regtest/metadata /var/lib/eth-node-regtest/regtest/genesis

    chown -R eth-node-regtest:eth-node-regtest /etc/eth-node-regtest 
}

remove_regtest(){
    rm -rf /var/lib/eth-node-regtest/regtest
}

if [ "$1" = "configure" ] || [ "$#" -eq 0 ]; then
    echo "Installing or upgrading the package."
    remove_regtest
    setup_package
    generate_testnet
fi


if [ "$1" = "remove" ]; then
    echo "Removing the package."
    remove_regtest
fi


exit 0
