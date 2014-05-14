# some functions for testing things from shell scripts

function assertFilesEqual
{
   local actual expected test
   actual="$1"
   expected="$2"
   test="$3"

   [ -f "$expected" ] || touch "$expected"
   if diff "$actual" "$expected" > /dev/null; then
      echo "OK $test output equals base file"
   else
      echo "NOT OK files differ - $test"
      echo vdiff "$actual" "$expected"
      return 1
   fi
   return 0
}
