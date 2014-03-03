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

setup_adb()
{
  setup_executable adb http://sys-mobilehost/tools/adb/adb.tar.bz2
}

setup_fastboot()
{
  setup_executable fastboot http://sys-mobilehost/tools/fastboot/fastboot.tar.bz2
}

setup_mkimage()
{
  if [ -n "`uname -a | grep x86_64`" ]; then
	  MKIMAGE_ARCH=64
  else
	  MKIMAGE_ARCH=32
  fi

  setup_executable mkimage http://sys-mobilehost/tools/mkimage/mkimage_$MKIMAGE_ARCH.tar.bz2
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
[ -z "`which adb`" ] && setup_adb
[ -z "`which fastboot`" ] && setup_fastboot
[ -z "`which mkimage`" ] && setup_mkimage
[ -n "`which ccache`" ] && setup_ccache

