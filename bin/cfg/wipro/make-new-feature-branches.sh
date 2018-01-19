#!/bin/bash
# create a new feature branch in all relevant repositories
# and configure the Jenkins email distribution list
# as well as the BDD testing server URL

set -e

# blank lines and #comments allowed in this list:
# by default, 'master' is the branch used, otherwise configure with a :branchname on the repo line
# by default, EMAIL_BE is used, add :front or :both after branchname to use EMAIL_FE
# repository:masterbranch:both
REPO_MASTER='
#pas-card-control-api
#pas-card-control-mock
#pas-card-control-visa-adapter
#pas-card-control-api-ucd-deploy
#pas-card-controls-cwa-ucd-deploy
pas-card-controls-cwa:master:front
pas-card-controls-cwa-mca-ie8:master:front
'

#  Eva Hoffman <ehoffman@sapient.com>,
#  Brent Cowgill <brent.cowgill@wipro.com>,
#  Harish Bora <hbora@sapient.com>,
EMAIL_FE="
  Harish Bora <hbora@sapient.com>,
  Aminul Islam <aminul.islam@wipro.com>,
"

#  Mayank Panwar <mpanwar@sapient.com>,
#  Shailendra Shail <sshail@sapient.com>,
EMAIL_BE="
  Santhosh Kumaran <santhosh.kumaran@wipro.com>,
  Timothy McNamara <timothy.mcnamara@wipro.com>,
"

# Script constants/variables
TEST_CASES=0
TEST_FAILS=0
STOP_ON_FAIL=1
HAD_FAIL=0
PASS="OK"
FAIL="NOT OK"
DIVIDER="=================================================="

# Enable NO_CREATE setting if you have already created the branch but need to re-run the script on the branch
# i.e. to debug the email distribution list change
NO_CREATE=1

# Enable NO_PUSH setting if you don't want to commit and push the repos immediately
NO_PUSH=1

function usage {
  local message
  message="$1"

  allow_fail_for_now
  NOT_OK "$message"

  echo "
$0 sprintNN/branch-name [bdd-pass-rate] [bdd-gulp-option]

This script will create a new feature branch in all the relevant repositories.
It will set the Jenkinsfile email distroList appropriately.
It will set the BDD pass rate check to zero, or whatever you specify on the command line.
It will set the BDD GULP_OPTION to runTestWithSauce, or whatever you specify on the command line.
"
  configuration
  exit_on_fail
  exit
}

function configuration {
  echo Branch Configuration:
  loop_repos echo "$REPO_MASTER"

  echo BDD Pass Configuration:
  echo $BDD_PASS
  echo BDD GULP_OPTION
  echo $BDD_GULP
  echo Email Configuration Front End Repos:
  echo "$EMAIL_FE"
  echo Email Configuration Back End Repos:
  echo "$EMAIL_BE"
}

function main {
  echo "$NEW_BRANCH" | perl -ne '
    chomp;
    exit 1 unless m{\A sprint\d+ / [\w\-]+ \z}xms;
    exit 1 if m{\A sprint\d+ / master \z}xms;
    exit 1 if m{\A sprint\d+ / develop \z}xms;
    exit 0;
  ' || usage "You must provide a new branch name of form sprintNN/feature NOT '$NEW_BRANCH'"

  info "Will create a new branch '$NEW_BRANCH' in all configured repositories."
  if [ ! -z $NO_CREATE ]; then
    info "NO_CREATE, will not actually create any branches, just checkout."
  fi
  if [ ! -z $NO_PUSH ]; then
    info "NO_PUSH, will not commit and push the repositories."
  fi

  configuration

  # first, ensure each repository is clean and on the appropriate master branch:
  allow_fail_for_now
  loop_repos check_git_directory "$REPO_MASTER"
  exit_on_fail
  loop_repos pull_branch "$REPO_MASTER"

  echo $DIVIDER
  info "Checking that branch '$NEW_BRANCH' does not already exist."
  loop_repos is_new_branch "$REPO_MASTER"

  info "Creating new branch '$NEW_BRANCH' in all repositories."
  loop_repos create_new_branch "$REPO_MASTER"

  info "Setting Jenkins email distribution list for team."
  loop_repos set_distro_email "$REPO_MASTER"

  # TODO set BDD testing server URL or disable on feature branch
  loop_repos set_bdd_options "$REPO_MASTER"

  MESSAGE="$NEW_BRANCH - initial creation"
  loop_repos commit_push "$REPO_MASTER"
}

# loop through repo configuration ignoring blank and commented lines
function loop_repos {
  local func repo_branch_email repo branch email
  func="$1"
  repo_config="$2"
  for repo_branch_email in $repo_config
  do
    split_colon $repo_branch_email; repo=$SPLIT1; branch=${SPLIT2:-master}; email=${SPLIT3:-back}
    if [ ! -z $repo ]; then
      if [ `echo $repo | cut -c 1` != '#' ]; then
        $func "$repo" "$branch" "$email"
      fi
    fi
  done
}

function check_git_directory {
  local repo
  repo="$1"
  if [ ! -d "$repo/.git" ]; then
    NOT_OK "'$repo' is not a Git repository in directory `pwd`."
  fi
}

function pull_branch {
  local repo branch
  repo="$1"
  branch="$2"
  enter_repo "$repo"

  git fetch --all && \
  git checkout "$branch" && \
  git pull

  if [ $? != 0 ]; then
    correct_in "$repo"
    NOT_OK "'$repo' could not switch and pull from branch '$branch'."
  fi

  popd
}

