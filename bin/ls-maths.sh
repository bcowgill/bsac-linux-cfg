#!/bin/bash
# List all math symbols except for letters and numbers
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

# Examples:
# show javascript style unicode escape for unknown unicode codes.
# ls-maths.sh --text | LESSUTFBINFMT='\u%04lX' less
# ls-maths.sh --text | LESSUTFBINFMT='[?]' less

#set -x
MATH=~/bin/character-samples/samples/mathematics-categorised.txt
MATH_TEXT=~/bin/character-samples/samples/mathematics.txt

if [ "$1" == "--alpha" ]; then
	# Shows MATH alphabet characters
	unicode-alpha.sh
	OK=1
fi

if [ "$1" == "--text" ]; then
	# Shows MATH characters with greppable descriptions and example formatting / layout
	if [ -e "$MATH_TEXT" ]; then
		cat "$MATH_TEXT"
		OK=1
	fi
fi

if [ "$1" == "--code" ]; then
	# Shows categorised MATH characters understood by math-rep.pl
	if [ -e "$MATH" ]; then
		cat "$MATH"
		OK=1
	fi
fi

if [ "$1" == "--dot" ]; then
	# Shows various DOT characters, but not all...
	grep-utf8.sh dot | grep -viE 'braille|hebrew|hangul|tone|with.+dot|dotless|\bpunctuation|NonspacingMark|MathSymbol'
	OK=1
fi

if [ -z "$OK" ]; then
	# Shows various MATH characters but not the plain letters and numbers
	grep-utf8.sh math | grep -vE '(Uppercase|Lowercase|Other)Letter|DecimalNumber'
fi
