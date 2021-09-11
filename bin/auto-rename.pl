#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# auto-rename.pl 'Screenshot.+\.png$' screen-shot- /tmp/me/screenshots /tmp/me
# WINDEV tool useful on windows development machin

use strict;
use warnings;

use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use FindBin;
use Sys::Hostname;
use File::Spec;
use File::Copy qw(move);
use File::Find ();

use autodie qw(open mkdir rmdir unlink move opendir );

# https://www.perl.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl/
use sigtrap qw(handler signal_handler normal-signals);

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	say("$msg\n\n") if $msg;
	say(<<"USAGE");
usage: $cmd [--help|--man|-?] pattern prefix [destination [source]]

This program will automatically rename or move matching files as they appear.

pattern     regex pattern to match against source file name to be renamed.
prefix      prefix for destination file names. Will have NNN appended to it.
destination destination directory to move file to. default is current directory.
source      source directory to find source files in. default is current directory.
--help      shows help for this program.
--man       shows help for this program.
-?          shows help for this program.

The program attempts to create an auto-rename.src/dst.lock directory in the destination and source before beginning to wait for files.

If the lock directories already exist it will terminate early.

If you create a file called stop in either lock directory it will cause the program to terminate at the next scan.

See also renumber-files.sh, rename-files.sh, cp-random.pl, renumber-by-time.sh

Example:

$cmd '\\.jpg\$' screen-shot- \$HOME/screen-shots \$HOME/Desktop

USAGE
	exit($msg ? 1: 0);
} # usage()

our $VERSION = 0.1;
our $DEBUG = 0;
our $DEBUG_TREE = 0;
our $SKIP = 0;

my $DELAY = 1;
my $PAD = 3;
my $signal_received = 0;

my $username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($REAL_USER_ID);
my $host = hostname();
my $origin_info = qq{$username\@$host $PROGRAM_NAME};

our $TESTING = 0;
our $TEST_CASES = 79;
# prove command sets HARNESS_ACTIVE in ENV
unless ($ENV{NO_UNIT_TESTS}) {
	tests() if ($ENV{HARNESS_ACTIVE} || scalar(@ARGV) && $ARGV[0] eq '--test');
}
if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

my $pattern = shift;
my $prefix = shift;
my $destination = shift || '.';
my $source = shift || '.';

my $source_lock;
my $destination_lock;

my $source_lock_stop;
my $destination_lock_stop;

my $source_lock_pid;
my $destination_lock_pid;

my $source_lock_origin;
my $destination_lock_origin;

sub configure_locks
{
	my ($src, $dst) = @ARG;

	$source_lock = file_in_dir($src, 'auto-rename.src.lock');
	$destination_lock = file_in_dir($dst, 'auto-rename.dst.lock');

	$source_lock_stop = file_in_dir($source_lock, 'stop');
	$destination_lock_stop = file_in_dir($destination_lock, 'stop');

	$source_lock_pid  = file_in_dir($source_lock, 'pid');
	$destination_lock_pid  = file_in_dir($destination_lock, 'pid');

	$source_lock_origin  = file_in_dir($source_lock, 'origin');
	$destination_lock_origin  = file_in_dir($destination_lock, 'origin');
}

sub check_args
{
	usage('You must provide a file matching pattern.') unless $pattern;
	usage('You must provide a destination file name prefix.') unless $prefix;

	failure("source [$source] must be an existing directory.") unless -d $source;
	failure("destination [$destination] must be an existing directory.") unless -d $destination;
}

