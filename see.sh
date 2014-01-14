#!/bin/bash
# see info about a file/dir
ls -al $*
if [ ! -d "$1" ]; then
   less "$1"
   file $*
   md5sum $*
fi
