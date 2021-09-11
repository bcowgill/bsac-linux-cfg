#!/usr/bin/env perl
# TODO short description - lightweight perl script template slurp a file, internal DATA, usage/warning/debug output, no arg handling, internal unit tests
# W I N D E V tool useful on windows development machin

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use FindBin;
#use Sys::Hostname;
#use File::Spec;
#use File::Copy qw(move);
#use File::Find ();
use File::Slurp qw(:std :edit);

use autodie qw(open); # mkdir rmdir unlink move opendir );
# https://www.perl.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl/
use sigtrap qw(handler signal_handler normal-signals);

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	say("$msg\n\n") if $msg;
	say(<<"USAGE");
usage: $cmd [--help|--man|-?] filename...

TODO short usage - lightweight perl script template slurp a file, internal DATA, usage/warning/debug output, no arg handling, internal unit tests

This program will ...

filename    files to process instead of standard input.
--help      shows help for this program.
--man       shows help for this program.
-?          shows help for this program.

More details...

See also ...

Example:

$cmd filename...

USAGE
	exit($msg ? 1: 0);
} # usage()

our $VERSION = 0.1;
our $DEBUG = 1;
our $SKIP = 0;

my $PAD = 3;
my $signal_received = 0;

our $TESTING = 0;
our $TEST_CASES = 10;
# prove command sets HARNESS_ACTIVE in ENV
unless ($ENV{NO_UNIT_TESTS}) {
	tests() if ($ENV{HARNESS_ACTIVE} || scalar(@ARGV) && $ARGV[0] eq '--test');
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

usage();

sub check_args
{
	# usage('You must provide a file matching pattern.') unless $pattern;
	# usage('You must provide a destination file name prefix.') unless $prefix;

	# failure("source [$source] must be an existing directory.") unless -d $source;
	# failure("destination [$destination] must be an existing directory.") unless -d $destination;
}

sub main
{
	check_args();
	# see auto-rename.pl if you need robust locking...
	# configure_locks($source, $destination);
	# obtain_locks();
	eval
	{
		warning(Dumper(\%ENV));
		warning("oops");
		debug("debug");

		# failure("very very bad man");

		while (my $line = <DATA>) {
			say("$line");
		}
	};
	if ($EVAL_ERROR)
	{
		debug("catch from main: $EVAL_ERROR", 1);
		# remove_locks($EVAL_ERROR) unless $signal_received;
		say($EVAL_ERROR);
	}
	elsif (!$signal_received)
	{
		# remove_locks();
	}
} # main()

sub signal_handler
{
	$signal_received = 1;
	# remove_locks();
	die "\n$FindBin::Script terminated by signal";
} # signal_handler()

# pad number with leading zeros
sub pad
{
	my ($number, $width) = @ARG;
	my $padded = ('0' x ($width - length($number))) . $number;
	return $padded;
} # pad()

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
} # tab()

sub failure
{
	my ($warning) = @ARG;
	die( "ERROR: " . tab($warning) . "\n" );
} # failure()

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;
	my $message;

##	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	if ( $DEBUG >= $level )
	{
		$message = tab($msg) . "\n";
		if ($TESTING)
		{
			diag(qq{DEBUG: $message});
		}
		else
		{
			print $message
		}
	}
	return $message
} # debug()

sub warning
{
	my ($warning) = @ARG;
	my $message = "WARN: " . tab($warning) . "\n";
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		warn( $message );
	}
	return $message;
} # warning()

sub say
{
	my ($message) = @ARG;
	if ($TESTING)
	{
		diag( $message );
	}
	else
	{
		print $message;
	}
	return $message;
}

main();

#===========================================================================
# unit test functions
#===========================================================================

sub test_say
{
	my ($expect, $message) = @ARG;
	my $result = say($message);
	is($result, $expect, "say: [$message] == [$expect]");
}

sub test_tab
{
	my ($expect, $message) = @ARG;

	my $result = tab($message);
	is($result, $expect, "tab: [$message] == [$expect]");
}

sub test_warning
{
	my ($expect, $message) = @ARG;
	my $result = warning($message);
	is($result, $expect, "warning: [$message] == [$expect]");
}

sub test_debug
{
	my ($expect, $message, $level) = @ARG;
	my $result = debug($message, $level);
	is($result, $expect, "debug: [$message, $level] == [@{[$expect || 'undef']}]");
}

sub test_failure
{
	my ($expect, $message) = @ARG;

	my $result;
	eval {
		failure($message);
	};
	if ($EVAL_ERROR)
	{
		$result = $EVAL_ERROR;
	}
	is($result, $expect, "failure: [$message] == [$expect]");
} # test_failure()

sub test_pad
{
	my ($expect, $message) = @ARG;

	my $result = pad($message, $PAD);
	is($result, $expect, "pad: [$message] == [$expect]");
}

#===========================================================================
# unit test suite helper functions
#===========================================================================

# setup / teardown and other helpers specific to this test suite
# see auto-rename.pl for setup of lock dirs etc.

#===========================================================================
# unit test library functions
#===========================================================================

# see auto-rename.pl for a wide variety of test assertions for files, directories, etc.

#===========================================================================
# unit test suite
#===========================================================================

sub tests
{
	$TESTING = 1;

	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	test_say("Hello, there", "Hello, there") unless $SKIP;
	test_tab("         Hello", "\t\t\tHello") unless $SKIP;
	test_warning("WARN: WARNING, OH MY!\n", "WARNING, OH MY!") unless $SKIP;
	test_debug(undef, "DEBUG, OH MY!", 10000) unless $SKIP;
	test_debug("DEBUG, OH MY!\n", "DEBUG, OH MY!", -10000) unless $SKIP;
	test_failure("ERROR: FAILURE, OH MY!\n", "FAILURE, OH MY!") unless $SKIP;
	test_pad("000", "") unless $SKIP;
	test_pad("001", "1") unless $SKIP;
	test_pad("123", "123") unless $SKIP;
	test_pad("1234", "1234") unless $SKIP;
	exit 0;
}

__END__
__DATA__
I am the data.
