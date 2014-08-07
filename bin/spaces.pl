#!/usr/bin/env perl
# show spaces, tab, and carriage return/linefeed characters in standard input
# spaces.pl spacetest.txt # MUSTDO test plan to test output

use strict;
use warnings;
use English;

while (<>) {
   s{\ }{.}xmsg;
   s{\t}{\\t}xmsg;
   s{\x0d\x0a}{CRLF\n}xmsg;
   s{\x0d}{CR\n}xmsg;
   s{\x0a}{LF\n}xmsg;
   print;
}
