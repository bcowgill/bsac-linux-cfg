# lib-check-system.sh - library of functions for checking linux system and setting things up
# Brent S.A. Cowgill.
# License: Unlicense http://unlicense.org/
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit

# Provides perl test case like output
# OK something worked
# NOT OK something failed
# Make sure you set -e on your setup script so it will terminate on first failure
#
# Example:
# set -e
# file_exists something-i-need.txt "need this config file"
# produces output:
# OK file exists: something-i-need.txt
# or
# NOT OK file missing: something-i-need.txt [need this config file]

# some definitions for TAP protocol support

SILENT_OK=1
SILENT_NOT_OK=0
TEST_PLAN=
TEST_CASES=0
TEST_FAILS=0
PASS="OK"
FAIL="NOT OK"

# Default is to let NOT_OK continue sometimes you want an end to the script
# on the first unhandled NOT_OK.
# so  NOT_OK "something" || echo " "   will suppress ending the script
# if you still need to handle a NOT_OK to prevent script ending.
# also NOT_OK "MAYBE will try" && make_it_happen   allow you to show a not ok and then try to fix it.
STOP_ON_FAIL=0

# When running under the prove command, lower case our output
if [ ${HARNESS_ACTIVE:-0} == 1 ]; then
	# TAP expects lower case
	PASS="ok"
	FAIL="not ok"
fi

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

function bleep {
	local type flag
	type=${1:-not-ok}
	flag=${2:-$SILENT_NOT_OK}
	if which sound-$type.sh > /dev/null; then
		if [ $flag == 0 ]; then
			sound-$type.sh
		fi
	fi
}

# TODO add terminal color escape sequences
function OK {
	local message
	message="$1"
	TEST_CASES=$(( $TEST_CASES + 1 ))
	echo $PASS "$TEST_CASES $message"
	bleep ok $SILENT_OK 
}

# TODO add terminal color escape sequences
function NOT_OK {
	local message
	message="$1"
	TEST_CASES=$(( $TEST_CASES + 1 ))
	TEST_FAILS=$(( $TEST_FAILS + 1 ))
	say "$FAIL $TEST_CASES $message"
	bleep 
	if [ $STOP_ON_FAIL == 1 ]; then
		return 1
	fi
	return 0
}

# Show a cross-platform notification message if possible
function mynotify {
	local title message TMP
	title="$2"
	message="$1"
	
	# MACOS
	# bash-3.2$ osascript -e 'display notification "NOT OK 131 file missing text: "check-iniline/.gitconfig" "gui/fontui = -family LucidaSans -size 14 -weight normal -slant roman -underline 0 -overstrike 0" [git gui UI font Edit / Options]" with title "" '
	# 52:58: syntax error: A identifier can’t go after this “"”. (-2740)
	# bash-3.2$ osascript -e 'display notification "NOT OK 131 file missing text: check-iniline/.gitconfig gui/fontui = -family LucidaSans -size 14 -weight normal -slant roman -underline 0 -overstrike 0 [git gui UI font Edit / Options]" with title "" '
	# So we strip double quotes from the vars before using them.
	which osascript > /dev/null && osascript -e "display notification \"`echo $message | tr -d '"'`\" with title \"`echo $title | tr -d '"'`\" "
	which notify > /dev/null && notify -t "$title" -m "$message"
	if which notify-send > /dev/null ; then
		if [ -z "$title" ]; then
			title="check-system.sh"
			if [ -z "$message" ]; then
				return
			fi
		fi
		notify-send --expire-time=15000 "$title" "$message"
	fi
	echo "`date`: $2: $1" >> $HOME/mynotify.log
}

# Show summary of failures and total tests
function ENDS {
	mynotify "$message" ""
	say "$TEST_FAILS test failures (may be hidden)"
	say "$TEST_CASES test cases"
	if which sw_vers > /dev/null 2>&1 ; then
		# don't do updatedb on mac, too slow
		true
	else
		echo "update db" && updatedb.sh &
	fi
}

# Say something on the terminal and with OS UI notification system
function say {
	local message
	message="$1"
	echo "$message"
	mynotify "$message" "$title"
}

#============================================================================
# Flow control

function pause {
	local message input
	message="$1"
	NOT_OK "PAUSE $message press ENTER to continue." && read input
}

function stop {
	local message
	message="$1"
	NOT_OK "STOPPED: $message"
	exit 1
}

function check_linux {
	local version ismacos check file which checkmacos os
	checkmacos=0
	os=linux
	version="$1"
	ismacos="${2:-0}"
	if which lsb_release > /dev/null; then
		check=$(lsb_release -sc 2> /dev/null)
	else
		file=/etc/issue
		if [ -f $file ]; then
			check="$file: `cat $file`"
		fi
		file=/etc/os-release
		if [ -f $file ]; then
			check="$file: `cat $file | grep PRETTY_NAME`"
		fi
		file=/etc/debian_version
		if [ -f $file ]; then
			check="$file: `cat $file`"
		fi
		file=/etc/rpi-issue
		if [ -f $file ]; then
			check="$file: `cat $file | grep Raspberry`"
		fi
		which=`which sw_vers`
		if [ ! -z "$which" ]; then
			check=$(sw_vers -productVersion 2> /dev/null)
			check="$check"
			checkmacos=1
			os=darwin
		fi
	fi
	if [ "$checkmacos" == "$ismacos" ]; then
		OK "machine is $os as expected"
	else
		NOT_OK "machine is $os did not expect that"
		return 1
	fi
	if [ "${check:-unknown}" == "$version" ]; then
		OK "$os version $version"
	else
		NOT_OK "$os version not $version [$check]"
		return 1
	fi
	return 0
}

#============================================================================
# system related

# ensure an env variable is defined
function var_exists {
	local name value
	name=$1
	value="$2"
	if [ -z $value ]; then
		NOT_OK "environment variable $name is not defined"
	fi
}

function user_in_group {
	local group user message
	group="$1"
	user="$2"
	message="$2"
	if egrep "^$group:" /etc/group | egrep "\b$user\b"; then
		OK "$user is a member of group $group"
	else
		NOT_OK "$user is not a member of group $group [$message]"
		return 1
	fi
	return 0
}

function add_user_to_group {
	local group user message
	group="$1"
	user="$2"
	message="$2"
	if egrep "^$group:" /etc/group | egrep "\b$user\b"; then
		OK "$user is a member of group $group"
	else
		echo "MAYBE NOT OK $user is not a member of group $group - will try to add"
		if egrep "^$group:" /etc/group; then
			OK "group $group exists"
		else
			sudo groupadd "$group"
		fi
		sudo usermod -aG "$group" "$user"
		user_in_group "$group" "$user" "$message"
	fi
	return 0
}

#============================================================================
# directory tools

function dir_exists {
	local dir message
	dir="$1"
	message="$2"
	if [ -d "$dir" ]; then
		OK "directory exists: $dir"
	else
		NOT_OK "directory missing: $dir [pwd=$(pwd)] [$message]"
		return 1
	fi
	return 0
}

# Enter a directory for some task, checking for existence
function push_dir {
	local dir message
	dir="$1"
	message="$2"
	if dir_exists "$dir"; then
		pushd "$dir" > /dev/null
		echo $message in dir `pwd`
	else
		NOT_OK "directory missing: $dir [pwd=$(pwd)] [$message]"
		return 1
	fi
}

# Pop a directory off the stack (can debug the trail)
function pop_dir {
	#echo DEBUG pushpop
	#echo DEBUG about to popd dir stack:
	dirs
	popd
}

function make_dir_exist {
	local dir message
	dir="$1"
	message="$2"
	if [ ! -d "$dir" ]; then
		mkdir -p "$dir"
	fi
	dir_exists "$dir" "$message"
}

function copy_dir {
	local dir source message
	dir="$1"
	source="$2"
	message="$3"
	if [ ! -d "$dir" ]; then
		mkdir -p "$dir"
		rmdir "$dir"
		cp -r "$source" "$dir/"
	fi
	dir_exists "$dir" "copy_dir from [$source] $message"
}

