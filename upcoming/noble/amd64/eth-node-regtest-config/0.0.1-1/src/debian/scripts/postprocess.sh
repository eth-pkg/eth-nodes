#!/bin/bash
set -e

get_debconf_value() {
    local package=$1
    local key=$2
    
    debconf-show "$package" | grep "$key" | awk -F ': ' '{print $2}'
}

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

tmp_dir=$(mktemp -d)

cd "$tmp_dir"
cp -R /etc/ethereum-genesis-generator . 
ethereum-genesis-generator all 

rm -rf /var/lib/eth-node-regtest/regtest/jwt
rm -rf /var/lib/eth-node-regtest/regtest/genesis
rm -rf /var/lib/eth-node-regtest/regtest/metadata
rm -rf /var/lib/eth-node-regtest/regtest/parsed

cp -R data/jwt /var/lib/eth-node-regtest/regtest
cp -R data/metadata /var/lib/eth-node-regtest/regtest
cp -R data/parsed /var/lib/eth-node-regtest/regtest

mv /var/lib/eth-node-regtest/regtest/metadata /var/lib/eth-node-regtest/regtest/genesis

chown -R eth-node-regtest:eth-node-regtest /etc/eth-node-regtest 

exit 0