sub main
{
	check_args();
	configure_locks($source, $destination);
	obtain_locks();
	eval
	{
		my $number = get_number($destination, $prefix);
		show_help();

		while (! -e $source_lock_stop && ! -e $destination_lock_stop) {
			sleep($DELAY);
			debug("wake after $DELAY second delay", 4);
			if (! -d $source_lock || ! -d $destination_lock) {
				remove_locks("lock directory [$source_lock] or [$destination_lock] disappeared.")
			}
			my $raNewFiles = get_new_files($source, $pattern);
			sleep($DELAY);
			debug("wake after $DELAY second delay for output to settle before moving.", 4);
			if ($raNewFiles){
				$number = move_files($raNewFiles, $source, $destination, $prefix, $number);
			}
			# TODO show message now and then when nothing has happened for a while...
		}

		debug("stop file [$source_lock_stop] or [$destination_lock_stop] found, exiting.", 1);
	};
	if ($EVAL_ERROR)
	{
		debug("catch from main: $EVAL_ERROR", 1);
		remove_locks($EVAL_ERROR) unless $signal_received;
		say($EVAL_ERROR);
	}
	elsif (!$signal_received)
	{
		remove_locks();
	}
} # main()

sub signal_handler
{
	$signal_received = 1;
	remove_locks();
	die "\n$FindBin::Script terminated by signal";
} # signal_handler()

sub obtain_locks
{
	eval {
		debug("lock $destination_lock", 1);
		mkdir($destination_lock);
		write_file($destination_lock_pid, $PID);
		write_file($destination_lock_origin, $origin_info);
	};
	if ($EVAL_ERROR) {
		failure("unable to obtain destination lock [$destination_lock] may already be in use.");
	}

	eval {
		debug("lock $source_lock", 1);
		mkdir($source_lock);
		write_file($source_lock_pid, $PID);
		write_file($source_lock_origin, $origin_info);
	};
	if ($EVAL_ERROR) {
		my $failure = "unable to obtain source lock [$source_lock] may already be in use.";
		remove_destination_lock($failure);
		failure($failure);
	}
} # obtain_locks()

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
} # get_number()

sub show_help
{
	return say(<<"EOHELP");
scanning $source directory for new files matching $pattern...
   Press Ctrl-C or
   touch $source_lock_stop
   touch $destination_lock_stop
to terminate...
EOHELP
} # show_help()

sub remove_locks
{
	my ($warning) = @ARG;
	remove_source_lock($warning) if -e $source_lock;
	remove_destination_lock($warning);
	failure($warning) if $warning;
} # remove_locks()

sub write_file
{
	my ($file_name, $content) = @ARG;

	my $fh;
	open($fh, '>', $file_name);
	print $fh $content;
	close($fh);
	return $content;
}

sub get_new_files
{
	my ($source_dir, $pattern_match) = @ARG;
	debug("check for new file matches of $pattern_match in $source_dir", 2);
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
			push(@$raFiles, $file);
		}
	}
	closedir($dh);
	return $raFiles;
} # get_new_files()

sub move_files
{
	my ($raNewFiles, $source_dir, $destination_dir, $prefix_name, $number) = @ARG;
	foreach my $file_name (@$raNewFiles)
	{
		$number = move_file($source_dir, $file_name, $destination_dir, $prefix_name, $number);
	}
	return $number;
} # move_files()

sub remove_destination_lock
{
	my ($warning) = @ARG;
	my $failure = "while removing destination lock [$destination_lock_stop] and [$destination_lock].";
	destroy($destination_lock_stop);
	destroy($destination_lock_pid);
	destroy($destination_lock_origin);
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
} # remove_destination_lock()

sub file_in_dir
{
	my ($dir, $filename) = @ARG;
	return File::Spec->catfile($dir, $filename);
} # file_in_dir()

sub remove_source_lock
{
	my ($warning) = @ARG;
	my $failure = "while removing source lock [$source_lock_stop] and [$source_lock].";
	destroy($source_lock_stop);
	destroy($source_lock_pid);
	destroy($source_lock_origin);
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
} # remove_source_lock()

