#!/usr/bin/env perl
use strict;
use warnings;
use integer;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given two integers output the minimum number of bits that need to be flipped to convert first integer into the second integer

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $p;
my $q;
my $bits;


while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;
		my $got = get_min_bits($p, $q);
		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected $expected but got $got\n};
		}
		$p = undef;
		$q = undef;
		next;
	}
	if (defined $p) {
		$q = $input + 0;
		if (!$test) {
			my $min = get_min_bits($p, $q);
			print qq{$min\n};
			exit 0;
		}
	} else {
		$p = $input + 0;
	}
}

sub get_min_bits
{
	my ($p, $q) = @ARG;
	my $min = 0;
	my $mask = 1;
	while ($p || $q) {
		my $P = $p & $mask;
		my $Q = $q & $mask;
		if ($debug) {
			printf "P=%32b ($P)\n", $p;
			printf "Q=%32b ($Q)\n", $q;
		}
		++$min if ($P != $Q);
		$p = $p & ~$mask;
		$q = $q & ~$mask;
		$mask = $mask << 1;
	}
	return $min;
}

__DATA__
7
10
#=3
1
1
#=0
-345
-360
#=6
