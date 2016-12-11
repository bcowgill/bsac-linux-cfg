#!/bin/bash
# run all mix tasks to make project up to date.

BROWSER=browser.sh
if [ "${1:-nothing}" == "launch" ] ; then
	LAUNCH=1
fi

mix deps.get \
&& mix test --cover \
&& mix escript.build \
&& mix docs

rm cover/index.html 2> /dev/null
ln -s `ls cover/ | head -1` cover/index.html
echo View coverage results at cover/

# mix run -e "Issues.default()"
# mix profile.fprof -e "Issues.default()"

if [ ! -z $LAUNCH ]; then
	$BROWSER doc/index.html cover/
fi
