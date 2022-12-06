#!/usr/bin/env perl
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

# POD in 5 mins http://juerd.nl/site.plp/perlpodtut

=head1 NAME

cp-random.pl - copy files at random from an input list to some destination

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

cp-random.pl [options] [@options-file ...] target-directory

copy files at random from an input list to some destination.

 Options:
   --number=N       optional number of files to copy
   --retries=N      optional additional copies to try after first failure
   --invert         optional. invert the output to show what was not copied
   --nospace        optional. create files with no spaces or special characters in them
   --notree         optional. create files in the target directory, do not reproduce the source tree
   --file-list=name optional. file containing list of files to choose from
   --version        display program version
   --help -?        brief help message
   --man            full help message

=head1 OPTIONS

=over 8

=item B<--number=N>

 optional. Specify a number of files to copy at random instead of filling up all disk space on the target-directory.

=item B<--retries=N>

 optional. default = 10. When a copy fails, indicating that the disk is full on the target-directory, additional random attempts are made in case smaller files could still fit.

=item B<--invert> or B<-v>

 Invert the printed output.  Normally the copied files are printed.  This causes the files that were in the list but not copied to be printed instead.

=item B<--space> or B<--nospace>

 optional. default is to allow.  Allow or prevent spaces and special characters in files and directories on the target device.

=item B<--tree> or B<--notree>

 optional. default is to tree.  Reproduce the source tree in the target directory or deposit all files directly in the target directory..

=item B<--file-list=FILENAME>

 optional. default is read from standard input.  This specifies the file name which contains the list of files to choose randomly from.

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION

This program can be used to make a random music play list or to copy a number of files at random to a destination.

It will copy files randomly to a target location preserving directory structure.

It will either copy a specific number of files or keep copying until there is no space left.

=head1 SEE ALSO

renumber-files.sh, renumber-by-time.sh, rename-files.sh, auto-rename.pl, choose.pl, reverse-order.sh, random-order.sh

=head1 EXAMPLES

 # copy random music files to a USB memory stick until it is full. Try to copy 30 additional random files when copies fail.
 find . -name *.mp3 | cp-random.pl --retries=30 /media/me/USB-2GB

=cut

{ use 5.006; }
use strict;
use warnings;

use English qw(-no_match_vars);
use Getopt::ArgvFile defult => 1;    # allows specifying an @options file to read more command line arguments from
use Getopt::Long;
use Pod::Usage;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

use File::Slurp qw(:std);
use File::Copy qw(cp);    # copy and preserve source files permissions
use File::Path qw(make_path);
use autodie qw(open cp);

our $VERSION = 0.1;       # shown by --version option
our $STDIO   = "";

use FindBin;
use File::Spec;

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			$STDIO  => 0,     # indicates standard in/out as - on command line
			'file-list' => '-', # list of files to choose from
			retries => 10,    # retries after disk full
			number  => 0,     # number of files to copy instead of size based
			invert  => 0,     # show copies, not those left behind
			space   => 1,     # allow spaces and special characters in filenames
			tree    => 1,     # allow subdirectories in target filenames
			verbose => 1,     # default value for verbose
			debug   => 0,
			man     => 0,     # show full help page
		},
		raFile => [],        # only one target directory allowed
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
			"invert|v!",       # invert output to show files not copied
			"space!",          # allow spaces and special characters in filenames
			"tree!",           # allow subdirectories in target filenames
			"retries|r:i",     # retries after disk full
			"number:i",        # number of files to copy instead of size based
			"file-list:s",     # list of files to choose from
			"debug|d+",        # incremental keep specifying to increase
			"verbose|v!",      # flag --verbose or --noverbose
			"man",             # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	fileName   => '<STDIN>',    # name of file
	entireFile => '',           # entire file contents for processing
	chooseFiles => [],          # list of files to choose from
	failedCopy => [],           # list of files which failed to copy
);

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
		"\nraFiles: " . Dumper($raFiles) .
		"\nuse_stdio: @{[opt($STDIO)]}\n", 2 );

	if ( opt('file-list') eq '-' )
	{
		processEntireStdio();
	}
	else
	{
		processFileList(opt('file-list'));
	}
	processFiles( $raFiles ) if scalar(@$raFiles);
	summary();
}

sub summary
{
	if ( opt('invert') )
	{
		print join("\n", @{$Var{chooseFiles}}, '');
		print join("\n", @{$Var{failedCopy}}, '');
	}
}

sub setup
{
	$OUTPUT_AUTOFLUSH = 1 if opt('debug');
	debug( "Var: " . Dumper( \%Var ), 2 );
	debug( "setup() rhOpt: " . Dumper( opt() ), 2 );
}

sub processEntireStdio
{
	debug("processEntireStdio()\n");
	$Var{fileName} = "<STDIN>";
	my $rContent = read_file( \*STDIN, scalar_ref => 1 );

	$Var{entireFile} = $$rContent;
	doEntireLines();
}

sub processFileList
{
	my ($fileName) = @ARG;
	debug("processFileList($fileName)\n");
	$Var{fileName} = $fileName;
	my $rContent = read_file( $fileName, scalar_ref => 1 );

	$Var{entireFile} = $$rContent;
	doEntireLines();
}

sub processFiles
{
	my ($raFiles) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		processTargetDirectory( $fileName );
	}
}

sub processTargetDirectory
{
	my ($targetDir) = @ARG;
	debug("processTargetDirectory($targetDir)\n");

	if (opt('number'))
	{
		chooseNFiles($targetDir, opt('number'));
	}
	else
	{
		chooseUntilFull($targetDir);
	}
}

