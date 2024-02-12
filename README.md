# Ethereum Node Packaging

This project is designed to simplify the process of packaging different Ethereum nodes for Debian-based systems. It provides a structured way to create Debian packages for multiple Ethereum clients. 

## Usage

### Build debian packages

#### Create sbuild env 

Sbuild env
```bash
CODENAME=bookworm
ARCH=amd64
SBUILD_TARBALL=/srv/chroot/$(CODENAME)-$(ARCH).tar.gz
sudo sbuild-createchroot --merged-usr \
                         --make-sbuild-tarball=$(SBUILD_TARBALL) \
                         --chroot-prefix=node-chroot \
                         $(CODENAME) \
                         `mktemp -d`\
                         http://deb.debian.org/debian 

```

Sbuild env for dotnet/nethermind
```bash
CODENAME=bookworm
ARCH=amd64
SBUILD_TARBALL=/srv/chroot/$(CODENAME)-$(ARCH).tar.gz
sudo sbuild-createchroot --merged-usr \
                         --extra-repository="$backports_repo_url" \
                         --keyring="$keyring_file" \
                         --make-sbuild-tarball=$(SBUILD_TARBALL) \
                         --chroot-prefix=node-chroot \
                         $(CODENAME) \
                         `mktemp -d`\
                         http://deb.debian.org/debian 

```


Sbuild env for node.js/lodestar
```bash
# To delete previous chroots
sudo rm -rf /etc/sbuild/chroot/$CHROOT_PREFIX
sudo rm -rf "/etc/schroot/chroot.d/${CHROOT_PREFIX}"*
sudo rm -rf /srv/chroot/$CHROOT_PREFIX

CODENAME=bookworm
ARCH=amd64
CHROOT_PREFIX="$CODENAME-$ARCH-plus-node-repo"
nodesource_repo_url="deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_21.x nodistro main"

sudo sbuild-createchroot --merged-usr \
                         --include="ca-certificates" \
                         --chroot-prefix="$CHROOT_PREFIX" \
                         "$CODENAME" /srv/chroot/"$CHROOT_PREFIX"\
                         http://deb.debian.org/debian 

echo "$nodesource_repo_url" | sudo tee /srv/chroot/$CHROOT_PREFIX/etc/apt/sources.list.d/nodesource.list > /dev/null
curl -fsSL "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" | gpg --dearmor | sudo tee /srv/chroot/"$CHROOT_PREFIX"/etc/apt/trusted.gpg.d/nodesource.gpg > /dev/null
echo "Package: nsolid" | sudo tee /srv/chroot/$CHROOT_PREFIX/etc/apt/preferences.d/nsolid > /dev/null
echo "Pin: origin deb.nodesource.com" | sudo tee -a /srv/chroot/$CHROOT_PREFIX/etc/apt/preferences.d/nsolid > /dev/null
echo "Pin-Priority: 600" | sudo tee -a /srv/chroot/$CHROOT_PREFIX/etc/apt/preferences.d/nsolid > /dev/null
echo "Package: nodejs" | sudo tee /srv/chroot/$CHROOT_PREFIX/etc/apt/preferences.d/nodejs > /dev/null
echo "Pin: origin deb.nodesource.com" | sudo tee -a /srv/chroot/$CHROOT_PREFIX/etc/apt/preferences.d/nodejs > /dev/null
echo "Pin-Priority: 600" | sudo tee -a /srv/chroot/$CHROOT_PREFIX/etc/apt/preferences.d/nodejs > /dev/null


```

**Build the Debian Packages**: Build Debian packages for each client using the generated variables.
   ```bash
   make build PACKAGE=eth-node VERSION=0.1-1
   make build PACKAGE=eth-node-besu VERSION=23.10.1-1
   make build PACKAGE=eth-node-erigon VERSION=2.53.2-1
   make build PACKAGE=eth-node-geth VERSION=1.13.4-1
   make build PACKAGE=eth-node-lighthouse VERSION=4.5.0-1
   make build PACKAGE=eth-node-lodestar VERSION=1.11.3-1
   make build PACKAGE=eth-node-nethermind VERSION=1.21.1-1
   make build PACKAGE=eth-node-nimbus-eth2 VERSION=23.10.0-1
   make build PACKAGE=eth-node-prysm VERSION=4.1.1-1
   make build PACKAGE=eth-node-service VERSION=0.1-1
   make build PACKAGE=eth-node-teku VERSION=23.10.0-1

   ```
  This will generate the appropiate .deb files for each package.


