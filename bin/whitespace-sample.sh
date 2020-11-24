#!/bin/bash
# show a sample of unicode whitespace characters
# WINDEV tool useful on windows development machine

# U+00A0 = non breaking space &nbsp;
# 'NEXT LINE (NEL)' (U+0085)
# TODO --raw option --lines option
# TODO unicode character classes to identify all 'white spaces'
echo whitespace/control-characters
perl -C -e '
	print qq{00-0F:\x{00}\x{01}\x{02}\x{03}\x{04}\x{05}\x{06}\x{07}\x{08}\x{09}\x{0A}\x{0B}\x{0C}\x{0D}\x{0E}\x{0F}\n};
	print qq{10-1F:\x{10}\x{11}\x{12}\x{13}\x{14}\x{15}\x{16}\x{17}\x{18}\x{19}\x{1A}\x{1B}\x{1C}\x{1D}\x{1E}\x{1F}\n};
	print qq{20:\x{20}\n7F:\x{7F}\n};
	print qq{CR:\x{0D}\n};
	print qq{LF:\x{0A}\n};
	print qq{NEL:\x{0085}\n};
	print qq{CRLF:\x{0D}\x{0A}\n};
'
exit 0
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
	echo $code `utf8.pl $code`
done

exit 0
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
