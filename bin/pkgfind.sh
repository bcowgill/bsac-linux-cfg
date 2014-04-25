#!/bin/bash
PKG=$1
if [ -z "$PKG" ]; then
   echo find similarly named packages and files
   exit 1
else
   echo "### dpkg -l * -- list similar"
   which dpkg > /dev/null  && dpkg -l *$PKG*
   echo "### apt-cache search -- search similar"
   which apt-cache > /dev/null && apt-cache search $PKG
fi
