#!/bin/bash

# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# TODO if pod2usage present in perl file use --man option for the help page

OUT=./man
INDEX=$OUT/_help.txt

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--add file...] [--make] [--list] [--help|--man|-?]

This will generate a 'help' file for all my bin/ tools.  It runs every tool with --help and stores the output in a help.txt file so you can grep for a specific tool.

--list  Scan the tools and list the ones which have --help options.
--add   Add boilerplate help to a tool if it doesn't have it.
--make  Generate the help file for all tools in current directory.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Example:

	Find all WINDEV marked tools and add help boilerplate as needed.

	$cmd --add \`grep WINDEV *.*\`
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
	echo "Created by help.sh" | line.sh > $INDEX
	datestamp.sh >> $INDEX
	for tool in $TOOLS
	do
		# TODO how to generate a real man page usable with man command?
		$tool --help > $OUT/$tool.man
		echo $tool | line.sh >> $INDEX
		cat $OUT/$tool.man >> $INDEX
	done
fi

if [ "$1" == "--add"  ]; then
	shift
	for file in $*
	do
		echo $file
		if grep -E '\-\-help' $file > /dev/null ; then
			echo Already has a --help option
		else
			if grep '#!' $file | grep perl > /dev/null ; then
				echo $file: Adding perl help boilerplate
				echo '
__END__
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Display a description of the program.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

More detail ...

See also ...

Example:

echo filename | $FindBin::Script

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}
' >> $file
			else
				echo $file: Adding shell help boilerplate
				echo '
exit 0
function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?]

This will ...

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

More detail ...

See also ...

Example:

...
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
' >> $file
			fi
			$EDITOR $file
		fi
	done
fi

exit 0
