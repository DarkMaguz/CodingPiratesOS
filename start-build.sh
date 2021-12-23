#!/bin/sh -e

if [ $(docker ps -a -f "name=/CodingPiratesOS$1$" -q) ]; then
  docker rm -f CodingPiratesOS$1
fi

docker build -t darkmagus/codingpiratesos .

docker run -t \
  -u root \
  --privileged \
  -v $PWD/build:/usr/app/build \
  -v $PWD/images:/usr/app/images \
  -v $PWD/basics:/usr/app/basics:ro \
  -v $PWD/data:/usr/app/data:ro \
  -v $PWD/scripts:/usr/app/scripts:ro \
  -e BUILD_NUMBER=${BUILD_NUMBER:=999} \
  -e BUILD_UID=$UID \
  -e CI=${CI:=false} \
  --name="CodingPiratesOS$1" \
  darkmagus/codingpiratesos
