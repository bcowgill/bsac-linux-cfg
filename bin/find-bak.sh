#!/bin/bash
# find all backup files in current directory

# use find-bak.sh -delete
# to delete the files found
# See also find-bak.sh find-git.sh clean-git.sh clean.sh
# WINDEV tool useful on windows development machine

PRINT=
if [ -z "$1" ]; then
	PRINT=-print
fi

find . \( \
	-name node_modules \
\) \
-prune -o \( \
	-iname '*.bak' \
	-o -name '*~' \
	-o -name '*.rej' \
\) $* $PRINT
# -o -name '*.orig'
