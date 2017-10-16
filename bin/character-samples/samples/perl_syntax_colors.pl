#!/usr/bin/perl
# A sample perl file for testing syntax highlighting in your editor
# and code beautifier setup.

=head1 TITLE

=head1 Visual SlickEdit color configuration

=item programming syntax colors

 comment  - includes POD
 keyword  - if, else, $@ etc
 number
 string
 function
 preprocessor  - use strict and some others
 symbol1
 symbol2
 symbol3
 symbol4

=item user interface elements

 current line
 cursor
 no save line
 inserted line
 line number
 line prefix area
 message
 modified line
 selected current line
 selection
 status
 filename
 highlight
 attribute
 unknown XML element
 XHTML element in XSL

=cut

use strict;       # keyword (use)  preprocessor (strict)
use CGI;          # keyword
my ($x, $n);
$x = 1;
if ($x)
{
   $x = "double quoted literal string";  # string
   $x = 'single quoted literal string';
   $x = q{single quoted literal string};
   $x = qq{double quoted literal string};
   $x = `echo command literal string`;
   $x =~ /regex string/;
   $x = <<'HERE';
here document literal string
HERE

   $n = 42;   # number
   $n = 12.34213;
   $n = 6.02e23;
   $n = 6.02e-23;
   $n = 0755;
   $n = 1_234_235_565;

   my $x = function();    # function

   my ($variable, @variable, %variable) = @_;
   local *GLOB;
   $variable = \&function;
   open(GLOB, "<xlksdf");
   my $rh = { KEY => 'value', 'key' => 'value'};
   my $ra = [ 12, 23, 34];
}
else
{

}

sub function
{

}

1;        # number


