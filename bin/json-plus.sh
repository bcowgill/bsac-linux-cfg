#!/usr/bin/env perl

use strict;
use warnings;

my $firstFile = 1;
my %First;
my @Keys;
my $first = 0;
my $second = 0;
my $override = 0;
my $something = 0;

unless (scalar(@ARGV))
{
	my $cmd = $0;
	print <<"USAGE";
$cmd first.json second.json

This will output everything from first.json and second.json where second.json overwrites identical key values from first.json.

Assumes pretty formatted json on separate lines with simple key: string-value structure.

Example:

$cmd first.json second.json > second-overrides-first.json
USAGE
	exit 0;
}

sub output
{
	$something = scalar(@Keys);
	print join(",\n",
		map { qq{  "$_": $First{$_}} } @Keys
	);
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
		output() unless $firstFile;
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
		if ($First{$key})
		{
			warn "duplicate key with values: $key: [$value] [$First{$key}]\n" 
		}
		else
		{
			push(@Keys, $key);
		}
		$First{$key} = $value;
		++$first;
	}
	else
	{
		# overwrite from second file if same key.
		++$second;
		if ($First{$key} && $value ne $First{$key})
		{
			++$override;
		}
		push(@Keys, $key) unless $First{$key};
		$First{$key} = $value;
	}
	BEGIN { print "{\n" if scalar(@ARGV) }
	END {
		print "\n}\n" if $something;
		print STDERR "first: $first\nsecond: $second\nsecond overrides first: $override\n" if $something;
	}
}
