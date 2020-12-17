#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# show what files are newer than specified file.
# assumes newest reconfigure.timestamp* if none given
REGEX='/(workspace|Dropbox|Pictures|\.fontconfig|\.Skype|\.mozilla|\.thunderbird|\.cache/thunderbird|\.dropbox|modeller/configuration|\.Ontology_Modeller_Workspace|(\.config|\.cache)/chromium|\.kde\/share\/apps\/nepomuk)/'

if [ -z $1 ]; then
	newer=`ls -1 ~/reconfigure.timestamp* -t | head -1`
else
	newer="$1"
fi
pushd ~ > /dev/null
find . -newer $newer | egrep -v "$REGEX"
echo NOTE: some files hidden by regex $REGEX
popd > /dev/null

