#!/bin/bash
# a very simple multiple  shell script test plan

LOG=test.out

CMD=./fix-counter.sh
echo "# Tests for $CMD" | tee $LOG
IN=fix-counter.test.in.txt
OUT=fix-counter.test.out
BASE=fix-counter.test.base
cp $IN $OUT
touch $BASE
$CMD $OUT >> $LOG
diff $OUT $BASE || echo NOT OK output differs. vdiff $OUT $BASE

CMD=./fix-har.sh
echo "# Tests for $CMD" | tee --append $LOG
IN=fix-har.test.in.txt
OUT=fix-har.test.out1
OUT2=fix-har.test.out2
BASE=fix-har.test.base1
BASE2=fix-har.test.base2
cp $IN $OUT
cp $IN $OUT2
touch $BASE
touch $BASE2
$CMD http://go.ru $OUT >> $LOG
diff $OUT $BASE || echo NOT OK output differs. vdiff $OUT $BASE

STRIPA=1 $CMD $OUT2 >> $LOG
diff $OUT2 $BASE2 || echo NOT OK output differs. vdiff $OUT2 $BASE2


echo "# Tests for STDOUT"
BASE=test.base
touch $BASE
diff $LOG $BASE || echo NOT OK output differs. vdiff $LOG $BASE

if [ ! -z "$KEEP" ]; then
	echo "# keeping *.out* files for diagnosis"
else
	rm *.out*
fi

