#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <codename> <arch>"
    exit 1
fi

CODENAME="$1"
ARCH="$2"
CHROOT_PREFIX="$CODENAME-$ARCH-node"
SRV_PREFIX=/srv/chroot/"$CHROOT_PREFIX"

# Clean up previous chroots
sudo rm -rf "/etc/sbuild/chroot/$CHROOT_PREFIX"
sudo rm -rf "/etc/schroot/chroot.d/${CHROOT_PREFIX}"*
sudo rm -rf "/srv/chroot/$CHROOT_PREFIX"

# Create new chroot
sudo sbuild-createchroot --merged-usr \
                         --include="apt-transport-https ca-certificates curl gnupg" \
                         --chroot-prefix="$CHROOT_PREFIX" \
                         "$CODENAME" "$SRV_PREFIX" \
                         http://deb.debian.org/debian


# Install Node.js in the chroot environment
# Should be working but is not
sudo chroot "$SRV_PREFIX" /bin/bash -c 
'curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs
npm install --global yarn'

# Add docker for the tests
sudo chroot "$SRV_PREFIX" /bin/bash -c '
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc'

# Add the repository to Apt sources:
sudo chroot "$SRV_PREFIX" /bin/bash -c '
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update'