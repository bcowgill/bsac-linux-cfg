#!/usr/bin/env perl

=head1 NAME

scan-js.pl - scan a javascript file and see if the functions are
arranged as suggested by Uncle Bob's Clean Code book.

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

scan-js.pl [options] [@options-file ...] [file ...]

 Options:
   --show-code      show the code after comment and string extraction
   --comment-char   use character to replace text in comment extraction
   --string-char    use character to replace text in string extraction
   --version        display program version
   --help -?        brief help message
   --man            full help message

=head1 OPTIONS

=over 8

=item B<--show-code> or B<--noshow-code>

 negatable. Print out the source code after comments and strings have been extracted.
 This allow you to diagnose code which might be excessively tricky.

=item B<--comment-char=s>

 optional. Defaults to '-'. Set the character to use to replace the text
 found in comments. Used with --show-code. If set to the empty string
 --comment-char='' then comments will not be stripped from the code.

=item B<--string-char=s>

 optional. Defaults to '_'. Set the character to use to replace the text
 found in strings. Used with --show-code. If set to the empty string
 --string-char='' then strings will not be stripped from the code.
 This is useful if functions are referred to by name in some strings.

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION

 B<This program> will read the given Javascript file(s) and examine
 whether the functions are ordered from high level to low level as
 suggested by Robert C. Martin's book Clean Code.

 This program is not a general purpose Javascript analysis tool. It
 assumes the code is pretty clean, not minified, etc. It will not look
 for obfuscated function definitions for example.

=head1 EXAMPLES

 scan-js.pl template/unminified/jquery-2.1.1.js

 scan-js.pl template/unminified/jquery-2.1.1.js 2>/dev/null | less

 scan-js.pl template/unminified/jquery-2.1.1.js --debug --debug --debug --debug 2>&1 | less


=cut

use strict;
use warnings;
use autodie qw(open);
use English -no_match_vars;
use Getopt::ArgvFile defult => 1; # allows specifying an @options file to read more command line arguments from
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent = 1;
$Data::Dumper::Terse = 1;

our $VERSION = 0.1; # shown by --version option
our $STDIO = "";

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			$STDIO => 0,      # indicates standard in/out as - on command line
			"show-code" => 0,
			"comment-char" => '-',
			"string-char" => '_',
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
			"show-code!",     # flag to print out code after comment and string extraction
			"comment-char:s", # char to replace text in comments
			"string-char:s",  # char to replace text in strings
			"debug|d+",   # incremental keep specifying to increase
			"verbose|v!", # flag --verbose or --noverbose
			$STDIO,       # empty string allows - to signify standard in/out as a file
			"man",        # show manual page only
		],
		raMandatory => [], # additional mandatory parameters not defined by = above.
		roParser => Getopt::Long::Parser->new,
	},
	raFunctions => [],    # names of functions found
	rhFunctions => {},    # names of functions found with line number and callers
	raLinesInFile => [],  # buffered lines for second pass
);

# Return the value of a command line option
sub opt
{
	my ($opt) = @ARG;
	return $Var{'rhArg'}{'rhOpt'}{$opt};
}

my $lines_seen = 0;
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
	secondPass($Var{raLinesInFile}, $rhOpt);
	summary($rhOpt);
}

sub summary
{
	my ($rhOpt) = @ARG;
	print "=====\n$lines_seen lines read\n";
	debug("summary() raFunctions:" . Dumper($Var{raFunctions}), 3);
	debug("summary() rhFunctions:" . Dumper($Var{rhFunctions}), 4);
	foreach my $function (@{$Var{raFunctions}})
	{
		my $rhFunction = $Var{rhFunctions}{$function};
		my $definedAt = $rhFunction->{line};
		my $firstCallAt = $rhFunction->{callers}[0];
		if ($firstCallAt)
		{
			print "$function() \@ $definedAt called @{[scalar(@{$rhFunction->{callers}})]} time(s) first at $firstCallAt\n";
			warning("$function() \@ $definedAt called before defined") if $firstCallAt < $definedAt;
		}
	}
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
		processEntireFile($fileName, $rhOpt);
	}
}

sub processFile
{
	my ($fileName, $rhOpt) = @ARG;
	debug("processFile($fileName)\n");

	# example read the file and show something line by line
	my $print = 0;
	my $fh;
	open($fh, "<", $fileName);
	while (my $line = <$fh>)
	{
		($line, $print) = doLine($rhOpt, $line, $print);
		print $line if $print;
	}
	close($fh);
}

