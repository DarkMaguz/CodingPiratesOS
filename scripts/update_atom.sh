#!/bin/sh -e

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
  echo "Please run as root"
  exit
fi

# Get source directory for this script.
DIR=$(dirname `realpath $0`)

. $DIR/functions.sh

# Create temporary directory for storing downloaded deb-file.
TEMP_DIR=$(mktemp -d /tmp/$(echo $0 | rev | cut -d "/" -f1 | rev).XXXXXX)

# List of dependencies to be installed.
DEPEND_PKGS="libxml2-utils wget git gconf2 gconf-service libgtk-3-0 libudev1 libgcrypt20 libnotify4 libxtst6 libnss3 python gvfs-bin xdg-utils libcap2 libx11-xcb1 libxss1 libasound2 libxkbfile1 libcurl4"
# Check for dependencies.
install_depends $DEPEND_PKGS

# Get the current version.
if [ $(which atom) ]; then
	CURRENT_VERSION=$(dpkg --status atom | grep -i "version:" | cut -d " " -f 2)
else
  CURRENT_VERSION=""
fi

# Get the latest version available.
LATEST_VERSION=$(wget -q -O - https://atom.io | xmllint --html --xpath 'string(//span[@class="version"])' - 2> /dev/null)
echo "Latest version: $LATEST_VERSION"
echo "Current version: $CURRENT_VERSION"

if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
	echo "Found an outdated version of Atom \"$CURRENT_VERSION\"."
	echo "Downloading lates version of Atom \"$LATEST_VERSION\"."

  # Download new Atom deb-file.
	wget -O $TEMP_DIR/atom.deb https://atom.io/download/deb

  dpkg -i $TEMP_DIR/atom.deb
else
	echo "Atom is up to date: \"$CURRENT_VERSION\""
fi
