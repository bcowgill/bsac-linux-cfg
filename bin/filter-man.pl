#!/usr/bin/env perl

use strict;
use warnings;
use English qw(-no_match_vars);
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Filter out man page magic characters and the TODO section.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Used for unit testing of help page for scripts by excluding the TODO section which changes regularly.

See also man, pee.pl. filter-script.pl, filter-whitespace.pl

Example:

man command | $FindBin::Script

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my $ESC = chr(27);
my $BS  = chr(8);

my $skip = 0;
my $header = 1;

while (<>)
{
	s{$ESC \[ [01]m }{}xmsg;
	s{.$BS}{}xmsg;

	if (m{\ANAME}xms)
	{
		$header = 0;
	}
	if (m{\ATODO}xms)
	{
		$skip = 1;
	}
	print unless ($skip || $header);
}
__END__
