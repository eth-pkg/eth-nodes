name = "ethereum-genesis-generator"
architecture = "any"
summary = "Create a ethereum execution and consensus layer testnet genesis"
conflicts = []
recommends = []
provides = []
suggests = []
depends = [
  "zcli (>=0.8.0)", 
  "eth2-testnet-genesis (>= 0.12.0)",
]
add_files = [
    "config-example /etc/ethereum-genesis-generator/config/",
    "apps/el-gen /usr/lib/ethereum-genesis-generator/apps/",
    "defaults /etc/ethereum-genesis-generator",
    "entrypoint.sh /usr/lib/ethereum-genesis-generator/bin",
    # "el-gen /usr/lib/el-gen/bin",
]
add_links = ["/usr/lib/ethereum-genesis-generator/bin/entrypoint.sh /usr/bin/ethereum-genesis-generator"]
add_manpages = []
long_doc = """
Create a ethereum execution and consensus layer testnet genesis and expose it via a webserver for testing purposes 
"""