#!/bin/bash
# perform regular maintenance with apt
# https://help.ubuntu.com/community/AptGet/Howto#Search_commands

DEEPCLEAN=0
PKG=lsof

echo === check
apt-get check
echo === show size of cache
du -sh /var/cache/apt/archives
echo === empty the trash in the cache
apt-get autoclean
echo === new size of the cache
du -sh /var/cache/apt/archives
echo === update
apt-get update
echo === fix unmet dependencies
apt-get -f install
echo === check for orphaned packages not needed
which deborphan && deborphan --show-priority --show-section --show-size

if [ "x$DEEPCLEAN" == "x1" ]; then
echo === doing deep clean
echo === remove packages installed by other packages which are no longer used
apt-get autoremove
echo === remove all packages in the cache - will cause redownloads when install
apt-get clean
else
echo === NOT doing deep clean - set DEEPCLEAN=1 to perform this
fi

echo === optional update search cache
which apt-file && apt-file update

echo === some search tests
set -x
which apt-cache && apt-cache search $PKG
echo ===
which dpkg && dpkg -l *$PKG*
echo ===
which apt-cache && apt-cache show $PKG
echo ===
which apt-cache && apt-cache showpkg $PKG
echo ===
which dpkg && dpkg --print-avail $PKG
echo ===
which apt-cache && apt-cache policy $PKG
echo ===
which dpkg && dpkg -L $PKG
# show contents of manually downloaded .deb file
#dpkg -c PKG.deb
echo ===
which dlocate && dlocate $PKG
echo ===
# a slower version of dlocate
which dpkg && dpkg -S $PKG
echo ===
which apt-file && apt-file search $PKG
# list every package on the system
#apt-cache pkgnames
set +x

echo === final size of the cache
du -sh /var/cache/apt/archives
