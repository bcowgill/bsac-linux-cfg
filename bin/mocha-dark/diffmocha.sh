VER=3.2.0
DIFF=diff.sh
$DIFF mocha/mocha.css mocha-dark-$VER/mocha-dark.css $1
$DIFF mocha/mocha.js  mocha-dark-$VER/mocha-dark.js $1
