#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show a sample of unicode characters
# unicode-sample.sh -list | column -t | column
# WINDEV tool useful on windows development machine

# U+00A0 = non breaking space &nbsp;

CODES="
U+00A0
U+2018 U+2019 U+201C U+201D
U+2026 U+00A9 U+00AE
#-numbers/mathematics
U+22C5 U+D7
U+F7 U+2215
U+00BC U+00BD U+00BE
U+221A U+221B U+221C
U+2070 U+B9 U+B2 U+B3 U+2074 U+2075 U+2076 U+2077 U+2078 U+2079 U+2071 U+207F U+207A U+207B U+207C U+207D U+207E U+2C2 U+2C3
U+33D2
U+394
U+2FF U+2F1 U+2F2
#-degrees-currency
U+B0 U+2103 U+2109
U+00A3 U+20B5 U+20A4 U+20AC U+FF04 U+FE69 U+2367
#-checks-votes
U+2713 U+2714 U+2705
U+2715 U+2716 U+2717 U+2718 U+2719 U+274C
U+2610 U+2611 U+2612
#-symbols
U+0277 U+0B50
U+0C94 U+0FD5
U+0FCA U+262F
U+1AA0
U+23F0
U+2460 U+2776
U+2615 U+1F4B0
#-chinese
U+56CD U+2FF0 U+80B9 U+813D U+5C6A U+9280
#-smileys
U+2639 U+263A U+263B U+1F60E
#-dice
U+2680 U+2681 U+2682 U+2683 U+2684 U+2685
#-sun-weather-world
U+1F305 U+1F307 U+1F31E U+1F33B
U+2603
U+1F30E
U+1F341
U+1F197 U+1F198 U+1F192
#-info-warning-danger-symbols
U+24D8 U+24A4 U+26A0
U+2623
U+2622
U+2620
U+1F52B
U+1F4A3
#-send-folder-computer-icons
U+1F4E9
U+1F4F2
U+1F4C2
U+1F4BB
#-shapes
U+0394
U+2610
U+25A2
U+26AC
U+26AA
U+26AB
U+2B58
U+2B57
U+25CC
U+25CB
U+274D
U+2B55
U+25EF
U+2B24
#-critters
U+1F427
U+1F41B
#-hands
U+1F446 U+1F447 U+1F448 U+1F449 U+1F44A U+1F44B U+1F44C U+1F44D U+1F44E U+1F44F
U+1F463
U+2741
U+23E9
#-arrows-mostly-TODO
U+2190 U+2191 U+2192 U+2193 U+2194 U+2195 U+2196 U+2197 U+2198 U+2199
U+21A9 U+21AA
U+21AF
U+21B0 U+21B1 U+21B2 U+21B3 U+21B4 U+21B5
U+21B6 U+21B7
U+21D0 U+21D1 U+21D2 U+21D3 U+21D4 U+21D5 U+21D6 U+21D7 U+21D8 U+21D9
U+21DC U+21DD
U+21E6 U+21E7 U+21E8 U+21E9
U+21FD U+21FE U+21FF
U+2B00 U+2B01 U+2B02 U+2B03 U+2B04
U+2B05 U+2B06 U+2B07 U+2B08 U+2B09 U+2B0A U+2B0B U+2B0C U+2B0D
U+2B0E U+2B0F U+2B10 U+2B11
#-search
U+1F50D U+1F50E
#-pi
U+3C0 U+213C U+1D6D1 U+1D70B U+1D745 U+1D77F U+1D7B9
"

# 🍩  doughnut
# ⛾  coffee
# 😎 🍁 🆗
#
# 🍁	U+1F341
# 80B9 c*nt
# 813D a child's p*nis
# 5C6A p*nis
# 9280 cash

for code in $CODES
do
	if echo $code | grep '#' > /dev/null ; then
		echo $code | perl -pne 's{-}{ }xmsg'
	else
		echo $code `utf8.pl $code`
	fi
done

if [ "$1" == "-list" ]; then
	exit 0
fi
if [ "$1" == "-l" ]; then
	exit 0
fi

echo "Lord of the Rings:
            ⸬                   ⸬"

