# some functions for testing things from shell scripts
# Brent S.A. Cowgill
# License: Unlicense http://unlicense.org/:wq
# Github original: https://github.com/bcowgill/bsac-linux-cfg/raw/master/bin/tests/shell-test.sh
# have a look into shUnit http://shunit2.googlecode.com/svn/trunk/source/2.1/doc/shunit2.html#id16

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

function testSuite
{
   local dir suite
   dir="$1"
   suite="$2"
   echo ======================================================================
   echo TEST SUITE in "$dir" : $suite
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
      echo vdiff "$actual" "$expected"
      return 1
   fi
   return 0
}

# On successful completion of a test plan, show OK message
COMPLETE_ERROR=0
function complete()
{
   if [ $COMPLETE_ERROR == 0 ]; then
      echo OK test plan $0 completed in `pwd`
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
