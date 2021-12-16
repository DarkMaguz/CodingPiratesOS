#!/bin/sh -e

echo "$KEYS" | tr ',' '\n' | while read key; do
  apt-key add $key
done

apt-get update
