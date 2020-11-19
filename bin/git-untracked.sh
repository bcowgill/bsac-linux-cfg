#!/bin/bash
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
