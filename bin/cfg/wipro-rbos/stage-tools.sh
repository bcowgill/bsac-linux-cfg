#!/bin/bash
# stage my tools for a new client by copying to home/bin from ~/bin
# ggr -E '\.(sh|pl)' ./home >> stage-tools.sh
# grep -E '\.(sh|pl)' ./home/bin >> stage-tools.sh

FROM=~/bin
TO=./home/bin

pushd $TO
cp $FROM/find-bak.sh .
cp $FROM/pswide.sh .
cp $FROM/datestamp.sh .
cp $FROM/git-*.sh .
rm git-use*.sh
cp $FROM/git-use-winmerge.sh .
mv `grep -l CUSTOM git-*` ./cfg/wipro-rbos/
cp `grep -l WINDEV *.sh` .

popd

tar cvzf wipro-rbos-tools.tgz home
exit
