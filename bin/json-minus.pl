#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English qw(-no_match_vars);
use FindBin;

my $firstFile = 1;
my %First;
my $first = 0;
my $second = 0;
my $removed = 0;
my $something = 0;

sub usage
{
	my $cmd = $FindBin::Script;
	print <<"USAGE";
$cmd [--help|--man|-?] first.json second.json

This will output everything from second.json which does not have an identical key/value from first.json.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Assumes pretty formatted json with each key/value on separate lines with simple key: string-value structure no deep values.

Also assumes there will be no double-quotes in the key/value strings and so removes them all.

See also json-plus.pl json-common.pl json_pp json_xs jq

Example:

$cmd first.json second.json > deduped-second.json
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
	BEGIN { print "{\n" if scalar(@ARGV) >= 2 && !grep { m{--help|--man|-\?}xms } @ARGV }
	END {
		print "\n}\n" if $something;
		print STDERR "first: $first\nsecond: $second\nduplicates removed from second: $removed\n" if $something;
	}
}
