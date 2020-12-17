#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# perltidy the modified/added/renamed perl files from a git repo.
# must be run from the top of your repository so the paths match up.
# NOTE: filenames with tricky characters will be a problem, -z format remedies that but this script doesn't do that yet.
RC=$HOME/.perltidyrc
if [ -f $RC ]; then
	echo Modified
	git status --porcelain | perl -ne 'if (m{\.p[lm] \n \z}xms) { s{\A \s M \s+}{}xms && (print qq{perltidy $_}) && system(qq{perltidy -b $_}); }'
	echo Added
	git status --porcelain | perl -ne 'if (m{\.p[lm] \n \z}xms) { s{\A A \s+}{}xms && (print qq{perltidy $_}) && system(qq{perltidy -b $_}); }'
	echo Renamed
	git status --porcelain | perl -ne 'if (m{\.p[lm] \n \z}xms) { s{\A R \s+ .+? \s+ -> \s+ }{}xms && (print qq{perltidy $_}) && system(qq{perltidy -b $_}); }'
	echo Renamed and Modified
	git status --porcelain | perl -ne 'if (m{\.p[lm] \n \z}xms) { s{\A R M .+? \s+ -> \s+ }{}xms && (print qq{perltidy $_}) && system(qq{perltidy -b $_}); }'
else
	echo "You need to have perltidy configured with the team's settings."
	echo "You can copy/symlink it from infinity-plus-dashboard/setup/perltidyrc to $RC"
	echo "Then you can run this from the top of your git repository."
fi
