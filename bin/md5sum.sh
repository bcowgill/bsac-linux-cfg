#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# md5sum wrapper to handle file names with spaces in them.

# md5sum.sh directory 2>&1 | tee md5sum.lst
# md5sum --check md5sum.lst

DIR=${1:-.}
MD5=md5sum
if which md5 > /dev/null 2> /dev/null; then
	MD5=md5
fi
find $DIR -type f | MD5=$MD5 perl -ne 'chomp; system(qq{$ENV{MD5} "$_"})'
