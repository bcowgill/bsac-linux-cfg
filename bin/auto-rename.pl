#!/usr/bin/env perl
# auto-rename.pl 'Screenshot.+\.png$' screen-shot- /tmp/me/screenshots /tmp/me

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

use autodie qw(open mkdir rmdir unlink move opendir );

# https://www.perl.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl/
use sigtrap qw(handler signal_handler normal-signals);

our $VERSION = 0.1;
our $DEBUG = 0;

my $DELAY = 1;
my $PAD = 3;
my $signal_received = 0;

our $TESTING = 0;
our $TEST_CASES = 29;
tests() if (scalar(@ARGV) && $ARGV[0] eq '--test');

my $pattern = shift;
my $prefix = shift;
my $destination = shift || '.';
my $source = shift || '.';

my $source_lock = file_in_dir($source, 'auto-rename.src.lock');
my $destination_lock = file_in_dir($destination, 'auto-rename.dst.lock');

my $source_lock_stop = file_in_dir($source_lock, 'stop');
my $destination_lock_stop = file_in_dir($destination_lock, 'stop');

my $source_lock_pid  = file_in_dir($source_lock, 'pid');
my $destination_lock_pid  = file_in_dir($destination_lock, 'pid');

my $source_lock_origin  = file_in_dir($source_lock, 'origin');
my $destination_lock_origin  = file_in_dir($destination_lock, 'origin');

my $username = $ENV{LOGNAME} || $ENV{USER} || getpwuid($REAL_USER_ID);
my $host = hostname();
my $origin_info = qq{$username\@$host $PROGRAM_NAME};

sub check_args
{
	usage('You must provide a file matching pattern.') unless $pattern;
	usage('You must provide a destination file name prefix.') unless $prefix;

	failure("source [$source] must be an existing directory.") unless -d $source;
	failure("destination [$destination] must be an existing directory.") unless -d $destination;
}

sub usage
{
	my ($msg) = @ARG;
	my $cmd = $FindBin::Script;

	say("$msg\n\n") if $msg;
	say(<<"USAGE");
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
} # usage()

sub main
{
	check_args();
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
	say(<<"EOHELP");
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
			push($raFiles, $file);
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
	write_file("this-file-does-not-exist.xyz", "a file to be deleted");
	my $result = destroy($file_name);
	is($result, $expect, "destroy: [$file_name] == [@{[$expect||'undef']}]");
	is_file($file_name, 'not_exists', 'destroy');
} # test_destroy()


sub test_move_file
{
	my  ($expect, $source_dir, $file_name, $destination_dir, $prefix_name, $number) = @ARG;
	# create a file to be moved first.
	my $to_name = "this-is-target-prefix-023.xyz";
	write_file("this-file-will-be-moved.XYZ", "a file to be moved");
	my $result = move_file($source_dir, $file_name, $destination_dir, $prefix_name, $number);
	is($result, $expect, "move_file: [$file_name,...] == [@{[$expect||'undef']}]");
	is_file($file_name, 'not_exists', 'move_file from');
	is_file_content($to_name, "a file to be moved", 'move_file to');
	destroy($to_name);
}

# TODO implement unit tests

# test_move_file, etc...

sub test_get_new_files
{
	my ($expect, $source_dir, $pattern_match) = @ARG;
	# create files to be found first.
	write_file("this-file-will-be-found.XYZ", "a file to be found");
	write_file("and-so-will-this-one.XYZ", "another file to be found");
	my $result;
	eval
	{
		$result = get_new_files($source_dir, $pattern_match);
	};
	if ($EVAL_ERROR)
	{
		$result = ["error:"];
	}
	is_deeply($result, $expect, "get_new_files: [$pattern_match] == @{[scalar(@$expect)]}");
	destroy("this-file-will-be-found.XYZ");
	destroy("and-so-will-this-one.XYZ");
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

sub test_file_in_dir
{
	my ($expect, $dir, $file_name) = @ARG;
	my $result = file_in_dir($dir, $file_name);
	is($result, $expect, "file_in_dir: [$dir, $file_name] == [$expect]");
}

# test_remove_locks

#===========================================================================
# unit test library functions
#===========================================================================

sub is_file
{
	my ($file_name, $expected, $test_name) = @ARG;
	$expected ||= 'is_file';
	$test_name = "$test_name: is_file[$file_name] == [$expected]" if $test_name;

	my $result = -e $file_name ? -f _ ? 'is_file' : 'non_file' : 'not_exists';
	is($result, $expected, $test_name);
}

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
}

sub read_file
{
	my ($file_name) = @ARG;
	my $fh;
	local $INPUT_RECORD_SEPARATOR = undef;
	open($fh, '<', $file_name);
	my $result = <$fh>;
	close($fh);
	return $result;
}

#===========================================================================
# unit test suite
#===========================================================================

sub tests
{
	$TESTING = 1;
	eval "use Test::More tests => $TEST_CASES;";
	eval "use Test::Exception;";

	test_say("Hello, there", "Hello, there");
	test_tab("         Hello", "\t\t\tHello");
	test_warning("WARN: WARNING, OH MY!\n", "WARNING, OH MY!");
	test_debug(undef, "DEBUG, OH MY!", 10000);
	test_debug("DEBUG, OH MY!\n", "DEBUG, OH MY!", -10000);
	test_failure("ERROR: FAILURE, OH MY!\n", "FAILURE, OH MY!");
	test_pad("000", "");
	test_pad("001", "1");
	test_pad("123", "123");
	test_pad("1234", "1234");
	test_make_filename("prefix-name-023.JPG", "prefix-name-", 23, ".JPG");
	test_get_extension(".EXT", "file-name.EXT");
	test_get_extension(".", "file-name.");
	test_get_extension("", "file-name");
	test_get_extension(".gz", "file-name.tar.gz");
	test_destroy(1, "this-file-does-not-exist.xxx");
	test_destroy(undef, "this-file-does-not-exist.xyz");
	#test_move_file("error", ".", "this-file-does-not-exist.xyz", ".", "this-is-target-prefix-", 23);
	test_move_file(24, ".", "this-file-will-be-moved.XYZ", ".", "this-is-target-prefix-", 23);
# test_remove_source_lock
	test_file_in_dir("dir/file_name.XYZ", "dir", "file_name.XYZ");
	test_file_in_dir("dir/file_name.XYZ", "dir/", "file_name.XYZ");
# test_remove_destination_lock
# test_move_files
   test_get_new_files([], ".", "\\.xyzzyZYXXY\$");
   test_get_new_files(["error:"], "./directory-does-not-exist", "\\.xyzzyZYXXY\$");
   test_get_new_files(["and-so-will-this-one.XYZ", "this-file-will-be-found.XYZ"], ".", "\\.XYZ\$");
   test_write_file("content for new file", "this-file-will-be-created.xxx", "content for new file");
	test_write_file("error:", "/root/this-file-will-be-created.xxx", "content for new file");
# test_remove_locks
# test_show_help
# test_get_number
# test_obtain_locks
# test_signal_handler
	exit 0;
}

# bring say, $TESTING changes over to perl template and any scripts based on this.

__END__
__DATA__
