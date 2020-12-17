#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# parse a java log file and only show warnings and errors
# WINDEV tool useful on windows development machine
use strict;
use warnings;
use English;

my $is_match = 0;

while (my $line = <>)
{
	# DEBUG YYYY-MM-DD HH:MM:SS ....
	if ($line =~ m{\A ([A-Z]+) \s+ \d+-\d+-\d+ \s \d+:\d+:\d+}xms)
	{
		$is_match = $1 =~ m{\A (ERROR | WARN) \z}xms;
	}
	else
	{
		print "   " if $is_match;
	}
	print $line if $is_match;
}
