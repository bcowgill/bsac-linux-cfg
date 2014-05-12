#!/usr/bin/env perl

# POD in 5 mins http://juerd.nl/site.plp/perlpodtut

=head1 NAME

sample - Using GetOpt::Long and Pod::Usage

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

perl.pl [options] [@options-file ...] [file ...]

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
use Getopt::ArgvFile defult => 1; # allows specifying an @options file to read more command line arguments from
use Getopt::Long;
use Pod::Usage;
#use Getopt::Long::Descriptive; # https://github.com/rjbs/Getopt-Long-Descriptive/blob/master/lib/Getopt/Long/Descriptive.pm
#use Switch;
use Data::Dumper;

use File::Copy qw(cp); # copy and preserve source files permissions
use File::Slurp qw(:std :edit);
use Fatal qw(cp);

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
			"splat:s",    # a file to edit in place
			"in:s",       # to test stdin=-
			"out:s",      # to test stdout=-
			"name|n=s@",  # multivalued array string
			"map|m=s%",   # multivalued hash key=value
			"debug|d+",   # incremental keep specifying to increase
			"verbose|v!", # flag --verbose or --noverbose
			"",           # empty string allows - to signify standard in/out as a file
			"man",        # show manual page only
		],
		raMandatory => [], # additional mandatory paramters not defined by = above.
		roParser => Getopt::Long::Parser->new,
	},
);

getOptions();

sub main
{
	my ($rhOpts, $raFiles, $use_stdio) = @ARG;
	print "Vars: " . Dumper \%Vars;
	print "main() rhOpts: " . Dumper($rhOpts) . "\nraFiles: " . Dumper($raFiles) . "\nuse_stdio: $use_stdio\n";

	if ($use_stdio)
	{
		processStdio($rhOpts);
	}
	processFiles($raFiles, $rhOpts);

	# Example in-place editing of file
	if (exists $rhOpts->{splat})
	{
		editFileInPlace($rhOpts->{splat}, ".bak", $rhOpts);
	}
}

sub processStdio
{
	my ($rhOpts) = @ARG;
	print "processStdio()\n";
	my $rContent = read_file(\*STDIN, scalar_ref => 1);
	doReplacement($rContent);
	print $$rContent;
}

sub processFiles
{
	my ($raFiles, $rhOpts) = @ARG;
	print "processFiles()\n";
	foreach my $fileName (@$raFiles)
	{
		processFile($fileName, $rhOpts);
	}
}

sub processFile
{
	my ($fileName, $rhOpts) = @ARG;
	print "processFile($fileName)\n";

	# example slurp in the file and show something
	my $rContent = read_file($fileName, scalar_ref => 1);
	print "length: " . length($$rContent) . "\n";
	doReplacement($rContent);
	print $$rContent;
}

sub doReplacement
{
	my ($rContent) = @ARG;
	my $regex = qr{\A}xms;
	$$rContent =~ s{$regex}{splatted\n}xms;
	return $rContent;
}

sub editFileInPlace
{
	my ($fileName, $suffix, $rhOpts) = @ARG;
	my $fileNameBackup = "$fileName$suffix";
	print "editFileInPlace($fileName) backup to $fileNameBackup\n";

	cp($fileName, $fileNameBackup);
	edit_file { doReplacement(\$ARG) } $fileName;
}

# Must manually check mandatory values present
sub checkOptions
{
	my ($raErrors, $rhOpts, $raFiles, $use_stdio) = @ARG;
	checkMandatoryOptions($raErrors, $rhOpts, $Vars{rhGetopt}{raMandatory});

	# Check additional parameter dependencies and push onto error array

	if (scalar(@$raErrors))
	{
		usage(join("\n", @$raErrors));
	}
}

sub checkMandatoryOptions
{
	my ($raErrors, $rhOpts, $raMandatory) = @ARG;

	$raMandatory = $raMandatory || [];
	foreach my $option (@{$Vars{rhGetopt}{raOpts}})
	{
		# Getopt option has = sign for mandatory options
		my $optName = undef;
		$optName = $1 if $option =~ m{\A (\w+)}xms;
		if ($option =~ m{\A (\w+) .* =}xms
			|| ($optName && grep { $ARG eq $optName } @{$raMandatory}))
		{
			my $error = 0;

			# Work out what type of parameter it might be
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
					# type might not be configured but we know it now
					$type =~ s{value}{multi-value}xms unless $type =~ m{multi-value}xms;
				}
				if ('HASH' eq $ref && 0 == scalar(keys(%{$rhOpts->{$optName}})))
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
