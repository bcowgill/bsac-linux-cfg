#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# WINDEV tool useful on windows development machine

isexe=${0//ls-cmds/is-exe}
IS_WIN=`echo $OS | grep -i windows`

#echo IS_WIN=$IS_WIN  isexe=$isexe

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] [--full] path-to-scan

This will scan all directories in the PATH or path-to-scan and list every executable it finds with or without the absolute path.

--full  Shows the full path to each executable instead of just the command name.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

If your path has spaces in it you should replace them with the string: 0x20
as that will be replaced internally by a space when finding executables.

See also ls-cmds-used.sh, is-exe.sh

Example:

Find all short command names on the path except for shell and perl scripts and sort them.

$cmd | grep -vE '\.(sh|pl)$' | sort

List commands when your PATH contains spaces in it.

$cmd \${PATH// /0x20}
...
"
	exit $code
}
if [ "$1" == "--help" ]; then
	usage 0
fi
if [ "$1" == "--man" ]; then
	usage 0
fi
if [ "$1" == "-?" ]; then
	usage 0
fi
FULL=
if [ "$1" == "--full" ]; then
	FULL=1
	shift
fi
if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	echo ""
	usage 1
fi

PTH="$1"
if [ -z "$PTH" ]; then
	PTH="$PATH"
fi
# Remove duplicate directories from the path
PTH="`echo $PTH | perl -pne 's{:}{\n}xmsg' | sort | uniq`"

# show the path on stderr
#>&2 echo Using PATH="$PTH"

function find_exe {
	local path
	path=$1
	if [ -z "$IS_WIN" ]; then
		find "${path//0x20/ }" -maxdepth 1 -type f -executable
	else
		# on windows executables are .exe .com or have a shebang line at top
		find "${path//0x20/ }" -maxdepth 1 -type f \
			| FULL=$FULL IS="$isexe" perl -ne '
				chomp;
				my $out = $_;
				$out =~ s{\.(exe|com)\z}{}xmsi unless ($ENV{FULL});
				my $cmd = qq{$ENV{IS} "$_"};
				#print STDERR qq{CMD: $cmd == @{[system($cmd)]}\n};
				print qq{$out\n} unless system($cmd);
			'
	fi
}

for P in $PTH; do
	#>&2 echo P=$P
	if [ $FULL ]; then
		find_exe "$P"
	else
		find_exe "$P" | perl -pne 's{\A.+/}{}xms'
	fi
done
