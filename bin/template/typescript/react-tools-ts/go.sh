#!/bin/bash
# 1. paste code from typescriptlang.org site into tslangorg.txt
# 2. paste JS transpiled code from same site into tslangorg.js.txt file
# 3. vdiff.sh tslangorg.txt tscompiler.txt to update the onecompiler site version of code
# 4. ./go.sh to fix up the EX_JS_NODE and EX_ONECOMP values as well as replace NBSP with space in the pasted javascript.
# 5. this also runs the javascript so you should see All Testts passed
# 6. then it reopens the files in emacs so you have the latest changes in the buffer.
perl -i -pne '
	s{(exports\.EX_ONECOMP.+=.+)false}{$1true}xms;
	s{(exports\.EX_TSLANG.+=.+)true}{$1false}xms;
	if (m{//\sENABLE\sMap\sEnd}) {
		$comment = 0;
	}
	elsif (m{//\sENABLE\sMap}) {
		$comment = 1;
	}
	$_ = "// $_" if $comment && !m{\A//};
' tscompiler.txt

perl -i -pne '
	s{(exports\.EX_ONECOMP.+=.+)true}{$1false}xms;
	s{(exports\.EX_TSLANG.+=.+)true}{$1false}xms;
' tsrunner.ts

perl -i -pne '
	s{(exports\.EX_ONECOMP.+=.+)true}{$1false}xms;
	s{(exports\.EX_TSLANG.+=.+)false}{$1true}xms;
' tslangorg.txt

cp tslangorg.js.txt tslangorg.js.bak
./tx.pl tslangorg.js.bak > tslangorg.js.txt
perl -i -pne 'if (!$prev && !m{\#!/usr/bin/env\snode}xms)
	{
		$_ = "#!/usr/bin/env node\n$_"
	}
	$prev = 1;
	s{(exports\.EX_ONECOMP.+=.+)true}{$1false}xms;
	s{(exports\.EX_TSLANG.+=.+)false}{$1true}xms;
	s{\ +\n}{\n}xms;
' tslangorg.js.txt

if [ `node --version` != `cat .nvmrc` ]; then
	echo YOU NEED TO nvm use FIRST!
	node --version
	cat .nvmrc
	exit
fi
echo " "
./tslangorg.js

echo " "
head -1 tslangorg.js
grep -E '^\s*(exports\.|export const )?EX_(JS_NODE|ONECOMP).+=' tslangorg.js tslangorg.txt tscompiler.txt

echo " "
grep MUSTDO README.txt

echo " "
echo "Go to emacs to refresh the changed files."
edit.sh ./tslangorg.js.txt ./tslangorg.txt ./tscompiler.txt
