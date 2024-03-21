#!/bin/bash
CNT=counter
echo Fix $CNT: N sequence in a .spec.js file so screenshots are in numbered order.

CNT=$CNT perl -i -pne '
	$counter += 0;
	$changes += 0;
	$save = $_;
	if (s{($ENV{CNT}:)\s*\d+}{$1 $counter}xmsg)
	{
		++$counter;
	}
	$changes++ unless $_ eq $save;
	END
	{
		print "Fixed $changes of $counter $ENV{CNT}: lines in test files.\n";
	}
' $*
