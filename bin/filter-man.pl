#!/usr/bin/env perl
# filter out man page magic characters

my $ESC = '';
my $BS  = '';

while (<>) {
	s{$ESC \[ [01]m }{}xmsg;
	s{.}{}xmsg;
	print;
}