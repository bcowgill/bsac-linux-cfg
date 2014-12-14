#!/usr/bin/env perl

=head1 NAME

ls-tabs.pl - List tab and space inconsistencies in files

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

ls-tabs.pl [options] [@options-file ...] [file ...]

 Options:
   --spaces=N       optional. number of spaced per tab stop. default 4
   --version        display program version
   --help -?        brief help message
   --man            full help message

=head1 OPTIONS

=over 8

=item B<--spaces>

 optional. Set the number of spaces to use per tab stop.
 default 4

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION

 This program will read the given input file(s) and show you lines
 which have inconsistent tabs and spaces.

=head1 EXAMPLES

 ls-tabs.pl --spaces=3 hello.c

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
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;
$Data::Dumper::Terse = 1;

our $VERSION = 0.1; # shown by --version option

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			spaces => 4,  # default number of spaces per tab stop
			'' => 0,      # indicates standard in/out as - on command line
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
			"spaces|s:i", # option sets the number of spaces per tab
			"debug|d+",   # incremental keep specifying to increase
			"",           # empty string allows - to signify standard in/out as a file
			"man",        # show manual page only
		],
		raMandatory => [], # additional mandatory parameters not defined by = above.
		roParser => Getopt::Long::Parser->new,
	},

	prefix_tabs => 0,
	prefix_spaces => 0,
	uneven_spacing => 0,
	code => 0,
	lines_seen => 0,
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
	summary($rhOpt);
}

sub summary
{
	my ($rhOpt) = @ARG;
	print "=====\n$Var{'lines_seen'} lines read\n";
	print "$Var{'prefix_spaces'} lines with prefix spacing\n";
	print "$Var{'prefix_tabs'} lines with prefix tabs\n";
	if ($Var{'uneven_spacing'})
	{
		print "spacing which mismatches tab depth (spaces=$rhOpt->{spaces}) found.\n";
		$Var{'code'} = 2;
	}
	if ($Var{'prefix_tabs'} && $Var{'prefix_spaces'})
	{
		print "mixed tabs and spaces found.\n";
		$Var{'code'} = 1;
	}

	print "spacing ok for tab stop $rhOpt->{spaces}\n" if $Var{'code'} == 0;
	exit($Var{'code'});
}

sub setup
{
	my ($rhOpt) = @ARG;
	$OUTPUT_AUTOFLUSH = 1 if $rhOpt->{debug};
	debug("Var: " . Dumper(\%Var), 2);
	debug("setup() rhOpt: " . Dumper($rhOpt), 2);
}

sub processStdio
{
	my ($rhOpt) = @ARG;
	my $print = 0;
	debug("processStdio()\n");
	while (my $line = <STDIN>)
	{
		debug("line: $line");
		($line, $print) = doLine($rhOpt, $line, $print);
		print $line if $print;
	}
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

	my $print = 0;
	my $fh;
	open($fh, "<", $fileName);
	while (my $line = <$fh>)
	{
		($line, $print) = doLine($rhOpt, $line);
		print $line if $print;
	}
	close($fh);
}

sub show_line
{
	my ($line) = @ARG;
	$line =~ s{
		\A ([\ \t]+) (\n|\S|\z)
	}{
		mark_spacing($1) . $2;
	}xmsge;
	return "$Var{'lines_seen'} $line";
}

sub mark_spacing
{
	# mark spaces '.' tabs 'T' and a tab's worth of spaces as '|..|'
	my ($prefix) = @ARG;
	my $TAB_STOP = $Var{rhArg}{rhOpt}{spaces};
	$prefix =~ s{ \ {$TAB_STOP} }{ '|' . ('.' x ($TAB_STOP - 2)) . '|' }xmsge;
	$prefix =~ tr[ \t][.T];
	$Var{'uneven_spacing'}++ if ($prefix =~ m{\.}xms);
	return $prefix;
}

sub doLine
{
	my ($rhOpt, $line) = @ARG;

	++$Var{'lines_seen'};
	# ignore lines with no lead spacing
	my $print = 0;
	debug("$Var{'lines_seen'}: $line");
	return ($line, $print) if ($line =~ m{\A \S}xms);
	debug("past gate1, has some lead space");
	return ($line, $print) if ($line =~ m{\A (\n|\z)}xms);
	debug("past gate2, not an empty line");

	# ignore lines with tabs only, but count them
	if ($line =~ m{\A \t+ (\n|\S|\z)}xms)
	{
		$Var{'prefix_tabs'}++;
		return ($line, $print);
	}
	debug("past gate3, not lead tabs only");

	$Var{'prefix_spaces'}++;
	# handle lines with lead space only
	if ($line =~ m{\A \ + (\S|\z)}xms)
	{
		debug("lead space only");
		$line = show_line($line);
		$print = 1;
#		return ($line, $print) if $line =~ m{\A \ + (\n|\z)}xms;
	}
	else
	{
		debug("mixed spaces and tabs");
		# handle lines with mixed spaces and tabs
		$Var{'prefix_tabs'}++;
		$line = show_line($line);
		$print = 1;
	}
	return ($line, $print);
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
		# set stdio option if no file names provided
		$Var{rhArg}{rhOpt}{''} = 1 unless scalar(@{$Var{rhArg}{raFile}});
		checkOptions(
			$Var{rhGetopt}{raErrors},
			$Var{rhArg}{rhOpt},
			$Var{rhArg}{raFile},
			$Var{rhArg}{rhOpt}{''} ## use_stdio option
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

# make tabs 3 spaces
sub tab
{
	my ($message) = @ARG;
	$message =~ s{\t}{   }xmsg;
	return $message;
}

sub warning
{
	my ($warning) = @ARG;
	warn("WARN: " . tab($warning) . "\n");
}

sub debug
{
	my ($msg, $level) = @ARG;
	$level ||= 1;
#	print "debug @{[substr($msg,0,10)]} debug: $Var{'rhArg'}{'rhOpt'}{'debug'} level: $level\n";
	print tab($msg) . "\n" if ($Var{'rhArg'}{'rhOpt'}{'debug'} >= $level);
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

