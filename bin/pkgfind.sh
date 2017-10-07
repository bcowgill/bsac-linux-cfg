#!/bin/bash
# cross-platform find similarly named packages
PKG=$1
if [ -z "$PKG" ]; then
	echo find similarly named packages and files
	exit 1
else
	if which brew > /dev/null; then
		echo "### brew list -- locally similar"
		brew list | grep $PKG
		echo "### brew search"
		brew search /$PKG/ | sort
		echo "### brew search --desc"
		brew search --desc /$PKG/
		exit 0
	fi
	echo "### dpkg -l * -- list similar"
	which dpkg > /dev/null  && dpkg -l *$PKG*
	echo "### apt-cache search -- search similar"
	which apt-cache > /dev/null && apt-cache search $PKG
fi
