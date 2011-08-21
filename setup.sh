#!/bin/bash

# remember current directory
CUR_DIR=`pwd`
DO_HELP=false
DO_CLEAN=false

COL_BRIGHT="\033[1m"
COL_NORMAL="\033[0m"

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

help_print_tool()
{
	printf "$COL_BRIGHT%-15s$COL_NORMAL - %s.\n" "$1 | $2" "$3"
}

usage()
{
	printf "Usage:\n"
	printf "     $ $COL_BRIGHT$0 [options]$COL_NORMAL\n"
	printf "\n"
	printf "Where 'options' is one of:\n"
	help_print_tool -c --clean "Clean up (reset) the project environment"
	help_print_tool -h --help "Display this message and exit"
	printf "\n"
	printf "Running without any options sets up the project environment.\n"
}

TEMP=`getopt -o c,h --long clean,help -- "$@"`
if [ $? != 0 ]; then
	echo "Terminating..." >&2;
	exit 1;
fi
eval set -- "$TEMP"

while true; do
	case "$1" in
		-h|--help)
			DO_HELP=true
			shift; break;;
		--) shift; break;;
		-c|--clean)
			DO_CLEAN=true
			shift; break;;
		--) shift; break;;
	*) echo "Illegal option: $1!"; exit 1;;
esac
done

if [ $DO_HELP == "true" ]; then
	# display usage
	usage
	exit 0
fi

if [ $DO_CLEAN == "true" ]; then
	printf "Nothing to do\n"
	exit 0
fi

# get prerequisite software
exec_script get_prerequisite_software.sh

# setup mobilehost gpg public key
exec_script setup_gpg_public_key.sh

# cd to execution direcory
cd 1>/dev/null $CUR_DIR