function dir_is_world_readable {
	local dir message	
	dir="$1"
	message="$2"
	if dir_exists "$dir" "$message"; then
		# drwxr-xr--+ 37 br388313  staff      1184 24 Jan 17:32 .
		if ls -al "$dir" | grep ' \.$' | grep -E '^d......r.x' > /dev/null ; then
			OK "directory is world readable: $dir"
		else
			NOT_OK "directory is not world readable+executable: $dir [pwd=$(pwd)] [$message]"
		fi
	fi
}

function make_dir_world_readable {
	local dir message	
	dir="$1"
	message="$2"
	if dir_exists "$dir" "$message"; then
		# drwxr-xr--+ 37 br388313  staff      1184 24 Jan 17:32 .
		if ls -al "$dir" | grep ' \.$' | grep -E '^d......r.x' > /dev/null ; then
			OK "directory is world readable: $dir"
		else
			chmod o+rx "$dir"
			dir_is_world_readable "$dir" "could not make world readable: $message"
		fi
	fi
}

#============================================================================
# root file/directory tools

function make_root_dir_exist {
	local dir message
	dir="$1"
	message="$2"
	dir_exists "$dir" > /dev/null || sudo mkdir -p "$dir"
	dir_exists "$dir" "$message"
}

function make_root_file_exist {
	local file contents message temp_file
	file="$1"
	contents="$2"
	message="$3"

	temp_file=`mktemp --tmpdir=/tmp/$USER`
	file_exists "$file" > /dev/null || (echo "$contents" >> $temp_file; chmod go+r $temp_file; sudo cp $temp_file "$file")
	rm $temp_file
	file_exists "$file" "$message"
}

function copy_file_to_root {
	local file source message
	file="$1"
	source="$2"
	message="$3"

	file_exists "$file" > /dev/null || (sudo cp "$source" "$file"; chmod go+r "$file")
	file_exists "$file" "$message"
}

# take ownership recursively of the given dir if it exists
# silently ignore it if it does not exist
function take_ownership_of {
	local dir message MYGROUP

	dir="$1"
	message="$2"

	MYGROUP=`groups | cut -f 1 -d " "`

	[[ ! -d "$dir" ]] && return 0

	if sudo chown -R $USER:$MYGROUP "$dir"
	then
		OK "directory $dir is now owned by you [$message]"
	else
		NOT_OK "directory $dir unable to change ownership to $USER:$MYGROUP [$message]"
		return 1
	fi
	return 0
}

function file_linked_to_root {
	local name target message link
	name="$1"
	target="$2"
	message="$3"
	file_exists "$target" "$message [sudo ln -s '$target' '$name']"
	set +e
	link=`readlink "$name"`
	set -e
	if [ "${link:-}" == "$target" ]; then
		OK "symlink $name links to $target"
		return 0
	else
		file_link_exists "$name" "will try to create for $message [sudo ln -s '$target' '$name']" || file_exists "$name" "save existing" && sudo mv "$name" "$name.orig"
		file_link_exists "$name" "try creating for $message" || sudo ln -s "$target" "$name"
		file_link_exists "$name" "$message"
	fi
}

function dir_linked_to {
	local name target message root link
	name="$1"
	target="$2"
	message="$3"
	root="$4"
	dir_exists "$target" "$message"
	if [ -e "$name" ]; then
		set +e
		link=`readlink "$name"`
		set -e
		if [ "${link:-}" == "$target" ]; then
			OK "symlink $name links to dir $target"
			return 0
		else
			if [ "${link:-}" == "$target/" ]; then
				OK "symlink $name links to dir $target/"
				return 0
			else
				NOT_OK "already exists: "$name" cannot create as a link to dir "$target" [$message] `readlink "$name"`"
				return 1
			fi
		fi
	else
		NOT_OK "symlink $name missing will try to create" && echo ln -s "$target" "$name"
		if [ -z "$root" ]; then
			ln -s "$target" "$name"
		else
			sudo ln -s "$target" "$name"
		fi
		dir_link_exists "$name" "$message"
	fi
}

#============================================================================
# file tools

# removes a file
function remove_file {
	local file message
	file="$1"
	message="$2"
	if [ -f "$file" ]; then
		if rm "$file"; then
			OK "file removed \"$file\" [$message]"
		else
			echo MAYBE NOT OK unable to remove file "$file" [$message]
			echo was in dir `pwd`
			set +e
			ls -al "$file"
			set -e
		fi
	else
		echo MAYBE NOT OK unable to remove file "$file" not found [message]
		echo was in dir `pwd`
		set +e
		ls -al "$file"
		set -e
	fi
}

# removes a symbolic link
function remove_symlink {
	local file message
	file="$1"
	message="$2"
	if [ -L "$file" ]; then
		if rm "$file"; then
			OK "symlink removed \"$file\" [$message]"
		else
			echo MAYBE NOT OK unable to remove symlink "$file" [$message]
			echo was in dir `pwd`
			set +e
			ls -al "$file"
			set -e
		fi
	else
		echo MAYBE NOT OK unable to remove symlink "$file" not found [message]
		echo was in dir `pwd`
		set +e
		ls -al "$file"
		set -e
	fi
}

# check that a file is present somewhere on the system using locate
function file_present {
	local file message
	file="$1"
	message="$2"
	if locate "$file"; then
		OK "file $file is present on system [$message]"
	else
		NOT_OK "file $file is NOT present on system [$message]"
		return 1
	fi
	return 0
}

function file_exists {
	local file message
	file="$1"
	message="$2"
	if [ -f "$file" ]; then
		OK "file exists: $file"
	else
		NOT_OK "file missing: $file [pwd=$(pwd)] [$message]"
		return 1
	fi
	return 0
}

function file_link_exists {
	local file message
	file="$1"
	message="$2"
	if [ -L "$file" ]; then
		OK "symlink exists: $file"
	else
		NOT_OK "symlink missing: $file [pwd=$(pwd)] [$message]"
		return 1
	fi
	return 0
}

function dir_link_exists {
	local dir message
	dir="$1"
	message="$2"
	if [ -L "$dir" ]; then
		OK "symlink dir exists: $dir"
	else
		NOT_OK "symlink dir missing: $dir [pwd=$(pwd)] [$message]"
		return 1
	fi
	return 0
}

function file_linked_to {
	local name target message link
	name="$1"
	target="$2"
	message="$3"
	file_exists "$target" "$message"
	set +e
	link=`readlink "$name"`
	set -e
	if [ "${link:-}" == "$target" ]; then
		OK "symlink $name links to $target"
		return 0
	else
		file_link_exists "$name" "will try to create for $message" || file_exists "$name" "save existing" && mv "$name" "$name.orig"
		file_link_exists "$name" "try creating for $message" || ln -s "$target" "$name"
		file_link_exists "$name" "$message"
	fi
}

# Check that relative symlink exists.
function file_relative_linked_to {
	local name target message link
	name="$1"
	target="$2"
	message="$3"
	set +e
	link=`readlink "$name"`
	set -e
	if [ "${link:-}" == "$target" ]; then
		OK "symlink $name links to $target"
		return 0
	else
		file_link_exists "$name" "will try to create for $message" || file_exists "$name" "save existing" && mv "$name" "$name.orig"
		file_link_exists "$name" "try creating for $message" || ln -s "$target" "$name"
		file_link_exists "$name" "$message"
	fi
}

function file_hard_linked_to {
	local name target message
	name="$1"
	target="$2"
	message="$3"
	file_exists "$target" "$message check target"
	file_exists "$name" "$message will try to hard link" || ln "$target" "$name"
	file_exists "$name" "$message"
}

function file_is_executable {
	local file message
	file="$1"
	message="$2"
	file_exists "$file" > /dev/null && chmod +x "$file"
	if [ -x "$file" ]; then
		OK "file is executable: $file"
	else
		NOT_OK "file is missing or not executable: $file [pwd=$(pwd)] [$message]"
		return 1
	fi
	return 0
}

