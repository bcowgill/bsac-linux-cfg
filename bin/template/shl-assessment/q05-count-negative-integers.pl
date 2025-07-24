#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of items in the sequence followed by another line with those numbers separated by spaces.

Then output only the count of negative numbers in the list.

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
my @Sequence = ();
my $negative = 0;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $negative;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$count = undef;
		@Sequence = ();
		$negative = 0;
		next;
	}
	my @Input = split(/\s+/, $input);
	my $values = scalar(@Input);

	if (!$count) {
		die "You should provide a single count value for the list length, you provided $values: $input\n" unless $values == 1;
		$count = shift(@Input);
		die "You should provide a positive count value for the list length, you gave: $input\n" unless $count > 0;
	} elsif (scalar(@Sequence) < 1) {
		die "You should provide $count numbers for the list, you gave $values items: $input\n" unless $values == $count;
		@Sequence = @Input;

		$negative = count_negatives(\@Sequence);

		if (!$test) {
			print qq{$negative\n};
			exit 0;
		}
	}
}

sub count_negatives {
	my ($raSequence) = @ARG;
	my $negative = 0;

	foreach my $number (@$raSequence) {
		$negative++ if $number < 0;
	}
	return $negative;
}

__DATA__
7
9 -3 8 -6 -7 8 10
#=3
5
2 1 0 3 -4
#=1