echo "ʎddɐɥ ʎddɐɥ ʎddɐɥ ʎddɐɥ ʎddɐɥ ʎddɐɥ ʎddɐɥ ʎddɐɥ ʎddɐɥ"
echo "ᘜ ᓋ ᓋ ᖱ  ᙏ ᓏ ᖆ ᘗ ᓲ ᘘ ᘜ "
echo "☂"
echo "(っ＾▿＾)۶🍸🌟🍺٩(˘◡˘ )"
echo "( ◑‿◑)ɔ┏🍟--🍔┑٩(^◡^ )"
echo " "
echo "// Cool comments"
echo "// ✅ All useEffect dependencies are specified"
echo "// ❌ Error cross"
echo "// 🔐 🔒 🔓 Lock states"
echo "// 💡	Brilliant Idea light bulb"
echo "// ☐ Todo item / ballot box"
echo "// ☑ Done. (Happily)"
echo "// ☒ Also Done."
echo "// ⚠️ createRows() is called on every render"
echo "// 🚩 Flag: watch out for negative numbers here"
echo "// 🔴 Bug: count is not specified as a dependency"
echo "// 🔵 Blue: circle"
echo "// ⬤ Black: circle"
echo "// ○ White: circle" echo "// ◌ Dotted Circle"
echo "// ❤ I love it!"
echo "// 🚀 take off!"
echo "// 📦 build it"
echo "// ⏰ time expensive"
echo "// 💰 money point"
echo "// ⛾ 🍩 coffee and doughnut reward"
echo "// ☹ Frowny face"
echo "// ☺ Smiling face"
echo "// ☻ Smiling face"
echo "// 😀 Grinning face"
echo "// 😃 Big smiling face"
echo "// 😉 Winking face"
echo "// 😎 Smiling shades face"
echo "// 😐 Neutral face"
echo "// 😕 Confused face"
echo "// 😠 Angry face"
echo "// 😡 Pouting face"
echo "// 😢 Crying face"
echo "
mac keyref -- Favourites:
~ ^ ☑️ ✅ ☐ ☒ ☑︎ ❌ 🤑 💰 💸 💵 💲 $ ﹩ ＄

windows keyref
✅ ⁐ ▢ ▭ ▣ ◯ ◻ □
"
echo "  NOT_OK: '✘ ', // 'NOT OK ',"
echo "  OK    : '✔ ', // 'OK ',"
echo "  SKIP  : '○ ', // 'SKIP',"
echo "  SKIP  : '◌ ', // 'SKIP',"
echo "▢  checkbox"
echo "⚬	U+26AC	[OtherSymbol]	MEDIUM SMALL WHITE CIRCLE"
echo "⚪	U+26AA	[OtherSymbol]	MEDIUM WHITE CIRCLE"
echo "⚫	U+26AB	[OtherSymbol]	MEDIUM BLACK CIRCLE"
echo "⌾	U+233E	[OtherSymbol]	APL FUNCTIONAL SYMBOL CIRCLE JOT"
echo "⊙	U+2299	[MathSymbol]	CIRCLED DOT OPERATOR"
echo "⊚	U+229A	[MathSymbol]	CIRCLED RING OPERATOR"
echo "⭘	U+2B58	[OtherSymbol]	HEAVY CIRCLE"
echo "⏣	U+23E3	[OtherSymbol]	BENZENE RING WITH CIRCLE"
echo "○	U+25CB	[OtherSymbol]	WHITE CIRCLE"
echo "◌	U+25CC	[OtherSymbol]	DOTTED CIRCLE"
echo "◍	U+25CD	[OtherSymbol]	CIRCLE WITH VERTICAL FILL"
echo "●	U+25CF	[OtherSymbol]	BLACK CIRCLE"
echo "◙	U+25D9	[OtherSymbol]	INVERSE WHITE CIRCLE"
echo "❍	U+274D	[OtherSymbol]	SHADOWED WHITE CIRCLE"
echo "⦾	U+29BE	[MathSymbol]	CIRCLED WHITE BULLET"
echo "⦿	U+29BF	[MathSymbol]	CIRCLED BULLET"
echo "⭗	U+2B57	[OtherSymbol]	HEAVY CIRCLE WITH CIRCLE INSIDE"
echo "⨀	U+2A00	[MathSymbol]	N-ARY CIRCLED DOT OPERATOR"
echo "⛒	U+26D2	[OtherSymbol]	CIRCLED CROSSING LANES"
echo "⭙	U+2B59	[OtherSymbol]	HEAVY CIRCLED SALTIRE"
echo "⭕	U+2B55	[OtherSymbol]	HEAVY LARGE CIRCLE"
echo "🔴	U+1F534	[OtherSymbol]	LARGE RED CIRCLE"
echo "🔵	U+1F535	[OtherSymbol]	LARGE BLUE CIRCLE"
echo "◯	U+25EF	[OtherSymbol]	LARGE CIRCLE"
echo "⬤	U+2B24	[OtherSymbol]	BLACK LARGE CIRCLE"

echo "‘Assistant’ English with “quotation” marks and apostrophe’s"
echo "「醫療熱線」Chinese with quotation marks"
echo "„Gesundheitsassistent“ German with quotation marks"
echo "‘con gas’ Italian with quotation marks"
echo "« assistant de santé » French with quotation marks"
echo "«Asistente de Salud» Spanish with quotation marks"
exit
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

