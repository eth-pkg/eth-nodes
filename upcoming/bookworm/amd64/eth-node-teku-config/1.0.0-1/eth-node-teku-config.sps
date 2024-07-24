name = "eth-node-ligthhouse-config"
architecture = "any"
conflicts = []
recommends = []
provides = ["eth-node-cl-config"]
suggests = []
depends=[]
add_files = [
    "debian/scripts/run-teku.sh /usr/lib/eth-node-ligthhouse-config/bin/",
    "debian/conf.d /etc/eth-node-teku-config"
]
add_links = ["/usr/lib/eth-node-ligthhouse-config/bin/run-ligthhouse.sh /usr/bin/run-teku.sh"]
add_manpages = []
summary = "Simple config and run script to run ligthhouse through standardized config files, based on eth-pkg/run-a-node"
long_doc = """eth-node-ligthhouse-config
By installing this package,
it will automatically it will install run-ligthhouse.sh script and 
ligthhouse minimal configs for each supported network, which you can use in tandem
with eth-node-[network]-config to spin up ligthhouse. 
See eth-node-[network]-service-ligthhouse package for how that is working.
"""