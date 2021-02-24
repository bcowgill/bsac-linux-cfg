#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# check for zero size files which have been blatted somehow
# WINDEV tool useful on windows development machine
# CUSTOM settings you may need to change on a new computer
BLATTED=`\
find . \( \
	-name .tmp \
	-o -name node_modules \
	-o -name bower_components \
	-o -name .git \
	-o -path ./dist \
	-o -path ./coverage \
\) \
-prune -o -size 0 \
| egrep -v '(/\.(tmp|git|idea)|\./(dist|coverage)|node_modules|bower_components|\.(log|timestamp)$|~$)' \
`
if [ ! -z "$BLATTED" ]; then
	echo WARNING some of your files are zero sized! have they been blatted?
	echo $BLATTED
	exit 1
fi