sub move_file
{
	my ($source_dir, $file_name, $destination_dir, $prefix_name, $number) = @ARG;
	my $from = file_in_dir($source_dir, $file_name);
	my $ext = lc(get_extension($file_name));
	my $to = file_in_dir($destination_dir, make_filename($prefix_name, $number, $ext));
	eval
	{
		say(qq{move new file "$from" to "$to"\n});
		# copy($from, $to); # to simulate a move error
		die qq{target file exists already} if (-e $to);
		move($from, $to);
	};
	if ($EVAL_ERROR)
	{
		remove_locks(qq{could not move "$from" to "$to": $EVAL_ERROR});
	}
	return $number + 1;
} # move_file()

# remove a file ignoring any error
sub destroy
{
	my ($file_name) = @ARG;
	my $error;
	eval
	{
		debug("remove $file_name", 1);
		unlink($file_name);
	};
	if ($EVAL_ERROR)
	{
		debug("destroy: $file_name: $EVAL_ERROR", 2);
		$error = 1;
	}
	return $error;
} # destroy()

sub get_extension
{
	my ($filename) = @ARG;
	my $ext = '';
	if ($filename =~ m{(\.[^.]*)\z}xms)
	{
		$ext = $1;
	}
	return $ext;
} # get_extension()

sub make_filename
{
	my ($prefix_name, $number, $ext) = @ARG;
	$number = pad($number, $PAD);
	my $to = qq{$prefix_name$number$ext};
	debug("target file name $to", 4);
	return $to;
} # make_filename()

# pad number with leading zeros
sub pad
{
	my ($number, $width) = @ARG;
	my $padded = ('0' x ($width - length($number))) . $number;
	return $padded;
} # pad()

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

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	my $THREE_SPACES = ' ' x 3;
	$message =~ s{\t}{$THREE_SPACES}xmsg;
	return $message;
} # tab()

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

sub test_make_filename
{
	my ($expect, $prefix, $number, $extension) = @ARG;

	my $result = make_filename($prefix, $number, $extension);
	is($result, $expect, "make_filename: [$prefix, $number, $extension] == [$expect]");
}

sub test_get_extension
{
	my ($expect, $file_name) = @ARG;

	my $result = get_extension($file_name);
	is($result, $expect, "get_extension: [$file_name] == [$expect]");
}

sub test_destroy
{
	my ($expect, $file_name) = @ARG;
	# create a file to be deleted first.
	write_file("this-file-does-not-exist.zyx", "a file to be deleted");
	my $result = destroy($file_name);
	is($result, $expect, "destroy: [$file_name] == [@{[$expect||'undef']}]");
	is_file($file_name, 'not_exists', 'destroy');
} # test_destroy()


sub test_move_file
{
	my  ($expect, $source_dir, $file_name, $destination_dir, $prefix_name, $number) = @ARG;

	my ($dir, $src, $dst) = setup_test_locks("auto-rename-unit-tests-move-file-test");

	# create a file to be moved first.
	my $from_name = "this-file-will-be-moved.XYZ";
	my $to_name = "this-is-target-prefix-023.xyz";
	write_file($from_name, "a file to be moved");

	my $result;
	my $error;
	eval
	{
		$result = move_file($source_dir, $file_name, $destination_dir, $prefix_name, $number);
	};
	if ($EVAL_ERROR)
	{
		$error = 1;
		$result = substr($EVAL_ERROR, 0, 21);
	}

	is($result, $expect, "move_file: [$file_name,...] == [@{[$expect||'undef']}]");
	is_file($file_name, 'not_exists', 'move_file from');
	is_file_content($to_name, $error ? "not_exists" : "a file to be moved", 'move_file to');
	destroy($from_name);
	destroy($to_name);

	wipe_locks($dir, $src, $dst);
} # test_move_file()

