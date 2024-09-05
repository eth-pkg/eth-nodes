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
sudo apt install -y eth-node-mainnet
``` 

## To install a node with one client given, but the other randomly

```bash
sudo apt install -y eth-node-mainnet eth-node-reth
```

## To install a node, but both clients as given

```bash
sudo apt install -y eth-node-mainnet eth-node-reth eth-node-teku
```

## To reinstall a node, but with two different clients

```bash
sudo apt remove -y eth-node-config-testnet-reth eth-node-config-testnet-teku

sudo apt install -y eth-node-config-testnet-reth eth-node-config-testnet-teku
```

## To reinstall a node, but with only changing one client

```bash
sudo apt remove -y eth-node-config-testnet-reth
# This will only work if you didn't install multiple consensus clients before
# same for execution clients
sudo apt install -y eth-node-config-testnet-besu
```

## Check if services are up 

```bash 
# Short form 
systemctl is-active eth-node-testnet-service-reth.service
systemctl is-active eth-node-testnet-service-teku.service

# Long form
systemctl status eth-node-mainnet-service-reth.service
systemctl status eth-node-mainnet-service-teku.service
```

## Check logs for running services

```bash
journalctl -u eth-node-mainnet-service-reth.service | less -S
journalctl -u eth-node-mainnet-service-teku.service | less -S
```

## Run scripts manually, in case systemd.d service halted with seccomp error

```bash
sudo -u eth-node-mainnet-reth  /bin/bash /usr/lib/eth-node-config-mainnet-reth/bin/run-reth.sh \
       --conf-file /etc/eth-node-mainnet/conf.d/mainnet.conf \
       --conf-file /etc/eth-node-mainnet/reth/conf.d/reth-mainnet.conf
```


### Todo elements

- [ ] creating groups for networks (sudo groupadd eth-node-testnet)
- [ ] add service users to newtork groups (sudo usermod -aG eth-node-testnet eth-node-testnet-reth)