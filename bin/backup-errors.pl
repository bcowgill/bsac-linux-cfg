#!/usr/bin/env perl
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

=head1 NAME

backup-errors.pl - Back up files from a previous backup file error listing.

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

backup-errors.pl [options] --from=from-path --to=to-path file-list

Given an error list of file names from a backup operation attempt to back them up again.  You can re-run until the list is finally empty if your device keeps disconnecting.

 Options:
   --from           mandatory. the base directory to copy files from
   --to             mandatory. the base directory to copy files to
   --check          if specified will compute md5 checksum before copying the file
   --version        display program version
   --help -?        brief help message
   --man            full help message

=head1 OPTIONS

=item B<--from>

 Specifies the base directory to backup files from.

=item B<--to>

 Specifies the base destination directory to copy files to.

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION

 B<This program> will read the provided file-list file and attempt to copy the files listed from the from-path to the to-path.

 The file-list file should have one file name per line with optional md5sum at the start and a colon.

 If a line in the file-list begins with '#' character it will be treated as a comment and ignored as well as blank lines.

 The original file-list will be saved to a backup and a new file-list will be created for any files which failed to back up.

 The order that the files are backed up will be random to avoid any kind of media error which happens after a given time.

 If any file is missing in the from-dir it will appear commented out in the newly written error log.  It will disappear from the file if run again while commented out.

=head1 EXAMPLES

 backup-errors.pl --from=/data/user/mtp/phone --to=/backup/phone phone-backup-errors.log

=cut

{ use 5.006; }
use strict;
use warnings;

use English qw(-no_match_vars);
use Getopt::ArgvFile defult => 1;    # allows specifying an @options file to read more command line arguments from
use Getopt::Long;
use Pod::Usage;

#use Getopt::Long::Descriptive; # https://github.com/rjbs/Getopt-Long-Descriptive/blob/master/lib/Getopt/Long/Descriptive.pm
#use Switch;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use Digest::MD5;
use File::Slurp qw(:std);
use autodie qw(open);

our $VERSION = 0.1;       # shown by --version option
our $TEST_CASES = 1;
tests() if (scalar(@ARGV) && $ARGV[0] eq '--test');

use FindBin;
use File::Spec;
use File::Copy qw(copy);
use File::Path qw(make_path);

# https://www.perl.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl/
use sigtrap qw(handler signal_handler normal-signals);

