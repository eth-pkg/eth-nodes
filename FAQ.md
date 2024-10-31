# Node running 


## Supported networks

- mainnet
- sepolia
- holesky
- ephemery
- regtest

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
sudo apt install -y eth-node-regtest
# or with validator 
sudo apt install -y eth-node-regtest eth-node-regtest-validator

``` 

## To install a node with one client given, but the other randomly

```bash
sudo apt install -y eth-node-regtest eth-node-reth
```

## To install a node, but both clients as given

```bash
sudo apt install -y eth-node-regtest eth-node-reth eth-node-teku
```

## To reinstall a node, but with two different clients

```bash
sudo apt remove -y eth-node-reth-regtest eth-node-teku-regtest

sudo apt install -y eth-node-reth-regtest eth-node-teku-regtest
```

## To reinstall a node, but with only changing one client

```bash
sudo apt remove -y eth-node-reth-regtest
# This will only work if you didn't install multiple consensus clients before
# same for execution clients
sudo apt install -y eth-node-config-regtest-besu
```

## Check if services are up 

```bash 
# Short form 
systemctl is-active eth-node-reth-regtest.service
systemctl is-active eth-node-teku-regtest.service

# Long form
systemctl status eth-node-reth-mainnet.service
systemctl status eth-node-teku-mainnet.service
```

## Check logs for running services

```bash
journalctl -u eth-node-reth-mainnet.service | less -S
journalctl -u eth-node-teku-mainnet.service | less -S
```

## Run client scripts manually, in case systemd.d service halted with error

```bash
sudo -u eth-node-besu-regtest besu \
       --config-file=/etc/eth-node-besu-regtest/besu-regtest.conf
```

```bash
sudo -u eth-node-erigon-regtest erigon \
       --config=/etc/eth-node-erigon-regtest/erigon-regtest.conf
```

```bash
sudo -u eth-node-reth-regtest reth \
       --conf-file /etc/eth-node-reth-regtest/reth-regtest.conf
```

## Run validator scripts manually, in case systemd.d service halted with error

```bash
sudo -u eth-node-teku-validator-regtest  teku \
       --config-file /etc/eth-node-teku-validator-regtest/teku-validator-regtest.toml
```

## View logs

```bash 
#sudo -u eth-node-<client>-<network> ls /var/logs/eth-node-<network>/<client>
sudo -u eth-node-teku-regtest ls /var/logs/eth-node-regtest/teku
```

### Todo elements

- [ ] creating groups for networks (sudo groupadd eth-node-regtest)
- [ ] add service users to newtork groups (sudo usermod -aG eth-node-regtest eth-node-regtest-reth)