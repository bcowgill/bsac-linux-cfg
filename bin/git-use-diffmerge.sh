#!/bin/bash
# Configure git to use diffmerge or not
# git difftool --no-prompt filenane
# or
# git mergetool --no-prompt filename
# https://sourcegear.com/diffmerge/webhelp/sec__git__linux.html
#
# Using it on a merge:
# git merge something   indicates conflicts
# git mergetool

if [ "x$1" == "xfalse" ]; then
	git config --global --unset diff.tool
	git config --global --unset difftool.diffmerge.cmd
	git config --global --unset merge.tool
	git config --global --unset mergetool.diffmerge.trustExitCode
	git config --global --unset mergetool.diffmerge.cmd
else
	git config --global diff.tool diffmerge
	git config --global difftool.diffmerge.cmd "/usr/bin/diffmerge --nosplash \"\$LOCAL\" \"\$REMOTE\""

	git config --global merge.tool diffmerge
	git config --global mergetool.diffmerge.trustExitCode true
	git config --global mergetool.diffmerge.cmd "/usr/bin/diffmerge --nosplash --merge --result=\"\$MERGED\" \"\$LOCAL\" \"\$BASE\" \"\$REMOTE\""
	if which sgdm.exe; then
		echo sgdm.exe
		git config --global difftool.diffmerge.cmd "git-diffmerge.sh \"\$LOCAL\" \"\$REMOTE\""
		git config --global mergetool.diffmerge.cmd "git-diffmerge-merge.sh --nosplash --merge --result=\"\$MERGED\" \"\$LOCAL\" \"\$BASE\" \"\$REMOTE\""
	fi
fi
git config --global --list

