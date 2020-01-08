#!/usr/bin/env perl

use strict;
use warnings;

use English qw(-no_match_vars);
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use FindBin;
use File::Spec;
use File::Copy qw(move);

use autodie qw(open mkdir rmdir unlink move);

# https://www.perl.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl/
use sigtrap qw(handler signal_handler normal-signals);

our $VERSION = 0.1;
our $DEBUG = 0;

our $TEST_CASES = 1;
tests() if (scalar(@ARGV) && $ARGV[0] eq '--test');

my $DELAY = 1;
my $PAD = 3;
my $signal_received = 0;

my $pattern = shift;
my $prefix = shift;
my $destination = shift || '.';
my $source = shift || '.';

usage('You must provide a file matching pattern.') unless $pattern;
usage('You must provide a destination file name prefix.') unless $prefix;

my $source_lock = file_in_dir($source, 'auto-rename.src.lock');
my $destination_lock = file_in_dir($destination, 'auto-rename.dst.lock');

my $source_lock_stop = file_in_dir($source_lock, 'stop');
my $destination_lock_stop = file_in_dir($destination_lock, 'stop');

failure("source [$source] must be an existing directory.") unless -d $source;
failure("destination [$destination] must be an existing directory.") unless -d $destination;

sub obtain_locks
{
	eval {
		debug("lock $destination_lock", 1);
		mkdir($destination_lock);
	};
	if ($EVAL_ERROR) {
		failure("unable to obtain destination lock [$destination_lock] may already be in use.");
	}

	eval {
		debug("lock $source_lock", 1);
		mkdir($source_lock);
	};
	if ($EVAL_ERROR) {
		my $failure = "unable to obtain source lock [$source_lock] may already be in use.";
		remove_destination_lock($failure);
		failure($failure);
	}
}

sub remove_destination_lock
{
	my ($warning) = @ARG;
	my $failure = "while removing destination lock [$destination_lock_stop] and [$destination_lock].";
	eval
	{
		debug("remove $destination_lock_stop", 1);
		unlink($destination_lock_stop);
	};
	eval
	{
		debug("unlock $destination_lock", 1);
		rmdir($destination_lock);
	};
	if ($EVAL_ERROR)
	{
		if ($warning)
		{
			warning("$EVAL_ERROR $failure");
			failure($warning);
		}
		else
		{
			failure("$EVAL_ERROR $failure")
		}
	}
}

sub remove_source_lock
{
	my ($warning) = @ARG;
	my $failure = "while removing source lock [$source_lock_stop] and [$source_lock].";
	eval
	{
		debug("remove $source_lock_stop", 1);
		unlink($source_lock_stop);
	};
	eval
	{
		debug("unlock $source_lock", 1);
		rmdir($source_lock);
	};
	if ($EVAL_ERROR)
	{
		if ($warning)
		{
			warning("$EVAL_ERROR $failure");
			failure($warning);
		}
		else
		{
			failure("$EVAL_ERROR $failure")
		}
	}
}

sub remove_locks
{
	my ($warning) = @ARG;
	remove_source_lock($warning) if -e $source_lock;
	remove_destination_lock($warning);
	failure($warning) if $warning;
}

sub signal_handler
{
	$signal_received = 1;
	remove_locks();
	die "\n$FindBin::Script terminated by signal";
}

sub show_help
{
	print <<"EOHELP";
scanning $source directory for new files matching $pattern...
   Press Ctrl-C or
   touch $source_lock_stop
   touch $destination_lock_stop
to terminate...
EOHELP
}

sub get_number
{
	my ($dir, $prefix) = @ARG;
	my $number = 1;
	my $match = qr{$prefix(\d+)\.}xms;
	debug("find next file number for $dir/$match", 5);
	my $dh;
	opendir($dh, $dir);
	while (my $file = readdir($dh))
	{
		my $full_filename = file_in_dir($dir, $file);
		debug("ignore if $full_filename is a directory", 7);
		next if (-d $full_filename);
		if ($file =~ $match)
		{
			my $num = 0 + $1;
			debug("matched $num from $file", 6);
			$number = $num >= $number ? $num + 1 : $number;
			debug("using number $number", 7);
		}
	}
	closedir($dh);
	debug("start naming files with number $number", 1);
	return $number;
}

sub pad
{
	my ($number, $width) = @ARG;
	my $padded = ('0' x ($width - length($number))) . $number;
	return $padded;
}

