#!/usr/bin/env perl

=head1 NAME

render-tt.pl - Render a Template::Toolkit template page using specific variables

=head1 AUTHOR

Brent S.A. Cowgill

=head1 LICENSE

Unlicense http://unlicense.org

=head1 SOURCE

https://github.com/bcowgill/bsac-linux-cfg/raw/master/bin/render-tt.pl

=head1 SYNOPSIS

render-tt.pl [options] [@options-file ...] [file ...]

 Options:
   --page-vars=file            set the page VARIABLEs by reading in a perl hash object from file.
   --page-consts=file          set the page CONSTANTs by reading in a perl hash object from file.
   --var=key=val               multiple. define a simple VARIABLE for the template
   --const=key=val             multiple. define a CONSTANT for the template
   --constants-namespace=name  set the CONSTANTS_NAMESPACE for the template
   --include-path              add a directory to the INCLUDE_PATH for Template::Toolkit
   --absolute                  turn on the ABSOLUTE option for Template::Toolkit
   --include-path              add a directory to the INCLUDE_PATH for Template::Toolkit
   --relative                  turn on the RELATIVE option for Template::Toolkit
   --anycase                   turn on the ANYCASE option for Template::Toolkit
   --interpolate               turn on the INTERPOLATE option for Template::Toolkit (default)
   --pre-chomp                 set the PRE_CHOMP option for Template::Toolkit (0 to 3 allowed)
   --post-chomp                set the POST_CHOMP option for Template::Toolkit (0 to 3 allowed)
   --version                   display program version
   --help -?                   brief help message
   --man                       full help message

=head1 OPTIONS

=over 8

=item B<--page-vars=file.vars> or B<--variables=file.vars> or B<--pre-define=file.vars>

 Specifies a file to read in to set all the template page VARIABLEs in one go. These can be overridden by individual --var settings later. The file read in should be the output of Data::Dumper.

=item B<--page-consts=file.vars> or B<--constants=file.vars>

 Specifies a file to read in to set all the template page CONSTANTs in one go. These can be overridden by individual --constant settings later. The file read in should be the output of Data::Dumper.

=item B<--var="key=value">

 Defines a simple page VARIABLE for use when doing template substitutions.
 You can specify this multiple times to define many VARIABLEs.
 Key can be this.that to define a hash object called this with a key of that.

=item B<--const="key=value">

 Defines a simple page CONSTANT for use when doing template substitutions.
 You can specify this multiple times to define many CONSTANTs.
 Key can be this.that to define a hash object called this with a key of that.

=item B<--constants-namespace="name">

 Sets the Template::Toolkit CONSTANTS_NAMESPACE. Default is 'constants'.

=item B<--include-path>

 Add a directory to the Template::Toolkit INCLUDE_PATH option so that processing of templates will look for any included templates there.

=item B<--absolute> or B<--noabsolute>

 Turns on the Template::Toolkit ABSOLUTE option so that processing of absolute path names is allowed.

=item B<--relative> or B<--norelative>

 Turns on the Template::Toolkit RELATIVE option so that processing of relative path names is allowed.

=item B<--anycase> or B<--noanycase>

 Turns on the Template::Toolkit ANYCASE option so that directive names are not case sensitive.

=item B<--interpolate> or B<--nointerpolate>

 Turns on the Template::Toolkit INTERPOLATE option so that direct substitution of $vars can happen. On by default.

=item B<--pre-chomp=N>

 Sets the Template::Toolkit PRE_CHOMP option to control how newlines and whitespace are chomped before a template marker.
 See L<http://tt2.org/docs/manual/Config.html#section_PRE_CHOMP_POST_CHOMP> for details.
 [%+ +%] disable chomp
 [%- -%] CHOMP_ONE = whitespace and one newline
 [%= =%] CHOMP_COLLAPSE = all whitespace and newlines
 [%~ ~%] CHOMP_GREEDY = all whitespace to a single space

 Examples:

 <span class="[% active -%] content">  removes spaces if active is empty otherwise lets space remain

=item B<--post-chomp=N>

 Sets the Template::Toolkit POST_CHOMP option to control how newlines and whitespace are chomped after a template marker.

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION

 B<render-tt.pl> will perform perl Template::Toolkit transformation of a template file using specific variables as inputs. It is useful for unit testing all possible outputs of a template page.

=head1 EXAMPLES

 render-tt.pl --var="this=that" < in/template.tt > out/template.html

