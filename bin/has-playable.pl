#!/usr/bin/env perl
# given an unplayable sound file name, check to see if a playable version also exists.
# ./find-unplayable.sh | has-playable.pl --not

use strict;
use warnings;
use Data::Dumper;
use FindBin;

my @Playable = qw(mp3 wav ogg);
my $SHOW_PLAYABLE = 1;
my $SHOW_UNPLAYABLE = 0;

sub usage
{
	my $cmd = $FindBin::Script;

	print <<"USAGE";
usage: $cmd [--not] [--both] [--help] < file-list

This will check each sound file from a list on standard input to see if a playable version of the file is present and prints the name of those found.

--not   prints out the name of the unplayable file if there are no playable ones found.
--both  prints out both the unplayable file and the associated playable ones.
--help  prints this help and terminates.

Playable sound file extensions are: @Playable

It will replace the sound file's extension with a playable one and look for that file.  If there is a directory matching the file extension in the sound file's path that will be replaced also with a playable extension and checked for a file.

For example:

Given the unplayable file:

here/m4a/somewhere/filename.m4a

The program will look for playable mp3 files named:

here/m4a/somewhere/filename.mp3
here/mp3/somewhere/filename.mp3
USAGE
	exit 1;
}

if (grep { $_ eq '--help' } @ARGV)
{
	usage();
}

if (grep { $_ eq '--not' } @ARGV)
{
	$SHOW_PLAYABLE = 0;
	$SHOW_UNPLAYABLE = 1;
}

if (grep { $_ eq '--both' } @ARGV)
{
	$SHOW_PLAYABLE = 1;
	$SHOW_UNPLAYABLE = 1;
}

while (my $file = <STDIN>)
{
	chomp($file);
	my $playable = 0;
	my $base = $file;
	$base =~ s{\.([^/\.]+)\z}{}xms;
	my $ext = $1;
	foreach my $try_ext (@Playable)
	{
		my $try_name = "$base.$try_ext";
		if ( -e $try_name)
		{
			$playable = 1;
			print qq{$try_name\n} if $SHOW_PLAYABLE;
		}
		if ($base =~ m{/$ext/}xms)
		{
			$try_name =~ s{/$ext/}{/$try_ext/}xms;
			if ( -e $try_name)
			{
				$playable = 1;
				print qq{$try_name\n} if $SHOW_PLAYABLE;
			}
		}
	}
	if ($playable == 0 || ($SHOW_PLAYABLE && $SHOW_UNPLAYABLE))
	{
		print qq{$file\n} if $SHOW_UNPLAYABLE;
	}
	print qq{\n} if $SHOW_UNPLAYABLE && $SHOW_PLAYABLE;
}
