#!/usr/bin/perl
# $Id: char_table.pl,v 1.1 2006/01/15 12:55:32 me Exp $
# Generate an ASCII character set table in HTML
# for a specific font face

use strict;
use warnings;
my $font_face = 'Open Symbol';
my $font_name = $font_face;
my $font_description = "Symbols";
my $font_file = "";
my $font_x    = "-adobe-symbol-medium-r-normal--10-100-75-75-p-61-adobe-fontspecific";

my $font = qq|<font face="$font_face">|;

my $title = "ASCII Table for font $font_name\n";
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
<tr align='center'>
<th>&nbsp;</th>@{[join("", map {"<th>$_</th>"} (0 .. 9, 'A' .. 'F'))]}
</tr>
HEADER

foreach my $high (0 .. 9, 'A' .. 'F')
{
   print "<tr align='center'>\n<th>$high&nbsp; : &nbsp;</th>";
   foreach my $low (0 .. 9, 'A' .. 'F')
   {
      my $hex = "$high$low";
      my $ascii = hex_to_dec($hex);
      my $hex_html = "&#$ascii;";
      $hex_html = ' ' if $hex eq '00';
      print "<td>$font$hex_html</font></td> ";
   }
   print "\n</tr>\n";
}
print <<"FOOTER";
</table>
</body>
</html>
FOOTER

# hex_to_dec("20AC3C7E45A4") = 35924121372068
sub hex_to_dec
{
   my ($hex) = @_;
   return hex($hex);
}


