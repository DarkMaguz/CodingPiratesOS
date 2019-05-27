#!/bin/sh -e

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
  echo "Please run as root"
  exit
fi

#cd ..

if [ ! -d images/ ]; then
	mkdir -p images/
fi

if [ ! -d build/ ]; then
	mkdir -p build/
else
	#rm -rf build/*
  #rm -rf build/.build
  echo "kkk"
fi

# Fix bug missing debian-cd pakage.
rm /usr/share/live/build/data/debian-cd/buster
ln -s /usr/share/debian-cd/data/buster /usr/share/live/build/data/debian-cd/buster

# Fix bug in debootstrap, when mounting /proc in docker.
patch /usr/share/debootstrap/scripts/debian-common < data/patch/debian-common.patch

# Debug skip compression of squashFS.
#patch /usr/lib/live/build/binary_rootfs < data/patch/binary_rootfs.patch

# Copy config files to build dir.
cp -r -u basics/* build/

cd build

lb clean
lb build

if [ ! -e live-image-amd64.hybrid.iso ]; then
  echo "#############"
  echo "## FAILED! ##"
  echo "#############"
  exit
fi

if [ ! -f ../data/build-version.txt ]; then
	echo 1000 >../data/build-version.txt
fi

read line <../data/VERSION
MAJOR=$(echo $line | cut -d "." -f1)
MINOR=$(echo $line | cut -d "." -f2)
BUILD=$(echo $line | cut -d "." -f3)
build_version="$MAJOR.$MINOR.$(($BUILD+1))"

#sudo chown magnus:magnus live-image-amd64.hybrid.iso
mv live-image-amd64.hybrid.iso "../images/live-image-amd64-$build_version.hybrid.iso"

#sudo chown magnus:magnus build.log
cp build.log "../images/live-image-amd64-$build_version.build.log"

echo $build_version >../data/VERSION
