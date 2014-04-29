# lib-check-system.sh - library of functions for checking linux system and setting things up
# Brent S.A. Cowgill.
# License: Unlicense http://unlicense.org/

# Provides perl test case like output
# OK something worked
# NOT OK something failed
# Make sure you set -e on your setup script so it will terminate on first failure
#
# Example:
# set -e
# file_exists something-i-need.txt "need this config file"
# produces output:
# OK file exists: something-i-need.txt
# or
# NOT OK file missing: something-i-need.txt [need this config file]

#============================================================================
# Flow control

function pause {
   local message input
   message="$1"
   echo NOT OK PAUSE $message press ENTER to continue.
   read input
}

function stop {
   local message
   message="$1"
   echo NOT OK STOPPED: $message
   exit 1
}

function check_linux {
   local version
   version="$1"
   if [ $(lsb_release -sc) == $version ]; then
      echo OK ubuntu version $version
   else
      echo NOT OK ubuntu version not $version
      return 1
   fi
   return 0
}

#============================================================================
# files and directories

function dir_exists {
   local dir message
   dir="$1"
   message="$2"
   if [ -d "$dir" ]; then
      echo OK directory exists: $dir
   else
      echo NOT OK directory missing: $dir [$message]
      return 1
   fi
   return 0
}

# Enter a directory for some task, checking for existence
function push_dir {
   local dir message
   dir="$1"
   message="$2"
   if dir_exists "$dir"; then
      pushd "$dir" > /dev/null
      echo $message in dir `pwd`
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
   temp_file=`mktemp --tmpdir=/tmp/$USER`
   file_exists "$file" > /dev/null || (echo "$contents" >> $temp_file; chmod go+r $temp_file; sudo cp $temp_file "$file")
   rm $temp_file
   file_exists "$file" "$message"
}

# removes a file
function remove_file {
   local file message
   file="$1"
   message="$2"
   if [ -f "$file" ]; then
      if rm "$file"; then
         echo OK file removed "$file" [$message]
      else
         echo MAYBE NOT OK unable to remove file "$file" [$message]
         echo was in dir `pwd`
         set +e
         ls -al "$file"
         set -e
      fi
   else
      echo MAYBE NOT OK unable to remove file "$file" not found [message]
      echo was in dir `pwd`
      set +e
      ls -al "$file"
      set -e
   fi
}

# removes a symbolic link
function remove_symlink {
   local file message
   file="$1"
   message="$2"
   if [ -L "$file" ]; then
      if rm "$file"; then
         echo OK symlink removed "$file" [$message]
      else
         echo MAYBE NOT OK unable to remove symlink "$file" [$message]
         echo was in dir `pwd`
         set +e
         ls -al "$file"
         set -e
      fi
   else
      echo MAYBE NOT OK unable to remove symlink "$file" not found [message]
      echo was in dir `pwd`
      set +e
      ls -al "$file"
      set -e
   fi
}

# check that a file is present somewhere on the system using locate
function file_present {
   local file message
   file="$1"
   message="$2"
   if locate "$file"; then
      echo OK file "$file" is present on system [$message]
   else
      echo NOT OK file "$file" is NOT present on system [$message]
      return 1
   fi
   return 0
}

function file_exists {
   local file message
   file="$1"
   message="$2"
   if [ -f "$file" ]; then
      echo OK file exists: $file
   else
      echo NOT OK file missing: $file [$message]
      return 1
   fi
   return 0
}

function file_link_exists {
   local file message
   file="$1"
   message="$2"
   if [ -L "$file" ]; then
      echo OK symlink exists: $file
   else
      echo NOT OK symlink missing: $file [$message]
      return 1
   fi
   return 0
}

function dir_link_exists {
   local dir message
   dir="$1"
   message="$2"
   if [ -L "$dir" ]; then
      echo OK symlink dir exists: $dir
   else
      echo NOT OK symlink dir missing: $dir [$message]
      return 1
   fi
   return 0
}

function file_linked_to {
   local name target message link
   name="$1"
   target="$2"
   message="$3"
   file_exists "$target" "$message"
   set +e
   link=`readlink "$name"`
   set -e
   if [ "${link:-}" == "$target" ]; then
      echo OK symlink $name links to $target
      return 0
   else
      file_link_exists "$name" "will try to create for $message" || file_exists "$name" "save existing" && mv "$name" "$name.orig"
      file_link_exists "$name" "try creating for $message" || ln -s "$target" "$name"
      file_link_exists "$name" "$message"
   fi
}

