#!/bin/bash

if [ -z "$1" ]; then
	echo "
usage: $0 filename

Strips the final newline from the named file.
"
	exit 0
fi

cp "$1" "$1.bak"
perl -ne 'chomp; push(@lines, $_); END { print join("\n", @lines) }' "$1.bak" > "$1"