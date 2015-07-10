#!/usr/bin/env perl
# summarize what is running with java or other things
# ps -ef | what-is-running.pl
# ps -ef | egrep "^($USER|`id -u`)" | what-is-running.pl 

use strict;
use English;

my $prefix = "___";
while (my $line = <>)
{
   $line = "${prefix}WEBSERVER     $line\n" if $line =~ m{python .+ (SimpleHTTP|http\.server)}xms;
   $line = "${prefix}CHARLES PROXY $line\n" if $line =~ m{java .+ -jar \s+ /usr/lib/charles-proxy/charles.jar}xms;
   $line = "${prefix}WEBSTORM IDE  $line\n" if $line =~ m{java .+ bcowgill/Downloads/WebStorm}xms;
   $line = "${prefix}KARMA         $line\n" if $line =~ m{node(js)? .+ karma \s* start}xms;
   $line = "${prefix}EXPRESS       $line\n" if $line =~ m{node(js)? .+ \./bin/www}xms;
   $line = "${prefix}DASHBOARD     $line\n" if $line =~ m{perl .+ infinity-plus-dashboard/bin/app\.pl}xms;
   $line = "${prefix}UPDAEMON      $line\n" if $line =~ m{perl .+ blis-location-uploadd.pl}xms;

   $line = "${prefix}AUTOBUILD     $line\n" if $line =~ m{auto-build\.sh}xms;
   $line = "${prefix}KEEP IT UP    $line\n" if $line =~ m{keep-it-up\.sh}xms;
   $line = "${prefix}BALOO         $line\n" if $line =~ m{baloo_file_extractor}xms;
   print $line;
}
__END__

