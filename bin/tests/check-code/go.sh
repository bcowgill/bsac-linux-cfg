# auto-build.sh ./go.sh ../..
./tests.sh
cat out/success.out

echo " "
echo Possible Errors:
grep OKEY out/success.out

