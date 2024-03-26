#!/bin/bash

NEXT=filter-code-files

./tests.sh
if [ ! -z "$1" ]; then
	if [ -x "../$1" ]; then
		echo "Running ../$1 from `pwd`"
		../$1
	else
		echo "ERROR: command '../$1' is not executable as seen from `pwd`, terminating the chain."
		exit 44
	fi
fi
exit $?

cd ../$NEXT
./test-chain.sh


filter-long.sh
filter-coverage.sh
filter-script.pl

#filter-punct.sh
#filter-json-commas.sh
#filter-url.pl
#filter-whitespace.pl
#filter-indents.sh
#filter-newlines.pl

#filter-generify.pl
#filter-man.pl

filter-sounds.sh
filter-images.sh
filter-videos.sh
filter-drawings.sh
filter-fonts.sh
filter-docs.sh
filter-bak.sh
filter-osfiles.sh

filter-source.sh
filter-scripts.sh
filter-configs.sh
filter-min.sh
filter-web.sh
filter-css.sh
filter-text.sh
filter-zips.sh
filter-built-files.sh
filter-code-files.sh

#filter-mime-audio.pl
#filter-mime-video.pl
#filter-file.pl

#filter-id3.pl
#filter-css-colors.pl
