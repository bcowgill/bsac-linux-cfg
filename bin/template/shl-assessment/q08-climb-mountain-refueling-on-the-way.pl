#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of refreshment stations followed by another line with numbers separated by spaces defining the distance of each station from the starting point.
The next line contains the same number as the first line followed by another line with numbers separated by spaces defining the litres of water at each station.
The next line gives the total distance to the mountain summit.
The next line gives the initial energy level of the hiker.

Given that the hiker loses one energy unit for every unit of distance travelled.
Given that the hiker gains one energy unit for every liter of water drunk.

Then output -1 if the hiker cannot reach the summit at all or the minimum number of refreshment stations the hiker needs to stop at to reach the summit.

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
my $stops;
my @Stops = ();
my @Water = ();
my $total_water;
my $total_distance;
my $energy;
my $min_stops = 0;

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $min_stops;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$count = undef;
		$stops = undef;
		@Stops = ();
		@Water = ();
		$total_water = undef;
		$total_distance = undef;
		$energy = undef;
		$min_stops = undef;
		next;
	}

	my @Input = split(/\s+/, $input);
	my $values = scalar(@Input);

	if (!$count) {
		die "You should provide a single count value for the number of stops, you provided $values: $input\n" unless $values == 1;
		$count = shift(@Input);
		die "You should provide a positive count value for the number of stops, you gave: $input\n" unless $count > 0;
	} elsif (scalar(@Stops) < 1) {
		die "You should provide $count numbers for the distance to each stop, you gave $values items: $input\n" unless $values == $count;
		my $last_stop = 0;
		@Stops = map {
			my $position = $ARG;
			die "You should provide a positive value for position of stop, you gave $position\n" if $position < 1;
			die "You should provide a greater value for each stop position, you gave $position <= $last_stop\n" if $position <= $last_stop;
			$last_stop = $position;
			$position;
		} @Input;

	} elsif (!$stops) {
		die "You should provide a single count value for the number of water amounts, you provided $values: $input\n" unless $values == 1;
		$stops = shift(@Input);
		die "You should provide a positive count value for the number of water amounts, you gave: $input\n" unless $stops > 0;
		die "You should give the same value for the number of stops($count) and number of water amounts, you gave: $input\n" unless $stops == $count;
	} elsif (scalar(@Water) < 1) {
		die "You should provide $count numbers for the amount of water at each stop, you gave $values items: $input\n" unless $values == $count;
		@Water = map {
			my $litres = $ARG;
			$total_water += $litres;
			die "You should provide a positive value for amount of water at each stop, you gave $litres\n" if $litres < 1;
			$litres
		} @Input;
	} elsif (!$total_distance) {
		die "You should provide a single value for the total distance to the summit, you provided $values: $input\n" unless $values == 1;
		$total_distance = shift(@Input);
		die "You should provide a positive value for the total distance to the summit, you gave: $input\n" unless $total_distance > 0;
		my $last_stop = $Stops[-1];
		die "You should provide a total distance to the summit greater than the final stop position($last_stop), you gave: $input\n" unless $total_distance > $last_stop;
	} elsif (!$energy) {
		die "You should provide a single value for the initial energy, you provided $values: $input\n" unless $values == 1;
		$energy = shift(@Input);
		die "You should provide a positive value for the initial energy, you gave: $input\n" unless $energy > 0;

		$min_stops = get_min_stops(\@Stops, \@Water, $total_distance, $energy, $total_water);

		if (!$test) {
			print qq{$min_stops\n};
			exit 0;
		}
	}
}

sub get_min_stops {
	my ($raStops, $raWater, $total_distance, $energy, $total_water) = @ARG;
	my $min_stops = 0;
	my $stops = scalar(@$raStops);

	if ($energy + $total_water < $total_distance) {
		print qq{not enough energy\n} if $debug;
		return -1;
	}

	my $last_position = 0;
	foreach my $idx (0 .. $stops - 1) {
		$energy -= $raStops->[$idx] - $last_position;
		$last_position = $raStops->[$idx];
		my $remaining = $total_distance - $last_position;
		print qq{stop#$idx \@$last_position E:$energy R:$remaining W:$raWater->[$idx]\n} if $debug;
		if ($energy < 0) {
			print qq{dead at stop#$idx\n} if $debug;
			return -1;
		}
		if ($energy < $remaining) {
			$min_stops++;
			$energy += $raWater->[$idx];
		}
	}

	return $min_stops;
}

__DATA__
3
5 7 10
3
2 3 5
15
5
#=3
3
50 70 100
3
2 3 5
150
5
#=-1
3
1 2 3
3
23 50 34
23
109
#=0
1
50
1
230
100
49
#=-1