sub get_new_files
{
	my ($source_dir, $pattern_match) = @ARG;
	debug("wake, check for new file matches of $pattern_match in $source_dir", 2);
	my $dh;
	my $raFiles = [];
	opendir($dh, $source_dir);
	while (my $file = readdir($dh))
	{
		my $full_filename = file_in_dir($source_dir, $file);
		debug("ignore if $full_filename is a directory", 4);
		next if (-d $full_filename);
		debug("check file $file vs $pattern_match", 3);
		# TODO get files from dir which match the pattern
		if ($file =~ m{$pattern_match}xms) {
			debug("matched $file", 3);
			push($raFiles, $file);
		}
	}
	closedir($dh);
	return $raFiles;
}

sub move_files
{
	my ($raNewFiles, $source_dir, $destination_dir, $prefix_name, $number) = @ARG;
	foreach my $file_name (@$raNewFiles)
	{
		$number = move_file($source_dir, $file_name, $destination_dir, $prefix_name, $number);
	}
	return $number;
}

sub make_filename
{
	my ($prefix_name, $number, $ext) = @ARG;
	$number = pad($number, $PAD);
	my $to = qq{$prefix_name$number$ext};
	debug("target file name $to", 4);
	return $to;
}

sub move_file
{
	my ($source_dir, $file_name, $destination_dir, $prefix_name, $number) = @ARG;
	my $from = file_in_dir($source_dir, $file_name);
	my $ext = lc(get_extension($file_name));
	my $to = file_in_dir($destination_dir, make_filename($prefix_name, $number, $ext));
	eval
	{
		print(qq{move new file "$from" to "$to"\n});
		# copy($from, $to); # to simulate a move error
		die qq{target file exists already} if (-e $to);
		move($from, $to);
	};
	if ($EVAL_ERROR)
	{
		remove_locks(qq{could not move "$from" to "$to": $EVAL_ERROR});
	}
	return $number + 1;
}

sub main
{
	obtain_locks();
	eval
	{
		my $number = get_number($destination, $prefix);
		show_help();

		while (! -e $source_lock_stop && ! -e $destination_lock_stop) {
			sleep($DELAY);
			if (! -d $source_lock || ! -d $destination_lock) {
				remove_locks("lock directory [$source_lock] or [$destination_lock] disappeared.")
			}
			my $raNewFiles = get_new_files($source, $pattern);
			if ($raNewFiles){
				$number = move_files($raNewFiles, $source, $destination, $prefix, $number);
			}
			# TODO show message now and then when nothing has happened for a while...
		}

		debug("stop file [$source_lock_stop] or [$destination_lock_stop] found, exiting.", 1);
	};
	if ($EVAL_ERROR)
	{
		remove_locks($EVAL_ERROR) unless $signal_received;
		print($EVAL_ERROR);
	}
	elsif (!$signal_received)
	{
		remove_locks();
	}
}

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

sub failure
{
	my ($warning) = @ARG;
	die( "ERROR: " . tab($warning) . "\n" );
}

sub debug
{
	my ( $msg, $level ) = @ARG;
	$level ||= 1;

##	print "debug @{[substr($msg,0,10)]} debug: $DEBUG level: $level\n";
	print tab($msg) . "\n" if ( $DEBUG >= $level );
}

sub file_in_dir
{
	my ($dir, $filename) = @ARG;
	return File::Spec->catfile($dir, $filename);
}

sub get_extension
{
	my ($filename) = @ARG;
	my $ext = '';
	if ($filename =~ m{(\.[^.]+)\z}xms)
	{
		$ext = $1;
	}
	return $ext;
}

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	print "$msg\n\n" if $msg;
	print <<"USAGE";
usage: $cmd pattern prefix [destination [source]]

This program will automatically rename or move matching files as they appear.

pattern     regex pattern to match against source file name to be renamed.
prefix      prefix for destination file names. Will have NNN appended to it.
destination destination directory to move file to. default is current directory.
source      source directory to find source files in. default is current directory.

The program attempts to create an auto-rename.src/dst.lock directory in the destination and source before beginning to wait for files.

If the lock directories already exist it will terminate early.

If you create a file called stop in either lock directory it will cause the program to terminate at the next scan.

Example:

$cmd '\\.jpg\$' screen-shot- \$HOME/screen-shots \$HOME/Desktop

USAGE
	exit($msg ? 1: 0);
}

main();

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
