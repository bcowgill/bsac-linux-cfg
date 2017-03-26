#!/usr/bin/env perl
# convert unicode quotes to source code compatible quotes.

while (<>)
{
	tr[〝＂〞‟“”❝❞‘’❛❜][""""""""''''];
	print;
}