function file_linked_to_root {
   local name target message link
   name="$1"
   target="$2"
   message="$3"
   file_exists "$target" "$message"
   set +e
   link=`readlink "$name"`
   set -e
   if [ "${link:-}" == "$target" ]; then
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
   local name target message root link
   name="$1"
   target="$2"
   message="$3"
   root="$4"
   dir_exists "$target" "$message"
   if [ -e "$name" ]; then
      set +e
      link=`readlink "$name"`
      set -e
      if [ "${link:-}" == "$target" ]; then
         echo OK symlink $name links to dir $target
         return 0
      else
         if [ "${link:-}" == "$target/" ]; then
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

function install_file_from_url {
   local file package url message
   file="$1"
   package="$2"
   url="$3"
   message="$4"
   file_exists "$file" > /dev/null || (echo Try to install $file from $package at $url; wget --output-document $HOME/Downloads/$package $url)
   file_exists "$file" "$message"
}

# Install a file from a downloaded archive which creates its own subdirectory
function install_file_from_url_zip {
   local file package url message
   file="$1"
   package="$2"
   url="$3"
   message="$4"
   install_file_from_url "$file" "$package" "$url" > /dev/null || (pushd "$HOME/Downloads/" && extract_archive "$HOME/Downloads/$package" && popd)
   file_exists "$file" "$message"
}

# Install a file from a downloaded archive which doesn't create its own subdirectory
function install_file_from_url_zip_subdir {
   local file package subdir url message
   file="$1"
   package="$2"
   subdir="$3"
   url="$4"
   message="$5"
   install_file_from_url "$file" "$package" "$url" > /dev/null || (pushd "$HOME/Downloads/" && mkdir -p   "$subdir" && cd "$subdir" && extract_archive "$HOME/Downloads/$package" && popd)
   file_exists "$file" "$message"
}

# Extract files from an archive
function extract_archive {
   local archive
   archive="$1"
   if echo "$archive" | grep ".zip"; then
      unzip "$archive"
   else
      if echo "$archive" | grep ".tar.gz"; then
         tar xvzf "$archive"
      else
         echo NOT OK archive "$archive" is not a known type
      fi
   fi
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

# Get a git repository and set to track a specific branch (ex origin/master)
function install_git_repo_branch {
   local dir subdir branch url message
   dir="$1"
   subdir="$2"
   branch="$3"
   url="$4"
   message="$5"
   dir_exists "$dir" "$message"
   if check_git_repo_branch "$dir/$subdir" "$branch" "$message"; then
      return 0
   else
      echo NOT OK will get git repo "$message" branch "$branch" from "$url"
      pushd "$dir" > /dev/null
      if [ ! -d "$subdir" ]; then
         git clone "$url" "$subdir"
      fi
      dir_exists "$subdir" "$message"
      cd "$subdir" && git checkout --track $branch
      popd > /dev/null
      check_git_repo_branch "$dir/$subdir" "$branch" "$message"
   fi
}

# Check that a checked out git repository is on the correct branch
function check_git_repo_branch {
   local dir branch message error
   dir="$1"
   branch="$2"
   message="$3"
   error=0
   dir_exists "$dir" "$message"
   pushd "$dir" > /dev/null
      if git branch | grep '*' | grep "$branch"; then
         # TODO could be only a substring match of the branch
         echo OK git repo "$dir" is on branch "$branch"
      else
         branch=`perl -e '$ARGV[0] =~ s{\A origin/}{}xms; print $ARGV[0]' "$branch"`
	 if git branch | grep '*' | grep "$branch"; then
	    # TODO could be only a substring match of the branch
	    echo OK git repo "$dir" is on branch "$branch"
	 else
            git branch
            echo NOT OK git repo "$dir" is not on branch "$branch"
            error=1
         fi
      fi
   popd > /dev/null
   return $error
}

#============================================================================
# commands and packages

function check_version {
   local cmd opt version message
   cmd="$1"
   opt="$2"
   find="$3"
   version="$4"
   message="$5"
   if $cmd $opt | grep "$find" | grep "$version"; then
      echo OK $cmd is correct version [$version]
   else
      echo NOT OK $cmd is not version [$version] `$cmd $opt` your mileage may vary setting this up
      return 1
   fi
   return 0
}

function cmd_exists {
   local cmd message npm
   cmd="$1"
   message="$2"
   if which "$cmd"; then
      echo OK command $cmd exists
   else
      if [ -z "$message" ]; then
         message="sudo apt-get install $cmd"
      fi
      echo NOT OK command $cmd missing [$message]
      return 1
   fi
   return 0
}

function commands_exist {
   local commands error
   commands="$1"
   error=0
   for cmd in $commands
   do
      cmd_exists "$cmd" || error=1
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for commands_exist $commands
   fi
   return $error
}

# Install a single command from a differently named package
function install_command_from {
   local command package
   command="$1"
   package="$2"
   if [ -z "$package" ]; then
      package="$command"
   fi
   cmd_exists "$command" > /dev/null || (echo want to install $command from $package; sudo apt-get install "$package")
   cmd_exists "$command" || return 1
}

# Install a single command but using a list of packages
function install_command_from_packages {
   local command packages
   command="$1"
   packages="$2"
   cmd_exists "$command" > /dev/null || (echo want to install $command from $packages; sudo apt-get install $packages)
   cmd_exists "$command" || return 1
}

# Install a bunch of commands if possible
function install_commands {
   local commands error
   commands="$1"
   error=0
   for cmd in $commands
   do
      if [ ! -z "$cmd" ]; then
         cmd_exists $cmd > /dev/null || (echo want to install $cmd ; sudo apt-get install "$cmd")
         cmd_exists $cmd || error=1
      fi
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for install_commands $commands
   fi
   return $error
}

# Install commands from specific package specified as input list with : separation
# cmd1:pkg2 cmd2:pkg2 ...
function install_commands_from {
   local list cmd_pkg cmd package error
   list="$1"
   error=0
   for cmd_pkg in $list
   do
      # split the cmd:pkg string into vars
      IFS=: read cmd package <<< $cmd_pkg
      install_command_from $cmd $package || error=1
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for install_commands_from $list
   fi
   return $error
}

# Force a command to be installed
function force_install_command_from {
   local command package
   command="$1"
   package="$2"
   if [ -z "$package" ]; then
      package="$command"
   fi
   echo forced to install $command from $package
   sudo apt-get install "$package"
   cmd_exists "$command" || return 1
}

# Force install commands from specific package specified as input list with : separation
# cmd1:pkg2 cmd2:pkg2 ...
function force_install_commands_from {
   local list cmd_pkg cmd package error
   list="$1"
   error=0
   for cmd_pkg in $list
   do
      # split the cmd:pkg string into vars
      IFS=: read cmd package <<< $cmd_pkg
      force_install_command_from $cmd $package || error=1
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for force_install_commands_from $list
   fi
   return $error
}

# Install a package downloaded from a url
function install_command_package_from_url {
   local cmd package url message
   cmd="$1"
   package="$2"
   url="$3"
   message="$4"
   cmd_exists "$cmd" > /dev/null || (echo Try to install $cmd from $package at $url $message; wget --output-document $HOME/Downloads/$package $url && sudo dpkg --install $HOME/Downloads/$package)
   cmd_exists "$cmd" $message || return 1
}

# Check if a server (just a command) is running
function is_server_running {
   local cmd message
   cmd="$1"
   message="$2"
   if ps -ef | grep $cmd | grep -v grep ; then
      echo OK $cmd is running
   else
      echo NOT OK $cmd is not running [$message]
      return 1
   fi
   return 0
}

# Check that a server (just a command) is not running
function server_should_not_be_running {
   local cmd message
   cmd="$1"
   message="$2"
   if ps -ef | grep $cmd | grep -v grep ; then
      echo NOT OK $cmd should not be running [$message]
      return 1
   else
      echo OK $cmd is not running
   fi
   return 0
}

# Check if port is listening like your web server
function is_port_listening {
   local host port message
   host="$1"
   port="$2"
   message="$3"
   if nc localhost 3000 < /dev/null > /dev/null; then
      echo  OK $host:$port is listening
   else
      echo NOT OK $host:$port is not listening [$message]
      return 1
   fi
   return 0
}

# Check that a port is not listening
function port_should_not_be_listening {
   local host port message
   host="$1"
   port="$2"
   message="$3"
   if nc localhost 3000 < /dev/null > /dev/null; then
      echo NOT OK $host:$port should not be listening [$message]
      return 1
   else
      echo  OK $host:$port is not listening
   fi
   return 0
}

# Make http request with wget and optionally show log file on error
function http_request_show {
   local url message log
   url="$1"
   message="$2"
   log="$3"
   echo Send a request to $url [$message]
   if wget --output-document=- "$url" ; then
      echo OK got response to $url
   else
      echo NOT OK no response from $url [$message]
      if [ ! -z "$log" ]; then
         cat "$log"
      fi
   fi
}

#============================================================================
# node/npm/grunt related commands and packages

# Install a command with the node package manager
function install_npm_command_from {
   local command package
   command="$1"
   package="$2"
   if [ -z "$package" ]; then
      package="$command"
   fi
   cmd_exists "$command" > /dev/null || (echo want to install $command from npm $package; sudo npm install "$package")
   cmd_exists "$command" || return 1
}

# Install a bunch of commands with the node package manager
function install_npm_commands_from {
   local list cmd_pkg cmd package error
   list="$1"
   error=0
   for cmd_pkg in $list
   do
      # split the cmd:pkg string into vars
      IFS=: read cmd package <<< $cmd_pkg
      install_npm_command_from $cmd $package || error=1
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for install_npm_commands_from $list
   fi
   return $error
}

# Install a global command with the node package manager
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

# Install a bunch of  global commands with the node package manager
function install_npm_global_commands_from {
   local list cmd_pkg cmd package error
   list="$1"
   error=0
   for cmd_pkg in $list
   do
      # split the cmd:pkg string into vars
      IFS=: read cmd package <<< $cmd_pkg
      install_npm_global_command_from $cmd $package || error=1
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for install_npm_global_commands_from $list
   fi
   return $error
}

# Install a new project template for grunt system
function install_grunt_template_from {
   local template package dir
   template="$1"
   package="$2"
   dir="$HOME/.grunt-init/$template"
   dir_exists "$dir" > /dev/null || (echo want to install grunt template $template from $package; git clone https://github.com/gruntjs/$package "$dir")
   dir_exists "$dir"
}

# Install a bunch of new project template for grunt system
function install_grunt_templates_from {
   local list tmp_pkg template package error
   list="$1"
   error=0
   for tmp_pkg in $list
   do
      # split the template:pkg string into vars
      IFS=: read template package <<< $tmp_pkg
      install_grunt_template_from $template $package || error=1
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for install_grunt_templates_from $list
   fi
   return $error
}

#============================================================================
# perl related setup

# Check that a perl module is available
function perl_module_exists {
   local module message
   module="$1"
   message="$2"
   if perl -M$module -e 'my $ver = eval "\$$ARGV[0]::VERSION"; print "OK perl module $ARGV[0] v$ver is installed\n"' $module > /dev/null; then
      echo OK perl module $module is installed
   else
      echo NOT OK perl module $module is not installed [$message]
      return 1
   fi
   return 0
}

# Check that a specific version perl module is available
function perl_module_version_exists {
   local module version message
   module="$1"
   version="$2"
   message="$3"
   if perl -M$module -e 'my $ver = eval "\$$ARGV[0]::VERSION"; my $msg = "NOT OK perl module $ARGV[0] v$ver is installed, expected v$ARGV[1]\n"; if ($ver ne $ARGV[1]) { print $msg; exit 1; }' $module $version; then
      echo OK perl module $module version $version is installed
   else
      echo NOT OK perl module $module version $version is not installed [$message]
      return 1
   fi
   return 0
}

# Check that a bunch of perl modules are available
function perl_modules_exist {
   local modules error
   modules="$1"
   error=0
   for mod in $modules
   do
      perl_module_exists "$mod" "sudo cpanp install $mod" || error=1
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for perl_modules_exist $modules 
   fi
   return $error
}

# Install as many perl modules as possible
function install_perl_modules {
   local modules error
   modules="$1"
   error=0
   for mod in $modules
   do
      if [ ! -z "$mod" ]; then
         perl_module_exists $mod > /dev/null || (echo want to install perl module $mod ; sudo cpanp install "$mod")
         perl_module_exists $mod || error=1
      fi
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for install_perl_modules $modules 
   fi
   return $error
}

# Force to install a bunch of perl modules
function force_install_perl_modules {
   local modules error
   modules="$1"
   error=0
   for mod in $modules
   do
      if [ ! -z "$mod" ]; then
         echo forced to install perl module $mod
         sudo cpanp install "$mod"
         perl_module_exists $mod || error=1
      fi
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for force_install_perl_modules $modules
   fi
   return $error
}

# Install a specific version of a perl module from a locally downloaded archive
function install_perl_module_version_from_archive {
   local module version location archive message
   module="$1"
   version="$2"
   location="$3"
   archive="$4"
   message="$5"
   if perl_module_version_exists "$module" "$version" "$message"; then
      return 0
   else
      dir_exists "$location" "directory for local archive file"
      file_exists "$location/$archive.tar.gz" "local archive file for $message"
      tar xvzf "$location/$archive.tar.gz" && dir_exists "$archive" "extracted archive not in expected location"
      build_perl_project "$archive"
      perl_module_version_exists "$module" "$version" "$message"
   fi
}

# Install a specific version of a perl module from a locally downloaded archive without tests
function install_perl_module_version_from_archive_no_tests {
   local module version location archive message
   module="$1"
   version="$2"
   location="$3"
   archive="$4"
   message="$5"
   if perl_module_version_exists "$module" "$version" "$message"; then
      return 0
   else
      dir_exists "$location" "directory for local archive file"
      file_exists "$location/$archive.tar.gz" "local archive file for $message"
      tar xvzf "$location/$archive.tar.gz" && dir_exists "$archive" "extracted archive not in expected location"
      build_perl_project_no_tests "$archive"
      perl_module_version_exists "$module" "$version" "$message"
   fi
}

# Install perl project dependencies
function install_perl_project_dependencies {
   local dir error
   dir="$1"
   error=1
   push_dir "$dir" "install perl dependencies for project"
   if [ -f Build.PL ]; then
      perl Build.PL && sudo ./Build installdeps && error=0
   else
      if [ -f Makefile.PL ]; then
         # This will only tell you about missing pre-requisites, not install them
         perl Makefile.PL && error=0
      else
         echo MAYBE NOT OK "$dir" no Build.PL or Makefile.PL found so no dependencies to install
         error=0
      fi
   fi
   popd > /dev/null
   if [ $error == 1 ]; then
      echo NOT OK errors for install_perl_project_dependencies $dir 
   fi
   return $error
}

# Install multiple perl project dependencies
function install_all_perl_project_dependencies {
   local dirs error
   dirs="$1"
   error=0
   for dir in $dirs
   do
      if [ ! -z "$dir" ]; then
         install_perl_project_dependencies "$dir" || error=1
      fi
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for install_all_perl_project_dependencies $dirs 
   fi
   return $error
}

# Do a standard perl project build sequence
function build_perl_project {
   local dir error
   dir="$1"
   error=1
   pushd "$dir" > /dev/null
   echo build perl project in dir `pwd`
   touch before_build.timestamp
   if [ -f Build.PL ]; then
      perl Build.PL && ./Build && ./Build test && ./Build install && error=0
   else
      if [ -f Makefile.PL ]; then
         perl Makefile.PL && make && make test && sudo make install && error=0
      else
         echo MAYBE NOT OK "$dir" no Build.PL or Makefile.PL found so nothing to build
      fi
   fi
   find . -newer before_build.timestamp
   popd > /dev/null
   if [ $error == 1 ]; then
      echo NOT OK errors for build_perl_project $dir 
   fi
   return $error
}

# Build a perl project and install omitting tests, in case failures are temporarily allowed
function build_perl_project_no_tests {
   local dir error
   dir="$1"
   error=1
   pushd "$dir" > /dev/null
   echo Build perl project in dir `pwd`
   touch before_build.timestamp
   echo WARNING: build will skip test phase, may install with failing tests.
   if [ -f Build.PL ]; then
      perl Build.PL && ./Build && sudo ./Build install && error=0
   else
      if [ -f Makefile.PL ]; then
         perl Makefile.PL && make && sudo make install && error=0
      else
         echo MAYBE NOT OK "$dir" no Build.PL or Makefile.PL found so nothing to build
      fi
   fi
   find . -newer before_build.timestamp
   popd > /dev/null
   if [ $error == 1 ]; then
      echo NOT OK errors for build_perl_project_no_tests $dir 
   fi
   return $error
}

# Build as many perl projects as possible
function build_perl_projects {
   local dirs error
   dirs="$1"
   error=0
   for dir in $dirs
   do
      if [ ! -z "$dir" ]; then
         build_perl_project "$dir" || error=1
      fi
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for build_perl_projects $dirs 
   fi
   return $error
}

# Build as many perl projects as possible without running tests
function build_perl_projects_no_tests {
   local dirs error
   dirs="$1"
   error=0
   for dir in $dirs
   do
      if [ ! -z "$dir" ]; then
         build_perl_project_no_tests "$dir" || error=1
      fi
   done
   if [ $error == 1 ]; then
      echo NOT OK errors for build_perl_projects_no_tests $dirs 
   fi
   return $error
}

#============================================================================
# check configuration within files

# exact check for text in file
function file_has_text {
   local file text message
   file="$1"
   text="$2"
   message="$3"
   file_exists "$file" "$message"
   if grep "$text" "$file" > /dev/null; then
      echo OK file has text: "$file" "$text"
   else
      echo NOT OK file missing text: "$file" "$text" [$message]
      echo grep \""$text"\" \""$file"\"
      return 1
   fi
   return 0
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
   else
      echo NOT OK file missing regex: egrep \"$text\" \"$file\" [$message]
      echo egrep \""$text"\" \""$file"\"
      return 1
   fi
   return 0
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
      echo grep \""$text"\" \""$file"\"
   fi
   return 0
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
   else
      echo NOT OK crontab missing command $oommand trying to install [$message]
      (crontab -l; echo "$config" ) | crontab -
      return 1
   fi
   return 0
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
   else
      echo NOT OK apt-key missing $key trying to install [$message]
      wget -q "$url" -O- | sudo apt-key add -
      if sudo apt-key list | grep "$key"; then
         echo OK apt-key installed $key
      else
         echo NOT OK apt-key could not install $key
         return 1
      fi
   fi
   return 0
}

#============================================================================
# mysql related setup

function mysql_connection_check {
   local user password
   user=$1
   password=$2
   echo Checking mysql connection to localhost for user $user
   if mysql -u $user -p$password -e 'SHOW DATABASES; SHOW GRANTS;'; then
      echo OK $user can connect to mysql on localhost
   else
      echo NOT OK $user cannot connect to mysql on localhost
      return 1
   fi
   return 0
}

# Check that a database is reachable on localhost for a user
function mysql_check_for_database {
   local user database password
   database=$1
   user=$2
   # optional password
   password=$2
   echo Check for mysql database $database with user $user
   if mysql -u $user -p$password -e "SELECT schema_name, 'exists' FROM information_schema.schemata WHERE schema_name = '$database';" | grep $database; then
      echo OK $database exists on mysql localhost
   else
      echo NOT OK $database does not exist on mysql localhost for user $user
      return 1
   fi
   return 0
}

# Check for a database and make it if not present
function mysql_make_database_exist {
   local database user
   database=$1
   user=$2
   if mysql_check_for_database $database $user > /dev/null; then
      echo OK $database exists on mysql localhost
   else
      echo NOT OK $database does not exist on mysql localhost will try to create with user $user
      mysql -u $user -p -e "CREATE DATABASE $database"
      mysql_check_for_database $database $user || return 1
   fi
   return 0
}

function mysql_make_test_user_exist_on_database {
   local user password database superuser
   user=$1
   password=$2
   database=$3
   superuser=$4
   if mysql -u $user -p$password -e 'SHOW GRANTS;' | grep $user; then
      echo OK $user exists with grants
   else
      echo NOT OK $user not configured. Will set it up with $superuser mysql account
      # drop and recreate user with no errors
      mysql -u $superuser -D mysql -p <<SQL
      GRANT USAGE ON *.* TO '$user'@'localhost';
      DROP USER '$user'@'localhost';
      CREATE USER '$user'@'localhost' IDENTIFIED BY '$password';
      GRANT ALL ON $database.* TO '$user'@'localhost';
      GRANT SUPER ON *.* TO '$user'@'localhost';
      FLUSH PRIVILEGES;
SQL
     mysql_connection_check $user $password
  fi
}

# check for user account on localhost mysql
#mysql -u root -D mysql -p -e 'SELECT user, host FROM user WHERE user="test_user"' | grep localhost

#============================================================================
# miscellaneous configuration

function has_ssh_keys {
# need to upload ssh public key to github before getting grunt templates
   #file_exists $HOME/.ssh/id_rsa.pub > /dev/null || (ssh-keygen -t rsa)
   #file_exists $HOME/.ssh/id_rsa.pub "ssh keys should exist"
   #mv .ssh/id_rsa* $HOME/bin/cfg/
   file_linked_to $HOME/.ssh/id_rsa.pub $HOME/bin/cfg/id_rsa.pub
   file_linked_to $HOME/.ssh/id_rsa $HOME/bin/cfg/id_rsa
}

