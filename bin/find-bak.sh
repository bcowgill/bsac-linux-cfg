#!/bin/bash
# find all backup files in current directory

# use find-bak.sh -delete
# to delete the files found
find . \( \
	-name node_modules \
\) \
-prune -o \( \
	-iname '*.bak' \
	-o -name '*~' \
	-o -name '*.rej' \
\) $*
# -o -name '*.orig'
