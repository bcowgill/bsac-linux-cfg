#!/usr/bin/env perl
# Filter out all punctuation and reduce spacing to single
use strict;
use warnings;
use English -no_match_vars;

while (my $line = <>) {
	$line =~ s{[<>'"`]+}{ }xmsg;
	$line =~ s{\s\s+}{ }xmsg;
	print "$line\n";
}
