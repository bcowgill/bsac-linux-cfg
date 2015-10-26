#!/usr/bin/env perl
# unicode-test.pl
# based on article http://perldoc.perl.org/perluniintro.html#Displaying-Unicode-As-Text

use strict;
use warnings;
use 5.012; # almost seamless utf
use feature 'unicode_strings'; # redundant with the 5.012 above
use charnames qw(:full); # needed for pre v5.16 for \N{UNICODE NAME}

use English qw(-no_match_vars);

print qq{\$PERL_VERSION: $PERL_VERSION [v5.6.0 first native unicode, v5.8.0+ recommended, v5.14.0 almost seamless, v5.16.0 quotemeta gotchas fixed, v5.22 full literal support]\n};
print qq{ENV PERL_UNICODE: @{[$ENV{PERL_UNICODE}||'']}\n};
print qq{\${^UNICODE}: @{[${^UNICODE}||'']}\n};
print qq{\${^OPEN}: @{[${^OPEN}||'']}\n};

# perl -C = -CSDL = -CIOEioL
# or PERL_UNICODE=""
# perl -C -e 'print qq{${^UNICODE}\n}'
binmode(STDIN,  ":encoding(utf8)"); # -CI
binmode(STDOUT, ":utf8"); # -CO
binmode(STDERR, ":utf8"); # -CE
# -Ci perlio utf8 on input
# -Co perlio utf8 on output
# -CL turn utf8 on/off based on locale env vars LC_ALL LC_TYPE or LANG

print "\nsome unicode from \\x{XX} notation:\n";
print "\x{DF} U+00DF LATIN SMALL LETTER SHARP S\n";
print "\x{0100} U+0100 LATIN CAPITAL LETTER A WITH MACRON\n";

my $idx = 0;
print "\nARGV unicode ?\n";
print (join("\n", map { "ARGV@{[$idx++]}: $ARG" } @ARGV), "\n");

print "\nENV SAMPLE_UNICODE is unicode enabled?\n";
print "[@{[$ENV{SAMPLE_UNICODE}||'']}]\n";

my $smiley_name = "WHITE SMILING FACE";
my $smiley_code_point = "U+263A";
my $smiley_from_name = "\N{WHITE SMILING FACE}";
my $smiley_from_code_point = "\N{U+263A}";

print "\nsome unicode from \\N{UNICODE NAME} and \\N{U+XXXX} literals\n";
print "$smiley_from_name from $smiley_name\n";
print "$smiley_from_code_point from $smiley_code_point\n";

my $smiley = $smiley_from_name;
print "\nregular expression matching\n";
print "regex literal name: " . ($smiley =~ /\N{WHITE SMILING FACE}/ ? "matched $smiley_name\n": "failed to match $smiley_name\n");
print "regex literal code point: " . ($smiley =~ /\N{U+263a}/ ? "matched $smiley_code_point\n": "failed to match $smiley_code_point\n");
# TODO regex match ARGV and SAMPLE_UNICODE

print "\nsome unicode from charnames::string_vianame() functions\n";
my $hebrew_alef_name = "HEBREW LETTER ALEF";
my $hebrew_alef_code_point = "U+05D0";
my $hebrew_alef_from_name = charnames::string_vianame($hebrew_alef_name);
my $hebrew_alef_from_code_point = charnames::string_vianame($hebrew_alef_code_point);
print "$hebrew_alef_from_name from $hebrew_alef_name\n";
print "$hebrew_alef_from_code_point from $hebrew_alef_code_point\n";

print qq{\nsome unicode from pack "U"\n};
my $smiley_from_pack = pack("U", 0x263A);
my $hebrew_alef_from_pack = pack("U", 0x05d0);
print qq{$smiley_from_pack from pack("U", 0x263A)\n};
print qq{$hebrew_alef_from_pack from pack("U", 0x05D0)\n};

