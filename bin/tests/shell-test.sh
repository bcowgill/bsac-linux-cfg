# some functions for testing things from shell scripts
# have a look into shUnit http://shunit2.googlecode.com/svn/trunk/source/2.1/doc/shunit2.html#id16

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
