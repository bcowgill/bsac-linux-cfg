#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of items in the sequence followed by another line with those numbers separated by spaces defining the first list.
Then given the next line of text containing the number of items in the second sequence followed by another line with thise numbers forming the second list.

Then output only the count of numbers which are unique to each list. That is those numbers which are not in both lists.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $count1;
my $count2;
my @Sequence1 = ();
my @Sequence2 = ();
my $unique = 0;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $unique;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$count1 = undef;
		$count2 = undef;
		@Sequence1 = ();
		@Sequence2 = ();
		$unique = 0;
		next;
	}
	my @Input = split(/\s+/, $input);
	my $values = scalar(@Input);

	if (!$count1) {
		die "You should provide a single count value for list 1 length, you provided $values: $input\n" unless $values == 1;
		$count1 = shift(@Input);
		die "You should provide a positive count value for list 1 length, you gave: $input\n" unless $count1 > 0;
	} elsif (scalar(@Sequence1) < 1) {
		die "You should provide $count1 numbers for list 1, you gave $values items: $input\n" unless $values == $count1;
		@Sequence1 = @Input;
	} elsif (!$count2) {
		die "You should provide a single count value for list 2 length, you provided $values: $input\n" unless $values == 1;
		$count2 = shift(@Input);
		die "You should provide a positive count value for list 2 length, you gave: $input\n" unless $count2 > 0;
	} elsif (scalar(@Sequence2) < 1) {
		die "You should provide $count2 numbers for list 2, you gave $values items: $input\n" unless $values == $count2;
		@Sequence2 = @Input;

		$unique = get_unique_count(\@Sequence1, \@Sequence2);

		if (!$test) {
			print qq{$unique\n};
			exit 0;
		}
	}
}

sub get_unique_count {
	my ($raSeq1, $raSeq2) = @ARG;
	my $unique = 0;
	my %Seen = ();

	foreach my $number (@$raSeq1) {
		$Seen{$number} = "1";
	}
	foreach my $number (@$raSeq2) {
		if ($Seen{$number}) {
			$Seen{$number} .= "2";
		} else {
			$Seen{$number} = "2";
		}
	}

	print qq{\n>>} if $debug;
	foreach my $number (keys(%Seen)) {
		print qq{$number($Seen{$number}) } if $debug;
		$unique++ if $Seen{$number} ne '12';
	}
	print qq{\n} if $debug;

	return $unique;
}

__DATA__
11
1 1 2 3 4 5 6 7 8 9 10
10
11 12 13 14 15 16 17 18 19 20
#=20
5
2 1 6 3 4
5
4 6 1 5 9
#=4
