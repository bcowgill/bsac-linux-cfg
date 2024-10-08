# bash functions
# Brent S.A. Cowgill

# similar to perl die, shows a messge on standard error and returns an error code.
die () {
	local msg
	msg="$*"
	echo "$msg" 1>&2
	return 1
}

# example of how to use die in bash functions, it doesn't actually throw so you have to use an err= value.
# see also cpstat below...
#test_die () {
#	local arg err
#	err=
#	arg=$1
#	if [ -z "$arg" ]; then err=42; die "You must provide an argument value."; fi
#	if [ -z $err ]; then
#		echo OK $arg
#	fi
#	return $err
#}

# show whichever command something is, a program, alias or shell function
whichever () {
	local cmd
	cmd=$1
	which $cmd 2> /dev/null
	alias | egrep "alias $cmd="
	command -V $cmd
}

# cpstat copies files with stats and progress
cpstat () {
	local sourceDir targetDir err
	sourceDir="$1"
	targetDir="$2"
	if [ -z "$sourceDir" -o ! -d "$sourceDir" ]; then err=1; die "You must provide a sourceDir for the copy."; fi
	if [ -z "$targetDir" -o ! -d "$targetDir" ]; then err=2; die "You must provide a targetDir for the copy."; fi
	if [ -z $err ]; then
		tar c "$sourceDir" | pv | tar x -C "$targetDir"
	fi
	return $err
}

# find-ez easy find shows just file name, size and time (alphabetically, tab-separated) for files in the given directory.
find-ez () {
	local sourceDir
	sourceDir="${1:-.}"
	pushd "$sourceDir" > /dev/null && find . -type f -printf '"%h/%f"\t%s\t%T+\n' | sort && popd > /dev/null
}
#
# find-dates shows just file date/time size and name (oldest first. tab-separated) for files in the given directory.
find-dates () {
	local sourceDir
	sourceDir="${1:-.}"
	pushd "$sourceDir" > /dev/null && find . -type f -printf '%T+ %12s "%h/%f"\n' | sort -n && popd > /dev/null
}

# find-datesr shows just file date/time size and name (newest first, tab-separated) for files in the given directory.
find-datesr () {
	local sourceDir
	sourceDir="${1:-.}"
	pushd "$sourceDir" > /dev/null && find . -type f -printf '%T+ %12s "%h/%f"\n' | sort -n -r && popd > /dev/null
}

# find-size easy find shows just file size, date/time and name (smallest first, tab-separated) for files in the given directory.
find-size () {
	local sourceDir
	sourceDir="${1:-.}"
	pushd "$sourceDir" > /dev/null && find . -type f -printf '%-12s %T+ "%h/%f"\n' | sort -n && popd > /dev/null
}

# find-sizer easy find shows just file size, date/time and name (smallest first, tab-separated) for files in the given directory.
find-sizer () {
	local sourceDir
	sourceDir="${1:-.}"
	pushd "$sourceDir" > /dev/null && find . -type f -printf '%-12s %T+ "%h/%f"\n' | sort -n -r && popd > /dev/null
}

# rvdiff reverses the files being diffed
rvdiff () {
	vdiff $2 $1
}

# touch_p function like mkdir -p
touch_p () {
	local dir
	dir=`dirname "$1"`
	[ -d "$dir" ] || mkdir -p "$dir"
	touch "$1"
}

# iselect command example of an enhanced cd command
#   database scan for enhanced cd command
which iselect > /dev/null 2>&1
if [ "$?" == "0" ]; then
	#echo we have iselect installed
cds () {
	(cd $HOME;
		find . -type d -print |\
		sed -e "s;^\.;$HOME;" |\
		sort -u >$HOME/.cdpaths ) &
}

#   definition of the enhanced cd command
ecd () {
	if [ -d "$1" ]; then
		builtin cd "$1"
	else
		builtin cd `egrep "/$1[^/]*$" $HOME/.cdpaths |\
			iselect -a -Q "$1" -n "chdir" \
			-t "Change Directory to..."`
	fi
	#PS1="\u@\h:$PWD\n:> "
}
#   definition of the enhanced pushd command
epushd () {
	if [ -d "$1" ]; then
		builtin pushd "$1"
	else
		builtin pushd `egrep "/$1[^/]*$" $HOME/.cdpaths |\
			iselect -a -Q "$1" -n "pushdir" \
			-t "Push Directory to..."`
	fi
	#PS1="\u@\h:$PWD\n:> "
}

fi

# wcd.exec command present then we define wcd function
# on cygwin the command is wcd.exe and no need for a function
which wcd.exec > /dev/null 2>&1
if [ "$?" == "0" ]; then
	#echo we have wcd.exec installed
	unalias wcd 2> /dev/null
	if [ -f /usr/share/wcd/wcd-include.sh ]; then
		. /usr/share/wcd/wcd-include.sh
		function pwcd
		{
			# a version of wcd which pushed the directory on the dirstack
			local WHERE
			\wcd "$1"
			WHERE=`pwd`
			cd - > /dev/null
			pushd "$WHERE"
		}
	fi
fi

# docker bash
function dbash
{
	local id
	id=$1
	docker exec -ti $id /bin/bash \
	|| docker exec -ti $id /bin/sh
}

# some functions for time/weather

function clock
{
	local line
	line="==============="
	while true; do
		clear
		echo $line
		date +%r
		echo $line
		sleep 1
	done
}

function weather
{
	local postcode URL
	postcode=${1:-SE3}
	URL="http://www.google.com/search?hl=en&lr=&client=firefox-a&rls=org.mozilla%3Aen-US%3Aofficial&q=weather+$postcode&btnG=Search"
	echo $URL
	declare -a WEATHERARRAY

	# to debug why it might not work.
	lynx "$URL"
	#WEATHERARRAY=( `lynx -dump "$URL" | grep -A 5 -m 1 "Weather in $postcode"` )
	#echo ${WEATHERARRAY[@]}
}

############################################################################
# Some example functions:(from cygwin default .bashrc file)
#
# a) function settitle
# settitle ()
# {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }
#
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
#
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
#
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
#
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
#
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
#
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
#
#   return 0
# }
#
# alias cd=cd_func

if [ "x$COMPANY" == "xwipro" ]; then
function grep_cfroutes
{
	local branch
	set +x
	for branch in $*; do
		echo $branch
		ls-cfroutes | grep $branch | sort
	done
}
fi

# https://github.com/robbyrussell/oh-my-zsh
function git_current_branch
{
	local ref
	ref=$(git symbolic-ref HEAD 2> /dev/null) || \
	ref=$(git rev-parse --short HEAD 2> /dev/null) || return
	echo ${ref#refs/heads/}
}

# Reset changes to a file in the last commit
# http://mjk.space/git-aliases-i-cant-live-without/
function grf
{
	git reset @~ "$@" && git commit --amend --no-edit
}

# Git grep and show a hit count or histogram per file matched and is sortable by count
# ggr_hits console | sort -h
function ggr_hits
{
	local match file
	match="$1"
	for file in `git grep -l "$1"`
	do
		echo `git grep "$1" $file | wc -l`: $file
	done
}

# Grep for typescript interface or type definition in current directory/node_modules
# tsgrep -l DateTimeFormat
function tsgrep
{
	grep $* `find . -name '*.d.ts'`
}
