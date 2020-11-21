#!/usr/bin/env perl
# WINDEV tool useful on windows development machine

use strict;
use English;
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?] [file ...]

Convert .ini file sections/values into inline section/value format so that it is easy to search for settings.

file    files to process instead of standard input.
--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

Given a .ini file as follows:

[section]
setting=value
setme=true

This program will output:

/section/setting=value
/section/setme=true

See also ...

Example:

	Find the File View settings within the SourceGear DiffMerge configiration file.

	$FindBin::Script ~/.SourceGear\ DiffMerge | grep /File/View

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}


my $section = "//";
while (my $line = <>)
{
	$line =~ s{\A \s*}{}xms;
	if ($line =~ m{\A \s* \[ \s* ( [^\]]+ ) \s* \] \s* \z}xms)
	{
		$section = $1;
	}
	else
	{
		print "/$section/$line";
	}
}

__END__
