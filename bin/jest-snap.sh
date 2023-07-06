#!/bin/bash

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] path/__snapshots__/suite.test.js.snap

This will split a jest unit test snapshot file into individual snapshot files so you can use a visual comparison tool on them.

path/.. the file name for the jest snapshot file to split.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

More detail the snapshot files will be created in the current directory named jest-snap-A.snap

A list of vdiff commands are also displayed for comparing the first snapshot file against each other one so you can easily copy and paste to compare them.

See also vdiff.sh, rvdiff.sh and their aliases vdiff, rvdiff
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

FILE="$1"

perl -e '
	$count = 0;
	my $source = $ARGV[0];
	my $preamble = qq{// $source\n};
	my $fh;
	my $file;
	while (my $line = <>)
	{
		if ($line =~ m{\Aexports\[}xms)
		{
			close($fh) if $file;
			my $char = chr(ord("a") + $count);
			$file = "jest-snap-$char.snap";
			++$count;
			open($fh, ">", $file) || die "create $file: $!";
			print $fh qq{// $file\n$preamble$line};
		}
		elsif ($file)
		{
			print $fh $line;
		}
		else
		{
			$preamble .= $line;
		}
		END
		{
			exit(1) unless ($count);
			print qq{$count jest-snap-*.snap file created from jest snapshot file.\n};
			foreach my $which (1 .. $count - 1)
			{
				my $char = chr(ord("a") + $which);
				print qq{vdiff jest-snap-a.snap jest-snap-$char.snap\n};
			}
		}
	}
' "$FILE"
