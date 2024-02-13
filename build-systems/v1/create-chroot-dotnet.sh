#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <codename> <arch>"
    exit 1
fi

CODENAME="$1"
ARCH="$2"
CHROOT_PREFIX="$CODENAME-$ARCH-dotnet"
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

# Download and install Microsoft package
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo cp packages-microsoft-prod.deb "/srv/chroot/$CHROOT_PREFIX/root/"
sudo chroot "/srv/chroot/$CHROOT_PREFIX" dpkg -i /root/packages-microsoft-prod.deb
sudo rm "/srv/chroot/$CHROOT_PREFIX/root/packages-microsoft-prod.deb"