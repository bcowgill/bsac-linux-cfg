#!/usr/bin/env perl
# locate malformed utf8 sequences
# WINDEV tool useful on windows development machine

use strict;

while (my $line = <>)
{
	$line =~ m{
		^
		(
			(
				[\x00-\x7f] |
				[\xc0-\xdf][\x80-\xbf] |
				[\xe0-\xef][\x80-\xbf]{2} |
				[\xf0-\xf7][\x80-\xbf]{3}
			)*
		)
		(.*)
		$
	}xms;

	print "$ARGV:$.:".($-[3]+1).":$line" if length($3);
}
