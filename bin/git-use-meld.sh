#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Configure git to use meld or not
# git difftool --no-prompt filenane
# or
# git mergetool --no-prompt filename
# https://stackoverflow.com/questions/43317697/setting-up-and-using-meld-as-your-git-difftool-and-mergetool-mac-syatem
#
# Using it on a merge:
# git merge something   indicates conflicts
# git mergetool
# WINDEV tool useful on windows development machine

MELD=`which meld`
if [ -z $MELD ]; then
	echo NOT OK meld is not installed.
fi

if [ "x$OSTYPE" == "xdarwin16" ]; then
	MELD="open -W -a Meld --args"
fi

if [ "x$1" == "xfalse" ]; then
	git config --global --unset diff.tool
	git config --global --unset difftool.prompt
	git config --global --unset difftool.meld.cmd
	git config --global --unset difftool.meld.trustExitCode
	git config --global --unset merge.tool
	git config --global --unset mergetool.prompt
	git config --global --unset mergetool.meld.cmd
	git config --global --unset mergetool.meld.trustExitCode
else
	git config --global diff.tool meld
	git config --global difftool.prompt false
	git config --global difftool.meld.trustExitCode true
	git config --global difftool.meld.cmd "$MELD \"\$LOCAL\" \"\$PWD/\$REMOTE\""

	git config --global merge.tool meld
	git config --global mergetool.prompt false
	git config --global mergetool.meld.trustExitCode true
	git config --global mergetool.meld.cmd "$MELD --auto-merge \"\$PWD/\$LOCAL\" \"\$PWD/\$BASE\" \"\$PWD/\$REMOTE\" --output=\"\$PWD/\$MERGED\""
fi
git config --global --list

exit

diff.tool=meld
difftool.prompt=false
difftool.meld.trustexitcode=true
difftool.meld.cmd=open -W -a Meld --args "$LOCAL" "$PWD/$REMOTE"
merge.tool=meld
mergetool.prompt=false
mergetool.meld.trustexitcode=true
mergetool.meld.cmd=open -W -a Meld --args --auto-merge "$PWD/$LOCAL" "$PWD/$BASE" "$PWD/$REMOTE" --output="$PWD/$MERGED"
