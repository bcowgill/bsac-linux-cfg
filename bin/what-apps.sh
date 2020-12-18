#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
# filter processes for apps of interest
# See also watch-apps.sh, what-is-running.pl, watcher.sh
pswide.sh | \
	egrep "node|grunt|perl|python|java|ruby|elixir|keep-it-up|auto-build|baloo_file_extractor|emacs|vim|nano|ezbackup|mount|/dev/" | \
	grep -v grep | \
	grep -v what-is-running | \
	grep -v cross-env | \
	what-is-running.pl | \
	sort | \
	perl -ne "print unless m{\A \s* \z}xms;#hidmehideme" | \
	grep -v hidmehideme


