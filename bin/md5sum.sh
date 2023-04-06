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
find $DIR -type f \
	| sort \
	| MD5=$MD5 perl -ne 'chomp; system(qq{$ENV{MD5} "$_"})' \
	| perl -pne 's{\AMD5\s+\((.+)\)\s*=\s*([0-9a-f]+)\s*\z}{$2  $1\n}xmsg'
exit $?
Sample Linux output with md5sum command...
119145aa148d9cb14c900370ce7eddcd  tx/c/d/bin/pee.pl
7e795e8d7b41fa6adf7a32f2dac061d6  tx/c/d/bin/cover-one.sh
65966141e5aa8dc7efaab4d360ebff04  tx/c/d/bin/calc.sh

Sample Mac output with md5 command...
MD5 (tx/c/Users/FILEID/my-git-tools.pl.txt) = e89e97204bc24676c32797b2eb01ff24
MD5 (tx/c/Users/FILEID/.bash_functions) = ee6bb991de53b138af8fb4d35c924dfe
MD5 (tx/c/Users/FILEID/kdiff3.config) = 04f17f4b4bbcb6253a4f88a3b5172f3e
MD5 (tx/c/Users/FILEID/bin/rvdiff.sh) = a353b39332938c43bd9d423db25d698c
