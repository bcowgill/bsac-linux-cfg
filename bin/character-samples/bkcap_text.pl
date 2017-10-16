#!/usr/bin/perl
# $Id: bkcap_text.pl,v 1.1 2006/01/15 12:55:31 me Exp $

# Output the raw byte codes for the BKCap font
# for outputing keyboard keys

# ./bkcap_text.pl < keyboard.txt > keyboard_keys.txt

use strict;
use warnings;

my %CharMap =
qw(
   [F1]  A1   [F2]  99  [F3]  A3  [F4]  A2
   [F5]  221E [F6]  A7  [F7]  B6  [F8]  95
   [F9]  AA   [F10] BA  [F11] 96  [F12] 2260
   [F13] 93   [F14] 91  [F15] AB

   [ALT]         61   [RETURN] 62   [CAPSLOCK] 63
   [PRTSC]       64   [ENTER]  65   [INS]      66
   [SCROLLLOCK]  67   [HOME]   68   [UP]       69
   [LEFT]        6A   [DOWN]   6B   [RIGHT]    6C
   [DELETE]      6D   [BACKSPACE]   6E   [OPTION]   6F
   [PAUSE]       70   [SHIFT]  71   [PAGEDOWN] 72
   [ESC]         73   [TAB]    74   [END]      75
   [CONTROL]     76   [HELP]   77   [CHAR]     78
   [DEL]         79   [APPLE]  7A   [ZERO]     82
   [ENTERV]      89   [FACE]   AE   [CTRL]     C7
   [SPACEBAR]    A0
   [APPLEFILLED] DB   [EMPTY]  DF   [CLEAR]    E7
   [PGUP]        02DA [APPLECHAR]   03A9
   [PAGEUP]      03C0 [ZERO2]       201A
   [ENTERV2]     2030
   [BSARROW]     2202 [PGDN]    2206
   [NUMLOCK]     221A [XARROW]  2248
);

while (<>)
{
   s/(\[[A-Z0-9]+\])/character($1)/gex;
   print;
}

sub character
{
   my ($char) = @_;
   return $char unless (exists($CharMap{$char}));
   $char = $CharMap{$char};
   if (length($char) == 4)
   {
       return hex_to_unicode($char);
   }
   return hex_to_byte($char);
}

sub hex_to_unicode
{
   my ($hex) = @_;
   return pack("U", hex_to_dec($hex));
}

# hex_to_dec("20AC3C7E45A4") = 35924121372068
sub hex_to_dec
{
   my ($hex) = @_;
   return hex($hex);
}

# hex_to_byte("30") = '0'
sub hex_to_byte
{
   my ($hex) = @_;
   $hex = "0$hex" if length($hex) %2 == 1;
   return pack("H2", $hex);
}

