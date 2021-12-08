#!/bin/sh -e

#echo "testing"
apt-key add /etc/apt/sources.list.d/test.key
apt-get update
