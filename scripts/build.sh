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
#else
#	sudo lb clean --all
fi

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

read line <../build-version.txt
build_version=$(($line+1))
#build_version=$(($build_version+1))

#sudo chown magnus:magnus live-image-amd64.hybrid.iso
mv live-image-amd64.hybrid.iso "../images/live-image-amd64-$build_version.hybrid.iso"

#sudo chown magnus:magnus build.log
cp build.log "../images/live-image-amd64-$build_version.build.log"

echo $build_version> ../build-version.txt
