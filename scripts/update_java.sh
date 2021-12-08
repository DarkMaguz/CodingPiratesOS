#!/bin/sh -e

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
	echo "Please run as root"
	exit
fi

# Get source directory for this script.
DIR=$(dirname `realpath $0`)

# Import functions.
. $DIR/functions.sh

JWM_PATH=/usr/lib/jvm
DEFAULT_PATH=/usr/lib/jvm/default-java
DEPEND_PKGS="wget libxml2-utils tar gzip coreutils"

if [ ! -d $JWM_PATH ]; then
	echo "The directory does not exist: $JWM_PATH"
	echo "Creating new JWM directory..."
	mkdir -p $JWM_PATH
fi

cd $JWM_PATH

# Check for dependencies.
install_depends $DEPEND_PKGS

HTML_DATA=$(wget -q -O - https://www.oracle.com/java/technologies/javase-jre8-downloads.html | xmllint --html --xpath 'string(//h4[contains(text(),"Java SE Runtime Environment")])' - 2> /dev/null)
BUNDLE_ID=$(wget -q -O - https://www.oracle.com/java/technologies/javase-jre8-downloads.html | xmllint --html --xpath 'string(//a[contains(text(),"linux-x64.tar.gz")]/@data-file)' - 2> /dev/null | cut -d'/' -f8)
BUNDLE_PREFIX="243727"
DL_LINK="https://javadl.oracle.com/webapps/download/AutoDL?BundleId=$BUNDLE_PREFIX""_$BUNDLE_ID"

LATEST_VERSION=$(echo $HTML_DATA | cut -d' ' -f5 | cut -d'u' -f1 )
LATEST_UPDATE=$(echo $HTML_DATA | cut -d' ' -f5  | cut -d'u' -f2 )

if [ -z "$LATEST_VERSION" -o -z "$LATEST_UPDATE" ]; then
	echo "ERROR: Unable to find latest version of Java VM!" >&2
	exit
fi

CURRENT_VERSION=0
CURRENT_UPDATE=0

LATEST_JRE_DIR=""
for entry in ./jre*
do
	if [ -d $entry ]; then
		LATEST_JRE_DIR=$entry
	fi
done

CURRENT_VERSION=$(echo $LATEST_JRE_DIR | cut -d'.' -f3)
CURRENT_UPDATE=$(echo $LATEST_JRE_DIR | cut -d'_' -f2)

CURRENT_DIR="jre1.$CURRENT_VERSION.0_$CURRENT_UPDATE"
LATEST_DIR="jre1.$LATEST_VERSION.0_$LATEST_UPDATE"

if [ "$LATEST_VERSION" != "$CURRENT_VERSION" -o "$LATEST_UPDATE" != "$CURRENT_UPDATE" ]; then
	echo "Found outdated version of Java JRE: Version $CURRENT_VERSION Update $CURRENT_UPDATE."
	echo "Downloading new version of Java JRE: Version $LATEST_VERSION Update $LATEST_UPDATE."
	JRE_ARCHIVE="jre-"$LATEST_VERSION"u"$LATEST_UPDATE"-linux-x64.tar.gz"
	wget -q --show-progress $DL_LINK -O $JRE_ARCHIVE
	tar zxvf $JRE_ARCHIVE
	rm $JRE_ARCHIVE
	rm -rf $CURRENT_DIR
	if [ -e $DEFAULT_PATH -o -L $DEFAULT_PATH ]; then
		rm -f $DEFAULT_PATH
	fi
	echo "Creating symbolic link..."
	ln -s $JWM_PATH/$LATEST_DIR $DEFAULT_PATH
else
	echo "Java JRE is up to date: Version $CURRENT_VERSION Update $CURRENT_UPDATE."
	if [ ! -e $DEFAULT_PATH ]; then
		if [ -L $DEFAULT_PATH ]; then
			rm -f $DEFAULT_PATH
		fi
		echo "Creating missing symbolic link..."
		ln -s $JWM_PATH/$CURRENT_DIR $DEFAULT_PATH
	fi
fi

update-alternatives --install /usr/bin/java java $JWM_PATH/$LATEST_DIR/bin/java $(($LATEST_VERSION*1000+$LATEST_UPDATE))
#update-alternatives --install /usr/bin/javac javac $JWM_PATH/$LATEST_DIR/bin/javac $(($LATEST_VERSION*100+$LATEST_UPDATE))
