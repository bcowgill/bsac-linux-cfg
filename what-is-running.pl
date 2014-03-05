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
   $line = "${prefix}MODELLER $line\n" if $line =~ m{java .+ -launcher \s+ /home/brent.cowgill/modeller}xms;
   $line = "${prefix}MODELLER $line\n" if $line =~ m{/home/brent\.cowgill/bin/java \s -Dosgi\.bundles=org\.eclipse\.equinox\.common}xms;

   $line = "${prefix}ECLIPSE $line\n"  if $line =~ m{java .+ -launcher \s+ /home/brent.cowgill/eclipse/eclipse}xms;
   $line = "${prefix}ECLIPSE $line\n"  if $line =~ m{/home/brent\.cowgill/workspace/jdk1\.7\.0_21/bin/java \s -Declipse\.ignoreApp=true}xms;
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

__END__
2001      6095  6092 78 11:53 pts/4    00:00:53 /home/brent.cowgill/bin/java -Dosgi.bundles=org.eclipse.equinox.common@2:start,org.eclipse.update.configurator@3:start,org.eclipse.core.runtime@start,org.eclipse.equinox.ds@3:start,com.ontologypartners.rdf@3:start,com.ontologypartners.ontopacks@start,org.apache.log4j@2:start,org.apache.commons.logging@2:start,com.ontologypartners.logging@3:start -Dosgi.console=1234 -Xmx2g -XX:PermSize=128m -XX:MaxPermSize=256m -Dlog4j.configuration=file:configuration/log4j.properties -Dfile.encoding=UTF-8 -XX:+UseCompressedOops -Ddebug.level=1 -Dcom.sun.management.jmxremote.port=8090 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dequinox.scr.dontDisposeInstances=true -Dequinox.scr.waitTimeOnBlock=30000000 -Dequinox.ds.block_timeout=30000000 -jar /home/brent.cowgill/modeller//plugins/org.eclipse.equinox.launcher_1.2.0.v20110502.jar -os linux -ws gtk -arch x86_64 -showsplash -launcher /home/brent.cowgill/modeller/modeller -name Modeller --launcher.library /home/brent.cowgill/modeller//plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.1.100.v20110505/eclipse_1407.so -startup /home/brent.cowgill/modeller//plugins/org.eclipse.equinox.launcher_1.2.0.v20110502.jar --launcher.overrideVmargs -exitdata 20460022 -data @noDefault -clean -vm /home/brent.cowgill/bin/java -vmargs -Dosgi.bundles=org.eclipse.equinox.common@2:start,org.eclipse.update.configurator@3:start,org.eclipse.core.runtime@start,org.eclipse.equinox.ds@3:start,com.ontologypartners.rdf@3:start,com.ontologypartners.ontopacks@start,org.apache.log4j@2:start,org.apache.commons.logging@2:start,com.ontologypartners.logging@3:start -Dosgi.console=1234 -Xmx2g -XX:PermSize=128m -XX:MaxPermSize=256m -Dlog4j.configuration=file:configuration/log4j.properties -Dfile.encoding=UTF-8 -XX:+UseCompressedOops -Ddebug.level=1 -Dcom.sun.management.jmxremote.port=8090 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dequinox.scr.dontDisposeInstances=true -Dequinox.scr.waitTimeOnBlock=30000000 -Dequinox.ds.block_timeout=30000000 -jar /home/brent.cowgill/modeller//plugins/org.eclipse.equinox.launcher_1.2.0.v20110502.jar

2001      6341  4643 99 11:54 ?        00:00:30 /home/brent.cowgill/workspace/jdk1.7.0_21/bin/java -Declipse.ignoreApp=true -Dosgi.noShutdown=true -Xmx6g -XX:+UseCompressedOops -XX:MaxPermSize=256m -Dlog4j.configuration=file:////home/brent.cowgill/workspace/trunk/features/com.ontologypartners.godel/rootfiles/configuration/log4j.properties -Dequinox.scr.dontDisposeInstances=true -Dcom.ontologypartners.location.input=file:////home/brent.cowgill/workspace/customer-data/current-data/,file:////home/brent.cowgill/workspace/customer-data/current-data/demo/ -Dcom.ontologypartners.location.output=file:////tmp/ontology/output/ -Dcom.ontologypartners.location.system=file:////tmp/ontology/system/ -Dequinox.scr.waitTimeOnBlock=60000000 -Dcom.sun.management.jmxremote.port=8099 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Dorg.openrdf.repository.debug=true -Dwicket.configuration=DEVELOPMENT -Dinfo.aduna.concurrent.locks.trackLocks=true -Dcom.ontologypartners.web.search.annotations.enabled=true -Dfile.encoding=UTF-8 -classpath /home/brent.cowgill/workspace/trunk/targets/eclipse/plugins/org.eclipse.equinox.launcher_1.2.0.v20110502.jar org.eclipse.equinox.launcher.Main -dev file:/home/brent.cowgill/workspace/.metadata/.plugins/org.eclipse.pde.core/Godel clean/dev.properties -configuration file:/home/brent.cowgill/workspace/.metadata/.plugins/org.eclipse.pde.core/Godel clean/ -console

