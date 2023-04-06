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
	~/bin/zip64.pl \
	~/bin/md5sum.sh \
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
