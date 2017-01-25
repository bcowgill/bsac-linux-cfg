# scan relay containers for fragments and show them
CONTS=`find app/containers/ -name '*.js' | grep -v index.js`
echo $CONTS
perl -ne '$print = 0; $print = 2 if m{displayName\s*=}xms; if (m{Relay.QL}xms) { $inside = 1; $print = 1 } if ($inside) { $inside = 0 if m{\}`}xms; $print = 1} $print = $print || $inside; print "\n" if $print > 1; print if $print' $CONTS
