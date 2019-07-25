#!/bin/sh -e

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
  echo "Please run as root"
  exit
fi

FILES="update_arduino.sh update_atom.sh update_firefox.sh update_java.sh update_scratch3.sh"
# update_unity.sh"

for F in $FILES; do
  ./$F
done

