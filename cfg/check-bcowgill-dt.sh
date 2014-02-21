#!/bin/bash
# Check configuration to make sure things are ok and make them ok where possible

# terminate on first error
set -e
# turn on trace of currently running command if you need it
#set -x

UBUNTU=precise
ULIMITFILES=8196
EMAIL=brent.cowgill@ontology.command
MYNAME="Brent S.A. Cowgill"

DOWNLOAD=$HOME/Downloads

INSTALL="vim curl wget colordiff dlocate deborphan dos2unix flip fdupes tig mmv iselect multitail chromium-browser cmatrix gettext"
INSTALL_FROM="wcd.exec:wcd mvn:maven"
SCREENSAVER="kscreensaver ktux kcometen4 screensaver-default-images wmmatrix"
# gnome ubuntustudio-screensaver unicode-screensaver

NODE="node npm grunt grunt-init uglifyjs phantomjs"
NODE_VER="v0.10.25"
NODE_PKG="nodejs npm node-abbrev node-fstream node-graceful-fs node-inherits node-ini node-mkdirp node-nopt node-rimraf node-tar node-which"
INSTALL_NPM_FROM=""
INSTALL_NPM_GLOBAL_FROM="uglifyjs:uglify-js@1 grunt:grunt-cli grunt-init"
INSTALL_GRUNT_TEMPLATES="basic:grunt-init-gruntfile node:grunt-init-node jquery:grunt-init-jquery.git"

CHARLES="charles"
CHARLES_PKG=charles-proxy
CHARLES_LICENSE="Ontology-Partners Ltd:c7f341142e860a8354"

VIRTUALBOX="VirtualBox"
VIRTUALBOX_CMDS="dkms VirtualBox"
VIRTUALBOX_PKG="dkms virtualbox-4.3"

DIFFMERGE=diffmerge
DIFFMERGE_PKG=diffmerge_4.2.0.697.stable_amd64.deb
DIFFMERGE_URL=http://download-us.sourcegear.com/DiffMerge/4.2.0/$DIFFMERGE_PKG

SUBLIME=subl
SUBLIME_CFG=.config/sublime-text-3
SUBLIME_PKG=sublime-text_build-3047_amd64.deb
SUBLIME_URL=http://c758482.r82.cf2.rackcdn.com/$SUBLIME_PKG

SVN_VER="1.8.5"
SVN_PKG="subversion libsvn-java"

MVN_VER="3.0.4"

GIT_VER="1.9.0"
GIT_PKG_MAKE="libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev build-essential"
GIT_PKG=git
GIT_PKG_AFTER="git-doc git-gui gitk libsvn-perl git-svn tig"

GIT_TAR=git-$GIT_VER
GIT_URL=https://git-core.googlecode.com/files/$GIT_TAR.tar.gz

GITSVN=/usr/lib/git-core/git-svn
GITSVN_PKG="git-svn"

THUNDER=ryu9c8b3.default

SKYPE=skype
SKYPE_PKG="skype skype-bin"

INI_DIR=check-iniline

COMMANDS="apt-file $NODE svn git wcd.exec mvn gettext $CHARLES $SKYPE $VIRTUALBOX_CMDS $SUBLIME $DIFFMERGE"
PACKAGES="vim curl colordiff bash-completion dlocate apt-file deborphan dos2unix flip fdupes wcd $SVN_PKG $GIT_PKG_MAKE $GIT_PKG_AFTER $GITSVNPKG tig mmv iselect multitail charles-proxy skype skype-bin $NODE_PKG $CHARLES_PKG $SKYPE_PKG $VIRTUALBOX_PKG"

#============================================================================
# files and directories

function check_linux {
   local version
   version="$1"
   if [ $(lsb_release -sc) == $version ]; then
      echo OK ubuntu version $version
      return 0
   else
      echo NOT OK ubuntu version not $version
      return 1
   fi
}

function dir_exists {
   local dir message
   dir="$1"
   message="$2"
   if [ -d "$dir" ]; then
      echo OK directory exists: $dir
      return 0
   else
      echo NOT OK directory missing: $dir [$message]
      return 1
   fi
}