OTHER - move to unicode sample....
⌘       U+2318  [OtherSymbol]   PLACE OF INTEREST SIGN (CMD KEY???)
⌤       U+2324  [OtherSymbol]   UP ARROWHEAD BETWEEN TWO HORIZONTAL BARS (CTRL KEY???)
⌥       U+2325  [OtherSymbol]   OPTION KEY
⌦       U+2326  [OtherSymbol]   ERASE TO THE RIGHT
⌧       U+2327  [OtherSymbol]   X IN A RECTANGLE BOX
⌨       U+2328  [OtherSymbol]   KEYBOARD
⌫       U+232B  [OtherSymbol]   ERASE TO THE LEFT
⎇       U+2387  [OtherSymbol]   ALTERNATIVE KEY SYMBOL

❘
❙
❚

❘       U+2758  [OtherSymbol]   LIGHT VERTICAL BAR
❙       U+2759  [OtherSymbol]   MEDIUM VERTICAL BAR
❚       U+275A  [OtherSymbol]   HEAVY VERTICAL BAR

█
▉
▊
▋
▌
▍
▎
▏

▕
▐
█

█       U+2588  [OtherSymbol]   FULL BLOCK
▉       U+2589  [OtherSymbol]   LEFT SEVEN EIGHTHS BLOCK
▊       U+258A  [OtherSymbol]   LEFT THREE QUARTERS BLOCK
▋       U+258B  [OtherSymbol]   LEFT FIVE EIGHTHS BLOCK
▌       U+258C  [OtherSymbol]   LEFT HALF BLOCK
▍       U+258D  [OtherSymbol]   LEFT THREE EIGHTHS BLOCK
▎       U+258E  [OtherSymbol]   LEFT ONE QUARTER BLOCK
▏       U+258F  [OtherSymbol]   LEFT ONE EIGHTH BLOCK

█       U+2588  [OtherSymbol]   FULL BLOCK
▐       U+2590  [OtherSymbol]   RIGHT HALF BLOCK
▕       U+2595  [OtherSymbol]   RIGHT ONE EIGHTH BLOCK

█▀▔ ▁▂▃▄▅▆▇█

▁       U+2581  [OtherSymbol]   LOWER ONE EIGHTH BLOCK
▂       U+2582  [OtherSymbol]   LOWER ONE QUARTER BLOCK
▃       U+2583  [OtherSymbol]   LOWER THREE EIGHTHS BLOCK
▄       U+2584  [OtherSymbol]   LOWER HALF BLOCK
▅       U+2585  [OtherSymbol]   LOWER FIVE EIGHTHS BLOCK
▆       U+2586  [OtherSymbol]   LOWER THREE QUARTERS BLOCK
▇       U+2587  [OtherSymbol]   LOWER SEVEN EIGHTHS BLOCK
█       U+2588  [OtherSymbol]   FULL BLOCK

█       U+2588  [OtherSymbol]   FULL BLOCK
▀       U+2580  [OtherSymbol]   UPPER HALF BLOCK
▔       U+2594  [OtherSymbol]   UPPER ONE EIGHTH BLOCK

▗▖
▝▘

▞▚
▚▞


▟▙
▜▛

▖       U+2596  [OtherSymbol]   QUADRANT LOWER LEFT
▗       U+2597  [OtherSymbol]   QUADRANT LOWER RIGHT
▘       U+2598  [OtherSymbol]   QUADRANT UPPER LEFT
▙       U+2599  [OtherSymbol]   QUADRANT UPPER LEFT AND LOWER LEFT AND LOWER RIGHT
▚       U+259A  [OtherSymbol]   QUADRANT UPPER LEFT AND LOWER RIGHT
▛       U+259B  [OtherSymbol]   QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER LEFT
▜       U+259C  [OtherSymbol]   QUADRANT UPPER LEFT AND UPPER RIGHT AND LOWER RIGHT
▝       U+259D  [OtherSymbol]   QUADRANT UPPER RIGHT
▞       U+259E  [OtherSymbol]   QUADRANT UPPER RIGHT AND LOWER LEFT
▟       U+259F  [OtherSymbol]   QUADRANT UPPER RIGHT AND LOWER LEFT AND LOWER RIGHT

░       U+2591  [OtherSymbol]   LIGHT SHADE
▒       U+2592  [OtherSymbol]   MEDIUM SHADE
▓       U+2593  [OtherSymbol]   DARK SHADE

