name = "eth-node-config-nethermind"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-mainnet-el-config"]
suggests = []
depends=["eth-node-nethermind"]
add_files = [
    "debian/scripts/run-nethermind.sh /usr/lib/eth-node-config-nethermind/bin/",
    "debian/conf.d/nethermind-mainnet.conf /etc/eth-node-mainnet/nethermind/conf.d/"
]
add_links = []
add_manpages = []
summary = "Simple config and run script to run nethermind through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-config-nethermind
By installing this package,
it will automatically it will install run-nethermind.sh script and 
nethermind minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up nethermind. 
See eth-node-[network]-service-nethermind package for how that is working.
"""