sub test_remove_source_lock
{
	my ($expect, $warning) = @ARG;
	my ($dir, $src, $dst) = setup_test_locks("auto-rename-unit-tests-remove-source-lock-test");

	is_dir_content($source_lock, 'dir,full', [
		"$source_lock_origin",
		"$source_lock_pid",
	], "remove_source_lock: [$warning] obtained");

	my $excess_file = file_in_dir($source_lock, 'an-excess-file-in-lock-dir.excess');
	my @ExpectTreeAfter = (
		"$dir/",
		"$dst/",
		"$destination_lock/",
		"$destination_lock_origin",
		"$destination_lock_pid",
		"$src/",
	);

	if ($expect ne 'returned')
	{
		write_file($excess_file, 'this file in lock dir will prevent removal');
		push(@ExpectTreeAfter, ("$source_lock/", $excess_file));
	}

	my $result = 'returned';
	eval
	{
		remove_source_lock($warning);
	};
	if ($EVAL_ERROR)
	{
		$result = $EVAL_ERROR;
	}

	is_like($result, $expect, "remove_source_lock");
	is_tree_content($dir, 'dir,full', \@ExpectTreeAfter, "remove_source_lock: [$warning] removed");

	destroy($excess_file);
	wipe_locks($dir, $src, $dst);
} # test_remove_source_lock()

sub test_file_in_dir
{
	my ($expect, $dir, $file_name) = @ARG;
	my $result = file_in_dir($dir, $file_name);
	is($result, $expect, "file_in_dir: [$dir, $file_name] == [$expect]");
}

sub test_remove_destination_lock
{
	my ($expect, $warning) = @ARG;
	my ($dir, $src, $dst) = setup_test_locks("auto-rename-unit-tests-remove-destination-lock-test");

	is_dir_content($destination_lock, 'dir,full', [
		"$destination_lock_origin",
		"$destination_lock_pid",
	], "remove_destination_lock: [$warning] obtained");

	my $excess_file = file_in_dir($destination_lock, 'an-excess-file-in-lock-dir.excess');
	my @ExpectTreeAfter = (
		"$dir/",
		"$dst/",
		"$src/",
		"$source_lock/",
		"$source_lock_origin",
		"$source_lock_pid",
	);

	if ($expect ne 'returned')
	{
		write_file($excess_file, 'this file in lock dir will prevent removal');
		push(@ExpectTreeAfter, ("$destination_lock/", $excess_file));
		@ExpectTreeAfter = sort(@ExpectTreeAfter);
	}

	my $result = 'returned';
	eval
	{
		remove_destination_lock($warning);
	};
	if ($EVAL_ERROR)
	{
		$result = $EVAL_ERROR;
	}

	is_like($result, $expect, "remove_destination_lock");
	is_tree_content($dir, 'dir,full', \@ExpectTreeAfter, "remove_destination_lock: [$warning] removed");

	destroy($excess_file);
	wipe_locks($dir, $src, $dst);
} # test_remove_destination_lock()

sub test_move_files
{
	my  ($expect, $raFileNames, $source_dir, $destination_dir, $prefix_name, $number) = @ARG;

	my ($dir, $src, $dst) = setup_test_locks("auto-rename-unit-tests-move-files-test");

	# create some files to be moved first.
	my $from_name1 = "this-file-will-be-moved.ABC";
	my $from_name2 = "this-file-will-also-be-moved.ABC";
	my $to_name1 = "this-is-target-prefix-023.abc";
	my $to_name2 = "this-is-target-prefix-024.abc";
	write_file($from_name1, "a file to be moved");
	write_file($from_name2, "another file to be moved");

	my $result;
	my $error;
	eval
	{
		$result = move_files($raFileNames, $source_dir, $destination_dir, $prefix_name, $number);
	};
	if ($EVAL_ERROR)
	{
		$error = 1;
		$result = substr($EVAL_ERROR, 0, 21);
	}

	is($result, $expect, "move_files: [$raFileNames->[0],...] == [@{[$expect||'undef']}]");
	foreach my $file (@$raFileNames)
	{
		is_file($file, 'not_exists', 'move_files from');
	}
	is_file_content($to_name1, $error ? "not_exists" : "a file to be moved", 'move_files to');
	is_file_content($to_name2, $error ? "not_exists" : "another file to be moved", 'move_files to');
	destroy($from_name1);
	destroy($from_name2);
	destroy($to_name1);
	destroy($to_name2);

	wipe_locks($dir, $src, $dst);
} # test_move_files()

