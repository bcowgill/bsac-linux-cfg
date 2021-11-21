#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars); # https://metacpan.org/pod/perlvar for reference
use charnames qw(:full); # :loose if you perl version supports it
use FindBin;

use Data::Dumper;
$Data::Dumper::Sortkeys = 1;
$Data::Dumper::Indent   = 1;
$Data::Dumper::Terse    = 1;

sub usage
{
	my ($code) = @ARG;
	if ($code)
	{
		print qq{$code\n\n};
		$code = 1;
	}
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [--codes|--reverse] [--binary] [--debug] [filesname ...]

This will filter the whitespace characters from standard input or files and transform them into codes or other symbols.

--codes   Shows U+XXXX code and unicode class for each whitespace character.
--reverse Convert unicode symbol characters to their corresponding control codes.
--binary  Treats new line characters no differently from other white space.
--debug   Shows which unicode classes are present on each line.
--man     Shows help for this tool.
--help    Shows help for this tool.
-?        Shows help for this tool.

By default the whitespace and control characters will be converted to the special unicode symbol characters which visually show the name of the whitespace character.

See also whitespace-sample.sh, spaces.pl, utf8-view.sh, utf8codept.pl, utf8.pl, filter-indents.sh, fix-spaces.sh, fix-tabs.sh, filter-newlines.sh

Example:

	whitespace-sample.sh --raw | filter-whitespace.pl
USAGE
	exit $code
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage();
}

my $DEBUG = 0; # show unicode classes for each line
my $BINARY = 0; # process input as binary
my $SHOW_CODES = 0; # show {U+XXXX,classes} for each whitespace character
my $SHOW_SYMBOLS = 0; # show unicode symbol characters for control characters
my $REVERT = 0; # replace unicode symbol characters with control characters

while (scalar(@ARGV) && $ARGV[0] =~ m{\A--})
{
	my $arg = shift(@ARGV);
	$SHOW_CODES = 1 if ($arg eq '--codes');
	$REVERT = 1 if ($arg eq '--reverse');
	$BINARY = 1 if ($arg eq '--binary');
	$DEBUG = 1 if ($arg eq '--debug');
}

if ($REVERT && $SHOW_CODES)
{
	usage('You cannot use --reverse and --codes at the same time.');
} elsif (!$REVERT && !$SHOW_CODES)
{
	$SHOW_SYMBOLS = 1;
}

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

# code point to utf8 character
sub toUTF8
{
	my ($hex) = @ARG;
	my $ret = charnames::string_vianame(uc("U+$hex"));
	return $ret;
}

sub toUTFCodePoint
{
	my ($char) = @ARG;
	my @classes = (
		$char =~ m{[[:cntrl:]]}xms ? 'cntrl' : undef,
		$char =~ m{[[:blank:]]}xms ? 'blank' : undef,
		$char =~ m{[[:space:]]}xms ? 'space' : undef,
	);
	my $classes = join(',', grep { $_ } @classes);
	$classes = ",$classes" if length($classes);
	return sprintf("{U+%04X$classes}", ord($char));
}

sub debugUTF8 {
	my ($canonical) = @ARG;

	# http://www.regular-expressions.info/posixbrackets.html
	foreach my $class ( qw(alnum alpha ascii blank cntrl digit graph lower
		print punct space upper word xdigit ) )
	{
		print "line below matches [[:$class:]] ? " . (($canonical =~ m{[[:$class:]]}xms) ? 1: 0) . "\n";
	}
}

sub read_data
{
	my %configure = ();
	while (my $line = <DATA>)
	{
		chomp($line);
		next if $line =~ m{\A\#}xms;
		if ($line =~ m{U\+ ([0-9a-f]+) \s+ .+ SYMBOL \s+ FOR \s+ (.+)}xmsi)
		{
			my ($code, $name) = ($1, $2);
			$configure{$name}{symbol} = toUTF8($code);
			$configure{$name}{findReverse} = qr{\x{$code}};
			$configure{$name}{visible} = $code;
			$configure{$name}{name} = $name;
		}
		elsif ($line =~ m{U\+ ([0-9a-f]+) \s+ .+\] \s+ (.+)}xmsi)
		{
			my ($code, $name) = ($1, $2);
			$configure{$name}{symbolReverse} = toUTF8($code);
			$configure{$name}{find} = qr{\x{$code}};
			$configure{$name}{invisble} = $code;
			$configure{$name}{name} = $name;
		}
	}
	#print Dumper(map { $configure{$ARG} } grep { $configure{$ARG}{symbol} && !$configure{$ARG}{find} } keys(%configure));
	#
	my @table = map { $configure{$ARG} }
		grep { $configure{$ARG}{symbol} && $configure{$ARG}{find} }
		keys(%configure);

	#print Dumper(\@table);
	return \@table;
}

