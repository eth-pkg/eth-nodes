#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <codename> <arch>"
    exit 1
fi

CODENAME="$1"
ARCH="$2"
CHROOT_PREFIX="$CODENAME-$ARCH-no-deps"

# Clean up previous chroots
sudo rm -rf "/etc/sbuild/chroot/$CHROOT_PREFIX"
sudo rm -rf "/etc/schroot/chroot.d/${CHROOT_PREFIX}"*
sudo rm -rf "/srv/chroot/$CHROOT_PREFIX"

# Create new chroot
sudo sbuild-createchroot --merged-usr \
                         --chroot-prefix="$CHROOT_PREFIX" \
                         "$CODENAME" "/srv/chroot/$CHROOT_PREFIX" \
                         http://deb.debian.org/debian
