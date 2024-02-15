#!/bin/sh -e

# Since EXTRA_PACKAGES may include dependencies, they should be installed first .
if [ -n "$EXTRA_PACKAGES" ]; then
  dpkg -i $EXTRA_PACKAGES
  apt-get install -f -y
fi

apt-get update

apt-get install -y --no-install-recommends --dry-run $PKG_LIST
