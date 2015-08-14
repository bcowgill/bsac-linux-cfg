#!/bin/bash
# filter processes for apps of interest
ps -ef | \
	egrep "node|grunt|perl|python|java|ruby|keep-it-up|auto-build|baloo_file_extractor" | \
	grep -v grep | \
	grep -v what-is-running | \
	what-is-running.pl | \
	sort | \
	perl -ne "print unless m{\A \s* \z}xms;#hidmehideme" | \
	grep -v hidmehideme


