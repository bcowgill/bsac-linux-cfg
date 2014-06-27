# some functions for testing things from shell scripts
# Brent S.A. Cowgill
# License: Unlicense http://unlicense.org/:wq
# Github original: https://github.com/bcowgill/bsac-linux-cfg/raw/master/bin/tests/shell-test.sh
# have a look into shUnit http://shunit2.googlecode.com/svn/trunk/source/2.1/doc/shunit2.html#id16

# Reset this to 0 to let test plans carry on to the end if they fail to match base file.
# Other types of test failures still stop the suite.
ERROR_STOP=1
TEST_FAILURES=0

function pause {
   local message input
   message="$1"
   echo NOT OK PAUSE $message press ENTER to continue.
   read input
}

function stop {
   local message
   message="$1"
   echo NOT OK STOPPED: $message
   exit 1
}

# TODO add terminal color escape sequences
function OK {
   local message
   message="$1"
   echo OK "$message"
   return 0
}

# TODO add terminal color escape sequences
function NOT_OK {
   local message
   message="$1"
   echo NOT OK "$message"
   return 1
}

function testSuite
{
   local dir suite
   dir="$1"
   suite="$2"
   echo ======================================================================
   echo TEST SUITE in "./$dir/" : $suite
   pushd "$dir" > /dev/null
   [ -d in ] || mkdir in
   [ -d out ] || mkdir out
   [ -d base ] || mkdir base
   if [ -x ./tests.sh ]; then
      ./tests.sh
   else
      echo NOT OK ./tests.sh does not exist in `pwd`
      return 1
   fi
   popd > /dev/null
   return 0
}

# Ensure a just executed command succeeded.
# usage:
# program-to-test $ARGS || assertCommandSuccess $? "program-to-test $ARGS"
function assertCommandSuccess
{
   local err cmd
   err="$1"
   cmd="$2"
   if [ 0 == $err ]; then
      echo OK command executed without error
   else
      echo NOT OK exit code $err for "$cmd"
      return 1
   fi
   return 0
}

# Ensure a just executed command failed.
# usage:
function assertCommandFails
{
   local err expect cmd
   err="$1"
   expect="$2"
   cmd="$3"
   if [ $expect == $err ]; then
      echo OK command failed with exit code $expect
   else
      echo NOT OK expected exit code $expect but got $err for "$cmd"
      return 1
   fi
   return 0
}

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
      echo " "
      echo vdiff "$actual" "$expected"
      echo " " 
      TEST_FAILURES=$(( $TEST_FAILURES + 1 ))
      return $ERROR_STOP
   fi
   return 0
}

# On successful completion of a test plan, show OK message
COMPLETE_ERROR=0
function complete()
{
   if [ $COMPLETE_ERROR == 0 ]; then
      if [ $TEST_FAILURES == 0 ]; then
         echo OK test plan $0 completed in `pwd`
      else
         echo NOT OK test plan $0 completed with $TEST_FAILURES failures in `pwd`
      fi
   fi
}
trap complete 0

# An error handler to trap premature terminations.
# source: http://stackoverflow.com/questions/64786/error-handling-in-bash
function error()
{
   local parent_lineno="$1"
   local message="$2"
   local code="${3:-1}"
   COMPLETE_ERROR=1
   echo NOT OK test plan $0 terminated by error in `pwd`
   if [[ -n "$message" ]] ; then
      echo "NOT OK on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
   else
      echo "NOT OK on or near line ${parent_lineno}; exiting with status ${code}"
   fi
   exit "${code}"
}
trap 'error ${LINENO}' ERR
