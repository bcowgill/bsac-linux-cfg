#!/bin/bash

export LC_ALL='C'
OUT=/cygdrive/d/d/Sys/_initial-state

cd /cygdrive/c
df -k > $OUT/disk-df-k-initial.txt

du -sk -- * | sort -n -r | tee $OUT/disk-usage-initial.txt

du -k -- | sort -n -r | tee $OUT/disk-usage-full-initial.txt

find . -type f | sort -d | tee $OUT/all-files-c-drive.txt

