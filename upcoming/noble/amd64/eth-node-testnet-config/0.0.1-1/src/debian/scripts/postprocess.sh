#!/bin/bash
set -e

get_debconf_value() {
    local package=$1
    local key=$2
    
    debconf-show "$package" | grep "$key" | awk -F ': ' '{print $2}'
}


package=eth-node-testnet-config
value=BASE_CONFIG_SECRETS_FILE
jwt_file=$(get_debconf_value $package $package/$value)

if [ -z "$jwt_file" ];then 
    jwt_file="/etc/eth-node-testnet/jwt.hex"
fi 

if [ ! -f "$jwt_file" ] || [ ! -s "$jwt_file" ]; then
    openssl rand -hex 32 | tr -d "\n" | tee "$jwt_file" >/dev/null
fi

chmod 750 $jwt_file

chown -R eth-node-testnet:eth-node-testnet /etc/eth-node-testnet 

exit 0
