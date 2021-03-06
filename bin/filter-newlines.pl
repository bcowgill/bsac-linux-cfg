#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# spaces.pl spacetest.txt
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English -no_match_vars;
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [file...]

Filter any OS newline characters from standard input or files and replace with system newlines.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

This will find Unicode Next Line (NEL), Carriage Return + Line Feed (CRLF), Carriage Returns (CR), or Line Feeds (LF) and replace them with the current system's newline character.

See also filter-whitespace.pl, spaces.pl, fix-spaces.sh, fix-tabs.sh

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

while (my $line = <>)
{
	# Unicode Next Line NEL, CRLF, CR, or LF
	$line =~ s{(\x{0085}|\x0d\x0a|\x0d|\x0a)}{\n}xmsg;
	print $line;
}
