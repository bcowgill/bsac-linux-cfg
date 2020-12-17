#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# toggle the prompt on/off
# source `which toggle-prompt.sh`
# WINDEV tool useful on windows development machine
if [ -z "$PS1_SAVED" ]; then
	export PS1_SAVED="$PS1"
	export PS1="> "
	echo Prompt saved to PS1_SAVED and simplified.
else
	export PS1="$PS1_SAVED"
	export PS1_SAVED=""
	echo Prompt restored from PS1_SAVED.
fi
