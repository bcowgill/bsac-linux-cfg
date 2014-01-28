#!/usr/bin/env perl
# summarize what is running with java
# ps -ef | what-is-running.pl

use strict;
use English;

while (my $line = <>)
{
   $line = "MODELLER $line\n" if $line =~ m{java .+ -launcher \s+ /home/brent.cowgill/modeller/modeller}xms;
   $line = "ECLIPSE $line\n"  if $line =~ m{java .+ -launcher \s+ /home/brent.cowgill/eclipse/eclipse}xms;
   $line = "CHARLES PROXY $line"  if $line =~ m{java .+ -jar \s+ /usr/lib/charles-proxy/charles.jar}xms;
   if ($line =~ m{-dev \s+ file:/home/brent.cowgill/workspace/.metadata/.plugins/org.eclipse.pde.core/([^/]+)/dev.properties}xms)
   {
      my $app = $1;
      if ($line =~ m{-agentlib:jdwp=transport=dt_socket,suspend=y,address=localhost}xms)
      {
         $line = "DEBUGGING $app\n";  
      }
      else
      {
         $line = "RUNNING $app\n";  
      }
   }

   print $line;
}
