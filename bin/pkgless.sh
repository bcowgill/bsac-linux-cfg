#!/bin/bash
# cross-platform show all information about package
PKG=$1
if [ -z "$PKG" ]; then
	echo show a bunch of into about a package
	echo dpkg -l / apt-cache policy / apt-cache shopkg / apt-cache show / dpkg --print-avail / dlocate / brew info / brew list
	exit 1
else
	if which brew > /dev/null; then
		echo "### brew info"
		brew info $PKG
		echo "### brew list -- listing of files in package"
		brew list $PKG
		exit 0
	fi
	echo "### dpkg -l -- list exact"
	which dpkg > /dev/null  && dpkg -l $PKG
	echo "### apt-cache policy"
	which apt-cache > /dev/null  && apt-cache policy $PKG
	echo "### apt-cache showpkg -- package information"
	which apt-cache > /dev/null  && apt-cache showpkg $PKG
	echo "### apt-cache show -- package records"
	which apt-cache > /dev/null  && apt-cache show $PKG
	echo "### dpkg --print-avail"
	which dpkg > /dev/null  && dpkg --print-avail $PKG
	echo "### dlocate -- fast listing of files in package"
	which dpkg > /dev/null  && dpkg -L $PKG
fi
