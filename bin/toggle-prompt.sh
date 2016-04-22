#!/bin/bash
# toggle the prompt on/off
# source `which toggle-prompt.sh`
if [ -z "$PS1_SAVED" ]; then
	export PS1_SAVED="$PS1"
	export PS1="> "
	echo Prompt saved to PS1_SAVED and simplified.
else
	export PS1="$PS1_SAVED"
	export PS1_SAVED=""
	echo Prompt restored from PS1_SAVED.
fi
