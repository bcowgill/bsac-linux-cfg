#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show a sample of unicode whitespace characters and their symbolic character

# U+00A0 = non breaking space &nbsp;
# 'NEXT LINE (NEL)' (U+0085)
# TODO unicode character classes to identify all 'white spaces'
# WINDEV tool useful on windows development machine
function usage {
	local code
	code=$1
	echo "
$(basename $0) [--label] [--raw] [--table] [--symbols] [--help|--man|-?]

This will display unicode whitespace characters and their symbol characters for making them visible.

--label    default. Shows a compact list of whitespace characters in labeled ranges per line.
--raw      Shows only the whitespace characters with a terminal OS dependend newline.
--table    Shows a tab separated table of whitespace and symbols unicode code point, class and character name.
--symbols  Shows a whitespace and then the symbol character for it with their code points.
--lf       Prints from standard input but terminated with LF line terminators.
--cr       Prints from standard input but terminated with CR line terminators.
--crlf     Prints from standard input but terminated with CRLF line terminators.
--nel      Prints from standard input but terminated with NEL line terminators.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

See also filter-whitespace.pl, strip-whitespace.pl

"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi

if [ "$1" == "--lf" ]; then
	CRLF=U+0A
fi
if [ "$1" == "--cr" ]; then
	CRLF=U+0D
fi
if [ "$1" == "--crlf" ]; then
	CRLF="U+0DU+0A"
fi
if [ "$1" == "--nel" ]; then
	CRLF="U+0085"
fi

if [ ! -z $CRLF ]; then
	CRLF=$CRLF perl -CI -CO -pne '
		use feature 'unicode_strings';
		use charnames qw(:full);
		# code point to utf8 character
		sub toUTF8
		{
			my ($hex) = @_;
			my $ret = charnames::string_vianame(uc($hex));
			return $ret;
		}
		my $nl = $ENV{CRLF};
		$nl =~ s{(U\+[0-9A-F]+)}{toUTF8($1)}xmsgei;
		chomp;
		print qq{$_$nl};
	'
	exit 0
fi

if [ "$1" == "--symbols" ]; then
	echo "Whitespace character followed by the Unicode character which symbolises it."
	CODES="
		U+00 U+2400
		U+01 U+2401
		U+02 U+2402
		U+03 U+2403
		U+04 U+2404
		U+05 U+2405
		U+06 U+2406
		U+07 U+2407
		U+08 U+2408
		U+09 U+2409
		U+0A U+240A
		U+0B U+240B
		U+0C U+240C
		U+0D U+240D
		U+0E U+240E
		U+0F U+240F
		U+10 U+2410
		U+11 U+2411
		U+12 U+2412
		U+13 U+2413
		U+14 U+2414
		U+15 U+2415
		U+16 U+2416
		U+17 U+2417
		U+18 U+2418
		U+19 U+2419
		U+1A U+241A
		U+1B U+241B
		U+1C U+241C
		U+1D U+241D
		U+1E U+241E
		U+1F U+241F
		U+20 U+2420
		U+7F U+2421
		U+0D U+0A U+0085 U+2424
	"
	for code in $CODES
	do
		echo $code [`utf8.pl $code`]
	done

	exit 0
fi

if [ "$1" == "--raw" ]; then
	perl -C -e '
		my $n = "\n";
		print qq{\x{00}\x{01}\x{02}\x{03}\x{04}\x{05}\x{06}\x{07}\x{08}\x{09}\x{0A}\x{0B}\x{0C}\x{0D}\x{0E}\x{0F}};
		print qq{\x{10}\x{11}\x{12}\x{13}\x{14}\x{15}\x{16}\x{17}\x{18}\x{19}\x{1A}\x{1B}\x{1C}\x{1D}\x{1E}\x{1F}};
		print qq{\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{200C}\x{200D}\x{200E}\x{200F}};
		print qq{\x{20}\x{7F}\x{A0}};
		print qq{\x{1361}\x{1680}};
		print qq{\x{202F}\x{205F}};
		print qq{\x{3000}\x{303F}};
		print qq{\x{FEFF}\x{E0020}};
		print qq{\x{0D}};
		print qq{\x{0A}};
		print qq{\x{0085}};
		print qq{\x{0D}\x{0A}};
		print qq{$n};
	'
	exit 0
fi

if [ "$1" == "--table" ]; then
	perl -e '
		# substitute nul so that diffmerge can diff this file as unicode
		my $nul = q{\x{00}};
		print <<"TABLE";
Whitespace and Symbols for Whitespace Code Points:
Ch	Code	Type	Name
$nul	U+0	[Control]	NULL
	U+1	[Control]	START OF HEADING
	U+2	[Control]	START OF TEXT
	U+3	[Control]	END OF TEXT
	U+4	[Control]	END OF TRANSMISSION
	U+5	[Control]	ENQUIRY
	U+6	[Control]	ACKNOWLEDGE
	U+7	[Control]	ALERT
	U+7	[Control]	BELL
	U+8	[Control]	BACKSPACE
		U+9	[Control]	CHARACTER TABULATION
		U+9	[Control]	HORIZONTAL TABULATION
	U+A	[Control]	LINE FEED
	U+B	[Control]	LINE TABULATION
	U+B	[Control]	VERTICAL TABULATION
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
	U+1C	[Control]	FILE SEPARATOR
	U+1D	[Control]	GROUP SEPARATOR
	U+1E	[Control]	RECORD SEPARATOR
	U+1F	[Control]	UNIT SEPARATOR
	U+1C	[Control]	INFORMATION SEPARATOR FOUR
	U+1D	[Control]	INFORMATION SEPARATOR THREE
	U+1E	[Control]	INFORMATION SEPARATOR TWO
	U+1F	[Control]	INFORMATION SEPARATOR ONE
	U+20	[SpaceSeparator]	SPACE
	U+7F	[Control]	DELETE
 	U+A0	[SpaceSeparator]	NO-BREAK SPACE
፡	U+1361	[OtherPunctuation]	ETHIOPIC WORDSPACE
 	U+1680	[SpaceSeparator]	OGHAM SPACE MARK
 	U+2000	[SpaceSeparator]	EN QUAD
 	U+2001	[SpaceSeparator]	EM QUAD
 	U+2002	[SpaceSeparator]	EN SPACE
 	U+2003	[SpaceSeparator]	EM SPACE
 	U+2004	[SpaceSeparator]	THREE-PER-EM SPACE
 	U+2005	[SpaceSeparator]	FOUR-PER-EM SPACE
 	U+2006	[SpaceSeparator]	SIX-PER-EM SPACE
 	U+2007	[SpaceSeparator]	FIGURE SPACE
 	U+2008	[SpaceSeparator]	PUNCTUATION SPACE
 	U+2009	[SpaceSeparator]	THIN SPACE
 	U+200A	[SpaceSeparator]	HAIR SPACE
​	U+200B	[Format]	ZERO WIDTH SPACE
‌	U+200C	[Format]	ZERO WIDTH NON-JOINER
‍	U+200D	[Format]	ZERO WIDTH JOINER
‎	U+200E	[Format]	LEFT-TO-RIGHT MARK
‏	U+200F	[Format]	RIGHT-TO-LEFT MARK
 	U+202F	[SpaceSeparator]	NARROW NO-BREAK SPACE
 	U+205F	[SpaceSeparator]	MEDIUM MATHEMATICAL SPACE
　	U+3000	[SpaceSeparator]	IDEOGRAPHIC SPACE
〿	U+303F	[OtherSymbol]	IDEOGRAPHIC HALF FILL SPACE
﻿	U+FEFF	[Format]	ZERO WIDTH NO-BREAK SPACE
󠀠	U+E0020	[Format]	TAG SPACE
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
TABLE
'
	exit 0
fi

# --label
echo whitespace/control-characters
perl -C -e '
	my $n = "\n";
	print qq{U+00-0F[\x{00}\x{01}\x{02}\x{03}\x{04}\x{05}\x{06}\x{07}\x{08}\x{09}\x{0A}\x{0B}\x{0C}\x{0D}\x{0E}\x{0F}]$n};
	print qq{U+10-1F[\x{10}\x{11}\x{12}\x{13}\x{14}\x{15}\x{16}\x{17}\x{18}\x{19}\x{1A}\x{1B}\x{1C}\x{1D}\x{1E}\x{1F}]$n};
	print qq{2000-0F[\x{2000}\x{2001}\x{2002}\x{2003}\x{2004}\x{2005}\x{2006}\x{2007}\x{2008}\x{2009}\x{200A}\x{200B}\x{200C}\x{200D}\x{200E}\x{200F}]$n};
	print qq{20[\x{20}]${n}7F[\x{7F}]${n}A0[\x{A0}]$n};
	print qq{1361[\x{1361}]${n}1680[\x{1680}]${n}};
	print qq{202F[\x{202F}]${n}205F[\x{205F}]${n}};
	print qq{3000[\x{3000}]${n}303F[\x{303F}]${n}};
	print qq{FEFF[\x{FEFF}]${n}E0020[\x{E0020}]${n}};
	print qq{CR[\x{0D}]${n}};
	print qq{LF[\x{0A}]${n}};
	print qq{NEL[\x{0085}]${n}};
	print qq{CRLF[\x{0D}\x{0A}]${n}};
	print qq{NL[$n]$n};
'
exit 0
