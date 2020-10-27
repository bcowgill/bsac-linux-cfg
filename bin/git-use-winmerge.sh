#!/bin/bash
# Configure git to use winmerge or not
# git difftool --no-prompt filenane
# or
# git mergetool --no-prompt filename
#
# Using it on a merge:
# git merge something   indicates conflicts
# git mergetool

WINMERGE=`which winMergeU`
# https://manual.winmerge.org/en/Command_line.html
# /e close winmerge with Esc once
# /x close winmerge if files identical
# /u don't add L R files to MRU list
# /wl left side read only
# /wr right side read only
# /am auto-merge at the middle

OPTS="/e /x /u /wl /maximize"
OPTS3="$OPTS /wr /am"
if [ -z $WINMERGE ]; then
	echo NOT OK winmerge is not installed.
fi

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

	git config --global merge.tool winmerge
	git config --global mergetool.prompt false
	git config --global mergetool.winmerge.trustExitCode false
	git config --global mergetool.winmerge.cmd "$WINMERGE \"\$PWD/\$LOCAL\" \"\$PWD/\$BASE\" \"\$PWD/\$REMOTE\" /o \"\$PWD/\$MERGED\" -- $OPTS3"
fi
git config --global --list

exit

diff.tool=winmerge
merge.tool=winmerge
difftool.winmerge.trustexitcode=false
difftool.winmerge.cmd=/home/me/bin/winMergeU "$LOCAL" "$PWD/$REMOTE" -- /e /x /u /wl /maximize
mergetool.winmerge.trustexitcode=false
mergetool.winmerge.cmd=/home/me/bin/winMergeU "$PWD/$LOCAL" "$PWD/$BASE" "$PWD/$REMOTE" /o "$PWD/$MERGED" -- /e /x /u /wl /maximize /wr /am
