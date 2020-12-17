#!/bin/bash
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# make-mocha-dark.sh mocha-light.js > mocha-dark.js
# grab the mocha.js file and change the canvas progress indicator to
# a dark colour scheme.
# SEE ALSO use-mocha-dark.sh
FILE=${1:-../../node_modules/mocha/mocha.js}

perl -pne 's{fillText}{fillStyle = "yellow"; // BSAC DARK SCHEME\n    ctx.fillText}xmsg' $FILE
