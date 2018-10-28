#!/bin/sh -e

cd ..
cp -r -u basics/* build/
cd build

sudo lb build
