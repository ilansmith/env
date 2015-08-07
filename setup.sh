#!/bin/bash

# remember current directory
CUR_DIR=`pwd`
DO_CLEAN=false

# force script to run from within script directory
EXEC_PATH=`echo $0 | sed 's/\(.*\)\/[^\/]*$/\1/'`

# cd to scripts directory
cd 1>/dev/null $EXEC_PATH/scripts

source scripts.env

exec_script()
{
	SCRIPT=$1

	if [ $# == 2 ]; then
		if [ "$2" == "-" ]; then
			PRINTLN "$SCRIPT... skipped"
			return 0
		fi
	fi

	shift

	./$SCRIPT $@
	if [ $? -eq 0 ]; then
		PRINTLN "Done!"
	else
		PRINTLN "Failed, Aborting..."
		exit 1
	fi
}

TEMP=`getopt -o c --long clean -- "$@"`
if [ $? != 0 ]; then
	echo "Terminating..." >&2;
	exit 1;
fi
eval set -- "$TEMP"

while true; do
	case "$1" in
		-c|--clean)
			DO_CLEAN=true
			shift; break;;
		--) shift; break;;
	*) echo "Illegal option: $1!"; exit 1;;
esac
done

if [ $DO_CLEAN == "true" ]; then
	# clean the patch directory
	exec_script patch_kernel.sh 0
	exit 0
fi

# get prerequisite software
exec_script get_prerequisite_software.sh

# patch the kernel
exec_script patch_kernel.sh 1

# setup mobilehost gpg public key
exec_script setup_gpg_public_key.sh

# cd to execution direcory
cd 1>/dev/null $CUR_DIR

