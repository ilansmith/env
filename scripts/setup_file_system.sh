#!/bin/bash

if [ ! -f scripts.env ]; then
  echo "Error: file_system.sh must be executed inside the scripts directory."
  exit 1
fi

source scripts.env

MYFS_DIR=myfs
MYFS_TAR_BZ2=$MYFS_DIR.tar.bz2
ANS_YES="yes"
ANS_NO="no"
ANS_ABORT="abort"

PRINT "Setting Up File System..."

# detect existing myfs directory
if [ -d $BASE_PATH/$MYFS_DIR ]; then
  echo "A file system direcotry exists. Do you want to back it up? [$ANS_YES/$ANS_NO/$ANS_ABORT]"
  while [ "$IS_DO_BACKUP" != "$ANS_YES" -a "$IS_DO_BACKUP" != "$ANS_NO" -a "$IS_DO_BACKUP" != "$ANS_ABORT" ]; do
    read IS_DO_BACKUP
  done
fi

# abort
if [ "$IS_DO_BACKUP" == $ANS_ABORT ]; then
  PRINT "Aborting..."
  exit 0
fi

# wget myfs
if [ ! -f $BINARIES_PATH/$MYFS_TAR_BZ2 ]; then
  PRINT "Getting $MYFS_DIR..."
  DO_QUITE_CD $BINARIES_PATH
  wget http://sys-mobilehost/emmc/ti/omap4/pandaboard/rls-27.12.1-p2/$MYFS_TAR_BZ2
  DO_QUITE_CD $SCRIPTS_PATH
fi

# do backup
if [ "$IS_DO_BACKUP" == $ANS_YES ]; then
  BCK_FILE_NAME=$MYFS_DIR-$GIT_EMAIL_USER-`date +%G_%m_%e-%H_%M_%S`.tar.bz2

  DO_QUITE_CD $BASE_PATH
  DO_QUITE_TAR cjf $BINARIES_BCK_PATH/$BCK_FILE_NAME $MYFS_DIR
  DO_QUITE_CD $SCRIPTS_PATH

  PRINT "Backed up current $MYFS_DIR at:"
  printf "%s\n" "$BINARIES_BCK_PATH/$BCK_FILE_NAME"
fi

# extract fresh copy of myfs
PRINT "Installing $MYFS_DIR..."
DO_QUITE_CD $BASE_PATH
rm -rf $MYFS_DIR
cp $BINARIES_PATH/$MYFS_TAR_BZ2 .
DO_QUITE_TAR xjf $MYFS_TAR_BZ2
rm -f $MYFS_TAR_BZ2
DO_QUITE_CD $SCRIPTS_PATH

PRINT "Done!"

