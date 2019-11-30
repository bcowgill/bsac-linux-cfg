#!/usr/bin/env perl
# Fill a directory with directories until the directory table is full

use strict;
use warnings;

use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use autodie qw(mkdir);
use FindBin;

our $VERSION = 0.1;
our $DEBUG = 0;
our $PREFIX = 'fill-dir';
our $REPORT = 1000;
our $EXIT = 0;

usage() if scalar(@ARGV) && $ARGV[0] eq '--help';
if (scalar(@ARGV) && $ARGV[0] eq '--debug')
{
	$DEBUG = 1;
	shift;
}

our $where   = shift || '.';
our $prefix  = shift || $PREFIX;
our $maximum = shift || undef;

our $number = 0;
our @Dirs = ();

sub warning
{
	my ($warning) = @ARG;
	warn( "WARN: " . tab($warning) . "\n" );
}

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;

##	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	print tab($msg) . "\n" if ( $DEBUG >= $level );
}

sub usage
{
	my ($msg) = @ARG;
	print "$msg\n\n" if $msg;
	print <<"USAGE";
usage: $FindBin::Script [--help] [--debug] [directory] [prefix] [number]

Fill a directory with directories until the directory table is full.

directory  optional. the directory in which to start creating directories.  default is current directory.
prefix     optional. the prefix name to use.  default is '$PREFIX'
number     optional. if present maximum number of directories to create.

If the prefix name matches 'remove' or 'delete' then the created directories will be removed after all are created.
USAGE
	exit($msg ? 1: 0);
}

main();

sub main
{
	eval
	{
		fill($where, $prefix, $maximum);
	};
	if ($EVAL_ERROR)
	{
		if ($EVAL_ERROR =~ m{no \s+ space \s+ left}xmsi)
		{
			print "$where: directory table is full\n";
		}
		else
		{
			warn($EVAL_ERROR);
			$EXIT = 1;
		}
	}

	print "$number directories created.\n";
	if ($prefix =~ m{remove|delete}xmsi)
	{
		$EXIT = empty($where) || $EXIT;
	}
	exit($EXIT);
}

sub fill
{
	my ($where, $prefix, $max) = @ARG;
	while (1) {
		my $dir_name = $prefix . pad($number, 25);
		my $dir = "$where/$dir_name";
		debug("mkdir $dir");
		mkdir $dir;
		print "mkdir $dir\n" if ++$number % $REPORT == 1;
		push(@Dirs, $dir_name);
		last if $max && $number >= $max;
	};
}

sub empty
{
	my ($where) = @ARG;
	my $removed = 0;
	my $exit = 0;
	foreach my $dir_name (@Dirs)
	{
		my $dir = "$where/$dir_name";
		debug("rmdir $dir");
		if (rmdir $dir)
		{
			print "rmdir $dir\n" if ++$removed % $REPORT == 1;
		}
		else
		{
			warn("$dir: $ERRNO");
			$exit = 2;
		}
	}
	print "$removed directories removed.\n";
	return $exit;
}

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
}

sub pad
{
	my ($value, $width) = @_;
	if (length($value) >= $width)
	{
		return $value;
	}
	return (('0' x ($width - length($value))) . $value);
}

__END__
__DATA__

