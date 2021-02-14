export PATH=/opt/firefox:$PATH
mkdir -p /tmp/$USER
/opt/firefox/firefox $* 2>&1 > /tmp/$USER/firefox-latest.log &
