# some functions for testing things from shell scripts
# Brent S.A. Cowgill
# License: Unlicense http://unlicense.org/:wq
# Github original: https://github.com/bcowgill/bsac-linux-cfg/raw/master/bin/tests/shell-test.sh
# have a look into shUnit http://shunit2.googlecode.com/svn/trunk/source/2.1/doc/shunit2.html#id16

# Reset this to 0 to let test plans carry on to the end if they fail to match base file.
# Other types of test failures still stop the suite.
ERROR_STOP=1
TEST_PLAN=
TEST_CASES=0
TEST_FAILURES=0
PASS="OK"
FAIL="NOT OK"

if [ "$UC_SHELL_TEST" == "" ]; then
	PASS="ok"
	FAIL="not ok"
fi

# perl -i.bak -pne 'chomp; s{echo \s OK \s+ (.*) \z}{OK "$1"}xms; s{echo \s NOT \s OK \s+ (.*) \z}{NOT_OK "$1"}xms; $_ .= "\n"' lib-check-system.sh

# Specify the number of test cases you expect to run.
# For Test Anything Protocol compatability http://testanything.org/tap-specification.html
function PLAN {
   local number
   number=$1
   if [ "$TEST_PLAN" == "" ]; then
      TEST_PLAN=$number
      echo "1..$number"
   fi
}

# TODO add terminal color escape sequences
function OK {
   local message
   message="$1"

   TEST_CASES=$(( $TEST_CASES + 1 ))
   echo $PASS $TEST_CASES "$message"
}

# TODO add terminal color escape sequences
function NOT_OK {
   local message
   message="$1"
   TEST_CASES=$(( $TEST_CASES + 1 ))
   echo "$FAIL $TEST_CASES $message"
}

function pause {
   local message input
   message="$1"
   NOT_OK "PAUSE $message press ENTER to continue."
   read input
}

function stop {
   local message
   message="$1"
   NOT_OK "STOPPED: $message"
   exit 1
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
      NOT_OK "./tests.sh does not exist in `pwd`"
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
      OK "command executed without error"
   else
      NOT_OK "exit code $err for \"$cmd\""
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
      OK "command failed with exit code $expect"
   else
      NOT_OK "expected exit code $expect but got $err for \"$cmd\""
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
      OK "$test output equals base file"
   else
      NOT_OK "files differ - $test"
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
         OK "test plan $0 completed in `pwd`"
      else
         NOT_OK "test plan $0 completed with $TEST_FAILURES failures in `pwd`"
      fi
      PLAN $TEST_CASES
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
   NOT_OK "test plan $0 terminated by error in `pwd`"
   if [[ -n "$message" ]] ; then
      NOT_OK "on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
   else
      NOT_OK "on or near line ${parent_lineno}; exiting with status ${code}"
   fi
   PLAN $TEST_CASES
   exit "${code}"
}
trap 'error ${LINENO}' ERR

