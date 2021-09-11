#!/bin/bash

# remember current directory
CUR_DIR=`pwd`

# force script to run from within script directory
EXEC_PATH=`echo $0 | sed 's/\(.*\)\/[^\/]*$/\1/'`

# cd to scripts directory
cd 1>/dev/null $EXEC_PATH/scripts

source scripts.env
print_key_val "PROJECT_PATH" $PROJECT_PATH
print_key_val "ENV_PATH" $ENV_PATH
print_key_val "ANDROID_PATH" $ANDROID_PATH
print_key_val "SCRIPTS_PATH" $SCRIPTS_PATH
print_key_val "PATCHES_PATH" $PATCHES_PATH
print_key_val "BINARIES_PATH" $BINARIES_PATH
print_key_val "BINARIES_BCK_PATH" $BINARIES_BCK_PATH
print_key_val "GIT_EMAIL_USER" $GIT_EMAIL_USER
print_key_val "TOOLCHAIN_PATH" $TOOLCHAIN_PATH
print_key_val "GIT_DEV_BRANCH" $GIT_DEV_BRANCH

exec_script()
{
  if [ $# -eq 2 ]; then
    if [ "$2" -eq 0 ]; then
      PRINTLN "Skipping $1..."
      return 0
    fi
  fi

  ./$1
  if [ $? -eq 0 ]; then
    PRINTLN "Done!"
  else
    PRINTLN "Skipped..."
  fi
}

# get root passowrd
get_root_password

# get prerequisite software
exec_script get_prerequisite_software.sh

# get toolchain
exec_script get_toolchain.sh

# populate extra stuff in build directory
exec_script setup_build_dir.sh

# setup mobilehost gpg public key
exec_script setup_gpg_public_key.sh

# cd to execution direcory
cd 1>/dev/null $CUR_DIR

