#!/bin/bash
# jshint-add-complexity.sh [.jshintrc] [complexity]
# add/update the maxcomplexity jshint setting

FILE=${1:-.jshintrc}
export COMPLEXITY=${2:-4}
perl -i.bak -pne 's{("maxcomplexity"\s*:\s*)\d+}{$1$ENV{COMPLEXITY}}xmsg' $FILE
if grep maxcomplexity $FILE ; then
	echo OK complexity added
	exit 0
else
	perl -i.bak -pne 's{((\s*)"(node)"\s*:.+\n)}{$1$2"maxcomplexity": $ENV{COMPLEXITY},\n}xmsg' $FILE
fi

if grep maxcomplexity $FILE ; then
	echo OK complexity added
else
	echo NOT OK complexity not added
fi
