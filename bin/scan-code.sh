#!/bin/bash
# MUSTDO make a test file for checking this
# scan the code for todo markers and other things.
dir=$1

#_notes/dwsync.xml is a dreamweaver sync file

find $dir \
-name sessions -prune \
-o -name .git -prune \
-o -name .svn -prune \
-o -name CVS -prune \
-o -name node_modules -prune \
-o -name bower_components -prune \
-o -name dist -prune \
-o -name blib -prune \
-o -name logs -prune \
-o -name out -prune \
-o -name _notes -prune \
-o -name .sass-cache -prune \
-o -name '*.min.*' -prune \
-o -name 'kendo.mobile.*.min.css' -prune \
-o -name 'kendo.icenium.min.css' -prune \
-o -name '*.log' -prune \
-o -name '*.bak' -prune \
-o -name '*.ico' -prune \
-o -name '*.jpg' -prune \
-o -name '*.pdf' -prune \
-o -name '*.png' -prune \
-o -name '*.gif' -prune \
-o -name '*.psd' -prune \
-o -name '*.svg' -prune \
-o -name '*.ttf' -prune \
-o -name '*.eot' -prune \
-o -name '*.otf' -prune \
-o -name '*.woff' -prune \
-o -name '*.gz' -prune \
-o -name '*.class' -prune \
-o -name '*.tar' -prune \
-o -name '*.zip' -prune \
-o -name '*.bz' -prune \
-o -name '*.csv' -prune \
-o -name '*.vars' -prune \
-o \( -type f -exec egrep --with-filename --line-number \
'\@todo|\b(MUSTDO|FIXME|REFACTOR|QN|[Hh]ack|HACK\b)|\b(maxcomplexity|maxstatements|maxlen|latedef|strict|unused)\s*:|\b(eqeqeq\s*:\s*false)|\bconsole\.(log|info|warn|error|dir|time|timeEnd|trace|assert)|\balert\(|\.(skip|only)\(|\((ev|e)\)|var\s+([a-zA-Z]\w?|\w\w)\b' \
{} \; \
\)

# look for @class mismatched with file name
git grep '@class' | perl -ne 'unless (m{/([^/]+)((?:\.spec)?\.js: \s* \*? \s* \@class \s+ \1 \s* \z)}xms) { $_ =~ s{\@class}{ERROR \@class mismatch to filename:}xmsg; print; }'

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

