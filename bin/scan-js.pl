#!/usr/bin/env perl

=head1 NAME

scan-js.pl - scan a javascript file and see if the functions are
arranged as suggested by Uncle Bob's Clean Code book.

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

scan-js.pl [options] [@options-file ...] [file ...]

 Options:
   --show-code      negatable. show the code after comment and string extraction
   --verbose        negatable. show more info about functions. default false
   --mess           negatable. show more info about functions. default true
   --summary        negatable. show summary of each file. default true
   --comment-char   use character to replace text in comment extraction
   --string-char    use character to replace text in string extraction
   --lint-length    allowed length of jshint control comments to ignore
   --version        display program version
   --help -?        brief help message
   --man            full help message
   --debug          incremental. increase the amount of debugging information shown

=head1 OPTIONS

=over 8

=item B<--show-code> or B<--noshow-code>

 negatable. default false. Print out the source code after comments and
 strings have been extracted.  This allow you to diagnose code which might be
 excessively tricky.

=item B<--verbose> or B<--noverbose>

 negatable. default false. Print out additional information instead of just
 mess warnings.

=item B<--mess> or B<--nomess>

 negatable. default true. Print out warnings about possible messy code.

=item B<--summary> or B<--nosummary>

 negatable. default true. Print out summary of each file.

=item B<--comment-char=s>

 optional. Defaults to '-'. Set the character to use to replace the text
 found in comments. Used with --show-code. If set to the empty string
 --comment-char='' then comments will not be stripped from the code.

=item B<--string-char=s>

 optional. Defaults to '_'. Set the character to use to replace the text
 found in strings. Used with --show-code. If set to the empty string
 --string-char='' then strings will not be stripped from the code.
 This is useful if functions are referred to by name in some strings.

=item B<--lint-length=n>

 optional. Defaults to 30. The maximum length of a jshint or jslint comment
 for it to not count against the amount of comments in the file. If there
 is only one such comment in the file it is also ignored.

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

=head1 GRUNT SETUP

In order to allow this script to use jshint to check how clean your code is you need a build target in your Gruntfile.js which enables jshint checking of a single file.

	jshint: {
		single: {
			// grunt jshint:single --check-file filename
			src: [grunt.option('check-file') || 'package.json']
		},
		...
	}

=head1 EXAMPLES

 scan-js.pl template/unminified/jquery-2.1.1.js

 scan-js.pl template/unminified/jquery-2.1.1.js 2>/dev/null | less

 scan-js.pl template/unminified/jquery-2.1.1.js --debug --debug --debug --debug 2>&1 | less

 FILES=`git diff --name-status $FROM $TO | perl -pne 's{\A [AM] \s+}{}xms'`; for file in $FILES; do scan-js.pl $file; done

=head1 TODO

 order output with public then private
 order output alphabetically
 order output in line order
 hide function listing unless warning
 keep track of number of params per function
 use jshint to measure complexity of functions
 closeness of definitions of function to first caller
 star rating of file based on maxcomplexity, maxparams, clean, test plan
 check if test plan exists for file
 jshint command fails, show how to set up grunt


Law of demeter violation checker
 perl -ne '$o = q{\w+ \s* \. \s*}; $m = q{\w+ \s* \s* (\([^\)]*\))? \s*}; print if ( m{ $o $m \. $m }xms );' demeter.js
what about array access this.something[fe].method();


=cut

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
use autodie qw(open);

our $VERSION = 0.1;       # shown by --version option
our $STDIO   = "";

# Big hash of vars and constants for the program
my %Var = (
	rhArg => {
		rhOpt => {
			$STDIO  => 0,    # indicates standard in/out as - on command line
			"show-code" => 0,
			"comment-char" => '-',
			"string-char" => '_',
			"lint-length" => 30,
			mess    => 1,
			verbose => 0,    # default value for verbose
			summary => 1,
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
			"show-code!",     # flag to print out code after comment and string extraction
			"verbose|v!",     # flag --verbose or --noverbose
			"mess|m!",        # flag --mess or --nomess
			"summary!",       # flag --summary or --nosummary
			"comment-char:s", # char to replace text in comments
			"string-char:s",  # char to replace text in strings
			"lint-length:n",
			"debug|d+",       # incremental keep specifying to increase
			$STDIO,           # empty string allows - to signify standard in/out as a file
			"man",            # show manual page only
		],
		raMandatory => [],    # additional mandatory parameters not defined by = above.
		roParser    => Getopt::Long::Parser->new,
	},
	entireFile => '',           # entire file contents for processing
	fileName   => '<STDIN>',    # name of file
	warnings => 0,              # number of mess warnings for file
	firstPrivateFunction => undef,
	lintComments => 0,
	comments => 0,
	strings => 0,
	code => 0,
	raFunctions => [],     # names of functions found
	rhFunctions => {},     # names of functions found with line number and callers
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

	if ( opt($STDIO) )
	{
		processEntireStdio();
	}
	processFiles( $raFiles ) if scalar(@$raFiles);
	summary();
}

