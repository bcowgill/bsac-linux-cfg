export PATH=/opt/firefox:$PATH
mkdir -p /tmp/$USER
/opt/firefox/firefox $* 2>&1 > /tmp/$USER/firefox-latest.log &
#
exit
================================
Manage Bookmarks / Import and Backup / Backup to
~/Downloads/tx/bookmarks-2025-03-05.json

Download new FF version to downloads dir:
~/Downloads
firefox-124.0.1.tar.bz2
firefox-136.0.tar.xz

cd Downloads/tx
tar xvJf ../firefox*.xz
sudo chown -R root.root `pwd`/firefox
sudo mv firefox /opt/firefox-136.0
sudo rm /opt/firefox
sudo ln -s firefox-136.0 /opt/firefox
ls -al /opt

 XPCOMGlueLoad error for file /opt/firefox-136.0/libxul.so:
/opt/firefox-136.0/libxul.so: undefined symbol: gdk_window_show_window_menu
Couldn't load XPCOM.
