#!/usr/bin/env perl
# track the battery charge and announce when it is draining, charging again and when it drains to 50%, 25%, 10%, 5% and about to fail...

use strict;
use warnings;

use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use FindBin;
use File::Slurp qw(:std);
use autodie qw(open);

our $VERSION = 0.1;
our $DEBUG = $ENV{DEBUG} || 0;
our $NOISY = $ENV{NOISY} || 0;

our $os_name = get_osname();
our $sound_cfg =
{
	LINUX => {
		dir => "$FindBin::Bin/sounds/BatteryWarnings/female/wav",
		ext => ".wav",
	},
	MAC => {
		dir => "$FindBin::Bin/sounds/BatteryWarnings/female/mp3",
		ext => ".mp3",
	},
};

our $save_file = "$FindBin::Bin/battery-level.txt";
our $sound_dir = $sound_cfg->{$os_name}{dir};
our $sound_ext = $sound_cfg->{$os_name}{ext};

# print "DEBUG: $ENV{OSTYPE} $os_name\n$sound_dir\n$sound_ext\n";
# print Dumper \%ENV;

sub say_if_fallen_below
{
	my ($threshold, $last, $now, $message) = @ARG;

	my $said = 0;
	if ($last > $threshold && $threshold >= $now)
	{
		say($message);
		++$said;
	}
	return $said;
}

sub say_if_draining_below
{
	my ($threshold, $last, $now, $message) = @ARG;

	my $said = 0;
	if (($last > $now) && ($now <= $threshold))
	{
		say($message);
		++$said;
	}
	return $said;
}

sub say_if_rising
{
	my ($last, $now, $message) = @ARG;

	my $said = 0;
	if ($last < $now)
	{
		say($message);
		++$said;
	}
	return $said;
}

sub say_if_falling
{
	my ($last, $now, $message) = @ARG;

	my $said = 0;
	if ($last > $now)
	{
		say($message);
		++$said;
	}
	return $said;
}

sub say
{
	my ($message) = @ARG;
	print "$message\n";
	system(qq{echo "$message" | wall});
	system(qq{mynotify.sh "$message" "WARNING"});
	play($message);
}

sub play
{
	my ($message) = @ARG;
	$message =~ s{[\% ]}{}xmsg;
	my $sound_file = "$sound_dir/$message$sound_ext";
	print "play $sound_file\n" if $DEBUG;
	system(qq{sound-play.sh "$sound_file"});
}

sub save_if_changed
{
	my ($last, $now) = @ARG;

	if (!defined $last || $last != $now)
	{
		my $was_draining = !defined $last || ($last > $now);
		save($now, 0 + $was_draining);
	}
}

sub get
{
	my ($was_draining, $last) = (1);
	my $saved;

	eval {
		$saved = read_file($save_file);
	};
	unless ($EVAL_ERROR)
	{
		$saved =~ m{ \A \s* (\d+) \s+ (\d+) }xms;
		$last = $1;
		$was_draining = $2;
	}
	print "get [$last] [$was_draining]\n" if $DEBUG;
	return ($last, $was_draining);
}

sub get_battery
{
	my $battery = `battery-value.sh`;
	$battery =~ s{\s* \z}{}xmsg;
	return $battery;
}

sub get_osname
{
	return is_mac() ? 'MAC': 'LINUX';
}

sub is_mac
{
	return !system(qq{which sw_vers > /dev/null});
}

sub save
{
	my ($now, $was_draining) = @ARG;
	my $fh;

	print "save $now $was_draining\n" if $DEBUG;
	open($fh, ">", $save_file);
	print $fh "$now $was_draining\n";
	close($fh);
}

sub main
{
	my ($last, $was_draining) = get();
	my $now = get_battery();

	#($now, $last, $was_draining) = (5,10,1);

	if (defined $now)
	{
		if (defined $last)
		{
			print "Battery: $now%\n" if $NOISY;
			if ($NOISY || $was_draining)
			{
				say_if_rising($last, $now, 'Battery Charging');
			}
			if ($NOISY || !$was_draining)
			{
				say_if_falling($last, $now, 'Battery Warning');
			}

			say_if_draining_below(4, $last + $was_draining, $now, 'Battery Critical')
				 || say_if_fallen_below(5, $last, $now, 'Battery Warning 5%')
				 || say_if_fallen_below(10, $last, $now, 'Battery Warning 10%')
				 || say_if_fallen_below(25, $last, $now, 'Battery Warning 25%')
				 || say_if_fallen_below(50, $last, $now, 'Battery Warning 50%');
		}
		else
		{
			say_if_draining_below(4, $now + 1, $now, 'Battery Critical')
		}

		save_if_changed($last, $now);
	}
	else
	{
		say("Cannot Read Battery");
	}
}

main();
