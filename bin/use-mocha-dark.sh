#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# find all mocha.css/js files and replace with a link to mocha-dark.css
# usage  use-mocha-dark.sh [dark|light|undo] [dir-to-mocha-dark]

DIR=`pwd`
USE=${1:-dark}
DARK_DIR=${2:-$DIR}
#echo "USE=$USE"

if [ $USE != dark ]; then
	if [ $USE != light ]; then
		if [ $USE != undo ]; then
			echo First parameter must be dark or light or undo, not $USE
			exit 1
		fi
	fi
fi

if [ ! -d "$DARK_DIR" ]; then
	echo $DARK_DIR is not a directory
	exit 1
fi

pushd $DARK_DIR > /dev/null
	DARK_DIR=`pwd`
popd > /dev/null

if [ ! -d "$DARK_DIR" ]; then
	echo $DARK_DIR is not a directory
	exit 1
fi
echo Will look for mocha-dark files somewhere within $DARK_DIR

# find the dark files to use
DARK_CSS=`find $DARK_DIR -type f -name mocha-dark.css | head -1`
DARK_JS=`find $DARK_DIR -type f -name mocha-dark.js | head -1`

DARK_CSS="$DARK_CSS"
DARK_JS="$DARK_JS"

if [ -z $DARK_CSS ]; then
	echo did not find a mocha-dark.css below $DARK_DIR
	exit 1
fi

if [ -z $DARK_JS ]; then
	echo did not find a mocha-dark.js below $DARK_DIR
	exit 1
fi

echo DARK_CSS="$DARK_CSS"
echo DARK_JS="$DARK_JS"

# now find all the mocha css/js files we need to replace
DIRS_TO_DO=`find . -name mocha.css -o -name mocha.js | perl -pne 's{/mocha\.(css|js)\s* \z}{\n}xmsg' | sort | uniq`
#echo DIRS_TO_DO="$DIRS_TO_DO"

if [ $USE == undo ]; then
	for dir in $DIRS_TO_DO; do
		echo undo mocha light/dark in dir $dir
		ls $dir/mocha* 2> /dev/null
		[ -L $dir/mocha-dark.js ]  && (echo remove mocha-dark.js in $dir; rm $dir/mocha-dark.js)
		[ -L $dir/mocha-dark.css ] && (echo remove mocha-dark.css in $dir; rm $dir/mocha-dark.css)
		[ -e $dir/mocha-dark.js ]  && (echo remove mocha-dark.js in $dir; rm $dir/mocha-dark.js)
		[ -e $dir/mocha-dark.css ] && (echo remove mocha-dark.css in $dir; rm $dir/mocha-dark.css)
		[ -L $dir/mocha.js ]  && (echo remove mocha.js link in $dir;  rm $dir/mocha.js)
		[ -L $dir/mocha.css ] && (echo remove mocha.css link in $dir; rm $dir/mocha.css)
		[ -e $dir/mocha-light.js ]  && (echo move mocha-light.js to mocha.js in $dir; mv $dir/mocha-light.js $dir/mocha.js)
		[ -e $dir/mocha-light.css ] && (echo move mocha-light.css to mocha.css in $dir; mv $dir/mocha-light.css $dir/mocha.css)
	done
else
	for dir in $DIRS_TO_DO; do
		echo making mocha $USE in dir $dir
	#	ls $dir/mocha* 2> /dev/null
		# make sure light/dark versions present
		[ -L $dir/mocha.js ]  || (echo move mocha.js file to light js version in $dir;  mv $dir/mocha.js $dir/mocha-light.js)
		[ -L $dir/mocha.css ] || (echo move mocha.css file to light css version in $dir; mv $dir/mocha.css $dir/mocha-light.css)
		[ -e $dir/mocha-dark.css ] || (echo put dark css version in $dir; ln -s $DARK_CSS $dir/mocha-dark.css)
		[ -e $dir/mocha-dark.js ]  || (echo make dark js version in $dir; make-mocha-dark.sh $dir/mocha-light.js > $dir/mocha-dark.js)

		# link to light/dark version
		[ -L $dir/mocha.js ]   && (echo remove mocha.js link in $dir;  rm $dir/mocha.js)
		[ -L $dir/mocha.css ]  && (echo remove mocha.css link in $dir; rm $dir/mocha.css)
		echo link mocha.js to mocha-$USE.js in $dir
		ln -s mocha-$USE.js $dir/mocha.js
		echo link mocha.css to mocha-$USE.css in $dir
		ln -s mocha-$USE.css $dir/mocha.css
	done
fi
