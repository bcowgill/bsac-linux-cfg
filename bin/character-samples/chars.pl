#!/usr/bin/perl
# $Id: chars.pl,v 1.1 2006/01/15 12:55:32 me Exp $
# functions for character, hex, decimal conversions

use strict;
use warnings;

print join(
   "\n", 
   unicode_char("UFEFF"), # Byte Order Mark
   unicode_char("U20AC") =~ /\x{20ac}/, # Euro
   unicode_char("U20AC"), # Euro
   unicode_char("U-263A"), # Smiley
   unicode_char("&#163;"), # Pound
   unicode_char("&#xA3;"), # Pound
   dec_to_hex(8364),
   dec_to_unicode(8364),  # unicode euro character
   hex_to_unicode(dec_to_hex(8364)),
   any_to_hex('32'),   # decimal 
   any_to_hex('66'),   # decimal 
   any_to_hex('0666'), # octal
   any_to_hex('0x3c7e'), # hex
   any_to_hex('0b0011110001111110'), # binary

   dec_to_hex(229),
   byte_to_hex("0"),
   data_to_hex("http://"),
   data_and_hex_lines("http://"),

   hex_to_byte("3"),    # pads to 03
   hex_to_byte("2056"), # loses second byte
   hex_to_byte("30"),
   hex_to_byte("A2"),   # ASCII cents symbol
   hex_to_byte("A3"),   # ASCII pound symbol
   hex_to_byte("A5"),   # ASCII yen symbol

   hex_to_data("3"),
   hex_to_data("687474703A2F2F"),

   hex_to_data("00A2"), # unicode cents symbol
   hex_to_data("00A3"), # unicode pound symbol
   hex_to_data("00A5"), # unicode yen symbol
   hex_to_data("20A4"), # unicode pound symbol
   hex_to_data("20A0"), # unicode ecu symbol (not widely used, not euro)
   hex_to_data("20AC"), # unicode euro symbol (european monetary union)

   hex_to_dec("20AC"),
   hex_to_dec("20AC3C7E"),
#   hex_to_dec("20AC3C7E45A4"),  # hex overflow

   hex_to_binary("2056"), # loses second byte
   hex_to_octal("156"),

   hex_to_unicode("00A3"),

);
print "\n";

# any_to_hex('66') = '42'       # decimal 
# any_to_hex('0666') = '01B6'    # octal
# any_to_hex('0x3c7e') = '3C7E' # hex
# any_to_hex('0b0011110001111110') = '3C7E' # binary
sub any_to_hex
{
   my ($any) = @_;
   return dec_to_hex($any =~ /^0/ ? oct($any) : $any);
}

# dec_to_hex(229) = 'E5'
sub dec_to_hex
{
   my ($decimal) = @_;
   my $hex = sprintf("%lX", $decimal);
   $hex = "0$hex" if length($hex) % 2 == 1;
   return $hex;
}

# byte_to_hex("0") = '30'
sub byte_to_hex
{
   my ($byte) = @_;
   return uc(unpack("H2", $byte));
}

# data_to_hex('http://') = '687474703A2F2F'
sub data_to_hex
{
   my ($data) = @_;
   return unpack("H*", $data);
}

# data_and_hex_lines('http://') =
# ( ' h t t p : / /',
#   '687474703A2F2F' )
sub data_and_hex_lines
{
   my ($data) = @_;
   my $hex = data_to_hex($data);
   $data =~ s/(.)/ $1/g;
   return ($data, $hex);
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

sub hex_to_binary
{
   my ($hex) = @_;
   return unpack("B*", hex_to_data($hex));
}

sub hex_to_octal
{
   my ($hex) = @_;
   my $odd_hex = (length($hex) % 2) == 1;
   my $binary = hex_to_binary($hex);
   $binary =~ s/^0000// if $odd_hex;
   my $remainder = length($binary) % 3;
   $binary = ('0' x (3 - $remainder)) . $binary if ($remainder);
   $binary =~ s/(...)/substr(any_to_hex("0b$1"),1,1)/ge;
   return $binary;
}

# hex_to_data("687474703A2F2F") = 'http://'
sub hex_to_data
{
   my ($hex) = @_;
   $hex = "0$hex" if length($hex) %2 == 1;
   return pack("H*", $hex);
}

sub dec_to_unicode
{
   my ($dec) = @_;
   return pack("U", $dec);
}

sub hex_to_unicode
{
   my ($hex) = @_;
   return pack("U", hex_to_dec($hex));
}

sub unicode_char
{
   my ($code) = @_;
   # U20AC u-20AC U+20AC
   $code = $1 if $code =~ /^U[-+]?([0-9A-F]+)$/i;
   # &#20AC; &#20AC  XML/HTML hex
   $code = $1 if $code =~ /^&#x([0-9A-F]+);?$/i;
   # \x{20AC} perl
   $code = $1 if $code =~ /^\\x\{([0-9A-F]+)\}$/i;
   # \u20AC 
   $code = $1 if $code =~ /^\\x([0-9A-F])$/i;
   # &#8364; &#8364  XML/HTML decimal
   $code = dec_to_hex($1) if $code =~ /^&#(\d+);?$/i;
   return hex_to_unicode($code);
}
