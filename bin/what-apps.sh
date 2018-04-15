#!/bin/bash
# filter processes for apps of interest
pswide.sh | \
	egrep "node|grunt|perl|python|java|ruby|elixir|keep-it-up|auto-build|baloo_file_extractor|emacs|vim|nano" | \
	grep -v grep | \
	grep -v what-is-running | \
	grep -v cross-env | \
	what-is-running.pl | \
	sort | \
	perl -ne "print unless m{\A \s* \z}xms;#hidmehideme" | \
	grep -v hidmehideme


