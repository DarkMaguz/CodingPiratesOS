#!/bin/sh -e

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
        echo "Please run as root"
        exit
fi

# Get source directory for this script.
DIR=$(dirname `realpath $0`)

# Import support functions.
. $DIR/functions.sh

# Create temporary directory for storing downloaded archives.
TEMP_DIR=$(mktemp -d /tmp/$0.XXXXXX)

# Install path for Arduino.
INSTALL_PATH=/opt/Arduino
ARDUINO_URL="https://www.arduino.cc/en/Main/Software"

# List of dependencies to be installed.
DEPEND_PKGS="librxtx-java libjna-java libxml2-utils wget xdg-utils"

# Check for dependencies.
install_depends $DEPEND_PKGS

# Get the current version.
if [ -e $INSTALL_PATH/revisions.txt ]; then
	CURRENT_VERSION=$(head -n 1 $INSTALL_PATH/revisions.txt | cut -d " " -f 2)
else
	CURRENT_VERSION="0.0.0"
fi

# Get the latest version available.
LATEST_VERSION=$(wget -q -O - https://www.arduino.cc/en/main/software | xmllint --html --xpath 'string(//*[@id="wikitext"]/div[2]/div[3]/div[1]/div/div[2]/div[1])' - 2> /dev/null | tr '\n' ' ' | sed -e 's/[A-Z[:space:]]*//g')

if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
	echo "Found an outdated version of Arduino \"$CURRENT_VERSION\"."
	echo "Downloading lates version of Arduino \"$LATEST_VERSION\"."

  # Remove old binary if it exists.
	if [ -d "$INSTALL_PATH" ]; then
		rm -rf $INSTALL_PATH
	fi

  # Make install path if it is missing.
  if [ ! -d "$INSTALL_PATH" ]; then
  	mkdir -p $INSTALL_PATH
  fi

  # Get the file name of the archive.
  FILE_NAME=$(wget -q -O - https://www.arduino.cc/en/main/software | xmllint --html --xpath 'string(//*[@id="wikitext"]/div[2]/div[3]/div[2]/p[3]/a[2]/@href)' - 2> /dev/null | cut -d '/' -f 5)

  # Download new Ardunio archive.
	wget -P $TEMP_DIR https://downloads.arduino.cc/$FILE_NAME

  # Extract the Arduino folder from archive to the install path.
  tar -xvC $INSTALL_PATH --strip-components=1 -f $TEMP_DIR/$FILE_NAME

  # Setup icons, menu items and file associations.
  sh $INSTALL_PATH/install.sh
else
	echo "Arduino is up to date: \"$CURRENT_VERSION\""
fi
