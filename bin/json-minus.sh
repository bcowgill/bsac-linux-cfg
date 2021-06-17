#!/usr/bin/env perl

use strict;
use warnings;

my $firstFile = 1;
my %First;
my $first = 0;
my $second = 0;
my $removed = 0;
my $something = 0;

unless (scalar(@ARGV))
{
	my $cmd = $0;
	print <<"USAGE";
$cmd first.json second.json

This will output everything from second.json which does not have an identical key/value from first.json.

Assumes pretty formatted json on separate lines with simple key: string-value structure.

Example:

$cmd first.json second.json > deduped-second.json
USAGE
	exit 0;
}

while (my $line = <>)
{
	# kill excess spaces, commas, newlines
	chomp $line;
	$line =~ s{\A\s*}{}xms;
	$line =~ s{\s*,?\s*\z}{}xms;

	# skip empties
	next if ($line =~ m/\A\s*{\s*/xms);

	# change when end of json found...
	if ($line =~ m/\A\s*}\s*\z/xms)
	{
		last unless $firstFile;
		$firstFile = 0;
		next;
	}

	#print qq{$.?? $line ??\n} if $. == 170;
	# get key, value and strip quotes
	my ($key, $value) = split(/\s*:\s*/, $line);
	$key =~ s{"}{}xmsg;
	$value =~ s{"}{}xmsg;
	$value = qq{"$value"};

	if ($firstFile)
	{
		# store values from first file
		warn "duplicate key with values: $key: [$value] [$First{$key}]\n" if $First{$key};
		$First{$key} = $value;
		++$first;
	}
	else
	{
		# output from second file if not identical value from first file.
		++$second;
		if ($First{$key} && $value eq $First{$key})
		{
			++$removed;
		}
		else
		{
			print ",\n" if $something;
			print qq{  "$key": $value};
			$something = 1;
		}
	}
	BEGIN { print "{\n" if scalar(@ARGV) }
	END {
		print "\n}\n" if $something;
		print STDERR "first: $first\nsecond: $second\nduplicates removed from second: $removed\n" if $something;
	}
}
