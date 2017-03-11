#!/bin/bash
# get disk space used on windows maching for config records

CDIR=/cygdrive/c
OUT=/cygdrive/d/d/Sys/_initial-state

export LC_ALL='C'

cd $CDIR
df -k > $OUT/disk-df-k-initial.txt

du -sk -- * | sort -n -r | tee $OUT/disk-usage-initial.txt

du -k -- | sort -n -r | tee $OUT/disk-usage-full-initial.txt

find . -type f | sort -d | tee $OUT/all-files-c-drive.txt

