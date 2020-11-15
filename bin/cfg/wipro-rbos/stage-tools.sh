#!/bin/bash
# stage my tools for a new client by copying to home/bin from ~/bin
# ggr -E '\.(sh|pl)' ./home >> stage-tools.sh
# grep -E '\.(sh|pl)' ./home/bin >> stage-tools.sh

FROM=~/bin
TO=./home/bin
SMILEYS=~/bin/template/html/faces-utf8.html
UNICODE=data/unicode/unicode-names.txt

pushd $TO
rm *.sh *.pl *.html $UNICODE

if [ "x$1" == "xclean" ]
	exit 0
fi

cp $SMILEYS .

# for grep-utf8 command
mkdir -p $UNICODE && rmdir $UNICODE
cp ~/bin/$UNICODE $UNICODE

cp `grep -l WINDEV $FROM/*.pl` .
mv `grep -l CUSTOM *.pl` ./cfg/wipro-rbos/

cp `grep -l WINDEV $FROM/*.sh` .

rm git-use*.sh
cp $FROM/git-use-winmerge.sh .

mv `grep -l CUSTOM *.sh` ./cfg/wipro-rbos/

popd

tar cvzf wipro-rbos-tools.tgz home
exit
