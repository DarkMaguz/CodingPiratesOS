#!/bin/sh -e

# Import functions.
. $PWD/functions.sh

# Unity versioning has the apparent form of major.minor.update.patch
# where:
#  major = year
#  minor = some sequential number
#  update = a(alpha) || b(beta) || rc(release candidate) || f(final)
#  patch = some sequential number

# When we currently test for updates, we only test for major, minor and patch.
# This should change in the future.

# Install path for Unity.
UNITY_PATH=/opt/unity

DEPEND_PKGS="curl wget libxml2-utils coreutils gconf-service lib32gcc1 lib32stdc++6 libasound2 libc6 libc6-i386 libcairo2 libcap2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libfreetype6 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libgl1-mesa-glx libglib2.0-0 libglu1-mesa libgtk2.0-0 libnspr4 libnss3 libpango1.0-0 libstdc++6 libx11-6 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxtst6 zlib1g debconf npm"

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

# Find the download page for latest version available.
# Here we make the presumption that the latest forum post,
# is the post that contain a link to the download page of the latest version.
UNITY_FORUM_URL="https://forum.unity.com/threads/unity-on-linux-release-notes-and-known-issues.350256/page-999"
UNITY_FORUM_DATA=$(wget -q -O - "$UNITY_FORUM_URL")
LAST_POST_NR=36
UNITY_DL_PAGE_URL=""
for i in $(seq $LAST_POST_NR 200); do
  XPATH="//ol[@id='messageList']/li[$i]//blockquote[@class='messageText SelectQuoteContainer ugc baseHtml']/a[@class='externalLink']"
  URL=$(echo "$UNITY_FORUM_DATA" | xmllint --html --xpath "string($XPATH)" - 2> /dev/null)
  if [ ! -z $URL ]; then
    UNITY_DL_PAGE_URL=$URL
  else
    break
  fi
done
echo $UNITY_DL_PAGE_URL

# Get latest version available.
HEADLINE=$(wget -q -O - $UNITY_DL_PAGE_URL | xmllint --html --xpath 'string(/html/body/h2)' -)
LATEST_VERSION=$(echo $HEADLINE | cut -d' ' -f2)
if [ -z $LATEST_VERSION ]; then
  echo "Failed to get the latest version of Unity!"
  echo "Terminating..."
  exit 1
fi
echo $LATEST_VERSION

# Get current installed version.
VERSION_XML_PATH=$UNITY_PATH/Editor/Data/PlaybackEngines/LinuxStandaloneSupport/ivy.xml
CURRENT_VERSION=""
if [ -e $VERSION_XML_PATH ]; then
  CURRENT_VERSION=$(xmllint --xpath 'string(//info/@*[local-name()="unityVersion" and namespace-uri()="http://ant.apache.org/ivy/extra"])' $UNITY_PATH/Editor/Data/PlaybackEngines/LinuxStandaloneSupport/ivy.xml)
fi
echo $CURRENT_VERSION

# Chech if we have the latest version.
UPDATE=""
if [ "$LATEST_VERSION" != "$CURRENT_VERSION" ]; then
	# Test if we need to update.
	LATEST_VERSION_LIST=$(echo $LATEST_VERSION | sed --posix 's/[^[:digit:]]/ /g')
	CURRENT_VERSION_LIST=$(echo $CURRENT_VERSION | sed --posix 's/[^[:digit:]]/ /g')
	for i in $(seq 1 4); do
		# TODO: Make test for a(alpha) || b(beta) || rc(release candidate) || f(final).
	  if [ $(echo $LATEST_VERSION_LIST | cut -d' ' -f$i) -gt $(echo $CURRENT_VERSION_LIST | cut -d' ' -f$i) ]; then
	    UPDATE=true
			break
	  fi
	done
fi

# Do the update if needed.
if [ $UPDATE ]; then
  cd $UNITY_PATH

  # Get the installer URL.
  INSTALLER_URL=$(wget -q -O - $UNITY_DL_PAGE_URL | xmllint --html --xpath 'string(/html/body/a[1]/@href)' -)

  wget -q -N $INSTALLER_URL
  INSTALLER_FILE=${INSTALLER_URL##*/}
  chmod +x $INSTALLER_FILE

  echo "y\n" | ./$INSTALLER_FILE -u -l $UNITY_PATH
fi