sub summaryOfFile
{
	my $isClean = 1;
	debug("summaryOfFile() raFunctions:" . Dumper($Var{raFunctions}), 3);
	debug("summaryOfFile() rhFunctions:" . Dumper($Var{rhFunctions}), 4);
	foreach my $function (@{$Var{raFunctions}})
	{
		my $rhFunction = $Var{rhFunctions}{$function};
		my $definedAt = $rhFunction->{line};
		my $firstCallAt = $rhFunction->{callers}[0];
		if ($firstCallAt)
		{
			functionPrint($function, $definedAt, "called @{[scalar(@{$rhFunction->{callers}})]} time(s) first at $firstCallAt\n");
			functionWarning($function, $definedAt, "defined before first call at $firstCallAt") if $firstCallAt > $definedAt;
		}
	}
	$isClean = computeCleanness();
	if ($Var{warnings}) {
		summarize("$Var{warnings} MESS warnings.");
		$isClean = 0;
	}
	if ($isClean) {
		summarize("Clean code.");
	}
}

sub computeCleanness
{
	$Var{code} = length($Var{entireFile}) - $Var{comments} - $Var{strings};
	$Var{ratioComments} = $Var{comments} /  ($Var{code} || 0.5);
	summarize("code: $Var{code} comments: $Var{comments} strings: $Var{strings}");
	summarize(int(100 * (1-$Var{ratioComments})) . "% code");
	return $Var{ratioComments} < 1/40;
}

sub summary
{
	summarize("$lines_seen lines read");
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
	resetFileInfo("<STDIN>");
	my $rContent = read_file( \*STDIN, scalar_ref => 1 );

	$Var{entireFile} = $$rContent;
	analyseEntireFile();
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

	resetFileInfo($fileName);
	my $rContent = read_file( $fileName, scalar_ref => 1 );
	$Var{entireFile} = $$rContent;
	analyseEntireFile();
}

sub analyseEntireFile
{
	my $print = opt('show-code');
	debug("print: $print");
	pullOutComments();
	pullOutStrings();
	print $Var{entireFile} if $print;

	my @Lines = split("\n", $Var{entireFile});
	findFunctionDefinitions(\@Lines);
	findFunctionReferences(\@Lines);
	jshintFile();
	summaryOfFile();
}

sub resetFileInfo
{
	my ($fileName) = @ARG;
	print "\n$fileName\n";
	$Var{fileName} = $fileName;
	$Var{warnings} = 0;
	$Var{firstPrivateFunction} = undef;
	$Var{lintComments} = 0;
	$Var{comments} = 0;
	$Var{strings} = 0;
	$Var{code} = 0;
	$Var{raFunctions} = [];
	$Var{rhFunctions} = {};
}

sub pullOutComments
{
	$Var{entireFile} =~ s{/\* (.+?) \*/}{
		replaceComment("/*", $1, "*/");
	}xmsge;
	$Var{entireFile} =~ s{// (.+?) (\n|\z)}{
		replaceComment("//", $1, $2);
	}xmsge;
}

