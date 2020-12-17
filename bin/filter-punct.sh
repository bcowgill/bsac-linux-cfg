#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Filter out all punctuation and reduce spacing to single
# See also filter-built-files.sh, filter-code-files.sh, filter-indents.sh, filter-punct.sh
# WINDEV tool useful on windows development machine
use strict;
use warnings;
use English -no_match_vars;

while (my $line = <>) {
	$line =~ s{[<>'"`]+}{ }xmsg;
	$line =~ s{\s\s+}{ }xmsg;
	print "$line\n";
}
