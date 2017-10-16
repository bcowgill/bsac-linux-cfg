#!/usr/bin/perl
# $Id: char_list.pl,v 1.1 2006/01/15 12:55:32 me Exp $
# generate a list of ASCII characters and their common names

use strict;
use warnings;
#x();
for my $ascii (0 .. 255) {
   my $hex = any_to_hex($ascii);
   $ascii = pad($ascii);
   my $char = chr($ascii);
   print "$ascii $hex >$char<\n";
#   print "$ascii $hex >$char< @{[ascii_name($hex)]}\n";
}

BEGIN {
   my %ASCIINames = map { split(/\|/, $_) } (
      '00|Null                   - Control @',
      '01|SOH - Start Heading    - Control A',
      '02|STX - Start of Text    - Control B',
      '03|ETX - End of Text      - Control C',
      '04|EOT - End Transmit     - Control D',
      '05|ENQ - Enquiry          - Control E',
      '06|ACK - Acknowledge      - Control F',
      '07|BEL - Beep             - Control G',
      '08|BS  - Backspace        - Contro H',
      '09|HT  - Horizontal Tab   - Control I',
      '0A|LF  - Line Feed        - Control J',
      '0B|VT  - Vertical Tab     - Control K',
      '0C|FF  - Form Feed        - Control L',
      '0D|CR  - Carriage Return  - Control M',
      '0E|SO  - Shift Out        - Control N',
      '0F|SI  - Shift In         - Control O',
      '10|DLE - Device Link Esc  - Control P',
      '11|DC1 - Dev Cont 1 X-ON  - Control Q',
      '12|DC2 - Dev Cont 2       - Control R',
      '13|DC3 - Dev Cont 3 X-OFF - Control S',
      '14|DC4 - Dev Cont 4       - Control T',
      '15|NAK - Negative Ack     - Control U',
      '16|SYN - Synchronous idle - Control V',
      '17|ETB - End Tran Block   - Control W',
      '18|CAN - Cancel           - Control X',
      '19|EM  - End Medium       - Control Y',
      '1A|SUB - Substitute       - Control Z',
      '1B|ESC - Escape           - Control [',
      '1C|FS  - Cursor Right     - Control /',
      '1D|GS  - Cursor Left      - Control ]',
      '1E|RS  - Cursor Up        - Control ^',
      '1F|US  - Cursor Down      - Control -',
   );
   sub ascii_name {
      my ($hex) = @_;
      
      return exists($ASCIINames{$hex}) ? "| $ASCIINames{$hex}" : "";
   }
sub x { use Data::Dumper; print Dumper(\%ASCIINames);
}
}

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

sub pad 
{
   my ($number, $width) = @_;
   $width = 3 unless defined($width);
   return (" " x ($width - length($number))) . $number
}
