#!/usr/bin/env perl
# convert input text to CamelCase.

use strict;
use warnings;
use English;

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
