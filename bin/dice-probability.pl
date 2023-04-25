#!/usr/bin/env perl
# Work out dice roll probabilities.
# dice-probability.pl 216000 2>> dice-state.txt | tee dice-rolls.txt
#
use strict;
use warnings;
use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use DiceState;

# https://www.perl.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl/
use sigtrap qw(handler user_signal2_handler normal-signals);
use sigtrap qw(handler user_signal_handler USR1);
use sigtrap qw(handler user_signal2_handler USR2);

my $stop = 0;
my $REPORT = 10000000;
my $RANGE = 5;

my $DICE = shift || 3;#216000;
my $SIDES = 6;

my $resumed = 0;
my $roll_number = 0;
my $min;
my $max;
my %Probability = ();
my $result = '1' x $DICE;

if ($DICE == $DiceState::STATE->{DICE} && $SIDES == $DiceState::STATE->{SIDES})
{
	$resumed = 1;
	$roll_number = $DiceState::STATE->{roll_number};
	$min = $DiceState::STATE->{min};
	$max = $DiceState::STATE->{max};
	$result = $DiceState::STATE->{result};
	%Probability = %{$DiceState::STATE->{Probability}};
}

sub sum
{
	my ($rolls) = @ARG;
	my $sum = 0;
	for (my $idx = 0; $idx < $DICE; ++$idx)
	{
		$sum += substr($rolls, $idx, 1);
	}
	return $sum;
}

sub next_result
{
	my ($rolls) = @ARG;
	my $sides = $SIDES - 1;
	if ($rolls !~ m{[1-$sides]}xms)
	{
		exit 0;
	}
	my $new_rolls = "";
	for (my $idx = 0; $idx < $DICE; ++$idx)
	{
		my $roll = 1 + substr($rolls, $idx, 1);
		if ($roll <= $SIDES)
		{
			$new_rolls .= $roll;
			$new_rolls .= substr($rolls, $idx + 1, $DICE - $idx - 1);
			last;
		} else
		{
			$new_rolls .= "1";
		}
	}
	return $new_rolls;
}

sub byvalue
{
	return $a <=> $b;
}

if ($DICE > 9)
{
print <<"INFO";
This will take a while...
You can kill -s SIGUSR1 PID to see a quick summary on STDERR of what dice roll is currently being calculated.
You can kill -s SIGUSR2 PID or ^C to terminate the program and display resumable state on STDERR. (store the output in DiceState.pm to resume the calculation later)
INFO
}

if ($resumed)
{
	print STDERR "# Resuming ${DICE}d$SIDES dice rolls from saved DiceState:\n";
	print_status();
}

sub min
{
	my ($one, $two) = @ARG;
	return $one ? ($two < $one ? $two : $one) : $two;
}

sub max
{
	my ($one, $two) = @ARG;
	return $one ? ($two > $one ? $two : $one) : $two;
}

while (1)
{
	++$roll_number;
	my $sum = sum($result);
	$Probability{$sum}++;
	$min = min($min, $sum);
	$max = max($max, $sum);
	$result = next_result($result);
	if ($stop)
	{
		print_state();
		last;
	}
	if ($roll_number % $REPORT == 0)
	{
		print STDERR "\@$roll_number ";
	}
}

sub print_status
{
	my %Histogram = ();
	my $total = 0;
	for (my $idx = 0; $idx < $DICE; ++$idx)
	{
		my $roll = substr($result, $idx, 1);
		$total += $roll;
		$Histogram{$roll}++;
	}
	my $histogram = join(" ", map { "$Histogram{$ARG}\@$ARG" } sort byvalue (keys(%Histogram)));
	print STDERR "# roll $roll_number: $histogram = $total [$min to $max]\n";
}

sub print_state
{
	my %State = (
		DICE => $DICE,
		SIDES => $SIDES,
		roll_number => $roll_number,
		min => $min,
		max => $max,
		result => $result,
		Probability => \%Probability,
	);
	print STDERR Dumper(\%State);
}

sub user_signal_handler
{
	print_status();
} # user_signal_handler()

sub user_signal2_handler
{
	$stop = 1;
} # user_signal2_handler()

sub print_table
{
	my ($stop) = @ARG;
	my @Bins = sort byvalue (keys(%Probability));
	my $bins = scalar(@Bins);
	my $bottom = $min + $RANGE - 1;
	my $middle = ($max + $min) / 2.0;
	my $lower = $middle - ($RANGE / 2);
	my $upper = $middle + ($RANGE / 2);
	my $top = $max - $RANGE + 1;
	my $status = "";
	if ($stop)
	{
		print "Results incomplete, stopped by user signal, SIGUSR2 or interrupt.\n";
		$status = "(incomplete) "
	}
	print "Rolling ${DICE}d$SIDES gives $status$bins possibile values:\n";
	print "Mean: $middle\n";
	#print "Ranges: $min .. $bottom / $lower .. $upper / $top .. $max\n";
	my ($lower_dot, $upper_dot) = (0, 0);
	foreach my $roll (@Bins)
	{
		if ($roll > $bottom && $roll < $lower)
		{
			print "...\n" unless $lower_dot;
			$lower_dot = 1;
			next;
		}
		if ($roll > $upper && $roll < $top)
		{
			print "...\n" unless $upper_dot;
			$upper_dot = 1;
			next;
		}
		print "Chance of rolling a $roll: $Probability{$roll}/$roll_number\n";
	}
}

END
{
	print STDERR "\n";
	print_table($stop);
}
