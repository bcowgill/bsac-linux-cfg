#!/usr/bin/env perl
# put a newline break between different files in a grep listing
my $last = ':';
while (my $line = <>)
{
	$line =~ m{\A ([^:]+ :)}xms;
	$filename = $1;
	if ($last ne $filename)
	{
		print ":\n";
		$last = $filename;
	}
	print $line;
}