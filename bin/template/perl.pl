#!/usr/bin/env perl

=head1 NAME

sample - Using GetOpt::Long and Pod::Usage

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

perl.pl [options] [file ...]

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
 Supports long option parsing and perldoc perl.pl to show pod.

 B<This program> will read the given input file(s) and do something
 useful with the contents thereof.

=head1 EXAMPLES

 template/perl.pl --length=32 --file this.txt filename.inline --in - --out - --ratio=43.345 --debug --debug --debug --name=fred --name=barney --map key=value --map this=that -m short=value --hex=0x3c7e --width -- --also-a-file -

=cut

use strict;
use warnings;
use English -no_match_vars;
use Getopt::Long;
use Getopt::ArgvFile; # TODO make use of this
use Pod::Usage;
#use Getopt::Long::Descriptive; # https://github.com/rjbs/Getopt-Long-Descriptive/blob/master/lib/Getopt/Long/Descriptive.pm
#use Switch;
use Data::Dumper;

our $VERSION = 0.1; # shown by --version option

# Big hash of vars and constants for the program
my %Vars = (
	rhArg => {
		rhOpt => {
			'' => 0, # indicates standard in/out as - on command line
			verbose => 1, # default value for verbose
			debug => 0,
			man => 0,     # show full help page
		},
		raFile => [],
	},
	rhGetopt => {
		result => undef,
		raErrors => [],
		raConfig => [
			"bundling",     # bundle single char options ie ps -aux
			"auto_version", # supplies --version option
			"auto_help",    # supplies --help -? options to show usage in POD SYNOPSIS
#			"debug",        # debug the argument processing
		],
		raOpts => [
			"length|l=i", # numeric required --length or -l (explicit defined)
			"width:3",    # numeric optional with default value if none given on command line but not necessarily the default assigned if not present on command line
			"ratio|r:f",  # float optional
			"hex=o",      # extended integer a number in decimal, octal, hex or binary
# cannot repeat when bundling is turned on
#		"point:f{2}", # two floats separated by comma --point=1.3,24.5
			"file=s",     # string required --file or -f (implicit)
			"in:s",       # to test stdin=-
			"out:s",      # to test stdout=-
			"name|n=s@",  # multivalued array string
			"map|m=s%",   # multivalued hash key=value
			"debug|d+",   # incremental keep specifying to increase
			"verbose|v!", # flag --verbose or --noverbose
			"",           # empty string allows - to signify standard in/out as a file
			"man",        # show manual page only
		],
		roParser => Getopt::Long::Parser->new,
	},
);

getOptions();

sub main
{
	my ($rhOpts, $raFiles, $use_stdio) = @ARG;
	print "Vars: " . Dumper \%Vars;
	print "main() rhOpts: " . Dumper($rhOpts) . "\nraFiles: " . Dumper($raFiles) . "\nuse_stdio: $use_stdio\b";
}

# Must manually check mandatory values present
sub checkOptions
{
	my ($raErrors, $rhOpts, $raFiles, $use_stdio) = @ARG;
	checkMandatoryOptions($raErrors, $rhOpts);
	if (scalar(@{$Vars{rhGetopt}{raErrors}}))
	{
		usage(join("\n", @{$Vars{rhGetopt}{raErrors}}));
	}
}

sub checkMandatoryOptions
{
	my ($raErrors, $rhOpts) = @ARG;

	foreach my $option (@{$Vars{rhGetopt}{raOpts}})
	{
		# Getopt option has = sign for mandatory options
		if ($option =~ m{\A (\w+) .* =}xms)
		{
			my $optName = $1;
			my $error = 0;
			my $type = "value";
			$type = 'number value' if $option =~ m{=f}xms;
			$type = 'integer value' if $option =~ m{=i}xms;
			$type = 'incremental value' if $option =~ m{\+}xms;
			$type = 'negatable value' if $option =~ m{\!}xms;
			$type = 'decimal/oct/hex/binary value' if $option =~ m{=o}xms;
			$type = 'string value' if $option =~ m{=s}xms;
			$type =~ s{value}{multi-value}xms if $option =~ m{\@}xms;
			$type =~ s{value}{key/value pair}xms if $option =~ m{\%}xms;
			if (exists($rhOpts->{$optName}))
			{
				my $ref = ref($rhOpts->{$optName});
				if ('ARRAY' eq $ref && 0 == scalar(@{$rhOpts->{$optName}}))
				{
					$error = 1;
					$type =~ s{value}{multi-value}xms unless $type =~ m{multi-value}xms;
				}
				if ('HASH' eq $ref && 0 == scalar(keys(%{$rhOpts->{$optName}})))
				{
					$error = 1;
					$type =~ s{value}{key/value pair}xms unless $type =~ m{key/value}xms;
				}
			}
			else
			{
				$error = 1;
			}
			push(@$raErrors, "--$optName $type is a mandatory parameter.") if $error;
		}
	}
	return $raErrors;
}

# Perform command line option processing and call main function.
sub getOptions
{
	$Vars{rhGetopt}{roParser}->configure(@{$Vars{rhGetopt}{raConfig}});
	$Vars{rhGetopt}{result} = 	$Vars{rhGetopt}{roParser}->getoptions(
		$Vars{rhArg}{rhOpt},
		@{$Vars{rhGetopt}{raOpts}}
	);
	if ($Vars{rhGetopt}{result})
	{
		manual() if $Vars{rhArg}{rhOpt}{man};
		$Vars{rhArg}{raFile} = \@ARGV;
		checkOptions(
			$Vars{rhGetopt}{raErrors},
			$Vars{rhArg}{rhOpt},
			$Vars{rhArg}{raFile},
			$Vars{rhArg}{rhOpt}{''}
		);
		main($Vars{rhArg}{rhOpt}, $Vars{rhArg}{raFile}, $Vars{rhArg}{rhOpt}{''});
	}
	else
	{
		# Here if unknown option provided
		usage();
	}
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
