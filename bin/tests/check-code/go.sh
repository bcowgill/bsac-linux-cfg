# auto-build.sh ./go.sh ../..
# git grep testcase ../../check-code.sh .
./tests.sh
if [ -e out/success.out ]; then
	cat out/success.out

	echo " "
	echo Possible Errors:
	grep OKEY out/success.out
fi
