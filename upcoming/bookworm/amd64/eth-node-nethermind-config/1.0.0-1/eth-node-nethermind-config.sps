name = "eth-node-nethermind-config"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-el-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-nethermind.sh /usr/lib/eth-node-nethermind-config/bin/",
    "debian/conf.d /etc/eth-node-nethermind-config"
]
add_links = ["/usr/lib/eth-node-nethermind-config/bin/run-nethermind.sh /usr/bin/run-nethermind.sh"]
add_manpages = []
summary = "Simple config and run script to run nethermind through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-nethermind-config
By installing this package,
it will automatically it will install run-nethermind.sh script and 
nethermind minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up nethermind. 
See eth-node-[network]-service-nethermind package for how that is working.
"""