function is_new_branch {
  local repo branch
  repo="$1"
  branch="$NEW_BRANCH"
  enter_repo "$repo"

  if [ -z $NO_CREATE ]; then
    if git branch --list --remote | grep "$branch" ; then
      NOT_OK "'$repo' remote branch '$branch' already exists."
    fi

    if git branch --list | grep "$branch" ; then
      correct_in "$repo"
      NOT_OK "'$repo' local branch '$branch' already exists. You can delete it with: git branch -d $branch if needed."
    fi
  fi

  popd
}

function create_new_branch {
  local repo branch
  repo="$1"
  branch="$2"
  enter_repo "$repo"

  info "Creating branch '$NEW_BRANCH' from branch '$branch' in '$repo'"
  if [ -z $NO_CREATE ]; then
    git checkout -b "$NEW_BRANCH" && \
      git push --set-upstream origin "$NEW_BRANCH"

    if [ $? != 0 ]; then
      correct_in "$repo"
      NOT_OK "'$repo' could not create new branch '$NEW_BRANCH' from branch '$branch'."
    fi
  else
    git checkout "$NEW_BRANCH"
  fi

  popd
}

function set_distro_email {
  local repo branch email
  repo="$1"
  branch="$2"
  email="$3"
  enter_repo "$repo"

  if [ $email == front ]; then
    email="$EMAIL_FE"
  else
    if [ $email == back ]; then
      email="$EMAIL_BE"
    else
      email="$EMAIL_FE $EMAIL_BE"
    fi
  fi

  echo Files which have email distroList:
  git grep -l distroList
  update_email "Jenkinsfile" "$email"
  update_email "pipelines/cron/Jenkinsfile" "$email"

  popd
}

function update_email {
  local filename email_list
  filename="$1"
  email_list="$2"

  if [ -f "$filename" ]; then
    info "$filename: setting email distribution list."
    #Jenkinsfile:def distroList = "Brent Cowgill <brent.cowgill@wipro.com>, Timothy McNamara <timothy.mcnamara@wipro.com>, Santhosh Kumaran <santhosh.kumaran@wipro.com>, Aminul Islam <aminul.islam@wipro.com>"
    EMAIL_LIST="$email_list" perl -i.bak -pne '
      BEGIN { $q = chr(39); $/ = undef }
      s{(def \s+ distroList \s* = \s*) ("|$q$q$q) (.+?) \2}{$1$q$q$q\n$ENV{EMAIL_LIST}\n$q$q$q}xms;
      ' "$filename"

    git add "$filename"
  fi
}

function set_bdd_options {
  local repo branch email
  repo="$1"
  branch="$2"
  enter_repo "$repo"

  update_bdd_pass_rate "pipelines/conf/job-configuration.json" $BDD_PASS
  update_bdd_gulp_option "pipelines/tests/bdd.groovy" $BDD_GULP

  popd
}

function update_bdd_pass_rate {
  local filename rate
  filename="$1"
  rate="$2"

  if [ -f "$filename" ]; then
    info "$filename: setting BDD pass rate to $rate"
    #pipelines/conf/job-configuration.json:      "percent_scenarios": "90"
    PASS_RATE="$rate" perl -i.bak -pne '
      BEGIN { $/ = undef }
      s{("percent_scenarios": \s*) "\d+"}{$1"$ENV{PASS_RATE}"}xms;
      ' "$filename"

    git add "$filename"
  fi
}

function commit_push {
  if [ -z $NO_PUSH ]; then
    git commit -m "$MESSAGE" \
      && git push
  fi
}

function update_bdd_gulp_option {
  local filename option
  filename="$1"
  option="$2"

  if [ -f "$filename" ]; then
    info "$filename: setting BDD gulp option to '$option'"
    #pipelines/tests/bdd.groovy:      "GULP_OPTION=runBddWithSauce"
    GULP_OPTION="$option" perl -i.bak -pne '
      BEGIN { $/ = undef }
      s{("GULP_OPTION=) \w* "}{$1$ENV{GULP_OPTION}"}xms;
      ' "$filename"

    git add "$filename"
  fi
}

function enter_repo {
  local repo
  repo="$1"
  echo $DIVIDER
  pushd "$1"
}

function correct_in {
  local repo
  repo="$1"
  echo "Correct in: pushd $repo"
}

function NOT_OK {
  local messag
  message="$1"
  TEST_CASES=$(( $TEST_CASES + 1 ))
  TEST_FAILS=$(( $TEST_FAILS + 1 ))
  error "$FAIL $TEST_CASES $message"
  HAD_FAIL=1
  if [ $STOP_ON_FAIL == 1 ]; then
    exit 1
  fi
}

function allow_fail_for_now {
  STOP_ON_FAIL=0
  HAD_FAIL=0
}

function exit_on_fail {
  if [ $HAD_FAIL == 1 ]; then
    echo Resolve the problem and try again...
    exit 1
  fi
  STOP_ON_FAIL=1
}

# bright yellow on red
function error {
  local message
  message="$1"
  echo -e '\033[37;41m'"\033[33;1m${message}\033[0m"
}

# black on cyan
function info {
  local message
  message="$1"
  echo -e '\033[37;46m'"\033[30m${message}\033[0m"
}

function split_colon {
  local one_two_three
  one_two_three="$1"
  # split the repo:branch:email string into vars
  IFS=: read SPLIT1 SPLIT2 SPLIT3 <<< "$one_two_three"
}

NEW_BRANCH="$1"
BDD_PASS=${2:-0}
BDD_GULP=${3:-runTestWithSauce}
main
