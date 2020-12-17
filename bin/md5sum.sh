#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# md5sum wrapper to handle file names with spaces in them.

# md5sum.sh directory 2>&1 | tee md5sum.lst
# md5sum --check md5sum.lst

DIR=${1:-.}
find $DIR -type f | perl -ne 'chomp; system(qq{md5sum "$_"})'
