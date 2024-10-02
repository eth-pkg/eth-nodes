name = "ethereum-genesis-generator"
architecture = "any"
summary = "Create a ethereum execution and consensus layer testnet genesis"
conflicts = []
recommends = []
provides = []
suggests = []
depends = [
  "python3", 
  "zcli", 
 "eth2-testnet-genesis",]
add_files = [
    "apps /usr/lib/ethereum-genesis-generator",
    "config /etc/ethereum-genesis-generator",
    "defaults /etc/ethereum-genesis-generator",
    "entrypoint.sh /usr/lib/ethereum-genesis-generator/bin"
    # "el-gen /usr/lib/el-gen/bin",
]
add_links = ["/usr/lib/ethereum-genesis-generator/bin/entrypoint.sh /usr/bin/ethereum-genesis-generator"]
add_manpages = []
long_doc = """
Create a ethereum execution and consensus layer testnet genesis and expose it via a webserver for testing purposes 
"""