print "\nget code point from characters\n";
print ord($smiley_from_code_point), " is code point for $smiley_from_code_point $smiley_name\n";
print ord($hebrew_alef_from_code_point), " is code point for $hebrew_alef_from_code_point $hebrew_alef_name\n";

print "\nlength() of combining unicode LATIN CAPITAL LETTER A + COMBINING ACUTE ACCENT\n";
print length("\N{LATIN CAPITAL LETTER A}\N{COMBINING ACUTE ACCENT}"), "\n";

print qq{\ntry these command lines:\n};
print qq{\nSAMPLE_UNICODE="ß U+00DF LATIN SMALL LETTER SHARP S" perl unicode-test.pl "ß U+00DF LATIN SMALL LETTER SHARP S" "Ā U+0100 LATIN CAPITAL LETTER A WITH MACRON" | tee unicode-test.out
\n};
print qq{\nSAMPLE_UNICODE="ß U+00DF LATIN SMALL LETTER SHARP S" perl -C unicode-test.pl "ß U+00DF LATIN SMALL LETTER SHARP S" "Ā U+0100 LATIN CAPITAL LETTER A WITH MACRON" | tee unicode-test.out
\n};
print "\nif unicode characters look wrong get GNU Unifont: http://unifoundry.com/unifont.html\n";

__END__

perl doc on English module
${^OPEN}
An internal variable used by PerlIO. A string in two parts, separated by a \0 byte, the first part describes the input layers, the second part describes the output layers.
This variable was added in Perl v5.8.0.

perldoc perlrun
-CSDL = I O E i o
binmode(STDIN,  ":encoding(utf8)"); # validates utf8 on input
binmode(STDIN,  ":utf8)"); # not safe, does not check valid utf8
binmode(STDOUT, ":utf8");
binmode(STDERR, ":utf8");

-C [number/list]
    The -C flag controls some of the Perl Unicode features.

    As of 5.8.1, the -C can be followed either by a number or a list
    of option letters.  The letters, their numeric values, and effects
    are as follows; listing the letters is equal to summing the
    numbers.

        I     1   STDIN is assumed to be in UTF-8
        O     2   STDOUT will be in UTF-8
        E     4   STDERR will be in UTF-8
        S     7   I + O + E
        i     8   UTF-8 is the default PerlIO layer for input streams
        o    16   UTF-8 is the default PerlIO layer for output streams
        D    24   i + o
        A    32   the @ARGV elements are expected to be strings encoded
                  in UTF-8
        L    64   normally the "IOEioA" are unconditional,
                  the L makes them conditional on the locale environment
                  variables (the LC_ALL, LC_TYPE, and LANG, in the order
                  of decreasing precedence) -- if the variables indicate
                  UTF-8, then the selected "IOEioA" are in effect
        a   256   Set ${^UTF8CACHE} to -1, to run the UTF-8 caching code in
                  debugging mode.

    For example, -COE and -C6 will both turn on UTF-8-ness on both
    STDOUT and STDERR.  Repeating letters is just redundant, not
    cumulative nor toggling.

The "io" options mean that any subsequent open() (or similar I/O
operations) in the current file scope will have the ":utf8" PerlIO
layer implicitly applied to them, in other words, UTF-8 is
expected from any input stream, and UTF-8 is produced to any
output stream.  This is just the default, with explicit layers in
open() and with binmode() one can manipulate streams as usual.

-C on its own (not followed by any number or option list), or the
empty string "" for the "PERL_UNICODE" environment variable, has
the same effect as -CSDL.  In other words, the standard I/O
handles and the default "open()" layer are UTF-8-fied but only if
the locale environment variables indicate a UTF-8 locale.  This
behaviour follows the implicit (and problematic) UTF-8 behaviour
of Perl 5.8.0.

SAMPLE_UNICODE="ß U+00DF LATIN SMALL LETTER SHARP S" perl unicode-test.pl "ß U+00DF LATIN SMALL LETTER SHARP S" "Ā U+0100 LATIN CAPITAL LETTER A WITH MACRON" | tee unicode-test.out