my $critical_section = 0;
my $signal_received = 0;

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			check   => 0,    # default checksum after copy
			verbose => 1,    # default value for verbose
			debug   => 0,
			man     => 0,    # show full help page
		},
		raFile => [],
	},
	rhGetopt => {
		result   => undef,
		raErrors => [],
		raConfig => [
			"bundling",        # bundle single char options ie ps -aux
			"auto_version",    # supplies --version option
			"auto_help",       # supplies --help -? options to show usage in POD SYNOPSIS

##			"debug",           # debug the argument processing
		],
		raOpts => [
			"from=s",        # from directory for files to backup
			"to=s",          # to directory for backup destination
			"check",         # when true will checksum before it copies
			"debug|d+",      # incremental keep specifying to increase
			"verbose|v!",    # flag --verbose or --noverbose
			"man",           # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	fileName   => '<STDIN>',    # name of file
	entireFile => '',           # entire file contents for processing
	backupSuccess => 0,         # count of successful backups
	backupMissing => 0,         # count of source files which were missing
	backupFiles => {},          # map of file name to md5sum
	backupErrors => {},          # map of files which failed to copy
);

sub signal_handler
{
	$signal_received = 1;
	if (!$critical_section)
	{
		die "\n$FindBin::Script terminated by signal";
	}
} # signal_handler()

sub check_signal
{
	if ($signal_received)
	{
		die "\n$FindBin::Script terminated by earlier signal";
	}
} # check_signal()

# Return the value of a command line option
sub opt
{
	my ($opt) = @ARG;
	return defined($opt) ?
		$Var{'rhArg'}{'rhOpt'}{$opt} :
		$Var{'rhArg'}{'rhOpt'};
}

sub hasOpt
{
	my ($opt) = @ARG;
	return exists( $Var{'rhArg'}{'rhOpt'}{$opt} );
}

sub setOpt
{
	my ( $opt, $value ) = @ARG;
	return $Var{'rhArg'}{'rhOpt'}{$opt} = $value;
}

sub arg
{
	my ($arg) = @ARG;
	return defined($arg) ?
		$Var{'rhArg'}{$arg} :
		$Var{'rhArg'};
}

sub setArg
{
	my ( $arg, $value ) = @ARG;
	return $Var{'rhArg'}{$arg} = $value;
}

my $lines_seen = 0;
getOptions();

sub main
{
	my ($raFiles) = @ARG;
	debug( "Var: " . Dumper( \%Var ), 2 );
	debug( "main() rhOpt: " . Dumper( opt() ) .
		"\nraFiles: " . Dumper($raFiles), 2 );

	processFiles( $raFiles ) if scalar(@$raFiles);
	summary($raFiles->[0]);
}

sub summary
{
	my ($errorLog) = @ARG;
	print "$lines_seen lines read from $errorLog\n";
	backupFiles($errorLog);
}

# slow visible delay, used for testing critical section
sub count
{
	foreach my $count (1 .. 10)
	{
		print "$count ...\n";
		sleep(1);
	}
}

sub backupFiles
{
	my ($errorLog) = @ARG;
	my @files = keys(%{$Var{'backupFiles'}});
	while (scalar(@files))
	{
		debug("backupFiles @{[scalar(@files)]} files to try");
		foreach my $fileName (@files)
		{
			if (pick())
			{
				backupFile($fileName);
			}
		}
		@files = keys(%{$Var{'backupFiles'}});
	}

	sumUp($errorLog);
}

sub sumUp
{
	my ($errorLog) = @ARG;
	# Critical section, prevent ^C from stopping this
	$critical_section = 1;
	print "$Var{'backupSuccess'} files backed up.\n";
	print "$Var{'backupMissing'} files were missing.\n";
	my @errors = getBackupErrors();
	print "@{[scalar(@errors)]} backup errors.\n";
	if (opt('check') || $Var{'backupSuccess'} || $Var{'backupMissing'})
	{
		writeErrors($errorLog, \@errors);
	}
	$critical_section = 0;
	check_signal();
}

sub getBackupErrors
{
	my @files = sort(keys(%{$Var{'backupErrors'}}));
	return map { getErrorLine($ARG) } @files;
}

sub getErrorLine
{
	my ($fileName) = @ARG;
	my $md5sum = $Var{'backupErrors'}{$fileName};
	my $errorLine = $md5sum ? "$md5sum: $fileName" : $fileName;
	return $errorLine;
}

sub writeErrors
{
	my ($fileName, $raErrors) = @ARG;
	write_file($fileName, { err_mode => 'carp' }, join("\n", @$raErrors) . "\n");
	print "$fileName updated with @{[scalar(@$raErrors)]} errors\n";
}

sub pick
{
	return rand() < 0.1;
}

sub fileInDir
{
	my ($dir, $filename) = @ARG;
	return File::Spec->catfile($dir, $filename);
} # fileInDir()

sub createTargetDirForFile
{
	my ($targetFileName) = @ARG;
	debug("createTargetDirForFile($targetFileName)\n", 4);
   my ($volume, $directories, $file) = File::Spec->splitpath( $targetFileName );
	$targetFileName = File::Spec->catpath($volume, $directories);
	debug("createTargetDirForFile: $targetFileName\n", 4);
	make_path($targetFileName);
}

sub checkSum
{
	my ($fileName) = @ARG;
	my $md5sum = '';
	my $error;

	open (my $fh, '<', $fileName) or die "$fileName could not checksum: $ERRNO";
	binmode ($fh);
	eval
	{
		$md5sum = Digest::MD5->new()->addfile($fh)->hexdigest();
	};
	if ($EVAL_ERROR)
	{
		$error = "$fileName: checksum $EVAL_ERROR";
	}
	close($fh);
	if ($error)
	{
		die $error;
	}

	return $md5sum;
} # checkSum()

sub md5sum
{
	my ($fileName) = @ARG;
	my $md5sum = '';

	my $result = `md5sum "$fileName"`;
	print "md5sum result: $result\n";
	if ($result =~ m{\A([0-9a-f]+)\s+}xmsi)
	{
		$md5sum = $1;
	}
	if (!$md5sum)
	{
		$md5sum = checkSum($fileName);
	}
	return $md5sum;
} # md5sum()

sub backupFile
{
	my ($fileName) = @ARG;
	debug("backupFile: $fileName");
	my $md5sum = $Var{'backupFiles'}{$fileName};
	my $from = fileInDir(opt('from'), $fileName);
	my $to = fileInDir(opt('to'), $fileName);
	my $error;

	eval
	{
		# if file does not exist in from-dir we mark it missing in error list
		unless (-e $from)
		{
			$Var{'backupMissing'}++;
			# effectively comment out lines for files which don't exist in from-dir
			$md5sum = $md5sum ? "#$md5sum" : "#";
			die "$fileName not found in from-dir, cannot verify backup";
		}
		if (!$md5sum && opt('check'))
		{
				$md5sum = checkSum($from);
				$Var{'backupFiles'}{$fileName} = $md5sum;
		}
		if (!-e $to)
		{
			createTargetDirForFile($to);
			copy($from, $to) || die "$from could not be backed up: $ERRNO";
		}
		if (-e $to)
		{
			my $targetCheckSum = checkSum($to);
			if (!$md5sum)
			{
				$md5sum = checkSum($from);
				$Var{'backupFiles'}{$fileName} = $md5sum;
			}
			if ($md5sum && ($md5sum ne $targetCheckSum))
			{
				die "$fileName: $md5sum != $targetCheckSum backed up file checksum differs";
			}
		}
	};
	if ($EVAL_ERROR)
	{
		$error = $EVAL_ERROR;
	}

	if ($error)
	{
		error($error);
		$Var{'backupErrors'}{$fileName} = $md5sum;
		delete $Var{'backupFiles'}{$fileName};
	}
	else
	{
		print "ok $fileName\n";
		$Var{'backupSuccess'}++;
		delete $Var{'backupFiles'}{$fileName};
	}
} # backupFile()

sub setup
{
	$OUTPUT_AUTOFLUSH = 1 if opt('debug');
	debug( "Var: " . Dumper( \%Var ), 2 );
	debug( "setup() rhOpt: " . Dumper( opt() ), 2 );
}

sub processFiles
{
	my ($raFiles) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		processEntireFile( $fileName );
	}
}

