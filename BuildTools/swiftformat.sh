#!/bin/sh

set -e

VERSION="0.52.3"
BASEDIR=$(dirname "$0")
INSTALL_DIR="${BASEDIR}/Tools/SwiftFormat"
EXECUTABLE="${INSTALL_DIR}/swiftformat"
DOWNLOAD_URL="https://github.com/nicklockwood/SwiftFormat/releases/download/$VERSION/swiftformat.zip"

function install_tool {
    mkdir -p $INSTALL_DIR
    curl -LO $DOWNLOAD_URL --output-dir $BASEDIR
    unzip $BASEDIR/swiftformat.zip -d $INSTALL_DIR
    rm -rf $BASEDIR/swiftformat.zip
    sudo xattr -dr com.apple.quarantine $EXECUTABLE
}

if [[ ! -f $EXECUTABLE ]]
then
    echo "$EXECUTABLE not found, installing…"
    install_tool
fi

INSTALLED_VERSION=$(./$EXECUTABLE --version)
if [[ $VERSION != $INSTALLED_VERSION ]]
then
    echo "Installed version is $INSTALLED_VERSION instead of $VERSION, re-installing…"
    rm -rf $INSTALL_DIR
    install_tool
fi

./$EXECUTABLE ${@:1}
