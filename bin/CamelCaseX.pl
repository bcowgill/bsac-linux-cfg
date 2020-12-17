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

Convert standard input text from [cC]amelCase, hyphen-case, or snake_case to CamelCase.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Note: it is named CamelCaseX.pl so that file systems which ignore case differences can distinguish from camelCase.pl

See also camelCase.pl, CamelCaseX.pl, CONST_CASE.pl, hyphen-case.pl, snake_case.pl

Example:

echo THIS_IS_CONST_CASE | $FindBin::Script

USAGE
	exit 0;
}

if (scalar(@ARGV[0]) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

sub CamelCase {
	my ($phrase) = @ARG;
	$phrase =~ s{([a-z0-9])([A-Z])}{${1}_$2}xmsg;
	my @words = split(/[-_]/, lc($phrase));
	if (scalar(@words) > 1) {
		$phrase = join('', map {
				ucfirst($ARG);
			} @words);
	}
	return $phrase;
}

while (my $line = <>) {
	$line =~ s{([\-\w]+)}{CamelCase($1)}xmsge;
	print $line;
}

__END__
