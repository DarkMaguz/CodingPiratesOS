#!/bin/sh -e

echo "¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤"
echo "Starting build nr: $BUILD_NUMBER"
echo "¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤¤"

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
  echo "Please run as root"
  exit
fi

# Make sure we have a place to put the images.
if [ ! -d images/ ]; then
	mkdir -p images/
fi

# Create or clean a build directory.
if [ ! -d build/ ]; then
	mkdir -p build/
else
	rm -rf build/*
  rm -rf build/.build
fi

# If any proxy related environment variables are defined, 
# copy the certificates to the config directory.
if [ -n "$http_proxy" ] || \
   [ -n "$https_proxy" ] || \
   [ -n "$HTTP_PROXY" ] || \
   [ -n "$HTTPS_PROXY" ]; then
   mkdir -p build/config/certs/
  cp certs/*.crt build/config/certs/
fi

# Fix bug missing debian-cd pakage.
rm /usr/share/live/build/data/debian-cd/bookworm
ln -s /usr/share/debian-cd/data/bookworm /usr/share/live/build/data/debian-cd/bookworm

# Fix bug in debootstrap, when mounting /proc in docker.
patch /usr/share/debootstrap/scripts/debian-common < data/patch/debian-common.patch

# Copy config files to build dir.
rsync -a --exclude=disabled/ basics/ build/

cd build

lb clean
lb build

if [ ! -e live-image-amd64.hybrid.iso ]; then
  echo "#############"
  echo "## FAILED! ##"
  echo "#############"
  exit 1
fi

read line <../data/VERSION
MAJOR=$(echo $line | cut -d "." -f1)
MINOR=$(echo $line | cut -d "." -f2)
BUILD_VERSION="$MAJOR.$MINOR.$BUILD_NUMBER"

mv live-image-amd64.hybrid.iso "../images/cpos-live-amd64-$BUILD_VERSION.iso"
cp build.log "../images/cpos-live-amd64-$BUILD_VERSION.build.log"

# Hand over ownership of generated/modified data to the proper owner.
chown -R $BUILD_UID:$BUILD_UID ../build ../images
