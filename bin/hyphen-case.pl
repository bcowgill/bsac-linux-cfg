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
$FindBin::Script [--help|--man|-?] [file ...]

Convert standard input text from [cC]amelCase, CONST_CASE, or snake_case to hyphen-case.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

More detail ...

# See also camelCase.pl, CamelCaseX.pl, CONST_CASE.pl, hyphen-case.pl, snake_case.pl

Example:

echo thisIsCamelCase | $FindBin::Script

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}


sub hyphen_case {
	my ($phrase) = @ARG;
	$phrase =~ s{([a-z0-9])([A-Z])}{${1}-$2}xmsg;
	my @words = split(/[-_]/, lc($phrase));
	$phrase = join('-', @words);
	return $phrase;
}

while (my $line = <>) {
	$line =~ s{([\-\w]+)}{hyphen_case($1)}xmsge;
	print $line;
}

__END__
