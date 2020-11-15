#!/bin/bash
# stage my tools for a new client by copying to home/bin from ~/bin
# ggr -E '\.(sh|pl)' ./home >> stage-tools.sh
# grep -E '\.(sh|pl)' ./home/bin >> stage-tools.sh

FROM=~/bin
TO=./home/bin

pushd $TO
rm *.sh *.pl

cp `grep -l WINDEV $FROM/*.pl` .
mv `grep -l CUSTOM *.pl` ./cfg/wipro-rbos/

cp `grep -l WINDEV $FROM/*.sh` .

rm git-use*.sh
cp $FROM/git-use-winmerge.sh .

mv `grep -l CUSTOM *.sh` ./cfg/wipro-rbos/

popd

tar cvzf wipro-rbos-tools.tgz home
exit
