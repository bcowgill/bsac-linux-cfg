#!/bin/bash
# WINDEV tool useful on windows development machine
# See also git-grep-skipped.sh
# MUSTDO make a test file for checking this
# scan the code for todo markers and other things we frown upon:
#	short variable names
#	some jshint settings being turned off
#	console.log, alert, debugger left in the code
#   skip or only on unit test suites/cases
# CUSTOM settings you may have to change on a new computer
dir=${1:-.}

BAD_CLASS=1
MISSING_CLASS=1

pushd $dir > /dev/null;
FILES=`git-ls-code.sh | egrep --invert-match --ignore-case '\.(less)$'`

egrep --with-filename --line-number \
'\@todo|\\
\b(MUSTDO|FIXME|BUGFIX|REFACTOR|QN|WARNING|DEPR(ECATED)?|[Hh]ack|HACK)\b|\\
\b(maxcomplexity|maxstatements|maxlen|latedef|strict|unused)\s*:|\\
\b(eqeqeq\s*:\s*false)|\\
\bconsole\.(log|info|warn|error|dir|time|timeEnd|trace|assert)|\\
\b(alert|xit|xdescribe)\(|\\
\bdebugger\b|\\
\.(skip|only)\(|\\
\bvar\s+([a-zA-Z]\w?|\w\w)\b|\\
,\s*[a-zA-Z_]\w?\s*,|\\
\(\s*[a-zA-Z_]\w?\s*\)|\\
\+\+[a-zA-Z_]\w?\b|\\
\b[a-zA-Z_]\w?\+\+' \
$FILES \
	| grep --perl-regexp --invert-match '\.spec\.js:\d+:(\s*it\(|.+\.to\.)'

if [ ${BAD_CLASS:-0} == 1 ]; then
# look for @class mismatched with file name
grep '@class' $FILES | perl -ne '
unless (m{([^/]+?)((?:\.spec)?\.js: .* \@class \s+ \1 \b)}xms)
{
	$_ =~ s{\@class (\s+ \w+)}{ERROR \@class$1 mismatches filename}xmsg;
	print;
}
'
fi

if [ ${MISSING_CLASS:-0} == 1 ]; then
# look for missing @class in file
grep --files-without-match '@class' $FILES | \
	egrep --invert-match --ignore-case '\.spec\.js$' | \
	egrep --ignore-case '\.js$' | \
	perl -pne 's{([\n\z])}{: ERROR no \@class keyword in file$1}xmsg'
fi

popd > /dev/null

# TODO xdescribe xit .skip( .only( console.log|error, etc

#'\@todo|MUSTDO|FIXME|REFACTOR|QN|[Hh]ack|HACK|bower_components|maxcomplexity|maxstatements|maxlen|latedef|strict\s*:|eqeqeq\s*:\s*false|unused\s*:|alert\(|ENG-\d+|DAS-\d+' \
# 'TODO|\@todo|MUSTDO|FIXME|REFACTOR|QN|maxcomplexity|maxstatements|maxlen|latedef|strict\s*:|eqeqeq\s*:\s*false|unused\s*:|alert\(|ENG-\d+' \
#-o \( -print \)
#-o \( -type f -print \)

#-o -name '*.sh' -prune \
#-o -name '*.sql' -prune \
#-o -name '*.cgi' -prune \
#-o -name '*.pm' -prune \
#-o -iname '*.pl' -prune \
#-o -name '*.t' -prune \
#-o -name '*.js' -prune \
#-o -name '*.json' -prune \
#-o -name '*.map' -prune \
#-o -name '*.css' -prune \
#-o -name '*.scss' -prune \
#-o -name '*.less' -prune \
#-o -name '*.yml' -prune \
#-o -name '*.xml' -prune \
#-o -name '*.html' -prune \
#-o -name '*.xhtml' -prune \
#-o -name '*.tt' -prune \
#-o -name '*.rb' -prune \
#-o -name '*.md' -prune \
#-o -name '*.txt' -prune \

#egrep 'maxcomplexity'
# --word-regexp 
# --perl-regexp

#find /home/brent/workspace/projects/infinity-plus-dashboard/public/js \
#-name '*.js' \
#-exec egrep --with-filename --line-number --max-count=5 \
#'\@todo|MUSTDO|FIXME|TODO|REFACTOR|QN|maxcomplexity|maxstatements|latedef|strict\s*:|ENG-\d+' \
#{} \;

