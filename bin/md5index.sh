#!/bin/bash
# parse a file N lines at a time giving the md5sum for each chunk.
# if you also specify a line number it will only show the chunk containing that line.
OUT=`mktemp`

FILE=$1
SHOW=$2

OUT=$OUT SHOW=$SHOW perl -ne '
	BEGIN
	{
		$BATCH = $ENV{BATCH} || 20;
		$out = $ENV{OUT};
		$show = $ENV{SHOW};
		$first = 1;
		@lines = ();
	}

	sub output
	{
		if ($show)
		{
			print qq{$first..$last:\n} . join("", @lines) if ($first <= $show && $show <= $last);
		}
		else
		{
			my $fh;
			open($fh, ">", $out) || die qq{$out: $_};
			print $fh join("", @lines);
			close($fh);
			`dos2unix -q $out`;
			my $sum = `md5sum $out`;
			my @parts = split(/\s/, $sum);
			print qq{$first..$last: $parts[0]\n};
		}
	}

	$last = $.;
	push(@lines, $_);
	if ($last % $BATCH == 0)
	{
		output();
		$first = $last + 1;
		@lines = ();
	}

	END
	{
		output() if (scalar(@lines));
	}
' "$FILE"

rm $OUT