⎅       U+2385  [OtherSymbol]   WHITE SQUARE WITH CENTRE VERTICAL LINE
◧       U+25E7  [OtherSymbol]   SQUARE WITH LEFT HALF BLACK
◨       U+25E8  [OtherSymbol]   SQUARE WITH RIGHT HALF BLACK
◩       U+25E9  [OtherSymbol]   SQUARE WITH UPPER LEFT DIAGONAL HALF BLACK
◪       U+25EA  [OtherSymbol]   SQUARE WITH LOWER RIGHT DIAGONAL HALF BLACK
◫       U+25EB  [OtherSymbol]   WHITE SQUARE WITH VERTICAL BISECTING LINE
■       U+25A0  [OtherSymbol]   BLACK SQUARE
□       U+25A1  [OtherSymbol]   WHITE SQUARE
▢       U+25A2  [OtherSymbol]   WHITE SQUARE WITH ROUNDED CORNERS
▣       U+25A3  [OtherSymbol]   WHITE SQUARE CONTAINING BLACK SMALL SQUARE
▤       U+25A4  [OtherSymbol]   SQUARE WITH HORIZONTAL FILL
▥       U+25A5  [OtherSymbol]   SQUARE WITH VERTICAL FILL
▦       U+25A6  [OtherSymbol]   SQUARE WITH ORTHOGONAL CROSSHATCH FILL
▧       U+25A7  [OtherSymbol]   SQUARE WITH UPPER LEFT TO LOWER RIGHT FILL
▨       U+25A8  [OtherSymbol]   SQUARE WITH UPPER RIGHT TO LOWER LEFT FILL
▩       U+25A9  [OtherSymbol]   SQUARE WITH DIAGONAL CROSSHATCH FILL
▪       U+25AA  [OtherSymbol]   BLACK SMALL SQUARE
▫       U+25AB  [OtherSymbol]   WHITE SMALL SQUARE
▬       U+25AC  [OtherSymbol]   BLACK RECTANGLE
▭       U+25AD  [OtherSymbol]   WHITE RECTANGLE
▮       U+25AE  [OtherSymbol]   BLACK VERTICAL RECTANGLE
▯       U+25AF  [OtherSymbol]   WHITE VERTICAL RECTANGLE
◰       U+25F0  [OtherSymbol]   WHITE SQUARE WITH UPPER LEFT QUADRANT
◱       U+25F1  [OtherSymbol]   WHITE SQUARE WITH LOWER LEFT QUADRANT
◲       U+25F2  [OtherSymbol]   WHITE SQUARE WITH LOWER RIGHT QUADRANT
◳       U+25F3  [OtherSymbol]   WHITE SQUARE WITH UPPER RIGHT QUADRANT
⬒       U+2B12  [OtherSymbol]   SQUARE WITH TOP HALF BLACK
⬓       U+2B13  [OtherSymbol]   SQUARE WITH BOTTOM HALF BLACK
⬔       U+2B14  [OtherSymbol]   SQUARE WITH UPPER RIGHT DIAGONAL HALF BLACK
⬕       U+2B15  [OtherSymbol]   SQUARE WITH LOWER LEFT DIAGONAL HALF BLACK
⬚       U+2B1A  [OtherSymbol]   DOTTED SQUARE
<U+2B1B>        U+2B1B  [OtherSymbol]   BLACK LARGE SQUARE
<U+2B1C>        U+2B1C  [OtherSymbol]   WHITE LARGE SQUARE
<U+2B1D>        U+2B1D  [OtherSymbol]   BLACK VERY SMALL SQUARE
<U+2B1E>        U+2B1E  [OtherSymbol]   WHITE VERY SMALL SQUARE
❏       U+274F  [OtherSymbol]   LOWER RIGHT DROP-SHADOWED WHITE SQUARE
❐       U+2750  [OtherSymbol]   UPPER RIGHT DROP-SHADOWED WHITE SQUARE
❑       U+2751  [OtherSymbol]   LOWER RIGHT SHADOWED WHITE SQUARE
❒       U+2752  [OtherSymbol]   UPPER RIGHT SHADOWED WHITE SQUARE
⁐	U+2050	[OtherPunctuation]	CLOSE UP
□	U+25A1	[OtherSymbol]	WHITE SQUARE
▢	U+25A2	[OtherSymbol]	WHITE SQUARE WITH ROUNDED CORNERS
▣	U+25A3	[OtherSymbol]	WHITE SQUARE CONTAINING BLACK SMALL SQUARE
▭	U+25AD	[OtherSymbol]	WHITE RECTANGLE
◯	U+25EF	[OtherSymbol]	LARGE CIRCLE
◻	U+25FB	[MathSymbol]	WHITE MEDIUM SQUARE
✅	U+2705	[OtherSymbol]	WHITE HEAVY CHECK MARK

