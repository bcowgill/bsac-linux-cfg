#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use utf8;         # so literals and identifiers can be in UTF-8
use v5.16;       # later version so we can use case folding fc() function directly
use strict;
use warnings;
use warnings  qw(FATAL utf8);   # fatalize encoding glitches
use open qw(:std :utf8);       # undeclared streams in UTF-8
use English qw(-no_match_vars);
use FindBin;

my $DEBUG = $ENV{DEBUG} || 0;
my $firstFile = 1;
my %First;
my @Keys;
my $first = 0;
my $second = 0;
my $translate = 0;
my $something = 0;
my $usage = 0;

sub usage
{
	my $cmd = $FindBin::Script;
	$usage = 1;
	print <<"USAGE";
$cmd [--help|--man|-?] language.json foreign.json

This will merge two translation JSON files together to provide a translation key.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Whenever a key from foreign.json matches a key from language.json, both values will be output next to each other with the foreign.json key coming last.  Mismatched keys will also be output.

Assumes pretty formatted json with each key/value on separate lines with simple key: string-value structure no deep values.

Also assumes there will be no double-quotes in the key/value strings and so removes them all.

See also json-plus.pl json-minus.pl json-insert.sh json-common.pl csv2json.sh json_pp json_xs jq

Example:

$cmd english.json french.json > english-french.json
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

sub debug
{
	print STDERR @ARG if $DEBUG;
}

while (my $line = <>)
{
	debug("firstFile: $firstFile first: $first second: $second translate $translate something: $something First: @{[scalar(keys(%First))]}\n");
	# kill excess spaces, commas, newlines
	chomp $line;
	$line =~ s{\A\s*}{}xms;
	$line =~ s{\s*,?\s*\z}{}xms;
	debug("line: [$line]\n");

	# skip empties
	next if ($line =~ m/\A\s*{\s*\z/xms);
	next if ($line =~ m/\A\s*\z/xms);
	debug("not empty\n");

	# change when end of json found...
	if ($line =~ m/\A\s*(\{\s*)?\}\s*\z/xms)
	{
		debug("end JSON firstFile: $firstFile second: $second\n");
		if (!$firstFile && scalar(keys %First))
		{
			my $excess = $second;
			foreach my $key (@Keys)
			{
				if ($First{$key})
				{
					print ",\n" if $excess;
					print qq{\n  "$key": $First{$key}};
					++$excess;
				}
			}
		}
		$firstFile = 0;
		next;
	}

	#print qq{LINE: $.?? $line ??\n} if $. == 3;
	# get key, value and strip quotes
	my ($key, $value) = split_colon($line);
	$key =~ s{"}{}xmsg;
	$value =~ s{"}{}xmsg;
	$value = qq{"$value"};

	if ($firstFile)
	{
		debug("store k: $key v: $value\n");
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
		# translate for second file if same key.
		if ($First{$key} && $value ne $First{$key})
		{
			debug("translate k: $key v: $value was: $First{$key}\n");
			print ",\n" if $second;
			print qq{\n  "$key": $First{$key},\n  "$key": $value};
			++$translate;
		}
		else
		{
			debug("untranslated k: $key v: $value\n");
			print ",\n" if $second;
			print qq{\n  "$key": $value};
		}
		delete $First{$key};
		++$second if $line =~ m{"\s*:\s*"};
	}
	BEGIN { print "{\n" if scalar(@ARGV) >= 2 && !grep { m{--help|--man|-\?}xms } @ARGV }
	END {
		debug("END $something");
		exit 1 if !$usage && $firstFile;
		print "\n}\n" if !$usage;
		print STDERR "first: $first\nsecond: $second\ntranslations for second: $translate\n" if $translate || $something;
	}
	sub split_colon
	{
		my ($line) = @_;
		my $key = $line;
		my $value = "";
		if ($line =~ m{:}xms)
		{
			$line =~ m{\A([^:]*?)\s*:\s*(.*)\z}xms;
			$key = $1  || "";
			$value = $2 || "";
		}
		return ($key, $value);
	}
}
