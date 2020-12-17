#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English;
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Convert standard input text from [cC]amelCase, hyphen-case, or snake_case to camelCase.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

See also camelCase.pl, CamelCaseX.pl, CONST_CASE.pl, hyphen-case.pl, snake_case.pl

Example:

echo this_is_snake_case | $FindBin::Script

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}


sub camelCase {
	my ($phrase) = @ARG;
	$phrase =~ s{([a-z0-9])([A-Z])}{${1}_$2}xmsg;
	my @words = split(/[-_]/, lc($phrase));
	my $letterNum = 0;
	$phrase = join('', map {
			(0 == $letterNum++) ? $ARG : ucfirst($ARG);
		} @words);
	return $phrase;
}

while (my $line = <>) {
	$line =~ s{([\-\w]+)}{camelCase($1)}xmsge;
	print $line;
}


__END__