function make_dir_exist {
   local dir message
   dir="$1"
   message="$2"
   dir_exists "$dir" > /dev/null || mkdir -p "$dir"
   dir_exists "$dir" "$message"
}

function make_root_file_exist {
   local file contents message temp_file
   file="$1"
   contents="$2"
   temp_file=`mktemp`
   file_exists "$file" > /dev/null || (echo "$contents" >> $temp_file; chmod go+r $temp_file; sudo cp $temp_file "$file")
   rm $temp_file
   file_exists "$file" "$message"
}

function remove_file {
   local file
   if [ -f "$file" ]; then
      rm "$file"
   fi
}

function file_exists {
   local file message
   file="$1"
   message="$2"
   if [ -f "$file" ]; then
      echo OK file exists: $file
      return 0
   else
      echo NOT OK file missing: $file [$message]
      return 1
   fi
}

function file_link_exists {
   local file message
   file="$1"
   message="$2"
   if [ -L "$file" ]; then
      echo OK symlink exists: $file
      return 0
   else
      echo NOT OK symlink missing: $file [$message]
      return 1
   fi
}

function dir_link_exists {
   local dir message
   dir="$1"
   message="$2"
   if [ -L "$dir" ]; then
      echo OK symlink dir exists: $dir
      return 0
   else
      echo NOT OK symlink dir missing: $dir [$message]
      return 1
   fi
}

function file_linked_to {
   local name target message
   name="$1"
   target="$2"
   message="$3"
   file_exists "$target" "$message"
   if [ `readlink "$name"` == "$target" ]; then
      echo OK symlink $name links to $target
      return 0
   else
      file_link_exists "$name" "will try to create for $message" || file_exists "$name" "save existing" && mv "$name" "$name.orig"
      file_link_exists "$name" "try creating for $message" || ln -s "$target" "$name"
      file_link_exists "$name" "$message"
   fi
}

function file_linked_to_root {
   local name target message
   name="$1"
   target="$2"
   message="$3"
   file_exists "$target" "$message"
   if [ `readlink "$name"` == "$target" ]; then
      echo OK symlink $name links to $target
      return 0
   else
      file_link_exists "$name" "will try to create for $message" || file_exists "$name" "save existing" && sudo mv "$name" "$name.orig"
      file_link_exists "$name" "try creating for $message" || sudo ln -s "$target" "$name"
      file_link_exists "$name" "$message"
   fi
}

function file_hard_linked_to {
   local name target message
   name="$1"
   target="$2"
   message="$3"
   file_exists "$target" "$message check target"
   file_exists "$name" "$message will try to hard link" || ln "$target" "$name"
   file_exists "$name" "$message"
}

function dir_linked_to {
   local name target message root
   name="$1"
   target="$2"
   message="$3"
   root="$4"
   dir_exists "$target" "$message"
   if [ -e "$name" ]; then
      if [ `readlink "$name"` == "$target" ]; then
         echo OK symlink $name links to dir $target
         return 0
      else
         if [ `readlink "$name"` == "$target/" ]; then
            echo OK symlink $name links to dir $target/
            return 0
         else
            echo NOT OK already exists: "$name" cannot create as a link to dir "$target" [$message] `readlink "$name"`
            return 1
         fi
      fi
   else
      echo NOT OK symlink $name missing will try to create
      echo ln -s "$target" "$name"
      if [ -z "$root" ]; then
         ln -s "$target" "$name"
      else
         sudo ln -s "$target" "$name"
      fi
      dir_link_exists "$name" "$message"
   fi
}

function file_exists_from_package {
   local file package
   file="$1"
   package="$2"
   file_exists "$file" "sudo apt-get install $package"
}

function install_file_from {
   local file package
   file="$1"
   package="$2"
   file_exists "$file" > /dev/null || (echo want to install $file from $package; sudo apt-get install "$package")
   file_exists "$file"
}

function install_file_manually {
   local file message source
   file="$1"
   message="$2"
   source="$3"
   file_exists "$file" "manually install $message from $source"
}

