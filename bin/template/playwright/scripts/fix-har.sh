#!/bin/bash
# used to strip or unify cache busting url parameters and cross origin headers in HAR file recordings so they can be played back by playwright.
HOST=http://localhost:58008
PM=a
NUM=9988776655443
HDR=Access-Control-Allow-Origin

if echo "$1" | grep -E 'https?://' > /dev/null; then
	HOST=$1
	shift
fi
if [ -z "$STRIPA" ]; then
	echo Set $PM=$NUM for url params and change $HDR headers to $HOST
else
	echo Remove $PM=\\d+ from url params and change $HDR headers to $HOST
fi

HOST=$HOST PM=$PM HDR=$HDR NUM=$NUM STRIPA=$STRIPA perl -i -pne '
	$saved = $_;
	if ($ENV{STRIPA})
	{
		s{([?&]$ENV{PM})=\d+}{}xms;
		s{/&}{/\?}xms;
	}
	else
	{
		s{([?&]$ENV{PM})=\d+}{$1=$ENV{NUM}}xmsg;
	}
	s{("$ENV{HDR}",\s*"value":\s*)"[^"]+"}{$1"$ENV{HOST}"}xmsg;
	$count++ unless ($saved eq $_);
	END
	{
		$count ||= 0;
		print "Fixed $count lines in files.\n";
	}
' $*
