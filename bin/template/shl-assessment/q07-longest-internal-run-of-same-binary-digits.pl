#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of binary digits in the sequence followed by another line with those binary digits without spaces.

Then output only the longest count of identical binary digits which do not appear at the start or end of the sequence.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $count;
my $stream;
my $longest = 0;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $longest;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$count = undef;
		$stream = undef;
		$longest = 0;
		next;
	}
	if (!$count) {
		$count = $input;
		die "You should provide a positive count value for the binary stream length, you provided $input\n" unless $count > 0;
	} else {
		die "You should provide a string of $count binary digits, you provided @{[length($input)]}" unless length($input) == $count;
		die "You should provide a string of binary 0 or 1 digits with no space separation, you provided: $input\n" unless $input =~ m{\A[01]+\z}xms;
		$longest = get_longest($input);
	}

	if (!$test) {
		print qq{$longest\n};
		exit 0;
	}
}

sub get_longest {
	my ($stream) = @ARG;
	my $longest = 0;

	print qq{>>$stream\n} if $debug;
	$stream =~ s{\A(0+|1+)}{}xms;
	print qq{strip1: $stream\n} if $debug;
	$stream =~ s{(0+|1+)\z}{}xms;
	print qq{strip2: $stream\n} if $debug;
	$stream =~ s{(0+|1+)}{
		my $length = length($1);
		print qq{run $1: $length | $longest\n} if $debug;

		$longest = $length if $length > $longest;
		'';
	}xmsge;
	print qq{rest: $stream\n} if $debug;
	return $longest;
}

__DATA__
6
101000
#=1
9
101111110
#=6
6
000000
#=0
6
111111
#=0
