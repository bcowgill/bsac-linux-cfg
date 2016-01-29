#!/bin/bash
# jshint-set-complexity-js.sh [complexity:1] files
# update any maxcomplexity jshint settings within javascript files.

function usage {
    echo usage: $0 [complexity] file ...
    echo This will change all jshint maxcomplexity settings found in files.
    echo The default complexity setting will be 1 if omitted.
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
