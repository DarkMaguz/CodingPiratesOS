#!/bin/sh -e

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
        echo "Please run as root"
        exit
fi

. $PWD/functions.sh

# Install path for firefox.
FF_PATH=/opt/Mozilla
FF_URL="https://download.mozilla.org/?product=firefox-latest&os=linux64&lang=da"

# Load Gnome desktop entry.
DESKTOP_ENTRY="$(cat ../data/Firefox.desktop)"

# List of dependencies to be installed.
DEPEND_PKGS="wget libxml2-utils tar coreutils grep"
# Check for dependencies.
install_depends $DEPEND_PKGS

# Make install path if it is missing.
if [ ! -d "$FF_PATH" ]; then
	mkdir -p $FF_PATH
fi

cd $FF_PATH

# Get the current version.
if [ -e $FF_PATH/firefox/application.ini ]; then
	CURRENT_VERSION=$(sed -n -e 's/^\s*Version\s*=\s*//p' $FF_PATH/firefox/application.ini)
else
	CURRENT_VERSION="0.0.0"
fi

# Get the latest version available.
LATEST_VERSION=$(wget --spider -S --max-redirect 0 $FF_URL 2>&1 | sed -n '/Location: /{s|.*/firefox-\(.*\)\.tar.*|\1|p;q;}')

if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
	echo "Found an outdated version of firefox \"$CURRENT_VERSION\"."
	echo "Downloading lates version of firefox \"$LATEST_VERSION\"."

  # Remove old binary if it exists.
	if [ -d "$FF_PATH/firefox/" ]; then
		rm -rf $FF_PATH/firefox/
	fi

  # Find any existing archives and delete them.
  for OLD_ARCHIVE in $FF_PATH/firefox*.tar*
  do
    rm -f $OLD_ARCHIVE
  done

  # Get URL fot the latest firefox version.
  ARCHIVE_URL=$(wget --spider -S --max-redirect 0 $FF_URL 2>&1 | grep "Location:" -m 1 | cut -d' ' -f4)

  # Download new firefox archive.
	wget $ARCHIVE_URL

  # Get name of the archive file.
  FIREFOX_BIN_ARCHIVE=$(echo $ARCHIVE_URL | rev | cut -d'/' -f1 | rev)

  # Extract archive and delete it afterwards.
	tar -xvf $FIREFOX_BIN_ARCHIVE
	rm -f $FIREFOX_BIN_ARCHIVE

  # Make symbolic links to icons.
  for ICON in $FF_PATH/firefox/browser/chrome/icons/default/default*.png
  do
    SIZE=$(echo $ICON | rev | cut -d'/' -f1 | rev | cut -d'.' -f1 | cut -c'8-')
    SYM_LINK=/usr/share/icons/hicolor/"$SIZE"x"$SIZE"/apps/firefox.png
    if [ -e $SYM_LINK ]; then
      rm $SYM_LINK
    fi
    ln -s $ICON $SYM_LINK
  done

  # Add Gnome desktop entry.
  echo "$DESKTOP_ENTRY"> /usr/share/applications/Firefox.desktop
else
	echo "Firefox is up to date: \"$CURRENT_VERSION\""
fi
