#!/bin/bash
# add the jsdoc @class and @extends tags to a javascript class file
# if no file name given it scans for lib/scripts or app/scripts files
#
# will add the following jsdoc to code:
#
# /**
#	@class CLASSNAME
#	@extends PARENT
# */
# var CLASSNAME = PARENT.extend({ ...
# });
# return CLASSNAME;

if [ -z $1 ]; then
	FILES=`(git grep -L '@class' lib/scripts/ ; git grep -L '@class' app/scripts/) 2> /dev/null | egrep '\.js$'`
	if [ -z "$FILES" ]; then
	    echo usage: $0 filename
	    echo " "
	    echo Will add @class jsdoc tag to a javascript file.
	    echo Will scan lib/scripts and app/scripts for files if none specified
	fi
	for file in $FILES
	do
		add-class-doctag.sh $file
	done
	exit 0;
fi

FILE="$1"
export CLASSNAME=$(basename $FILE .js)

perl -i.bak -pne '
BEGIN {
	$indent = " " x 4;
	$class=$ENV{CLASSNAME};
}

if (!$found && s{
		\A (\s+) (?:return|var \s+ \w+ \s*=) ( \s+ ([\w\.]+) \.extend\( )
	}{
		"$1/**\n$1$indent\@class $class\n$1$indent\@extends $3\n$1*/\n$1var $class =$2"
	}xmse)
{
	$found=1;
}

if ($found)
{
	s{\A (\}\);)}{${indent}return $class;\n$1}xmsg;
}
' $FILE
