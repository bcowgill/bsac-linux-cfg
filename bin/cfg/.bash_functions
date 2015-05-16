# bash functions
# Brent S.A. Cowgill

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

fi

# wcd.exec command present then we define wcd function
# on cygwin the command is wcd.exe and no need for a function
which wcd.exec > /dev/null 2>&1
if [ "$?" == "0" ]; then
   #echo we have wcd.exec installed
   unalias wcd 2> /dev/null
   if [ -f /usr/share/wcd/wcd-include.sh ]; then
      . /usr/share/wcd/wcd-include.sh
   fi
fi

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

