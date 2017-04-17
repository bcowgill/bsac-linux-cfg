TYPES="commonjs amd umd es2015 system"
for T in $TYPES
do
	echo making $T
	[ -d $T ] || mkdir $T
	rm *.js
	tsc --project tsconfig-$T.json 2>&1 | tee $T/build.log
	mv *.js $T
done
