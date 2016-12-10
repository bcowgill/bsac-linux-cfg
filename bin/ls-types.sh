#!/bin/bash
# list elixir style @type definitions within git control
MODE=${1:-full}

if [ "$MODE" == "--names" ]; then
	( \
	git grep -E '@type\b' \
	| perl -ne 'print if s{\A [^:]+ : \s* \@type \s+ ([^:]+?) \s* :: \s* (.+) \s* \z}{$1\n}xmsg;'; \
	git grep -E '@spec\b' \
	| perl -ne 'print if s{\A [^:]+ : \s* \@spec \s+ [^\(]+ \( \s* (.+?) \s* \) \s* :: \s* (.+?) \s* (when \s+ .+)? \z}{$1\n}xmsg;' \
	) | sort | uniq
fi
if [ "$MODE" == "--values" ]; then
	( \
	git grep -E '@type\b' \
	| perl -ne 'print if s{\A [^:]+ : \s* \@type \s+ ([^:]+?) \s* :: \s* (.+) \s* \z}{$2\n}xmsg;'; \
	git grep -E '@spec\b' \
	| perl -ne 'print if s{\A [^:]+ : \s* \@spec \s+ [^\(]+ \( \s* (.+?) \s* \) \s* :: \s* (.+?) \s* (when \s+ .+)? \z}{$2\n}xmsg;' \
	) | sort | uniq
fi
if [ "$MODE" == "full" ]; then
	( \
	git grep -E '@type\b' \
	| perl -ne 'print if s{\A [^:]+ : \s* \@type \s+ ([^:]+?) \s* :: \s* (.+) \s* \z}{$1 :: $2\n}xmsg;'; \
	git grep -E '@spec\b' \
	| perl -ne 'print if s{\A [^:]+ : \s* \@spec \s+ [^\(]+ \( \s* (.+?) \s* \) \s* :: \s* (.+?) \s* (when \s+ .+)? \z}{$1 :: $2\n}xmsg;' \
	) | sort | uniq
fi