sub pullOutStrings
{
	$Var{entireFile} =~ s{ ([\"']) ( (?:\\\1|.)*? ) \1 }{
		replaceString($1, $2)
	}xmsge;
}

sub replaceComment
{
	my ($before, $comment, $after) = @ARG;
	trackComment($before, $comment, $after);
	$comment = blotOut($comment, opt('comment-char'));
	$comment = $before . $comment . $after;
	return $comment;
}

sub replaceString
{
	my ($quote, $string) = @ARG;
	$Var{strings} += 2 + length($string);
	$string = blotOut($string, opt('string-char'));
	$string = $quote . blotOut($string, opt('string-char')) . $quote;
	return $string;
}

# track comments except for jshint control comments unless they are big
sub trackComment
{
	my ($before, $comment, $after) = @ARG;
	my $track = 1;
	my $length = length($before . $comment . $after);
	if ($comment =~ m{\s* (js[hl]int|globals?|property|exported) \b }xms) {
		$track = 0 unless $Var{lintComments};
		$track = 0 if $length <= opt('lint-length');
		$Var{lintComments}++;
		debug("trackComment() track: $track length:$length lintcomments: $Var{lintComments} $comment", 3);
	}
	$Var{comments} += $length if $track;
}

sub blotOut
{
	my ($text, $char) = @ARG;
	if (length($char))
	{
		$char = substr($char, 0, 1);
		$text =~ s{[^\s]}{$char}xmsg;
	}
	return $text;
}

sub findFunctionDefinitions
{
	my ($raLines) = @ARG;
	for (my $idx = 0; $idx < scalar(@$raLines); ++$idx)
	{
		my $line = $raLines->[$idx] . "\n";
		debug("findFunctionDefinitions() $line", 4);
		doLine($line);
	}
}

sub findFunctionReferences
{
	my ($raLines) = @ARG;
	my $regex = join('|', @{$Var{raFunctions}});
	debug("findFunctionReferences() regex: $regex", 3);
	if (length($regex)) {
		for (my $idx = 0; $idx < scalar(@$raLines); ++$idx)
		{
			my $line = $raLines->[$idx] . "\n";
			debug("findFunctionReferences() $line", 4);
			$line =~ s{\b ($regex) \b}{
				registerCaller($1, $idx + 1);
			}xmsge;
		}
	}
	else
	{
		warning("no functions found.");
	}
}

sub jshintFile
{
	if (system("grunt jshint:single --check-file $Var{fileName} > jshint.out"))
	{
		#warning("error invoking grunt jshint:single on $Var{fileName}");
#		my $rContent = read_file( "jshint.out", scalar_ref => 1 );
#		$$rContent =~ s{\\A \\s* \\^}{}xms'
		my $jshintWarnings = `perl -ne 'print if s{\\A \\s* \\^}{}xms' jshint.out`;
		foreach my $warn (split(/\n/, $jshintWarnings))
		{
			warning("jshint $warn");
		}
	}
	else
	{
		print "jshint OK\n";
	}
}

sub doLine
{
	my ( $line, $print ) = @ARG;
	++$lines_seen;

	findFunctions($line);

	$print = 0;
  return ( $line, $print );
}

sub findFunctions
{
	my ($line) = @ARG;

	# something = function (
	#	something: function (
	#	function something(

	# method = function Named (
	# method = function (
	$line =~ s{(\w+) \s* = \s* \b function \b \w* \s* \(}{
		registerFunction({
			function => $1,
			access => getFunctionType($1),
			line => $lines_seen,
		});
		""
	}xmsge;

	# method : function Named (
	# method : function (
	# 'method' : function Named (
	# "method" : function (
	$line =~ s{(\w+) ['"]? \s* : \s* \b function \b \s* \w* \s* \(}{
		registerFunction({
			function => $1,
			access => getFunctionType($1),
			line => $lines_seen,
		});
		""
	}xmsge;

	# function Named (
	$line =~ s{function \b \s* (\w+) \s* \(}{
		debug("findFunctions match [$1]", 4);
		debug("findFunctions lines_seen [$lines_seen]", 4);
		registerFunction({
			function => $1,
			access => getFunctionType($1),
			line => $lines_seen,
		});
		""
	}xmsge;

	# function (  anonymous not handled
}

sub getFunctionType
{
	my ($name) = @ARG;
	return $name =~ m{ \A _ }xms ? 'private' : 'public';
}

sub registerFunction
{
	my ($rhFunction) = @ARG;

	my $function = $rhFunction->{function};
	if ($Var{rhFunctions}{$function})
	{
		warning("function $function defined again");
	}
	else
	{
		push(@{$Var{raFunctions}}, $function);
		$Var{rhFunctions}{$function} = $rhFunction;
		$rhFunction->{callers} = [];
		trackFirstPrivateFunction($rhFunction);
		warnIfPublicFunctionAfterPrivates($rhFunction);
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

sub trackFirstPrivateFunction
{
	my ($rhFunction) = @ARG;
	unless ($Var{firstPrivateFunction}) {
		$Var{firstPrivateFunction} = $rhFunction->{function}
			if $rhFunction->{access} eq 'private';
	}
}

sub warnIfPublicFunctionAfterPrivates
{
	my ($rhFunction) = @ARG;

	if ($Var{firstPrivateFunction}
		&& $rhFunction->{access} ne 'private') {
		functionWarning($rhFunction->{function}, $rhFunction->{line}, "$rhFunction->{access} function defined after first private function $Var{firstPrivateFunction}()");
	}
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

sub info
{
	print(@ARG) if opt('verbose');
}

sub summarize
{
	print(@ARG, "\n") if opt('summary');
}

sub functionPrint
{
	my ($function, $line, $message) = @ARG;
	info("$function() \@ $line $message");
}

sub functionWarning
{
	my ($function, $line, $warning) = @ARG;
	warning("$function() \@ $line $warning");
}

sub warning
{
	my ($warning) = @ARG;
	++$Var{warnings};
	warn( "MESSY: " . tab($warning) . "\n" ) if opt('mess');
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
