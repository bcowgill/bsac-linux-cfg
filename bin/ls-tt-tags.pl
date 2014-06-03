#!/usr/bin/env perl

=head1 NAME

ls-tt-tags.pl - List all Template::Toolkit processing tags in files

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

ls-tt-tags.pl [options] [@options-file ...] [file ...]

 Options:
   --inline-block   display multiline processing blocks in a single line of output.
   --echo-filename  display filename being processed.
   --version        display program version.
   --help -?        brief help message.
   --man            full help message.

=head1 OPTIONS

=over 8

=item B<--inline-block> or B<--noinline-block>

 negatable. Displays multiline processing blocks in a single line of output.

=item B<--echo-filename> or B<--noecho-filename>

 negatable. Prints name of file being processed.

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION

 B<This program> will read the given input file(s) and display Template::Toolkit processing instructions found within it.

=head1 EXAMPLES

 find all unique template toolkit blocks
 find . -name '*.tt' -exec ls-tt-tags.pl --inline-block {} \; | sort | uniq

 find template files and show markup with filename.
 find . -name '*.tt' -exec ls-tt-tags.pl --echo-filename {} \;

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
my %Var = (
	rhArg => {
		rhOpt => {
			'' => 0, # indicates standard in/out as - on command line
			'inline-block' => 0,
			'echo-filename' => 0,
			'debug' => 0,
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
			"inline-block!",
			"echo-filename!",
			'debug|d+',
			"",           # empty string allows - to signify standard in/out as a file
			"man",        # show manual page only
		],
		raMandatory => [], # additional mandatory parameters not defined by = above.
		roParser => Getopt::Long::Parser->new,
	},
	'indent' => ''
);

getOptions();

sub main
{
	my ($rhOpt, $raFiles, $use_stdio) = @ARG;
	debug("Var: " . Dumper(\%Var), 2);
	debug("main() rhOpt: " . Dumper($rhOpt) . "\nraFiles: " . Dumper($raFiles) . "\nuse_stdio: $use_stdio\n", 2);

	if ($use_stdio)
	{
		processStdio($rhOpt);
	}
	processFiles($raFiles, $rhOpt) if scalar(@$raFiles);
}

sub setup
{
	my ($rhOpt) = @ARG;
	debug("Var: " . Dumper(\%Var), 2);
	debug("setup() rhOpt: " . Dumper($rhOpt), 2);
	if ($rhOpt->{'echo-filename'})
	{
		$Var{'indent'} = "   ";
	}
}

sub processStdio
{
	my ($rhOpt) = @ARG;
	debug("processStdio()\n");
	my $rContent = read_file(\*STDIN, scalar_ref => 1);
	doReplacement($rContent);
}

sub processFiles
{
	my ($raFiles, $rhOpt) = @ARG;
	debug("processFiles()\n");
	foreach my $fileName (@$raFiles)
	{
		processFile($fileName, $rhOpt);
	}
}

sub processFile
{
	my ($fileName, $rhOpt) = @ARG;
	debug("processFile($fileName)\n");

	print "$fileName\n" if $rhOpt->{'echo-filename'};
	my $rContent = read_file($fileName, scalar_ref => 1);
	doReplacement($rContent);
}

sub doReplacement
{
	my ($rContent) = @ARG;
	# Template Toolkit markers look like so:
	# [% DIRECTIVE .... %]
	# [%# COMMENTED ... %]
	# can also just be $obj.prop.subprop ...
	# perhaps even $obj.$key ??
	# and ${obj.id}
	# but these can match some javascript so output not exact
	$$rContent =~ s{( \[ \% .+? \% \] | \$(\w|\.|\$|\{|\})+ )}{
		my $match = $1;
		$match =~ s{\s+}{ }xmsg if $Var{rhArg}{rhOpt}{'inline-block'};
		$match =~ s{\n}{\n$Var{'indent'}}xmsg;
		print "$Var{'indent'}$match\n";
		""
	}xmsge;
}

# Must manually check mandatory values present
sub checkOptions
{
	my ($raErrors, $rhOpt, $raFiles, $use_stdio) = @ARG;
	checkMandatoryOptions($raErrors, $rhOpt, $Var{rhGetopt}{raMandatory});

	# Check additional parameter dependencies and push onto error array
	if ($use_stdio && $rhOpt->{'echo-filename'})
	{
		push(@$raErrors, "--echo-filename option not allowed when processing standard input.");
	}
	if (scalar(@$raErrors))
	{
		usage(join("\n", @$raErrors));
	}
}

sub checkMandatoryOptions
{
	my ($raErrors, $rhOpt, $raMandatory) = @ARG;

	$raMandatory = $raMandatory || [];
	foreach my $option (@{$Var{rhGetopt}{raOpts}})
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

			if (exists($rhOpt->{$optName}))
			{
				my $ref = ref($rhOpt->{$optName});
				if ('ARRAY' eq $ref && 0 == scalar(@{$rhOpt->{$optName}}))
				{
					$error = 1;
					# type might not be configured but we know it now
					$type =~ s{value}{multi-value}xms unless $type =~ m{multi-value}xms;
				}
				if ('HASH' eq $ref && 0 == scalar(keys(%{$rhOpt->{$optName}})))
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
	$Var{rhGetopt}{roParser}->configure(@{$Var{rhGetopt}{raConfig}});
	$Var{rhGetopt}{result} = 	$Var{rhGetopt}{roParser}->getoptions(
		$Var{rhArg}{rhOpt},
		@{$Var{rhGetopt}{raOpts}}
	);
	if ($Var{rhGetopt}{result})
	{
		manual() if $Var{rhArg}{rhOpt}{man};
		$Var{rhArg}{raFile} = \@ARGV;
		# set stdio option if no file names provided
		$Var{rhArg}{rhOpt}{''} = 1 unless scalar(@{$Var{rhArg}{raFile}});
		checkOptions(
			$Var{rhGetopt}{raErrors},
			$Var{rhArg}{rhOpt},
			$Var{rhArg}{raFile},
			$Var{rhArg}{rhOpt}{''}
		);
		setup($Var{rhArg}{rhOpt});
		main($Var{rhArg}{rhOpt}, $Var{rhArg}{raFile}, $Var{rhArg}{rhOpt}{''});
	}
	else
	{
		# Here if unknown option provided
		usage();
	}
}

sub debug
{
	my ($msg, $level) = @ARG;
	$level ||= 1;
#	print "debug @{[substr($msg,0,10)]} debug: $Var{'rhArg'}{'rhOpt'}{'debug'} level: $level\n";
	print $msg if ($Var{'rhArg'}{'rhOpt'}{'debug'} >= $level);
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
