#!/bin/sh -e

# Download extra deb packages.
#python3 scripts/get_extra_pkgs.py

# Download extensions for VS Codium.
# python3 scripts/get_vscodium_extensions.py

if [ $(docker ps -a -f "name=/CodingPiratesOS$1$" -q) ]; then
  docker rm -f CodingPiratesOS$1
fi

# Create a bridge network if it doesn't already exist.
if [ -z "$(docker network ls | grep cpos)" ]; then
  docker network create --driver bridge cpos
fi

docker build \
  --network=cpos \
  -t darkmagus/codingpiratesos .

docker run -ti \
  -u root \
  --privileged \
  --network=cpos \
  -v $PWD/build:/usr/app/build:rw \
  -v $PWD/images:/usr/app/images \
  -v $PWD/basics:/usr/app/basics:ro \
  -v $PWD/data:/usr/app/data:ro \
  -v $PWD/scripts:/usr/app/scripts:ro \
  -v $PWD/proxy/etc/squid/certs:/usr/app/certs:ro \
  -e BUILD_NUMBER=${BUILD_NUMBER:=$(date "+%s")} \
  -e BUILD_UID=$UID \
  -e CI=${CI:=false} \
  --name="CodingPiratesOS$1" \
  darkmagus/codingpiratesos:latest $1
