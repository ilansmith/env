#!/bin/bash

if [ ! -f scripts.env ]; then
	echo "Error: get_prerequisit_software.sh must be executed inside the scripts directory."
	exit 1
fi

source scripts.env

MISSING=""
PACKAGES_RECOMMENDED_GENERIC="git valgrind"

read_os_release()
{
	echo "`cat /etc/os-release | grep \"^$1=\" | awk -F= '{ print $2 }' | sed 's%\"%%g'`"
}

test_installed_ubuntu()
{
	dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed"
}

test_installed_rhel()
{
	yum list installed $1 > /dev/null 2>&1; echo $?
}

test_installed()
{
	OS_ID="`read_os_release ID`"
	OS_NAME="`read_os_release NAME`"

	case $OS_ID in
		ubuntu)
			echo `test_installed_ubuntu $1`
			;;
		rhel)
			echo ! `test_installed_rhel $1`
			;;
		*)
			echo "OS $OS_NAME not supported."
			exit 1
			;;
	esac
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

