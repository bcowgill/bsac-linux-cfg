#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# convert input text from [cC]amelCase to snake_case.
# See also camelCase.pl, CamelCaseX.pl, CONST_CASE.pl, hyphen-case.pl, snake_case.pl
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English;

sub snake_case {
	my ($phrase) = @ARG;
	$phrase =~ s{([a-z0-9])([A-Z])}{${1}_$2}xmsg;
	my @words = split(/[-_]/, lc($phrase));
	$phrase = join('_', @words);
	return $phrase;
}

while (my $line = <>) {
	$line =~ s{([\-\w]+)}{snake_case($1)}xmsge;
	print $line;
}
