#!/bin/bash
# find all mocha.css/js files and replace with a link to mocha-dark.css

# find the dark files to use
DIR=`pwd`
DARK_CSS=`find . -type f -name mocha-dark.css | head -1`
DARK_JS=`find . -type f -name mocha-dark.js | head -1`

if [ -z $DARK_CSS ]; then
	echo did not find a mocha-dark.css below $DIR
	exit 1
fi

if [ -z $DARK_JS ]; then
	echo did not find a mocha-dark.js below $DIR
	exit 1
fi

echo DARK_CSS="$DIR/$DARK_CSS"
echo DARK_JS="$DIR/$DARK_JS"

# now find all the mocha css/js files we need to replace
find . -type f -name mocha.css
find . -type f -name mocha.js

