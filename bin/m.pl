#!/usr/bin/env perl

# some simple math markup for writing equations, simpler than math-rep.pl

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use English qw(-no_match_vars);
use charnames qw(:full); # :loose if you perl version supports it
use FindBin;

use Data::Dumper;

binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE

#my $sp = "\x{2004}"; # 3 per em space
my $sp = "";

while (<>) {
s{epsilon}{\x{1D774}}xmsg;
s{\^theta}{\x{1DBF}}xmsg;
s{theta}{\x{3B8}}xmsg;
s{sigma}{\x{3C3}}xmsg;
s{SIGMA}{\x{2211}}xmsg;
s{gamma}{\x{1D6C4}}xmsg;  # MATHEMATICAL BOLD SMALL GAMMA
s{delta}{\x{1D6C5}}xmsg;
s{cross}{\x{2A2F}}xmsg;
s{3root}{\x{221B}}xmsg;
s{4root}{\x{221C}}xmsg;
s{sqrt}{\x{221A}}xmsg;
s{hbar}{\x{210F}$sp}xmsg;
#s{hbar}{h/2pi}xmsg
#s{dee}{\x{1D41D}}xmsg;
s{dee}{\x{1D485}}xmsg;
#s{dee}{\x{1D6DB}}xmsg;
s{dot}{\x{22C5}}xmsg;
s{psi}{\x{1D6D9}$sp}xmsg;
s{del}{\x{1D6C1}}xmsg;
s{sum}{\x{2211}}xmsg;
s{phi}{\x{1D6D7}}xmsg;
s{rho}{\x{1D6D2}}xmsg;
s{1/3}{\x{2153}}xmsg;
s{int}{\x{222B}}xmsg;
s{pi}{\x{1D6D1}}xmsg;
s{\^\+}{\x{207A}}xmsg;
s{\^7}{\x{2077}}xmsg;
s{\^4}{\x{2074}}xmsg;
s{\^2}{\x{B2}}xmsg;
s{\^1}{\x{B9}}xmsg;
s{\^i}{\x{2071}}xmsg;
s{\^n}{\x{207F}}xmsg;
s{\^x}{\x{2E3}}xmsg;
s{_i}{\x{1D62}}xmsg;
s{_n}{\x{2099}}xmsg;
s{==}{\x{2261}}xmsg;
s{~=}{\x{2243}}xmsg;
s{mu}{\x{1D6CD}}xmsg;
s{>=}{\x{2265}}xmsg;
s{<=}{\x{2264}}xmsg;
s{\+-}{\x{B1}}xmsg;
print;
}
