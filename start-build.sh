#!/bin/sh -e

# Download extra deb packages.
#python3 scripts/get_extra_pkgs.py

# Download extensions for VS Codium.
# python3 scripts/get_vscodium_extensions.py

if [ $(docker ps -a -f "name=/CodingPiratesOS$1$" -q) ]; then
  docker rm -f CodingPiratesOS$1
fi

# Specify the network to use.
DOCKER_NETWORK=default

# If the network "cpos" exists, use it. 
if [ -n "$(docker network ls | grep cpos)" ]; then
  DOCKER_NETWORK=cpos
fi

# Build the docker image.
docker build \
  --network $DOCKER_NETWORK \
  -t darkmagus/codingpiratesos .

# Start building the live cpos iso.
# It is necessary to run the container with --privileged in order 
# to mounting /dev/pts and /proc whith chroot inside the container.
# See https://github.com/docker/docker/issues/11896
docker run -ti \
  --network $DOCKER_NETWORK \
  --privileged \
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
