#!/bin/bash
# cross-platform find packages and files
PKG=$1
if [ -z "$PKG" ]; then
	echo find packages and files
	echo dpkg -l / dlocate / dpkg -L / apt-file search / dpkg -S / brew info / brew search / brew list
	exit 1
else
	if which brew > /dev/null; then
		echo "### brew info"
		brew info $PKG
		echo "### brew search"
		brew search /$PKG/ | sort
		echo "### brew search --desc"
		brew search --desc /$PKG/
		echo "### brew list -- listing of files in package"
		brew list $PKG
		exit 0
	fi
	echo "### dpkg -l -- list exact"
	which dpkg > /dev/null  && dpkg -l $PKG
	echo "### dlocate -- fast listing of files in package"
	which dlocate > /dev/null  && dlocate $PKG
	echo "### dpkg -L -- files installed by package (slow)"
	which dpkg > /dev/null  && dpkg -L $PKG
	echo "### apt-file search -- what package contains a file"
	which apt-file > /dev/null  && apt-file search $PKG
	echo "### dpkg -S -- similar named files (slow)"
	# a slower version of dlocate
	which dpkg > /dev/null  && dpkg -S $PKG
fi
