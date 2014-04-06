#!/usr/bin/env perl
# summarize what is running with java or other things
# ps -ef | what-is-running.pl
# ps -ef | egrep "^($USER|`id -u`)" | what-is-running.pl 

use strict;
use English;

my $prefix = "___";
while (my $line = <>)
{
   $line = "${prefix}WEBSERVER $line\n" if $line =~ m{python .+ (SimpleHTTP|http\.server)}xms;
   $line = "${prefix}CHARLES PROXY $line"  if $line =~ m{java .+ -jar \s+ /usr/lib/charles-proxy/charles.jar}xms;

   print $line;
}

__END__

