#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of a specific group from 0 to 9
Second line is a single sequence of digits from 0 to 9 representing the group each person belongs to.

Then output only the total count the specific group number in the string of digits.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $group;
my $stream;
my $members = 0;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $members;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$group = undef;
		$stream = undef;
		$members = 0;
		next;
	}
	if (!$group) {
		$group = $input;
		die "You should provide a single hobby group value from 0 to 9, you provided $input\n" unless $group >= 0 && $group <= 9;
		$group++; # record group as 1 .. 10
	} else {
		my $saved = $input;
		$input =~ s{\s+}{}xmsg;
		die "You should provide a string of digits, you provided $saved" unless $input =~ m{\A\d+\z}xms;
		$members = get_members($group - 1, $input);
	}

	if (!$test) {
		print qq{$members\n};
		exit 0;
	}
}

sub get_members {
	my ($group, $stream) = @ARG;
    my $members = 0;
	my $pl = qq{\$members = \$stream =~ tr[$group][X];};
	print qq{eval: $pl\n} if $debug;
	eval $pl; die $EVAL_ERROR if $EVAL_ERROR;
	print qq{str: $stream mem: $members\n} if $debug;

	return $members;
}

__DATA__
2
1232238
#=3
3
12 3 2 2 38
#=2
0
9823465298347252984735
#=0