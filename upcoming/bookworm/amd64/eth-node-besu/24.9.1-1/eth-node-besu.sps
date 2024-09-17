name = "eth-node-besu"
architecture = "any"
summary = "Besu is an Apache 2.0 licensed, MainNet compatible, Ethereum client written in Java."
conflicts = []
recommends = []
provides = ["eth-node-execution-client (= 1)"]
suggests = ["eth-node (= 1)"]
add_files = ["build/install/besu /usr/lib/eth-node-besu"]
add_links = ["/usr/lib/eth-node-besu/besu/bin/besu /usr/bin/besu"]
add_manpages = []
long_doc = """
Hyperledger Besu is an Ethereum client designed to be enterprise-friendly for both public and private permissioned network use cases, with an extractable EVM implementation. It can also be run on test networks such as Sepolia and Görli. Hyperledger Besu includes several consensus algorithms including Proof of Stake, Proof of Work, and Proof of Authority (IBFT 2.0, QBFT, and Clique). Its comprehensive permissioning schemes are designed specifically for use in a consortium environment.
"""
