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
my $first = 0;
my $second = 0;
my $common = 0;
my $something = 0;
my $usage = 0;

sub usage
{
	my $cmd = $FindBin::Script;
	$usage = 1;
	print <<"USAGE";
$cmd [--help|--man|-?] first.json second.json

This will output everything from second.json which has an identical key/value as first.json.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Assumes pretty formatted json with each key/value on separate lines with simple key: string-value structure no deep values.

Also assumes there will be no double-quotes in the key/value strings and so removes them all.

See also json-plus.pl json-minus.pl json-change.sh json-insert.sh json-translate.pl json-reorder.pl csv2json.sh json_pp json_xs jq

Example:

$cmd first.json second.json > second-common.json
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
	debug("firstFile: $firstFile first: $first second: $second common: $common something: $something First: @{[scalar(keys(%First))]}\n");
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
		debug("end JSON\n");
		last unless $firstFile;
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
		warn "duplicate key with values: $key: [$value] [$First{$key}]\n" if $First{$key};
		$First{$key} = $value;
		++$first;
	}
	else
	{
		# output from second file if identical value from first file.
		++$second;
		if ($First{$key} && ($value eq $First{$key}))
		{
			debug("common k: $key v: $value\n");
			++$common;
			print ",\n" if $something;
			print qq{  "$key": $value};
			$something = 1;
		}
	}
	BEGIN { print "{\n" if scalar(@ARGV) >= 2 && !grep { m{--help|--man|-\?}xms } @ARGV }
	END {
		debug("END $something");
		exit 1 if !$usage && $firstFile;
		print "\n}\n" unless $usage;
		print STDERR "first: $first\nsecond: $second\nduplicate values: $common\n" if $common || $something;
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