sub test_get_new_files
{
	my ($expect, $source_dir, $pattern_match) = @ARG;
	# create files to be found first.
	write_file("this-file-will-be-found.XYZ1", "a file to be found");
	write_file("and-so-will-this-one.XYZ1", "another file to be found");
	my $result;
	eval
	{
		$result = [sort(@{get_new_files($source_dir, $pattern_match)})];
	};
	if ($EVAL_ERROR)
	{
		$result = ["error:"];
	}
	# warning("GET NEW: " . join("\n", @$result));
	# warning("EXPECT: " . join("\n", @$expect));
	is_deeply($result, $expect, "get_new_files: [$pattern_match] == @{[scalar(@$expect)]}");
	destroy("this-file-will-be-found.XYZ1");
	destroy("and-so-will-this-one.XYZ1");
}

sub test_write_file
{
	my ($expect, $file_name, $content) = @ARG;
	my $result;
	my $expect_exists = 0;
	eval
	{
		write_file($file_name, $content);
		$expect_exists = 1;
	};
	if ($EVAL_ERROR)
	{
		$result = "error:";
	}
	$content = 'not_exists' unless ($expect_exists);
	is_file_content($file_name, $content, "write_file");
	destroy($file_name);
} # test_write_file()

sub test_remove_locks
{
	my ($expect, $warning) = @ARG;
	my ($dir, $src, $dst) = setup_test_locks("auto-rename-unit-tests-remove-lock-test");

	is_dir_content($source_lock, 'dir,full', [
		"$source_lock_origin",
		"$source_lock_pid",
	], "remove_locks: [$warning] obtained");

	my $result = 'returned';
	eval
	{
		remove_locks($warning);
	};
	if ($EVAL_ERROR)
	{
		$result = $EVAL_ERROR;
	}

	is($result, $expect, "remove_locks: [$warning] == [$expect]");
	is_tree_content($dir, 'dir,full', [
		"$dir/",
		"$dst/",
		"$src/",
	], "remove_locks: [$warning] removed");

	wipe_locks($dir, $src, $dst);
} # test_remove_locks()

sub test_show_help
{
	$source = 'SOURCE';
	$pattern = 'PATTERN';
	my $expect = <<"EOE";
scanning $source directory for new files matching $pattern...
   Press Ctrl-C or
   touch $source_lock_stop
   touch $destination_lock_stop
to terminate...
EOE
	is(show_help(), $expect, "show_help: == [$expect]");
}

sub test_get_number
{
	my ($expect, $dir, $prefix) = @ARG;
	write_file("auto-rename-unit-tests-get-number-exists-022.XXX", "a file for get_number function test");
	my $result = get_number($dir, $prefix);
	is($result, $expect, "get_number: [$dir, $prefix] == [$expect]");
	destroy("auto-rename-unit-tests-get-number-exists-022.XXX");
}

sub test_obtain_locks
{
	my ($dir, $src, $dst) = setup_test_locks("auto-rename-unit-tests-obtain-lock-test");

	# obtain_locks(); # called by setup_test_locks()

	is_dir_content($dir, 'dir,full', [ "$dst/", "$src/" ], "obtain_locks");
	is_tree_content($dir, 'dir,full', [
		"$dir/",
		"$dst/",
		"$destination_lock/",
		"$destination_lock_origin",
		"$destination_lock_pid",
		"$src/",
		"$source_lock/",
		"$source_lock_origin",
		"$source_lock_pid",
	], "obtain_locks");

	is_file_content($source_lock_pid, $PID, "obtain_locks");
	is_file_content($destination_lock_pid, $PID, "obtain_locks");
	is_file_content($source_lock_origin, $origin_info, "obtain_locks");
	is_file_content($destination_lock_origin, $origin_info, "obtain_locks");

	wipe_locks($dir, $src, $dst);
}

