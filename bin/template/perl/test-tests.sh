# ./test-tests.sh > tests.log 2>&1

./perl.t
./perl.t bail
./perl.t pass
prove perl.t
prove perl.t bail
prove perl.t pass
