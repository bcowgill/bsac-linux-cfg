#!/bin/bash
# show only untracked files from git
git status | perl -ne '
if (!$found) {
	$found = 1 if m{
		\A (Untracked \s files:)
	}xms
}
if (!$print && $found) {
	$print = 1 if m{\A \t}xms;
}
print if $print && !m{
	no \s changes \s added \s to \s commit
}xms;
'
