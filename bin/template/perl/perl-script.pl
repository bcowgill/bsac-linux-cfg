#!/usr/bin/env perl

# POD in 5 mins http://juerd.nl/site.plp/perlpodtut
# W I N D E V tool useful on windows development machin

=head1 NAME

perl-script.pl - TODO short usage - full fat perl script template using GetOpt::Long and Pod::Usage, slurp a stdin/files and process/replace, internal DATA, usage/warning/debug output, full arg handling, internal unit tests

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

perl-script.pl [options] [@options-file ...] [file ...]

TODO short description - full fat perl script template using GetOpt::Long and Pod::Usage, slurp a stdin/files and process/replace, internal DATA, usage/warning/debug output, full arg handling, internal unit tests

 Options:
   --version        display program version
   --help -?        brief help message
   --man            full help message

=head1 OPTIONS

=over 8

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION

 Template for a perl script with the usual bells and whistles.
 Supports long option parsing and perldoc perl-script.pl to show pod.

 B<This program> will read the given input file(s) and do something
 useful with the contents thereof. It does not modify the input files.

=head1 EXAMPLES

 template/perl/perl-script.pl --length=32 --file this.txt filename.inline --in - --out - --ratio=43.345 --debug --debug --debug --name=fred --name=barney --map key=value --map this=that -m short=value --hex=0x3c7e --width -- --also-a-file -

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

use FindBin;
#use Sys::Hostname;
use File::Spec;
#use File::Find ();
#use File::Copy qw(cp);    # copy and preserve source files permissions
use File::Slurp qw(:std);
use autodie qw(open); # mkdir rmdir unlink move opendir );
# https://www.perl.com/article/37/2013/8/18/Catch-and-Handle-Signals-in-Perl/
use sigtrap qw(handler signal_handler normal-signals);

our $VERSION = 0.1;       # shown by --version option

our $TESTING = 0;
our $TEST_CASES = 10;
our $SKIP = 0;

our $STDIO   = "";
my $PAD = 3;
my $signal_received = 0;

say("the directory of my script is: " . $FindBin::Bin . "\n");
say("the base name of my script is: " . $FindBin::Script . "\n");
if ($FindBin::Script eq '-e')
{
	print "this was invoked as: cd $FindBin::Bin ; perl -e";
}
else
{
	print "the canonical location of my script is: " . File::Spec->catfile($FindBin::Bin, $FindBin::Script) . "\n";
}

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			$STDIO  => 0,    # indicates standard in/out as - on command line
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
			"entire!",         # process entire file instead of reading line by line
			"length|l=i",      # numeric required --length or -l (explicit defined)
			"width:3",         # numeric optional with default value if none given on command line but not necessarily the default assigned if not present on command line
			"ratio|r:f",       # float optional
			"hex=o",           # extended integer a number in decimal, octal, hex or binary

			# cannot repeat when bundling is turned on
##			"point:f{2}",    # two floats separated by comma --point=1.3,24.5
			"file=s",        # string required --file or -f (implicit)
			"in:s",          # to test stdin=-
			"out:s",         # to test stdout=-
			"name|n=s@",     # multivalued array string
			"map|m=s%",      # multivalued hash key=value
			"debug|d+",      # incremental keep specifying to increase
			"verbose|v!",    # flag --verbose or --noverbose
			$STDIO,          # empty string allows - to signify standard in/out as a file
			"man",           # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	fileName   => '<STDIN>',    # name of file
	entireFile => '',           # entire file contents for processing
);

# prove command sets HARNESS_ACTIVE in ENV
tests() if ($ENV{HARNESS_ACTIVE} || scalar(@ARGV) && $ARGV[0] eq '--test');

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

while (my $line = <DATA>) {
	say("$line");
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

	if ( opt($STDIO) )
	{
		if ( opt('entire') )
		{
			processEntireStdio();
		}
		else
		{
			processStdio();
		}
	}
	processFiles( $raFiles ) if scalar(@$raFiles);
	summary();
} # main()

sub summary
{
	say("=====\n$lines_seen lines read\n");
}


sub signal_handler
{
	$signal_received = 1;
	# see auto-rename.pl for signal handling and locks()
	# remove_locks();
	die "\n$FindBin::Script terminated by signal";
} # signal_handler()

sub setup
{
	$OUTPUT_AUTOFLUSH = 1 if opt('debug');
	debug( "Var: " . Dumper( \%Var ), 2 );
	debug( "setup() rhOpt: " . Dumper( opt() ), 2 );
}

sub processStdio
{
	my $print = 0;
	debug("processStdio()\n");
	$Var{fileName} = "<STDIN>";
	while ( my $line = <STDIN> )
	{
		( $line, $print ) = doLine( $line, $print );
	}
}

sub processEntireStdio
{
	debug("processEntireStdio()\n");
	$Var{fileName} = "<STDIN>";
	my $rContent = read_file( \*STDIN, scalar_ref => 1 );

	$Var{entireFile} = $$rContent;
	doEntireLines();
}

sub processFiles
{
	my ($raFiles) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		if ( opt('entire') )
		{
			processEntireFile( $fileName );
		}
		else
		{
			processFile( $fileName );
		}
	}
}

sub processFile
{
	my ($fileName) = @ARG;
	debug("processFile($fileName)\n");

	# example read the file and show something line by line
	$Var{fileName} = $fileName;
	my $print = 0;
	my $fh;
	open( $fh, "<", $fileName );
	while ( my $line = <$fh> )
	{
		( $line, $print ) = doLine( $line, $print );
	}
	close($fh);
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
	debug("doLine: $line");
	++$lines_seen;
	my $regex = qr{\A}xms;
	$line =~ s{$regex}{length($line) . q{ }}xmse;
	$print = 1;
	print $line if $print;
	return ( $line, $print );
}

# Must manually check mandatory values present
sub checkOptions
{
	my ( $raErrors, $raFiles ) = @ARG;
	checkMandatoryOptions( $raErrors, $Var{rhGetopt}{raMandatory} );

	# Check additional parameter dependencies and push onto error array

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
} # checkMandatoryOptions()

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
} #getOptions()

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
}

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

##	print "debug @{[substr($msg,0,10)]} debug: @{[opt('debug')]} level: $level\n";
	if ( opt('debug') >= $level )
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
} # say()

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
