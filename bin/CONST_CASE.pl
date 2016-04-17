#!/usr/bin/env perl
# convert input text from [cC]amelCase or snake_case to CONST_CASE.

use strict;
use warnings;
use English;

sub CONST_CASE {
	my ($phrase) = @ARG;
	$phrase =~ s{([a-z0-9])([A-Z])}{${1}_$2}xmsg;
	my @words = split(/[-_]/, uc($phrase));
	$phrase = join('_', @words);
	return $phrase;
}

while (my $line = <>) {
	$line =~ s{([\-\w]+)}{CONST_CASE($1)}xmsge;
	print $line;
}
