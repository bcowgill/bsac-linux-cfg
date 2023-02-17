#!/bin/bash

TIME="time -p"
SCRIPT=${1:-src/index.ts}
shift

if [ ! -z "$NODE_TEST" ]; then
	TIME=
fi

if [ "pull" == "$1" ]; then
	echo Fetching libraries from github
	curl https://raw.githubusercontent.com/artemave/ts-swc-es-loader/main/loader.mjs -O
	curl https://raw.githubusercontent.com/artemave/ts-swc-es-loader/main/suppress-experimental-warnings.js -O
else
	$TIME node $* --require ./suppress-experimental-warnings.js --enable-source-maps --loader ./loader.mjs "$SCRIPT"
fi


