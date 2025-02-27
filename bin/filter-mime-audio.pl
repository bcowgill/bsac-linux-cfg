#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine

use strict;
use warnings;
use English qw(-no_match_vars);
use FindBin;

sub usage
{
	my $cmd = $FindBin::Script;
	print <<"USAGE";
$cmd [--help|--man|-?] [file...]

This will filter a list of file names using the file command to filter out anything that is not an audio file.

file    optional name of a file containing the list of file names to filter.
--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Will filter standard input if file names are omitted.  Using the file command identifies files by mime type instead of just by file extension and empty files will also be filtered out.

See also file, filter-sounds.sh, filter-videos.sh

Example:

Use find command and then filter to find audio files.

	find . -iname '*.mp3' -o -iname '*.ogg' | filter-mime-audio.pl

Use locate database and filer-music to get a list of possible sound files then filter them by mime type and create a Play list for cmus command.

	locate -i --regex [aeiou] | filter-music | filter-mime-audio.pl > ~/.cmus/all-sounds.pl
USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my $DEBUG = 0;

while (my $line = <>)
{
	my $q = chr(39);
	chomp($line);
	# Handle files with an apostrophe in them...
	my $filename = $line;
	$filename =~ s{$q}{$q"$q"$q}xmsg;
	my $mime = `file $q$filename$q`;
	my $original = $mime;
	print STDERR $mime if $DEBUG;
	$mime =~ s{\A[^:]+:\s*}{}xms;
	next if $mime =~ m{\A\s*(directory|data|empty)\s*\z}xmsi;
	next if $mime =~ m{\b(executable|relocatable|symbolic\s+link\s+to|(ASCII|Unicode(\s+\(with\s+BOM\))?|8859)\s+text)\b}xmsi;
	#print STDERR $original unless $DEBUG;
	print "$line\n" if $mime =~ m{\b(audio|mpeg|midi|stereo|microsoft asf|video)\b}xmsi;
}