sub test_signal_handler
{
	my ($expect) = @ARG;
	my ($dir, $src, $dst) = setup_test_locks("auto-rename-unit-tests-signal-handler-test");

	is($signal_received, 0, "signal_handler: flag before [$signal_received] == [0]");
	is_dir_content($source_lock, 'dir,full', [
		"$source_lock_origin",
		"$source_lock_pid",
	], "signal_handler: obtained");

	my $result = 'returned';
	eval
	{
		signal_handler();
	};
	if ($EVAL_ERROR)
	{
		$result = $EVAL_ERROR;
	}

	is($signal_received, 1, "signal_handler: flag after [$signal_received] == [1]");
	is_like($result, $expect, "signal_handler: == [$expect]");
	is_tree_content($dir, 'dir,full', [
		"$dir/",
		"$dst/",
		"$src/",
	], "signal_handler: removed");

	wipe_locks($dir, $src, $dst);
} # test_signal_handler()

#===========================================================================
# unit test suite helper functions
#===========================================================================

sub setup_test_locks
{
	my ($dir) = @ARG;
	my $src = file_in_dir($dir, 'source');
	my $dst = file_in_dir($dir, 'destination');

	mkdir($dir);
	mkdir($src);
	mkdir($dst);

	configure_locks($src, $dst);
	obtain_locks();

	return ($dir, $src, $dst);
} # setup_test_locks()

sub wipe_locks
{
	my ($dir, $src, $dst) = @ARG;

	my @LockFiles = (
		$source_lock_origin,
		$source_lock_pid,
		$destination_lock_origin,
		$destination_lock_pid
	);
	my @LockDirs = (
		$source_lock,
		$destination_lock,
		$src,
		$dst,
		$dir
	);

	foreach my $file (@LockFiles) {
		eval
		{
			unlink($file);
		};
	}
	foreach my $lock_dir (@LockDirs) {
		eval
		{
			rmdir($lock_dir);
		};
	}
} # wipe_locks()

#===========================================================================
# unit test library functions
#===========================================================================

# acts as is() or like() based on whether $expected is a string or a regex string
sub is_like
{
	my ($got, $expected, $test_name) = @ARG;
	my $limit = 32;
	if ($expected =~ m{\A\(\?.+\)\z}xms)
	{
		$test_name = "$test_name: like[@{[substr($got, 0, $limit)]}...] =~ $expected" if $test_name;
		like($got, $expected, $test_name);
	}
	else
	{
		$test_name = "$test_name: is[@{[substr($got, 0, 32)]}...] == $expected" if $test_name;
		is($got, $expected, $test_name);
	}
} # is_like()

# acts as isnt() or unlike() based on whether $expected is a string or a regex string
sub isnt_like
{
	my ($got, $expected, $test_name) = @ARG;
	my $limit = 32;
	if ($expected =~ m{\A\(\?.+\)\z}xms)
	{
		$test_name = "$test_name: unlike[@{[substr($got, 0, $limit)]}...] !~ $expected" if $test_name;
		unlike($got, $expected, $test_name);
	}
	else
	{
		$test_name = "$test_name: isnt[@{[substr($got, 0, 32)]}...] != $expected" if $test_name;
		isnt($got, $expected, $test_name);
	}
} # is_like()

sub is_file
{
	my ($file_name, $expected, $test_name) = @ARG;
	$expected ||= 'is_file';
	$test_name = "$test_name: is_file[$file_name] == [$expected]" if $test_name;

	my $result = -e $file_name ? -f _ ? 'is_file' : 'non_file' : 'not_exists';
	is($result, $expected, $test_name);
} # is_file()

sub is_file_content
{
	my ($file_name, $expected, $test_name) = @ARG;
	$test_name = "$test_name: is_file_content[$file_name] == [$expected]" if $test_name;
	my $result;

	eval
	{
		$result = -e $file_name ? read_file($file_name) : 'not_exists';
	};
	if ($EVAL_ERROR)
	{
		$result = "error: $EVAL_ERROR";
	}
	is($result, $expected, $test_name);
} # is_file_content()

