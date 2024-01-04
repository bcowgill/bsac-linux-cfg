if node --version | grep `cat .nvmrc`; then \
	SRC=index.ts
	rm $SRC*.out
	#touch $SRC.bas $SRC.err.bas

	npx ts-node $SRC \
	&& npx ts-node $SRC > $SRC.out 2> $SRC.err.out

	diff $SRC.out $SRC.bas || echo "NOT OK - Standard Output differs from base file: vdiff $SRC.out $SRC.bas"
	diff $SRC.err.out $SRC.err.bas || echo "NOT OK - Standard Error differs from base file: vdiff $SRC.err.out $SRC.err.bas"
else
	echo "You need to run: nvm use"
	echo "to set the correct version of node [`cat .nvmrc`] for this project."
fi
