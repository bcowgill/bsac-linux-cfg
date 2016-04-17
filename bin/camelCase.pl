#!/usr/bin/env perl
# convert input text to camelCase.

use strict;
use warnings;
use English;

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
