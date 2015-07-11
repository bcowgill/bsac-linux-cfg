#!/bin/bash
# find all mocha.css/js files and replace with a link to mocha-dark.css

USE=${1:-dark}
#echo "USE=$USE"

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

DARK_CSS="$DIR/$DARK_CSS"
DARK_JS="$DIR/$DARK_JS"

echo DARK_CSS="$DARK_CSS"
echo DARK_JS="$DARK_JS"

# now find all the mocha css/js files we need to replace
DIRS_TO_DO=`find . -name mocha.css -o -name mocha.js | perl -pne 's{/mocha\.(css|js)\s* \z}{\n}xmsg' | sort | uniq`
#echo DIRS_TO_DO="$DIRS_TO_DO"

for dir in $DIRS_TO_DO; do
	echo making mocha $USE in dir $dir
#	ls $dir/mocha* 2> /dev/null
	# make sure light/dark versions present
	[ -e $dir/mocha-dark.js ]  || (echo put dark js version in $dir;  ln -s $DARK_JS $dir/mocha-dark.js)
	[ -e $dir/mocha-dark.css ] || (echo put dark css version in $dir; ln -s $DARK_CSS $dir/mocha-dark.css)
	[ -L $dir/mocha.js ]  || (echo move mocha.js file to light js version in $dir;  mv $dir/mocha.js $dir/mocha-light.js)
	[ -L $dir/mocha.css ] || (echo move mocha.css file to light css version in $dir; mv $dir/mocha.css $dir/mocha-light.css)

	# link to light/dark version
	[ -L $dir/mocha.js ]   && (echo remove mocha.js link in $dir;  rm $dir/mocha.js)
	[ -L $dir/mocha.css ]  && (echo remove mocha.css link in $dir; rm $dir/mocha.css)
	echo link mocha.js to mocha-$USE.js in $dir
	ln -s mocha-$USE.js $dir/mocha.js
	echo link mocha.css to mocha-$USE.css in $dir
	ln -s mocha-$USE.css $dir/mocha.css
done

