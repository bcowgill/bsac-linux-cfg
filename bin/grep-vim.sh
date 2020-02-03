#!/bin/bash
# grep for a simple pattern and the launch vim at each match position
# http://vim.wikia.com/wiki/Using_normal_command_in_a_script_for_searching
# http://vimdoc.sourceforge.net/htmldoc/eval.html#search()


FIND="$1";
shift

if [ -z "$FIND" ]; then
	echo "
usage: $(basename $0) pattern ... other grep options ...

This will grep for the pattern specified and launch vim at the line number and column position of each match.
"
	exit 1
fi

grep -n "$FIND" $* | \
	FIND="$FIND" perl -pne '
	BEGIN { print qq{#!/bin/bash\n}; }
	$q = chr(39);
	my ($file, $line, $context) = split(/:/);
	$_ = qq{vim +$line -c "call search (${q}$ENV{FIND}$q)" $file\n}'
