#!/bin/bash

if [ ! -f scripts.env ]; then
	echo "Error: get_prerequisit_software.sh must be executed inside the scripts directory."
	exit 1
fi

source scripts.env

MISSING=""
PACKAGES_RECOMMENDED_GENERIC="git"

test_installed()
{
	dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

PRINTLN "Checking for prerequisite software..."
for app in $PACKAGES_RECOMMENDED_GENERIC; do
	echo -n "checking $app... "

	INSTALLED=`test_installed $app`
	if [ $INSTALLED -eq 1 ]; then
		echo "ok"
	else
		echo "missing"
		MISSING+=" $app"
	fi
done

if [ -n "$MISSING" ]; then
	echo
	echo "Please install the following packages:$MISSING"
	exit 1
fi

exit 0

