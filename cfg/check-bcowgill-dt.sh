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

INSTALL="vim curl colordiff dlocate deborphan dos2unix flip fdupes tig mmv iselect multitail chromium-browser cmatrix"
INSTALLFROM="wcd.exec:wcd" # not used, (YET) just quick reference
SCREENSAVER="kscreensaver ktux kcometen4 screensaver-default-images wmmatrix"
# gnome ubuntustudio-screensaver unicode-screensaver

NODE="node npm"
NODEPKG="nodejs npm node-abbrev node-fstream node-graceful-fs node-inherits node-ini node-mkdirp node-nopt node-rimraf node-tar node-which"

CHARLES="charles"
CHARLESPKG=charles-proxy
CHARLESLICENSE="Ontology-Partners Ltd:c7f341142e860a8354"

DIFFMERGE=diffmerge
DIFFMERGEPKG=diffmerge_4.2.0.697.stable_amd64.deb
DIFFMERGEURL=http://download-us.sourcegear.com/DiffMerge/4.2.0/$DIFFMERGEPKG

SVNVER="1.7.9"
SUBVERSIONPKG="subversion libsvn-java"

SKYPE=skype
SKYPEPKG="skype skype-bin"

COMMANDS="apt-file $NODE svn $CHARLES $SKYPE"
PACKAGES="vim curl colordiff bash-completion dlocate apt-file deborphan dos2unix flip fdupes wcd tig mmv iselect multitail charles-proxy skype skype-bin $NODEPKG $CHARLESPKG $SUBVERSIONPKG $SKYPEPKG"
# flashplutin installer

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
   dir_exists "$dir" "$message" || mkdir -p "$dir"
   dir_exists "$dir" "$message"
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

function install_file_from {
   local file package
   file="$1"
   package="$2"
   file_exists "$file" > /dev/null || (echo want to install $file from $package; sudo apt-get install "$package")
   file_exists "$file"
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
   local list
   list="$1"
   for cmd_pkg in $list
   do
      # split the cmd:pkg string into vars
      IFS=: read cmd package <<< $cmd_pkg
      install_command_from $cmd $package
   done
}

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

