#!/bin/bash
# show a sample of unicode characters
# unicode-sample.sh -list | column -t | column


# U+00A0 = non breaking space &nbsp;
CODES="
U+00A0
U+2018 U+2019 U+201C U+201D
U+2026 U+00A9 U+00AE U+00BC U+00BD U+00BE
U+B0 U+2103 U+2109
U+00A3 U+20B5 U+20A4 U+20AC U+FF04 U+FE69 U+2367
U+2713 U+2714 U+2705
U+2715 U+2716 U+2717 U+2718 U+2719 U+274C
U+0277 U+0B50
U+0C94 U+0FD5
U+0FCA U+262F
U+1AA0
U+23F0
U+2460 U+2776
U+2603
U+2615 U+1F4B0
U+56CD U+2FF0 U+80B9 U+813D U+5C6A U+9280
U+2639 U+263A U+263B U+1F60E
U+2680 U+2681 U+2682 U+2683 U+2684 U+2685
U+1F305 U+1F307 U+1F31E U+1F33B
U+1F30E
U+1F341
U+1F197 U+1F198 U+1F192
U+24D8 U+24A4 U+26A0
U+2623
U+2622
U+2620
U+1F52B
U+1F4A3
U+1F4E9
U+1F4F2
U+1F4C2
U+1F4BB
U+0394
U+2610
U+274D
U+33D2
U+1F427
U+1F41B
U+1F446 U+1F447 U+1F448 U+1F449 U+1F44A U+1F44B U+1F44C U+1F44D U+1F44E U+1F44F
U+1F463
U+2741
U+23E9 U+2192 U+21A9 U+21AA U+21B6 U+21B7 U+21D0 U+21D2 U+2B00 U+21DC U+21DD
U+1F50D U+1F50E
"

# 😎 🍁 🆗
#
# 🍁	U+1F341
# 80B9 c*nt
# 813D a child's p*nis
# 5C6A p*nis
# 9280 cash

for code in $CODES
do
	echo $code `utf8.pl $code`
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
