#!/bin/bash
U=tx/c/Users/FILEID
UB=$U/bin
B=tx/c/d/bin
mkdir -p $UB
mkdir -p $B

cp * .* $U

rm $U/to-lloyds.sh \
	$U/.bash_history \
	$U/.viminfo \
	$U/atom-* \
	$U/git_bash_aliases \
	$U/save-cfg.sh \
	$U/save-lloyds.sh \

perl -i -pne 's{C:/Program\s+Files/KDiff3}{C:/d/bin/kdiff3}xmsg' $U/.gitconfig

mv $U/clean.sh $UB
mv $U/kill-ws.sh $UB
mv $U/rvdiff.sh $UB
mv $U/vdiff.sh $UB
mv $U/see.sh $UB

cp ~/bin/cfg/git-aliases.sh $U

cp ~/bin/find-bak.sh \
	~/bin/test-one.sh \
	~/bin/cover-one.sh \
	~/bin/pee.pl \
	~/bin/filter-url.pl \
	~/bin/filter-script.pl \
	~/bin/filter-whitespace.pl \
	~/bin/calc.sh \
	~/bin/srep.sh \
	~/bin/replace.sh \
	~/bin/pswide.sh \
	~/bin/webserver.sh \
	~/bin/grep-vim.sh \
	~/bin/grep-lint.sh \
	~/bin/slay.sh \
	~/bin/ls-tabs.pl \
	~/bin/fix-tabs.sh \
	~/bin/fix-spaces.sh \
	~/bin/mad.sh \
	~/bin/sad.sh \
	~/bin/glad.sh \
	~/bin/task.sh \
	~/bin/xvdiff.sh \
	~/bin/waste.sh \
	~/bin/datestamp.sh \
	~/bin/git-rebase.sh \
	~/bin/git-slay-branch.sh \
	~/bin/git-new-branch.sh \
	~/bin/git-fetch-pull-request.sh \
	$B

md5sum.sh tx | tee md5sum.lst
exit $?
Sample Linux output with md5sum command...

Sample Mac output with md5 command...
MD5 (tx/c/Users/FILEID/my-git-tools.pl.txt) = e89e97204bc24676c32797b2eb01ff24
MD5 (tx/c/Users/FILEID/.bash_functions) = ee6bb991de53b138af8fb4d35c924dfe
MD5 (tx/c/Users/FILEID/kdiff3.config) = 04f17f4b4bbcb6253a4f88a3b5172f3e
MD5 (tx/c/Users/FILEID/bin/rvdiff.sh) = a353b39332938c43bd9d423db25d698c
