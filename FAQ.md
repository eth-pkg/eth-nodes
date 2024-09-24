# Node running 


## Supported networks

- mainnet
- sepolia
- holesky
- ephemery
- testnet

## Supported clients

Supported execution clients
- besu
- erigon
- geth
- nethermind
- reth 

Suppported consensus clients
- lighthouse
- lodestar
- nimbus-eth2
- prysm
- teku

## To install a node 

```bash
sudo apt install -y eth-node-testnet
# or with validator 
sudo apt install -y eth-node-testnet eth-node-testnet-validator

``` 

## To install a node with one client given, but the other randomly

```bash
sudo apt install -y eth-node-testnet eth-node-reth
```

## To install a node, but both clients as given

```bash
sudo apt install -y eth-node-testnet eth-node-reth eth-node-teku
```

## To reinstall a node, but with two different clients

```bash
sudo apt remove -y eth-node-reth-testnet eth-node-teku-testnet

sudo apt install -y eth-node-reth-testnet eth-node-teku-testnet
```

## To reinstall a node, but with only changing one client

```bash
sudo apt remove -y eth-node-reth-testnet
# This will only work if you didn't install multiple consensus clients before
# same for execution clients
sudo apt install -y eth-node-config-testnet-besu
```

## Check if services are up 

```bash 
# Short form 
systemctl is-active eth-node-reth-testnet.service
systemctl is-active eth-node-teku-testnet.service

# Long form
systemctl status eth-node-reth-mainnet.service
systemctl status eth-node-teku-mainnet.service
```

## Check logs for running services

```bash
journalctl -u eth-node-reth-mainnet.service | less -S
journalctl -u eth-node-teku-mainnet.service | less -S
```

## Run client scripts manually, in case systemd.d service halted with seccomp error

```bash
sudo -u eth-node-reth-testnet  /bin/bash /usr/lib/eth-node-reth-testnet/bin/run-reth.sh \
       --conf-file /etc/eth-node-testnet-config/testnet.conf \
       --conf-file /etc/eth-node-reth-testnet/reth-testnet.conf
```

## Run validator scripts manually, in case systemd.d service halted with seccomp error

```bash
sudo -u eth-node-teku-validator-testnet  /bin/bash /usr/lib/eth-node-teku-validator-testnet/bin/run-teku-validator.sh \
       --conf-file /etc/eth-node-testnet-config/testnet.conf \
       --conf-file /etc/eth-node-teku-validator-testnet/teku-validator-testnet.conf
```

### Todo elements

- [ ] creating groups for networks (sudo groupadd eth-node-testnet)
- [ ] add service users to newtork groups (sudo usermod -aG eth-node-testnet eth-node-testnet-reth)