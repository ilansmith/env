#!/bin/bash

if [ ! -f scripts.env ]; then
  echo "Error: setup_android_system.sh must be executed inside the scripts directory."
  exit 1
fi

source scripts.env

PRINTLN "Setting up project directories..."
setup_new_tar $PROJECT_PATH http://sys-mobilehost/emmc/samsung/exynos5/octa/android/jb/project_dirs_jb.tar.bz2

