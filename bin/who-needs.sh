#!/bin/bash
# Find out which packages need a particular package using package.json, package-lock.json or yarn.lock
# Useful for analysing nexus or sonatype security vulnerability reports.
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

WHICH=$1
# Most package.json files are indented 2 levels each so we are looking for second level indent of four spaces.
INDENT=${2:-4}

echo package.json:
grep -E 'ependencies|^\s+"'$WHICH package.json

if [ -e yarn.lock ]; then
	echo " "
	echo yarn.lock:
	grep -vE '^\s+(integrity|resolved)' yarn.lock \
		| grep -E '^("?@?\w|\s+"?'$WHICH')' \
		| WHICH=$WHICH perl -ne 'if (m[\A\s+"?$ENV{WHICH}]xms) { print qq{$last$_} } $last = $_;'
fi

if [ -e package-lock.json ]; then
	echo " "
	echo package-lock.json:
	grep -vE '"(integrity|resolved)"|}' package-lock.json \
		| INDENT=$INDENT perl -ne 'print if (s[\A\s{$ENV{INDENT}}][]xmsg);' \
		| grep -E '^("?@?\w+|\s+"?'$WHICH')' \
		| WHICH=$WHICH perl -ne 'if (m[\A\s+"?$ENV{WHICH}]xms) { print qq{$last$_} } $last = $_;'
fi

echo " "
echo Source Code:
git grep -lE "\\b$WHICH\\b" | grep -vE 'package(-lock)?.json|yarn.lock'

