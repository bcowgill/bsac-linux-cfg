#!/bin/bash
# Configure git to use winmerge/vscode or not
# git difftool --no-prompt filenane
# or
# git mergetool --no-prompt filename
#
# Using it on a merge:
# git merge something   indicates conflicts
# git mergetool

# Quick key reference for WinMerge
# Alt-F4         Exit
# F6             Change to other pane
# Alt-Up         Previous Diff
# Alt-Down       Next Diff
# Alt-Home       First Diff
# Alt-Enter      Current Diff
# Alt-End        Last Diff
# Alt-Right      Copy changes to right
# Alt-Left       Copy changes to left
# Ctrl-Alt-Right Copy changes to right and go to next diff
# Ctrl-Alt-Left  Copy changes to left andn go to next diff

# Best to add the winmerge and VS code directories to your path first.
# WINDEV tool useful on windows development machine
WINMERGE=`which winMergeU`
VSCODE=`which Code`
if [ -z $WINMERGE ]; then
	echo NOT OK Your path needs to contain the winMerge executable directory
	exit 1
fi
if [ -z $VSCODE ]; then
	echo NOT OK Your path needs to contain the MS Visual Studio Codee executable directory
	exit 1
fi
WINMERGE=winMergeU
VSCODE=Code
# https://manual.winmerge.org/en/Command_line.html
# /e close winmerge with Esc once
# /x close winmerge if files identical
# /u don't add L R files to MRU list
# /wl left side read only
# /wr right side read only
# /am auto-merge at the middle
OPTS="/e /x /u /wl /maximize"
OPTS3="$OPTS /wr /am"

if [ "x$1" == "xfalse" ]; then
	git config --global --unset diff.tool
	git config --global --unset difftool.prompt
	git config --global --unset difftool.winmerge.cmd
	git config --global --unset difftool.winmerge.trustExitCode
	git config --global --unset merge.tool
	git config --global --unset mergetool.prompt
	git config --global --unset mergetool.winmerge.cmd
	git config --global --unset mergetool.winmerge.trustExitCode
else
	git config --global diff.tool winmerge
	git config --global difftool.prompt false
	git config --global difftool.winmerge.trustExitCode false
	git config --global difftool.winmerge.cmd "$WINMERGE \"\$LOCAL\" \"\$PWD/\$REMOTE\" -- $OPTS"
	# use VS Code for diffing alternatively
	#git config --global difftool.winmerge.cmd "$VSCODE --new-window --wait --diff \"\$LOCAL\" \"\$PWD/\$REMOTE\""

	git config --global merge.tool winmerge
	git config --global mergetool.prompt false
	git config --global mergetool.winmerge.trustExitCode false
	# for versions which support left/middle/right panels
	#git config --global mergetool.winmerge.cmd "$WINMERGE \"\$PWD/\$LOCAL\" \"\$PWD/\$BASE\" \"\$PWD/\$REMOTE\" /o \"\$PWD/\$MERGED\" -- $OPTS3"
	# for versions which support a version control incomplete merge file
	#git config --global mergetool.winmerge.cmd "$WINMERGE \"\$PWD/\$MERGED\""
	# use VS Code instead of winmerge if it only supports left/right panels
	# https://code.visualstudio.com/docs/editor/command-line
	git config --global mergetool.winmerge.cmd "$VSCODE --new-window --wait \"\$PWD/\$MERGED\""
fi
git config --global --list

exit

diff.tool=winmerge
merge.tool=winmerge
difftool.winmerge.trustexitcode=false
difftool.winmerge.cmd=winMergeU "$LOCAL" "$PWD/$REMOTE" -- /e /x /u /wl /maximize
mergetool.winmerge.trustexitcode=false
mergetool.winmerge.cmd=Code "$PWD/$LOCAL" "$PWD/$BASE" "$PWD/$REMOTE" /o "$PWD/$MERGED" -- /e /x /u /wl /maximize /wr /am
mergetool.winmerge.cmd=Code --new-window --wait "$PWD/$MERGED"
