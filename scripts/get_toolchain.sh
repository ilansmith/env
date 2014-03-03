#!/bin/bash

if [ ! -f scripts.env ]; then
  echo "Error: get_toolchain.sh must be executed inside the scripts directory."
  exit 1
fi

source scripts.env

PRINTLN "Setting up toolchain..."
setup_new_tar $TOOLCHAIN_PATH http://sys-mobilehost/toolchains/arm-2010q1-202-arm-none-linux-gnueabi-i686-pc-linux-gnu.tar.bz2

