#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of lights in a string followed by another line with the binary state of each light separated by spaces.
Then the next line giving the number of days to run the lights.

Given that a light will turn off if both of its neighbour lights were ON or both OFF the previous night. Otherwise the light will remain on.
Given that the lights at the ends of the string have no neighbour but pretend they have one that is OFF.

Then output the on/off state of the lights on the final day as a string of space separated 0's and 1's.

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
my @Lights = ();
my $days = 0;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = join(' ', @Lights);

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$count = undef;
		@Lights = ();
		$days = 0;
		next;
	}
	my @Input = split(/\s+/, $input);
	my $values = scalar(@Input);

	if (!$count) {
		die "You should provide a single count value for the length of the string of lights, you provided $values: $input\n" unless $values == 1;
		$count = shift(@Input);
		die "You should provide a positive count value for the length of the string of lights, you gave: $input\n" unless $count > 0;
	} elsif (scalar(@Lights) < 1) {
		die "You should provide $count binary digits for the state of the lights in the string, you gave $values items: $input\n" unless $values == $count;
		die "You should provide a string of binary 0 or 1 digits with space separation, you provided: $input\n" unless $input =~ m{\A[01\ ]+\z}xms;
		@Lights = map {
			my $state = $ARG;
			my $length = length($state);
			die "You should provide a binary 0 or 1 digit with space separation, you provided: $state\n" unless $length == 1;
			$state
		} @Input;
	} elsif (!$days) {
		die "You should provide a single value for the number of days, you provided $values: $input\n" unless $values == 1;
		$days = shift(@Input);
		die "You should provide a positive value for the number of days, you gave: $input\n" unless $days > 0;

		foreach (1 .. $days) {
			@Lights = get_next_state(\@Lights);
		}

		if (!$test) {
			print qq{@{[join(' ', @Lights)]}\n};
			exit 0;
		}
	}
}

sub get_next_state {
	my ($raLights) = @ARG;
	my @Tomorrow = @$raLights;
	my $count = scalar(@Tomorrow);

	foreach my $idx (0 .. $count - 1) {
		my $prev = $idx ? $raLights->[$idx - 1] : 0;
		my $next = $idx + 1 >= $count  ? 0 : $raLights->[$idx + 1];
		$Tomorrow[$idx] = $prev == $next ? 0 : 1;
	}
	print qq{@{[join(' ', @$raLights)]} => @{[join(' ', @Tomorrow)]}\n} if $debug;
	return @Tomorrow;
}

__DATA__
8
1 1 1 0 1 1 1 1
2
#=0 0 0 0 0 1 1 0
