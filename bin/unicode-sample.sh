#!/bin/bash
# show a sample of unicode characters

CODES="U+00A3 U+00A9 U+00AE U+00BC U+00BD U+00BE U+0277 U+0B50
U+0C94 U+0FD5 U+0FCA U+1AA0 U+20B5 U+20A4 U+20AC U+2713 U+2714
U+2715 U+2716 U+2717 U+2718 U+2719 U+274C U+274D U+FF04 U+FE69
U+23F0 U+2367 U+23E9 U+2460 U+2622 U+2620 U+2603 U+262F U+2705
U+2776 U+2B00 U+56CD U+2FF0 U+2615 U+1F4B0 U+80B9 U+813D U+5C6A
U+9280"

# 80B9 c*nt
# 813D a child's p*nis
# 5C6A p*nis
# 9280 cash

for code in $CODES
do
	echo $code `utf8.pl $code`
done

echo "Lord of the Rings: 
            ⸬                   ⸬"
