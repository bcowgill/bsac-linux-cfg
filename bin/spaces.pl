#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show spaces, tab, and carriage return/linefeed characters in standard input
# or from a file.
# see also filter-newlines.pl, filter-whitespace.pl, etc
# spaces.pl spacetest.txt
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English -no_match_vars;
use File::Slurp;
use open IN => ':raw';

sub show_spaces
{
	my ($content) = @ARG;
	$content =~ s{(.)}{
		my $ret = $1;
		if ($1 eq ' ')
		{
			$ret = '.';
		}
		elsif ($1 eq "\x09")
		{
			$ret = '\\t';
		}
		elsif ($1 eq "\x0d")
		{
			$ret = "CR";
		}
		elsif ($1 eq "\x0a")
		{
			$ret = "LF\n";
		}
		elsif ($1 eq "\x00")
		{
			$ret = '\\0';
		}
		$ret;
	}xmsge;
	print $content;
}

if (scalar(@ARGV))
{
	# filename given, open file with binary mode
	my $content = read_file($ARGV[0]);
	show_spaces($content);
}
else
{
	# no filename given, parsing standard input
	local $INPUT_RECORD_SEPARATOR = undef;
	show_spaces(<>);
}
