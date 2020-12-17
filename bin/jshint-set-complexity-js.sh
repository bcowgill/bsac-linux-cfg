#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# jshint-set-complexity-js.sh [complexity:1] files
# update any maxcomplexity jshint settings within javascript files.

function usage {
    echo "
usage: $(basename $0) [complexity] file ...

This will change all jshint maxcomplexity settings found in files.
The default complexity setting will be 1 if omitted.
"
    exit 1
}

if [ -z "$1" ]; then
    usage;
fi

if [ -f "$1" ]; then
    export COMPLEXITY=1
else
    export COMPLEXITY=$1
    shift
fi

#echo COMPLEXITY=$COMPLEXITY
#echo $*

if [ -z "$1" ]; then
    usage;
fi

perl -i.bak -pne 's{(maxcomplexity\s*:\s*)\d+}{$1$ENV{COMPLEXITY}}xmsg' $*
