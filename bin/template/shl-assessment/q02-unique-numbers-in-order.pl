#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of items in the sequence followed by those numbers separated by spaces, output only the unique (non-repeated) numbers in the sequence in order they are received.

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

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = join(" ", @Sequence);

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$count = undef;
		@Sequence = ();
		next;
	}
	my @Input = split(/\s+/, $input);
	$count = shift(@Input);
	die "You specified a sequence of $count numbers, but provided @{[scalar(@Input)]}" if (scalar(@Input) != $count);

	@Sequence = get_unique(\@Input);

	if (!$test) {
		my $min = join(" ", @Sequence);
		print qq{$min\n};
		exit 0;
	}
}

sub get_unique {
	my ($raSequence) = @ARG;
	my %Seen = ();
	my @Unique = ();

	foreach my $number (@$raSequence) {
		push(@Unique, $number) unless $Seen{$number};
		$Seen{$number}++;
	}
	return @Unique;
}

__DATA__
8 1 1 2 3 5 4 5 6
#=1 2 3 5 4 6
12 9 4 5 2 4 5 2 1 2 33 4 1
#=9 4 5 2 1 33
