#!/usr/bin/env perl
# ls-tt-tags.pl
# list template toolkit tags present within a file

# Usage:
# find all unique template toolkit blocks
# export LS_TT_TAGS_INLINE=1; find . -name '*.tt' -exec ls-tt-tags.pl {} \; | sort | uniq

# find template files and show markup with filename.
# export LS_TT_TAGS_ECHO=1; find . -name '*.tt' -exec ls-tt-tags.pl {} \;

use strict;
use warnings;
use English -no_match_vars;
local $INPUT_RECORD_SEPARATOR = undef; # slurp it all in

my $INLINE = $ENV{LS_TT_TAGS_INLINE} || 0; # convert multiline blocks into a single line for display
my $ECHO = $ENV{LS_TT_TAGS_ECHO} || 0; # echo the filename if only one on command line
my $INDENT = "";

if ($ECHO && scalar(@ARGV) == 1) {
   print "@ARGV\n";
   $INDENT = "   ";
}

my $content = <>;

# Template Toolkit markers look like so:
# [% DIRECTIVE .... %]
# [%# COMMENTED ... %]
# can also just be $obj.prop.subprop ...
# perhaps even $obj.$key ??
# but these can match some javascript so output not exact

$content =~ s{( \[ \% .+? \% \] | \$(\w|\.|\$)+ )}{
   my $match = $1;
   $match =~ s{\s+}{ }xmsg if $INLINE;
   $match =~ s{\n}{\n$INDENT}xmsg;
   print "$INDENT$match\n";
   ""
}xmsge;