sub show_codes
{
	my ($line) = @ARG;
	$line =~ s{([[:blank:][:space:][:cntrl:]])}{toUTFCodePoint($1)}xmsge;
	return $line;
}

sub show_symbols
{
	my ($line, $raTable) = @ARG;
	foreach my $utf (@$raTable)
	{
		$line =~ s{$utf->{find}}{$utf->{symbol}}xmsg;
	}
	return $line;
}

sub replace_symbols
{
	my ($line, $raTable) = @ARG;
	foreach my $utf (@$raTable)
	{
		$line =~ s{$utf->{findReverse}}{$utf->{symbolReverse}}xmsg;
	}
	return $line;
}

# TODO line mode for text files, binary mode
# TODO reverse replace symbols back to whitespace
# TODO newline mode show NL for LF on unix, NL for CRLF on windows, etc
sub main
{
	my $raTable = read_data();
	while (my $line = <>) {
		my $nl = '';
		if (!$BINARY)
		{
			$nl = "\n";
			#chomp($line);
		}
		if ($DEBUG)
		{
			debugUTF8($line);
		}
		if ($SHOW_CODES)
		{
			$line = show_codes($line);
		}
		elsif ($SHOW_SYMBOLS)
		{
			$line = show_symbols($line, $raTable);
		}
		elsif ($REVERT)
		{
			$line = replace_symbols($line, $raTable);
		}
		print qq{$line$nl};
	}
}

main();

__DATA__
␀	U+2400	[OtherSymbol]	SYMBOL FOR NULL
␁	U+2401	[OtherSymbol]	SYMBOL FOR START OF HEADING
␂	U+2402	[OtherSymbol]	SYMBOL FOR START OF TEXT
␃	U+2403	[OtherSymbol]	SYMBOL FOR END OF TEXT
␄	U+2404	[OtherSymbol]	SYMBOL FOR END OF TRANSMISSION
␅	U+2405	[OtherSymbol]	SYMBOL FOR ENQUIRY
␆	U+2406	[OtherSymbol]	SYMBOL FOR ACKNOWLEDGE
␇	U+2407	[OtherSymbol]	SYMBOL FOR BELL
␈	U+2408	[OtherSymbol]	SYMBOL FOR BACKSPACE
␉	U+2409	[OtherSymbol]	SYMBOL FOR HORIZONTAL TABULATION
␊	U+240A	[OtherSymbol]	SYMBOL FOR LINE FEED
␋	U+240B	[OtherSymbol]	SYMBOL FOR VERTICAL TABULATION
␌	U+240C	[OtherSymbol]	SYMBOL FOR FORM FEED
␍	U+240D	[OtherSymbol]	SYMBOL FOR CARRIAGE RETURN
␎	U+240E	[OtherSymbol]	SYMBOL FOR SHIFT OUT
␏	U+240F	[OtherSymbol]	SYMBOL FOR SHIFT IN
␐	U+2410	[OtherSymbol]	SYMBOL FOR DATA LINK ESCAPE
␑	U+2411	[OtherSymbol]	SYMBOL FOR DEVICE CONTROL ONE
␒	U+2412	[OtherSymbol]	SYMBOL FOR DEVICE CONTROL TWO
␓	U+2413	[OtherSymbol]	SYMBOL FOR DEVICE CONTROL THREE
␔	U+2414	[OtherSymbol]	SYMBOL FOR DEVICE CONTROL FOUR
␕	U+2415	[OtherSymbol]	SYMBOL FOR NEGATIVE ACKNOWLEDGE
␖	U+2416	[OtherSymbol]	SYMBOL FOR SYNCHRONOUS IDLE
␗	U+2417	[OtherSymbol]	SYMBOL FOR END OF TRANSMISSION BLOCK
␘	U+2418	[OtherSymbol]	SYMBOL FOR CANCEL
␙	U+2419	[OtherSymbol]	SYMBOL FOR END OF MEDIUM
␚	U+241A	[OtherSymbol]	SYMBOL FOR SUBSTITUTE
␛	U+241B	[OtherSymbol]	SYMBOL FOR ESCAPE
␜	U+241C	[OtherSymbol]	SYMBOL FOR FILE SEPARATOR
␝	U+241D	[OtherSymbol]	SYMBOL FOR GROUP SEPARATOR
␞	U+241E	[OtherSymbol]	SYMBOL FOR RECORD SEPARATOR
␟	U+241F	[OtherSymbol]	SYMBOL FOR UNIT SEPARATOR
␠	U+2420	[OtherSymbol]	SYMBOL FOR SPACE
␡	U+2421	[OtherSymbol]	SYMBOL FOR DELETE
␤	U+2424	[OtherSymbol]	SYMBOL FOR NEWLINE

	U+0	[Control]	NULL
	U+1	[Control]	START OF HEADING
	U+2	[Control]	START OF TEXT
	U+3	[Control]	END OF TEXT
	U+4	[Control]	END OF TRANSMISSION
	U+5	[Control]	ENQUIRY
	U+6	[Control]	ACKNOWLEDGE
	U+7	[Control]	ALERT
