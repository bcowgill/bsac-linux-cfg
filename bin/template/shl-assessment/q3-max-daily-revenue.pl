#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line specifying the number of days(N) and number of products(P) space separated. The next N lines will contain P space separated numbers for the sales of each product that day.
Output the highest sales value for each day as space separated numbers on a single line.


=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}

my $days;
my $products;
my @Sales = ();
my @Bestsellers = ();

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;
		die "You specified $days days of sales figures but provided @{[scalar(@Bestsellers)]}" if scalar(@Bestsellers) > $days;

		my $got = join(" ", @Bestsellers);

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$days = undef;
		$products = undef;
		@Sales = ();
		@Bestsellers = ();
		next;
	}
	my @Input = split(/\s+/, $input);
	my $count = scalar(@Input);
	if ($days && $products) {
		die "You specified $products product sales figures per day, but provided $count values: $input\n" if ($count != $products);
		die "You specified $days days of sales figures but provided @{[scalar(@Bestsellers)]}" if scalar(@Bestsellers) > $days;

		@Sales = sort { $b <=> $a } @Input;
		#if ($test) {
		#	print qq{@{[join(" ", @Sales)]}\n};
		#}
		push(@Bestsellers, $Sales[0]);
	}
	else {
		die "You need to provide a number of days and products but provided $count values: $input\n" unless scalar(@Input) == 2;
		$days = shift(@Input);
		$products = shift(@Input);
		die "You need to provide a positive number of days: $days\n" unless $days > 0;
		die "You need to provide a positive number of products: $products\n" unless $products > 0;
	}

	if (!$test) {
		my $bestsellers = join(" ", @Bestsellers);
		print qq{$bestsellers\n};
		exit 0;
	}
}

__DATA__
3 4
100 198 333 323
122 232 221 111
223 565 245 764
#=333 232 764
2 2
12 545
678 45
#=545 678
