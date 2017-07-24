#!/bin/bash
# find all backup files in current directory

# use find-bak.sh -delete
# to delete the files found
find . \( -iname '*.bak' -o -name '*~' -o -name '*.rej' \) $*
#find . \( -iname '*.bak' -o -name '*~' -o -name '*.orig' -o -name '*.rej' \) $*
