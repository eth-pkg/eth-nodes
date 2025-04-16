name = "eth-node-regtest-full"
architecture = "all"
summary = "regtest network for eth-nodes"
conflicts = ["eth-node-regtest"]
recommends = []
provides = ["eth-node", "eth-node-regtest"]
suggests = []
## There will be two packages, with all deps
## and with no deps
depends = [
    "eth-node-besu",
    "eth-node-erigon",
    "eth-node-geth",
    "eth-node-lighthouse",
    "eth-node-lodestar",
    "eth-node-nethermind",
    "eth-node-nimbus-eth2",
    "eth-node-prysm",
    "eth-node-reth",
    "eth-node-teku",
    "ethereum-genesis-generator (>=4.0.3-4)",
    "ntp"
]
add_files = []
add_links = []
add_manpages = []
long_doc = """eth-node-regtest
Package that install two random Ethereum consensus and execution client and
starts them running.
This package comes without validator. If you would like to have validator running
please install eth-node-regtest-with-validator instead.
This package contains all clients (el + cl) as hard dependency due to debian dependency
limitation doesn't allow to select interchangeable packages as dependency. 
"""
add_files = [
    ## package itself
    "debian/regtest /var/lib/eth-node-regtest",
    "debian/conf /etc/eth-node-regtest",
    "debian/scripts/postprocess.sh /usr/lib/eth-node-regtest",
    ## config
    "debian/regtest/regtest /var/lib/eth-node-regtest/regtest",
    "debian/regtest/config /etc/eth-node-regtest/regtest/",
    "debian/regtest/defaults /etc/eth-node-regtest/regtest/",
    ## besu (execution client)
    "debian/clients/besu/scripts/* /usr/lib/eth-node-regtest/besu",
    "debian/clients/besu/eth-node-besu-regtest.service /lib/systemd/system/",
    ## erigon (execution client)
    "debian/clients/erigon/scripts/* /usr/lib/eth-node-regtest/erigon",
    "debian/clients/erigon/eth-node-erigon-regtest.service /lib/systemd/system/",
    ## geth (execution client)
    "debian/clients/geth/scripts/* /usr/lib/eth-node-regtest/geth",
    "debian/clients/geth/eth-node-geth-regtest.service /lib/systemd/system/",
    ## nethermind (execution client)
    "debian/clients/nethermind/scripts/* /usr/lib/eth-node-regtest/nethermind",
    "debian/clients/nethermind/eth-node-nethermind-regtest.service /lib/systemd/system/",
    ## reth (execution client)
    "debian/clients/reth/scripts/* /usr/lib/eth-node-regtest/reth",
    "debian/clients/reth/eth-node-reth-regtest.service /lib/systemd/system/",
    ## lighthouse (consensus client)
    "debian/clients/lighthouse/scripts/* /usr/lib/eth-node-regtest/lighthouse",
    "debian/clients/lighthouse/eth-node-lighthouse-regtest.service /lib/systemd/system/",
    ## lighthouse validator
    "debian/clients/lighthouse-validator/scripts/* /usr/lib/eth-node-regtest/lighthouse-validator",
    "debian/clients/lighthouse-validator/eth-node-lighthouse-validator-regtest.service /lib/systemd/system/",
    "debian/clients/lighthouse-validator/validator /var/lib/eth-node-regtest/lighthouse-validator",
    ## lodestar (consensus client)
    "debian/clients/lodestar/scripts/* /usr/lib/eth-node-regtest/lodestar",
    "debian/clients/lodestar/eth-node-lodestar-regtest.service /lib/systemd/system/",
    ## lodestar validator
    "debian/clients/lodestar-validator/scripts/* /usr/lib/eth-node-regtest/lodestar-validator",
    "debian/clients/lodestar-validator/eth-node-lodestar-validator-regtest.service /lib/systemd/system/",
    "debian/clients/lodestar-validator/validator /var/lib/eth-node-regtest/lodestar-validator",
    ## nimbus-eth2 (consensus client)
    "debian/clients/nimbus-eth2/scripts/* /usr/lib/eth-node-regtest/nimbus-eth2",
    "debian/clients/nimbus-eth2/eth-node-nimbus-eth2-regtest.service /lib/systemd/system/",
    ## nimbus-eth2 validator
    "debian/clients/nimbus-eth2-validator/scripts/* /usr/lib/eth-node-regtest/nimbus-eth2-validator",
    "debian/clients/nimbus-eth2-validator/eth-node-nimbus-eth2-validator-regtest.service /lib/systemd/system/",
    "debian/clients/nimbus-eth2-validator/validator /var/lib/eth-node-regtest/nimbus-eth2-validator",
    ## prysm (consensus client)
    "debian/clients/prysm/scripts/* /usr/lib/eth-node-regtest/prysm",
    "debian/clients/prysm/eth-node-prysm-regtest.service /lib/systemd/system/",
    ## prysm validator
    "debian/clients/prysm-validator/scripts/* /usr/lib/eth-node-regtest/prysm-validator",
    "debian/clients/prysm-validator/eth-node-prysm-validator-regtest.service /lib/systemd/system/",
    "debian/clients/prysm-validator/validator /var/lib/eth-node-regtest/prysm-validator",
    ## teku (consensus client)
    "debian/clients/teku/scripts/* /usr/lib/eth-node-regtest/teku",
    "debian/clients/teku/eth-node-teku-regtest.service /lib/systemd/system/",
    ## teku validator
    "debian/clients/teku-validator/scripts/* /usr/lib/eth-node-regtest/teku-validator",
    "debian/clients/teku-validator/eth-node-teku-validator-regtest.service /lib/systemd/system/",
    "debian/clients/teku-validator/validator /var/lib/eth-node-regtest/teku-validator",
]
