#!/bin/bash
# Check configuration to make sure things are ok and make them ok where possible

# terminate on first error
set -e
# turn on trace of currently running command if you need it
#set -x

UBUNTU=precise
EMAIL=brent.cowgill@ontology.command
MYNAME="Brent S.A. Cowgill"

INSTALL="vim curl colordiff dlocate deborphan dos2unix flip fdupes tig mmv iselect multitail chromium-browser"
INSTALLFROM="wcd.exec:wcd" # not used, (YET) just quick reference

NODE="node npm"
NODEPKG="nodejs npm node-abbrev node-fstream node-graceful-fs node-inherits node-ini node-mkdirp node-nopt node-rimraf node-tar node-which"

CHARLES="charles"
CHARLESPKG=charles-proxy
CHARLESLICENSE="Ontology-Partners Ltd:c7f341142e860a8354"

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

function dir_linked_to {
   local name target message
   name="$1"
   target="$2"
   message="$3"
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
      ln -s "$target" "$name"
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

file_exists .fonts/p/ProFontWindows.ttf "ProFontWindows font needs to be installed"
file_has_text .kde/share/apps/konsole/Shell.profile ProFontWindows "need to set font for konsole"

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

install_commands "$INSTALL"
install_commands_from "$INSTALLFROM"
install_command_from_packages node "$NODEPKG"

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



popd