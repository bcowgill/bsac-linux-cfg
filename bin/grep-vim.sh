#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# grep for a simple pattern in a file and then launch vim at each match position
# WINDEV tool useful on windows development machine

# http://vim.wikia.com/wiki/Using_normal_command_in_a_script_for_searching
# http://vimdoc.sourceforge.net/htmldoc/eval.html#search()
# within vim  :N goes to line N and   ^Ml goes to column M (sort of it actually goes to M positions after the first non-whitespace on the line)
# vim "+call cursor(3, 2)" tests.sh  #  for line and column
# vim "+normal <LINE>G<COLUMN>|"

# TODO parse a stack trace?
# stack trace from jest test run:
# at Object.willGetInvitationFromActivationCode (src/api/selfRegistration.js:171:18)

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] pattern file-name...

This will grep for the pattern specified in the files provided and create a bash script to launch vim or VS code at the line number and column position of each match.

pattern    the text to find in the file provided.
file-name  the file or list of files to look within. or additional grep command options i.e. -r . to grep recursively in current directory.
--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

If the 'code' command is available on the path, then VS Code will be used. Otherwise vim will be used.

See also grep-lint.sh grep-file-line.sh

Example:

	touch go.sh; chmod +x go.sh
	grep-vim.sh function tests.sh > go.sh; ./go.sh

	grep-vim.sh toHaveLength -r tests/ > go.sh; ./go.sh
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

FIND="$1";
shift

if [ -z "$FIND" ]; then
	usage 1
fi

if [ -z "$1" ]; then
	usage 1
fi

if which code > /dev/null; then
	CODE=1
fi

grep -n -H "$FIND" $* | \
	FIND="$FIND" CODE=$CODE perl -pne '
	BEGIN { print qq{#!/bin/bash\n}; }
	$q = chr(39);
	chomp;
	s{\A\(standard\sinput\):\d+:}{}xmsg;
	print qq{\n# $_\n};
	my ($file, $line, $column) = split(/:/g);
	$file =~ s{\A"(.+)"\z}{$1}xms;
	if ($column && $column =~ m{\A\d+\z}xms)
	{
		if ($ENV{CODE})
		{
			$_ = qq{code $q$file:$line:$column$q\n};
		}
		else
		{
			$_ = qq{vim +"call cursor(${line},$column)" "$file"\n};
			#$_ = qq{vim +"normal ${line}G$column|" "$file"\n};
		}
	}
	else
	{
		if ($ENV{CODE})
		{
			# MUSTDO find out which one actually works, next time...
			$_ = qq{code --goto $q$file:$line:1$q\n};
			#$_ = qq{code "$file:$line"\n};
		}
		else
		{
			$_ = qq{vim +$line -c "call search (${q}$ENV{FIND}$q)" "$file"\n}
		}
	}
	'

