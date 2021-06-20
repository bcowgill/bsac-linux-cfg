#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English qw(-no_match_vars);
use FindBin;

my $firstFile = 1;
my %First;
my @Keys;
my $first = 0;
my $second = 0;
my $override = 0;
my $something = 0;

sub usage
{
	my $cmd = $FindBin::Script;
	print <<"USAGE";
$cmd [--help|--man|-?] first.json second.json

This will output everything from first.json and second.json where second.json overwrites identical key values from first.json.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Assumes pretty formatted json with each key/value on separate lines with simple key: string-value structure no deep values.

Also assumes there will be no double-quotes in the key/value strings and so removes them all.

See also json-minus.pl json-common.pl json_pp json_xs jq

Example:

$cmd first.json second.json > second-overrides-first.json
USAGE
	exit 0;
}

unless (scalar(@ARGV) >= 2)
{
	usage()
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
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
	BEGIN { print "{\n" if scalar(@ARGV) >= 2 && !grep { m{--help|--man|-\?}xms } @ARGV }
	END {
		print "\n}\n" if $something;
		print STDERR "first: $first\nsecond: $second\nsecond overrides first: $override\n" if $something;
	}
}