function install_git_repo {
   local dir subdir url message
   dir="$1"
   subdir="$2"
   url="$3"
   message="$4"
   dir_exists "$dir" "$message"
   dir_exists "$dir/$subdir" > /dev/null || (echo "NOT OK get git repo $mesasge from $url"; pushd "$dir" && git clone "$url" "$subdir"; popd)
   dir_exists "$dir/$subdir" "$message"
}

#============================================================================
# commands and packages

function cmd_exists {
   local cmd messagenode npm
   cmd="$1"
   message="$2"
   if which "$cmd"; then
      echo OK command $cmd exists
      return 0
   else
      if [ -z "$message" ]; then
         message="sudo apt-get install $cmd"
      fi
      echo NOT OK command $cmd missing [$message]
      return 1
   fi
}

function commands_exist {
   local commands
   commands="$1"
   for cmd in $commands
   do
      cmd_exists "$cmd"
   done
}

function install_command_from {
   local command package
   command="$1"
   package="$2"
   if [ -z "$package" ]; then
      package="$command"
   fi
   cmd_exists "$command" > /dev/null || (echo want to install $command from $package; sudo apt-get install "$package")
   cmd_exists "$command"
}

function install_command_from_packages {
   local command packages
   command="$1"
   packages="$2"
   cmd_exists "$command" > /dev/null || (echo want to install $command from $packages; sudo apt-get install $packages)
   cmd_exists "$command"
}

function install_commands {
   local commands
   commands="$1"
   for cmd in $commands
   do
      cmd_exists $cmd > /dev/null || (echo want to install $cmd ; sudo apt-get install "$cmd")
      cmd_exists $cmd
   done
}

# Install commands from specific package specified as input list wi1.7.9th : separation
# cmd1:pkg2 cmd2:pkg2 ...
function install_commands_from {
   local list cmd_pkg cmd package
   list="$1"
   for cmd_pkg in $list
   do
      # split the cmd:pkg string into vars
      IFS=: read cmd package <<< $cmd_pkg
      install_command_from $cmd $package
   done
}

#============================================================================
# node/npm/grunt related commands and packages

function install_npm_command_from {
   local command package
   command="$1"
   package="$2"
   if [ -z "$package" ]; then
      package="$command"
   fi
   cmd_exists "$command" > /dev/null || (echo want to install $command from npm $package; sudo npm install "$package")
   cmd_exists "$command"
}

function install_npm_commands_from {
   local list cmd_pkg cmd package
   list="$1"
   for cmd_pkg in $list
   do
      # split the cmd:pkg string into vars
      IFS=: read cmd package <<< $cmd_pkg
      install_npm_command_from $cmd $package
   done
}

function install_npm_global_command_from {
   local command package
   command="$1"
   package="$2"
   if [ -z "$package" ]; then
      package="$command"
   fi
   cmd_exists "$command" > /dev/null || (echo want to install global $command from npm $package; sudo npm install -g "$package")
   cmd_exists "$command"
}

function install_npm_global_commands_from {
   local list cmd_pkg cmd package
   list="$1"
   for cmd_pkg in $list
   do
      # split the cmd:pkg string into vars
      IFS=: read cmd package <<< $cmd_pkg
      install_npm_global_command_from $cmd $package
   done
}

