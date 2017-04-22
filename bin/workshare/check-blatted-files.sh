#!/bin/bash
# check for zero size files which have been blatted somehow
BLATTED=`\
find . \( \
	-name .tmp \
	-o -name node_modules \
	-o -path ./dist \
	-o -path ./webui \
	-o -path ./build-test \
	-o -path ./coverage \
\) \
-prune -o -size 0 \
| egrep -v '(/\.tmp|\./dist|\./webui|\./build|\./coverage|node_modules|\.log$|\.timestamp$|~$)' \
`
if [ ! -z "$BLATTED" ]; then
	echo WARNING some of your files are zero sized! have they been blatted?
	echo $BLATTED
	#exit 1
	#it's a warning - don't break the build
fi
