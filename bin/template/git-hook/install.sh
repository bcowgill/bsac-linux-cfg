# install the named hook file as a git hook
HOOK=$1
RENAME=${2:-$HOOK}

if [ -z "$HOOK" ]; then
	cat <<EOF
usage: $0 hook-file [rename]

This script will install the named hook-file from this directory
into the .git/hooks directory for this repository.  If the file
needs to be renamed because it has a .suffix, supply it as the
second parameter.
EOF
	exit 1
fi

cp $HOOK ../../../.git/hooks/$RENAME