# ensure files are identical
function files_same {
	local file source message
	file="$1"
	source="$2"
	message="$3"
	if diff --brief "$file" "$source" ; then
		OK "no change in file $1 - $message"
	else
		NOT_OK "file $1 has changed compared to $2 - $message"
	fi
}

function install_file_manually {
	local file message source
	file="$1"
	message="$2"
	source="$3"
	file_exists "$file" "manually install $message from $source"
}

# install a file from another location
function install_file {
	local file source message
	file="$1"
	source="$2"
	message="$3"
	file_exists "$file" > /dev/null || (echo want to install $file from $source ; cp "$source" "$file")
	file_exists "$file" "$message"
}

#============================================================================
# url / zip / network tools

# Make http request and optionally show log file on error
function http_request_show {
	local url message log
	url="$1"
	message="$2"
	log="$3"
	echo Send a request to $url [$message]
	if http_dump "$url" ; then
		OK "got response to $url"
	else
		NOT_OK "no response from $url [$message]" || echo " "
		if [ ! -z "$log" ]; then
			cat "$log"
		fi
		return 1
	fi
}

# Make http request to get a specific file
function http_get {
	local output url
	output="$1"
	url="$2"
	if which wget > /dev/null; then
		wget --output-document="$output" "$url"
	else
		if which curl > /dev/null; then
			curl --location --fail --create-dirs --output "$output" "$url"
		else
			NOT_OK "command wget or curl do not exist, cannot fetch web resources"
		fi
	fi
}

# Make http request and show content on console
function http_dump {
	local url
	url="$1"
	if which wget > /dev/null; then
		wget -q --output-document=- "$url"
	else
		if which curl > /dev/null; then
			curl "$url"
		else
			NOT_OK "command wget or curl do not exist, cannot fetch web resources"
		fi
	fi
}

# Download a file from a URL if it doesn't exist
function install_file_from_url {
	local file package url message
	file="$1"
	package="$2"
	url="$3"
	message="$4"
	var_exists DOWNLOAD "$DOWNLOAD"
	file_exists "$file" > /dev/null || (echo MAYBE NOT OK Try to install $file from $package at $url; http_get "$DOWNLOAD/$package" "$url")
	file_exists "$file" "$message"
}

# Download files from a URL if it doesn't exist
function install_files_from_url {
	local package url files message dir file
	package="$1"
	url="$2"
	files="$3"
	message="$4"
	dir="$DOWNLOAD/$package"
	var_exists DOWNLOAD "$DOWNLOAD"
	make_dir_exist "$dir" "$message"
	for file in $files
	do
		install_file_from_url "$dir/$file" "$package/$file" "$url/$file" "$message $file"
	done
}

# Install a file from a downloaded archive which creates its own subdirectory
function install_file_from_url_zip {
	local file package url message
	file="$1"
	package="$2"
	url="$3"
	message="$4"
	var_exists DOWNLOAD "$DOWNLOAD"
	if [ ! -f "$file" ]; then
		if [ ! -f "$DOWNLOAD/$package" ]; then
			install_file_from_url "$DOWNLOAD/$package" "$package" "$url" "$message"
		fi
		install_file_from_zip "$file" "$package" "$message"
	fi
	file_exists "$file" "$message"
}

# Install a file from a downloaded archive which doesn't create its own subdirectory
function install_file_from_url_zip_subdir {
	local file package subdir url message
	file="$1"
	package="$2"
	subdir="$3"
	url="$4"
	message="$5"
	var_exists DOWNLOAD "$DOWNLOAD"
	install_file_from_url "$file" "$package" "$url" > /dev/null || (push_dir "$DOWNLOAD/" && mkdir -p   "$subdir" && cd "$subdir" && extract_archive "$DOWNLOAD/$package" && pop_dir)
	file_exists "$file" "$message"
}

# Install a file from a manually downloaded archive which creates its own subdirectory
function install_file_from_zip {
	local file package message
	file="$1"
	package="$2"
	message="$3"
	var_exists DOWNLOAD "$DOWNLOAD"
	file_exists "$DOWNLOAD/$package" "$message"
	file_exists "$file" "$message" > /dev/null || (push_dir "$DOWNLOAD/" && extract_archive "$DOWNLOAD/$package" && pop_dir)
	file_exists "$file" "$message"
}

# Extract files from an archive
function extract_archive {
	local archive
	archive="$1"
	if echo "$archive" | grep ".zip"; then
		unzip "$archive"
	else
		if echo "$archive" | grep ".tar.gz"; then
			tar xvzf "$archive"
		else
			if echo "$archive" | grep ".tgz"; then
				tar xvzf "$archive"
			else
				if echo "$archive" | grep ".tar.bz2"; then
					tar xvjf "$archive"
				else
					NOT_OK "archive \"$archive\" is not a known type"
				fi
			fi
		fi
	fi
}

#============================================================================
# git related tools

# get git if possible
function get_git {
	cmd_exists git || ( echo doing an upgrade to get git; $PKGINST update && $PKGINST upgrade && $PKGINST install git && exit 11)

}

function install_git_repo {
	local dir subdir url message
	dir="$1"
	subdir="$2"
	url="$3"
	message="$4"
	dir_exists "$dir" "$message"
	dir_exists "$dir/$subdir" > /dev/null || (echo "NOT OK get git repo $mesasge from $url"; push_dir "$dir" && git clone "$url" "$subdir"; pop_dir)
	dir_exists "$dir/$subdir" "$message"
}

# Get a git repository and set to track a specific branch (ex origin/master)
function install_git_repo_branch {
	local dir subdir branch url message
	dir="$1"
	subdir="$2"
	branch="$3"
	url="$4"
	message="$5"
	dir_exists "$dir" "$message"
	if check_git_repo_branch "$dir/$subdir" "$branch" "$message"; then
		return 0
	else
		NOT_OK "will get git repo \"$message\" branch \"$branch\" from \"$url\"" || echo " "
		push_dir "$dir"
		if [ ! -d "$subdir" ]; then
			git clone "$url" "$subdir"
		fi
		dir_exists "$subdir" "$message"
		cd "$subdir" && git checkout --track $branch
		pop_dir
		check_git_repo_branch "$dir/$subdir" "$branch" "$message"
	fi
}

# Check that a checked out git repository is on the correct branch
function check_git_repo_branch {
	local dir branch message error
	dir="$1"
	branch="$2"
	message="$3"
	error=0
	dir_exists "$dir" "$message"
	push_dir "$dir"
		if git branch | grep '*' | grep "$branch"; then
			# TODO could be only a substring match of the branch
			OK "git repo "$dir" is on branch \"$branch\""
		else
			branch=`perl -e '$ARGV[0] =~ s{\A origin/}{}xms; print $ARGV[0]' "$branch"`
		if git branch | grep '*' | grep "$branch"; then
			# TODO could be only a substring match of the branch
			OK "git repo "$dir" is on branch \"$branch\""
		else
				git branch
				NOT_OK "git repo \"$dir\" is not on branch \"$branch\""
				error=1
			fi
		fi
		pop_dir
	return $error
}

#============================================================================
# MacOS brew related tools

if which brew > /dev/null; then
	PKGINST=brew
else
	PKGINST="sudo apt-get"
fi

# pin a tap for macos brew package manager
function brew_has_tap {
	local tap
	tap="$1"
	if which brew > /dev/null; then
		if $PKGINST tap | grep "$tap"; then
			OK "brew has tap $tap"
		else
			NOT_OK "brew has no tap $tap configured"
			return 1
		fi
	fi
	return 0
}

function brew_tap_from {
	local tap
	tap="$1"
	if which brew > /dev/null; then
		brew_has_tap "$tap" > /dev/null || (echo want to pin a tap $tap; $PKGINST tap "$tap")
		brew_has_tap "$tap"
	fi
	return 0
}

