#!/bin/bash
# Merge all the bash history files from all sessions and reload the history

history -n
echo history: `history | wc -l`
pushd ~ > /dev/null
SESS_HIST=`wc -l .sh_history .bash_sessions/*.history* | grep -vE 'total$|^\s*0\s' | sort -rg | perl -pne 's{\A\s*\d+\s+}{}xms'`

IN=~/.bash_history
OUT=~/.bash_history.merged

cp $IN $OUT
for hist in $SESS_HIST
do
	vdiff.sh $hist $OUT
done
cp $OUT $IN
if [ ! -z "$HISTFILE" ]; then
	cp $OUT $HISTFILE
fi
echo HISTFILE=$OUT history -r
echo history: `history | wc -l`
popd > /dev/null
echo You may want to execute:
echo HISTFILE=$OUT history -r
