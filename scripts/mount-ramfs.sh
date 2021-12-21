#!/bin/sh -e

sudo mount -t tmpfs -o size=24G tmpfs $(pwd)/build/
sudo chown $USER:$USER $(pwd)/build