function brew_taps_from {
	local list message error package
	list="$1"
	message="$2"
	error=""
	if which brew > /dev/null; then
		for package in $list
		do
			brew_tap_from $package || error="$error $package"
		done
		if [ ! -z "$error" ]; then
			NOT_OK "errors for brew_tap_from$error [$message]"
			error=1
		else
			error=0
		fi
		return $error
	fi
}

#============================================================================
# commands and packages

function check_version {
	local cmd opt version message
	cmd="$1"
	opt="$2"
	find="$3"
	version="$4"
	message="$5"
	if $cmd $opt | grep "$find" | grep "$version"; then
		OK "$cmd is correct version [$version]"
	else
		NOT_OK "$cmd is not version [$version] `$cmd $opt` your mileage may vary setting this up"
		return 1
	fi
	return 0
}

function cmd_exists { # command_exists
	local cmd message which
	cmd="$1"
	message="$2"
	which=`which "$cmd"` || echo ""
	if [ ! -z "$which" ] ; then
		OK "command $cmd exists [$which]"
	else
		if [ -z "$message" ]; then
			message="$PKGINST install $cmd"
		fi
		NOT_OK "command $cmd missing [$message]"
		return 1
	fi
	return 0
}

function has_app {
	local cmd message
	cmd="$1"
	message="$2"
	if which sw_vers > /dev/null 2>&1 ; then
		if [ -d "/Applications/$cmd" ] ; then
			OK "application $cmd exists [/Applications/$cmd]"
			return 0
		fi
	fi
	echo MAYBE NOT OK "application $cmd does not exist [/Applications/$cmd] [$message]"
	return 1
}

function app_exists {
	local cmd message
	cmd="$1"
	message="$2"
	if [ -z "$message" ]; then
		message="manually install $cmd from App Store"
	fi
	if has_app "$cmd" > /dev/null; then
		OK "application $cmd exists"
		return 0
	else
		NOT_OK "application $cmd does not exist [$message]"
	fi
	return 1
}

function cmd_or_app_exists {
	local cmd message
	cmd="$1"
	message="$2"
	if has_app "$cmd" "$message"; then
		return 0
	else
		if cmd_exists "$cmd" "$message"; then
			return 0
		fi
	fi
	return 1
}

function commands_exist {
	local commands error cmd_pkg cmd package
	commands="$1"
	error=""
	for cmd_pkg in $commands
	do
		# split the cmd:pkg string into vars
		split_colon $cmd_pkg; cmd="$SPLIT1"; package="$SPLIT2"
		# echo "check: [$cmd_pkg] [$cmd] [$package]"
		if [ ! -z "$package" ]; then
			cmd="$package"
		fi
		# echo "check2: [$cmd_pkg] [$cmd] [$package]"
		cmd_exists "$cmd" || error="$error $cmd_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for commands_exist$error"
		error=1
	else
		error=0
	fi
	return $error
}

function file_exists_from_package {
	local file package
	file="$1"
	package="$2"
	file_exists "$file" "$PKGINST install $package"
}

# Install a single command from a differently named package
# options --assume-yes is useful to prevent asking questions
function install_command_from {
	local command package options
	command="$1"
	package="$2"
	options="$3"
	if [ -z "$package" ]; then
		package="$command"
	fi
	cmd_exists "$command" > /dev/null || (echo want to install command $command from $package; $PKGINST $options install "$package")
	cmd_exists "$command" || return 1
}

# Install a single command but using a list of packages
# options --assume-yes is useful to preven asking questions
function install_command_from_packages {
	local command packages options
	command="$1"
	packages="$2"
	options="$3"
	cmd_exists "$command" > /dev/null || (echo want to install command $command from $packages; $PKGINST $options install $packages)
	cmd_exists "$command" || return 1
}

