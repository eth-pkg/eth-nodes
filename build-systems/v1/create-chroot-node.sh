#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <codename> <arch>"
    exit 1
fi

CODENAME="$1"
ARCH="$2"
CHROOT_PREFIX="$CODENAME-$ARCH-node"
# NODESOURCE_REPO_URL="deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/nodesource.gpg] https://deb.nodesource.com/node_21.x nodistro main"

# Clean up previous chroots
sudo rm -rf "/etc/sbuild/chroot/$CHROOT_PREFIX"
sudo rm -rf "/etc/schroot/chroot.d/${CHROOT_PREFIX}"*
sudo rm -rf "/srv/chroot/$CHROOT_PREFIX"

# Create new chroot
sudo sbuild-createchroot --merged-usr \
                         --include="ca-certificates" \
                         --chroot-prefix="$CHROOT_PREFIX" \
                         "$CODENAME" "/srv/chroot/$CHROOT_PREFIX" \
                         http://deb.debian.org/debian

# # Configure NodeSource repository
# echo "$NODESOURCE_REPO_URL" | sudo tee "/srv/chroot/$CHROOT_PREFIX/etc/apt/sources.list.d/nodesource.list" > /dev/null
# curl -fsSL "https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key" | gpg --dearmor | sudo tee "/srv/chroot/$CHROOT_PREFIX/etc/apt/trusted.gpg.d/nodesource.gpg" > /dev/null

# # Configure package preferences
# echo -e "Package: nsolid\nPin: origin deb.nodesource.com\nPin-Priority: 600" | sudo tee "/srv/chroot/$CHROOT_PREFIX/etc/apt/preferences.d/nsolid" > /dev/null
# echo -e "Package: nodejs\nPin: origin deb.nodesource.com\nPin-Priority: 600" | sudo tee "/srv/chroot/$CHROOT_PREFIX/etc/apt/preferences.d/nodejs" > /dev/null

# Install Node.js in the chroot environment
sudo chroot "/srv/chroot/$CHROOT_PREFIX" /bin/bash -c 'curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash - && sudo apt-get install -y nodejs'
