#!/usr/bin/env perl
# filter out all indentation from a file
# See also filter-built-files.sh, filter-code-files.sh, filter-indents.sh, filter-punct.sh
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English -mo_match_vars;

while (my $line = <>) {
	chomp($line);
	$line =~ s{ \A \s+ }{}xmsg;
	print "$line\n";
}