# Install a bunch of commands if possible
# prefer using installs_from as it handles files and commands
function install_commands {
	local commands error cmd
	commands="$1"
	error=""
	for cmd in $commands
	do
		if [ ! -z "$cmd" ]; then
			cmd_exists $cmd > /dev/null || (echo want to install command $cmd ; $PKGINST install "$cmd")
			cmd_exists $cmd || error=""
		fi
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_commands$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Install commands from specific package specified as input list with : separation
# cmd1:pkg1 cmd2:pkg2 ...
# prefer to use installs_from as it handles both files and commands
function install_commands_from {
	local list message options error cmd_pkg cmd package
	list="$1"
	message="$2"
	options="$3"
	error=""
	for cmd_pkg in $list
	do
		# split the cmd:pkg string into vars
		split_colon $cmd_pkg; cmd="$SPLIT1"; package="$SPLIT2"
		install_command_from $cmd $package $options || error="$error $cmd_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_commands_from$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Force a command to be installed
function force_install_command_from {
	local command package message options
	command="$1"
	package="$2"
	message="$3"
	options="$4"
	if [ -z "$package" ]; then
		package="$command"
	fi
	echo forced to install $command from $package for "$message"
	$PKGINST $options install "$package"
	cmd_exists "$command" || return 1
}

# Force install commands from specific package specified as input list with : separation
# cmd1:pkg1 cmd2:pkg2 ...
function force_install_commands_from {
	local list message options error cmd_pkg cmd package
	list="$1"
	message="$2"
	options="$3"
	error=""
	for cmd_pkg in $list
	do
		# split the cmd:pkg string into vars
		split_colon $cmd_pkg; cmd="$SPLIT1"; package="$SPLIT2"
		force_install_command_from $cmd $package "$message" $options || error="$error $cmd_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for force_install_commands_from$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Install a command from a package (.deb) already downloaded manually
function install_command_package {
	local cmd package message
	cmd="$1"
	package="$2"
	message="$3"
	var_exists DOWNLOAD "$DOWNLOAD"
	cmd_or_app_exists "$cmd" > /dev/null || (file_exists "$DOWNLOAD/$package" "$message" && sudo dpkg --install "$DOWNLOAD/$package")
	cmd_or_app_exists "$cmd" $message || return 1
}

# Force install a command from a package (.deb) already downloaded manually
function force_install_command_package {
	local cmd package message
	cmd="$1"
	package="$2"
	message="$3"
	var_exists DOWNLOAD "$DOWNLOAD"
	file_exists "$DOWNLOAD/$package" "$message" && sudo dpkg --install "$DOWNLOAD/$package"
	cmd_exists "$cmd" $message || return 1
}

# Install a package (.deb) downloaded from a url
function install_command_package_from_url {
	local cmd package url message
	cmd="$1"
	package="$2"
	url="$3"
	message="$4"
	var_exists DOWNLOAD "$DOWNLOAD"
	file_exists "$DOWNLOAD/$package" "$message" > /dev/null || (echo Try to install $cmd from $package at $url [$message]; http_get "$DOWNLOAD/$package" $url && force_install_command_package $cmd "$package" "$message")
	install_command_package $cmd "$package"
}

function filter_packages {
	local packages remove
	packages="$1"
	remove="$2"
	perl -e '
		sub remove {
			my ($package, $rhRemove) = @_;
			my ($cmd_or_file, $package_name) = split(":", $package);
			$package_name = $package_name || $cmd_or_file;
			return $rhRemove->{$package_name};
		}
		my %remove = map { ($_, 1) } split(/\s+/, $ARGV[1]);
		my @packages = grep { !remove ($_, \%remove) } split(/\s+/, $ARGV[0]);
		print join(" ", @packages);
	' "$packages" "$remove"
}

function uninstall_from {
	local packages
	packages="$1"
	if [ "$PKGINST" != "brew" ]; then
		$PKGINST remove $packages
		$PKGINST autoremove
	else
		$PKGINST uninstall $packages
	fi
}

# install a command or file from a package
function install_from {
	local file package which
	file="$1"
	package="$2"
	if [ -z "$package" ]; then
		package="$file"
	fi
	which=`which "$file"`
	if [ ! -z "$which" ] ; then
		OK "command $file exists [$which]"
	else
		file_exists "$file" > /dev/null || (echo want to install cmd/file $file from $package; $PKGINST install "$package")
		which=`which "$file"`
		if [ ! -z "$which" ] ; then
			OK "command $file exists [$which]"
		else
			file_exists "$file" "use dpkg -L $package to get list of files installed by package"
		fi
	fi
}

# Install commands/files from specific packages specified as input list with : separation
# cmd1:pkg1 file2:pkg2 ...
function installs_from {
	local list message error file_pkg file package
	list="$1"
	message="$2"
	error=""
	for file_pkg in $list
	do
		# split the file:pkg string into vars
		split_colon $file_pkg; file="$SPLIT1"; package="$SPLIT2"
		install_from $file $package || error="$error $file_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_from$error [$message]"
		error=1
	else
		error=0
	fi
	return $error
}

# install a file from a given package
function install_file_from {
	local file package
	file="$1"
	package="$2"
	file_exists "$file" > /dev/null || (echo want to install file $file from $package; $PKGINST install "$package")
	file_exists "$file" "use dpkg -L $package to get list of files installed by package"
}

# Install files from specific packages specified as input list with : separation
# file1:pkg1 file2:pkg2 ...
function install_files_from {
	local list message options error file_pkg file package
	list="$1"
	message="$2"
	options="$3"
	error=""
	for file_pkg in $list
	do
		# split the file:pkg string into vars
		split_colon $file_pkg; file="$SPLIT1"; package="$SPLIT2"
		install_file_from $file $package $options || error="$error $file_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_files_from$error [$message]"
	fi
	return $error
}

#============================================================================
# servers and daemons

# Check if a server (just a command) is running
function is_server_running {
	local cmd message
	cmd="$1"
	message="$2"
	if ps -ef --cols 256 | grep $cmd | grep -v grep ; then
		OK "$cmd is running"
	else
		NOT_OK "$cmd is not running [$message]"
		return 1
	fi
	return 0
}

# Check if a server (just a command) is running with a specified port
function is_server_running_on_port {
	local cmd port message
	cmd="$1"
	port="$2"
	message="$3"
	if ps -ef --cols 256 | grep $cmd | grep $port | grep -v grep ; then
		OK "$cmd is running on port $port"
	else
		NOT_OK "$cmd is not running on port $port [$message]"
		return 1
	fi
	return 0
}

# Check that a server (just a command) is not running
function server_should_not_be_running {
	local cmd message
	cmd="$1"
	message="$2"
	if ps -ef --cols 256 | grep $cmd | grep -v grep ; then
		NOT_OK "$cmd should not be running [$message]"
		return 1
	else
		OK "$cmd is not running"
	fi
	return 0
}

# Check that a server (just a command) is not running with a specified port
function server_should_not_be_running_on_port {
	local cmd message
	cmd="$1"
	port="$2"
	message="$3"
	if ps -ef --cols 256 | grep $cmd | grep $port | grep -v grep ; then
		NOT_OK "$cmd should not be running on port $port [$message]"
		return 1
	else
		OK "$cmd is not running on port $port"
	fi
	return 0
}

# Check if port is listening like your web server
function is_port_listening {
	local host port message
	host="$1"
	port="$2"
	message="$3"
	if nc localhost "$port" < /dev/null > /dev/null; then
		OK "$host:$port is listening"
	else
		NOT_OK "$host:$port is not listening [$message]"
		return 1
	fi
	return 0
}

# Check that a port is not listening
function port_should_not_be_listening {
	local host port message
	host="$1"
	port="$2"
	message="$3"
	if nc localhost "$port" < /dev/null > /dev/null; then
		NOT_OK "$host:$port should not be listening [$message]"
		return 1
	else
		OK "$host:$port is not listening"
	fi
	return 0
}

#============================================================================
# node/npm/grunt related commands and packages

function node_check {
	NODE=node
	if ! which $NODE > /dev/null; then
		NODE=nodejs
	fi
	if ! which $NODE > /dev/null; then
		NOT_OK "node command does not exist"
		return 1
	fi
	return 0
}

function install_node {
	local named version
	named=$1
	version=$named
	if n --$named > /dev/null; then
		version=`n --$named`
	fi
	if ls_node_vers | grep $version; then
		OK "node $named version is installed: $version"
	else
		NOT_OK "MAYBE node $named version is not installed: $version"
		sudo n $named
		if ls_node_vers | grep $version; then
			OK "node $named version is installed: $version"
		else
			ls_node_vers
			NOT_OK "node [$named] version is not installed: [$version]"
			return 1
		fi
	fi
	return 0
}

function ls_node_vers {
	ls /usr/local/n/versions/node
}

# Check that a node module is available
function node_module_exists {
	local module message NODE
	module="$1"
	message="$2"
	node_check
	if $NODE -e 'try { var arg = process.argv[1]; require(arg); console.log("OK node module " + arg + " is installed"); process.exit(0); } catch (err) { console.error(process.execPath + " " + process.version); process.exit(1)}' -- $module > /dev/null; then
		OK "node module $module is installed"
	else
		NOT_OK "node module $module is not installed [$message]"
		return 1
	fi
	return 0
}

# Install a command or file with the node package manager
function install_npm_command_from {
	local command package
	command="$1"
	package="$2"
	if [ -z "$package" ]; then
		package="$command"
	fi
	cmd_exists "$command" > /dev/null || (echo want to install npm command $command from npm $package; npm install "$package")
	cmd_exists "$command" || return 1
}

# Install a bunch of commands with the node package manager
function install_npm_commands_from {
	local list error cmd_pkg cmd package
	list="$1"
	error=""
	for cmd_pkg in $list
	do
		# split the cmd:pkg string into vars
		split_colon $cmd_pkg; cmd="$SPLIT1"; package="$SPLIT2"
		install_npm_command_from $cmd $package || error="$error $cmd_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_npm_commands_from$error"
		error=1
	else
		error=0
	fi
	return $error
}

function uninstall_npm_global_packages {
	local packages
	packages="$1"
	sudo npm remove -g $packages
}

# Install a global command with the node package manager
function install_npm_global_command_from {
	local file package which
	file="$1"
	package="$2"
	if [ -z "$package" ]; then
		package="$file"
	fi
	which=`which "$file"`
	if [ ! -z "$which" ] ; then
		OK "command $file exists [$which]"
	else
		file_exists "$file" > /dev/null || (echo want to install npm global cmd/file $file from npm $package; sudo npm install -g "$package")
		which=`which "$file"`
		if [ ! -z "$which" ] ; then
			OK "command $file exists [$which]"
		else
			file_exists "$file" "use locate $package | grep node_modules to find what files are installed by npm package"
		fi
	fi
}

# Always Install a global package with the node package manager
function always_install_npm_global_from {
	local command package
	command="$1"
	package="$2"
	if [ -z "$package" ]; then
		package="$command"
	fi
	sudo npm install -g "$package"
}

# Always Install a bunch of global packages with the node package manager
function always_install_npm_globals_from {
	local list error cmd_pkg cmd package
	list="$1"
	error=""
	for cmd_pkg in $list
	do
		# split the cmd:pkg string into vars
		split_colon $cmd_pkg; cmd="$SPLIT1"; package="$SPLIT2"
		echo npm global1: $cmd : $package
		always_install_npm_global_from $cmd $package || error="$error $cmd_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for always_install_npm_globals_from$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Force Install a global command with the node package manager
function force_install_npm_global_command_from {
	local command package
	command="$1"
	package="$2"
	if [ -z "$package" ]; then
		package="$command"
	fi
	echo npm global2 force: $package
	sudo npm install --force -g "$package"
	cmd_exists "$command"
}

# Install a bunch of  global commands with the node package manager
function install_npm_global_commands_from {
	local list error cmd_pkg cmd package
	list="$1"
	error=""
	for cmd_pkg in $list
	do
		# split the cmd:pkg string into vars
		split_colon $cmd_pkg; cmd="$SPLIT1"; package="$SPLIT2"
		echo npm global3: $cmd : $package
		install_npm_global_command_from $cmd $package || error="$error $cmd_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_npm_global_commands_from$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Force Install a bunch of  global commands with the node package manager
function force_install_npm_global_commands_from {
	local list error cmd_pkg cmd package
	list="$1"
	error=""
	for cmd_pkg in $list
	do
		# split the cmd:pkg string into vars
		split_colon $cmd_pkg; cmd="$SPLIT1"; package="$SPLIT2"
		echo npm global4 force: $cmd : $package
		force_install_npm_global_command_from $cmd $package || error="$error $cmd_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for force_install_npm_global_commands_from$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Check if an npm package is installed
function is_npm_global_package_installed {
	local package message
	package="$1"
	message="$2"
	if npm ls -g $package | grep '(empty)' > /dev/null; then
		NOT_OK "npm global package $package is not installed [$message]"
		return 1
	else
		OK "npm global package $package is installed"
	fi
	return 0
}

# Install a new project template for grunt system
function install_grunt_template_from {
	local template package dir
	template="$1"
	package="$2"
	dir="$HOME/.grunt-init/$template"
	dir_exists "$dir" > /dev/null || (echo want to install grunt template $template from $package; git clone https://github.com/gruntjs/$package "$dir")
	dir_exists "$dir"
}

# Install a bunch of new project template for grunt system
function install_grunt_templates_from {
	local list error tmp_pkg template package
	list="$1"
	error=""
	for tmp_pkg in $list
	do
		# split the template:pkg string into vars
		split_colon $tmp_pkg; template="$SPLIT1"; package="$SPLIT2"
		install_grunt_template_from $template $package || error="$error $tmp_pkg"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_grunt_templates_from$error"
		error=1
	else
		error=0
	fi
	return $error
}

#============================================================================
# apm related commands and packages

# Check that an apm module is available
function apm_module_exists {
	local module message
	module="$1"
	message="$2"

	if apm list | egrep \\s$module@; then
		OK "apm module $module is installed"
	else
		NOT_OK "apm module $module is not installed [$message]"
		return 1
	fi
	return 0
}

function install_apm_module {
	local module
	module="$1"
	apm_module_exists "$module" > /dev/null || (echo want to install apm module $module; apm install "$module")
	apm_module_exists "$module"
}

function install_apm_modules_from {
	local list message error package
	list="$1"
	message="$2"
	error=""
	for package in $list
	do
		install_apm_module "$package" || error="$error $package"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_apm_module$error [$message]"
		error=1
	else
		error=0
	fi
	return $error
}

#============================================================================
# perl related setup

# Check that a perl module is available
function perl_module_exists {
	local module message
	module="$1"
	message="$2"
	if perl -M$module -e 'my $ver = eval "\$$ARGV[0]::VERSION"; print "OK perl module $ARGV[0] v$ver is installed\n"' $module > /dev/null; then
		OK "perl module $module is installed"
	else
		NOT_OK "perl module $module is not installed [$message]"
		return 1
	fi
	return 0
}

# Check that a specific version perl module is available
function perl_module_version_exists {
	local module version message
	module="$1"
	version="$2"
	message="$3"
	if perl -M$module -e 'my $ver = eval "\$$ARGV[0]::VERSION"; my $msg = "NOT OK perl module $ARGV[0] v$ver is installed, expected v$ARGV[1]\n"; if ($ver ne $ARGV[1]) { print $msg; exit 1; }' $module $version; then
		OK "perl module $module version $version is installed"
	else
		NOT_OK "perl module $module version $version is not installed [$message]"
		return 1
	fi
	return 0
}

# Check that a bunch of perl modules are available
function perl_modules_exist {
	local modules error mod
	modules="$1"
	error=""
	for mod in $modules
	do
		perl_module_exists "$mod" "sudo cpanp install $mod" || error="$error $mod"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for perl_modules_exist$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Install as many perl modules as possible
function install_perl_modules {
	local modules error mod
	modules="$1"
	error=""

	for mod in $modules
	do
		if [ ! -z "$mod" ]; then
##         perl_module_exists $mod > /dev/null || (echo want to install perl module $mod ; sudo cpanp install "$mod")
			perl_module_exists $mod > /dev/null || (echo want to install perl module $mod ; sudo cpanm "$mod")
			perl_module_exists $mod || error="$error $mod"
		fi
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_perl_modules$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Force to install a bunch of perl modules
function force_install_perl_modules {
	local modules error mod
	modules="$1"
	error=""
	for mod in $modules
	do
		if [ ! -z "$mod" ]; then
			echo forced to install perl module $mod
##         sudo cpanp install "$mod"
			sudo cpanm "$mod"
			perl_module_exists $mod || error="$error $mod"
		fi
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for force_install_perl_modules$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Install a specific version of a perl module from a locally downloaded archive
function install_perl_module_version_from_archive {
	local module version location archive message
	module="$1"
	version="$2"
	location="$3"
	archive="$4"
	message="$5"
	if perl_module_version_exists "$module" "$version" "$message"; then
		return 0
	else
		dir_exists "$location" "directory for local archive file"
		file_exists "$location/$archive.tar.gz" "local archive file for $message"
		tar xvzf "$location/$archive.tar.gz" && dir_exists "$archive" "extracted archive not in expected location"
		build_perl_project "$archive"
		perl_module_version_exists "$module" "$version" "$message"
	fi
}

# Install a specific version of a perl module from a locally downloaded archive without tests
function install_perl_module_version_from_archive_no_tests {
	local module version location archive message
	module="$1"
	version="$2"
	location="$3"
	archive="$4"
	message="$5"
	if perl_module_version_exists "$module" "$version" "$message"; then
		return 0
	else
		dir_exists "$location" "directory for local archive file"
		file_exists "$location/$archive.tar.gz" "local archive file for $message"
		tar xvzf "$location/$archive.tar.gz" && dir_exists "$archive" "extracted archive not in expected location"
		build_perl_project_no_tests "$archive"
		perl_module_version_exists "$module" "$version" "$message"
	fi
}

# Install perl project dependencies
function install_perl_project_dependencies {
	local dir error
	dir="$1"
	error=1
	push_dir "$dir" "install perl dependencies for project"
	if [ -f Build.PL ]; then
		perl Build.PL && sudo ./Build installdeps && error=0
	else
		if [ -f Makefile.PL ]; then

			perl Makefile.PL && cpanm --installdeps --sudo . && error=0
		else
			echo MAYBE NOT OK "$dir" no Build.PL or Makefile.PL found so no dependencies to install
			error=0
		fi
	fi
	popd > /dev/null
	if [ $error == 1 ]; then
		NOT_OK "errors for install_perl_project_dependencies $dir"
	fi
	return $error
}

# Install multiple perl project dependencies
function install_all_perl_project_dependencies {
	local dirs error dir
	dirs="$1"
	error=""
	for dir in $dirs
	do
		if [ ! -z "$dir" ]; then
			install_perl_project_dependencies "$dir" || error="$error $dir"
		fi
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_all_perl_project_dependencies$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Do a standard perl project build sequence
function build_perl_project {
	local dir error
	dir="$1"
	error=1
	push_dir "$dir"
	echo build perl project in dir `pwd`
	touch before_build.timestamp
	if [ -f Build.PL ]; then
		perl Build.PL && ./Build && ./Build test && sudo ./Build install && error=0
	else
		if [ -f Makefile.PL ]; then
			perl Makefile.PL && make && make test && sudo make install && error=0
		else
			echo MAYBE NOT OK "$dir" no Build.PL or Makefile.PL found so nothing to build
		fi
	fi
	find . -newer before_build.timestamp
	pop_dir
	if [ $error == 1 ]; then
		NOT_OK "errors for build_perl_project $dir"
	fi
	return $error
}

# Build a perl project and install omitting tests, in case failures are temporarily allowed
function build_perl_project_no_tests {
	local dir error
	dir="$1"
	error=1
	push_dir "$dir"
	echo Build perl project in dir `pwd`
	touch before_build.timestamp
	echo WARNING: build will skip test phase, may install with failing tests.
	if [ -f Build.PL ]; then
		perl Build.PL && ./Build && sudo ./Build install && error=0
	else
		if [ -f Makefile.PL ]; then
			perl Makefile.PL && make && sudo make install && error=0
		else
			echo MAYBE NOT OK "$dir" no Build.PL or Makefile.PL found so nothing to build
		fi
	fi
	find . -newer before_build.timestamp
	pop_dir
	if [ $error == 1 ]; then
		NOT_OK "errors for build_perl_project_no_tests $dir"
	fi
	return $error
}

# Build as many perl projects as possible
function build_perl_projects {
	local dirs error dir
	dirs="$1"
	error=""
	for dir in $dirs
	do
		if [ ! -z "$dir" ]; then
			build_perl_project "$dir" || error="$error $dir"
		fi
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for build_perl_projects$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Build as many perl projects as possible without running tests
function build_perl_projects_no_tests {
	local dirs error dir
	dirs="$1"
	error=""
	for dir in $dirs
	do
		if [ ! -z "$dir" ]; then
			build_perl_project_no_tests "$dir" || error="$error $dir"
		fi
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for build_perl_projects_no_tests$error"
		error=1
	else
		error=0
	fi
	return $error
}

#============================================================================
# ruby related setup

# Check that a ruby gem module is available
function ruby_gem_exists {
	local gem message
	gem="$1"
	message="$2"
	if gem list --local | grep "^$gem (" > /dev/null; then
		OK "ruby gem $gem is installed"
	else
		NOT_OK "ruby gem $gem is not installed [$message]"
		return 1
	fi
	return 0
}

# Check that a bunch of ruby gems are available
function ruby_gems_exist {
	local gems error gem
	gems="$1"
	error=""
	for gem in $gems
	do
		ruby_gem_exists "$gem" "sudo gem install $gem" || error="$error"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for ruby_gems_exist$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Install as many ruby gems as possible
# the list of gems may contain a version number
# gem1:ver1 gem2:ver2 ...
function install_ruby_gems {
	local gems error gem_ver gem version
	gems="$1"
	error=""

	for gem_ver in $gems
	do
		# split the gem:ver string into vars
		split_colon $gem_ver; gem="$SPLIT1"; version="$SPLIT2"
		if [ ! -z "$gem" ]; then
			if [ ! -z "$version" ]; then
				# version number given
				version="--version=$version"
			fi
			# maybe do a version check also
			ruby_gem_exists $gem > /dev/null || (echo want to install ruby gem $gem_ver ; sudo gem install "$gem" $version)
			ruby_gem_exists $gem || error="$error $gem_ver"
		fi
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_ruby_gems$error"
		error=1
	else
		error=0
	fi
	return $error
}

#============================================================================
# python3 related setup

# Check that a python3 pip package is available
function python3_pip_exists {
	local pip message
	pip="$1"
	message="$2"
	if pip3 list | grep -E "^$pip\s+[0-9]" > /dev/null; then
		OK "python3 pip $pip is installed"
	else
		NOT_OK "python3 pip $pip is not installed [$message]"
		return 1
	fi
	return 0
}

# Check that a bunch of python3 pips are available
function python3_pips_exist {
	local pips error pip
	pips="$1"
	error=""
	for pip in $pips
	do
		python3_pip_exists "$pip" "pip3 install $pip" || error="$error"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for python3_pips_exist$error"
		error=1
	else
		error=0
	fi
	return $error
}

# Install as many python3 pips as possible
function install_python3_pips {
	local pips error pip
	pips="$1"
	error=""

	for pip in $pips
	do
		python3_pip_exists $pip > /dev/null || (echo want to install python3 pip $pip ; pip3 install "$pip")
		python3_pip_exists $pip || error="$error $pip"
	done
	if [ ! -z "$error" ]; then
		NOT_OK "errors for install_python3_pip$error"
		error=1
	else
		error=0
	fi
	return $error
}

#============================================================================
# check configuration within files

# Check that a config file has exact text.
# Will not look at lines commented out by a hash character.
function config_has_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	file_exists "$file" "$message"
	if egrep -v '^\s*#' "$file" | grep "$text" > /dev/null; then
		OK "config has text: \"$file\" \"$text\""
	else
		NOT_OK "config missing text: \"$file\" \"$text\" [$message]" && echo grep \""$text"\" \""$file"\"
		return 1
	fi
	return 0
}

# Check that a config file has exact text, if the file exists.
# Will not look at lines commented out by a hash character.
function maybe_config_has_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	if [ -f "$file" ] ; then
		config_has_text "$file" "$text" "$message"
	else
		OK "config file \"$file\" not present to check contents"
	fi
}

# Check that a config file has regex matches some text.
# Will not look at lines commented out by a hash character.
function config_contains_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	file_exists "$file" "$message"
	if egrep -v '^\s*#' "$file" | egrep "$text" > /dev/null; then
		OK "config contains regex: \"$file\" \"$text\""
	else
		NOT_OK "config missing regex: egrep \"$text\" \"$file\" [$message]"
		return 1
	fi
	return 0
}

# exact check for text in file
function file_has_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	file_exists "$file" "$message"
	if grep "$text" "$file" > /dev/null; then
		OK "file has text: \"$file\" \"$text\""
	else
		NOT_OK "file missing text: \"$file\" \"$text\" [$message]" && echo grep \""$text"\" \""$file"\"
		return 1
	fi
	return 0
}

# exact check for text in file if file exists
function maybe_file_has_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	if [ -f "$file" ] ; then
		file_has_text "$file" "$text" "$message"
	else
		OK "file \"$file\" not present to check contents"
	fi
}

# regex check for text in file
function file_contains_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	file_exists "$file" "$message"
	if egrep "$text" "$file" > /dev/null; then
		OK "file contains regex: \"$file\" \"$text\""
	else
		NOT_OK "file missing regex: egrep \"$text\" \"$file\" [$message]"
		return 1
	fi
	return 0
}

# regex check for text in file grepping for key to filter on
function file_contains_key_value {
	local file key text message
	file="$1"
	key="$2"
	text="$3"
	message="$4"
	file_exists "$file" "$message"
	if egrep "$key" "$file" | egrep "$text" > /dev/null; then
		OK "file contains key value regex: \"$file\" \"$key\" \"$text\""
	else
		NOT_OK "file missing key value regex: egrep \"$key\" \"$file\" | egrep \"$text\" [$message]" && egrep "$key" "$file"
		return 1
	fi
	return 0
}

function file_must_not_have_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	file_exists "$file" "$message"
	if grep "$text" "$file" > /dev/null; then
		NOT_OK "file should not have text: "$file" "$text" [$message]"
		return 1
	else
		OK "file does not have text: \"$file\" \"$text\""
		echo grep \""$text"\" \""$file"\"
	fi
	return 0
}

# exact check for text in file which uses # for comment lines
function commented_file_has_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	file_exists "$file" "$message"
	if egrep -v '^#' "$file" | grep "$text" > /dev/null; then
		OK "file has text: \"$file\" \"$text\""
	else
		NOT_OK "file missing text: \"$file\" \"$text\" [$message]" && echo grep \""$text"\" \""$file"\"
		return 1
	fi
	return 0
}

function commented_file_must_not_have_text {
	local file text message
	file="$1"
	text="$2"
	message="$3"
	file_exists "$file" "$message"
	if egrep -v '^#' "$file" | grep "$text" > /dev/null; then
		NOT_OK "file should not have text: "$file" "$text" [$message]"
		return 1
	else
		OK "file does not have text: \"$file\" \"$text\""
		echo grep \""$text"\" \""$file"\"
	fi
	return 0
}

function ini_file_has_text {
	local dir file text message
	dir=`dirname "$1"`
	file=`basename "$1"`
	text="$2"
	message="$3"
	file_exists "$dir/$file" "$message"
	if [ ! -e "$INI_DIR/$file" ]; then
		echo "making searchable ini file from $dir/$file"
		ini-inline.pl "$dir/$file" > "$INI_DIR/$file"
	fi
	file_has_text "$INI_DIR/$file" "$text" "$message"
}

function ini_file_must_not_have_text {
	local dir file text message
	dir=`dirname "$1"`
	file=`basename "$1"`
	text="$2"
	message="$3"
	file_exists "$dir/$file" "$message"
	file_exists "$INI_DIR/$file" "$message" > /dev/null || (ini-inline.pl "$dir/$file" > "$INI_DIR/$file")
	file_must_not_have_text "$INI_DIR/$file" "$text" "$message"
}

function ini_file_contains_key_value {
	local dir file key text message
	dir=`dirname "$1"`
	file=`basename "$1"`
	key="$2"
	text="$3"
	message="$4"
	file_exists "$dir/$file" "$message"
	file_exists "$INI_DIR/$file" "$message" > /dev/null || (ini-inline.pl "$dir/$file" > "$INI_DIR/$file")
	file_contains_key_value "$INI_DIR/$file" "$key" "$text" "$message"
}

function crontab_has_command {
	local command config message
	command="$1"
	config="$2"
	message="$3"
	if crontab -l | grep "$command"; then
		OK "crontab has command $command"
	else
		NOT_OK "crontab missing command $command trying to install [$message]" && (crontab -l; echo "$config" ) | crontab -
		return 1
	fi
	return 0
}

#============================================================================
# apt-get configuration

function apt_has_source {
	local source message
	source="$1"
	message="$2"
	commented_file_has_text /etc/apt/sources.list "$source" "$message" || (sudo add-apt-repository "$source" && touch go.sudo)
}

function apt_has_source_listd {
	local name source message file
   name="$1"
	source="$2"
	message="$3"
   file="/etc/apt/sources.list.d/$name.list"
   make_root_file_exist "$file" "$source" "$message"
	file_has_text "$file" "$source"
}

function apt_has_source_listd_check {
	local name source check message file
   name="$1"
	source="$2"
   check="$3"
	message="$4"
   file="/etc/apt/sources.list.d/$name.list"
   make_root_file_exist "$file" "$source" "$message"
	file_has_text "$file" "$check"
}

function apt_must_not_have_source {
	local source message
	source="$1"
	message="$2"
	commented_file_must_not_have_text /etc/apt/sources.list "$source" "$message"
}

function apt_has_key {
	local key url message
	key="$1"
	url="$2"
	message="$3"
	if sudo apt-key list | grep "$key"; then
		OK "apt-key has $key"
	else
		NOT_OK "apt-key missing $key trying to install [$message]" || echo " "
		http_dump "$url" | sudo apt-key add -
		if sudo apt-key list | grep "$key"; then
			OK "apt-key installed $key"
		else
			NOT_OK "apt-key could not install $key"
			return 1
		fi
	fi
	return 0
}

function apt_has_key_adv {
	local keycheck key url message
	keycheck="$1"
	key="$2"
	url="$3"
	message="$4"
	if sudo apt-key list | grep "$keycheck"; then
		OK "apt-key has $key"
	else
		NOT_OK "apt-key adv missing $key trying to install [$message]" || echo " "
		sudo apt-key adv --keyserver "$url" --recv-keys $key
		if sudo apt-key list | grep "$keycheck"; then
			OK "apt-key installed $key"
		else
			NOT_OK "apt-key could not install $key [$message]"
			return 1
		fi
	fi
	return 0
}

function apt_has_key_adv_recv {
	local keycheck key url message
	keycheck="$1"
	key="$2"
	url="$3"
	message="$4"
	if sudo apt-key list | grep "$keycheck"; then
		OK "apt-key has $key"
	else
		NOT_OK "apt-key adv missing $key trying to install [$message]" || echo " "
		sudo apt-key adv --keyserver "$url" --recv $key
		if sudo apt-key list | grep "$keycheck"; then
			OK "apt-key installed $key"
		else
			NOT_OK "apt-key could not install $key [$message]"
			return 1
		fi
	fi
	return 0
}

#============================================================================
# mysql related setup

function mysql_connection_check {
	local user password
	user=$1
	password=$2
	echo Checking mysql connection to localhost for user $user
	if mysql -u $user -p$password -e 'SHOW DATABASES; SHOW GRANTS;'; then
		OK "$user can connect to mysql on localhost"
	else
		NOT_OK "$user cannot connect to mysql on localhost"
		return 1
	fi
	return 0
}

# Check that a database is reachable on localhost for a user
function mysql_check_for_database {
	local user database password
	database=$1
	user=$2
	# optional password
	password=$3
	echo Check for mysql database $database with user $user
	if mysql -u $user -p$password -e "SELECT schema_name, 'exists' FROM information_schema.schemata WHERE schema_name = '$database';" | grep $database; then
		OK "$database exists on mysql localhost"
	else
		NOT_OK "$database does not exist on mysql localhost for user $user"
		return 1
	fi
	return 0
}

# Check for a database and make it if not present
function mysql_make_database_exist {
	local database user
	database=$1
	user=$2
	# optional password
	password=$3
	if mysql_check_for_database $database $user $password > /dev/null; then
		OK "$database exists on mysql localhost"
	else
		NOT_OK "MAYBE $database does not exist on mysql localhost will try to create with user $user" && mysql -u $user -p$password -e "CREATE DATABASE $database"
		mysql_check_for_database $database $user $password || return 1
	fi
	return 0
}

function mysql_make_test_user_exist_on_database {
	local user password database superuser
	user=$1
	password=$2
	database=$3
	superuser=$4
	if mysql -u $user -p$password -e 'SHOW GRANTS;' | grep $user; then
		OK "$user exists with grants"
	else
		# drop and recreate user with no errors
		NOT_OK "$user not configured. Will set it up with $superuser mysql account" && mysql -u $superuser -D mysql -p$password <<SQL
		GRANT USAGE ON *.* TO '$user'@'localhost';
		DROP USER '$user'@'localhost';
		CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';
		GRANT ALL ON $database.* TO '$user'@'localhost';
		GRANT SUPER ON *.* TO '$user'@'localhost';
		FLUSH PRIVILEGES;
SQL
		mysql_connection_check $user $password
	fi
}

# run a mysql script against a database an fail if there were any errors
function mysql_run_script_on_database {
	local sql_file user password database message
	sql_file=$1
	user=$2
	password=$3
	database=$4
	message=$5
	temp_file=`mktemp --tmpdir=/tmp/$USER`
	file_exists $sql_file "sql file for $message"
	if mysql -u $user -p$password -D $database < $sql_file 2> $temp_file; then
		if [ -s $temp_file ]; then
			echo "ERROR in $sql_file:"
			cat $temp_file
			rm $temp_file
			NOT_OK "script $sql_file has ERRORS on database $database [$message]"
		else
			OK "script $sql_file ran on database $database [$message]"
		fi
	else
		echo "ERROR in $sql_file:"
		cat $temp_file
		rm $temp_file
		NOT_OK "script $sql_file FAILED on database $database [$message]"
	fi
}

# check for user account on localhost mysql
#mysql -u root -D mysql -p -e 'SELECT user, host FROM user WHERE user="test_user"' | grep localhost

#========================================================================
# miscellaneous configuration

function has_ssh_keys {
	local cfg
	cfg=$HOME/bin/cfg/$1
	# need to upload ssh public key to github before getting grunt templates
	file_exists $cfg/id_rsa.pub > /dev/null \
	|| (ssh-keygen -t rsa && mv $HOME/.ssh/id_rsa* $cfg/)
	file_exists $cfg/id_rsa.pub "ssh keys should exist"

	file_linked_to $HOME/.ssh/id_rsa.pub $cfg/id_rsa.pub "public SSH key"
	file_linked_to $HOME/.ssh/id_rsa $cfg/id_rsa "private SSH key"
}

function split_colon {
	local one_two
	one_two="$1"
	# split the file:pkg string into vars
	# echo "WHAT: [$one_two]"
	# not working on mac!
	# IFS=':' read SPLIT1 SPLIT2 <<< $one_two
	SPLIT1=`echo "$one_two" | cut -d ':' -f 1`
	SPLIT2=`echo "$one_two" | cut -d ':' -f 2`
}