sub processEntireFile
{
	my ($fileName, $rhOpt) = @ARG;
	debug("processFile($fileName)\n");

	# example read the entire file and show something line by line
	my $print = $rhOpt->{'show-code'};
	my $fh;
	local $INPUT_RECORD_SEPARATOR = undef;
	open($fh, "<", $fileName);
	my $file = <$fh>;
	$Var{entireFile} = $file;
	$lines_seen += getLinesInFile($file);
	pullOutComments() if opt('comment-char');
	pullOutStrings() if opt('string-char');
	print $Var{entireFile} if $print;
	close($fh);
}

sub pullOutComments
{
	$Var{entireFile} =~ s{/\* (.+?) \*/}{
		"/*" . blotOut($1, opt('comment-char')) . "*/"
	}xmsge;
	$Var{entireFile} =~ s{// (.+?) (\n|\z)}{
		"//" . blotOut($1, opt('comment-char')) . $2
	}xmsge;
}

sub pullOutStrings
{
	$Var{entireFile} =~ s{" ((?:[^"]|\\")*) "}{
		'"' . blotOut($1, opt('string-char')) . '"'
	}xmsge;
	$Var{entireFile} =~ s{' ((?:[^']|\\')*) '}{
		"'" . blotOut($1, opt('string-char')) . "'"
	}xmsge;
}

sub blotOut
{
	my ($text, $char) = @ARG;
	$char = substr($char, 0, 1);
	$text =~ s{[^\s]}{$char}xmsg;
	return $text;
}

sub getLinesInFile
{
	my ($file) = @ARG;
	my $lines = 0;

	if (length($file))
	{
		if ($file =~ m{\n}xms)
		{
			$lines += $file =~ tr[\n][\n];
			if ($file =~ m{\n [^\n]+ \z}xms)
			{
				++$lines;
			}
		}
		else
		{
			++$lines;
		}
	}
	return $lines;
}

sub secondPass
{
	my ($raLines, $rhOpt) = @ARG;
	my $regex = join('|', @{$Var{raFunctions}});
	debug("secondPass() regex: $regex", 3);

	for (my $idx = 0; $idx < scalar(@$raLines); ++$idx)
	{
		my $line = $raLines->[$idx];
		debug("secondPass() $line", 4);
		$line =~ s{($regex)}{
			registerCaller($1, $idx + 1);
		}xmsge;
	}

}

sub doLine
{
	my ($rhOpt, $line, $print) = @ARG;
	++$lines_seen;

	push(@{$Var{raLinesInFile}}, $line);
	findFunction($line);

	$print = 0;
	return ($line, $print);
}

sub findFunction
{
	my ($line) = @ARG;

	# something = function (
	#	something: function (
	#	function something(

	$line =~ s{(\w+) \s* [=:] \s* function \s* \(}{
		registerFunction($1, $lines_seen)
	}xmsge;
	$line =~ s{function \s+ (\w+) \s* \(}{
		registerFunction($1, $lines_seen)
	}xmsge;
}

sub registerFunction
{
	my ($function, $line) = @ARG;

	if ($Var{rhFunctions}{$function})
	{
		warning("function $function defined again");
	}
	else
	{
		push(@{$Var{raFunctions}}, $function);
		$Var{rhFunctions}{$function} = {
			line => $line,
			callers => [],
		}
	}
}

sub registerCaller
{
	my ($function, $line) = @ARG;
	debug("registerCaller() function: $function", 4);
	if ($line != $Var{rhFunctions}{$function}{line})
	{
		push(@{$Var{rhFunctions}{$function}{callers}}, $line);
	}
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
		manual() if opt('man');
		$Var{rhArg}{raFile} = \@ARGV;
		# set stdio option if no file names provided
		$Var{rhArg}{rhOpt}{$STDIO} = 1 unless scalar(@{$Var{rhArg}{raFile}});
		checkOptions(
			$Var{rhGetopt}{raErrors},
			$Var{rhArg}{rhOpt},
			$Var{rhArg}{raFile},
			$Var{rhArg}{rhOpt}{$STDIO} ## use_stdio option
		);
		setup($Var{rhArg}{rhOpt});
		main($Var{rhArg}{rhOpt}, $Var{rhArg}{raFile}, opt($STDIO));
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
#	print "debug @{[substr($msg,0,10)]} debug: @{[opt('debug')]} level: $level\n";
	print tab($msg) . "\n" if (opt('debug') >= $level);
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
