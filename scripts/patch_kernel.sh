#!/bin/bash

if [ ! -f scripts.env ]; then
	echo "Error: patch_kernel.sh must be executed inside the scripts directory."
	exit 1
fi

source scripts.env

KERNEL_DIRS="$KERNEL_PATH/patches $KERNEL_PATH/runtime"

do_clean()
{
	PRINT "Cleaning kernel patches... "
	rm -rf $KERNEL_DIRS
	PRINTLN "done"
}

do_patch()
{
	PRINTLN "Applying kernel patches..."
	mkdir -p $KERNEL_DIRS
	for p in `cat ../patches`; do
		echo -n "patching $p... "
		patch -p1 -d $KERNEL_PATH/patches --force --no-backup-if-mismatch --reject-file=- < $UNIT_TEST_PATH/$p > /dev/null
		echo "done"
	done
}

if [ $# -ne 1 ]; then
	echo "usage: $0 < 0 | 1 >"
	exit 1
elif [ $1 -eq 0 ]; then
	do_clean
else
	do_patch
fi

