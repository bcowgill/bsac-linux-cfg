#!/bin/bash
# Show unicode spacing and block characters. see also spacings.html
grep-utf8.sh space | grep -vE 'MATHEMATICAL MONOSPACE|ETHIOPIC'
grep-utf8.sh block
echo View spacings.html in a browser to see physical size of space and block characters.
