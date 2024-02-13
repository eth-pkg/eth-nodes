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
sudo chroot "/srv/chroot/$CHROOT_PREFIX" /bin/bash -c 'curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && apt-get install -y nodejs'
sudo chroot "/srv/chroot/$CHROOT_PREFIX" /bin/bash -c 'npm install --global yarn'
