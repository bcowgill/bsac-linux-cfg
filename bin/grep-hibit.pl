#!/usr/bin/env perl
# search files for non-alpha characters (unicode, accented letters, etc)

while (my $line = <>)
{
	# find first byte with high bit set
	$line =~ m{ ^ ([\x00-\x7f]*) (.*) $ }xms;

	# display filename, line and column number if there is a match
	print "$ARGV:$.:" . ($-[2]+1) . ":$line" if length($2);
}

