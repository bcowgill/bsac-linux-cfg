#!/usr/bin/perl
# $Id: char_table_utf8.pl,v 1.1 2006/01/15 12:55:32 me Exp $
# Generate a utf8 character set table in HTML
# for a specific font face

use strict;
use warnings;
my $font_face = 'Open Symbol';
my $font_name = $font_face;
my $font_description = "Symbols";
my $font_file = "";
my $font_x    = "-adobe-symbol-medium-r-normal--10-100-75-75-p-61-adobe-fontspecific";

my $font = qq|<font face="$font_face">|;

my $title = "Unicode Table for font $font_name\n";
my $meta = qq|<meta http-equiv="content-type" content="text/html; charset=utf-8">|;

print <<"HEADER";
<html>
<head>
<title>$title</title>
$meta
</head>
<body>
<h1>$title</h1>
<p><b>$font_description</b></p>
<p>file: $font_file</p>
<p>x-font: $font_x</p>
<table>
HEADER

my @characters = qw(
   0152 0153 0160 0161 0178 017D 017E 0192 019B
   02C6 02D9 02DA 02DC 03F1 2010 2013 2014
   2018 2019 201A 201C 201D 201E 2020 2021
   2022 2026 2030 2039 203A 20A1 20A2 20A3
   20A4 20A8 20A9 20AB 20AC 2102 2107 210A
   210F 2111 2112 2113 2115 2118 211A 211C
   211D 2122 2124 2127 2130 2131 2135 2190
);

my $idx = 0;
while ($idx < scalar(@characters))
{
   print "<tr align='center'>\n";
   foreach my $col (0 .. 9, 'A' .. 'F')
   {
      my ($hex, $hex_html);
      if ($idx < scalar(@characters))
      {
         $hex_html = hex_to_unicode($characters[$idx]);
         $hex = 'u' . $characters[$idx];
      }
      else
      {
         $hex = '&nbsp;';
         $hex_html = '&nbsp;';
      }
      print "<th>$hex</th><td>$font$hex_html</font></td> ";
      $idx++;
   }
   print "\n</tr>\n";
}

print <<"FOOTER";
</table>
</body>
</html>
FOOTER

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


