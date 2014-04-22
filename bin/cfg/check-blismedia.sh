#!/bin/bash
# Check configuration to make sure things are ok and make them ok where possible
# search for 'begin' for start of script

# terminate on first error
set -e
# turn on trace of currently running command if you need it
#set -x

UBUNTU=trusty
ULIMITFILES=8196
EMAIL=brent@blismedia.com
MYNAME="Brent S.A. Cowgill"
COMPANY=blismedia
ONBOOT=onboot-$COMPANY.sh
MOUNT_DATA=""
DROP_BACKUP=Dropbox/WorkSafe/_tx/$COMPANY
CHARLES_LICENSE="UNREGISTERED:xxxxxxxxxx"
THUNDER=""
#THUNDER=ryu9c8b3.default

DOWNLOAD=$HOME/Downloads

USE_JAVA=""

MVN_PKG=""
MVN_CMD=""
#MVN_CMD="mvn"
#MVN_PKG="mvn:maven"
#MVN_VER="3.0.4"

INSTALL_FROM="wcd.exec:wcd gvim:vim-gtk $MVN_PKG"
SCREENSAVER="kscreensaver ktux kcometen4 screensaver-default-images wmmatrix xscreensaver xscreensaver-data-extra xscreensaver-gl-extra xfishtank xdaliclock fortune"
# gnome ubuntustudio-screensaver unicode-screensaver

NODE="nodejs npm grunt grunt-init uglifyjs phantomjs"
NODE_VER="v0.10.25"
NODE_CMD="nodejs"
NODE_PKG="nodejs npm node-abbrev node-fstream node-graceful-fs node-inherits node-ini node-mkdirp node-nopt node-rimraf node-tar node-which"
INSTALL_NPM_FROM=""
INSTALL_NPM_GLOBAL_FROM="uglifyjs:uglify-js@1 grunt:grunt-cli grunt-init bower"
INSTALL_GRUNT_TEMPLATES="basic:grunt-init-gruntfile node:grunt-init-node jquery:grunt-init-jquery.git"

CHARLES="charles"
CHARLES_PKG=charles-proxy

VIRTUALBOX="VirtualBox"
VIRTUALBOX_CMDS="dkms"
VIRTUALBOX_CMDS="dkms VirtualBox"
VIRTUALBOX_PKG="dkms virtualbox-4.3"
VIRTUALBOX_REL="raring"

DIFFMERGE=diffmerge
DIFFMERGE_PKG=diffmerge_4.2.0.697.stable_amd64.deb
DIFFMERGE_URL=http://download-us.sourcegear.com/DiffMerge/4.2.0/$DIFFMERGE_PKG

SUBLIME=subl
SUBLIME_CFG=.config/sublime-text-3
SUBLIME_PKG=sublime-text_build-3047_amd64.deb
SUBLIME_URL=http://c758482.r82.cf2.rackcdn.com/$SUBLIME_PKG

ECLIPSE=""

SVN_PKG=""
SVN_CMD=""
#SVN_CMD=svn
#SVN_VER="1.8.5"
#SVN_PKG="subversion libsvn-java"

GITSVN_PKG=""
#GITSVN=/usr/lib/git-core/git-svn
#GITSVN_PKG="libsvn-perl git-svn"

GIT_VER="1.9.1"
GIT_PKG_MAKE="libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev build-essential"
GIT_PKG=git
GIT_PKG_AFTER="git-doc git-gui gitk tig $GITSVN_PKG"

GIT_TAR=git-$GIT_VER
GIT_URL=https://git-core.googlecode.com/files/$GIT_TAR.tar.gz

SKYPE=skype
SKYPE_PKG="skype skype-bin"

INI_DIR=check-iniline

INSTALL="vim curl wget colordiff dlocate deborphan dos2unix flip fdupes mmv iselect multitail chromium-browser cmatrix gettext"
COMMANDS="apt-file wcd.exec gettext git $NODE_CMD $SVN_CMD $MVN_CMD $CHARLES $SUBLIME $DIFFMERGE $SKYPE $VIRTUALBOX_CMDS"
PACKAGES="$INSTALL apt-file wcd bash-completion $NODE_PKG $GIT_PKG_MAKE $GIT_PKG_AFTER $SVN_PKG $GITSVN_PKG $CHARLES_PKG $SKYPE_PKG $VIRTUALBOX_PKG $SCREENSAVER"

source `which lib-check-system.sh`

#============================================================================
# begin actual system checking

pushd $HOME

id

if grep $USER /etc/group | grep sudo; then
   echo OK user $USER has sudo privileges
else
   echo NOT OK user $USER does not have sudo privileges
