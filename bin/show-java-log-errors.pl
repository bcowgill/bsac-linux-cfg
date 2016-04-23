#!/usr/bin/env perl
# parse a java log file and only show warnings and errors
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
