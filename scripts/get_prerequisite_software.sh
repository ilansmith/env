#!/bin/bash

EXECUTABLE_PATH=/usr/local/bin

if [ ! -f scripts.env ]; then
  echo "Error: get_prerequisit_software.sh must be executed inside the scripts directory."
  exit 1
fi

source scripts.env

DISTRIBUTION=`cat /etc/issue | \grep -i ubuntu | awk '{print $1 " " $2}'`

apt_get_update()
{
  sudo apt-get update
  sudo apt-get -y autoremove
}

install_common_recommended()
{
  PACKAGES_RECOMMENDED_COMMON=ccache

  sudo apt-get install -y $PACKAGES_RECOMMENDED_COMMON
}

install_64bit_recommended()
{
  echo "Installing 64bit recommended packages..."

  PACKAGES_RECOMMENDED_64BIT=ia32-libs-multiarch ia32-libs

  sudo apt-get install -y $PACKAGES_RECOMMENDED_64BIT
}

setup_executable()
{
  setup_new_tar $EXECUTABLE_PATH $2
  sudo chmod a+x $EXECUTABLE_PATH/$1
}

setup_ccache()
{
  PRINTLN "Limiting ccache size..."
  ccache --max-size=500M
}

PRINTLN "Installing prerequisite software..."
apt_get_update
install_common_recommended
[ -n "`uname -a | grep x86_64`" ] && install_64bit_recommended
[ -n "`which ccache`" ] && setup_ccache

