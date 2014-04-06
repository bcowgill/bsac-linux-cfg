#!/bin/bash
# find packages and files
PKG=$1
echo "### dpkg -l * -- list similar"
which dpkg > /dev/null  && dpkg -l *$PKG*
echo "### apt-cache search -- search similar"
which apt-cache > /dev/null && apt-cache search $PKG

