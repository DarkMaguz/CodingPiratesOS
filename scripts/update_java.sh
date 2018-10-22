#!/bin/bash
set -e
JWM_PATH="/usr/lib/jvm"
DEFAULT_PATH="/usr/lib/jvm/default-java"

# Ensure that we have superpowers.
if [ $(id -u) != 0 ]; then
        echo "Please run as root"
        exit
fi

if [ ! -d "$JWM_PATH" ]; then
	echo "The directory does not exist: $DEFAULT_PATH"
	echo "Terminating..."
	exit
fi

cd "$JWM_PATH"

DL_LINK=`wget -q -O - https://java.com/en/download/linux_manual.jsp | xmllint --html --xpath 'string(/html/body/div[2]/div[1]/div/table[2]/tbody/tr[5]/td[2]/a/@href)' - 2>/dev/null`
HTML_DATA=`wget -q -O - https://java.com/en/download/linux_manual.jsp | xmllint --html --xpath 'string(/html/body/div/div/div/h4[@class="sub"])' - 2>/dev/null`

LATEST_VERSION=`cut -d' ' -f3 <<<$HTML_DATA`
LATEST_UPDATE=`cut -d' ' -f5 <<<$HTML_DATA`

CURRENT_VERSION=0
CURRENT_UPDATE=0

JRE_DIRS=(`ls -d jre*`)
JRE_DIR=${JRE_DIRS[-1]}
VERSION_STRING=${JRE_DIR:3}

CURRENT_VERSION=`cut -d'.' -f2 <<<$VERSION_STRING`
CURRENT_UPDATE=`cut -d'_' -f2 <<<$VERSION_STRING`

CURRENT_DIR="jre1."$CURRENT_VERSION".0_"$CURRENT_UPDATE""
LATEST_DIR="jre1."$LATEST_VERSION".0_"$LATEST_UPDATE""

if [ "$LATEST_VERSION" != "$CURRENT_VERSION" -o "$LATEST_UPDATE" != "$CURRENT_UPDATE" ]; then
	echo "Found outdated version of Java JRE: Version $CURRENT_VERSION Update $CURRENT_UPDATE."
	echo "Downloading new version of Java JRE: Version $LATEST_VERSION Update $LATEST_UPDATE."
	JRE_ARCHIVE="jre-"$LATEST_VERSION"u"$LATEST_UPDATE"-linux-x64.tar.gz"
	wget -q --show-progress $DL_LINK -O $JRE_ARCHIVE
	tar zxvf $JRE_ARCHIVE
	rm $JRE_ARCHIVE
	rm -rf $CURRENT_DIR
else
	echo "Java JRE is up to date: Version $CURRENT_VERSION Update $CURRENT_UPDATE."
fi

if [ `readlink -- "$DEFAULT_PATH"` != $JWM_PATH/$LATEST_DIR ]; then
	echo "Creating symbolic link..."
	rm -f $DEFAULT_PATH
	ln -s $JWM_PATH/$LATEST_DIR $DEFAULT_PATH
fi