sub processEntireFile
{
	my ($fileName) = @ARG;
	debug("processEntireFile($fileName)\n");

	# example slurp in the file and show something line by line
	$Var{fileName} = $fileName;
	my $rContent = read_file( $fileName, scalar_ref => 1 );
	$Var{entireFile} = $$rContent;
	backupListingFile($fileName, $$rContent);
	doEntireLines();
}

sub backupListingFile
{
	my ($fileName, $content) = @ARG;
	my $backup = qq{$fileName.bak};
	debug("backupListingFile($fileName) to $backup\n");
	write_file($backup, { err_mode => 'carp' }, $content);
}

sub doEntireLines
{
	my $line;
	my $print = 0;
	print "$Var{fileName}\n";
	my @Lines = split( "\n", $Var{entireFile} );
	for ( my $idx = 0; $idx < scalar(@Lines); ++$idx )
	{
		$line = $Lines[$idx] . "\n";
		( $line, $print ) = doLine( $line, $print );
	}
}

sub doLine
{
	my ( $line, $print ) = @ARG;
	my $regex = qr{\A(([0-9a-f]+):\s*)?(.+)\z}xmsi;
	chomp $line;
	debug("doLine: [$line]");
	++$lines_seen;
	if (($line !~ m{\A\s*\#}xms) && $line =~ $regex)
	{
		registerFile($2, $3);
		#$print = 1;
	}
	print $line if $print;
	return ( $line, $print );
}

sub registerFile
{
	my ($md5sum, $fileName) = @ARG;
	debug("registerFile: [@{[$md5sum||'']}] $fileName");
	$Var{'backupFiles'}{$fileName} = $md5sum;
}

# Must manually check mandatory values present
sub checkOptions
{
	my ( $raErrors, $raFiles ) = @ARG;
	checkMandatoryOptions( $raErrors, $Var{rhGetopt}{raMandatory} );

	# Check additional parameter dependencies and push onto error array
	if (scalar(@$raFiles) > 1) {
		push(@$raErrors, "please specify only one file-list backup error log file to process.");
	}

	if ( scalar(@$raErrors) )
	{
		usage( join( "\n", @$raErrors ) );
	}
}

sub checkMandatoryOptions
{
	my ( $raErrors, $raMandatory ) = @ARG;

	$raMandatory = $raMandatory || [];
	foreach my $option ( @{ $Var{rhGetopt}{raOpts} } )
	{
		# Getopt option has = sign for mandatory options
		my $optName = undef;
		$optName = $1 if $option =~ m{\A (\w+)}xms;
		if ( $option =~ m{\A (\w+) .* =}xms
			|| ( $optName && grep { $ARG eq $optName } @{$raMandatory} ) )
		{
			my $error = 0;

			# Work out what type of parameter it might be
			my $type = "value";
			$type = 'number value'                 if $option =~ m{=f}xms;
			$type = 'integer value'                if $option =~ m{=i}xms;
			$type = 'incremental value'            if $option =~ m{\+}xms;
			$type = 'negatable value'              if $option =~ m{\!}xms;
			$type = 'decimal/oct/hex/binary value' if $option =~ m{=o}xms;
			$type = 'string value'                 if $option =~ m{=s}xms;
			$type =~ s{value}{multi-value}xms    if $option =~ m{\@}xms;
			$type =~ s{value}{key/value pair}xms if $option =~ m{\%}xms;

			if ( hasOpt($optName) )
			{
				my $opt = opt($optName);
				my $ref = ref($opt);
				if ( 'ARRAY' eq $ref && 0 == scalar(@$opt) )
				{
					$error = 1;

					# type might not be configured but we know it now
					$type =~ s{value}{multi-value}xms unless $type =~ m{multi-value}xms;
				}
				if ( 'HASH' eq $ref && 0 == scalar( keys(%$opt) ) )
				{
					$error = 1;

					# type might not be configured but we know it now
					$type =~ s{value}{key/value pair}xms unless $type =~ m{key/value}xms;
				}
			}
			else
			{
				$error = 1;
			}
			push( @$raErrors, "--$optName $type is a mandatory parameter." ) if $error;
		}
	}
	return $raErrors;
}

# Perform command line option processing and call main function.
sub getOptions
{
	$Var{rhGetopt}{roParser}->configure( @{ $Var{rhGetopt}{raConfig} } );
	$Var{rhGetopt}{result} = $Var{rhGetopt}{roParser}->getoptions( opt(), @{ $Var{rhGetopt}{raOpts} } );
	if ( $Var{rhGetopt}{result} )
	{
		manual() if opt('man');
		setArg( 'raFile', \@ARGV );

		checkOptions( $Var{rhGetopt}{raErrors}, arg('raFile') );
		setup();
		main( arg('raFile') );
	}
	else
	{
		# Here if unknown option provided
		usage();
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

sub error
{
	my ($warning) = @ARG;
	warn($warning . "\n");
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

##	print "debug @{[substr($msg,0,10)]} debug: @{[opt('debug')]} level: $level\n";
	print tab($msg) . "\n" if ( opt('debug') >= $level );
}

sub usage
{
	my ($msg) = @ARG;
	my %Opts = (
		-exitval => 1,
		-verbose => 1,
	);
	$Opts{-msg} = $msg if $msg;
	pod2usage(%Opts);
}

sub manual
{
	pod2usage(
		-exitval => 0,
		-verbose => 2,
	);
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
