#!/bin/bash
# Display a specifically numbered item from the dpkg control files.
# sort-dctrl -k Installed-Size:rv /var/lib/dpkg/available | dctrl-item.sh 10
# grep-dctrl -F Package atom /var/lib/dpkg/available | dctrl-item.sh

ITEM="$1" perl -ne '
	if (m{\APackage:}xms)
	{
		++$found;
		if ($found > ($ENV{ITEM} || 0))
		{
			print "Index: @{[$found-1]}\n";
			$show = 1;
		}
	}
	print if $show;
	if (m{\A\s*\z}xms)
	{
		exit if $show;
	}
'
