#!/bin/sh

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
        echo "Please run as root"
        exit
fi

docker rm -f CodingPiratesOS
set -e
docker build -t darkmagus/codingpiratesos .

docker run -t --privileged -v $PWD/build:/usr/app/build -v $PWD/images:/usr/app/images -v $PWD/basics:/usr/app/basics -v $PWD/data:/usr/app/data -v $PWD/scripts:/usr/app/scripts --name="CodingPiratesOS" darkmagus/codingpiratesos