# check directory content for files, files and dirs or with full file name based on $mode
sub is_dir_content
{
	my ($dir_name, $mode, $raExpected, $test_name) = @ARG;
	$test_name = "$test_name: is_dir_content[$dir_name] == [@{[scalar(@$raExpected)]}]" if $test_name;
	my @result;
	my $use_full_name = $mode && $mode =~ m{full}xms;
	my $show_dirs = $mode && $mode =~ m{dir}xms;

	eval
	{
		@result = -e $dir_name ? $show_dirs ? read_dir_all($dir_name, $use_full_name) : read_dir($dir_name, $use_full_name) : qw(not_exists);
	};
	if ($EVAL_ERROR)
	{
		@result = ("error:", $EVAL_ERROR);
	}
	warning("DIR_CONTENT_EXPECT:\n  " . join("\n  ", @$raExpected)) if $DEBUG_TREE;
	warning("DIR_CONTENT_RESULT:\n  " . join("\n  ", @result)) if $DEBUG_TREE;
	is_deeply(\@result, $raExpected, $test_name);
} # is_dir_content

# check directory content recursively with short or full file name based on $mode
sub is_tree_content
{
	my ($dir_name, $mode, $raExpected, $test_name) = @ARG;
	$test_name = "$test_name: is_tree_content[$dir_name] == [@{[scalar(@$raExpected)]}]" if $test_name;
	my @result;
	my $use_full_name = $mode && $mode =~ m{full}xms;
	my $show_dirs = $mode && $mode =~ m{dir}xms;

	eval
	{
		@result = -e $dir_name ? read_tree($dir_name, $mode) : qw(not_exists);
	};
	if ($EVAL_ERROR)
	{
		@result = ("error:", $EVAL_ERROR);
	}
	warning("TREE_CONTENT_EXPECT:\n  " . join("\n  ", @$raExpected)) if $DEBUG_TREE;
	warning("TREE_CONTENT_RESULT:\n  " . join("\n  ", @result)) if $DEBUG_TREE;
	is_deeply(\@result, $raExpected, $test_name);
} # is_tree_content()

sub read_file
{
	my ($file_name) = @ARG;
	my $fh;
	local $INPUT_RECORD_SEPARATOR = undef;
	open($fh, '<', $file_name);
	my $result = <$fh>;
	close($fh);
	return $result;
} # read_file()

# read the files in a directory return a sorted array of names or full names
sub read_dir
{
	my ($dir, $use_full_name) = @ARG;
	my $dh;
	my @files;
	opendir($dh, $dir);
	while (my $file = readdir($dh))
	{
		my $full_filename = file_in_dir($dir, $file);
		warning("FULL $full_filename");
		next if (-d $full_filename);
		push(@files, $use_full_name ? $full_filename : $file);
	}
	closedir($dh);
	return sort(@files);
} # read_dir()

# read the dirs and files in a directory return a sorted array of names or full names
sub read_dir_all
{
	my ($dir, $use_full_name) = @ARG;
	my $dh;
	my @files;
	opendir($dh, $dir);
	while (my $file = readdir($dh))
	{
		my $full_filename = file_in_dir($dir, $file);
		next if ($file =~ m{\A\.\.?\z}xms);
		my $name = $use_full_name ? $full_filename : $file;
		$name .= "/" if (-d $full_filename);
		push(@files, $name);
	}
	closedir($dh);
	return sort(@files);
} # read_dir_all()

