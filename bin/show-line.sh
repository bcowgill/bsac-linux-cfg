#!/bin/bash

COL=1
WINDOW=3

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] line [column] [line-window] file

This will show you the exact place by line and column within the file indicated.

line    The line number of the specified file.
column  optional. The column number to indicate. defaults to $COL.
line-window optional. The number of lines before and after to show as context. defaults to $WINDOW.
file    The name of the file to show the location context.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also json-syntax.pl head tail
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

LINE=$1

if [ -z "$1" ]; then
	usage 1
fi

shift
if [ -z "$1" ]; then
	usage 2
fi
if [ ! -e "$1" ]; then
	COL=$1
	shift
fi
if [ -z "$1" ]; then
	usage 3
fi
if [ ! -e "$1" ]; then
	WINDOW=$1
	shift
fi
if [ -z "$1" ]; then
	usage 4
fi

#echo LINE=$LINE COL=$COL WINDOW=$WINDOW

C=$COL L=$LINE W=$WINDOW perl -ne '
	#my $down = "⬇";
	#my $up = "⬆";
	my $down = "∇";
	my $up = "Δ";
	my $left = "⍈";
	my $right = "⍇";
	my $pre = qq{$.: };
	if ($. == $ENV{L})
	{
		my $in = "-" x ($ENV{C});
		print qq{$pre$in$down\n};

		chomp;
		$_ .= " " x ($ENV{C} - length($_));
		my $start = substr($_, 0, $ENV{C} - 1);
		my $char  = substr($_, $ENV{C} - 1, 1);
		my $end   = substr($_, $ENV{C});
		print qq{$pre$start$left$char$right$end\n};
	}
	if (abs($.+0.5 - $ENV{L}) <= $ENV{W} && $. != $ENV{L})
	{
		print qq{$pre$_};
	}
	if ($. == $ENV{L})
	{
		$in = "-" x ($ENV{C});
		print qq{$pre$in$up\n};
	}
' $*

#⬆
#⬇∇Δ
#⍇
#⍈
