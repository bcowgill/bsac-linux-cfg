#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# Configure git to use diffmerge or not
# git difftool --no-prompt filenane
# or
# git mergetool --no-prompt filename
# https://sourcegear.com/diffmerge/webhelp/sec__git__linux.html
#
# Using it on a merge:
# git merge something   indicates conflicts
# git mergetool

# /usr/bin/diffmerge
# WINDEV tool useful on windows development machine
DIFFM=`which diffmerge || which diffmerge.sh`
if [ -z $DIFFM ]; then
	echo NOT OK diffmerge is not installed.
fi
if which sgdm.exe; then
	DIFFM=git-diffmerge.sh
fi
if [ "x$OSTYPE" == "xdarwin16" ]; then
	DIFFM="/Applications/DiffMerge.app/Contents/MacOS/DiffMerge"
fi

if [ "x$1" == "xfalse" ]; then
	git config --global --unset diff.tool
	git config --global --unset difftool.diffmerge.cmd
	git config --global --unset merge.tool
	git config --global --unset mergetool.diffmerge.trustExitCode
	git config --global --unset mergetool.diffmerge.cmd
else
	git config --global diff.tool diffmerge
	git config --global difftool.diffmerge.cmd "$DIFFM --nosplash \"\$LOCAL\" \"\$REMOTE\""

	git config --global merge.tool diffmerge
	git config --global mergetool.diffmerge.trustExitCode true
	git config --global mergetool.diffmerge.cmd "$DIFFM --nosplash --merge --result=\"\$MERGED\" \"\$LOCAL\" \"\$BASE\" \"\$REMOTE\""
	if which sgdm.exe; then
		echo sgdm.exe
		git config --global difftool.diffmerge.cmd "git-diffmerge.sh \"\$LOCAL\" \"\$REMOTE\""
		git config --global mergetool.diffmerge.cmd "git-diffmerge-merge.sh --nosplash --merge --result=\"\$MERGED\" \"\$LOCAL\" \"\$BASE\" \"\$REMOTE\""
	fi
fi
git config --global --list

