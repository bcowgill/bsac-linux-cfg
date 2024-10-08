#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# See also fix-spaces.sh, fix-tabs.sh, strip-whitespace.sh
# WINDEV tool useful on windows development machine

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) filename

Strips the final newline from the named file.
"
	exit 0
fi

cp "$1" "$1.bak"
perl -ne 'chomp; push(@lines, $_); END { print join("\n", @lines) }' "$1.bak" > "$1"
