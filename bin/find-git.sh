#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find files that git leaves around after a merge conflict
# find-git.sh rm  to remove the files
# See also find-bak.sh find-git.sh clean-git.sh clean.sh
# WINDEV tool useful on windows development machine

LS=${1:-ls}
$LS `find . \( \
	-name .git \
	-o -name .tmp \
	-o -name node_modules \
	-o -name bower_components \
	\) \
	-prune -o \( \
		-name '*.orig' \
		-o -name '*.RESTORE' \
		-o -name '*_REMOTE_*' \
		-o -name '*_LOCAL_*' \
		-o -name '*_BACKUP_*' \
		-o -name '*_BASE_*' \
	\) -print \
	| perl -pne 's{\.orig}{?*}'`

# are these from git?
#	-o -name '.#*' \
#	-o -name '#*#$' \
