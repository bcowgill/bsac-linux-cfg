#!/usr/bin/env perl
# convert input text from [cC]amelCase or snake_case to hyphen-case.
# See also camelCase.pl, CamelCaseX.pl, CONST_CASE.pl, hyphen-case.pl, snake_case.pl
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English;

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
