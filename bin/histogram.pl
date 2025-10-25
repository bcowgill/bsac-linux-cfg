#!/usr/bin/env perl

# POD in 5 mins http://juerd.nl/site.plp/perlpodtut
# WINDEV tool useful on windows development machine

=head1 NAME

histogram.pl - examine the distribution of words used in any number of files.

=head1 AUTHOR

Brent S.A. Cowgill

=head1 SYNOPSIS

histogram.pl [options] [@options-file ...] [file ...]

This program will examine the files provided and display histograms of word usage for each or for the combined batch of files.  The meaning of a word can be controlled by command line options. By default all punctuation is stripped, words are converted to lower case and the histogram of all files provided is output.

 Options:
   --line           histogram by line, without outer spacing.
   --sentence       histogram by sentence, terminated by ! ? . forces --entire option.
   --letter         histogram by letters and numbers.
   --char           histogram by any non-space character.
   --lower          convert to lower case characters.
   --upper          convert to upper case characters.
   --fold           fold case to compare identical letter forms that don't transform to upper/lower case the same.
   --number         replace number symbols with their values.
   --strip-apos     strip out apostrophe characters.
   --strip-hyphen   strip out hyphen characters to make a combined word.
   --split-dash     replace dash or hyphen with space to split word.
   --keep-punct     keep punctuation as is when connected to words.
   --utf=type       show invisible characters as unicode code points for given language. (code, wrap, name, etc)
   --all            read all files and output one histogram, instead of showing one for each file read.
   --percent        show percentage for each word instead of counts of each.
   --digits=N       show number of decimal digits for percentages. default 2
   --alpha          sort the results alphabetically instead of my number.
   --reverse        reverse the normal sorting order (ascending number or reversed for alphabetical.)
   --list           just list the words without their count values.
   --bar            show results as a bar chart.
   --entire         process the entire file instead of reading line by line.
   --version        display program version
   --help -?        brief help message
   --man            full help message

=head1 OPTIONS

=over 8

=item B<--line>

 Histogram by each line, stripping leading and trailing spaces.

=item B<--sentence>

 Histogram by sentence, terminated by . ! ?. Multiple line sentences are joined into a single line of text terminated by one or more terminators.

=item B<--letter>

 Histogram by letters and numbers, includes hyphens, apostrophe, comma, decimal point and currency symbols.

=item B<--char>

 Histogram by any non-space character.


=item B<--lower>

 Convert to lower case characters before doing the histogram analysis.

=item B<--upper>

 Convert to upper case characters before doing the histogram analysis.

=item B<--fold>

 Fold the case of characters before doing the histogram analysis.  This allows proper comparison of letters with different forms like Sigma in Greek, whcih do not convert to upper and lower case the same way.

 Forms Σσς  Greek capital, lower, final
 upper ΣΣΣ
 lower σσς
 fold  σσσ

 This also folds all apostrophe characters in words to the unicode MODIFIER LETTER APOSTROPHE. All forms of hypen or dash is folded into the unicode HTPHEN. All forms of quotation marks are folded into the unicode LEFT/RIGHT SINGLE QUOTATION MARK.  All forms of brackets are folded into simple parenthesis.

=item B<--number>

  Replace characters and symbols which are numerically based, with their corresponding values (and units if relevant)

=item B<--strip-apos>

  Strip out various apostrophe characters before doing the histogram analysis.

=item B<--strip-hyphen>

 Strip out hyphen characters to make a combined word before doing the histogram analysis.

=item B<--split-dash>

 Replace dash or hyphen with space to split the word so that both halves are counted in the histogram analysis.

=item B<--keep-punct>

 Keep punctuation as is when connected to words.  Normally, apostrophe's will fold into the unicode MODIFIER LETTER APOSTROPHE. And other punctuation like comma, full-stop, quote marks will be removed so the histogram is only considering words.  This option will preserve all adjacent punctuation and non-letter characters attached to words.

=item B<--utf=format>

 Show invisible characters as unicode code points in a given format.

 code       U+HHHH      normal unicode code point format.
 wrap       {U+HHHH}    wrapped in curly parenthesis so the character is separated from trailing characters that are also hexadecimal digits.
 name       NAME        uppercase name of the character like LINE FEED.
 html       &#xHHHH;    formatted so it is usable in an html file. can also use xml
 javascript \u{HHHH}    formatted so it is usable inside of a javascript string literal. can also use js, typescript
 perl       \N{U+HHHH}  formatted so it is usable inside a perl string literal.
 perlname   \N{NAME}    formatted so it is usable inside a perl string literal as the unicode character name instead of code point.
 java       \uHHHH      formatted so it is usable inside a java string literal.
 python                 same as java, usable in a python script string literal.
 debug      \N{NAME}[C] for debugging, shows perlname format as well as the literal character between square brackets.

=item B<--all>

  Show a single histogram for all files read, instead of one for each file.  This is the default when reading from standard input.

=item B<--percent>

  Show histogram values by percentage of occurrence instead of plain counts of each word.

=item B<--digits=N>

  Defaults to two decimal place digits to show for percentage values.

=item B<--alpha>

  Sort the histogram results alphabetically instead of by percentage or count value.

=item B<--reverse>

  Reverse the normal sorting order for the historgram. Uses ascending order for percentage or count values and reverse alphabetical order for --alpha option.

=item B<--list>

  Instead of a histogram, just list the words without their percentage or count value.

=item B<--bar>

  Show results as a bar chart instead of just numberd lines.

=item B<--entire>

  Read in the entire file instead of reading line by line.

=item B<--version>

 Prints the program version and exit.

=item B<--help> or B<-?>

 Print a brief help message and exit.

=item B<--man>

 Print the full help message and exit.

=back

=head1 DESCRIPTION


 B<This program> will examine standard input, or the files provided and display histograms of word usage for each or for the combined batch of files.  The meaning of a word can be controlled by command line options. By default all punctuation is stripped, words are converted to lower case and the histogram of all files provided is output.
MUSTDO

=head1 EXAMPLES

MUSTDO
 template/perl/perl-script.pl --length=32 --file this.txt filename.inline --in - --out - --ratio=43.345 --debug --debug --debug --name=fred --name=barney --map key=value --map this=that -m short=value --hex=0x3c7e --width -- --also-a-file -

=cut

use utf8;
use locale;
use v5.16;
use strict;
use warnings;
use open qw(:std :utf8); # undeclared streams in UTF-8
use feature "fc"; # fc() function is from v5.16
use Unicode::UCD qw( charinfo general_categories );  # to get category of character -- for charnames

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
our $TEST_CASES = 4;
our $SKIP = 0;

our $STDIO   = "";
my $PAD = 3;
my $signal_received = 0;

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
			"sentence!",       # histogram based on each sentence with newlines removed.
			"line!",           # histogram based on entire line content minus outer spacing
			"letter",          # histogram based on letters and numbers (currency)
			"char",            # histogram based on every character
			"upper",           # convert to upper case
			"lower",           # convert to lower case
			"fold",            # convert to unicode's folded case
			"number",          # convert numeric symbols to their associated value and units.
			"strip-apos",      # strip out apostrophe's.
			"strip-hyphen",    # strip out hyphens but not dashes.
			"split-dash",      # replace hyphen and dash with space.
			"keep-punct",      # keep punctuation as is when connected to words.
			"utf:s",           # show unicode code points as code,wrap,javascript,java,python etc
			"all",             # read all files and output one histogram, instead of showing one for each file read.
			"percent",         # show percentage for each word instead of counts of each.
			"digits:i",        # number of decimal place digits to show for percentage values.
			"alpha",           # sort the results alphabetically instead of my number.
			"reverse",         # reverse the normal sorting order (ascending number or reversed for alphabetical.)
			"list",            # just list the words without their count values.
			"bar",             # show histogram as a bar chart instead of numbers
