#!/bin/bash
# Split a jest __snapshot__/test.js.snap file into individual test case files for comparison
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
			foreach my $which (1 .. $count - 1)
			{
				my $char = chr(ord("a") + $which);
				print qq{vdiff.sh jest-snap-a.snap jest-snap-$char.snap};
			}
		}
	}
' "$FILE"
