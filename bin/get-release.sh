# cross-platform os release version name/number
( which sw_vers > /dev/null && sw_vers -productVersion ) \
|| ( which lsb_release > /dev/null && lsb_release -sc )
