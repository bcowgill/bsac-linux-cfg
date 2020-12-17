#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# convert unicode quotes to source code compatible quotes.
# WINDEV tool useful on windows development machine
# WIP work in progress TODO convert apostrophe in a string to unicode apostrophe
# i.e.     "I said: don't do that!"  'I said: don\'t do that!'
# becomes  'I said: don’t do that!'  letter \' letter
# also change double quotes to single quotes.

while (<>)
{
	tr[〝＂〞‟“”❝❞‘’❛❜][""""""""''''];
	print;
}

