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
                         --include="ca-certificates wget apt-utils mlocate" \
                         --chroot-prefix="$CHROOT_PREFIX" \
                         "$CODENAME" "/srv/chroot/$CHROOT_PREFIX" \
                         http://deb.debian.org/debian


sudo chroot $SRV_PREFIX /bin/bash -c '
java -version
wget https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz
tar -zxf jdk-17_linux-x64_bin.tar.gz
mkdir -p /opt/lib/jvm
mkdir -p /usr/lib/jvm
mv jdk-17.0.10 /opt/lib/jvm/jdk-17-oracle-x64
ls /opt/lib/jvm/jdk-17-oracle-x64
ln -s /opt/lib/jvm/jdk-17-oracle-x64  /usr/lib/jvm/jdk-17
cat <<EOF | tee /etc/profile.d/jdk.sh
export JAVA_HOME=/usr/lib/jvm/jdk-17
export PATH=\$PATH:\$JAVA_HOME/bin
EOF

mkdir -p /var/lib/plocate
updatedb
locate libjli.so
source /etc/profile.d/jdk.sh
/opt/lib/jvm/jdk-17-oracle-x64/bin/java -version
java -version
'
