#!/bin/bash
# find packages and files
PKG=$1
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
