#!/usr/bin/env perl
# An experiment in converting mathematical words and combinations into unicode character equivalents.
# ^x is a superscript x
# _x is a subscript x
# other words correspond to greek letters and operators
# echo PHI PSI del DELTA SIGMA gamma epsilon lamda mu pi rho dee epsilon phi int cross dot +- sum sqrt identical \<= \>= ^0 ^1 ^2 ^3 ^4 ^5 ^6 ^7 ^8 ^9 ^0 ^n _0 _1 _2 _3 _4 _5 _6 _7 _8 _9| math-rep.pl | utf8.pl

while (<STDIN>) {
    s{\^theta}{{U+1DBF}}xmsg;
    s{epsilon}{{U+1D6C6}}xmsg;
    s{epsilon}{{U+1D6DC}}xmsg;
    s{sigma}{{U+1D6D4}}xmsg;
    s{DELTA}{{U+1D6AB}}xmsg;
    s{3root}{{U+221B}}xmsg;
    s{4root}{{U+221C}}xmsg;
    s{SIGMA}{{U+1D6BA}}xmsg;
    s{gamma}{{U+1D6C4}}xmsg;
    s{theta}{{U+1D6AF}}xmsg;
    s{lamda}{{U+1D6CC}}xmsg;
    s{cross}{{U+2A2F}}xmsg;
    s{sqrt}{{U+221A}}xmsg;
    s{\^\+}{{U+207A}}xmsg;
    s{PHI}{{U+1D6BD}}xmsg;
    s{PSI}{{U+1D6BF}}xmsg;
    s{psi}{{U+1D6BF}}xmsg;
    s{del}{{U+1D6C1} }xmsg;
    s{rho}{{U+1D6D2}}xmsg;
    s{dee}{{U+1D6DB}}xmsg;
    s{phi}{{U+1D6DF}}xmsg;
    s{int}{{U+222B}}xmsg;
    s{dot}{{U+22C5}}xmsg;
    s{\+-}{{U+B1}}xmsg;
    s{sum}{{U+2211}}xmsg;
    s{\^0}{{U+2070}}xmsg;
    s{\^1}{{U+B9}}xmsg;
    s{\^2}{{U+B2}}xmsg;
    s{\^3}{{U+B3}}xmsg;
    s{\^4}{{U+2074}}xmsg;
    s{\^5}{{U+2075}}xmsg;
    s{\^6}{{U+2076}}xmsg;
    s{\^7}{{U+2077}}xmsg;
    s{\^8}{{U+2078}}xmsg;
    s{\^9}{{U+2079}}xmsg;
    s{\^i}{{U+2071}}xmsg;
    s{\^n}{{U+207F}}xmsg;
    s{mu}{{U+1D6CD}}xmsg;
    s{pi}{{U+1D6D1}}xmsg;
    s{==}{{U+2261}}xmsg;
    s{~=}{{U+2245}}xmsg;
    s{<=}{{U+2264}}xmsg;
    s{>=}{{U+2265}}xmsg;
    s{_0}{{U+2080}}xmsg;
    s{_1}{{U+2081}}xmsg;
    s{_2}{{U+2082}}xmsg;
    s{_3}{{U+2083}}xmsg;
    s{_4}{{U+2084}}xmsg;
    s{_5}{{U+2085}}xmsg;
    s{_6}{{U+2086}}xmsg;
    s{_7}{{U+2087}}xmsg;
    s{_8}{{U+2088}}xmsg;
    s{_9}{{U+2089}}xmsg;
    s{_i}{{U+1D62}}xmsg;

    print;
}
