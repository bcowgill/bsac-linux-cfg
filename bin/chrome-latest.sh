export PATH=/opt/google/chrome:$PATH
mkdir -p /tmp/$USER
/opt/google/chrome/chrome $* 2>&1 > /tmp/$USER/chrome-latest.log &