# MUSTDO remove
#			"length|l=i",      # numeric required --length or -l (explicit defined)
#			"width:3",         # numeric optional with default value if none given on command line but not necessarily the default assigned if not present on command line
#			"ratio|r:f",       # float optional
#			"hex=o",           # extended integer a number in decimal, octal, hex or binary

			# cannot repeat when bundling is turned on
##			"point:f{2}",    # two floats separated by comma --point=1.3,24.5
#			"file=s",        # string required --file or -f (implicit)
#			"in:s",          # to test stdin=-
#			"out:s",         # to test stdout=-
#			"name|n=s@",     # multivalued array string
#			"map|m=s%",      # multivalued hash key=value
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

# Populate numeric values from __DATA__
my $NUMVAL = '';
my %Numbers = ();
my %NumValue = ();

# Break/no-break indicator charaters for words and between words
my $BR = qq[\N{U+82}\N{U+83}\N{U+2011}\N{U+feff}]; # word break/no-break indicator characters
my $NOBR = qq[\N{U+a0}\N{U+202f}]; # inter-word no-break indicator characters

# Unicode space separator class plus zero to full width invisible characters
my $BRK = '\s\p{Separator}\p{Control}\N{U+e0020}\N{U+feff}\N{U+303f}\N{U+200b}\N{U+1361}\N{U+8}'; # TAG SPACE,ZERO WIDTH NO-BREAK SPACE,IDEOGRAPHIC HALF FILL SPACE,ZERO WIDTH SPACE,ETHIOPIC WORDSPACE,BACKSPACE

# Unicode currency or number with thousands separator and decimal point
my $NUM = '\p{Currency_Symbol}\p{Number},.\N{U+ff0c}\N{U+ff0e}';

