#!/usr/bin/env perl
use strict;
use warnings;
use English qw(-no-match-vars);
use Data::Dumper;

=pod

./q10-resource-allocation.pl < q10.dat

PROBLEM STATEMENT:

Given input lines all contain space separate numbers.
line 1: the number of different resource types (M)
line 2: M numbers specifying the amount of available resources of each type not yet assigned to any user.
line 3: two numbers: the number of employees (N) and the number of required resources -- always M..
next N lines: M numbers specifying the amount of each resource type needed by nth employee
next line: two numbers: the number of employees with resources and the number of issued resources. Always will be N M
next N lines: M numbers specifying the amount of each resource type already issued to nth employee

Given that the task manager proceeds from the employee with the lowest id to the highest looking to assign resources. Then returns to the lowest id who still needs resources.
Given an employee can borrow additional resources to complete their task and when complete they give all the resources back.
Another employee can only borrow a resource once it has been returned.
The task manager tries to assign resources optimally so all employees can complete their tasks.

Output N numbers on a single line showing the optimal order of employee id's to complete their assignments. Or if the assignments cannot be completed output -1 alone on the line.


=cut

my $in = *STDIN;
my $test;
my $arg = $ARGV[0] || '';
if ($arg eq '--test') {
	$test = 1;
	$in = *DATA;
}
my $debug = 0;#$test;

my $resourceTypes;
my @FreeResources = ();
my $numEmployees;
my $empId = 0;
my $empId2 = 0;
my %NeededResources = ();
my $using;
my %UsingResources = ();

my @AssignOrder = ();

