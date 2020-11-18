#!/bin/bash
# display only https?:// URLs from standard input and display on standard error
# WINDEV tool useful on windows development machine
perl -ne '
	my ($q, $Q) = (chr(39), chr(34));
#		(https?://\S+?)[$q$Q]?
	s{
		(https?://[^\s$q$Q]+)
	}{
		print STDERR "$1\n"
	}xmsge;'

