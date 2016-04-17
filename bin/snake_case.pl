#!/usr/bin/env perl
# convert input text from [cC]amelCase to snake_case.

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