# read the dirs and files in a directory recursively and return a sorted array of names or full names
sub read_tree
{
	my ($dir, $mode) = @ARG;
	my @files;
	my $use_full_name = $mode && $mode =~ m{full}xms;
	my $show_dirs = $mode && $mode =~ m{dir}xms;

	File::Find::find({
		wanted => sub {
			my ($dev,$ino,$mode,$nlink,$uid,$gid);

			my $found_dir = $File::Find::dir;
			my $name = $File::Find::name;
			if (($dev,$ino,$mode,$nlink,$uid,$gid) = lstat($ARG))
			{
				if (-d _)
				{
					$name .= '/';
					return unless $show_dirs;
				}
				$name = substr($name, length($dir) + 1) unless $use_full_name;
				push(@files, $name);
			}
		}},
		$dir
	);
	return sort(@files);
} # read_tree()

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
	test_make_filename("prefix-name-023.JPG", "prefix-name-", 23, ".JPG") unless $SKIP;
	test_get_extension(".EXT", "file-name.EXT") unless $SKIP;
	test_get_extension(".", "file-name.") unless $SKIP;
	test_get_extension("", "file-name") unless $SKIP;
	test_get_extension(".gz", "file-name.tar.gz") unless $SKIP;
	test_destroy(1, "this-file-does-not-exist.xxx") unless $SKIP;
	test_destroy(undef, "this-file-does-not-exist.zyx") unless $SKIP;
	test_move_file(24, ".", "this-file-will-be-moved.XYZ", ".", "this-is-target-prefix-", 23) unless $SKIP;
	test_move_file("ERROR: could not move", ".", "this-file-does-not-exist.xyz", ".", "this-is-target-prefix-", 23) unless $SKIP;
	test_remove_source_lock("returned", "") unless $SKIP;
	test_remove_source_lock(qr{^ERROR: Can't rmdir.+?Directory not empty}, "") unless $SKIP;
	test_remove_source_lock("ERROR: warning message for remove locks\n", "warning message for remove locks") unless $SKIP;
	test_file_in_dir("dir/file_name.XYZ2", "dir", "file_name.XYZ2") unless $SKIP;
	test_file_in_dir("dir/file_name.XYZ2", "dir/", "file_name.XYZ2") unless $SKIP;
	test_remove_destination_lock("returned", "") unless $SKIP;
#	$SKIP = 0;
#	$DEBUG_TREE = 1;
	test_remove_destination_lock(qr{^ERROR: Can't rmdir.+?Directory not empty}, "") unless $SKIP;
#	$SKIP = 1;
#	$DEBUG_TREE = 0;
	test_remove_destination_lock("ERROR: warning message for remove locks\n", "warning message for remove locks") unless $SKIP;
	test_move_files(25, ["this-file-will-be-moved.ABC", "this-file-will-also-be-moved.ABC"], ".", ".", "this-is-target-prefix-", 23) unless $SKIP;
	test_move_files("ERROR: could not move", ["this-file-does-not-exist.abc"], ".", ".", "this-is-target-prefix-", 23) unless $SKIP;
	test_get_new_files([], ".", "\\.xyzzyZYXXY\$") unless $SKIP;
	test_get_new_files(["error:"], "./directory-does-not-exist", "\\.xyzzyZYXXY\$") unless $SKIP;
	test_get_new_files(["and-so-will-this-one.XYZ1", "this-file-will-be-found.XYZ1"], ".", "\\.XYZ1\$") unless $SKIP;
	test_write_file("content for new file", "this-file-will-be-created.xxx", "content for new file") unless $SKIP;
	test_write_file("error:", "/root/this-file-will-be-created.xxx", "content for new file") unless $SKIP;
	test_remove_locks("returned", "") unless $SKIP;
	test_remove_locks("ERROR: warning message for remove locks\n", "warning message for remove locks") unless $SKIP;
	test_show_help();
	test_get_number(1, ".", "auto-rename-unit-tests-get-number-new-") unless $SKIP;
	test_get_number(23, ".", "auto-rename-unit-tests-get-number-exists-") unless $SKIP;
	test_obtain_locks() unless $SKIP;
	test_signal_handler(qr{^\nauto-rename\.pl terminated by signal at }) unless $SKIP;
	exit 0;
}

__END__
__DATA__
