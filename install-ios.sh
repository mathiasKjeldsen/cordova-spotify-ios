#!/usr/bin/env bash

INSTALL_PATH="plugins/cordova-spotify-ios/src/ios/spotify-sdk"
DOWNLOAD_PATH="https://github.com/spotify/ios-sdk/archive/v1.2.0.tar.gz"

if [ ! -d $INSTALL_PATH ]; then
    mkdir -p $INSTALL_PATH
    curl -LsS $DOWNLOAD_PATH | tar -xz -C $INSTALL_PATH --strip 1
fi
