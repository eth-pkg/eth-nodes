#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <codename> <arch>"
    exit 1
fi

CODENAME="$1"
ARCH="$2"
CHROOT_PREFIX="$CODENAME-$ARCH-no-deps"
SRV_PREFIX=/srv/chroot/$CHROOT_PREFIX


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


sudo chroot $SRV_PREFIX /bin/bash -c '
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.deb
sudo apt install ./jdk-17_linux-x64_bin.deb

cat <<EOF | sudo tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-17/
export PATH=\$PATH:\$JAVA_HOME/bin
EOF


source /etc/profile.d/jdk.sh
sudo ln -s /usr/lib/jvm/jdk-17-oracle-x64  /usr/lib/jvm/jdk-17
'
