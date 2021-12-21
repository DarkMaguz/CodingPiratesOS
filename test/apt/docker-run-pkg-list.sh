#!/bin/sh -e

wget http://ftp.dk.debian.org/debian/pool/main/liba/libappindicator/libappindicator3-1_0.4.92-7_amd64.deb
wget http://ftp.dk.debian.org/debian/pool/main/libi/libindicator/libindicator3-7_0.5.0-4_amd64.deb
dpkg -i libappindicator3-1_0.4.92-7_amd64.deb libindicator3-7_0.5.0-4_amd64.deb || true
apt-get install -f -y

echo "$KEYS" | tr ',' '\n' | while read key; do
  apt-key add $key
done

apt-get update

# echo "$PKG_LIST" | tr ',' '\n' | while read pkg; do
#   apt-get install --dry-run $pkg
# done
apt-get install -y --dry-run $PKG_LIST