function apt_has_source {
   local source message
   source="$1"
   message="$2"
   file_has_text /etc/apt/sources.list "$source" "$message" || (sudo add-apt-repository "$source" && touch go.sudo)
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

pushd $HOME

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

dir_linked_to sandbox workspace "sandbox alias for workspace"
dir_linked_to bin workspace/bin "transfer area in workspace"
dir_linked_to tx workspace/tx "transfer area in workspace"
dir_linked_to jdk workspace/jdk1.7.0_21
dir_linked_to bk Dropbox/WorkSafe/_tx/ontology "backup area in Dropbox"

dir_exists  bin/cfg "bin configuration missing"
make_dir_exist workspace/backup/cfg "workspace home configuration files missing"
make_dir_exist workspace/tx/mirror "workspace mirror area for charles"

file_linked_to go.sh bin/onboot-bcowgill-dt.sh "on reboot script configured"
file_linked_to .bash_aliases bin/cfg/.bash_aliases  "bash alias configured"
file_linked_to .bash_functions bin/cfg/.bash_functions "bash functions configured"
file_linked_to .bashrc bin/cfg/.bashrc "bashrc configured"

cmd_exists apt-file || (sudo apt-get install apt-file && sudo apt-file update)

# update apt sources list with needed values to install some more complicated programs
touch go.sudo; rm go.sudo
apt_has_source "deb http://www.charlesproxy.com/packages/apt/ charles-proxy main" "config for charles-proxy missing"
[ -f go.sudo ] && (wget -q -O - http://www.charlesproxy.com/packages/apt/PublicKey | sudo apt-key add - )
apt_has_source "deb http://ppa.launchpad.net/svn/ppa/ubuntu $(lsb_release -sc) main" "config for svn update missing"
apt_has_source "deb-src http://ppa.launchpad.net/svn/ppa/ubuntu $(lsb_release -sc) main" "config for svn update missing"
apt_has_source "deb http://archive.canonical.com/ $(lsb_release -sc) partner" "config for skype missing"

[ -f go.sudo ] && (sudo apt-get update; sudo apt-get install $CHARLESPKG $SUBVERSIONPKG $SKYPEPKG && sudo apt-get -f install && echo YOUDO: set charles license: $CHARLESLICENSE)
file_exists /usr/lib/x86_64-linux-gnu/jni/libsvnjavahl-1.so "svn and eclipse setup lib exists"
dir_linked_to /usr/lib/jni /usr/lib/x86_64-linux-gnu/jni "svn and eclipse symlink exists" root

cmd_exists $CHARLES
cmd_exists $SKYPE
cmd_exists svn
if svn --version | grep " version " | grep $SVNVER; then
   echo OK svn command version correct
else
   echo NOT OK svn command version incorrect
   exit 1
fi

install_file_from /etc/bash_completion bash-completion
file_exists_from_package /etc/bash_completion.d/git bash-completion

cmd_exists $DIFFMERGE "sourcegear diffmerge will try to get" || (wget --output-document $HOME/Downloads/$DIFFMERGEPKG $DIFFMERGEURL && sudo dpkg --install $HOME/Downloads/$DIFFMERGEPKG)
cmd_exists $DIFFMERGE "sourcegear diffmerge"

install_commands "$INSTALL"
install_commands_from "$INSTALLFROM"
install_command_from_packages node "$NODEPKG"
install_command_from_packages kslideshow.kss "$SCREENSAVER"

make_dir_exist workspace/dropbox-dist "dropbox distribution files"
file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd "dropbox installed" || (pushd workspace/dropbox-dist && wget -O - "https://www.dropbox.com/download?plat=lnx.x86_64" | tar xzf - && ./.dropbox-dist/dropboxd & popd)
file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd

commands_exist "$COMMANDS"

cmd_exists backup-work.sh "backup script missing"
file_exists bin/cfg/crontab-$HOSTNAME "crontab missing" || backup-work.sh
crontab_has_command "backup-work.sh" "30 17,18 * * * \$HOME/workspace/bin/backup-work.sh > /tmp/backup-work.log 2>&1" "crontab daily backup configuration"
crontab_has_command "backup-work.sh"

if [ x`git config --global --get user.email` == x$EMAIL ]; then
   echo OK git config has been set up
else
   echo NOT OK git config not set. trying to do so
   git config --global user.name "$MYNAME"
   git config --global user.email $EMAIL
fi

# Check charles configuration options
FILE=.charles.config
file_has_text $FILE "port>58008" "charles port config"
file_has_text $FILE "enableSOCKSTransparentHTTPProxying>true" "charles proxy config"
file_has_text $FILE "displayFont>ProFontWindows" "charles font config"
file_has_text $FILE "displayFontSize>16" "charles font config"
file_has_text $FILE "tx/mirror/web</savePath" "charles mirror config"
file_has_text $FILE "showMemoryUsage>true" "charles memory usage config"

FILE=.kde/share/config/kioslaverc
file_has_text $FILE "httpProxy=localhost 58008" "system proxy config"

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
file_has_text .thunderbird/ryu9c8b3.default/prefs.js "imap.hslive.net" "thunderbird outlook configuration http://wiki/wiki/Hosted_Exchange#IMAP"
file_has_text .thunderbird/ryu9c8b3.default/prefs.js "default/News/newsrc-news" "thunderbird newsgroup configuration http://wiki/wiki/Hosted_Exchange#News_Groups http://wiki/wiki/New_Engineering_Starters_Handbook#Newsgroups"q
file_has_text .thunderbird/ryu9c8b3.default/prefs.js "ProFontWindows"

# System Settings
file_has_text ./.kde/share/config/kcminputrc "MouseButtonMapping=LeftHanded"

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

popd