fi


check_linux $UBUNTU

touch go.sudo; rm go.sudo
if [ `ulimit -n` == $ULIMITFILES ]; then
   echo OK ulimit for open files is good
else
   echo NOT OK ulimit for open files is bad need $ULIMITFILES
   file_has_text /etc/security/limits.conf $USER "check limits file" || ( \
      echo echo \"$USER            soft    nofile          $ULIMITFILES\" \>\> /etc/security/limits.conf > go.sudo;
      echo echo \"$USER            hard    nofile          $ULIMITFILES\" \>\> /etc/security/limits.conf >> go.sudo;
      chmod +x go.sudo;
      sudo ./go.sudo\
   )
   file_has_text /etc/security/limits.conf $USER "check username in limits file"
   file_has_text /etc/security/limits.conf $ULIMITFILES "check value in limits file"
   echo YOUDO You have to logout/login again for ulimit to take effect.
   exit 1
fi

install_file_from_url_zip Downloads/MProFont/ProFontWindows.ttf MProFont.zip "http://tobiasjung.name/downloadfile.php?file=MProFont.zip" "ProFontWindows font package"
install_file_from_url_zip Downloads/ProFont-Windows-Bold/ProFont-Bold-01/ProFontWindows-Bold.ttf ProFont-Windows-Bold.zip "http://tobiasjung.name/downloadfile.php?file=ProFont-Windows-Bold.zip" "ProFontWindows bold font package"
install_file_from_url_zip Downloads/ProFontWinTweaked/ProFontWindows.ttf ProFontWinTweaked.zip "http://tobiasjung.name/downloadfile.php?file=ProFontWinTweaked.zip" "ProFontWindows tweaked font package"

cmd_exists kfontinst
FILE=.fonts/p/ProFontWindows.ttf
file_exists $FILE "ProFontWindows font needs to be installed" || find Downloads/ -name '*.ttf'
file_exists $FILE > /dev/null || kfontinst Downloads/ProFontWinTweaked/ProFontWindows.ttf 
file_exists $FILE "ProFontWindows still not installed"

FILE=.fonts/p/ProFontWindows_Bold.ttf
file_exists $FILE > /dev/null || kfontinst Downloads/ProFont-Windows-Bold/ProFont-Bold-01/ProFontWindows-Bold.ttf
file_exists $FILE "ProFontWindows Bold still not installed"

file_has_text .kde/share/apps/konsole/Shell.profile "Font=ProFontWindows,14" "need to set font for konsole Settings / Edit Current Profile / Appearance / Set Font"
file_has_text .kde/share/config/kateschemarc "Font=ProFontWindows,14" "ProFontWindows in kate editor Settings / Configure Kate / Fonts & Colors"
file_has_text .kde/share/config/kateschemarc "Solarized (dark)" "Solarized Dark schema in kate editor"
# adjusted Solarized (dark) color for some barely visible items
file_has_text .kde/share/config/katesyntaxhighlightingrc "Bash:OtherCommand=1,ff930093,ff839496,1,,,,,,,---" "Settings / Configure Kate / Fonts & Colors / Highlighting Text Styles"
#file_has_text .kde/share/config/katesyntaxhighlightingrc "Bash:OtherCommand=1,ff7b007b,ff839496,1,,,,,,,---" "Settings / Configure Kate / Fonts & Colors / Highlighting Text Styles"

file_has_text .kde/share/config/katesyntaxhighlightingrc "Bash:Redirection=1,ff293ea6,ff839496,1,,,,,,,---" "Settings / Configure Kate / Fonts & Colors / Highlighting Text Styles"
file_has_text .kde/share/config/kdeglobals "fixed=ProFontWindows,14" "ProFontWindows for System fixed width font System Settings / Application Appearance / Fonts"

#TODO KATE color check
#./.kde/share/config/colors/Recent_Colors
#./.kde/share/config/kateschemarc
#./.kde/share/config/katerc

dir_linked_to sandbox workspace "sandbox alias for workspace"
dir_linked_to bin workspace/play/bsac-linux-cfg/bin "linux config scripts in workspace"
#dir_linked_to bin workspace/bin "transfer area in workspace"
dir_linked_to tx workspace/tx "transfer area in workspace"
dir_linked_to projects workspace/projects "projects area in workspace"
dir_linked_to bk $DROP_BACKUP "backup area in Dropbox"
if [ ! -z $USE_JAVA ]; then
   dir_linked_to jdk workspace/jdk1.7.0_21 "shortcut to current java dev kit"
fi

