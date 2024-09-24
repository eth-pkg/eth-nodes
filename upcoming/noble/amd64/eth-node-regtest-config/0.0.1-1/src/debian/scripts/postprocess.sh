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

chown -R eth-node-regtest:eth-node-regtest /etc/eth-node-regtest 

exit 0
