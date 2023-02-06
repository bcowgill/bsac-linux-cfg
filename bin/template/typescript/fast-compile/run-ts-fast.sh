#!/bin/bash

SCRIPT=${1:-my-script.ts}

if [ "pull" == "$1" ]; then
	echo Fetching libraries from github
	curl https://raw.githubusercontent.com/artemave/ts-swc-es-loader/main/loader.mjs -O
	curl https://raw.githubusercontent.com/artemave/ts-swc-es-loader/main/suppress-experimental-warnings.js -O
else
	node --require ./suppress-experimental-warnings.js --enable-source-maps --loader ./loader.mjs "$SCRIPT"
fi