dir_exists  bin/cfg "bin configuration missing"
rm -rf $INI_DIR
make_dir_exist /tmp/$USER "user's own temporary directory"
dir_linked_to tmp /tmp/$USER "make a tmp in home dir point to /tmp/"
make_dir_exist $INI_DIR "output area for checking INI file settings"
make_dir_exist workspace/backup/cfg "workspace home configuration files missing"
make_dir_exist workspace/play "workspace play area missing"
make_dir_exist workspace/tx/mirror "workspace mirror area for charles"

file_linked_to go.sh bin/cfg/$ONBOOT "on reboot script configured"
file_linked_to bin/check-system.sh $HOME/bin/cfg/check-$COMPANY.sh "system check script configured"
file_linked_to bin/get-from-home.sh $HOME/bin/cfg/get-from-home.sh "home work unpacker configured"
file_linked_to .bash_aliases bin/cfg/.bash_aliases  "bash alias configured"
file_linked_to .bash_functions bin/cfg/.bash_functions "bash functions configured"
file_linked_to .bashrc bin/cfg/.bashrc "bashrc configured"

if [ ! -z $MOUNT_DATA ]; then
   if [ -d /data/UNMOUNTED ]; then
      echo OK /data/UNMOUNTED exists will try mounting it to check dirs
      sudo mount /data
      if [ -d /data/UNMOUNTED ]; then
         echo NOT OK unable to mount /data
#   mkdir -p /data/UNMOUNTED
#   blkid /dev/sdb1
#   mount UUID="89373938-6b43-4471-8aef-62cd6fc2f2a3" /data
#   /etc/fstab entry added
#   UUID=89373938-6b43-4471-8aef-62cd6fc2f2a3 /data           ext4    rw              0       2
#   mkdir -p /data/$USER
#   chown -R $USER:domusers /data/$USER
         exit 1
      fi
   fi
fi
dir_exists /data/$USER "personal area on data dir missing"
#sudo mkdir -p /data/$USER
#sudo chown $USER:$USER /data/$USER

make_dir_exist /data/$USER/backup "backup dir on /data"
make_dir_exist /data/$USER/VirtualBox "VirtualBox dir on /data"

cmd_exists wget
cmd_exists apt-file || (sudo apt-get install apt-file && sudo apt-file update)