^G      U+7     [Control]       BELL
	U+8	[Control]	BACKSPACE
		U+9	[Control]	CHARACTER TABULATION
                U+9     [Control]       HORIZONTAL TABULATION
	U+A	[Control]	LINE FEED
	U+B	[Control]	LINE TABULATION
^K      U+B     [Control]   VERTICAL TABULATION
	U+C	[Control]	FORM FEED
	U+D	[Control]	CARRIAGE RETURN
	U+E	[Control]	SHIFT OUT
	U+F	[Control]	SHIFT IN
	U+10	[Control]	DATA LINK ESCAPE
	U+11	[Control]	DEVICE CONTROL ONE
	U+12	[Control]	DEVICE CONTROL TWO
	U+13	[Control]	DEVICE CONTROL THREE
	U+14	[Control]	DEVICE CONTROL FOUR
	U+15	[Control]	NEGATIVE ACKNOWLEDGE
	U+16	[Control]	SYNCHRONOUS IDLE
	U+17	[Control]	END OF TRANSMISSION BLOCK
	U+18	[Control]	CANCEL
	U+19	[Control]	END OF MEDIUM
	U+1A	[Control]	SUBSTITUTE
	U+1B	[Control]	ESCAPE
^\      U+1C    [Control]       FILE SEPARATOR
^]      U+1D    [Control]       GROUP SEPARATOR
^^      U+1E    [Control]       RECORD SEPARATOR
^_      U+1F    [Control]       UNIT SEPARATOR
	U+1C	[Control]	INFORMATION SEPARATOR FOUR
	U+1D	[Control]	INFORMATION SEPARATOR THREE
	U+1E	[Control]	INFORMATION SEPARATOR TWO
	U+1F	[Control]	INFORMATION SEPARATOR ONE
        U+20    [SpaceSeparator]        SPACE
	U+7F	[Control]	DELETE
	U+80	[Control]	PADDING CHARACTER
	U+81	[Control]	HIGH OCTET PRESET
	U+82	[Control]	BREAK PERMITTED HERE
	U+83	[Control]	NO BREAK HERE
	U+84	[Control]	INDEX
	U+85	[Control]	NEXT LINE
	U+86	[Control]	START OF SELECTED AREA
	U+87	[Control]	END OF SELECTED AREA
	U+88	[Control]	CHARACTER TABULATION SET
	U+89	[Control]	CHARACTER TABULATION WITH JUSTIFICATION
	U+8A	[Control]	LINE TABULATION SET
	U+8B	[Control]	PARTIAL LINE FORWARD
	U+8C	[Control]	PARTIAL LINE BACKWARD
	U+8D	[Control]	REVERSE LINE FEED
	U+8E	[Control]	SINGLE SHIFT TWO
	U+8F	[Control]	SINGLE SHIFT THREE
	U+90	[Control]	DEVICE CONTROL STRING
	U+91	[Control]	PRIVATE USE ONE
	U+92	[Control]	PRIVATE USE TWO
	U+93	[Control]	SET TRANSMIT STATE
	U+94	[Control]	CANCEL CHARACTER
	U+95	[Control]	MESSAGE WAITING
	U+96	[Control]	START OF GUARDED AREA
	U+97	[Control]	END OF GUARDED AREA
	U+98	[Control]	START OF STRING
	U+99	[Control]	SINGLE GRAPHIC CHARACTER INTRODUCER
	U+9A	[Control]	SINGLE CHARACTER INTRODUCER
	U+9B	[Control]	CONTROL SEQUENCE INTRODUCER
	U+9C	[Control]	STRING TERMINATOR
	U+9D	[Control]	OPERATING SYSTEM COMMAND
	U+9E	[Control]	PRIVACY MESSAGE
	U+9F	[Control]	APPLICATION PROGRAM COMMAND
