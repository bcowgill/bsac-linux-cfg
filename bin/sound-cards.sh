aplay --list-devices | perl -ne 'print if s{\A card \s+ (\d+) : .+ \z}{$1\n}xmsg' | sort | uniq
