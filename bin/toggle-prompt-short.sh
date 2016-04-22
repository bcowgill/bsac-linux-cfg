#!/bin/bash
# toggle the short prompt on/off
# source `which toggle-prompt-short.sh`
if [ -z "$PS1_SAVED" ]; then
	export PS1_SAVED="$PS1"
	export PS1="$PS1_SHORT"
	echo Prompt saved to PS1_SAVED and shortened.
else
	export PS1="$PS1_SAVED"
	export PS1_SAVED=""
	echo Prompt restored from PS1_SAVED.
fi