=cut

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

use File::Slurp qw(:std);

use Template;

our $VERSION = 0.1;       # shown by --version option
our $STDIO   = "";

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			$STDIO  => 0,    # indicates standard in/out as - on command line
			var => {},
			'include-path' => ['.'],
			absolute => 0,
			relative => 0,
			'include-path' => ['.'],
			'constants-namespace' => 'constants',
			anycase => 0,
			interpolate => 1,
			'pre-chomp' => 0,
			'post-chomp' => 0,
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
			"include-path:s@",
			"absolute!",
			"include-path:s@",
			"relative!",
			"anycase!",
			"interpolate!",
			"pre-chomp:i",
			"post-chomp:i",
			"page-vars|variables|pre_define:s",
			"page-consts|constants:s",
			"var|variable:s%",     # multivalued hash key=value
			"const|constant:s%",   # multivalued hash key=value
			"constants-namespace:s",
			"debug|d+",      # incremental keep specifying to increase
			$STDIO,          # empty string allows - to signify standard in/out as a file
			"man",           # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	fileName   => '<STDIN>',    # name of file
	rhPageVar => {},
	rhPageConst => {},
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
		processEntireStdio();
	}
	processFiles( $raFiles ) if scalar(@$raFiles);
}

# Populate the rhPageVar/rhPageConst by slurping in a file with Data::Dumper output in it
sub loadPageParameters
{
	my ($fileName, $var, $option) = @ARG;

	if ($fileName)
	{
		my $rContent = read_file($fileName, scalar_ref => 1);
		$$rContent =~ s{\A \s* \$VAR1 \s* = \s* }{}xms;
		$$rContent = "\$Var{$var} = $$rContent;";
		eval $$rContent;
		die "Error loading --$option from $fileName: $EVAL_ERROR" if $EVAL_ERROR;
	}
}

# Populate the rhPageVar with the --var options (also rhPageConst)
sub defineValues
{
	my ($rhVar, $var) = @ARG;
	# a key of this.long.path will autovivify the intervening hashes
	foreach my $key (keys %$rhVar)
	{
		my @Chain = split(/\./, $key);
		my $rhScope = $Var{$var};
		while (scalar(@Chain))
		{
			my $thisKey = shift(@Chain);
			if (0 == scalar(@Chain))
			{
				# final key in the chain, set the value
				$rhScope->{$thisKey} = $rhVar->{$key};
			}
			else
			{
				$rhScope->{$thisKey} = $rhScope->{$thisKey} || {};
				$rhScope = $rhScope->{$thisKey};
			}
		}
	}
}

sub setup
{
	# Populate the rhPageVar by slurping in a file with Data::Dumper output in it
	loadPageParameters(opt('page-vars'), 'rhPageVar', 'page-vars');
	loadPageParameters(opt('page-consts'), 'rhPageConst', 'page-consts');

	# Populate the rhPageVar with the --var options
	defineValues(opt('var'), 'rhPageVar');
	defineValues(opt('const'), 'rhPageConst');
}

sub processEntireStdio
{
	debug("processEntireStdio()\n");
	$Var{fileName} = "<STDIN>";
	my $rContent = read_file( \*STDIN, scalar_ref => 1 );
	doReplacement( $rContent );
	print $$rContent;
}

sub processFiles
{
	my ($raFiles) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		processFile( $fileName );
	}
}

sub processFile
{
	my ($fileName) = @ARG;
	debug("processFile($fileName)\n");

	my $oTemplate = Template->new({
		INCLUDE_PATH => opt('include-path'),
		INTERPOLATE => opt('interpolate'),
		PRE_CHOMP => opt('pre-chomp'),
		POST_CHOMP => opt('post-chomp'),
		ABSOLUTE => opt('absolute'),
		RELATIVE => opt('relative'),
		ANYCASE => opt('anycase'),
		VARIABLES => $Var{rhPageVar},
		CONSTANTS => $Var{rhPageConst},
		CONSTANTS_NAMESPACE => opt('constants-namespace'),
	}) || die "$Template::ERROR\n";

	$oTemplate->process($fileName)
	|| die ($oTemplate->error() . "\n");
}

sub doReplacement
{
	my ( $rContent ) = @ARG;
	my $regex = qr{\A}xms;
	$$rContent =~ s{$regex}{splatted\n}xms;
	return $rContent;
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
