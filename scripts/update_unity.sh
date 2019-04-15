#!/bin/sh -e

DIR=$(dirname `realpath $0`)

# Import support functions.
. $DIR/functions.sh

# Install path for Unity.
UNITY_PATH=/opt/Unity

# Check for dependencies.
DEPEND_PKGS="curl wget libxml2-utils xdg-utils jshon coreutils gconf-service lib32gcc1 lib32stdc++6 libasound2 libc6 libc6-i386 libcairo2 libcap2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libfreetype6 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libgl1-mesa-glx libglib2.0-0 libglu1-mesa libgtk2.0-0 libnspr4 libnss3 libpango1.0-0 libstdc++6 libx11-6 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxtst6 zlib1g"

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
  echo "Please run as root"
  exit
fi

# Check for dependencies.
install_depends $DEPEND_PKGS

# Make sure we have a directory to install Unity into.
if [ ! -d $UNITY_PATH ]; then
  echo "The directory does not exist: $UNITY_PATH"
  echo "Creating new unity directory..."
  mkdir -p $UNITY_PATH
fi

# Create temporary directory for storing downloaded archives.
TEMP_DIR=$(mktemp -d /tmp/$0.XXXXXX)
cd $TEMP_DIR

# Get available versions.
wget -q https://public-cdn.cloud.unity3d.com/hub/prod/releases-linux.json

# Get latest version available.
LATEST_VERSION=$(jshon -F releases-linux.json -e official -e -1 -e version | tr -d "\"")
if [ -z $LATEST_VERSION ]; then
  echo "Failed to get the latest version of Unity!"
  echo "Terminating..."
  exit 1
fi
echo "Latest version: $LATEST_VERSION"

# Get current installed version.
VERSION_XML_PATH=$UNITY_PATH/Editor/Data/PlaybackEngines/LinuxStandaloneSupport/ivy.xml
CURRENT_VERSION=""
if [ -e $VERSION_XML_PATH ]; then
  CURRENT_VERSION=$(xmllint --xpath 'string(//info/@*[local-name()="unityVersion" and namespace-uri()="http://ant.apache.org/ivy/extra"])' $UNITY_PATH/Editor/Data/PlaybackEngines/LinuxStandaloneSupport/ivy.xml 2> /dev/null)
fi
echo "Current version: $CURRENT_VERSION"

# Check if we have the latest version.
UPDATE=""
if [ -z $CURRENT_VERSION ]; then
  UPDATE=true
elif [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
  UPDATE=true
fi

# Do the update/install if needed.
if [ $UPDATE ]; then
  # Get the archive URL.
  INSTALLER_URL=$(jshon -F releases-linux.json -e official -e -1 -e downloadUrl | tr -d "\"" | tr -d "\\")
  if [ -z $INSTALLER_URL ]; then
    echo "Failed to get the URL for the archive!"
    echo "Terminating..."
    exit 1
  fi

  # Download unity.
  wget $INSTALLER_URL

  # Get name of the archive file.
  UNITY_ARCHIVE=$(echo $INSTALLER_URL | rev | cut -d'/' -f1 | rev)

  # Extract the archive.
  tar -xvf $UNITY_ARCHIVE -C $UNITY_PATH

  # Add Gnome desktop entry.
  xdg-desktop-menu install --novendor $DIR/../data/Unity.desktop

  if [ -e /usr/bin/Unity ]; then
    rm -f /usr/bin/Unity
  fi

  ln -s $UNITY_PATH/Editor/Unity /usr/bin/Unity
fi
