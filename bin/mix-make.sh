#!/bin/bash
# run all mix tasks to make elixir project up to date.

BROWSER=browser.sh
if [ "${1:-nothing}" == "launch" ] ; then
	LAUNCH=1
fi

if [ "${1:-nothing}" == "listen" ] ; then
	LISTEN=1
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

if [ ! -z $LISTEN ]; then
	# generate docs, coverage every time code changes and you press enter
	MIX_ENV=dev mix do docs, test --cover --listen-on-stdin --stale
fi
