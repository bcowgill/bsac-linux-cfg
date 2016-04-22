#!/usr/bin/env perl
# convert .ini file sections/values into inline section/value format so that it is easy to search for settings

use strict;
use English;

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
[section]
setting=value
setme=true

becomes

/section/setting=value
/section/setme=true
