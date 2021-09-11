#!/bin/bash

if [ ! -f scripts.env ]; then
  echo "Error: get_prerequisit_software.sh must be executed inside the scripts directory."
  exit 1
fi

source scripts.env

setup_softlink ubuntu/kernel $PROJECT_PATH/kernel
build_directory_structure $PROJECT_PATH/.ccache
