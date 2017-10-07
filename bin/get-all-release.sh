# cross-platform get full os release information
( which sw_vers > /dev/null && sw_vers ) \
|| ( which lsb_release > /dev/null && lsb_release -a )