# update apt sources list with needed values to install some more complicated programs
touch go.sudo; rm go.sudo
apt_has_source "deb http://www.charlesproxy.com/packages/apt/ charles-proxy main" "apt config for charles-proxy missing"
apt_must_not_have_source "deb-src http://www.charlesproxy.com/packages/apt/ charles-proxy main" "apt config for charles-proxy wrong"
[ -f go.sudo ] && (wget -q -O - http://www.charlesproxy.com/packages/apt/PublicKey | sudo apt-key add - )
apt_has_source "deb http://ppa.launchpad.net/svn/ppa/ubuntu $(lsb_release -sc) main" "apt config for svn update missing"
apt_has_source "deb-src http://ppa.launchpad.net/svn/ppa/ubuntu $(lsb_release -sc) main" "apt config for svn update missing"
apt_has_source "deb http://archive.canonical.com/ $(lsb_release -sc) partner" "apt config for skype missing"

apt_has_source "deb http://download.virtualbox.org/virtualbox/debian $VIRTUALBOX_REL contrib" "apt config for virtualbox missing trusty must use raring for now"
apt_must_not_have_source "deb-src http://download.virtualbox.org/virtualbox/debian $VIRTUALBOX_REL contrib" "apt config for virtualbox wrong"
apt_must_not_have_source "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" "apt config trusty must use raring for now"
apt_must_not_have_source "deb-src http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" "apt config trusty must use raring for now"

echo Checking for apt-keys...
apt_has_key charlesproxy http://www.charlesproxy.com/packages/apt/PublicKey "key fingerprint for Charles Proxy missing"
apt_has_key VirtualBox http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc "key fingerprint for VirtualBox missing"

cmd_exists dkms "need dkms command for VirtualBox"
cmd_exists $VIRTUALBOX || (sudo apt-get update; sudo apt-get install $VIRTUALBOX_PKG)
cmd_exists $VIRTUALBOX 

echo MAYBE DO MANUALLY apt-get install $CHARLES_PKG $SVN_PKG $SKYPE_PKG $VIRTUALBOX_PKG
[ -f go.sudo ] && (sudo apt-get update; sudo apt-get install $CHARLES_PKG $SVN_PKG $SKYPE_PKG && sudo apt-get -f install && echo YOUDO: set charles license: $CHARLES_LICENSE)

cmd_exists $CHARLES
cmd_exists $SKYPE

if [ ! -z $SVN_PKG ]; then
cmd_exists svn
file_exists /usr/lib/x86_64-linux-gnu/jni/libsvnjavahl-1.so "svn and eclipse setup lib exists"
dir_linked_to /usr/lib/jni /usr/lib/x86_64-linux-gnu/jni "svn and eclipse symlink exists" root
apt_has_key WANdisco http://opensource.wandisco.com/wandisco-debian.gpg "key fingerprint for svn 1.8 wandisco"
FILE="/etc/apt/sources.list.d/WANdisco.list"
make_root_file_exist "$FILE" "deb http://opensource.wandisco.com/ubuntu $(lsb_release -sc) svn18" "adding WANdisco source for apt"
file_has_text "$FILE" wandisco.com
if svn --version | grep " version " | grep $SVN_VER; then
   echo OK svn command version correct
else
   echo NOT OK svn command version incorrect - will try update
   # http://askubuntu.com/questions/312568/where-can-i-find-a-subversion-1-8-binary
   sudo apt-get update
   apt-cache show subversion | grep '^Version:'   
   sudo apt-get install $SVN_PKG
   echo NOT OK exiting after svn update, try again.
   exit 1
fi
else
   echo OK will not configure subversion unless SVN_PKG is non-zero
fi

has_ssh_keys

which git
if git --version | grep " version " | grep $GIT_VER; then
   echo OK git command version correct
else
   echo NOT OK git command version incorrect - will try update
   # http://blog.avirtualhome.com/git-ppa-for-ubuntu/
   apt_has_source ppa:pdoes/ppa "repository for git"
   sudo apt-get update
   apt-cache show git | grep '^Version:'
   sudo apt-get install $GIT_PKG $GIT_PKG_AFTER
   echo NOT OK exiting after git update, try again.
   exit 1
   
   sudo apt-get install $GIT_PKG_MAKE
   # upgrading git on ubuntu
   # https://www.digitalocean.com/community/articles/how-to-install-git-on-ubuntu-12-04
   make_dir_exist $DOWNLOAD
   pushd $DOWNLOAD
   wget $GIT_URL
   tar xvzf $GIT_TAR.tar.gz
   cd $GIT_TAR
   make prefix=/usr/local all
   sudo make prefix=/usr/local install
   sudo apt-get install $GIT_PKG_AFTER
   popd
   echo NOT OK exiting after git update, try again.
   exit 1
fi

if [ ! -z $MVN_PKG ]; then
   cmd_exists mvn
   if mvn --version | grep "Apache Maven " | grep $MVN_VER; then
      echo OK mvn command version correct
   else
      echo NOT OK mvn command version incorrect
      exit 1
   fi
fi

if [ "x$JAVA_HOME" == "x/usr/lib/jvm/jdk1.7.0_21" ]; then
   echo OK JAVA_HOME set correctly
else
   echo NOT OK JAVA_HOME is incorrect $JAVA_HOME
   exit 1
fi
if [ "x$M2_HOME" == "x/usr/share/maven" ]; then
   echo OK M2_HOME set correctly
else
   echo NOT OK M2_HOME is incorrect $M2_HOME
   exit 1
fi

cmd_exists git
if [ ! -z $GITSVN_PKG ]; then
if [ -x $GITSVN ]; then
   echo OK git svn command installed
else
   echo NOT OK git svn command missing -- will try to install
   sudo apt-get install $GITSVN_PKG
fi
cmd_exists $GITSVN
else
   echo OK will not configure git-svn unless GITSVN_PKG is non-zero
fi

# git installs completion file but not in right place any more
file_linked_to_root /etc/bash_completion.d/git /usr/share/bash-completion/completions/git
install_command_package_from_url $DIFFMERGE $DIFFMERGE_PKG $DIFFMERGE_URL "sourcegear diffmerge"

echo BIG INSTALL $INSTALL
install_commands "$INSTALL"
install_commands_from "$INSTALL_FROM"
install_command_from_packages "$NODE_CMD" "$NODE_PKG"
install_command_from_packages kslideshow.kss "$SCREENSAVER"

make_dir_exist workspace/dropbox-dist "dropbox distribution files"
file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd "dropbox installed" || (pushd workspace/dropbox-dist && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - && ./.dropbox-dist/dropboxd & popd)
file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd

commands_exist "$COMMANDS"

file_exists workspace/cfgrec.txt "configuration record files will copy from templates" || cp bin/template/cfgrec/* workspace/
file_exists workspace/cfgrec.txt "configuration record files"

#cp bin/ontology/backup-work* bin/cfg/
file_linked_to bin/backup-work.sh $HOME/bin/cfg/backup-work.sh "daily backup script"
file_linked_to bin/backup-work-manual.sh $HOME/bin/cfg/backup-work-manual.sh "manual backup script"
cmd_exists backup-work.sh "backup script missing"
cmd_exists get-from-home.sh "unpacker script for work at home"

file_exists bin/cfg/crontab-$HOSTNAME "crontab missing" || backup-work.sh
crontab_has_command "mkdir" "* * * * * mkdir -p /tmp/\$LOGNAME && set > /tmp/\$LOGNAME/crontab-set.log 2>&1" "crontab user temp dir creation and env var dump"
crontab_has_command "mkdir"
crontab_has_command "backup-work.sh" "30 17,18 * * * \$HOME/bin/backup-work.sh > /tmp/\$LOGNAME/crontab-backup-work.log 2>&1" "crontab daily backup configuration"
crontab_has_command "backup-work.sh"
crontab_has_command "wcdscan.sh" "*/10 9,10,11,12,13,14,15,16,17,18 * * * \$HOME/bin/wcdscan.sh > /tmp/\$LOGNAME/crontab-wcdscan.log 2>&1" "crontab update change dir scan"
crontab_has_command "wcdscan.sh"

if [ x`git config --global --get user.email` == x$EMAIL ]; then
   echo OK git config has been set up
else
   echo NOT OK git config not set. trying to do so
   git config --global user.name "$MYNAME"
   git config --global user.email $EMAIL
fi

if $NODE_CMD --version | grep $NODE_VER; then
   echo OK node command version correct
else
   echo NOT OK node command version incorrect. trying to update
   #https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#wiki-ubuntu-mint-elementary-os
   sudo apt-get update
   sudo apt-get install -y python-software-properties python g++ make
   sudo add-apt-repository ppa:chris-lea/node.js
   sudo apt-get update
   sudo apt-get install nodejs
   exit 1
fi

npm config set registry https://registry.npmjs.org/
#install_npm_commands_from "$INSTALL_NPM_FROM" 
install_npm_global_commands_from "$INSTALL_NPM_GLOBAL_FROM" 
make_dir_exist $HOME/.grunt-init "grunt template dir"
# need to upload ssh public key to github before getting grunt templates
install_grunt_templates_from "$INSTALL_GRUNT_TEMPLATES"

cmd_exists git "need git installed before configure sublime"
cmd_exists grunt "need grunt installed before configure sublime for it"

file_linked_to /usr/bin/node /usr/bin/nodejs "grunt needs node command at present, not updated to nodejs yet"
cmd_exists node "grunt needs node command at present, not updated to nodejs yet"
install_command_package_from_url $SUBLIME $SUBLIME_PKG $SUBLIME_URL "sublime editor"
install_file_from_url Downloads/Package-Control.sublime-package.zip Package-Control.sublime-package.zip "http://sublime.wbond.net/Package%20Control.sublime-package" "sublime package control bundle"
#cp Downloads/Package-Control.sublime-package.zip ".config/sublime-text-3/Installed Packages/Package Control.sublime-package"
install_file_manually "$SUBLIME_CFG/Installed Packages/Package Control.sublime-package" "sublime package control from instructions" "https://sublime.wbond.net/installation"
install_git_repo "$SUBLIME_CFG/Packages" sublime-grunt-build git://github.com/jonschlinkert/sublime-grunt-build.git "sublime text grunt build package - check for Tools/Build System/Grunt after -- May have to correct syntax in print('BuildGruntOnSave: on_post_save')"
## TODO - maybe not sublime build may be working ... install_file_manually "$SUBLIME_CFG/Packages/Grunt/SublimeGrunt.sublime-settings" "sublime grunt build system" "https://www.npmjs.org/package/sublime-grunt-build"

cmd_exists git "need git to clone repos"
make_dir_exist workspace/play "github repo play area"
install_git_repo "workspace/play" jshint-test https://github.com/bcowgill/jshint-test.git "my jshint build system"
install_git_repo "workspace/play" grunt-test https://github.com/bcowgill/grunt-test.git "my grunt build system"
install_git_repo "workspace/play" bsac-linux-cfg https://github.com/bcowgill/bsac-linux-cfg.git "my linux config scripts"

# Check charles configuration options
FILE=.charles.config
make_dir_exist tx/mirror/web "charles mirroring area"
file_has_text $FILE "port>58008" "charles port config Proxy / Proxy Settings"
file_has_text $FILE "enableSOCKSTransparentHTTPProxying>true" "charles proxy config"
file_has_text $FILE "displayFont>ProFontWindows" "charles font config Edit / Preferences / User Interface"
file_has_text $FILE "showMemoryUsage>true" "charles memory usage config Edit / Preferences / User Interface"
file_has_text $FILE "displayFontSize>16" "charles font config"
file_has_text $FILE "tx/mirror/web</savePath" "charles mirror config Tools / Mirror"

FILE=.kde/share/config/kioslaverc
file_has_text $FILE "ProxyType=1" "system proxy config Alt-F2 / Proxy"
file_has_text $FILE "httpProxy=localhost 58008" "system proxy config to charles"

DIR=.local/share/applications
dir_exists $DIR "KDE applications folder"

# Eclipse configuration (shortcut and font)
if [ ! -z "$ECLIPSE" ]; then
DIR=.local/share/applications
file_exists eclipse/eclipse "Eclipse program"
file_exists eclipse/Eclipse.desktop "Eclipse launcher"
file_exists $DIR/Eclipse.desktop "Eclipse KDE menu item" || cp eclipse/Eclipse.desktop $DIR/Eclipse.desktop

TEXT="ProFontWindows"
DIR=workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings
file_has_text $DIR/org.eclipse.ui.workbench.prefs "$TEXT"
file_has_text $DIR/org.eclipse.jdt.ui.prefs "$TEXT"
file_has_text $DIR/org.eclipse.wst.jsdt.ui.prefs "$TEXT"
fi

# Dropbox configuration
dir_exists .config/autostart "System Settings / Startup & Shutdown / Autostart"
file_exists workspace/dropbox-dist/dropboxd.desktop "dropbox autostart saved"
file_exists .config/autostart/dropboxd.desktop "dropbox autostart" || (cp workspace/dropbox-dist/dropboxd.desktop .config/autostart/dropboxd.desktop)

# Thunderbird
if [ ! -z $THUNDER ]; then
FILE=".thunderbird/$THUNDER/prefs.js"
file_has_text $FILE "imap.hslive.net" "thunderbird outlook configuration http://wiki/wiki/Hosted_Exchange#IMAP"
file_has_text $FILE "default/News/newsrc-news" "thunderbird newsgroup configuration http://wiki/wiki/Hosted_Exchange#News_Groups http://wiki/wiki/New_Engineering_Starters_Handbook#Newsgroups"
file_has_text $FILE "ProFontWindows"
file_contains_text $FILE "browser.anchor_color., .#66FFFF"
#file_contains_text $FILE "browser.anchor_color., .#99FFFF"
file_contains_text $FILE "browser.display.background_color., .#000000"
#file_contains_text $FILE "browser.display.background_color., .#666666"
file_contains_text $FILE "browser.display.foreground_color., .#FFFF33"
#file_contains_text $FILE "browser.display.foreground_color., .#FFFF66"
#file_contains_text $FILE "browser.display.use_document_colors., false"
file_contains_text $FILE "browser.visited_color., .#FF99FF"
#file_contains_text $FILE "browser.visited_color., .#FFCCCC"
file_contains_text $FILE "mail.citation_color., .#CCCCCC"
#file_contains_text $FILE "mail.citation_color., .#FFCC66"
file_contains_text $FILE "mailnews.tags..label1.color., .#FF0000"
file_contains_text $FILE "mailnews.tags..label2.color., .#FF9900"
file_contains_text $FILE "mailnews.tags..label3.color., .#009900"
file_contains_text $FILE "mailnews.tags..label4.color., .#3333FF"
file_contains_text $FILE "mailnews.tags..label5.color., .#993399"
#file_contains_text $FILE "msgcompose.background.color., .#333333"
#file_contains_text $FILE "msgcompose.text_color., .#FFFF33"
else
   echo OK thunderbird will not be configured unless THUNDER is non-zero
fi

# System Settings
FILE=.kde/share/config/kcminputrc
file_has_text $FILE "MouseButtonMapping=LeftHanded" "Mouse settings System Settings / Input Devices / Mouse Settings"
file_has_text $FILE "cursorTheme=redglass" "System Settings / Workspace Appearance / Cursor Theme"
file_has_text $FILE "cursorSize=32" "System Settings / Workspace Appearance / Cursor Theme"
file_has_text $FILE "RepeatDelay=150" "System Settings / Input Devices / Keyboard / Hardware"
file_has_text $FILE "RepeatRate=50" "System Settings / Input Devices / Keyboard / Hardware"

FILE=.kde/share/config/kdeglobals
file_has_text $FILE "activeFont=Ubuntu,11" "System Settings / Application Appearance"
file_has_text $FILE "desktopFont=Ubuntu,11"
file_has_text $FILE "font=Ubuntu,11"
file_has_text $FILE "menuFont=Ubuntu,11"
file_has_text $FILE "taskbarFont=Ubuntu,11"
file_has_text $FILE "smallestReadableFont=Ubuntu,10"
file_has_text $FILE "toolBarFont=Ubuntu,10"
file_has_text $FILE "fixed=ProFontWindows,14"

FILE=.kde/share/config/kdeglobals
file_has_text $FILE "ColorScheme=Zion .Reversed." "System Settings / Application Appearance / Colors"
# Unity settings

# KDE settings
file_has_text $FILE "ToolButtonStyle=TextUnderIcon" "System Settings / Application Appearance / Style / Fine Tuning"
file_has_text $FILE "ToolButtonStyleOtherToolbars=TextUnderIcon"
file_has_text $FILE "DateFormatShort=%Y-%m-%d" "System Settings / Locale / Date & Time"
file_has_text $FILE "BinaryUnitDialect=2"   # byte units kB, MB etc
file_has_text $FILE "UseSystemBell=true" "System Settings / Notifications / System Bell"

file_has_text .kde/share/config/plasmarc "name=oxygen" "System Settings / Workspace Appearaance / Desktop Theme"

# Spell checking settings
FILE=.kde/share/config/sonnetrc
file_has_text $FILE "backgroundCheckerEnabled=true" "System Settings / Locale / Spell Checker"
file_has_text $FILE "checkerEnabledByDefault=true"
file_has_text $FILE "defaultLanguage=en_GB"

# Sourcegear Diffmerge colors
FILE=".SourceGear DiffMerge"
cmd_exists ini-inline.pl "missing command to convert INI file to inline settings for search"
ini_file_has_text "$FILE" "/File/Font=16:76:ProFontWindows"
ini_file_has_text "$FILE" "/File/Color/AllEqual/bg=0"
ini_file_has_text "$FILE" "/File/Color/AllEqual/fg=16776960"
ini_file_has_text "$FILE" "/File/Color/AllEqual/Unimp/fg=8421504"
ini_file_has_text "$FILE" "/File/Color/Caret/fg=16777215"
ini_file_has_text "$FILE" "/File/Color/Conflict/bg=4194304"
ini_file_has_text "$FILE" "/File/Color/Conflict/fg=16744576"
ini_file_has_text "$FILE" "/File/Color/Conflict/IL/bg=4721920"
ini_file_has_text "$FILE" "/File/Color/EolUnknown/fg=1973790"
ini_file_has_text "$FILE" "/File/Color/LineNr/bg=0"
ini_file_has_text "$FILE" "/File/Color/NoneEqual/bg=4194304"
ini_file_has_text "$FILE" "/File/Color/NoneEqual/fg=16711680"
ini_file_has_text "$FILE" "/File/Color/NoneEqual/IL/bg=4194304"
ini_file_has_text "$FILE" "/File/Color/Omit/bg=0"
ini_file_has_text "$FILE" "/File/Color/Omit/fg=3552822"
ini_file_has_text "$FILE" "/File/Color/Selection/fg=16776960"
ini_file_has_text "$FILE" "/File/Color/SubEqual/bg=16384"
ini_file_has_text "$FILE" "/File/Color/SubEqual/fg=65280"
ini_file_has_text "$FILE" "/File/Color/SubEqual/IL/bg=32768"
ini_file_has_text "$FILE" "/File/Color/SubNotEqual/bg=64"
ini_file_has_text "$FILE" "/File/Color/SubNotEqual/fg=65535"
ini_file_has_text "$FILE" "/File/Color/SubNotEqual/IL/bg=64"
ini_file_has_text "$FILE" "/File/Color/Void/bg=0"
ini_file_has_text "$FILE" "/File/Color/Void/fg=2631720"
ini_file_has_text "$FILE" "/File/Color/Window/bg=0"
ini_file_has_text "$FILE" "/Folder/Font=16:76:ProFontWindows"
ini_file_has_text "$FILE" "/Folder/Color/Different/bg=0"
ini_file_has_text "$FILE" "/Folder/Color/Equal/bg=0"
ini_file_has_text "$FILE" "/Folder/Color/Equal/fg=16777215"
ini_file_has_text "$FILE" "/Folder/Color/Equivalent/bg=0"
ini_file_has_text "$FILE" "/Folder/Color/Error/bg=1"
ini_file_has_text "$FILE" "/Folder/Color/Folders/bg=0"
ini_file_has_text "$FILE" "/Folder/Color/Folders/fg=16777215"
ini_file_has_text "$FILE" "/Folder/Color/Peerless/bg=0"

# Accessibility
FILE=.kde/share/config/kaccessrc
file_has_text $FILE "SystemBell=true" "System Settings / Accessibility / Bell"
file_has_text $FILE "VisibleBell=true"
file_has_text $FILE "VisibleBellInvert=false"
file_has_text $FILE "AccessXBeep=true"
file_has_text $FILE "BounceKeysRejectBeep=true"
file_has_text $FILE "GestureConfirmation=true" "System Settings / Accessibility / Activation Gestures"
file_has_text $FILE "SlowKeysAcceptBeep=true"
file_has_text $FILE "SlowKeysPressBeep=true"
file_has_text $FILE "SlowKeysRejectBeep=true"
file_has_text $FILE "StickyKeysBeep=true"
file_has_text $FILE "StickyKeysLatch=true"
file_has_text $FILE "ToggleKeysBeep=true"
file_has_text $FILE "kNotifyAccessX=true"
file_has_text $FILE "kNotifyModifiers=true"

# Startup
FILE=.kde/share/config/systemsettingsrc
file_has_text $FILE "ksysguard"
# TODO file_has_text $FILE "dropboxd"

# Default Applications
if [ ! -z $THUNDER ]; then
FILE=.kde/share/config/emaildefaults
file_contains_text $FILE "EmailClient..e.=thunderbird"
fi

FILE=.kde/share/config/kdeglobals
file_has_text $FILE "BrowserApplication=chromium-browser.desktop"
#KDE file_has_text $FILE "BrowserApplication..e.=chromium-browser.desktop"

# sublime configuration
FILE=$SUBLIME_CFG/Packages/User/Preferences.sublime-settings
file_linked_to $FILE $HOME/bin/cfg/Preferences.sublime-settings
file_has_text $FILE "Packages/Color Scheme - Default/Cobalt.tmTheme"
file_has_text $FILE "ProFontWindows"
file_contains_text $FILE "font_size.: 16"

DIR="$SUBLIME_CFG/Packages/Theme - Default"
FILE="$DIR/Default.sublime-theme"
## TODO dir_exists "$DIR" "sublime theme override dir"
## TODO file_linked_to "$FILE" $HOME/bin/cfg/Default.sublime-theme
## TODO file_linked_to "$DIR/bsac_dark_tool_tip_background.png" $HOME/bin/cfg/bsac_dark_tool_tip_background.png

# KDE Desktop Effects
FILE=.kde/share/config/kwinrc
## TODO special window effects
## TODO file_has_text $FILE "kwin4_effect_cubeEnabled=false"
## TODO file_has_text $FILE "kwin4_effect_desktopgridEnabled=true"
## TODO file_has_text $FILE "kwin4_effect_magnifierEnabled=false"
## TODO file_has_text $FILE "kwin4_effect_mousemarkEnabled=true"
## TODO file_has_text $FILE "kwin4_effect_presentwindowsEnabled=true"
## TODO file_has_text $FILE "kwin4_effect_trackmouseEnabled=true"
## TODO file_has_text $FILE "kwin4_effect_windowgeometryEnabled=true"
## TODO file_has_text $FILE "kwin4_effect_zoomEnabled=true"
## TODO file_must_not_have_text $FILE "kwin4_effect_snaphelperEnabled=true"

#FILE=.kde/share/config/kwinrc
#file_has_text $FILE ""

# Screen saver
FILE=.kde/share/config/kscreensaverrc
## TODO file_has_text "$FILE" "Saver=KSlideshow.desktop" "screensaver configured System Settings / Display and Monitor / Screen Locker"
file_has_text "$FILE" "Saver=bsod.desktop" "screensaver configured System Settings / Display and Monitor / Screen Locker"
file_has_text "$FILE" "Timeout=1200" "screensaver activation time configured"
file_has_text "$FILE" "LockGrace=60000" "screensaver lock time configured"

FILE=.kde/share/config/kslideshow.kssrc
file_has_text "$FILE" "Dropbox/WorkSafe" "screensaver dir configured"
file_has_text "$FILE" "SubDirectory=true" "screensaver subdirs"

# uk/us keyboard layout
FILE=.kde/share/config/kxkbrc
file_has_text "$FILE" "LayoutList=gb(extd),us" "keyboard layout System Settings / Input Devices / Keyboard / Layouts / Configure Layouts"

popd

echo COMMANDS="$COMMANDS"
echo PACKAGES="$PACKAGES"

echo TODO VIRTUALBOX SETUP
echo TODO SUBLIME THEME OVERRIDES
echo TODO WINDOW MANAGER SPECIAL EFFECTS
echo TODO SCREEN SAVER SLIDER

echo OK all checks complete

