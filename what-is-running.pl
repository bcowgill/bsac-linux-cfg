#!/usr/bin/env perl
# summarize what is running with java or other things
# ps -ef | what-is-running.pl
# ps -ef | egrep "^($USER|`id -u`)" | what-is-running.pl 

use strict;
use English;

my $prefix = "___";
while (my $line = <>)
{
   $line = "${prefix}WEBSERVER $line\n" if $line =~ m{python .+ SimpleHTTP}xms;
   $line = "${prefix}MODELLER $line\n" if $line =~ m{java .+ -launcher \s+ /home/brent.cowgill/modeller/modeller}xms;
   $line = "${prefix}ECLIPSE $line\n"  if $line =~ m{java .+ -launcher \s+ /home/brent.cowgill/eclipse/eclipse}xms;
   $line = "${prefix}CHARLES PROXY $line"  if $line =~ m{java .+ -jar \s+ /usr/lib/charles-proxy/charles.jar}xms;
   if ($line =~ m{-dev \s+ file:/home/brent.cowgill/workspace/.metadata/.plugins/org.eclipse.pde.core/([^/]+)/dev.properties}xms)
   {
      my $app = $1;
      if ($line =~ m{-agentlib:jdwp=transport=dt_socket,suspend=y,address=localhost}xms)
      {
         $line = "${prefix}DEBUGGING $app\n";  
      }
      else
      {
         $line = "${prefix}RUNNING $app\n";  
      }
   }

   print $line;
}
