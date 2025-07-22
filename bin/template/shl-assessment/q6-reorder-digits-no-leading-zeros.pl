#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a single positive integer as input.
Then output the lowest value integer obtained by reordering the digits in the number such that there are no leading zeros.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $id;
my $task;


while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $task;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected $expected but got $got\n};
		}
		$id = undef;
		$task = undef;
		next;
	}
	$id = $input;
	die "You should provide a positive integer, you gave: $id\n" if $id < 1;
	$task = get_task($id);
}

sub get_task
{
	my ($id) = @ARG;
	my @Sorted = sort { $a cmp $b } split(//, $id);
	my $task = join('', @Sorted);
	$task =~ s{\A(0*)(\d)(\d*)\z}{$2$1$3}xms;

	return $task;
}

__DATA__
934
#=349
105430
#=100345
