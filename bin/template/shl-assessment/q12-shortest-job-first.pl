#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);
use Data::Dumper;

=pod

PROBLEM STATEMENT:

Given a line of text containing the number of tasks that need to run(N).
The next line contains the request time (an integer) for each of the N tasks.
The next line contains the number N again.
The last line contains the duration of each of the N tasks each one a positive integer.

Given that the computer system selects the shortest job to run first and if there are more than one, then the one that was requested earlier.
When the task is finished it again selects the shortest job to run next as above.
Given the waiting time is the difference between the time is starts running and the time it was requested.

Then output the average waiting time for the given list of tasks.

=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my %StateValue = (
	waiting => 0,
	running => 1,
	done => 2,
);

my $count;
my $count2;
my $requests;
my $durations;
my @Tasks = ();
my $average_wait;
my @RunOrder = ();

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		my $got = $average_wait;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$count = undef;
		$count2 = undef;
		$requests = undef;
		$durations = undef;
		$average_wait = undef;
		@Tasks = ();
		@RunOrder = ();
		next;
	}

	my @Input = split(/\s+/, $input);
	my $values = scalar(@Input);

	if (!$count) {
		die "You should provide a single count value for the number of tasks to run, you provided $values: $input\n" unless $values == 1;
		$count = shift(@Input);
		die "You should provide a positive count value for the number of tasks to run, you gave: $input\n" unless $count > 0;
	} elsif (!$requests) {
		die "You should provide $count numbers for the request time of each task, you gave $values items: $input\n" unless $values == $count;
		$requests++;

		@Tasks = map {
			my $time = $ARG;
			my $rhTask = {
				state => 'waiting',
				requested => $time,
			};
			die "You should provide a non-negative value for the task request time, you gave $time\n" if $time < 0;
			$rhTask;
		} @Input;

	} elsif (!$count2) {
		die "You should provide a single count value for the number of task durations, you provided $values: $input\n" unless $values == 1;
		$count2 = shift(@Input);
		die "You should give the same value for the number of tasks($count) and number of task durations, you gave: $input\n" unless $count2 == $count;
	} elsif (!$durations) {
		$durations++;
		die "You should provide $count numbers for the duration of each task, you gave $values items: $input\n" unless $values == $count;
		my $idx = 0;
		foreach my $rhTask (@Tasks) {
			my $duration = shift(@Input);
			die "You should provide a positive value for each task duration, you gave $duration\n" if $duration < 1;
			$rhTask->{duration} = $duration;
		}

		print Dumper(\@Tasks) if $debug;

		$average_wait = get_average_wait(\@Tasks);

		if (!$test) {
			print qq{$average_wait\n};
			exit 0;
		}
	}
}

sub get_average_wait {
	my ($raTasks) = @ARG;
	my $count = scalar(@Tasks);
	my $time = 0;
	my $total_wait = 0;

	my $rhFirstTask = pick_earliest_request($raTasks);
	die "There were no tasks waiting to run." unless $rhFirstTask;
	$time = $rhFirstTask->{requested}; # clock starts with earliest request
	start_task($time, $rhFirstTask);
	print qq{Started: @{[Dumper($rhFirstTask)]}\n} if $debug;

	run_tasks($rhFirstTask, $raTasks);

	foreach my $rhTask (@$raTasks) {
		$total_wait += $rhTask->{waited};
	}

	if ($debug) {
		print qq{RunOrder: };
		foreach my $rhTask (@RunOrder) {
			print qq{R\@$rhTask->{requested}($rhTask->{duration})[W:$rhTask->{waited}]S\@$rhTask->{started}-E\@$rhTask->{ended} }
		}
		print qq{\n};
	}

	return $total_wait / $count;
}

sub run_tasks {
	my ($rhTask, $raTasks) = @ARG;

	die "Fatal, the task requested at $rhTask->{requested} is not currently running!" unless $rhTask->{state} eq 'running';
	while ($rhTask) {
		my $time = wait_for_task($rhTask);
		print qq{End: \@$time @{[Dumper($rhTask)]}\n} if $debug;

		my $rhNextTask = pick_shortest($raTasks);
		if ($rhNextTask) {
			print qq{Next??: \@$time @{[Dumper($rhNextTask)]}\n} if $debug;
			if ($rhNextTask->{requested} <= $time) {
				$rhTask = $rhNextTask;
			} else {
				$rhTask = pick_earliest_request($raTasks);
				print qq{Next: \@$time @{[Dumper($rhTask)]}\n} if $debug;
			}
		} else {
			print qq{Done: \@$time\n} if $debug;
			$rhTask = undef;
		}
		if ($rhTask) {
			$time = $time < $rhTask->{requested} ? $rhTask->{requested} : $time;
			print qq{Start: \@$time @{[Dumper($rhTask)]}\n} if $debug;
			start_task($time, $rhTask);
		}
	}
}

sub start_task {
	my ($time, $rhTask) = @ARG;

	$rhTask->{state} = 'running';
	$rhTask->{started} = $time;
	$rhTask->{waited} = $rhTask->{started} - $rhTask->{requested};
	push(@RunOrder, $rhTask);
}

sub wait_for_task {
	my ($rhTask) = @ARG;
	
	$rhTask->{state} = 'done';
	$rhTask->{ended} = $rhTask->{started} + $rhTask->{duration};
	return $rhTask->{ended};
}

sub pick_earliest_request {
	my ($raTasks) = @ARG;

	my @Ordered = sort by_earliest_request @$raTasks;
	print qq{Earliest: @{[Dumper(\@Ordered)]}\n} if $debug;
	return ($Ordered[0]{state} eq 'waiting') ? $Ordered[0] : undef;
}

sub pick_shortest {
	my ($raTasks) = @ARG;

	my @Ordered = sort by_shortest_job @$raTasks;
	print qq{Shortest: @{[Dumper(\@Ordered)]}\n} if $debug;
	return ($Ordered[0]{state} eq 'waiting') ? $Ordered[0] : undef;
}

sub by_earliest_request {
	# print qq{A @{[Dumper($a)]}\n} if $debug;
	# print qq{B @{[Dumper($b)]}\n} if $debug;
	# print qq{A<=>B @{[$a->{requested} <=> $b->{requested}]}\n} if $debug;
	
	return $StateValue{$a->{state}} <=> $StateValue{$b->{state}}
		|| $a->{requested} <=> $b->{requested}
		|| $a->{duration} <=> $b->{duration}
}

sub by_shortest_job {
	# print qq{A @{[Dumper($a)]}\n} if $debug;
	# print qq{B @{[Dumper($b)]}\n} if $debug;
	# print qq{A<=>B @{[$a->{duration} <=> $b->{duration}]}\n} if $debug;
	
	return $StateValue{$a->{state}} <=> $StateValue{$b->{state}}
		|| $a->{duration} <=> $b->{duration}
		|| $a->{requested} <=> $b->{requested}
}

__DATA__
4
5 7 10 12
4
2 3 5 2
#=0.75
6
5 7 10 12 7 6
6
8 13 2 2 9 9
#=10.6666666666667