function install_grunt_template_from {
   local template package dir
   template="$1"
   package="$2"
   dir="$HOME/.grunt-init/$template"
   dir_exists "$dir" > /dev/null || (echo want to install grunt template $template from $package; git clone https://github.com/gruntjs/$package "$dir")
   dir_exists "$dir"
}

function install_grunt_templates_from {
   local list tmp_pkg template package
   list="$1"
   for tmp_pkg in $list
   do
      # split the template:pkg string into vars
      IFS=: read template package <<< $tmp_pkg
      install_grunt_template_from $template $package
   done
}

#============================================================================
# check configuration within files

# exact check for text in file
function file_has_text {
   local file text message
   file="$1"
   text="$2"
   message="$3"
   file_exists "$file"
   if grep "$text" "$file" > /dev/null; then
      echo OK file has text: "$file" "$text"
      return 0
   else
      echo NOT OK file missing text: "$file" "$text" [$message]
      return 1
   fi
}

# regex check for text in file
function file_contains_text {
   local file text message
   file="$1"
   text="$2"
   message="$3"
   file_exists "$file"
   if egrep "$text" "$file" > /dev/null; then
      echo OK file contains regex: "$file" "$text"
      return 0
   else
      echo NOT OK file missing regex: egrep \"$text\" \"$file\" [$message]
      return 1
   fi
}

function file_must_not_have_text {
   local file text message
   file="$1"
   text="$2"
   message="$3"
   file_exists "$file"
   if grep "$text" "$file" > /dev/null; then
      echo NOT OK file should not have text: "$file" "$text" [$message]
      return 1
   else
      echo OK file does not have text: "$file" "$text"
      return 0
   fi
}

function ini_file_has_text {
   local dir file text message
   dir=`dirname "$1"`
   file=`basename "$1"`
   text="$2"
   message="$3"
   file_exists "$dir/$file"
   file_exists "$INI_DIR/$file" > /dev/null || (ini-inline.pl "$dir/$file" > "$INI_DIR/$file")
   file_has_text "$INI_DIR/$file" "$text" "$message"
}

function crontab_has_command {
   local command config message
   command="$1"
   config="$2"
   message="$3"
   if crontab -l | grep "$command"; then
      echo OK crontab has command $command
      return 0
   else
      echo NOT OK crontab missing command $oommand trying to install [$message]
      (crontab -l; echo "$config" ) | crontab -
   fi
}

#============================================================================
# apt-get configuration

function apt_has_source {
   local source message
   source="$1"
   message="$2"
   file_has_text /etc/apt/sources.list "$source" "$message" || (sudo add-apt-repository "$source" && touch go.sudo)
}

function apt_must_not_have_source {
   local source message
   source="$1"
   message="$2"
   file_must_not_have_text /etc/apt/sources.list "$source" "$message"
}

function apt_has_key {
   local key url message
   key="$1"
   url="$2"
   message="$3"
   if sudo apt-key list | grep "$key"; then
      echo OK apt-key has $key
      return 0
   else
      echo NOT OK apt-key missing $key trying to install [$message]
      wget -q "$url" -O- | sudo apt-key add -
      if sudo apt-key list | grep "$key"; then
         echo OK apt-key installed $key
         return 0
      else
         echo NOT OK apt-key could not install $key
         return 1
      fi
   fi
}

#============================================================================
# miscellaneous configuration

function has_ssh_keys {
# need to upload ssh public key to github before getting grunt templates
   file_linked_to $HOME/.ssh/id_rsa.pub $HOME/bin/cfg/id_rsa.pub
   file_linked_to $HOME/.ssh/id_rsa $HOME/bin/cfg/id_rsa
#   file_exists $HOME/.ssh/id_rsa.pub > /dev/null || (ssh-keygen -t rsa)
#   file_exists $HOME/.ssh/id_rsa.pub "ssh keys should exist"
}

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
   file_has_text /etc/security/limits.conf brent.cowgill "check limits file" || ( \
      echo echo \"brent.cowgill            soft    nofile          $ULIMITFILES\" \>\> /etc/security/limits.conf > go.sudo;
      echo echo \"brent.cowgill            hard    nofile          $ULIMITFILES\" \>\> /etc/security/limits.conf >> go.sudo;
      chmod +x go.sudo;
      sudo ./go.sudo\
   )
   file_has_text /etc/security/limits.conf brent.cowgill "check username in limits file"
   file_has_text /etc/security/limits.conf $ULIMITFILES "check value in limits file"
   echo YOUDO You have to logout/login again for ulimit to take effect.
   exit 1
fi

file_exists .fonts/p/ProFontWindows.ttf "ProFontWindows font needs to be installed"
file_has_text .kde/share/apps/konsole/Shell.profile "Font=ProFontWindows,14" "need to set font for konsole"
file_has_text .kde/share/config/kateschemarc "Font=ProFontWindows,14" "ProFontWindows in kate editor"
#file_has_text .kde/share/config/katesyntaxhighlightingrc ""
file_has_text .kde/share/config/kdeglobals "fixed=ProFontWindows,14" "ProFontWindows for System fixed width font"

#TODO KATE color check
#./.kde/share/config/colors/Recent_Colors
#./.kde/share/config/kateschemarc
#./.kde/share/config/katerc

dir_linked_to sandbox workspace "sandbox alias for workspace"
dir_linked_to bin workspace/bin "transfer area in workspace"
dir_linked_to tx workspace/tx "transfer area in workspace"
dir_linked_to jdk workspace/jdk1.7.0_21
dir_linked_to bk Dropbox/WorkSafe/_tx/ontology "backup area in Dropbox"

dir_exists  bin/cfg "bin configuration missing"
rm -rf $INI_DIR
make_dir_exist /tmp/$USER "user's own temporary directory"
dir_linked_to tmp /tmp/$USER "make a tmp in home dir point to /tmp/"
make_dir_exist $INI_DIR "output area for checking INI file settings"
make_dir_exist workspace/backup/cfg "workspace home configuration files missing"
make_dir_exist workspace/tx/mirror "workspace mirror area for charles"

file_linked_to go.sh bin/onboot-bcowgill-dt.sh "on reboot script configured"
file_linked_to .bash_aliases bin/cfg/.bash_aliases  "bash alias configured"
file_linked_to .bash_functions bin/cfg/.bash_functions "bash functions configured"
file_linked_to .bashrc bin/cfg/.bashrc "bashrc configured"

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
#   mkdir -p /data/brent.cowgill
#   chown -R brent.cowgill:domusers /data/brent.cowgill
      exit 1
   fi
else
   dir_exists /data/brent.cowgill "personal area on data dir missing"
fi
make_dir_exist /data/brent.cowgill/backup "backup dir on /data"
make_dir_exist /data/brent.cowgill/VirtualBox "VirtualBox dir on /data"

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

apt_has_source "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" "apt config for virtualbox missing"
apt_must_not_have_source "deb-src http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" "apt config for virtualbox wrong"
echo Checking for apt-keys...
apt_has_key VirtualBox http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc "key fingerprint for VirtualBox missing"
cmd_exists $VIRTUALBOX || (sudo apt-get update; sudo apt-get install $VIRTUALBOX_PKG)
cmd_exists $VIRTUALBOX 

[ -f go.sudo ] && (sudo apt-get update; sudo apt-get install $CHARLES_PKG $SVN_PKG $SKYPE_PKG && sudo apt-get -f install && echo YOUDO: set charles license: $CHARLES_LICENSE)
file_exists /usr/lib/x86_64-linux-gnu/jni/libsvnjavahl-1.so "svn and eclipse setup lib exists"
dir_linked_to /usr/lib/jni /usr/lib/x86_64-linux-gnu/jni "svn and eclipse symlink exists" root

cmd_exists $CHARLES
cmd_exists $SKYPE
cmd_exists svn
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

cmd_exists mvn
if mvn --version | grep "Apache Maven " | grep $MVN_VER; then
   echo OK mvn command version correct
else
   echo NOT OK mvn command version incorrect
   exit 1
fi
if [ "x$JAVA_HOME" == "x/usr/lib/jvm/jdk1.7.0_21" ]; then
   echo OK JAVA_HOME set correctly
else
   echo NOT OK JAVA_HOME is incorrect $JAVA_HOME
   exit 1
fi
if [ "x$M2_HOME" == "x" ]; then
   echo OK M2_HOME set correctly
else
   echo NOT OK M2_HOME is incorrect $M2_HOME
   exit 1
fi

cmd_exists git
if [ -x $GITSVN ]; then
   echo OK git svn command installed
else
   echo NOT OK git svn command missing -- will try to install
   sudo apt-get install $GITSVN_PKG
fi
cmd_exists $GITSVN

# git installs completion file but not in right place any more
file_linked_to_root /etc/bash_completion.d/git /usr/share/bash-completion/completions/git

cmd_exists $DIFFMERGE "sourcegear diffmerge will try to get" || (wget --output-document $HOME/Downloads/$DIFFMERGE_PKG $DIFFMERGE_URL && sudo dpkg --install $HOME/Downloads/$DIFFMERGE_PKG)
cmd_exists $DIFFMERGE "sourcegear diffmerge"

install_commands "$INSTALL"
install_commands_from "$INSTALL_FROM"
install_command_from_packages node "$NODE_PKG"
install_command_from_packages kslideshow.kss "$SCREENSAVER"

cmd_exists $SUBLIME "sublime will try to get" || (wget --output-document $HOME/Downloads/$SUBLIME_PKG $SUBLIME_URL && sudo dpkg --install $HOME/Downloads/$SUBLIME_PKG)
cmd_exists $SUBLIME "sublime editor"
install_file_manually "$SUBLIME_CFG/Installed Packages/Package Control.sublime-package" "sublime package control from instructions" "https://sublime.wbond.net/installation"
install_file_manually "$SUBLIME_CFG/Packages/Grunt/SublimeGrunt.sublime-settings" "sublime grunt build system" "https://www.npmjs.org/package/sublime-grunt-build"
install_git_repo "$SUBLIME_CFG/Packages" sublime-grunt-build git://github.com/jonschlinkert/sublime-grunt-build.git "sublime text grunt build package - check for Tools/Build System/Grunt after"

make_dir_exist workspace/dropbox-dist "dropbox distribution files"
file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd "dropbox installed" || (pushd workspace/dropbox-dist && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - && ./.dropbox-dist/dropboxd & popd)
file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd

commands_exist "$COMMANDS"

cmd_exists backup-work.sh "backup script missing"
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

if node --version | grep $NODE_VER; then
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

# Check charles configuration options
FILE=.charles.config
file_has_text $FILE "port>58008" "charles port config"
file_has_text $FILE "enableSOCKSTransparentHTTPProxying>true" "charles proxy config"
file_has_text $FILE "displayFont>ProFontWindows" "charles font config"
file_has_text $FILE "displayFontSize>16" "charles font config"
file_has_text $FILE "tx/mirror/web</savePath" "charles mirror config"
file_has_text $FILE "showMemoryUsage>true" "charles memory usage config"

FILE=.kde/share/config/kioslaverc
file_has_text $FILE "ProxyType=1" "system proxy config"
file_has_text $FILE "httpProxy=localhost 58008" "system proxy config to charles"

# Eclipse configuration
file_exists eclipse/eclipse "Eclipse program"
file_exists eclipse/Eclipse.desktop "Eclipse launcher"
dir_exists .local/share/applications "KDE applications folder"
file_exists .local/share/applications/Eclipse.desktop "Eclipse KDE menu item" || cp eclipse/Eclipse.desktop .local/share/applications/Eclipse.desktop

TEXT="ProFontWindows"
file_has_text workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.ui.workbench.prefs "$TEXT"
file_has_text workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.jdt.ui.prefs "$TEXT"
file_has_text workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings/org.eclipse.wst.jsdt.ui.prefs "$TEXT"

# Ontology Modeller
file_exists modeller/modeller "Ontology modeller"
make_dir_exist /tmp/ontology/output "Ontology output dir"
make_dir_exist /tmp/ontology/system "Ontology system dir"

# Dropbox configuration
dir_exists .config/autostart
file_exists workspace/dropbox-dist/dropboxd.desktop "dropbox autostart saved"
file_exists .config/autostart/dropboxd.desktop "dropbox autostart" || (cp workspace/dropbox-dist/dropboxd.desktop .config/autostart/dropboxd.desktop)

# Screen saver
file_has_text .kde/share/config/kscreensaverrc "Saver=KSlideshow.desktop" "screensaver configured"
file_has_text .kde/share/config/kslideshow.kssrc "Dropbox/WorkSafe" "screensaver dir configured"

# Thunderbird
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

# System Settings
FILE=.kde/share/config/kcminputrc
file_has_text $FILE "MouseButtonMapping=LeftHanded"
file_has_text $FILE "cursorTheme=redglass"
file_has_text $FILE "cursorSize=32"

FILE=.kderc
file_has_text $FILE "activeFont=Ubuntu,11"
file_has_text $FILE "desktopFont=Ubuntu,11"
file_has_text $FILE "font=Ubuntu,11"
file_has_text $FILE "menuFont=Ubuntu,11"
file_has_text $FILE "taskbarFont=Ubuntu,11"
file_has_text $FILE "smallestReadableFont=Ubuntu,10"
file_has_text $FILE "toolBarFont=Ubuntu,10"
file_has_text $FILE "fixed=ProFontWindows,14"

FILE=.kde/share/config/kdeglobals
file_has_text $FILE "ColorScheme=Zion .Reversed."
file_has_text $FILE "activeFont=Ubuntu,11"
file_has_text $FILE "desktopFont=Ubuntu,11"
file_has_text $FILE "font=Ubuntu,11"
file_has_text $FILE "menuFont=Ubuntu,11"
file_has_text $FILE "taskbarFont=Ubuntu,11"
file_has_text $FILE "smallestReadableFont=Ubuntu,10"
file_has_text $FILE "toolBarFont=Ubuntu,10"
file_has_text $FILE "fixed=ProFontWindows,14"
file_has_text $FILE "ToolButtonStyle=TextUnderIcon"
file_has_text $FILE "ToolButtonStyleOtherToolbars=TextUnderIcon"
file_has_text $FILE "DateFormatShort=%Y-%m-%d"
file_has_text $FILE "BinaryUnitDialect=2"   # byte units kB, MB etc
file_has_text $FILE "UseSystemBell=true"

file_has_text .kde/share/config/plasmarc "name=oxygen"

# Spell checking settings
FILE=.kde/share/config/sonnetrc
file_has_text $FILE "backgroundCheckerEnabled=true"
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
file_has_text $FILE "SystemBell=true"
file_has_text $FILE "VisibleBell=true"
file_has_text $FILE "VisibleBellInvert=false"
file_has_text $FILE "AccessXBeep=true"
file_has_text $FILE "BounceKeysRejectBeep=true"
file_has_text $FILE "GestureConfirmation=true"
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
file_has_text $FILE "dropboxd"

# Default Applications
FILE=.kde/share/config/emaildefaults
file_contains_text $FILE "EmailClient..e.=thunderbird"
FILE=.kde/share/config/kdeglobals
file_has_text $FILE "BrowserApplication..e.=chromium-browser.desktop"

# sublime configuration
FILE=$SUBLIME_CFG/Packages/User/Preferences.sublime-settings
file_linked_to $FILE $HOME/bin/cfg/Preferences.sublime-settings
file_has_text $FILE "Packages/Color Scheme - Default/Cobalt.tmTheme"
file_has_text $FILE "ProFontWindows"
file_contains_text $FILE "font_size.: 16"

DIR="$SUBLIME_CFG/Packages/Theme - Default"
FILE="$DIR/Default.sublime-theme"
dir_exists "$DIR" "sublime theme override dir"
file_linked_to "$FILE" $HOME/bin/cfg/Default.sublime-theme
file_linked_to "$DIR/bsac_dark_tool_tip_background.png" $HOME/bin/cfg/bsac_dark_tool_tip_background.png

# KDE Desktop Effects
FILE=.kde/share/config/kwinrc
file_has_text $FILE "kwin4_effect_cubeEnabled=false"
file_has_text $FILE "kwin4_effect_desktopgridEnabled=true"
file_has_text $FILE "kwin4_effect_magnifierEnabled=false"
file_has_text $FILE "kwin4_effect_mousemarkEnabled=true"
file_has_text $FILE "kwin4_effect_presentwindowsEnabled=true"
file_has_text $FILE "kwin4_effect_trackmouseEnabled=true"
file_has_text $FILE "kwin4_effect_windowgeometryEnabled=true"
file_has_text $FILE "kwin4_effect_zoomEnabled=true"
file_must_not_have_text $FILE "kwin4_effect_snaphelperEnabled=true"

#FILE=.kde/share/config/kwinrc
#file_has_text $FILE ""

popd

echo COMMANDS="$COMMANDS"
echo PACKAGES="$PACKAGES"
echo OK all checks complete
