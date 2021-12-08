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
TEMP_DIR=$(mktemp -d /tmp/$(echo $0 | rev | cut -d "/" -f1 | rev).XXXXXX)

# Install path for Arduino.
INSTALL_PATH=/opt/Arduino
ARDUINO_URL="https://www.arduino.cc/en/Main/Software"

# List of dependencies to be installed.
DEPEND_PKGS="librxtx-java libjna-java libxml2-utils wget xdg-utils xz-utils"

# Check for dependencies.
install_depends $DEPEND_PKGS

# Get the current version.
if [ -e $INSTALL_PATH/revisions.txt ]; then
	CURRENT_VERSION=$(head -n 1 $INSTALL_PATH/revisions.txt | cut -d " " -f 2)
else
	CURRENT_VERSION="0.0.0"
fi

# Get the latest version available.
LATEST_VERSION=$(wget -q -O - $ARDUINO_URL | xmllint --html --xpath 'string(//div[@class="download-desc"]/h2)' - 2> /dev/null | tr '\n' ' ' | sed -e 's/[a-Z[:space:]]*//g')

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

  # Get the URL of the archive.
  DL_URL=$(wget -q -O - $ARDUINO_URL | xmllint --html --xpath 'string(//a[@title="Linux 64 bits"]/@href)' - 2> /dev/null)

  # Get the file name of the archive.
  FILE_NAME=$(echo $DL_URL | cut -d '/' -f 4)

  # Download new Ardunio archive.
	wget -P $TEMP_DIR $DL_URL

  # Extract the Arduino folder from archive to the install path.
  tar -xvC $INSTALL_PATH --strip-components=1 -f $TEMP_DIR/$FILE_NAME

  # Setup icons, menu items and file associations.
  sh $INSTALL_PATH/install.sh

  # Add user to dialout group. Needed for access to serial ports while flashing the chips.
  sudo usermod -a -G dialout $USER
else
	echo "Arduino is up to date: \"$CURRENT_VERSION\""
fi