sub chooseNFiles
{
	my ($targetDir, $number) = @ARG;
	debug("chooseNFiles($targetDir, $number)\n");
	while ($number && hasFilesToChoose())
	{
		my $rhChosen = chooseFile();
		last unless copyFile($targetDir, $rhChosen);
		--$number;
	}
}

sub chooseUntilFull
{
	my ($targetDir) = @ARG;
	my $retries = opt('retries');
	debug("chooseUntilFull($targetDir, $retries)\n");

	while ($retries && hasFilesToChoose())
	{
		my $rhChosen = chooseFile();
		unless (copyFile($targetDir, $rhChosen))
		{
			--$retries;
		}
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
	doEntireLines();
}

sub doEntireLines
{
	my @Lines = grep { m{\A\S}xms }
		map {
			my $new = $ARG;
			$new =~ s{\A\s*(.*?)\s*\z}{$1}xms;
			$new
		}
		split( "\n", $Var{entireFile} );
	debug("chooseFiles:\n@{[Dumper \@Lines]}", 3);
	$Var{chooseFiles} = \@Lines;
}

sub hasFilesToChoose
{
	my $number = scalar(@{$Var{chooseFiles}});
	debug("hasFilesToChoose: $number\n", 3);
	return $number;
}

sub chooseFile
{
	my $number = scalar(@{$Var{chooseFiles}});
	my $idx = int(rand($number));
	my $fileName = $Var{chooseFiles}[$idx];
	debug("chooseFile: $idx/$number, $fileName\n", 3);
	return {
	 number => $number,
	 index => $idx,
	 fileName => $fileName,
	};
}

sub copyFile
{
	my ($targetDir, $rhChosen) = @ARG;
	my $fileName = $rhChosen->{fileName};
	debug("copyFile($targetDir, $fileName)\n", 2);
	my $copied = 0;
	eval
	{
		my $targetFileName = targetFileName($targetDir, $fileName);
		createTargetDirForFile($targetFileName);
		copyTheFile($fileName, $targetFileName);
		print "$targetFileName\n" unless (opt('invert'));
		removeChosenFile($rhChosen->{index});
		$copied = 1;
	};
	if ($EVAL_ERROR)
	{
		print STDERR $EVAL_ERROR;
		recordErrorFile($fileName);
		removeChosenFile($rhChosen->{index});
	}
	return $copied;
}

sub removeChosenFile
{
	my ($idx) = @ARG;
	splice(@{$Var{chooseFiles}}, $idx, 1);
}

sub recordErrorFile
{
	my ($fileName) = @ARG;
	push(@{$Var{failedCopy}}, $fileName);
}

sub targetFileName
{
	my ($targetDir, $fileName) = @ARG;
	my $targetFileName;
	if (opt('tree'))
	{
		$targetFileName = File::Spec->catfile(fixPath($targetDir), fixPath($fileName));
	}
	else
	{
		$targetFileName = File::Spec->catfile(fixPath($targetDir), fixPath(fileNameOnly($fileName)));
	}
	debug("targetFileName($targetDir, $fileName): $targetFileName\n", 4);
	return $targetFileName;
}

sub fileNameOnly
{
	my ($path) = @ARG;
	my ($volume, $directories, $fileName) = File::Spec->splitpath( $path );
	return $fileName;
}

sub fixPath
{
	my ($path) = @ARG;
	my ($volume, $directories, $fileName) = File::Spec->splitpath( $path );
	$directories = File::Spec->catdir(map {
		unspace($ARG)
	} File::Spec->splitdir($directories));
	$fileName = unspace($fileName);
	$path = File::Spec->catpath($volume, $directories, $fileName);
	return $path;
}

sub unspace
{
	my ($path) = @ARG;
	unless (opt('spaces'))
	{
		$path =~ s{[\s:;\{\}\[\]\(\)<>,\?\@'"£\$\%\^&\*_\+=~\#`\|!]+}{-}xmsg;
		$path =~ s{--+}{-}xmsg;
		$path =~ s{-?\.-?}{.}xmsg;
		$path =~ s{\A-}{}xmsg;
		$path =~ s{-\z}{}xmsg;
	}
	return $path;
}

sub createTargetDirForFile
{
	my ($targetFileName) = @ARG;
	debug("createTargetDirForFile($targetFileName)\n", 4);
	my ($volume, $directories, $file) = File::Spec->splitpath( $targetFileName );
	$targetFileName = File::Spec->catpath($volume, $directories);
	debug("createTargetDirForFile: $targetFileName\n", 4);
	make_path($targetFileName);
}

sub copyTheFile
{
	my ($fileName, $targetFileName) = @ARG;
	debug("copyTheFile($fileName, $targetFileName)\n", 4);
	cp($fileName, $targetFileName);
}

# Must manually check mandatory values present
sub checkOptions
{
	my ( $raErrors, $raFiles ) = @ARG;
	checkMandatoryOptions( $raErrors, $Var{rhGetopt}{raMandatory} );

	# Check additional parameter dependencies and push onto error array
	if (scalar(@$raFiles) != 1) {
		push(@$raErrors, "You must provide a single target-directory.");
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

		# set stdio option if no file names provided
		setOpt( $STDIO, 1 ) unless scalar( @{ arg('raFile') } );
		checkOptions( $Var{rhGetopt}{raErrors}, arg('raFile') );
		setup();
		main( arg('raFile'), opt($STDIO) );
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

__END__