while (my $input = <$in>) {
	chomp($input);
	if ($input =~ m{\A#=(.+)\z})
	{
		next if !$test;
		my $expected = $1;

		die "You haven't specified the number of resource types." unless $resourceTypes;
		die "You haven't specified the available unassigned resources of each type." unless scalar(@FreeResources);
		die "You haven't specified the number of employees." unless $numEmployees;
		die "You haven't specified the resources needed for every employee." if scalar(keys(%NeededResources) < $numEmployees);
		die "You haven't specified the resources currently used by every employee." if scalar(keys(%UsingResources) < $numEmployees);

		my $got = scalar(@AssignOrder) ? join(" ", @AssignOrder) : -1;

		if ($got eq $expected) {
			print qq{$got\n};
		} else {
			print qq{NOT OK expected: ($expected) but got ($got)\n};
		}
		$resourceTypes = undef;
		$numEmployees = undef;
		$empId = 0;
		$empId2 = 0;
		@FreeResources = ();
		%NeededResources = ();
		%UsingResources = ();
		$using = undef;
		next;
	}
	my @Input = split(/\s+/, $input);
	my $count = scalar(@Input);
	if (!$resourceTypes) {
		die "You need to provide a single number of resource types but provided $count values: $input\n" unless $count == 1;
		$resourceTypes = shift(@Input);
		die "You need to provide a positive number of resource types: $resourceTypes\n" unless $resourceTypes > 0;
	} elsif (!scalar(@FreeResources)) {
		die "You need to provide $resourceTypes values for each resource type but provided $count values: $input\n" unless $count == $resourceTypes;
		@FreeResources = map {
			my $value = $ARG;
			die "You need to provide a non-negative number for resource type value($value): $input\n" if $value < 0;
			$value
		} @Input;
	} elsif (!$numEmployees) {
		die "You need to provide the number of employees and number of resources($resourceTypes), but provided $count values: $input\n" unless $count == 2;
		$numEmployees = shift(@Input);
		die "You need to provide a positive number of employees($numEmployees): $input\n" unless $numEmployees > 0;
		my $value = $Input[0];
		die "You need to provide the same number of resources($resourceTypes), but provided $value : $input\n" unless $value == $resourceTypes;
	} elsif ($empId < $numEmployees) {
		die "You need to provide $resourceTypes values for each employee's needed resource type but provided $count values: $input\n" unless $count == $resourceTypes;
		my $total = 0;
		my @Resources = map {
			my $value = $ARG;
			$total += $value;
			die "You need to provide a non-negative number for employee's needed resource type value($value): $input\n" if $value < 0;
			$value
		} @Input;
		$NeededResources{$empId} = \@Resources;
		$NeededResources{"total$empId"} = $total;
		$empId++;
	} elsif (!$using) {
		die "You need to provide the number of employees($numEmployees) and number of resources($resourceTypes) again, but provided $count values: $input\n" unless $count == 2;
		die "You need to provide the same number of employees($numEmployees), but provided $Input[0] : $input\n" unless $Input[0] == $numEmployees;
		die "You need to provide the same number of resources($resourceTypes), but provided $Input[1] : $input\n" unless $Input[1] == $resourceTypes;
		$using = 1;
	} elsif ($empId2 < $numEmployees) {
		die "You need to provide $resourceTypes values for each employee's resource type in use but provided $count values: $input\n" unless $count == $resourceTypes;
		my @Resources = map {
			my $value = $ARG;
			die "You need to provide a non-negative number for employee's resource type in use value($value): $input\n" if $value < 0;
			$value
		} @Input;
		$UsingResources{$empId2} = \@Resources;
		$empId2++;
	}
	if ($empId2 && $empId2 == $numEmployees) {
		if ($debug) {
			print qq{E: $numEmployees R: $resourceTypes\n};
			print qq{FreeRes: @{[Dumper(\@FreeResources)]}\n};
			print qq{UsingRes: @{[Dumper(\%UsingResources)]}\n};
			print qq{NeedRes: @{[Dumper(\%NeededResources)]}\n};
		}

		@AssignOrder = get_schedule();

		if (!$test) {
			my $order = scalar(@AssignOrder) ? join(" ", @AssignOrder) : -1;
			print qq{$order\n};
			exit 0;
		}
	}

}

sub get_schedule {
	my $tries = $numEmployees * $resourceTypes;
	my @Order = ();

	while (scalar(@Order) < $numEmployees && $tries) {
		my @Assigned = try_to_assign();
		if (scalar(@Assigned)) {
			push(@Order, @Assigned);
		} else {
			--$tries;
		}
	}
	if ($tries < 1) {
		@Order = ();
	}
	return @Order;
}

sub try_to_assign {
	my @Assigned = ();
	foreach my $empId (0 .. ($numEmployees - 1)) {
		print qq{Try emp# $empId\n} if $debug;
		if ($NeededResources{"total$empId"} eq "wip") {
			# finished, give UsingResources resources back
			give($UsingResources{$empId}, \@FreeResources);
			$NeededResources{"total$empId"} = 0;
		} elsif ($NeededResources{"total$empId"} == 0) {
			next;
		} elsif (enough_free($NeededResources{$empId})) {
			# deduct Needed from Free and add to Using and begin task...
			take($NeededResources{$empId}, \@FreeResources, $UsingResources{$empId});
			$NeededResources{"total$empId"} = "wip";
			push(@Assigned, $empId)
		}
	}
	return @Assigned;
}


sub enough_free {
	my ($raNeeded) = @ARG;
	my $banner = '=' x 40;

	if ($debug) {
		print qq{$banner\nEnough? @{[Dumper(\@FreeResources)]} Need: @{[Dumper($raNeeded)]}\n};
	}
	foreach my $resId (0 .. ($resourceTypes - 1)) {
		if ($FreeResources[$resId] < $raNeeded->[$resId]) {
			print qq{Not Enough Free!\n} if $debug;
			return 0;
		}
	}
	print qq{Yes, Enough Free!\n} if $debug;
	return 1;
}

sub give {
	my ($raFrom, $raTo) = @ARG;
	foreach my $resId (0 .. ($resourceTypes - 1)) {
		$raTo->[$resId] += $raFrom->[$resId];
		$raFrom->[$resId] = 0;
	}
}

sub take {
	my ($raNeed, $raFree, $raTo) = @ARG;
	foreach my $resId (0 .. ($resourceTypes - 1)) {
		$raFree->[$resId] -= $raNeed->[$resId];
		$raTo->[$resId] += $raNeed->[$resId];
		$raNeed->[$resId] = 0;
	}
}
__DATA__
3
2 2 3
3 3
2 4 0
0 0 1
0 1 3
3 3
3 5 4
1 3 4
2 3 5
#=1 2 0
3
1 2 3
3 3
2 4 0
0 0 10
0 1 3
3 3
3 5 4
1 3 4
2 3 5
#=2 0 1
3
1 2 3
3 3
2 4 0
0 0 100
0 1 3
3 3
3 5 4
1 3 4
2 3 5
#=-1
