#!/bin/sh -e

DIR=$(dirname `realpath $0`)

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
        echo "Please run as root"
        exit
fi

. $PWD/functions.sh

# Install path for Scratch 3.
INSTALL_PATH=/opt/Scratch3

# List of dependencies to be installed.
DEPEND_PKGS="libgtkmm-3.0-dev autotools-dev libboost-system-dev libboost-thread-dev google-chrome docker git"
# Check for dependencies.
install_depends $DEPEND_PKGS

# Make install path if it is missing.
if [ ! -d "$INSTALL_PATH" ]; then
	mkdir -p $INSTALL_PATH
fi

# Get splash screen.
SPLASH_SCREEN_STATE=none
if [ ! -d "$INSTALL_PATH/Scratch3-splash" ]; then
  git clone https://github.com/DarkMaguz/Scratch3-splash.git $INSTALL_PATH/Scratch3-splash
  SPLASH_SCREEN_STATE=cloned
else
  git -C $INSTALL_PATH/Scratch3-splash remote update &> /dev/null
  GIT_STATUS=`git -C $INSTALL_PATH/Scratch3-splash status`
  SEARCH_STRING="Your branch is up-to-date"
  if [ ! "${GIT_STATUS#*$SEARCH_STRING}" != "$GIT_STATUS" ]; then
    make -C $INSTALL_PATH/Scratch3-splash uninstall
    git -C $INSTALL_PATH/Scratch3-splash pull --all &> /dev/null
    SPLASH_SCREEN_STATE=pulled
  fi
fi

# Build and install splash screen if needed.
if [ "$SPLASH_SCREEN_STATE" != "none" ]; then
  cd $INSTALL_PATH/Scratch3-splash
  autoreconf -i
  ./configure --prefix /usr
  make && make install
fi

# Add Gnome desktop entry.
cp $DIR/../data/Scratch3/Scratch3.desktop /usr/share/applications/Scratch3.desktop

# Install scratch3.sh.
cp $DIR/../data/Scratch3/scratch3.sh $INSTALL_PATH/scratch3.sh
ln -s $INSTALL_PATH/scratch3.sh /usr/bin/scratch3
