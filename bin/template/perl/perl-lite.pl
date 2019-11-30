#!/usr/bin/env perl
# TODO short description - lightweight perl script template slurp a file, internal DATA, usage/warning/debug output, no arg handling, internal unit tests

use strict;
use warnings;

use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use File::Slurp qw(:std :edit);
use autodie qw(open);
use FindBin;

our $VERSION = 0.1;
our $DEBUG = 1;

our $TEST_CASES = 1;
tests() if (scalar(@ARGV) && $ARGV[0] eq '--test');

warning("oops");
debug("debug");

while (my $line = <DATA>) {
	print "$line";
}

usage();

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
}

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
	my $cmd = $FindBin::Script;

	print "$msg\n\n" if $msg;
	print <<"USAGE";
usage: $cmd

TODO short usage - lightweight perl script template slurp a file, internal DATA, usage/warning/debug output, no arg handling, internal unit tests
USAGE
	exit($msg ? 1: 0);
}

#===========================================================================
# unit test functions
#===========================================================================

sub test_tab
{
	my ($expect, $message) = @ARG;

	my $spaced = tab($message);
	is($spaced, $expect, "tab: [$message] == [$expect]");
}

#===========================================================================
# unit test suite
#===========================================================================

sub tests
{
	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	test_tab("         Hello", "\t\t\tHello");
	exit 0;
}

__END__
__DATA__
I am the data.
