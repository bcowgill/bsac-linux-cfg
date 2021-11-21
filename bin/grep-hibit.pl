#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [file ...]

Search standard input or files for non-alpha characters (unicode, accented letters, etc)

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

See also utf8dbg.pl, utf8-view.sh, grep-bad-utf8.pl, utf2entity.pl and other unicode tools.

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

while (my $line = <>)
{
	# find first byte with high bit set
	$line =~ m{ ^ ([\x00-\x7f]*) (.*) $ }xms;

	# display filename, line and column number if there is a match
	print "$ARGV:$.:" . ($-[2]+1) . ":$line" if length($2);
}

__END__
