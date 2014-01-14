#!/bin/bash
# see info about a file/dir
ls -al $*
file $*
md5sum $*
if [ ! -d "$1" ]; then
   less "$1"
fi
