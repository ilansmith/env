#!/bin/bash

if [ ! -f scripts.env ]; then
  echo "Error: get_toolchain.sh must be executed inside the scripts directory."
  exit 1
fi

source scripts.env

PRINTLN "Setting up toolchain..."
# Available also on Ilan Smith's Google Drive
setup_new_tar $TOOLCHAIN_PATH http://dn.odroid.com/ODROID-XU/compiler/arm-eabi-4.6.tar.gz

