#!/bin/sh -e

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
  echo "Please run as root"
  exit
fi

if [ ! -d images/ ]; then
	mkdir -p images/
fi

if [ ! -d build/ ]; then
	mkdir -p build/
else
	rm -rf build/*
  rm -rf build/.build
fi

# Fix bug missing debian-cd pakage.
rm /usr/share/live/build/data/debian-cd/bullseye
ln -s /usr/share/debian-cd/data/bullseye /usr/share/live/build/data/debian-cd/bullseye

# Fix bug in debootstrap, when mounting /proc in docker.
patch /usr/share/debootstrap/scripts/debian-common < data/patch/debian-common.patch

# Debug skip compression of squashFS.
#patch /usr/lib/live/build/binary_rootfs < data/patch/binary_rootfs.patch

rm -rf build/config/
# Copy config files to build dir.
cp -r -u basics/* build/

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
