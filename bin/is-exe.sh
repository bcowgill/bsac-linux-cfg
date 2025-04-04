#!/bin/bash
# used by ls-cmds.sh
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# WINDEV tool useful on windows development machine

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] file-name

This will exit successfully if the file provided is executable according to Windows.  If not it will exit with an error code.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

Meant to be used on Windows where every file is marked executable.  If the file has extension .exe or .com (but not .bat) then it is considered executable. Otherwise, the first few characters of the file are examined for a shebang line: #!/bin/bash is an example.

See also ls-cmds.sh
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
if echo "$*" | grep -- "--" > /dev/null; then
	echo "unknown parameter provided, please study the command usage below."
	echo ""
	usage 1
fi

if [ -z "$1" ]; then
	usage 1
fi

FILE="$1"
case "$FILE" in
   *.exe) exit 0;;
   *.com) exit 0;;
   *) head -c 10 "$FILE" | grep -E '^#!/' > /dev/null && exit 0;;
esac
exit 1
