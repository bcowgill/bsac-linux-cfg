#!/bin/bash
# Configure git to use diffmerge or not
# git difftool --no-prompt filenane
# or
# git mergetool --no-prompt filename

if [ "x$1" == "xfalse" ]; then
   git config --global --unset diff.tool
   git config --global --unset difftool.diffmerge.cmd
   git config --global --unset merge.tool
   git config --global --unset mergetool.diffmerge.trustExitCode
   git config --global --unset mergetool.diffmerge.cmd
else
   git config --global diff.tool diffmerge
   git config --global difftool.diffmerge.cmd "/usr/bin/diffmerge \"\$LOCAL\" \"\$REMOTE\""

   git config --global merge.tool diffmerge
   git config --global mergetool.diffmerge.trustExitCode true
   git config --global mergetool.diffmerge.cmd "/usr/bin/diffmerge --merge --result=\"\$MERGED\" \"\$LOCAL\" \"\$BASE\" \"\$REMOTE\""
fi
git config --global --list

