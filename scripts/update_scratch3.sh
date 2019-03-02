#!/bin/sh -e

DIR=$(dirname `realpath $0`)

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
        echo "Please run as root"
        exit
fi

. $PWD/functions.sh

# Install path for firefox.
INSTALL_PATH=/opt/Scratch3
GIT_URL="https://github.com/LLK/scratch-gui.git"

# Load Gnome desktop entry.
#DESKTOP_ENTRY="$(cat $DIR/../data/Scratch3.desktop)"

# List of dependencies to be installed.
DEPEND_PKGS="nodejs"
# Check for dependencies.
install_depends $DEPEND_PKGS

# Make install path if it is missing.
if [ ! -d "$INSTALL_PATH" ]; then
	mkdir -p $INSTALL_PATH
fi

# Clone the repo.
git clone $GIT_URL $INSTALL_PATH
cd $INSTALL_PATH

npm install

# Add Gnome desktop entry.
#echo "$DESKTOP_ENTRY"> /usr/share/applications/Scratch3.desktop
cp $DIR/../data/Scratch3.desktop /usr/share/applications/Scratch3.desktop
