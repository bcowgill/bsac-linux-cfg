#!/bin/bash

OUT=./man
INDEX=$OUT/_help.txt

function usage {
	local code
	code=$1
	echo "
$(basename $0) [--make] [--list] [--help|-?]

This will generate a 'help' file for all my bin/ tools.  It runs every tool with --help and stores the output in a help.txt file so you can grep for a specific tool.

--list  Scan the tools and list the ones which have --help options.
--make  Generate the help file for all tools in current directory.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi
TOOLS=`grep -lE '\-\-help' *.sh *.pl *.py | sort`
if [ "$1" == "--list" ]; then
	for tool in $TOOLS
	do
		echo $tool
	done
	exit 0
fi

if [ "$1" == "--make" ]; then
	[ -d $OUT ] || mkdir -p $OUT
	line.sh "Created by help.sh" > $INDEX
	datestamp.sh >> $INDEX
	for tool in $TOOLS
	do
		# TODO how to generate a real man page usable with man command?
		$tool --help > $OUT/$tool.man
		line.sh $tool >> $INDEX
		cat $OUT/$tool.man >> $INDEX
	done
fi
