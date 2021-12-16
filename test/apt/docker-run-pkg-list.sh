#!/bin/sh -e

echo "$KEYS" | tr ',' '\n' | while read key; do
  apt-key add $key
done

apt-get update

# echo "$PKG_LIST" | tr ',' '\n' | while read pkg; do
#   apt-get install --dry-run $pkg
# done
apt-get install -y --dry-run $PKG_LIST
