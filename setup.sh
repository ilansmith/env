#!/bin/bash

# remember current directory
CUR_DIR=`pwd`

# force script to run from within script directory
EXEC_PATH=`echo $0 | sed 's/\(.*\)\/[^\/]*$/\1/'`

# cd to scripts directory
cd 1>/dev/null $EXEC_PATH/scripts

source scripts.env
PRINT_KEY_VAL "SCRIPTS_PATH" $SCRIPTS_PATH
PRINT_KEY_VAL "ENV_PATH" $ENV_PATH
PRINT_KEY_VAL "BINARIES_PATH" $BINARIES_PATH
PRINT_KEY_VAL "BINARIES_BCK_PATH" $BINARIES_BCK_PATH
PRINT_KEY_VAL "BASE_PATH" $BASE_PATH
PRINT_KEY_VAL "GIT_EMAIL_USER" $GIT_EMAIL_USER

# setup file system
exec ./setup_file_system.sh

# cd to execution direcory
cd 1>/dev/null $CUR_DIR

