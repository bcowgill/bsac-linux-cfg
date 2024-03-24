#!/bin/bash

NEXT=filter-code-files

./tests.sh
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
#filter-images.sh
#filter-videos.sh
#filter-drawings.sh
#filter-fonts.sh
#filter-docs.sh

#filter-scripts.sh
#filter-configs.sh
#filter-web.sh
#filter-css.sh
#filter-text.sh
#filter-zips.sh
#filter-built-files.sh
#filter-file.pl

filter-code-files.sh

#filter-mime-audio.pl
#filter-mime-video.pl

#filter-id3.pl
#filter-css-colors.pl
