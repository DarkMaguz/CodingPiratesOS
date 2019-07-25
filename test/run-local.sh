#!/bin/sh -e

export ISOPATH=images/image-to-be-tested.iso

docker-compose build
docker-compose up --exit-code-from test
