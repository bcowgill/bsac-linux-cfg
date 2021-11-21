#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [file ...]

Locate malformed utf8 sequences from standard input or a file.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

See also grep-hibit.pl, utf8-view.sh, utf8dbg.pl, utf82entity.pl and other unicode tools.

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

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

__END__
