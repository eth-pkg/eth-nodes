#!/usr/bin/env bash 

set -e -pipefail


CONF_FILE=/etc/eth-node-testnet-service-besu/service.conf
shared_file=$(sed -n 's/^shared_file=\(.*\)$/\1/p' "$CONF_FILE")
client_config=$(sed -n 's/^client_config=\(.*\)$/\1/p' "$CONF_FILE")

exec /usr/lib/eth-node-config-testnet/bin/run-besu.sh --conf-file shared_file --conf-file client_config