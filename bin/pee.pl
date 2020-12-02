#!/usr/bin/env perl
# strip ANSI control characters from output for a log file...
# and show start and end time as well as elapsed.

use strict;
use warnings;
use English qw(-no_match_vars);
use Fatal qw(open);
use POSIX;

# Get column wrap width from environment or use default
# COLUMNS env var is an alternative
my $WRAP = $ENV{WRAP} || 60;

my $mode = '>';
if (scalar(@ARGV) && $ARGV[0] eq '--append')
{
	$mode = '>>';
	shift;
}
my $file = shift;

my $esc = qq{\x1b};
my $fh;
open($fh, $mode, $file);

# Turn off bufferring so you can tail the output
my $h = select(STDOUT);
$| = 1;
select($h);
$h = select($fh);
$| = 1;
select($h);

sub echo
{
	my ($message, $log) = @ARG;
	$log = $log || $message;
	print qq{$message};
	print $fh qq{$log};
}

sub wrap
{
	my ($line) = @ARG;
	chomp($line);
	my @lines = ();
	while (length($line) > $WRAP)
	{
		my $part = substr($line, 0, $WRAP);
		$line = substr($line, $WRAP);
		if ($line =~ s{\A\s}{}xms)
		{
			push(@lines, $part);
		}
		else
		{
			$line =~ s{\A(\S+)(\s|\z)}{}xms;
			push(@lines, $part . $1);
		}
	}
	push(@lines, $line) if length($line);
	return join("\n", @lines) . "\n";
}

sub plural
{
	my ($number, $string) = @ARG;
	return '' if $number == 0;
	return qq{$number $string} if $number == 1;
	return qq{$number ${string}s};
}

sub duration
{
	my ($elapsed) = @ARG;
	if ($elapsed > 120)
	{
		my $seconds = $elapsed % 60;
		$elapsed = floor($elapsed / 60);
		$elapsed = join(' ', (
			plural($elapsed, 'minute'),
			plural($seconds, 'second')
		));
	}
	else
	{
		$elapsed = plural($elapsed, 'second');
	}
}

my $start = time();
my $now = `date`;
echo(qq{$now\n\n});

while (my $line = <STDIN>)
{
	my $clean = $line;
	# http://ascii-table.com/ansi-escape-sequences.php
	$clean =~ s{$esc\[[0-9;]+m}{}xmsg;
	echo($line, wrap($clean));
}

my $finish = `date`;
my $done = time();
my $seconds = $done - $start;
my $elapsed = $seconds;
my $HOUR = 60 * 60;

if ($elapsed > $HOUR)
{
	my $hours = floor($elapsed / $HOUR);
	$seconds = ($elapsed - $HOUR * $hours) % $HOUR;
	$elapsed = plural($hours, 'hour') . ' ' . duration($seconds);
}
else
{
	$elapsed = duration($elapsed);
}

if ($elapsed eq '')
{
	$elapsed = '<1 second';
}

echo(qq{$finish\nElapsed: $elapsed\n});
close($fh);

