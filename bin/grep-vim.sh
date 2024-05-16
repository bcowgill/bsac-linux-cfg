#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# grep for a simple pattern in a file and then launch vim at each match position
# http://vim.wikia.com/wiki/Using_normal_command_in_a_script_for_searching
# http://vimdoc.sourceforge.net/htmldoc/eval.html#search()
# WINDEV tool useful on windows development machine

# within vim  :N goes to line N and   ^Ml goes to column M (sort of it actually goes to M positions after the first non-whitespace on the line)
# vim "+call cursor(3, 2)" tests.sh  #  for line and column
# vim "+normal <LINE>G<COLUMN>|"

# Example:
# touch go.sh; chmod +x go.sh
# grep-vim.sh function tests.sh > go.sh; ./go.sh

# See also grep-lint.sh grep-file-line.sh

function usage {
	local code
	code=$1
	cmd=$(basename $0)
	echo "
$cmd [--help|--man|-?] pattern

This will grep for the pattern specified and create a bash script to launch vim at the line number and column position of each match.

--man   Shows help for this tool.
--help  Shows help for this tool.
-?      Shows help for this tool.

More detail ...

See also grep-lint.sh

Example:

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

FIND="$1";
shift

if [ -z "$FIND" ]; then
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
			$_ = qq{code "$file:$line:$column"\n};
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
			$_ = qq{code "$file:$line"\n};
		}
		else
		{
			$_ = qq{vim +$line -c "call search (${q}$ENV{FIND}$q)" "$file"\n}
		}
	}
	'
