#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
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
	-o -name '*.RESTORE' \
	-o -name '*_REMOTE_*' \
	-o -name '*_LOCAL_*' \
	-o -name '*_BACKUP_*' \
	-o -name '*_BASE_*' \
\) $* $PRINT
# -o -name '*.orig'