# Apostrophes and hypens/dashes
my $APOS = qq['\N{U+2bc}\N{U+2ee}\N{U+55a}\N{U+7f4}\N{U+7f5}\N{U+ff07}];
my $APOS_CH = qq[\N{U+2bc}]; # MODIFIER LETTER APOSTROPHE
my $HYPHEN = '-\N{U+58a}\N{U+1400}\N{U+1806}\N{U+2010}\N{U+2011}\N{U+2e17}\N{U+2e1a}\N{U+30a0}\N{U+fe63}\N{U+ff0d}'; # not \p{Dash_Punctuation}
my $HYPHEN_CH = qq[\N{U+2010}]; # HYPHEN
my $DASH = '\N{U+5be}\N{U+2012}\N{U+2013}\N{U+2014}\N{U+2015}\N{U+2053}\N{U+2e3a}\N{U+2e3b}\N{U+301c}\N{U+3030}\N{U+fe31}\N{U+fe32}\N{U+fe58}';
my $DASH_CH = qq[\N{U+2013}]; # EN DASH

# Unicode word with dash or apostrophe or non-break space
my $LTR = '\p{Letter}';
my $WRD = $HYPHEN . $APOS . $LTR;

# Grammar punctuation
my $COMMA = qq[,\N{U+55d}\N{U+60c}\N{U+7f8}\N{U+1363}\N{U+1802}\N{U+1808}\N{U+2e32}\N{U+2e34}\N{U+3001}\N{U+a4fe}\N{U+a60d}\N{U+a6f5}\N{U+fe10}\N{U+fe11}\N{U+fe50}\N{U+fe51}\N{U+ff0c}\N{U+ff64}]; # COMMA
my $COMMA_CH = ',';

my $SMCOL = qq[;\N{U+61b}\N{U+1364}\N{U+204f}\N{U+2e35}\N{U+a6f6}\N{U+fe14}\N{U+fe54}\N{U+ff1b}]; # SEMICOLON
my $SMCOL_CH = ';';

my $COLON = qq[:\N{U+703}\N{U+704}\N{U+705}\N{U+706}\N{U+707}\N{U+708}\N{U+709}\N{U+1365}\N{U+1366}\N{U+1804}\N{U+205d}\N{U+a6f4}\N{U+fe13}\N{U+fe55}\N{U+fe1a}\N{U+12471}\N{U+12472}\N{U+12473}]; # COLON
my $COLON_CH = ':';

my $FS = qq[\N{U+2e}\N{U+589}\N{U+6d4}\N{U+701}\N{U+702}\N{U+1362}\N{U+166e}\N{U+1803}\N{U+1809}\N{U+2cf9}\N{U+2cfe}\N{U+3002}\N{U+a4ff}\N{U+a60e}\N{U+a6f3}\N{U+fe12}\N{U+fe52}\N{U+ff0e}\N{U+ff61}]; # FULL STOP
my $FS_CH = '.';

my $EXCL = qq[!\N{U+a1}\N{U+55c}\N{U+7f9}\N{U+1944}\N{U+fe15}\N{U+fe57}\N{U+ff01}]; # EXCLAMATION
my $EXCL_CH = '!';

my $QUES = qq[\\?\N{U+5f}\N{U+37e}\N{U+55e}\N{U+61f}\N{U+1367}\N{U+1945}\N{U+2cfa}\N{U+2cfb}\N{U+2e2e}\N{U+a60f}\N{U+a6f7}\N{U+fe16}\N{U+fe56}\N{U+ff1f}\N{U+11143}]; # QUESTION MARK
my $QUES_CH = '?';

# Symbols
my $AMP = qq[&\N{U+fe60}\N{U+ff06}];
my $AMP_CH = '&';
my $ASTER = qq[\\*\N{U+204e}\N{U+2051}\N{U+a673}\N{U+fe61}\N{U+ff0a}]; # ASTERISK
my $ASTER_CH = '*';
my $AT = qq[@\N{U+fe6b}\N{U+ff20}]; # AT SIGN
my $AT_CH = '@';
my $NUMSN = qq[#\N{U+fe5f}\N{U+ff03}]; # NUMBER SIGN
my $NUMSN_CH = '#';
my $PCT = qq[%\N{U+66a}\N{U+fe6a}\N{U+ff05}]; # PERCENT
my $PCT_CH = '%';

my $SOL = qq[/\N{U+ff0f}]; # SOLIDUS
my $SOL_CH = '/';
my $RSOL = qq[\\\N{U+fe68}\N{U+ff3c}]; # REVERSE SOLIDUS
my $RSOL_CH = '\\';

my $total_count = 0;
my %Words = ();

# prove command sets HARNESS_ACTIVE in ENV
unless ($ENV{NO_UNIT_TESTS}) {
	tests() if ($ENV{HARNESS_ACTIVE} || scalar(@ARGV) && $ARGV[0] eq '--test');
}
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
	#say(Dumper(\%Words));
	show_histogram() if opt('all');
}

sub show_histogram
{
	# MUSTDO sort by order found in document??
	my @Ordered = sort { sort_word($a, $b) } keys(%Words);
	say(join("\n", map { show_word($ARG, $Words{$ARG}) } @Ordered));
}

sub sort_word
{
	my $cmp;
	if (opt('alpha'))
	{
		$cmp = $a cmp $b || $Words{$b} <=> $Words{$a};
	}
	else
	{
		$cmp = $Words{$b} <=> $Words{$a} || $a cmp $b;
	}
	return opt('reverse') ? -$cmp : $cmp;
}

sub show_word
{
	my ($word, $value) = @ARG;
	my $output = '';

	if (opt('list'))
	{
		$output = $word,
	} elsif (opt('percent'))
	{
		my $digits = opt('digits') || 2;
		my $places = int('1' . ('0' x $digits));
		$output = (int(($value * $places) / $total_count) / $places) . "% $word";
	}
	else
	{
		$output = "$value $word";
	}
	return $output;
}

sub clear_histogram
{
	$total_count = 0;
	%Words = ();
}

sub setup
{
	$OUTPUT_AUTOFLUSH = 1 if opt('debug');
	debug( "Var: " . Dumper( \%Var ), 2 );
	debug( "setup() rhOpt: " . Dumper( opt() ), 2 );
	if (opt('sentence'))
	{
		setOpt('entire', 1);
	}

	while (my $data = <DATA>)
	{
		chomp($data);
		my ($value, $char) = split('#', $data);
		if ($char)
		{
			my $uchar = toUTF8($char);
			$NumValue{$uchar} = $value;
			$Numbers{$value} .= $uchar;
			$NUMVAL .= $uchar;
		}
	}
	$NUMVAL = qr{[$NUMVAL]}xms;
	foreach my $value (keys(%Numbers))
	{
		my $re = $Numbers{$value};
		$Numbers{$value} = qr{[$re]}xms;
	}
#	print "NUMVAL: $NUMVAL\n";
#	print Dumper(\%Numbers);
#	print Dumper(\%NumValue);
}

sub processStdio
{
	my $print = 0;
	debug("processStdio()\n");
	$Var{fileName} = "<STDIN>";
	setOpt('all', 1);
	while ( my $line = <STDIN> )
	{
		( $line, $print ) = doLine( $line, $print );
	}
}

sub processEntireStdio
{
	debug("processEntireStdio()\n");
	$Var{fileName} = "<STDIN>";
	setOpt('all', 1);
	my $rContent = read_file( \*STDIN, scalar_ref => 1 );

	$Var{entireFile} = $$rContent;
	processEntire();
}

sub processEntire
{
	if (opt('sentence')) {
		$Var{entireFile} = fold_stops($Var{entireFile});
	}
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
		unless (opt('all'))
		{
			say("\n=== " . banner($fileName));
			show_histogram();
			clear_histogram();
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
	processEntire();
}

sub doEntireLines
{
	my $line;
	my $print = 0;
	#print "$Var{fileName}\n";
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
	debug("doLine $line");
	++$lines_seen;

	my $raWords = splitWords($line);
	foreach my $word (@$raWords)
	{
		if (opt('char'))
		{
			$word = toCodePoint($word, opt('utf') || 'code') if $word =~ m{[$BRK]}xms;
		} elsif (opt('utf')) {
			$word =~ s{(.)}{toUtf($1)}xmsge;
		}
		$Words{$word}++;
		$total_count++;
	}
	return ( $line, $print );
}

# Split line into 'word' chunks which may be sentences, lines, words or characters
sub splitWords
{
	my ($line) = @ARG;
   # https://www.regular-expressions.info/unicodecategory.html

   my $chars = opt('char') || opt('letter');
	my $strip = !opt('char') && !opt('letter');
	my $linewise = opt('line') || opt('sentence');

   # strip leading / trailing spaces \p{Separator} \p{Space_Separator}
	$line =~ s{\A[$BRK]*(.*?)[$BRK]*\z}{$1}xms if $strip;
	$line = fix_breaks($line) if $strip;

	# strip non-letter/numbers for letter mode
	$line =~ s{[^$WRD$NUM]+}{\ }xmsg if opt('letter');

	# MUSTDO match on all Letters or dashes or apostrophes  \p{Letter}

	$line = strip_apos($line) if opt('strip-apos');
	$line = fold_apos($line) unless opt('keep-punct');
	$line = split_dash($line) if opt('split-dash');
	$line = strip_hyphen($line) if opt('strip-hyphen');

	$line = fold_numbers($line) if opt('number');

	# Case conversions now
	$line = uc($line) if opt('upper');
	$line = lc($line) if opt('lower');
	$line = fold($line) if opt('fold');

	# Splitting into smaller chunks now
	my $split = $chars ? '' : qr/[$BRK]+/xms;

	my @Words = $linewise ? ($line) : split($split, $line);
	return \@Words;
}

sub fix_breaks
{
	my ($line) = @ARG;
	$line =~ s{[$BR]+}{}xmsg;
	$line =~ s{[$NOBR]+}{ }xmsg;
	return $line;
}

# MUSTDO Fold unicode letters and singular punctuation characters (apostrophe, hyphen, etc) into a canonical character.
sub fold
{
	my ($line) = @ARG;
   # MUSTDO identify quoted and bracketed spans of text and canonise them.
	$line = fc($line);
   # match all non-letters in the string and fold them.
	$line =~ s{(\P{Letter})}{foldChar($1)}xmsge;
	return $line;
}

sub foldChar
{
   my ($char) = @ARG;
   # MUSTDO quotation chars
	$char = fold_apos($char);
	$char = fold_hyphen($char);
	$char = fold_dash($char);
	$char = fold_punct($char);
   return $char;
}

# Fold numbers and number like (1) circles etc, fractions into their numerical value equivalents.
sub fold_numbers
{
	my ($char) = @ARG;
	#print "FOLD: [$char] ==@{[$char =~ m{($NUMVAL)}xms]}\n";
	$char =~ s{($NUMVAL)}{replace_value($1)}xmsge;

	#print "FOLD2: [$char]\n\n";
	return $char;
}

# Replace a number like character with its numerical value.
sub replace_value
{
	my ($char) = @ARG;
	#print "MATCH: [$char] :$NumValue{$char}:\n";
	return $NumValue{$char};
}

sub fold_stops
{
	my ($char) = @ARG;
	$char =~ s{\n}{ }xmsg;
	$char =~ s{[$FS]}{$FS_CH}xmsg;
	$char =~ s{[$EXCL]}{$EXCL_CH}xmsg;
	$char =~ s{[$QUES]}{$QUES_CH}xmsg;
	$char =~ s{([$FS_CH$EXCL_CH$QUES_CH]+)}{$1\n}xmsg;
	return $char;
}

sub fold_punct
{
	my ($char) = @ARG;
	$char =~ s{[$AMP]}{$AMP_CH}xmsg;
	$char =~ s{[$ASTER]}{$ASTER_CH}xmsg;
	$char =~ s{[$AT]}{$AT_CH}xmsg;
	$char =~ s{[$NUMSN]}{$NUMSN_CH}xmsg;
	$char =~ s{[$PCT]}{$PCT_CH}xmsg;
	$char =~ s{[$COMMA]}{$COMMA_CH}xmsg;
	$char =~ s{[$SMCOL]}{$SMCOL_CH}xmsg;
	$char =~ s{[$COLON]}{$COLON_CH}xmsg;
	$char =~ s{[$FS]}{$FS_CH}xmsg;
	$char =~ s{[$EXCL]}{$EXCL_CH}xmsg;
	$char =~ s{[$QUES]}{$QUES_CH}xmsg;
	$char =~ s{[$SOL]}{$SOL_CH}xmsg;
	$char =~ s{[$RSOL]}{$RSOL_CH}xmsg;

	$char =~ s{\N{U+203c}}{!!}xmsg;
	$char =~ s{\N{U+2048}}{?!}xmsg;
	$char =~ s{\N{U+2049}}{!?}xmsg;

	return $char;
}

sub strip_apos
{
	my ($line) = @ARG;
	$line =~ s{[$APOS]+}{}xmsg;
	return $line;
}

sub fold_apos
{
	my ($line) = @ARG;
	$line =~ s{[$APOS]}{$APOS_CH}xmsg;
	return $line;
}

sub split_dash
{
	my ($line) = @ARG;
	$line =~ s{[$HYPHEN$DASH]+}{ }xmsg;
	return $line;
}

sub strip_hyphen
{
	my ($line) = @ARG;
	$line =~ s{[$HYPHEN]+}{}xmsg;
	return $line;
}

sub fold_hyphen
{
	my ($line) = @ARG;
	$line =~ s{[$HYPHEN]}{$HYPHEN_CH}xmsg;
	return $line;
}

sub fold_dash
{
	my ($line) = @ARG;
	$line =~ s{[$DASH]}{$DASH_CH}xmsg;
	return $line;
}

# Shows a character as a UTF8 code point value
sub toUtf
{
	my ($char, $mode) = @ARG;
	if ($char ne ' ' && $char ne $APOS_CH && $char ne $HYPHEN_CH && $char ne $DASH_CH && $char =~ m{[$BRK]}xms)
	{
		return toCodePoint($char, $mode)
	}
   return $char;
}

# Converts U+HHHH string or \N{...} string to the unicode character
sub toUTF8
{
        my ($string) = @ARG;
        my $ret = $string;
        if ($string =~ m{ \A U \+ [0-9a-f]+ \z }xmsi)
        {
                $ret = charnames::string_vianame(uc($string));
        }
        elsif ($string =~ m{ \A \\N \{ ([^\}]+) \} \z }xmsi)
        {
                my $name = uc($1);
                my $loose_name = $name;
                $loose_name =~ s{[\s_-]}{_}xmsg;
                $ret = charnames::string_vianame($name)
                        || charnames::string_vianame($loose_name)
                        || die "Unknown character \\N{$name}";

        }
        return $ret;
}


# mode code, wrap, name, js, javascript, typescript, java, python, perl, perlname, debug
sub toCodePoint
{
	my ($char, $mode) = @ARG;
   my $val = unpack("W", $char);
	$mode = $mode || opt('utf') || 'wrap';

   if ($mode =~ m{\A(js|javascript|typescript)\z}xms)
	{
		return lc(sprintf("\\u{%04X}", $val));   ## \u{....}
	}
	elsif ($mode =~ m{\A(java|python)\z}xms)
	{
		return lc(sprintf("\\u%04X", $val));   ## \u....
	}
	elsif ($mode =~ m{\A(ht|x)ml\z}xms)
	{
		return lc(sprintf("&#x%04X;", $val));  ## &#x....
	}
   elsif ($mode eq 'perl')
	{
		return "\\N{U+" . lc(sprintf("%04X}", $val));   ## \N{U+....}
	}
   elsif ($mode eq 'name')
	{
		my $name =  toName($char);
		$name =~ s[\\N\{(.+?)\}][$1]xmsg;
		return $name;
	}
   elsif ($mode eq 'perlname')
	{
		return toName($char);
	}
   elsif ($mode eq 'debug')
	{
		return toName($char) . "[$char]";
	}
   elsif ($mode eq 'wrap')
	{
		return sprintf("{U+%04X}", $val);   ## {U+....}
	}
   # code or any other format
   return sprintf("U+%04X", $val);   ## U+....
}

sub toName
{
   my $val = unpack("W", $ARG[0]);
   my $named = charnames::viacode($val) || "UN-NAMED[@{[toCodePoint($ARG[0])]}]";
   return "\\N{$named}";
}

# Must manually check mandatory values present
sub checkOptions
{
	my ( $raErrors, $raFiles ) = @ARG;
	checkMandatoryOptions( $raErrors, $Var{rhGetopt}{raMandatory} );

	# Check additional parameter dependencies and push onto error array
	if (opt('digits') && opt('digits') < 0)
	{
		push( @$raErrors, "--digits=N number of decimal digits cannot be less than one." );
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

sub banner
{
	my ($message, $width, $min) = @ARG;
	$width = $width || (76 - length("===  "));
   $min = 3;

	if (length($message) + $min <= $width)
	{
		$min = $width - length($message) - 1;
	}
	$message .= ' ' . ('=' x $min);
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

	#test_say("Hello, there", "Hello, there") unless $SKIP;
	#test_tab("         Hello", "\t\t\tHello") unless $SKIP;
	#test_warning("WARN: WARNING, OH MY!\n", "WARNING, OH MY!") unless $SKIP;
	#test_debug(undef, "DEBUG, OH MY!", 10000) unless $SKIP;
	#test_debug("DEBUG, OH MY!\n", "DEBUG, OH MY!", -10000) unless $SKIP;
	#1test_failure("ERROR: FAILURE, OH MY!\n", "FAILURE, OH MY!") unless $SKIP;
	test_pad("000", "") unless $SKIP;
	test_pad("001", "1") unless $SKIP;
	test_pad("123", "123") unless $SKIP;
	test_pad("1234", "1234") unless $SKIP;
	exit 0;
}

__END__
__DATA__
0#\N{U+1018A}
0#\N{U+1040}
0#\N{U+104A0}
0#\N{U+1090}
0#\N{U+11066}
0#\N{U+110F0}
0#\N{U+11136}
0#\N{U+111D0}
0#\N{U+116C0}
0#\N{U+17E0}
0#\N{U+1810}
0#\N{U+1946}
0#\N{U+19D0}
0#\N{U+1A80}
0#\N{U+1A90}
0#\N{U+1B50}
0#\N{U+1BB0}
0#\N{U+1C40}
0#\N{U+1C50}
0#\N{U+1D7CE}
0#\N{U+1D7D8}
0#\N{U+1D7E2}
0#\N{U+1D7EC}
0#\N{U+1D7F6}
0. #\N{U+1F100}
0, #\N{U+1F101}
(0) #\N{U+24EA}
(0) #\N{U+24FF}
0#\N{U+3007}
0#\N{U+660}
0#\N{U+6F0}
0#\N{U+7C0}
0#\N{U+966}
0#\N{U+9E6}
0#\N{U+A620}
0#\N{U+A66}
0#\N{U+A8D0}
0#\N{U+A900}
0#\N{U+A9D0}
0#\N{U+AA50}
0#\N{U+ABF0}
0#\N{U+AE6}
0#\N{U+B66}
0#\N{U+BE6}
0#\N{U+C66}
0#\N{U+CE6}
0#\N{U+D66}
0#\N{U+E50}
0#\N{U+ED0}
0#\N{U+F20}
0#\N{U+FF10}
(10) #\N{U+2469}
(10) #\N{U+247D}
(10) #\N{U+24FE}
(10) #\N{U+277F}
(10) #\N{U+2789}
(10) #\N{U+2793}
(10) #\N{U+3229}
(10) #\N{U+3248}
(10) #\N{U+3289}
(11) #\N{U+246A}
(11) #\N{U+247E}
(11) #\N{U+24EB}
(12) #\N{U+246B}
(12) #\N{U+247F}
(12) #\N{U+24EC}
(13) #\N{U+246C}
(13) #\N{U+2480}
(13) #\N{U+24ED}
(14) #\N{U+246D}
(14) #\N{U+2481}
(14) #\N{U+24EE}
(15) #\N{U+246E}
(15) #\N{U+2482}
(15) #\N{U+24EF}
(16) #\N{U+246F}
(16) #\N{U+2483}
(16) #\N{U+24F0}
(17) #\N{U+2470}
(17) #\N{U+2484}
(17) #\N{U+24F1}
(18) #\N{U+2471}
(18) #\N{U+2485}
(18) #\N{U+24F2}
(19) #\N{U+2472}
(19) #\N{U+2486}
(19) #\N{U+24F3}
(1) #\N{U+2460}
(1) #\N{U+2474}
(1) #\N{U+24F5}
(1) #\N{U+2776}
(1) #\N{U+2780}
(1) #\N{U+278A}
(1) #\N{U+3220}
(1) #\N{U+3280}
(20) #\N{U+2473}
(20) #\N{U+2487}
(20) #\N{U+24F4}
(20) #\N{U+3249}
(21) #\N{U+3251}
(22) #\N{U+3252}
(23) #\N{U+3253}
(24) #\N{U+3254}
(25) #\N{U+3255}
(26) #\N{U+3256}
(27) #\N{U+3257}
(28) #\N{U+3258}
(29) #\N{U+3259}
(2) #\N{U+2461}
(2) #\N{U+2475}
(2) #\N{U+24F6}
(2) #\N{U+2777}
(2) #\N{U+2781}
(2) #\N{U+278B}
(2) #\N{U+3221}
(2) #\N{U+3281}
(30) #\N{U+324A}
(30) #\N{U+325A}
(31) #\N{U+325B}
(32) #\N{U+325C}
(33) #\N{U+325D}
(34) #\N{U+325E}
(35) #\N{U+325F}
(36) #\N{U+32B1}
(37) #\N{U+32B2}
(38) #\N{U+32B3}
(39) #\N{U+32B4}
(3) #\N{U+2462}
(3) #\N{U+2476}
(3) #\N{U+24F7}
(3) #\N{U+2778}
(3) #\N{U+2782}
(3) #\N{U+278C}
(3) #\N{U+3222}
(3) #\N{U+3282}
(40) #\N{U+324B}
(40) #\N{U+32B5}
(41) #\N{U+32B6}
(42) #\N{U+32B7}
(43) #\N{U+32B8}
(44) #\N{U+32B9}
(45) #\N{U+32BA}
(46) #\N{U+32BB}
(47) #\N{U+32BC}
(48) #\N{U+32BD}
(49) #\N{U+32BE}
(4) #\N{U+2463}
(4) #\N{U+2477}
(4) #\N{U+24F8}
(4) #\N{U+2779}
(4) #\N{U+2783}
(4) #\N{U+278D}
(4) #\N{U+3223}
(4) #\N{U+3283}
(50) #\N{U+324C}
(50) #\N{U+32BF}
(5) #\N{U+2464}
(5) #\N{U+2478}
(5) #\N{U+24F9}
(5) #\N{U+277A}
(5) #\N{U+2784}
(5) #\N{U+278E}
(5) #\N{U+3224}
(5) #\N{U+3284}
(60) #\N{U+324D}
(6) #\N{U+2465}
(6) #\N{U+2479}
(6) #\N{U+24FA}
(6) #\N{U+277B}
(6) #\N{U+2785}
(6) #\N{U+278F}
(6) #\N{U+3225}
(6) #\N{U+3285}
(70) #\N{U+324E}
(7) #\N{U+2466}
(7) #\N{U+247A}
(7) #\N{U+24FB}
(7) #\N{U+277C}
(7) #\N{U+2786}
(7) #\N{U+2790}
(7) #\N{U+3226}
(7) #\N{U+3286}
(80) #\N{U+324F}
(8) #\N{U+2467}
(8) #\N{U+247B}
(8) #\N{U+24FC}
(8) #\N{U+277D}
(8) #\N{U+2787}
(8) #\N{U+2791}
(8) #\N{U+3227}
(8) #\N{U+3287}
(9) #\N{U+2468}
(9) #\N{U+247C}
(9) #\N{U+24FD}
(9) #\N{U+277E}
(9) #\N{U+2788}
(9) #\N{U+2792}
(9) #\N{U+3228}
(9) #\N{U+3288}
1 drachma #\N{U+10142}
1#\N{U+10107}
1#\N{U+10159}
1#\N{U+1015A}
1#\N{U+10320}
1#\N{U+103D1}
1#\N{U+1041}
1#\N{U+104A1}
1#\N{U+10858}
1#\N{U+1091}
1#\N{U+10916}
1#\N{U+10A40}
1#\N{U+10A7D}
1#\N{U+10B58}
1#\N{U+10B78}
1#\N{U+10E60}
1#\N{U+11052}
1#\N{U+11067}
1#\N{U+110F1}
1#\N{U+11137}
1#\N{U+111D1}
1#\N{U+116C1}
1#\N{U+12415}
1#\N{U+1241E}
1#\N{U+1242C}
1#\N{U+12434}
1#\N{U+1244F}
1#\N{U+12458}
1#\N{U+1369}
1#\N{U+17E1}
1#\N{U+17F0}
1#\N{U+1811}
1#\N{U+1947}
1#\N{U+19D1}
1#\N{U+19DA}
1#\N{U+1A81}
1#\N{U+1A91}
1#\N{U+1B51}
1#\N{U+1BB1}
1#\N{U+1C41}
1#\N{U+1C51}
1#\N{U+1D360}
1#\N{U+1D369}
1#\N{U+1D7CF}
1#\N{U+1D7D9}
1#\N{U+1D7E3}
1#\N{U+1D7ED}
1#\N{U+1D7F7}
1, #\N{U+1F102}
1#\N{U+2160}
1#\N{U+2170}
1. #\N{U+2488}
1#\N{U+3021}
1#\N{U+31}
1#\N{U+3192}
1#\N{U+661}
1#\N{U+6F1}
1#\N{U+7C1}
1#\N{U+967}
1#\N{U+9E7}
1#\N{U+A621}
1#\N{U+A67}
1#\N{U+A6E6}
1#\N{U+A8D1}
1#\N{U+A901}
1#\N{U+A9D1}
1#\N{U+AA51}
1#\N{U+ABF1}
1#\N{U+AE7}
1#\N{U+B67}
1#\N{U+BE7}
1#\N{U+C67}
1#\N{U+CE7}
1#\N{U+D67}
1#\N{U+E51}
1#\N{U+ED1}
1#\N{U+F21}
1#\N{U+FF11}
2 drachmas #\N{U+1015D}
2 drachmas #\N{U+1015E}
2#\N{U+10108}
2#\N{U+1015B}
2#\N{U+1015C}
2#\N{U+103D2}
2#\N{U+1042}
2#\N{U+104A2}
2#\N{U+10859}
2#\N{U+1091A}
2#\N{U+1092}
2#\N{U+10A41}
2#\N{U+10B59}
2#\N{U+10B79}
2#\N{U+10E61}
2#\N{U+11053}
2#\N{U+11068}
2#\N{U+110F2}
2#\N{U+11138}
2#\N{U+111D2}
2#\N{U+116C2}
2#\N{U+12400}
2#\N{U+12416}
2#\N{U+1241F}
2#\N{U+12423}
2#\N{U+1242D}
2#\N{U+12435}
2#\N{U+1244A}
2#\N{U+12450}
2#\N{U+12456}
2#\N{U+12459}
2#\N{U+136A}
2#\N{U+17E2}
2#\N{U+17F1}
2#\N{U+1812}
2#\N{U+1948}
2#\N{U+19D2}
2#\N{U+1A82}
2#\N{U+1A92}
2#\N{U+1B52}
2#\N{U+1BB2}
2#\N{U+1C42}
2#\N{U+1C52}
2#\N{U+1D361}
2#\N{U+1D36A}
2#\N{U+1D7D0}
2#\N{U+1D7DA}
2#\N{U+1D7E4}
2#\N{U+1D7EE}
2#\N{U+1D7F8}
2, #\N{U+1F103}
2#\N{U+2161}
2#\N{U+2171}
2. #\N{U+2489}
2#\N{U+3022}
2#\N{U+3193}
2#\N{U+32}
2#\N{U+662}
2#\N{U+6F2}
2#\N{U+7C2}
2#\N{U+968}
2#\N{U+9E8}
2#\N{U+A622}
2#\N{U+A68}
2#\N{U+A6E7}
2#\N{U+A8D2}
2#\N{U+A902}
2#\N{U+A9D2}
2#\N{U+AA52}
2#\N{U+ABF2}
2#\N{U+AE8}
2#\N{U+B68}
2#\N{U+BE8}
2#\N{U+C68}
2#\N{U+CE8}
2#\N{U+D68}
2#\N{U+E52}
2#\N{U+ED2}
2#\N{U+F22}
2#\N{U+FF12}
3#\N{U+10109}
3#\N{U+1043}
3#\N{U+104A3}
3#\N{U+1085A}
3#\N{U+1091B}
3#\N{U+1093}
3#\N{U+10A42}
3#\N{U+10B5A}
3#\N{U+10B7A}
3#\N{U+10E62}
3#\N{U+11054}
3#\N{U+11069}
3#\N{U+110F3}
3#\N{U+11139}
3#\N{U+111D3}
3#\N{U+116C3}
3#\N{U+12401}
3#\N{U+12408}
3#\N{U+12417}
3#\N{U+12420}
3#\N{U+12424}
3#\N{U+12425}
3#\N{U+1242E}
3#\N{U+1242F}
3#\N{U+12436}
3#\N{U+12437}
3#\N{U+1243A}
3#\N{U+1243B}
3#\N{U+1244B}
3#\N{U+12451}
3#\N{U+12457}
3#\N{U+136B}
3#\N{U+17E3}
3#\N{U+17F2}
3#\N{U+1813}
3#\N{U+1949}
3#\N{U+19D3}
3#\N{U+1A83}
3#\N{U+1A93}
3#\N{U+1B53}
3#\N{U+1BB3}
3#\N{U+1C43}
3#\N{U+1C53}
3#\N{U+1D362}
3#\N{U+1D36B}
3#\N{U+1D7D1}
3#\N{U+1D7DB}
3#\N{U+1D7E5}
3#\N{U+1D7EF}
3#\N{U+1D7F9}
3, #\N{U+1F104}
3#\N{U+2162}
3#\N{U+2172}
3. #\N{U+248A}
3#\N{U+3023}
3#\N{U+3194}
3#\N{U+33}
3#\N{U+663}
3#\N{U+6F3}
3#\N{U+7C3}
3#\N{U+969}
3#\N{U+9E9}
3#\N{U+A623}
3#\N{U+A69}
3#\N{U+A6E8}
3#\N{U+A8D3}
3#\N{U+A903}
3#\N{U+A9D3}
3#\N{U+AA53}
3#\N{U+ABF3}
3#\N{U+AE9}
3#\N{U+B69}
3#\N{U+BE9}
3#\N{U+C69}
3#\N{U+CE9}
3#\N{U+D69}
3#\N{U+E53}
3#\N{U+ED3}
3#\N{U+F23}
3#\N{U+FF13}
4#\N{U+1010A}
4#\N{U+1044}
4#\N{U+104A4}
4#\N{U+1094}
4#\N{U+10A43}
4#\N{U+10B5B}
4#\N{U+10B7B}
4#\N{U+10E63}
4#\N{U+11055}
4#\N{U+1106A}
4#\N{U+110F4}
4#\N{U+1113A}
4#\N{U+111D4}
4#\N{U+116C4}
4#\N{U+12402}
4#\N{U+12409}
4#\N{U+1240F}
4#\N{U+12418}
4#\N{U+12421}
4#\N{U+12426}
4#\N{U+12430}
4#\N{U+12438}
4#\N{U+1243C}
4#\N{U+1243D}
4#\N{U+1243E}
4#\N{U+1243F}
4#\N{U+1244C}
4#\N{U+12452}
4#\N{U+12453}
4#\N{U+136C}
4#\N{U+17E4}
4#\N{U+17F3}
4#\N{U+1814}
4#\N{U+194A}
4#\N{U+19D4}
4#\N{U+1A84}
4#\N{U+1A94}
4#\N{U+1B54}
4#\N{U+1BB4}
4#\N{U+1C44}
4#\N{U+1C54}
4#\N{U+1D363}
4#\N{U+1D36C}
4#\N{U+1D7D2}
4#\N{U+1D7DC}
4#\N{U+1D7E6}
4#\N{U+1D7F0}
4#\N{U+1D7FA}
4, #\N{U+1F105}
4#\N{U+2163}
4#\N{U+2173}
4. #\N{U+248B}
4#\N{U+3024}
4#\N{U+3195}
4#\N{U+34}
4#\N{U+664}
4#\N{U+6F4}
4#\N{U+7C4}
4#\N{U+96A}
4#\N{U+9EA}
4#\N{U+A624}
4#\N{U+A6A}
4#\N{U+A6E9}
4#\N{U+A8D4}
4#\N{U+A904}
4#\N{U+A9D4}
4#\N{U+AA54}
4#\N{U+ABF4}
4#\N{U+AEA}
4#\N{U+B6A}
4#\N{U+BEA}
4#\N{U+C6A}
4#\N{U+CEA}
4#\N{U+D6A}
4#\N{U+E54}
4#\N{U+ED4}
4#\N{U+F24}
4#\N{U+FF14}
5×5,000 #\N{U+1014F}
5 minas #\N{U+10173}
5#\N{U+1010B}
5#\N{U+10143}
5#\N{U+1015F}
5#\N{U+10321}
5#\N{U+1045}
5#\N{U+104A5}
5#\N{U+1095}
5#\N{U+10E64}
5#\N{U+11056}
5#\N{U+1106B}
5#\N{U+110F5}
5#\N{U+1113B}
5#\N{U+111D5}
5#\N{U+116C5}
5#\N{U+12403}
5#\N{U+1240A}
5#\N{U+12410}
5#\N{U+12419}
5#\N{U+12422}
5#\N{U+12427}
5#\N{U+12431}
5#\N{U+12439}
5#\N{U+1244D}
5#\N{U+12454}
5#\N{U+12455}
5#\N{U+136D}
5#\N{U+17E5}
5#\N{U+17F4}
5#\N{U+1815}
5#\N{U+194B}
5#\N{U+19D5}
5#\N{U+1A85}
5#\N{U+1A95}
5#\N{U+1B55}
5#\N{U+1BB5}
5#\N{U+1C45}
5#\N{U+1C55}
5#\N{U+1D364}
5#\N{U+1D36D}
5#\N{U+1D7D3}
5#\N{U+1D7DD}
5#\N{U+1D7E7}
5#\N{U+1D7F1}
5#\N{U+1D7FB}
5, #\N{U+1F106}
5#\N{U+2164}
5#\N{U+2174}
5. #\N{U+248C}
5#\N{U+3025}
5#\N{U+35}
5#\N{U+665}
5#\N{U+6F5}
5#\N{U+7C5}
5#\N{U+96B}
5#\N{U+9EB}
5#\N{U+A625}
5#\N{U+A6B}
5#\N{U+A6EA}
5#\N{U+A8D5}
5#\N{U+A905}
5#\N{U+A9D5}
5#\N{U+AA55}
5#\N{U+ABF5}
5#\N{U+AEB}
5#\N{U+B6B}
5#\N{U+BEB}
5#\N{U+C6B}
5#\N{U+CEB}
5#\N{U+D6B}
5#\N{U+E55}
5#\N{U+ED5}
5#\N{U+F25}
5#\N{U+FF15}
6#\N{U+1010C}
6#\N{U+1046}
6#\N{U+104A6}
6#\N{U+1096}
6#\N{U+10E65}
6#\N{U+11057}
6#\N{U+1106C}
6#\N{U+110F6}
6#\N{U+1113C}
6#\N{U+111D6}
6#\N{U+116C6}
6#\N{U+12404}
6#\N{U+1240B}
6#\N{U+12411}
6#\N{U+1241A}
6#\N{U+12428}
6#\N{U+12440}
6#\N{U+1244E}
6#\N{U+136E}
6#\N{U+17E6}
6#\N{U+17F5}
6#\N{U+1816}
6#\N{U+194C}
6#\N{U+19D6}
6#\N{U+1A86}
6#\N{U+1A96}
6#\N{U+1B56}
6#\N{U+1BB6}
6#\N{U+1C46}
6#\N{U+1C56}
6#\N{U+1D365}
6#\N{U+1D36E}
6#\N{U+1D7D4}
6#\N{U+1D7DE}
6#\N{U+1D7E8}
6#\N{U+1D7F2}
6#\N{U+1D7FC}
6, #\N{U+1F107}
6#\N{U+2165}
6#\N{U+2175}
6#\N{U+2185}
6. #\N{U+248D}
6#\N{U+3026}
6#\N{U+36}
6#\N{U+666}
6#\N{U+6F6}
6#\N{U+7C6}
6#\N{U+96C}
6#\N{U+9EC}
6#\N{U+A626}
6#\N{U+A6C}
6#\N{U+A6EB}
6#\N{U+A8D6}
6#\N{U+A906}
6#\N{U+A9D6}
6#\N{U+AA56}
6#\N{U+ABF6}
6#\N{U+AEC}
6#\N{U+B6C}
6#\N{U+BEC}
6#\N{U+C6C}
6#\N{U+CEC}
6#\N{U+D6C}
6#\N{U+E56}
6#\N{U+ED6}
6#\N{U+F26}
6#\N{U+FF16}
7#\N{U+1010D}
7#\N{U+1047}
7#\N{U+104A7}
7#\N{U+1097}
7#\N{U+10E66}
7#\N{U+11058}
7#\N{U+1106D}
7#\N{U+110F7}
7#\N{U+1113D}
7#\N{U+111D7}
7#\N{U+116C7}
7#\N{U+12405}
7#\N{U+1240C}
7#\N{U+12412}
7#\N{U+1241B}
7#\N{U+12429}
7#\N{U+12441}
7#\N{U+12442}
7#\N{U+12443}
7#\N{U+136F}
7#\N{U+17E7}
7#\N{U+17F6}
7#\N{U+1817}
7#\N{U+194D}
7#\N{U+19D7}
7#\N{U+1A87}
7#\N{U+1A97}
7#\N{U+1B57}
7#\N{U+1BB7}
7#\N{U+1C47}
7#\N{U+1C57}
7#\N{U+1D366}
7#\N{U+1D36F}
7#\N{U+1D7D5}
7#\N{U+1D7DF}
7#\N{U+1D7E9}
7#\N{U+1D7F3}
7#\N{U+1D7FD}
7, #\N{U+1F108}
7#\N{U+2166}
7#\N{U+2176}
7. #\N{U+248E}
7#\N{U+3027}
7#\N{U+37}
7#\N{U+667}
7#\N{U+6F7}
7#\N{U+7C7}
7#\N{U+96D}
7#\N{U+9ED}
7#\N{U+A627}
7#\N{U+A6D}
7#\N{U+A6EC}
7#\N{U+A8D7}
7#\N{U+A907}
7#\N{U+A9D7}
7#\N{U+AA57}
7#\N{U+ABF7}
7#\N{U+AED}
7#\N{U+B6D}
7#\N{U+BED}
7#\N{U+C6D}
7#\N{U+CED}
7#\N{U+D6D}
7#\N{U+E57}
7#\N{U+ED7}
7#\N{U+F27}
7#\N{U+FF17}
8#\N{U+1010E}
8#\N{U+1048}
8#\N{U+104A8}
8#\N{U+1098}
8#\N{U+10E67}
8#\N{U+11059}
8#\N{U+1106E}
8#\N{U+110F8}
8#\N{U+1113E}
8#\N{U+111D8}
8#\N{U+116C8}
8#\N{U+12406}
8#\N{U+1240D}
8#\N{U+12413}
8#\N{U+1241C}
8#\N{U+1242A}
8#\N{U+12444}
8#\N{U+12445}
8#\N{U+1370}
8#\N{U+17E8}
8#\N{U+17F7}
8#\N{U+1818}
8#\N{U+194E}
8#\N{U+19D8}
8#\N{U+1A88}
8#\N{U+1A98}
8#\N{U+1B58}
8#\N{U+1BB8}
8#\N{U+1C48}
8#\N{U+1C58}
8#\N{U+1D367}
8#\N{U+1D370}
8#\N{U+1D7D6}
8#\N{U+1D7E0}
8#\N{U+1D7EA}
8#\N{U+1D7F4}
8#\N{U+1D7FE}
8, #\N{U+1F109}
8#\N{U+2167}
8#\N{U+2177}
8. #\N{U+248F}
8#\N{U+3028}
8#\N{U+38}
8#\N{U+668}
8#\N{U+6F8}
8#\N{U+7C8}
8#\N{U+96E}
8#\N{U+9EE}
8#\N{U+A628}
8#\N{U+A6E}
8#\N{U+A6ED}
8#\N{U+A8D8}
8#\N{U+A908}
8#\N{U+A9D8}
8#\N{U+AA58}
8#\N{U+ABF8}
8#\N{U+AEE}
8#\N{U+B6E}
8#\N{U+BEE}
8#\N{U+C6E}
8#\N{U+CEE}
8#\N{U+D6E}
8#\N{U+E58}
8#\N{U+ED8}
8#\N{U+F28}
8#\N{U+FF18}
9#\N{U+1010F}
9#\N{U+1049}
9#\N{U+104A9}
9#\N{U+1099}
9#\N{U+10E68}
9#\N{U+1105A}
9#\N{U+1106F}
9#\N{U+110F9}
9#\N{U+1113F}
9#\N{U+111D9}
9#\N{U+116C9}
9#\N{U+12407}
9#\N{U+1240E}
9#\N{U+12414}
9#\N{U+1241D}
9#\N{U+1242B}
9#\N{U+12446}
9#\N{U+12447}
9#\N{U+12448}
9#\N{U+12449}
9#\N{U+1371}
9#\N{U+17E9}
9#\N{U+17F8}
9#\N{U+17F9}
9#\N{U+1819}
9#\N{U+194F}
9#\N{U+19D9}
9#\N{U+1A89}
9#\N{U+1A99}
9#\N{U+1B59}
9#\N{U+1BB9}
9#\N{U+1C49}
9#\N{U+1C59}
9#\N{U+1D368}
9#\N{U+1D371}
9#\N{U+1D7D7}
9#\N{U+1D7E1}
9#\N{U+1D7EB}
9#\N{U+1D7F5}
9#\N{U+1D7FF}
9, #\N{U+1F10A}
9#\N{U+2168}
9#\N{U+2178}
9. #\N{U+2490}
9#\N{U+3029}
9#\N{U+39}
9#\N{U+669}
9#\N{U+6F9}
9#\N{U+7C9}
9#\N{U+96F}
9#\N{U+9EF}
9#\N{U+A629}
9#\N{U+A6EE}
9#\N{U+A6F}
9#\N{U+A8D9}
9#\N{U+A909}
9#\N{U+A9D9}
9#\N{U+AA59}
9#\N{U+ABF9}
9#\N{U+AEF}
9#\N{U+B6F}
9#\N{U+BEF}
9#\N{U+C6F}
9#\N{U+CEF}
9#\N{U+D6F}
9#\N{U+E59}
9#\N{U+ED9}
9#\N{U+F29}
9#\N{U+FF19}
10×5,000 #\N{U+10150}
10 minas #\N{U+10157}
10 #\N{U+10110}
10 #\N{U+10160}
10 #\N{U+10161}
10 #\N{U+10162}
10 #\N{U+10163}
10 #\N{U+10164}
10 #\N{U+10322}
10 #\N{U+103D3}
10 #\N{U+1085B}
10 #\N{U+10917}
10 #\N{U+10A44}
10 #\N{U+10B5C}
10 #\N{U+10B7C}
10 #\N{U+10E69}
10 #\N{U+1105B}
10 #\N{U+1372}
10 #\N{U+2169}
10 #\N{U+2179}
10. #\N{U+2491}
10 #\N{U+3038}
10 #\N{U+A6EF}
10 #\N{U+BF0}
10 #\N{U+D70}
11 #\N{U+216A}
11 #\N{U+217A}
11. #\N{U+2492}
12 #\N{U+216B}
12 #\N{U+217B}
12. #\N{U+2493}
13. #\N{U+2494}
14. #\N{U+2495}
15. #\N{U+2496}
16. #\N{U+2497}
17 #\N{U+16EE}
17. #\N{U+2498}
18 #\N{U+16EF}
18. #\N{U+2499}
19 #\N{U+16F0}
19. #\N{U+249A}
20 #\N{U+10111}
20 #\N{U+103D4}
20 #\N{U+1085C}
20 #\N{U+10918}
20 #\N{U+10A45}
20 #\N{U+10B5D}
20 #\N{U+10B7D}
20 #\N{U+10E6A}
20 #\N{U+1105C}
20 #\N{U+1373}
20. #\N{U+249B}
20 #\N{U+3039}
30 #\N{U+10112}
30 #\N{U+10165}
30 #\N{U+10E6B}
30 #\N{U+1105D}
30 #\N{U+1374}
30 #\N{U+303A}
40 #\N{U+10113}
40 #\N{U+10E6C}
40 #\N{U+1105E}
40 #\N{U+1375}
50×5,000 #\N{U+10151}
50 minas #\N{U+10174}
50 #\N{U+10114}
50 #\N{U+10144}
50 #\N{U+10166}
50 #\N{U+10167}
50 #\N{U+10168}
50 #\N{U+10169}
50 #\N{U+10323}
50 #\N{U+10A7E}
50 #\N{U+10E6D}
50 #\N{U+1105F}
50 #\N{U+1376}
50 #\N{U+216C}
50 #\N{U+217C}
50 #\N{U+2186}
60 #\N{U+10115}
60 #\N{U+10E6E}
60 #\N{U+11060}
60 #\N{U+1377}
70 #\N{U+10116}
70 #\N{U+10E6F}
70 #\N{U+11061}
70 #\N{U+1378}
80 #\N{U+10117}
80 #\N{U+10E70}
80 #\N{U+11062}
80 #\N{U+1379}
90 #\N{U+10118}
90 #\N{U+10341}
90 #\N{U+10E71}
90 #\N{U+11063}
90 #\N{U+137A}
100×5,000 #\N{U+10152}
100 #\N{U+10119}
100 #\N{U+10158}
100 #\N{U+1016A}
100 #\N{U+103D5}
100 #\N{U+1085D}
100 #\N{U+10919}
100 #\N{U+10A46}
100 #\N{U+10B5E}
100 #\N{U+10B7E}
100 #\N{U+10E72}
100 #\N{U+11064}
100 #\N{U+137B}
100 #\N{U+216D}
100 #\N{U+217D}
100 #\N{U+BF1}
100 #\N{U+D71}
200 #\N{U+1011A}
200 #\N{U+10E73}
300 #\N{U+1011B}
300 #\N{U+1016B}
300 #\N{U+10E74}
400 #\N{U+1011C}
400 #\N{U+10E75}
500×5,000 #\N{U+10153}
500 #\N{U+1011D}
500 #\N{U+10145}
500 #\N{U+1016C}
500 #\N{U+1016D}
500 #\N{U+1016E}
500 #\N{U+1016F}
500 #\N{U+10170}
500 #\N{U+10E76}
500 #\N{U+216E}
500 #\N{U+217E}
600 #\N{U+1011E}
600 #\N{U+10E77}
700 #\N{U+1011F}
700 #\N{U+10E78}
800 #\N{U+10120}
800 #\N{U+10E79}
900 #\N{U+10121}
900 #\N{U+1034A}
900 #\N{U+10E7A}
1,000×5,000 #\N{U+10154}
1,000 #\N{U+10122}
1,000 #\N{U+10171}
1,000 #\N{U+1085E}
1,000 #\N{U+10A47}
1,000 #\N{U+10B5F}
1,000 #\N{U+10B7F}
1,000 #\N{U+11065}
1,000 #\N{U+216F}
1,000 #\N{U+217F}
1,000 #\N{U+2180}
1,000 #\N{U+BF2}
1,000 #\N{U+D72}
2,000 #\N{U+10123}
3,000 #\N{U+10124}
4,000 #\N{U+10125}
5,000 #\N{U+10126}
5,000 #\N{U+10146}
5,000 #\N{U+10148}
5,000 #\N{U+10172}
5,000 #\N{U+2181}
6,000 #\N{U+10127}
7,000 #\N{U+10128}
8,000 #\N{U+10129}
9,000 #\N{U+1012A}
10,000×5,000 #\N{U+10155}
10,000 #\N{U+1012B}
10,000 #\N{U+10149}
10,000 #\N{U+1085F}
10,000 #\N{U+137C}
10,000 #\N{U+2182}
20,000 #\N{U+1012C}
30,000 #\N{U+1012D}
40,000 #\N{U+1012E}
50,000×5,000 #\N{U+10156}
50,000 #\N{U+1012F}
50,000 #\N{U+10147}
50,000 #\N{U+1014A}
50,000 #\N{U+2187}
60,000 #\N{U+10130}
70,000 #\N{U+10131}
80,000 #\N{U+10132}
90,000 #\N{U+10133}
100,000 #\N{U+1014B}
100,000 #\N{U+2188}
216,000 #\N{U+12432}
432,000 #\N{U+12433}
500,000 #\N{U+1014C}
1,000,000 #\N{U+1014D}
5,000,000 #\N{U+1014E}
-1 #\N{U+F33}
0/3 #\N{U+2189}
0#\N{U+C78}
/16 #\N{U+9F9}
1/10 #\N{U+2152}
1/16 #\N{U+A833}
1/16 #\N{U+B75}
1/2 #\N{U+10141}
1/2 #\N{U+10175}
1/2 #\N{U+10176}
1/2 #\N{U+10E7B}
1/2 #\N{U+2CFD}
1/2 #\N{U+A831}
1/2 #\N{U+B73}
1/2 #\N{U+BD}
1/2 #\N{U+D74}
1/2 #\N{U+F2A}
1/3 #\N{U+10E7D}
1/3 #\N{U+1245A}
1/3 #\N{U+1245D}
1/3 #\N{U+2153}
1/4 #\N{U+10140}
1/4 #\N{U+10E7C}
1/4 #\N{U+12460}
1/4 #\N{U+12462}
1/4 #\N{U+A830}
1/4 #\N{U+B72}
1/4 #\N{U+BC}
1/4 #\N{U+D73}
1/5 #\N{U+2155}
1/6 #\N{U+12461}
1/6 #\N{U+2159}
1/7 #\N{U+2150}
1/8 #\N{U+1245F}
1/8 #\N{U+215B}
1/8 #\N{U+A834}
1/8 #\N{U+B76}
1/9 #\N{U+2151}
1/ #\N{U+215F}
1/ #\N{U+9F4}
1#\N{U+C79}
1#\N{U+C7C}
2/3 #\N{U+10177}
2/3 #\N{U+10E7E}
2/3 #\N{U+1245B}
2/3 #\N{U+1245E}
2/3 #\N{U+2154}
2/5 #\N{U+2156}
2/ #\N{U+9F5}
2#\N{U+C7A}
2#\N{U+C7D}
3/16 #\N{U+A835}
3/16 #\N{U+B77}
3/2 #\N{U+F2B}
3/4 #\N{U+10178}
3/4 #\N{U+9F8}
3/4 #\N{U+A832}
3/4 #\N{U+B74}
3/4 #\N{U+BE}
3/4 #\N{U+D75}
3/5 #\N{U+2157}
3/8 #\N{U+215C}
3/ #\N{U+9F6}
3#\N{U+C7B}
3#\N{U+C7E}
4/5 #\N{U+2158}
4/ #\N{U+9F7}
5/2 #\N{U+F2C}
5/6 #\N{U+1245C}
5/6 #\N{U+215A}
5/8 #\N{U+215D}
7/2 #\N{U+F2D}
7/8 #\N{U+215E}
9/2 #\N{U+F2E}
11/2 #\N{U+F2F}
13/2 #\N{U+F30}
15/2 #\N{U+F31}
17/2 #\N{U+F32}
