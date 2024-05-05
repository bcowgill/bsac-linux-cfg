#!/bin/bash
U=tx/c/Users/FILEID
UB=$U/bin
B=tx/c/d/bin

rm -rf tx/c
rm -rf bundle
mkdir bundle
mkdir -p $UB
mkdir -p $B/playwright

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

cp ~/bin/cfg/git-aliases.sh \
	~/bin/template/javascript/react-maintainable-code.txt \
	~/bin/template/cfgrec/windows-keyref.txt \
	$U

unicode-sample.sh > $U/unicode-sample.txt

cp ~/bin/find-bak.sh \
	~/bin/check-code.sh \
	~/bin/test-one.sh \
	~/bin/cover-one.sh \
	~/bin/pee.pl \
	~/bin/filter-url.pl \
	~/bin/filter-script.pl \
	~/bin/filter-whitespace.pl \
	~/bin/filter-long.sh \
	~/bin/filter-coverage.sh \
	~/bin/filter-bak.sh \
	~/bin/filter-built-files.sh \
	~/bin/filter-code-files.sh \
	~/bin/filter-configs.sh \
	~/bin/filter-css.sh \
	~/bin/filter-fonts.sh \
	~/bin/filter-indents.sh \
	~/bin/filter-json-commas.sh \
	~/bin/filter-min.sh \
	~/bin/filter-newlines.pl \
	~/bin/filter-osfiles.sh \
	~/bin/filter-punct.sh \
	~/bin/filter-scripts.sh \
	~/bin/filter-source.sh \
	~/bin/filter-text.sh \
	~/bin/filter-web.sh \
	~/bin/filter-zips.sh \
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
	~/bin/npm-stars.lst \
	~/bin/unicode-sample.sh \
	~/bin/unwebpack.sh \
	$B

pushd ~/bin/template/playwright
	tar czf /tmp/playwright.tgz `find . \( -name screenshots -o -name *.[jt]s-snapshots -o -name playwright-report -o -name test-results -o -name node_modules \) -prune -o -type f -print | grep -vE '\.(log|lst|clean|DS_Store)'`
popd
pushd $B/playwright
	tar xzf /tmp/playwright.tgz
popd

if [ ! -d /tmp/node_modules/nyc-dark ]; then
	pushd /tmp
	npm install nyc-dark
	popd
fi
cp -r /tmp/node_modules/nyc-dark $B

tar czf bundle/my-git-dev-tools.tgz tx
zip64.pl `find tx -type f` > bundle/mytools.txt 2> bundle/zip64.log
grep -vE '^(end|\s*$)' bundle/zip64.log

md5sum.sh tx | tee bundle/md5sum.lst

echo ""
echo "You can email mytools.txt to send all the tools."

ls -alh bundle



