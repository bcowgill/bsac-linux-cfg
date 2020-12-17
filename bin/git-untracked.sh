#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show only untracked files from git
# WINDEV tool useful on windows development machine
git status | perl -ne '
if (!$found) {
	$found = 1 if m{
		\A (Untracked \s files:)
	}xms
}
if (!$print && $found) {
	$print = 1 if m{\A \t}xms;
}
print if $print && m{\A \t}xms;
'
