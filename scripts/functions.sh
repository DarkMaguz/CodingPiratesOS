#!/bin/sh -e

ARCHITECTURE=$(dpkg --print-architecture)

# Find and install missing dependencies.
# Useage: install_depends(STRING)
#  Where STRING is a string comprised of names of packages spepareted by spaces.
install_depends() {
  local missing=""
  echo "Checking for $(echo "$@" | wc -w) dependencies."

  # Check for missing dependencies.
  for pkg in $@; do
    dpkg-query -s $pkg:$ARCHITECTURE > /dev/null 2>&1 || missing="$missing $pkg"
  done

  # Install missing packages, if any.
  if [ ! -z "$missing" ]; then
    echo "Found $(echo "$missing" | wc -w) missing packages."
  	apt update -y
  	apt install -y $missing
  fi
}
