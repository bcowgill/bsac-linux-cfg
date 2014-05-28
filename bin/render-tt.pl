#!/usr/bin/env perl

=head1 NAME

render-tt.pl - Render a Template::Toolkit template page using specific variables

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

render-tt.pl [options] [@options-file ...] [file ...]

 Options:
   --page-vars=file    set the page variables by reading in a perl hash object from file.
   --var=key=val       multiple. define a simple variable for the template
   --version           display program version
   --help -?           brief help message
   --man               full help message

=head1 OPTIONS

=over 8

=item B<--page-vars=file.vars>

 Specifies a file to read in to set all the template page vars in one go. These can be overridden by individual --var settings later. The file read in should be the output of Data::Dumper.

=item B<--var="key=value">

 Defines a simple page variable for use when doing template substitutions.
 You can specify this multiple times to define many variables.
 Key can be this.that to define a hash object called this with a key of that.

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
use English -no_match_vars;
use Getopt::ArgvFile defult => 1; # allows specifying an @options file to read more command line arguments from
use Getopt::Long;
use Pod::Usage;
#use Getopt::Long::Descriptive; # https://github.com/rjbs/Getopt-Long-Descriptive/blob/master/lib/Getopt/Long/Descriptive.pm
#use Switch;
use Data::Dumper;

use File::Slurp qw(:std :edit);

use Template;

our $VERSION = 0.1; # shown by --version option

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			'' => 0, # indicates standard in/out as - on command line
			var => {},
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
			"page-vars:s",
			"var:s%",     # multivalued hash key=value
			"debug|d+",   # incremental keep specifying to increase
			"",           # empty string allows - to signify standard in/out as a file
			"man",        # show manual page only
		],
		raMandatory => [], # additional mandatory paramters not defined by = above.
		roParser => Getopt::Long::Parser->new,
	},
	rhPageVars => {},
);

getOptions();

sub main
{
	my ($rhOpt, $raFiles, $use_stdio) = @ARG;
	debug("Var: " . Dumper(\%Var), 2);
	debug("main() rhOpt: " . Dumper($rhOpt) . "\nraFiles: " . Dumper($raFiles) . "\nuse_stdio: $use_stdio\n", 2);

	$use_stdio = 1 unless scalar(@$raFiles);

	if ($use_stdio)
	{
		processStdio($rhOpt);
	}
	processFiles($raFiles, $rhOpt) if scalar(@$raFiles);
}

sub setup
{
	my ($rhOpt) = @ARG;

	# Populate the rhPageVars by slurping in a file with Data::Dumper output in it
	if ($rhOpt->{'page-vars'})
	{
		my $rContent = read_file($rhOpt->{'page-vars'}, scalar_ref => 1);
		$$rContent =~ s{\A \s* \$VAR1 \s* = \s* }{}xms;
		$$rContent = "\$Var{rhPageVars} = $$rContent;";
		eval $$rContent;
		die "Error loading --page-vars from $rhOpt->{'page-vars'}: $EVAL_ERROR" if $EVAL_ERROR;
	}

	# Populate the rhPageVars with the --var options
	# a key of this.long.path will autovivify the intervening hashes
	foreach my $key (keys %{$rhOpt->{'var'}})
	{
		my @Chain = split(/\./, $key);
		my $rhScope = $Var{rhPageVars};
		while (scalar(@Chain))
		{
			my $thisKey = shift(@Chain);
			if (0 == scalar(@Chain))
			{
				# final key in the chain, set the value
				$rhScope->{$thisKey} = $rhOpt->{'var'}{$key};
			}
			else
			{
				$rhScope->{$thisKey} = $rhScope->{$thisKey} || {};
				$rhScope = $rhScope->{$thisKey};
			}
		}
	}
}

sub processStdio
{
	my ($rhOpt) = @ARG;
	debug("processStdio()\n");
	my $rContent = read_file(\*STDIN, scalar_ref => 1);
	doReplacement($rContent);
	print $$rContent;
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

	my $oTemplate = Template->new({
		INCLUDE_PATH => '.',
		INTERPOLATE => 1,
	}) || die "$Template::ERROR\n";

	$oTemplate->process($fileName, $Var{rhPageVars})
	|| die ($oTemplate->error() . "\n");
}

sub doReplacement
{
	my ($rContent) = @ARG;
	my $regex = qr{\A}xms;
	$$rContent =~ s{$regex}{splatted\n}xms;
	return $rContent;
}

# Must manually check mandatory values present
sub checkOptions
{
	my ($raErrors, $rhOpt, $raFiles, $use_stdio) = @ARG;
	checkMandatoryOptions($raErrors, $rhOpt, $Var{rhGetopt}{raMandatory});

	# Check additional parameter dependencies and push onto error array

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
