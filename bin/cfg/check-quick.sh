#!/bin/bash
# A Quick Check of new configuration functions from lib-check-system.sh before adding it to check-system.sh for good.

# terminate on first error
set -e
# turn on trace of currently running command if you need it
if [ ! -z "$DEBUG" ]; then
	set -x
fi

if [ -e $HOME/bin ]; then
	set -o posix
	set > $HOME/bin/check-system.env.quick0.log
	echo Updated $HOME/bin/check-system.env.quick0.log
	set +o posix
fi

if [ ! -z $1 ]; then
	BAIL_OUT="$1"
fi

if which lib-check-system.sh; then
	source `which lib-check-system.sh`
else
	echo "NOT OK cannot find lib-check-system.sh"
	echo Make sure $HOME/bin is on your path and try again.
	exit 1
fi

function BAIL_OUT {
	local stage
	stage=$1
	echo "BAIL_OUT? $stage"
	if [ "x$BAIL_OUT" == "x$stage" ]; then
		NOT_OK "BAIL_OUT=$BAIL_OUT is set, stopping"
		exit 44
	fi
}

AUSER=$USER
MYNAME="Brent S.A. Cowgill"
COMPANY=
EMAIL=
[ -e ~/.COMPANY ] && source ~/.COMPANY
if [ -z "$EMAIL" ]; then
	echo You need to provide your email address in function set_env
	echo You can define it as EMAIL= in ~/.COMPANY file along with COMPANY=
	exit 1
fi
if which sw_vers > /dev/null 2>&1 ; then
	MACOS=1
fi
if [[ $OSTYPE == darwin* ]]; then
	MACOS=1
fi

#============================================================================
# begin actual system checking

BAIL_OUT begin

make_dir_world_readable "$HOME" "for updatedb command to index your home directory"
#dir_is_world_readable "$HOME" "for updatedb command to index your home directory"

OK "all checks complete"
ENDS
