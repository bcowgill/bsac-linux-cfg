#!/bin/bash
# Check configuration to make sure things are ok and make them ok where possible
# cd bin; nvm use
# check-system.sh 2>&1 | tee ~/check.log | egrep 'You|MAYBE|NOT OK' ; alarm.sh
# DEBUG=1 check-system.sh 2>&1 | tee ~/check.log | egrep 'You|MAYBE|NOT OK' ; alarm.sh
# check-system.sh 2>&1 | tee ~/check.log ; alarm.sh
# tail -f ~/check.log | egrep 'You|YOU|MAYBE|BAIL|NOT OK'
# check-system.sh 2>&1 | egrep -A 45 VERSIONS

# Search for 'begin' for start of script

# To set up a new computer you can simply download and unzip anywhere
# wget https://github.com/bcowgill/bsac-linux-cfg/archive/master.zip && unzip master.zip
# cd bsac-linux-cfg-master/bin && PATH=$PATH:. ./cfg/check-system.sh
# start a new shell after first run so aliases and functions will be available

# terminate on first error
set -e
# turn on trace of currently running command if you need it
if [ ! -z "$DEBUG" ]; then
	set -x
fi

# chrome URLs open in case session buddy fails
#http://askubuntu.com/questions/800601/where-is-system-disk-info-stored/801162#801162
#https://www.google.com/intl/en_uk/chrome/browser/welcome.html
#http://www.ubuntu.com/support
#http://cooktopcove.com/2016/03/15/smoked-bacon-weave-wrapped-stuffed-sausage-roll-yes-its-possible/?src=wim_50230&t=syn
#http://download.virtualbox.org/virtualbox/5.1.2/
#http://stackoverflow.com/questions/25978427/installing-nvm-on-ubuntu-14-04
#https://github.com/creationix/nvm
#https://www.npmjs.com/package/karma
#https://github.com/nodejs/LTS#lts_schedule
#https://github.com/adobe-fonts/source-code-pro/

if [ -e $HOME/bin ]; then
	set -o posix
	set > $HOME/bin/check-system.env0.log
	set +o posix
fi

# set FRESH_NPM to reinstall npm packages so they are updated
#FRESH_NPM=1

# set BAIL_OUT to stop after a specific point reached
# search for "BAIL_OUT name" to see where that point is.
#BAIL_OUT=versions
#BAIL_OUT=init
#BAIL_OUT=font
#BAIL_OUT=xfont
#BAIL_OUT=diff
#BAIL_OUT=elixir
#BAIL_OUT=mongo
#BAIL_OUT=install
#BAIL_OUT=node
#BAIL_OUT=screensaver
#BAIL_OUT=perl
#BAIL_OUT=ruby
#BAIL_OUT=files
#BAIL_OUT=npm
#BAIL_OUT=dropbox
#BAIL_OUT=maven
#BAIL_OUT=commands
#BAIL_OUT=crontab
#BAIL_OUT=editors
#BAIL_OUT=custom
#BAIL_OUT=repos
#BAIL_OUT=docker
#BAIL_OUT=vpn
#BAIL_OUT=php
#BAIL_OUT=

if [ ! -z $1 ]; then
	BAIL_OUT="$1"
fi

if which lib-check-system.sh; then
	source `which lib-check-system.sh`
else
	echo "NOT OK cannot find lib-check-system.sh"
	exit 1
fi

function BAIL_OUT {
	local stage
	stage=$1
	echo "BAIL_OUT? $stage"
	if [ "x$BAIL_OUT" == "x$stage" ]; then
		NOT_OK "BAIL_OUT=$BAIL_OUT is set, stopping"
		exit 44
	fi
}

# set_env can only contain $HOME and other generally available values
function set_env {

AUSER=$USER
MYNAME="Brent S.A. Cowgill"
COMPANY=
EMAIL=
[ -e ~/.COMPANY ] && source ~/.COMPANY
if [ -z "$EMAIL" ]; then
	echo You need to provide your email address in function set_env
	echo You can define it as EMAIL= in ~/.COMPANY file along with COMPANY=
	exit 1
fi
if which sw_vers > /dev/null 2>&1 ; then
	MACOS=1
fi
if [[ $OSTYPE == darwin* ]]; then
	MACOS=1
fi
UBUNTU=trusty
LSB_RELEASE=`get-release.sh`
ULIMITFILES=1024
#ULIMITFILES=8096
DOWNLOAD=$HOME/Downloads/check-system
INI_DIR=check-iniline

MOUNT_DATA=""
BIG_DATA="/data"
USE_KDE=1
USE_JAVA=""
SVN_PKG=""
GRADLE_PKG=""
MVN_PKG=""
GITSVN_PKG=""
USE_SCHEMACRAWLER=""
USE_POSTGRES=""
USE_MYSQL=""
USE_REDIS=""
USE_MONGO=""
USE_PIDGIN=""
CUSTOM_PKG=""

USE_ECLIPSE=""

USE_I3=1
I3WM_CMD=i3
I3BLOCKS=i3blocks
#I3WM_PKG="i3 i3status i3lock $I3BLOCKS dmenu:suckless-tools dunst xbacklight xdotool xmousepos:xautomation feh gs:ghostscript"

CHARLES_PKG=charles-proxy
CHARLES_CMD="charles"
CHARLES_LICENSE="UNREGISTERED:xxxxxxxxxx"

SKYPE_CMD=skypeforlinux
SKYPE_PKG="skypeforlinux-64.deb"
SKYPE_URL=https://go.skype.com/$SKYPE_PKG

SLACK_PKG="slack-desktop-2.1.2-amd64.deb"
SLACK_DEPS="/usr/share/doc/libindicator7/copyright:libindicator7 /usr/share/doc/libappindicator1/copyright:libappindicator1"
SLACK_URL="https://downloads.slack-edge.com/linux_releases"
SLACK_CMD="slack"

KARABINER_CMD=Karabiner-Elements.app
KARABINER_PKG=Karabiner-Elements-11.1.0.dmg
KARABINER_URL=https://pqrs.org/osx/karabiner/files/$KARABINER_PKG

# iTerm 2.app space is a problem so we create a symlink
ITERM_CMD="iTerm2.app"
ITERM_PKG=iTerm2-3_1_2.zip
ITERM_URL=https://iterm2.com/downloads/stable/$ITERM_PKG

# http://download.virtualbox.org/virtualbox/5.0.14/virtualbox-5.0_5.0.14-105127~Ubuntu~trusty_amd64.deb
VIRTUALBOX_CMD="VirtualBox"
VIRTUALBOX_CMDS="dkms $VIRTUALBOX_CMD"
VIRTUALBOX_VER=5.1
VIRTUALBOX_PKG="unar gksu dkms"
VIRTUALBOX_REL="raring"
#VIRTUALBOX_PKG="$VIRTUALBOX_PKG $VIRTUALBOX_CMD:virtualbox-$VIRTUALBOX_VER"

MONO_PKG=mono-complete
MONO_CMD=mono

PHP_PKG=php5-cli
PHP_CMD=php

SVN_CMD=svn
SVN_VER="1.8.5"
#SVN_PKG="subversion libsvn-java"

GITSVN_CMD=/usr/lib/git-core/git-svn
#GITSVN_PKG="libsvn-perl git-svn"

GIT_PKG=git
GIT_VER="2.1.4"
GIT_PKG_MAKE="libcurl4-gnutls-dev libexpat1-dev gettext libz-dev libssl-dev build-essential"
# these must be configured in set_derived_env
#GIT_PKG_AFTER="/usr/share/doc-base/git-tools:git-doc /usr/lib/git-core/git-gui:git-gui gitk tig $GITSVN_PKG"
#GIT_TAR=git-$GIT_VER
#GIT_URL=https://git-core.googlecode.com/files/$GIT_TAR.tar.gz

MVN_CMD="mvn"
MVN_PKG="mvn:maven"
MVN_VER="3.0.4"

GRADLE_CMD="gradle"
GRADLE_PKG="gradle"

JAVA_VER=java-7-openjdk-amd64
JAVA_JVM=/usr/lib/jvm
JAVA_CMD=java

# http://sourcegear.com/diffmerge/downloads.php
DIFFMERGE_CMD=diffmerge
DIFFMERGE_PKG=diffmerge_4.2.0.697.stable_amd64.deb
DIFFMERGE_URL=http://download-us.sourcegear.com/DiffMerge/4.2.0/$DIFFMERGE_PKG

#DIFFMERGE_CMD=diffmerge.sh
#DIFFMERGE_PKG=DiffMerge.4.2.1.1013.intel.stable.dmg
#DIFFMERGE_URL=http://download.sourcegear.com/DiffMerge/4.2.1/$DIFFMERGE_PKG

# Perforce p4merge tool
# HELIX P4MERGE: VISUAL MERGE TOOL
P4MERGE_VER=p4v-2015.2.1315639
P4MERGE_URL="http://www.perforce.com/downloads/Perforce/20-User#10"
P4MERGE_PKG=p4v.tgz
#P4MERGE_CMD="$DOWNLOAD/$P4MERGE_VER/bin/p4merge"

RUBY_PKG="ruby-dev ruby rake"
RUBY_CMD=ruby
#RUBY_GEMS="sass:3.4.2 compass compass-validator foundation"
RUBY_GEMS="rake watchr sass compass compass-validator foundation"
RUBY_SASS_COMMANDS="ruby gem rake sass compass foundation"

POSTGRES_PKG="psql:postgresql-client-9.3 pfm pgadmin3:pgadmin3-data pgadmin3"
POSTGRES_NODE_PKG="node-pg"
POSTGRES_NPM_PKG="node-dbi"

REDIS_PKG="redis-cli:redis-server"
REDIS_CMDS="redis-cli redis-server"

# BlisMedia Druid reporting requirements
DRUID_PKG="apache2"
DRUID_PERL_MODULES="CGI::Fast DBI DBD::mysql JSON"
DRUID_PACKAGES="/usr/lib/apache2/modules/mod_fcgid.so:libapache2-mod-fcgid"

# Mongo DB install
MONGO_PKG="mongod:mongodb-org"
MONGO_CMD="mongod"
MONGO_CMDS="$MONGO_CMD mongo mongodump mongoexport mongofiles mongoimport"
MONGO_KEY=0C49F3730359A14518585931BC711F9BA15703C6
MONGO_KEYCHK=A15703C6
MONGO_KEYSVR="hkp://keyserver.ubuntu.com:80"

# Robomongo == Robo 3T - GUI for mongo db administration
ROBO3T_VER=1.1.1
ROBO3T_CHK=c93c6b0
ROBO3T_CMD=robo3t.sh
ROBO3T_URL=https://download.robomongo.org
#ROBO3T_URL=https://download.robomongo.org/$ROBO3T_VER/linux/$ROBO3T_ARCHIVE.tar.gz
#ROBO3T_ARCHIVE=robo3t-$ROBO3T_VER-linux-x86_64-$ROBO3T_CHK
#ROBO3T_URL=$ROBO3T_URL/$ROBO3T_VER/linux/$ROBO3T_ARCHIVE.tar.gz
#ROBO3T_DIR=$ROBO3T_ARCHIVE
#ROBO3T_EXTRACTED_DIR=$DOWNLOAD/$ROBO3T_DIR
#ROBO3T_EXTRACTED=$ROBO3T_EXTRACTED_DIR/bin/robo3t

PIDGIN_CMD="pidgin" # "pidgin-guifications pidgin-themes pidgin-plugin-pack"
PIDGIN_SKYPE="/usr/lib/purple-2/libskype.so"
PIDGIN_SKYPE_PKG="$PIDGIN_SKYPE:pidgin-skype"
PIDGIN_SRC="pidgin-2.10.11"
PIDGIN_ZIP="$PIDGIN_SRC.tar.bz2"

VPN_PKG="openvpn brctl:bridge-utils"
VPN_CONFIG=/etc/network/interfaces.d/bridge-vpn
VPN_CONN=/etc/NetworkManager/system-connections/WorkshareVPN

# epub, mobi book reader
EBOOK_READER="calibre"

# simple paint program
PINTA_PKG="pinta"
PINTA_CMD="pinta"

if [ -z $MACOS ]; then # TODO MACOS PKGS
	PERL_PKG="cpanm:cpanminus /usr/share/doc/perl/README.gz:perl-doc"
	TEMPERATURE_PKG="sensors:lm-sensors hddtemp"
else
	PERL_PKG="cpanm:cpanminus"
fi

# TODO install n versions from here
N_VER=2.1.7
# MUSTDO restore version numbers but must fix lib- code so it works
#N_VERS="lts latest stable"
N_VERS="lts latest stable 0.10.0 4.0.0 5.0.0 6.0.0 7.0.0 8.11.1 9.10.1 10.0.0"
N_IO_VERS="1.0.0  2.0.0  3.0.0"
N_CMD=n

NVM_VER="v0.39.1"
#https://github.com/nvm-sh/nvm
#NVM_URL="https://raw.githubusercontent.com/creationix/nvm/$NVM_VER/install.sh"
NVM_DIR="$HOME/.nvm"
NVM_VER_DIR="$NVM_DIR/versions/node"
NVM_CMD="$NVM_DIR/nvm.sh"

#NVM_LTS_VER="v4.4.7"
#NVM_LATEST_VER="v6.3.1"
# nvm ls-remote --lts | tail -1
# nvm ls-remote | tail -1
# NVM_LTS_VER="v6.11.4"
# NVM_LATEST_VER="v8.6.0"
NVM_LTS_VER="v16.15.0"
NVM_LATEST_VER="v18.2.0"

PNPM_VER="1.41.23"
PNPM_CMD=pnpm
PNPM_NPM_PKG=pnpm

NODE_VER="v0.12.9"
#NODE="nodejs nodejs-legacy npm grunt grunt-init uglifyjs phantomjs $POSTGRES_NODE_PKG"
NODE_CMD="nodejs"

# for hosted front end static assets: html, js, css
SURGE_NPM_PKG=surge

# Typescript editor support
# https://github.com/Microsoft/TypeScript/wiki/TypeScript-Editor-Support
# alm a node/chrome/typescript IDE for typescript

#https://www.erlang-solutions.com/resources/download.html
#ERLANG_PKG=erlang-solutions_1.0_all.deb
ERL_OBSERVER_PKG="/usr/lib/x86_64-linux-gnu/libwx_baseu-2.8.so.0:libwxbase2.8-0 /usr/lib/x86_64-linux-gnu/libwx_gtk2u_core-2.8.so.0:libwxgtk2.8-0"
ERLANG_PKG=esl-erlang_19.2.3-1-ubuntu-precise_amd64.deb
ERLANG_CMD="erl"
ERLANG_URL=https://packages.erlang-solutions.com/$ERLANG_PKG
#ELIXIR_DEB=elixir_1.4.1-1-ubuntu-precise_all.deb
ELIXIR_DEB=elixir_1.3.4-1-ubuntu-precise_amd64.deb
ELIXIR_URL=https://packages.erlang-solutions.com/$ELIXIR_DEB
ELIXIR_PKG="erl:esl-erlang elixir $ERL_OBSERVER_PKG"
ELIXIR_CMD="elixir"
ELIXIR_CMDS="elixir elixirc iex mix erl erlc"

# TODO notifications
# tried installing kubuntu-notification-helper in an effort to get
# the osd notifications to appear like they are at work.
# another option is pidgin
#RE=`apt-cache search notifications | perl -ne 's{\A ([\-\.\w]+) .+ \z}{$1}xmsg; push(@o, $_); sub END {print join("|", @o)}'`
#git grep -E "\b($RE)\b" cfg/pkg-list.txt cfg/workshare/pkg-list.txt

INSTALL_GRUNT_TEMPLATES="basic:grunt-init-gruntfile node:grunt-init-node jquery:grunt-init-jquery.git"

# webcollage screensaver pulls from the internet so not safe for work
KSCREENSAVER_PKG="
	kscreensaver
	ktux
	kcometen4
"
SCREENSAVER_PKG="
	workrave
	screensaver-default-images
	wmmatrix
	xscreensaver
	xbacklight
	xscreensaver-data-extra
	xscreensaver-gl-extra
	xscreensaver-screensaver-bsod
	unicode-screensaver
	xscreensaver-screensaver-webcollage
	xfishtank
	xdaliclock
	fortune
	cmatrix-xfont
"
# gnome ubuntustudio-screensaver

DROPBOX_URL="https://www.dropbox.com/download?plat=lnx.x86_64"

EMACS_VER=24.4
EMACS_BASE=emacs24

#https://atom.io/download/deb
#https://atom-installer.github.com/v1.9.9/atom-amd64.deb?s=1471476867&ext=.deb
#ATOM_VER=v1.10.0-beta7
#ATOM_VER=v1.21.0-beta2
ATOM_VER=1.20.1
ATOM_PKG=atom-amd64.deb
ATOM_APM=apm
ATOM_CMD=atom
ATOM_APP=$ATOM_CMD
ATOM_URL=https://atom.io/download/deb
#ATOM_URL=https://atom-installer.github.com
# Atom packages vetted 2021-05 on Mac
ATOM_APM_PKG="
	autosave
	editorconfig
	file-icons
	tree-view-auto-fold
	tree-view-auto-reveal
	tree-view-copy-relative-path
	directory-color
	zen-plus
	zentabs
	tab-foldername-index
	color-tabs
	color-tabs-regex
	cursor-index
	line-number-color
	highlight-selected
	pigments
	Chromo-Color-Previews
	atom-json-color
	atom-color-the-tag-name
	color-indent
	color-whitespace
	nms-color-bracket
	Sublime-Style-Column-Selection
	copy-path
	duplicate-line-or-selection
	toggle-quotes
	atom-wrap-in-tag
	autoclose-html
	autoclose
	autocomplete
	autocomplete-modules
	autocomplete-date
	autocomplete-ramda
	autocomplete-math
	autocomplete-json
	gherkin-autocomplete
	css-color-name
	atom-change-case-menu
	string-case
	case-keep-replace
	color-picker
	var-that-color
	atom-name-that-color
	sort-lines
	sort-words
	sort-css
	docblockr
	atom-js-snippets
	css-snippets
	es6-snippets
	osd-atom-snippets
	local-history
	related
	atom-beautify
	activate-power-mode
	hyperclick
	atom-ternjs
"
# pigments - when activated takes a while to scan the project.
# autosave and local-history messes with git checkouts and automatic test runs and marks some changed files as changed again after saving them so disabled..

# previously used packages
#	language-javascript-jsx
#	prettier-atom
#	atom-transpose
#	project-manager
#	set-syntax
#	emmet
#	emmet-jsx-css-modules
#	es6-javascript
#	linter-eslint
#	language-javascript-jsx
#	language-babel
# MUSTDO investigate these package failures
#	dracula-theme
#	json-level-color - not coloring by level
#	webbox-color - fails to install
#	an-color-picker - real color picker from any screen
#	color-tabs-byproject - couldn't configure to my liking
#	color-dict - not so useful
#	file-path-picker - not working on mac
#	js-hyperclick - needs babel? couldn't configure
#ATOM_URL=$ATOM_URL/v$ATOM_VER/$ATOM_PKG

# Atom MACOS
#https://github.com/atom/atom/releases/download/v1.21.0/atom-mac.zip


# MUSTDO MACOS try this...
# Mobile Phone screen mirroring win/mac/linux
# https://medium.com/mac-os-x/how-to-mirror-your-smart-phone-screen-in-mac-os-x-2daf018aae4d
# https://www.vysor.io/

# https://download.sublimetext.com/sublime-text_build-3114_amd64.deb
SUBLIME_PKG=sublime-text_build-3114_amd64.deb
SUBLIME_CFG=.config/sublime-text-3
SUBLIME_CMD=subl
SUBLIME_URL=http://download.sublimetext.com
#SUBLIME_URL=$SUBLIME_URL/$SUBLIME_PKG

#WebStorm 2016.3.2
#Build #WS-163.9166.30
#Licensed to Workshare LTD / Brent Cowgill
#You have perpetual fallback license for this version
#Subscription is active until January 27, 2018
#JRE: 1.8.0_112-release-b343 amd64
#JVM: OpenJDK 64-Bit Server VM by JetBrains s.r.o

#me@akston:~/bin (dell-7510 *% u+2)$ tar tvzf ~/Downloads/WebStorm-2016.2.tar.gz  | head
#-rw-r--r-- 0/0            6878 2016-07-09 10:44 WebStorm-162.1121.31/bin/idea.properties
# https://www.jetbrains.com/webstorm/download/#section=linux-version
WEBSTORM_CMD=wstorm
WEBSTORM_ARCHIVE=WebStorm-2016.3.2
WEBSTORM_CONFIG=WebStorm2016.3
WEBSTORM_DIR=WebStorm-163.9166.30
WEBSTORM_URL=http://download.jetbrains.com/webstorm
#WEBSTORM_EXTRACTED_DIR="$DOWNLOAD/$WEBSTORM_DIR"
#WEBSTORM_EXTRACTED="$WEBSTORM_EXTRACTED_DIR/bin/webstorm.sh"
#WEBSTORM_URL=$WEBSTORM_URL/$WEBSTORM_ARCHIVE.tar.gz

VSLICK_CMD=vs
VSLICK_ARCHIVE=se_20000300_linux64
VSLICK_URL="http://www.slickedit.com/dl/dl.php?type=trial&platform=linux64&product=se&pname=SlickEdit%20for%20Linux"
VSLICK_EXTRACTED_DIR="$DOWNLOAD/$VSLICK_ARCHIVE"
VSLICK_EXTRACTED="$VSLICK_EXTRACTED_DIR/vsinst"

if [ -z $MACOS ]; then  # TODO MACOS PKGS
	PULSEAUDIO_PKG="pavucontrol pavumeter speaker-test"
	KEYBOARD_PKG="showkey evtest"
fi

GITHUB_URL=https://github.com/bcowgill
MY_REPOS="
	react-boilerplate
	functionaljs
	mock-browser
	ramda
	babelon
	exceptionaljs
	simple-design
	node-play
	grunt-test
	knockout-test
	jshint-test
	jsclass-test
	foundation-test
	perljs
	open-layers
	brick-xtag
	d3-family-tree
	FT-Hackday-2012
	QUnitChainer
	BigScreen
	Qucumber
"

DOCKER_PKG=docker-engine
DOCKER_PRE="apt-transport-https ca-certificates linux-image-extra-$(uname -r) linux-image-extra-virtual"
DOCKER_CMD=docker
DOCKER_GRP=docker
DOCKER_KEY=58118E89F3A912897C070ADBF76221572C52609D
DOCKER_KEYCHK=2C52609D
DOCKER_KEYSVR=hkp://ha.pool.sks-keyservers.net:80

#HEREIAM PKG

# open pages to find latest versions of files to download
# browser.sh https://www.slickedit.com/trial/slickedit
# browser.sh http://www.jetbrains.com/webstorm/download/#section=linux-version
# browser.sh "https://www.sublimetext.com/3"
# browser.sh "http://download.virtualbox.org/virtualbox/"
# browser.sh "http://www.sourcegear.com/diffmerge/downloaded.php"
# browser.sh "https://www.perforce.com/downloads/register/helix?return_url=http://www.perforce.com/downloads/perforce/r15.2/bin.linux26x86_64/p4v.tgz&platform_family=LINUX&platform=Linux%20%28x64%29&version=2015.2/1315639&product_selected=Perforce&edition_selected=helix&product_name=Helix%20P4Merge:%20:%20Visual%20Merge%20Tool&prod_num=10"
# browser.sh "https://github.com/creationix/nvm"

THUNDER=""
#THUNDER=ryu9c8b3.default

# Chrome download page
GOOGLE_CHROME_URL="http://www.google.com/chrome?platform=linux"
GOOGLE_CHROME=google-chrome
GOOGLE_CHROME_PKG=google-chrome-stable_current_amd64.deb

# Chrome Dev Tools Dark Theme manual setup
# https://github.com/mauricecruz/chrome-devtools-zerodarkmatrix-theme
# Install chrome extension, chrome://flags to enable dev tools experiments and restart
# Then turn on allow custom UI in dev tools settings and restart again

FLASH_ARCHIVE="flashplayer_11_plugin_debug.i386"
FLASH_EXTRACTED_DIR="$DOWNLOAD/$FLASH_ARCHIVE"
FLASH_EXTRACTED="$FLASH_EXTRACTED_DIR/libflashplayer.so"
FLASH_URL="http://fpdownload.macromedia.com/pub/flashplayer/updaters/11/$FLASH_ARCHIVE.tar.gz"
CHROME_PLUGIN="/usr/lib/chromium-browser/plugins"

# TODO Brave Brower setup/install attempted
# https://brave.com/linux/
# sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
# echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
# sudo apt update -- error no public key for brave.
# sudo apt install brave-browser

# Mobile phone mounting tools
MTP_PKG="mtpfs mtp-files:mtp-tools jmtpfs"

# meld - caskroom/cask
HOMEBREW_NO_AUTO_UPDATE=1
BREW_TAPS="
	caskroom/cask
	cloudfoundry/tap
"

if [ "$HOSTNAME" == "akston" ]; then
	LINK_DOWNLOADS=1
	GIT_VER=1.9.1
	#GIT_VER=2.30.2
	NODE_VER=v0.10.25
	USE_KDE=""
	#I3WM_PKG=""
	I3BLOCKS=""
	CHARLES_PKG=""
	#SKYPE_PKG=""
	SLACK_PKG=""
	VIRTUALBOX_PKG=""
	MONO_PKG=""
	#DIFFMERGE_PKG=""
	#P4MERGE_PKG=""
	RUBY_PKG=""
	VPN_PKG=""
	#EBOOK_READER=""
	DRUID_PKG=""
	USE_REDIS=1
	USE_MONGO=1
	MVN_PKG=""
	GRADLE_PKG=""

	DIGIKAM_PKG="digikam /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstasf.so:gstreamer1.0-plugins-ugly /usr/lib/x86_64-linux-gnu/gstreamer-1.0/libgstlibav.so:gstreamer1.0-libav"
	# ttf-ancient-fonts - Symbola used for emacs emoji
	# sox - sound player mp3 format installed
	CUSTOM_PKG="
		gnucash
		audacity
		oggconvert
		winff-qt
		avconv
		$DIGIKAM_PKG
		fswebcam
		samba
		mount.cifs:cifs-utils
		firefox
		/usr/share/doc/fonts-lyx/copyright:fonts-lyx
		/usr/share/fonts/truetype/ttf-ancient-scripts/Symbola605.ttf:ttf-ancient-fonts
		cmus
		sox /usr/share/doc/libsox-fmt-all/copyright:libsox-fmt-all
		shutter
		cowsay
		gimp
		dia
	"
	UNINSTALL_PKGS="
		maven
		gradle
	"
	UNINSTALL_NPM_GLOBAL_PKGS=""
	#NODE_PKG=""
	#SUBLIME_PKG=""
	SUBLIME_CFG=""
	WEBSTORM_ARCHIVE=WebStorm-2016.3.1
	WEBSTORM_CONFIG=WebStorm2016.3.1
	WEBSTORM_DIR=WebStorm-163.7743.51

	#VSLICK_ARCHIVE=""
	EMACS_VER=24.3

	# HEREIAM CFG
fi # akston linux

if [ "$HOSTNAME" == "156131225" ]; then
	COMPANY=wipro
fi
if [ "$HOSTNAME" == "L-156131225-BrentCowgill.local" ]; then
	COMPANY=wipro
fi
if [ "$HOSTNAME" == "L-156131225.local" ]; then
	COMPANY=wipro
fi
if [ "$COMPANY" == "wipro" ]; then
	# Change settings for wipro MACOS workstation
	EMAIL=brent.cowgill@wipro.com
	BIG_DATA=
	MACOS=1
	UBUNTU=11.6.5
	GIT_VER=2.36.1
	# GIT_PKG_AFTER=""
	USE_I3=""
	USE_KDE=""
	USE_JAVA=1
	SKYPE_PKG=""
	SLACK_PKG=""
	CHARLES_PKG=""
	VIRTUALBOX_PKG=""
	DIFFMERGE_CMD=diffmerge.sh
	DIFFMERGE_PKG=DiffMerge.4.2.1.1013.intel.stable.dmg
	DIFFMERGE_URL=http://download.sourcegear.com/DiffMerge/4.2.1/$DIFFMERGE_PKG
	P4MERGE_PKG="" # TODO
	DRUID_PKG=""
	# http://www.oracle.com/technetwork/java/javase/downloads/index.html
	# https://download.oracle.com/java/18/latest/jdk-18_macos-x64_bin.dmg
	JAVA_URL=http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
	JAVA_VER=jdk-18.0.1.1.jdk
	JAVA_PKG_VER=jdk-18_macos-x64_bin
	JAVA_PKG=$JAVA_PKG_VER.dmg
	JAVA_JVM=/Library/Java/JavaVirtualMachines/$JAVA_VER/Contents/Home
	#JAVA_HOME=$JAVA_JVM
	JAVA_JRE=$JAVA_JVM/bin/java
	MVN_PKG="mvn:maven"
	MVN_VER="3.8.5"
	GRADLE_PKG="gradle"
	NODE_CMD=/usr/local/bin/node
	N_VER=v8.2.0
	N_VERS="lts latest stable 8.12.0 11.0.0"
	# npm doesn't work with latest/stable version of node at this time
	# NODE_VER="v16.15.0"
	NODE_VER="v11.0.0"
	NODE_BREW="node@8"
	NODE_MOD=/usr/local/Cellar/node@8/8.12.0/lib/node_modules
	NVM_VER="v0.39.1"
	MONO_PKG=""
	PHP_PKG=""
	RUBY_PKG="ruby-build ruby rake"
	RUBY_GEMS="rake watchr"
	RUBY_SASS_COMMANDS="ruby gem rake"
	ATOM_APP=Atom.app
	# MUSTDO re-enable this once apm fixed
	ATOM_APM=""
	ATOM_VER="1.60.0"
	ATOM_PKG=atom-mac.zip
	ATOM_URL=https://github.com/atom/atom/releases/download
	PINTA_PKG=""
	ELIXIR_PKG=""
	DOCKER_PKG=""
	SUBLIME_PKG=""
	EMACS_BASE=""
	VPN_PKG=""
	EBOOK_READER=""
	SCREENSAVER_PKG=""
	SURGE_NPM_PKG=""
	WEBSTORM_ARCHIVE=""
	VSLICK_ARCHIVE=""
	MY_REPOS="perljs"
	# brew install --cask keycastr # show keys on screen as you type them...
	# ranger is a vi style file manager -- used by qutebrowser
	CUSTOM_PKG="
		yarn
		/usr/local/Cellar/lzo/2.10/lib/liblzo2.dylib:lzo
		editorconfig
		cf:cf-cli
		groovy
		ranger
		/usr/local/Cellar/shared-mime-info/2.2/README.md:shared-mime-info
	"
fi # wipro MACOS

if [ "$HOSTNAME" == "brent-Aspire-VN7-591G" ]; then
	# Change settings for clearbooks linux workstation
	AUSER=brent
	EMAIL=brent@clearbooks.co.uk
	COMPANY=clearbooks
	UBUNTU=sarah
	ULIMITFILES=1024
	GIT_VER=2.7.4
	P4MERGE_VER=p4v-2017.1.1491634
	EMACS_VER=24.5
	NVM_VER=""
	N_VER="v2.1.7"
	NODE_VER="v4.2.6"
	PHP_PKG=php7.0-cli
	MY_REPOS=""
	USE_KDE=""
	USE_JAVA=""
	SVN_PKG=""
	MVN_PKG=""
	GRADLE_PKG=""
	GITSVN_PKG=""
	USE_SCHEMACRAWLER=""
	USE_POSTGRES=""
	USE_MYSQL=""
	USE_PIDGIN=""
	CUSTOM_PKG="mysqldump:mysql-client-5.7 mysql-workbench"
	USE_ECLIPSE=""
	#I3WM_PKG=""
	I3BLOCKS=""
	CHARLES_PKG=""
	SKYPE_PKG=""
	SLACK_PKG=""
	VIRTUALBOX_PKG=""
	MONO_PKG=""
	#GIT_PKG=""
	#DIFFMERGE_PKG=""
	#P4MERGE_PKG=""
	RUBY_PKG=""
	#POSTGRES_PKG=""
	#POSTGRES_NODE_PKG=""
	#POSTGRES_NPM_PKG=""
	SURGE_NPM_PKG=""
	DRUID_PKG=""
	PIDGIN_SKYPE_PKG=""
	VPN_PKG=""
	PINTA_PKG=""
	#PERL_PKG=""
	#TEMPERATURE_PKG=""
	#NODE_PKG=""
	#NODE_CUSTOM_PKG=""
	#NPM_GLOBAL_PKG=""
	ERL_OBSERVER_PKG=""
	ERLANG_PKG=""
	ELIXIR_PKG=""
	#KSCREENSAVER_PKG=""
	#SCREENSAVER_PKG=""
	#EMACS_BASE=""
	ATOM_PKG=""
	ATOM_APM_PKG=""
	SUBLIME_PKG=""
	WEBSTORM_ARCHIVE=""
	VSLICK_ARCHIVE=""
	#PULSEAUDIO_PKG=""
	#KEYBOARD_PKG=""
	#DOCKER_PKG=""
	GOOGLE_CHROME_PKG=""
	#FLASH_ARCHIVE=""
	SC_PRO_ARCHIVE=""
fi # clearbooks

if [ "$HOSTNAME" == "worksharexps-XPS-15-9530" ]; then
	# Change settings for workshare linux laptop
	AUSER=bcowgill
	EMAIL=brent.cowgill@workshare.com
	COMPANY=workshare
	UBUNTU=vivid
	ULIMITFILES=1024
	BIG_DATA="/data"
	VPN_PKG=""
	JAVA_VER=java-8-openjdk-amd64
	# set FRESH_NPM=1 once if you update NODE_VER
	NODE_VER="v6.9.2"
	NODE_CMD=node
	NPM_GLOBAL_PKG=`echo $NPM_GLOBAL_PKG | perl -pne 's{\s+}{\n}xmsg' | egrep -v 'karma|babel'`
	SURGE_NPM_PKG=""
	VIRTUALBOX_REL=$(get-release.sh)
	USE_KDE=""
	CHARLES_PKG=""
	SKYPE_PKG=""
	RUBY_GEMS=""
	RUBY_SASS_COMMANDS=""
	DRUID_PKG=""

	GOOGLE_CHROME_PKG=""
	VSLICK_ARCHIVE=""
	SUBLIME_CFG=""
	PINTA_PKG=""
fi # workshare

if [ "$HOSTNAME" == "raspberrypi" ]; then
	echo RASPBERRYPI
	# Change settings for the raspberry pi

	UBUNTU="/etc/rpi-issue: Raspberry Pi reference 2015-02-16 (armhf)"
	UBUNTU="wheezy"
	ULIMITFILES=1024
	GIT_VER="1.7.10.4"
	JAVA_VER=jdk-8-oracle-arm-vfp-hflt
	BIG_DATA=""
	COMPANY=raspberrypi
	USE_I3=""
	USE_KDE=""
	I3WM_PKG=""
	CHARLES_PKG=""
	SKYPE_PKG=""
	SLACK_PKG=""
	VIRTUALBOX_PKG=""
	MONO_PKG=""
	DIFFMERGE_PKG=""
	P4MERGE_PKG=""
	ERL_OBSERVER_PKG=""
	ERLANG_PKG=""
	ELIXIR_PKG=""
	PHP_PKG=""
	RUBY_GEMS="sass foundation"
	RUBY_SASS_COMMANDS="ruby gem $RUBY_GEMS"
	USE_PIDGIN=""
	VPN_PKG=""
	EBOOK_READER=""
	DRUID_PKG=""
	CUSTOM_PKG="
		vim
		reptyr
		locate
		zip
		cmatrix
		chromium
		gnash
		/usr/lib/gnash/libgnashplugin.so:browser-plugin-gnash
		screen
		gpm
		fbcat
		convert:imagemagick
		elinks
		lynx
		links
		cacaview:caca-utils
		pip:python-pip
		mc
		cmus
		/usr/lib/cmus/ip/ffmpeg.so:cmus-plugin-ffmpeg
		mplayer
		cpanm:cpanminus
		perldoc:perl-doc
		perltidy
		adjtimex
		audacity
		meld
		htop
		ncdu
		figlet
		banner:sysvbanner
		cowsay
		linuxlogo
	"
	UNINSTALL_PKGS="
		tightvncserver
		gimp
	"
	UNINSTALL_NPM_GLOBAL_PKGS="
		jscs
		yo
	"
	NODE_VER="v0.6.19"
	NODE_CMD="nodejs"
	NODE2_PKG="no"
	NODE_CUSTOM_PKG="no"
	N_VERS="latest"
	SURGE_NPM_PKG=""
	SCREENSAVER_PKG=""
	DROPBOX_URL=""
	SUBLIME_PKG=""
	SUBLIME_CFG=""
	WEBSTORM_ARCHIVE=""
	VSLICK_ARCHIVE=""
	MY_REPOS=""

	GOOGLE_CHROME_PKG=""
	FLASH_URL=""
	DOCKER_PKG=""
	MTP_PKG=""
	EMACS_BASE=""
	PINTA_PKG=""
fi # raspberrypi

}
set_env

function set_node_env {
echo ===================
NODE_CMDS="$NODE_CMD npm"
NODE_LIB=/usr/lib/$NODE_CMD
NPM_LIB=/usr/local/lib/node_modules
NODE_MOD=${NODE_MOD:-/usr/lib/node_modules}

if [ ! -e "$NODE_LIB" ]; then
	NODE_LIB=/usr/local/bin/$NODE_CMD
fi
if [ ! -d "$NODE_MOD" ]; then
	NODE_MOD=/usr/local/lib/node_modules
fi

if [ -z $MACOS ]; then
NODE_PKG="
	$NODE_CMDS
	node:nodejs-legacy
	/usr/share/doc/node-inherits/copyright:node-inherits
"
if [ "x$NODE2_PKG" == "xno" ]; then
	NODE2_PKG=
else
	NODE2_PKG="
		/usr/share/doc/node-debug/copyright:node-debug
		$NODE_LIB/glob.js:node-glob
		$NODE_LIB/mkdirp/index.js:node-mkdirp
		$NODE_LIB/eyes.js:node-eyes
		$NODE_LIB/rimraf/index.js:node-rimraf
	"
fi
if [ "x$NODE_CUSTOM_PKG" == "xno" ]; then
	NODE_CUSTOM_PKG=
else
	NODE_CUSTOM_PKG="
		$NODE_LIB/abbrev.js:node-abbrev
		$NODE_LIB/async.js:node-async
		$NODE_LIB/base64id.js:node-base64id
		$NODE_LIB/bignumber.js:node-bignumber
		$NODE_LIB/bytes/index.js:node-bytes
		$NODE_LIB/chrono.js:node-chrono
		$NODE_LIB/cli/index.js:node-cli
		/usr/share/doc/node-colors/copyright:node-colors
		/usr/share/doc/node-commander/copyright:node-commander
		$NODE_LIB/contextify/index.js:node-contextify
		$NODE_LIB/daemon/index.js:node-daemon
		$NODE_LIB/dequeue/index.js:node-dequeue
		/usr/share/doc/node-diff/copyright:node-diff
		$NODE_LIB/dirty/index.js:node-dirty
		$NODE_LIB/fstream/index.js:node-fstream
		$NODE_LIB/get/index.js:node-get
		$NODE_LIB/growl.js:node-growl
		$NODE_LIB/ini.js:node-ini
		$NODE_LIB/JSV/index.js:node-jsv
		$NODE_LIB/keypress.js:node-keypress
		$NODE_LIB/lockfile.js:node-lockfile
		$NODE_LIB/minimatch.js:node-minimatch
		$NODE_LIB/nopt.js:node-nopt
		$NODE_LIB/once.js:node-once
		/usr/share/doc/node-optimist/copyright:node-optimist
		$NODE_LIB/osenv.js:node-osenv
		$NODE_LIB/read.js:node-read
		$NODE_LIB/readdirp/index.js:node-readdirp
		$NODE_LIB/request/index.js:node-request
		$NODE_LIB/retry/index.js:node-retry
		$NODE_LIB/security.js:node-security
		$NODE_LIB/semver/index.js:node-semver
		$NODE_LIB/step.js:node-step
		$NODE_LIB/tar/index.js:node-tar
		$NODE_LIB/tinycolor.js:node-tinycolor
		$NODE_LIB/traverse.js:node-traverse
		$NODE_LIB/which.js:node-which
		$NODE_LIB/wordwrap.js:node-wordwrap
		/usr/share/doc/node-zipfile/copyright:node-zipfile
	"
fi
else
	# MACOS node
NODE_PKG="
	$NODE_CMDS
"
fi

# node-inspector mostly not needed since node v6.3
NPM_GLOBAL_LINUX_PKG="
	node-sass
	phantomjs:phantomjs-prebuilt
	$NPM_LIB/karma/bin/karma:karma
	karma:karma-cli
	$NPM_LIB/karma-chrome-launcher/index.js:karma-chrome-launcher
	$NPM_LIB/karma-phantomjs-launcher/index.js:karma-phantomjs-launcher
"

if [ ! -z $MACOS ]; then
	NPM_GLOBAL_LINUX_PKG=""
fi

# node-inspector mostly not needed since node v6.3
NPM_GLOBAL_PKG="
	n
	pnpm
	yarn
	npm-find
	npm-json5
	npm-cache
	prettydiff
	uglifyjs:uglify-js
	jsdoc
	jshint
	eslint
	jscs
	flow:flow-bin
	babel:babel-cli
	lessc:less
	mocha
	jstest
	jasmine
	bower
	yo
	grunt:grunt-cli
	grunt-init
	express:express-generator
	$NODE_MOD/node-notifier/README.md:node-notifier
	ncu:npm-check-updates
	tsc:typescript tslint typings tsfmt:typescript-formatter
	alm
	create-react-app
	$NPM_GLOBAL_LINUX_PKG
"
} # set_node_env

# set_derived_env values will depend on those defined in set_env
function set_derived_env {
DROP_BACKUP=Dropbox/WorkSafe/_tx/$COMPANY
if [ -z "$COMPANY" ]; then
	COMP=""
	ONBOOT=cfg/onboot.sh
else
	COMP="/$COMPANY"
	ONBOOT=cfg/$COMPANY/onboot-$COMPANY.sh
fi

I3WM_PKG="i3 i3status i3lock $I3BLOCKS dmenu:suckless-tools dunst xbacklight xdotool xmousepos:xautomation feh gs:ghostscript"

# disable commands for omitted packages
[ -z "$SVN_PKG"           ] && SVN_CMD=""
[ -z "$SKYPE_PKG"         ] && SKYPE_CMD=""
[ -z "$SLACK_PKG"         ] && SLACK_CMD="" && SLACK_DEPS=""
[ -z "$USE_I3"            ] && I3WM_PKG="" && I3WM_CMD="" && I3BLOCKS=""
[ -z "$CHARLES_PKG"       ] && CHARLES_CMD=""
[ -z "$VIRTUALBOX_PKG"    ] && VIRTUALBOX_CMDS=""
[ -z "$MVN_PKG"           ] && MVN_CMD=""
[ -z "$GRADLE_PKG"        ] && GRADLE_CMD=""
[ -z "$GITSVN_PKG"        ] && GITSVN_CMD=""
[ -z "$DIFFMERGE_PKG"     ] && DIFFMERGE_CMD=""
[ -z "$P4MERGE_PKG"       ] && P4MERGE_CMD=""
[ -z "$PHP_PKG"           ] && PHP_CMD=""
[ -z "$RUBY_PKG"          ] && RUBY_CMD="" && RUBY_GEMS="" && RUBY_SASS_COMMANDS=""
[ -z "$USE_POSTGRES"      ] && POSTGRES_PKG="" && POSTGRES_NODE_PKG="" && POSTGRES_NPM_PKG=""
[ -z "$USE_REDIS"         ] && REDIS_PKG="" && REDIS_CMDS=""
[ -z "$USE_MONGO"         ] && MONGO_PKG="" && MONGO_CMDS="" && MONGO_CMD="" && ROBO3T_ARCHIVE=""
[ -z "$USE_PIDGIN"        ] && PIDGIN_CMD="" && PIDGIN_SKYPE_PKG=""
[ -z "$DRUID_PKG"         ] && DRUID_PERL_MODULES="" && DRUID_PACKAGES=""
[ -z "$NODE_VER"          ] && NODE_CMD="" && NODE_CMDS="" && NODE_PKG="" && NODE2_PKG="no" && NODE_CUSTOM_PKG="no" && NPM_GLOBAL_PKG="" && POSTGRES_NODE_PKG="" && POSTGRES_NPM_PKG=""
[ -z "$ATOM_PKG"          ] && ATOM_CMD="" && ATOM_APP="" && ATOM_APM=""
[ -z "$PINTA_PKG"         ] && PINTA_CMD=""
[ -z "$ELIXIR_PKG"        ] && ELIXIR_CMD="" && ELIXIR_CMDS=""
[ -z "$DOCKER_PKG"        ] && DOCKER_CMD="" && DOCKER_PRE=""
[ -z "$NVM_VER"           ] && NVM_URL=""
[ -z "$SUBLIME_PKG"       ] && SUBLIME_CFG=""

# HEREIAM DERIVED

# final package configuration based on what has been turned on

INSTALL_MACOSLINUX="
	tcsh
	curl wget
	vim ctags
	screen tmux cmatrix
	colordiff
	dos2unix
	htop
	ncdu
	lsof
	fdupes
	mmv
	pv
	fortune
	mc
	multitail
	jhead
	gradle
	jq
"

INSTALL_LINUX="
	dlocate deborphan
	$EMACS_BASE
	flip
	unicode
	gettext
	iselect
	root-tail
	sysstat
	traceroute
	unetbootin
	fbcat
	chromium-browser
	meld
	libid3-tools
	id3v2
	$MTP_PKG
"
# sysstat for iostat command to check disk performance
# unetbootin for creating bootable linux from usb/network
# MUSTDO ultimate boot cd install to /opt/ubcd for making boot USB
# MUSTDO my snapshot.sh needs: traceroute  and lscgroup,lssubsys from cgroup-bin


INSTALL_MACOS="
	meld:caskroom/cask/meld
	7z:p7zip
	id3v2
"

if [ -z $MACOS ]; then
	INSTALL_MACOS=""
else
	INSTALL_LINUX=""
fi # not MACOS

#vim-scripts requires ruby - loads of color schemes and helpful vim scripts
# runit
# jhead for jpeg EXIF header editing
INSTALL_CMDS="
	$INSTALL_MACOSLINUX
	$INSTALL_LINUX
	$INSTALL_MACOS
"

# HEREIAM SUGGESTED
# from ssh rssh molly-guard monkeysphere
# from gvim ri ruby-dev ruby1.9.1-examples ri1.9.1 graphviz ruby1.9.1-dev ruby-switch
#  cscope ttf-dejavu
# from perlcritic libscalar-number-perl
# from graphviz  graphviz-doc
# from imagemagick   imagemagick-doc autotrace enscript ffmpeg gimp gnuplot grads hp2xx html2ps
#  libwmf-bin mplayer povray radiance texlive-base-bin transfig ufraw-batch
#    libfftw3-bin libfftw3-dev
# from cpanminus libcapture-tiny-perl
# from lm-sensors fancontrol sensord read-edid i2c-tools
# from hddtemp ksensors
# from meld libbonobo2-bin desktop-base libgnomevfs2-bin libgnomevfs2-extra gamin fam
# gnome-mime-data python-gnome2-doc libgtksourceview2.0-dev python-pyorbit-dbg
# from nodejs etc debian-keyring g++-multilib g++-4.8-multilib gcc-4.8-doc libstdc++6-4.8-dbg
# libstdc++-4.8-doc node-hawk node-aws-sign node-oauth-sign
# node-http-signature
# Recommended packages:
# xml-core:i386
# from i3wm libevent-perl libio-async-perl libpoe-perl dwm stterm surf
#    i3lock suckless-tools i3status dunst libanyevent-i3-perl libjson-xs-perl
# from calibre fonts-stix fonts-mathjax-extras libjs-mathjax-doc python-apsw-doc
#  python-markdown-doc ttf-bitstream-vera python-paste python-webob-doc
# from digikam Suggested packages:
# digikam-doc systemsettings libqt4-sql-mysql docbook docbook-dsssl
# docbook-defguide dbtoepub docbook-xsl-doc-html docbook-xsl-doc-pdf
# docbook-xsl-doc-text docbook-xsl-doc docbook-xsl-saxon fop libsaxon-java
# libxalan2-java libxslthl-java xalan python-wxgtk2.8
# libterm-readline-gnu-perl libterm-readline-perl-perl djvulibre-bin finger
# gallery gimp kmail vorbis-tools gpsd gsl-ref-psdoc gsl-doc-pdf gsl-doc-info
# gsl-ref-html hspell libqca2-plugin-cyrus-sasl libqca2-plugin-gnupg
# libqca2-plugin-ossl qtmobility-l10n libquazip-doc phonon-backend-vlc
# gstreamer1.0-plugins-ugly phonon4qt5-backend-gstreamer perlsgml w3-recs
# opensp
# Recommended packages:
# minidnla

# TODO MACOS PKGS
INSTALL_LINUX="
	wcd.exec:wcd
	calc:apcalc
	gvim:vim-gtk
	perlcritic:libperl-critic-perl
"

COMMANDS_LINUX="
	apt-file
	wcd.exec
	gettext
"

if [ -z $MACOS ]; then
	true
else
	INSTALL_LINUX=""
	COMMANDS_LINUX=""
fi

INSTALL_LIST="
	$INSTALL_LINUX
	ssh:openssh-client
	sshd:openssh-server
	perldoc:perl-doc
	dot:graphviz
	convert:imagemagick
	gpm
	markdown
"

if [ -z $MACOS ]; then # TODO MACOS PKGS
INSTALL_FILES="
	/usr/share/doc/fortunes/copyright:fortunes
	/usr/share/doc-base/vim-referencemanual:vim-doc
"
fi # not MACOS

COMMANDS_LIST="
	$COMMANDS_LINUX
	git
	perl
	dot
	meld
	gitk
"

if [ ! -z $PHP_CMD ]; then
	INSTALL_MACOSLINUX="
		$INSTALL_MACOSLINUX
		$PHP_CMD:$PHP_PKG
	"
fi

if [ -z $MACOS ]; then
	GIT_TAR=git-$GIT_VER
	GIT_URL=https://git-core.googlecode.com/files/$GIT_TAR.tar.gz
else
	GIT_TAR=git-$GIT_VER-intel-universal-mavericks.dmg
	GIT_URL=https://downloads.sourceforge.net/project/git-osx-installer/$GIT_TAR
#?r=https%3A%2F%2Fgit-scm.com%2Fdownload%2Fmac&ts=1507631580&use_mirror=kent
fi

if [ -z $MACOS ]; then  # TODO MACOS PKGS
GIT_PKG_AFTER="
	/usr/share/doc-base/git-tools:git-doc
	/usr/lib/git-core/git-gui:git-gui
	gitk
	tig
	$GITSVN_PKG
"
else
	# gitk is in git-gui brew package
	GIT_PKG_AFTER="
		/usr/local/bin/git-gui:git-gui
		tig
		$GITSVN_PKG
	"
fi # not MACOS

if [ ! -z $NVM_VER ]; then
	# NVM_URL="https://raw.githubusercontent.com/creationix/nvm/$NVM_VER/install.sh"
	NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VER/install.sh"
fi

P4MERGE_CMD="$DOWNLOAD/$P4MERGE_VER/bin/p4merge"

WEBSTORM_EXTRACTED_DIR="$DOWNLOAD/$WEBSTORM_DIR"
WEBSTORM_EXTRACTED="$WEBSTORM_EXTRACTED_DIR/bin/webstorm.sh"
WEBSTORM_URL=$WEBSTORM_URL/$WEBSTORM_ARCHIVE.tar.gz

ROBO3T_ARCHIVE=robo3t-$ROBO3T_VER-linux-x86_64-$ROBO3T_CHK
ROBO3T_URL=$ROBO3T_URL/$ROBO3T_VER/linux/$ROBO3T_ARCHIVE.tar.gz
ROBO3T_DIR=$ROBO3T_ARCHIVE
ROBO3T_EXTRACTED_DIR=$DOWNLOAD/$ROBO3T_DIR
ROBO3T_EXTRACTED=$ROBO3T_EXTRACTED_DIR/bin/robo3t

ATOM_URL=$ATOM_URL/v$ATOM_VER/$ATOM_PKG

SUBLIME_URL=$SUBLIME_URL/$SUBLIME_PKG

if [ ! -z $EMACS_BASE ]; then
EMACS_PKG="
	$EMACS_BASE
	/usr/share/emacs/$EMACS_VER/lisp/minibuffer.el.gz:${EMACS_BASE}-el
	${EMACS_BASE}-lucid
	/usr/share/terminfo/x/xtermm:ncurses-term
	editorconfig
	ctags:exuberant-ctags
	/usr/share/doc/libparse-exuberantctags-perl/copyright:libparse-exuberantctags-perl
"
fi

SLACK_URL="$SLACK_URL/$SLACK_PKG"

if [ ! -z "$VIRTUALBOX_PKG" ]; then
	VIRTUALBOX_PKG="$VIRTUALBOX_PKG $VIRTUALBOX_CMD:virtualbox-$VIRTUALBOX_VER"
fi

if [ ! -z "$EMACS_PKG" ]; then
	EMACS_PKG="$EMACS_PKG /usr/share/emacs/$EMACS_VER/lisp/linum.el.gz:$EMACS_BASE-el"
fi

set_node_env

NODE_PKG_LIST="
	$NODE_PKG
	$NODE2_PKG
	$NODE_CUSTOM_PKG
	$POSTGRES_NODE_PKG
"

NPM_GLOBAL_PKG_LIST="
	$NPM_GLOBAL_PKG
	$POSTGRES_NPM_PKG
	$SURGE_NPM_PKG
"

INSTALL_FROM="
	$INSTALL_LIST
	$PERL_PKG
	$TEMPERATURE_PKG
	$KEYBOARD_PKG
	$I3WM_PKG
	$EMACS_PKG
	$MVN_PKG
	$GRADLE_PKG
	$POSTGRES_PKG
	$DRUID_PKG
	$REDIS_PKG
	$MONGO_PKG
	$PIDGIN_CMD
	$PIDGIN_SKYPE_PKG
	$VPN_PKG
	$EBOOK_READER
	$PULSEAUDIO_PKG
	$SLACK_DEPS
	$ELIXIR_PKG
"

COMMANDS="
	$COMMANDS_LIST
	$NODE_CMDS
	$RUBY_CMD
	$RUBY_SASS_COMMANDS
	$SVN_CMD
	$MVN_CMD
	$GRADLE_CMD
	$I3WM_CMD
"

COMMANDS_CUSTOM="
	$ATOM_CMD
	$CHARLES_CMD
	$DIFFMERGE_CMD
	$SKYPE_CMD
	$PIDGIN_CMD
	$SLACK_CMD
	$PINTA_CMD
	$ELIXIR_CMDS
	$REDIS_CMDS
	$MONGO_CMDS
"

PACKAGES="
	$INSTALL_CMDS
	apt-file
	wcd
	bash-completion
	graphviz
	$NODE_PKG_LIST
	$RUBY_PKG
	$GIT_PKG_MAKE
	$GIT_PKG_AFTER
	$SVN_PKG
	$GITSVN_PKG
	$I3WM_PKG
	$VPN_PKG
	$CHARLES_PKG
	$SKYPE_PKG
	$POSTGRES_PKG
	$SCREENSAVER_PKG
	$PIDGIN_CMD
	$PIDGIN_SKYPE_PKG
	$PULSEAUDIO_PKG
	$KEYBOARD_PKG
	$ELIXIR_PKG
	$DOCKER_PRE
"

PERL_MODULES="
	Getopt::ArgvFile
	$DRUID_PERL_MODULES
"

if [ -f ./cpanminus ]; then
	CPAN_LIST=./cpanminus
fi
if [ -f ~/bin/cpanminus ]; then
	CPAN_LIST=~/bin/cpanminus
fi
if [ -z "$CPAN_LIST" ]; then
	echo MAYBE NOT OK cannot find cpanminus
	CPAN_LIST=/dev/null
fi

PERL_MODULES="
	$PERL_MODULES
	`cat $CPAN_LIST | grep -v '#' | perl -pne 's{\.pm}{}xmsg; s{/}{::}xmsg'`
"

# Packages to install specific files
INSTALL_FILE_PACKAGES="
	$INSTALL_FILES
	$DRUID_PACKAGES
"

if [ -e $HOME/bin ]; then
	set -o posix
	set > $HOME/bin/check-system.env.log
	set +o posix
fi
}
set_derived_env

function pre_checks {
	if [ -e "$VPN_CONFIG" ]; then
		OK vpn config file already exists $VPN_CONFIG
		HAD_VPN_CONFIG=1
	fi
}
pre_checks

echo CONFIG UNINSTALL_PKGS=$UNINSTALL_PKGS
echo CONFIG UNINSTALL_NPM_GLOBAL_PKGS=$UNINSTALL_NPM_GLOBAL_PKGS
echo CONFIG INSTALL_CMDS=$INSTALL_CMDS
echo CONFIG INSTALL_FROM=$INSTALL_FROM
echo CONFIG INSTALL_FILES=$INSTALL_FILES
echo CONFIG COMMANDS=$COMMANDS
echo CONFIG COMMANDS_CUSTOM=$COMMANDS_CUSTOM
echo CONFIG PACKAGES=$PACKAGES
echo CONFIG NODE_PKG_LIST=$NODE_PKG_LIST
echo CONFIG PERL_MODULES=$PERL_MODULES
echo CONFIG RUBY_GEMS=$RUBY_GEMS
echo CONFIG INSTALL_FILE_PACKAGES=$INSTALL_FILE_PACKAGES
echo CONFIG NPM_GLOBAL_PKG_LIST

#============================================================================
# begin actual system checking

echo "export COMPANY=$COMPANY" > $HOME/.COMPANY
echo "export EMAIL=$EMAIL" >> $HOME/.COMPANY
file_exists $HOME/.COMPANY "company env variable setup file"

if [ -z $MACOS ]; then
	# provides lsb_release command as well.
	cmd_exists apt-file || (sudo apt-get install apt-file && sudo apt-file update)
fi

uname -a && get-all-release.sh && id

if grep $USER /etc/group | grep sudo; then
	OK "user $USER has sudo privileges"
	sudo egrep "\b$AUSER\b" /etc/passwd /etc/group /etc/sudoers
	#/etc/passwd:bcowgill:x:1001:1001:Brent Cowgill,,,:/home/bcowgill:/bin/bash
	#/etc/group:sudo:x:27:workshare-xps,bcowgill
	#/etc/group:bcowgill:x:1001:
	#etc/sudoers:bcowgill   ALL=(ALL:ALL) ALL
else
	echo You need to confirm sudo priviletes, cannt check automatically.
	if [ ! -z $MACOS ]; then
		[ -e check-my-sudo.tmp ] && sudo rm check-my-sudo.tmp
		sudo touch check-my-sudo.tmp
		if ls -al check-my-sudo.tmp | grep root; then
			OK "user $USER has sudo privileges"
			sudo rm check-my-sudo.tmp
		else
			NOT_OK "user $USER does not have sudo privileges"
		fi
	else
		NOT_OK "user $USER does not have sudo privileges"
	fi
fi

pushd $HOME

if [ "$HOME" == "/home/me" ]; then
	dir_exists "$HOME" "home dir ok"
else
	if [ -z $MACOS ]; then
		dir_link_exists "/home/me" "$HOME" "need to alias home dir as /home/me"
	else
		NOT_OK "MAYBE cannot link /home/me on MACOS"
	fi
fi

make_dir_exist workspace/play "workspace play area missing"
make_dir_exist workspace/tx   "workspace transfer area missing"
make_dir_exist workspace/projects "workspace projects area missing"
make_dir_exist $DOWNLOAD "Downloads area missing"
make_dir_exist $DROP_BACKUP "Dropbox backup area"

get_git

# on MACOS when java not installed, running java command requests an install with dialog box
#L-156131255:bin bcowgill$ ls -al /usr/bin/java
#lrwxr-xr-x  1 root  wheel  74 23 Mar  2017 /usr/bin/java -> /System/Library/Frameworks/JavaVM.framework/Versions/Current/Commands/java

echo VERSIONS
echo MACOS=$MACOS
check_linux "$UBUNTU" $MACOS
which git && git --version
if [ -z $MACOS ]; then # TODO MACOS PKGS
	which apt-get && apt-get --version
else
	which brew && brew --version
fi
[ -x /usr/libexec/java_home ] && /usr/libexec/java_home
which java && java -version && [ -e $JAVA_JVM ] && ls $JAVA_JVM
which groovy && groovy -version
#You should set GROOVY_HOME:
#  export GROOVY_HOME=/usr/local/opt/groovy/libexec
which perl && perl --version
which python && python --version
which ruby && ruby --version
which node && node --version
which nodejs && nodejs --version
which n && n --version
# && echo node lts version: `n --lts` && echo node stable version: `n --stable` && echo node latest version: `n --latest` && n
which npm && (npm --version || echo seems there is no node...)
which pnpm && (pnpm --version || echo seems there is no node...)
which yarn && (yarn --version || echo seems there is no node...)
which erl && erl -eval 'halt().'
which elixir && elixir -v
which php && php -v
which composer && composer -v | head -7
which tsc && tsc -v
which atom && atom -v
if [ ! -z $ATOM_APM ]; then
	which apm && apm --no-color -version
fi
if [ ! -z $MACOS ]; then
	ITV=`grep '# V' ~/bin/cfg/iterm2-shell-integration.sh`
	echo iTerm2 Shell Integration version: $ITV
fi
echo END versions

if [ ! -e $HOME/bin ]; then
	set -o posix
	set > $HOME/check-system.env.log
	set +o posix
fi

BAIL_OUT versions

# chicken egg bootstrap:
if [ ! -e $HOME/bin ]; then
	NOT_OK "MAYBE there is no $HOME/bin dir yet, we will install ourself."
	mkdir $HOME/bin
fi

if [ -e $HOME/bin ]; then
	if [ ! -e $HOME/bin/cfg/check-system.sh ]; then
		# comment out this next line only on first machine setup
		NOT_OK "MAYBE there is a $HOME/bin dir, we will install ourself there. "
		mv $HOME/bin $HOME/bin.saved
		git clone https://github.com/bcowgill/bsac-linux-cfg.git
		make_dir_exist workspace/play
		mv bsac-linux-cfg workspace/play
		ln -s workspace/play/bsac-linux-cfg/bin
		popd
		git config --global user.email "$EMAIL"
		git config --global user.name "$MYNAME"
		git config --global push.default simple
		cp cfg/check-system.sh $HOME/bin/cfg/
		cp lib-check-system.sh $HOME/bin
		echo You need to ensure you export PATH=$PATH:$HOME/bin
		echo before you run this command again
	else
		OK "we are already installed."
	fi
fi

# remove bin.saved dir only if empty
if [ -d $HOME/bin.saved ]; then
	rmdir $HOME/bin.saved >> /dev/null 2>&1 || NOT_OK "~/bin.saved still exists, please move anything useful to ~/bin"
fi

dir_linked_to sandbox workspace "sandbox alias for workspace"
dir_linked_to bin workspace/play/bsac-linux-cfg/bin "linux config scripts in workspace"
dir_linked_to tx workspace/tx "transfer area in workspace"
dir_linked_to projects workspace/projects "projects area in workspace"
dir_linked_to bk $DROP_BACKUP "backup area in Dropbox"

if [ ! -z $LINK_DOWNLOADS ]; then
	dir_linked_to Downloads d/Download "download directory in personal tree"
fi

dir_exists  bin/cfg "bin configuration missing"
file_linked_to go.sh bin/$ONBOOT "on reboot script configured"

#if [ -z "$COMPANY" ]; then
file_linked_to bin/check-system.sh $HOME/bin/cfg/check-system.sh "system check script configured"
#else
#	file_linked_to bin/check-system.sh $HOME/bin/cfg/$COMPANY/check-$COMPANY.sh "system check script configured"
#fi

file_exists workspace/cfgrec.txt "configuration record files will copy from templates" || cp bin/template/cfgrec/* workspace/
file_exists workspace/cfgrec.txt "configuration record files"

if [ ! -z "$INI_DIR" ]; then
	rm -rf $INI_DIR
	make_dir_exist /tmp/$USER "user's own temporary directory"
	if dir_exists tmp "tmp dir in user home" ; then
		true
	else
		dir_linked_to tmp /tmp/$USER "make a tmp in home dir point to /tmp/"
	fi
	make_dir_exist $INI_DIR "output area for checking INI file settings"
fi

make_dir_exist workspace/backup/cfg "workspace home configuration files missing"
make_dir_exist workspace/tx/mirror "workspace mirror area for charles"
make_dir_exist workspace/tx/_snapshots "workspace area for screen shots"
dir_linked_to Pictures/_snapshots $HOME/workspace/tx/_snapshots "link pictures dir to snapshots"

if [ ! -z "$COMPANY" ]; then
	if [ "$HOSTNAME" != "raspberrypi" ]; then
		file_linked_to bin/get-from-home.sh $HOME/bin/cfg/$COMPANY/get-from-home-$COMPANY.sh "home work unpacker configured"
	fi
fi

if [ -z $MACOS ]; then
touch go.sudo; rm go.sudo
if [ `ulimit -n` == $ULIMITFILES ]; then
	OK "ulimit for open files is good"
else
	NOT_OK "ulimit for open files is bad need $ULIMITFILES"
	config_has_text /etc/security/limits.conf $USER "check limits file" || ( \
		echo echo \"$USER            soft    nofile          $ULIMITFILES\" \>\> /etc/security/limits.conf > go.sudo;
		echo echo \"$USER            hard    nofile          $ULIMITFILES\" \>\> /etc/security/limits.conf >> go.sudo;
		chmod +x go.sudo;
		sudo ./go.sudo\
	)
	config_has_text /etc/security/limits.conf $USER "check username in limits file"
	config_has_text /etc/security/limits.conf $ULIMITFILES "check value in limits file"
	echo YOUDO You have to logout/login again for ulimit to take effect.
	exit 1
fi

# https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
if grep -rl inotify /etc/sysctl.conf /etc/sysctl.d; then
	OK "inotify settings are configured in /etc/sysctl.conf or /etc/sysctl.d"
else
	FILE=/etc/sysctl.d/10-inotify.conf
	make_root_file_exist "$FILE" "fs.inotify.max_user_watches = 524288" "set inotify file watch settings"
	file_has_text "$FILE" "fs.inotify.max_user_watches = 524288" "inotify file watch settings for hungry IDEs like IntelliJ"
	sudo sysctl -p --system
fi

# try a different kernel:
# ls /boot
# update-initramfs -u -k 3.13.0-46-generic

# ensure /boot doesn't get too full
if df -k /boot | egrep [89][0-9]% ; then
	NOT_OK "/boot is nearly full, will clean up some space now."
	sudo apt-get autoremove
else
	OK "plenty of space on /boot"
fi

fi # not MACOS

# Shell configuration files
file_linked_to .git_aliases bin/cfg/git-aliases.sh  "git alias configured"
file_linked_to .bash_aliases bin/cfg/.bash_aliases  "bash alias configured"
file_linked_to .bash_functions bin/cfg/.bash_functions "bash functions configured"
if [ ! -z $MACOS ]; then
	file_linked_to .bash_profile bin/cfg/.bash_profile "bash_profile configured"
fi
file_linked_to .bashrc bin/cfg/.bashrc "bashrc configured"
file_linked_to .perltidyrc bin/cfg/.perltidyrc "perltidyrc configured"
#file_linked_to .perltidyrc bin/cfg/.perltidyrc-$COMPANY "perltidyrc configured for $COMPANY"
file_linked_to .vimrc bin/cfg/vimrc.txt  "awesome vim configured"
#file_linked_to .vimrc bin/cfg/.vimrc  "vim configured"
file_linked_to .screenrc bin/cfg/.screenrc "screen command layouts configured"
file_linked_to .my.cnf bin/cfg/.my.cnf "mysql configured"
file_linked_to .pgadmin3 bin/cfg/.pgadmin3 "postgres admin tool configured"
file_linked_to .aspell.en.pws bin/cfg/.aspell.en.pws "aspell personal word list for english dictionary"
file_linked_to .aspell.en.prepl bin/cfg/.aspell.en.prepl "aspell personal replacements for english dictionary"

if [ -z $MACOS ]; then

file_linked_to .Xresources bin/cfg/.Xresources "xresources config for xterm and other X programs"
file_linked_to .xscreensaver bin/cfg$COMP/.xscreensaver "xscreensaver configuration"
dir_linked_to .gconf bin/cfg$COMP/.gconf/ "gnome configuration files linked"

if [ ! -z $USE_I3 ]; then
	make_dir_exist .config/i3 "i3 configuration file dir"
	file_linked_to .config/i3/config $HOME/bin/cfg$COMP/.i3-config "i3 window manager configuration"
	file_linked_to bin/i3-launch.sh  $HOME/bin/cfg$COMP/i3-launch.sh "i3 window manager launch configuration"
	file_linked_to bin/i3-dock.sh    $HOME/bin/cfg$COMP/i3-dock.sh "i3 window manager docking configuration"
fi

[ -d .config/mc ] && HAS_MC=1
make_dir_exist .config/mc "midnight commander configuration file dir"
if [ ${HAS_MC:-)} == 0 ]; then
	OK "MAYBE copying midnight commander configuration"
	cp bin/cfg/.config/mc/* .config/mc/ || NOT_OK "unable to copy midnight commander configuration"
fi

fi # not MACOS

if [ ! -z "$MOUNT_DATA" ]; then
	if [ -z "$BIG_DATA" ]; then
		NOT_OK "Must specify BIG_DATA if MOUNT_DATA is specified"
	fi
	if [ -d "$BIG_DATA/UNMOUNTED" ]; then
		OK "$BIG_DATA/UNMOUNTED exists will try mounting it to check dirs"
		sudo mount "$BIG_DATA"
		if [ -d "$BIG_DATA/UNMOUNTED" ]; then
			NOT_OK "unable to mount /data"
#   mkdir -p "$BIG_DATA/UNMOUNTED"
#   blkid /dev/sdb1
#   mount UUID="89373938-6b43-4471-8aef-62cd6fc2f2a3" "$BIG_DATA"
#   /etc/fstab entry added
#   UUID=89373938-6b43-4471-8aef-62cd6fc2f2a3 /data           ext4    rw              0       2
#   mkdir -p "$BIG_DATA/$USER"
#   chown -R $USER:domusers "$BIG_DATA/$USER"
			exit 1
		fi
	fi
else
	OK "will not configure mounting /data partition unless MOUNT_DATA is non-zero"
fi # MOUNT_DATA

if [ ! -z "$BIG_DATA" ]; then
	if [ ! -d "$BIG_DATA/$USER" ]; then
		make_root_dir_exist "$BIG_DATA/$USER" "create Big data area for IE vm's"
		take_ownership_of "$BIG_DATA/$USER" "own Big data area for IE vm's"
	fi

	# Virtualbox configuration
	# /home/bcowgill/.config/VirtualBox/
	# default where it stores VM images
	# /home/bcowgill/VirtualBox VMs/

	dir_exists "$BIG_DATA/$USER" "personal area on data dir missing"
	make_dir_exist "$BIG_DATA/$USER/backup" "backup dir on /data"
	make_dir_exist "$BIG_DATA/$USER/VirtualBox" "VirtualBox dir on /data"
	dir_linked_to "$HOME/VirtualBox VMs" "$BIG_DATA/$USER/VirtualBox" "link for VirtualBox VMs"
	dir_exists "$BIG_DATA/$USER/VirtualBox/ie-vm-downloads" "MAYBE ie vms directory" && \
	dir_linked_to $HOME/.ievms "$BIG_DATA/$USER/VirtualBox/ie-vm-downloads" "link for ievms script"
fi

BAIL_OUT init

if [ ! -z $MACOS ]; then
	cmd_exists brew > /dev/null || ( echo want to install homebrew; /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" )
	cmd_exists brew
	app_exists Xcode.app "XCode is required, please install from App Store. it takes hours to download."
fi

# Fonts ================================================================
# https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=14781
install_file_from_url_zip $DOWNLOAD/MProFont/ProFontWindows.ttf MProFont.zip "http://tobiasjung.name/downloadfile.php?file=MProFont.zip" "ProFontWindows font package"
install_file_from_url_zip $DOWNLOAD/ProFont-Windows-Bold/ProFont-Bold-01/ProFontWindows-Bold.ttf ProFont-Windows-Bold.zip "http://tobiasjung.name/downloadfile.php?file=ProFont-Windows-Bold.zip" "ProFontWindows bold font package"
install_file_from_url_zip $DOWNLOAD/ProFontWinTweaked/ProFontWindows.ttf ProFontWinTweaked.zip "http://tobiasjung.name/downloadfile.php?file=ProFontWinTweaked.zip" "ProFontWindows tweaked font package"
echo YOUDO You have to manually install ProFontWindows with your Font Manager from $DOWNLOAD/MProFont/ProFontWindows.ttf

# alternative install: npm install git://github.com/adobe-fonts/source-code-pro.git#release
# https://github.com/adobe-fonts/source-code-pro/ archive/1.017R.zip
SC_PRO_VERSION=1.017R
SC_PRO_ARCHIVE=source-code-pro-$SC_PRO_VERSION
install_file_from_url_zip $DOWNLOAD/$SC_PRO_ARCHIVE/SVG/SourceCodePro-Black.svg $SC_PRO_ARCHIVE.zip "https://github.com/adobe-fonts/source-code-pro/archive/$SC_PRO_VERSION.zip" "Source Code pro font package"
install_file_from_url_zip $DOWNLOAD/$SC_PRO_ARCHIVE/OTF/SourceCodePro-Black.otf $SC_PRO_ARCHIVE.zip "https://github.com/adobe-fonts/source-code-pro/archive/$SC_PRO_VERSION.zip" "Source Code pro font package"
echo YOUDO You have to manually install SourceCodePro with your Font Manager from $DOWNLOAD/$SC_PRO_ARCHIVE/OTF/SourceCodePro-Black.otf

FILE=.fonts/ProFontWindows.ttf
make_dir_exist .fonts "locally installed fonts for X windows"
file_exists $FILE || cp $DOWNLOAD/ProFontWinTweaked/ProFontWindows.ttf .fonts
file_exists $FILE "ProFontWindows still not installed"
FILE=.fonts/SourceCodePro-Black.otf
file_exists $FILE || cp $DOWNLOAD/$SC_PRO_ARCHIVE/OTF/*.otf .fonts
file_exists $FILE "SourceCodePro fonts still not installed"

if [ -z $MACOS ]; then

cmd_exists fc-cache "font cache program needed"
cmd_exists fc-list "font cache list program needed"
fc-cache --verbose | grep 'new cache contents' || echo " "
if ( fc-list | grep ProFontWindows ) ; then
	OK "ProFontWindows font is cached"
else
	NOT_OK "ProFontWindows font is not cached"
fi
if ( fc-list | grep SourceCodePro ) ; then
	OK "SourceCodePro font is cached"
else
	NOT_OK "SourceCodePro font is not cached"
fi

if [ ! -f xlsfonts.lst  ]; then
	locale -a > locale-a.lst
	xset q > xset-q.lst
	xlsfonts > xlsfonts.lst
	fc-list > fc-list.lst
fi

else
	# on MACOS Library/Fonts/ contains installed fonts, manually install
	echo You may have to install these fonts manually by dragging from .fonts/ dir
	file_exists Library/Fonts/ProFontWindows.ttf ”ProFontWindows font installed on MACOS”
	file_exists Library/Fonts/SourceCodePro-Black.otf ”SourceCodePro Black font installed on MACOS”
	file_exists Library/Fonts/SourceCodePro-Bold.otf ”SourceCodePro Bold font installed on MACOS”
	file_exists Library/Fonts/SourceCodePro-ExtraLight.otf ”SourceCodePro ExtraLight font installed on MACOS”
	file_exists Library/Fonts/SourceCodePro-Light.otf ”SourceCodePro Light font installed on MACOS”
	file_exists Library/Fonts/SourceCodePro-Medium.otf ”SourceCodePro Medium font installed on MACOS”
	file_exists Library/Fonts/SourceCodePro-Regular.otf ”SourceCodePro Regular font installed on MACOS”
	file_exists Library/Fonts/SourceCodePro-Semibold.otf ”SourceCodePro Semibold font installed on MACOS”

fi # not MACOS

# Get unicode fonts and examples
# http://www.cl.cam.ac.uk/~mgk25/ucs-fonts.html
# http://www.cl.cam.ac.uk/~mgk25/ucs/quick-intro.txt
# http://www.cl.cam.ac.uk/~mgk25/unicode.html#x11
URL=http://www.cl.cam.ac.uk/~mgk25

CHECK=`LC_CTYPE=en_GB.UTF-8 locale charmap`
if [ ${CHECK:-NOTOK} == UTF-8 ]; then
	OK "UTF-8 locale is supported"
else
	NOT_OK "UTF-8 locale is not supported:: $CHECK"
fi
install_file_from_url_zip_subdir "$DOWNLOAD/ucs-fonts/examples/UTF-8-test.txt" "ucs-fonts.tar.gz" ucs-fonts $URL/download/ucs-fonts.tar.gz "Misc Fixed unicode fonts"
#install_file_from_url_zip_subdir "$DOWNLOAD/ucs-fonts-75dpi100dpi/100dpi/timR24.bdf" "ucs-fonts-75dpi100dpi.tar.gz" ucs-fonts-75dpi100dpi $URL/download/ucs-fonts-75dpi100dpi.tar.gz "Fixed unicode fonts Adobe B&H"
#install_file_from_url "$DOWNLOAD/ucs-fonts/examples/quick-intro.txt" "ucs-fonts/examples/quick-intro.txt" $URL/ucs/quick-intro.txt
dir_linked_to bin/template/unicode "$DOWNLOAD/ucs-fonts/examples" "symlink to sample unicode files"

BAIL_OUT font

if [ -z $MACOS ]; then

# MUSTDO finish this
if false ; then
if xlsfonts | grep xyzzy > /dev/null ; then
	OK "ucs unicode fonts are installed"
else
	NOT_OK "MAYBE install ucs unicode fonts"
	pushd $DOWNLOAD/ucs-fonts/submission
	make
	ls *.pcf.gz
	#sudo mv -b *.pcf.gz /usr/share/fonts/X11/misc
	#sudo mkfontdir /usr/share/fonts/X11/misc
	#xset fp rehash
	popd
fi
fi

# Install the X fonts!
# display all the glyphs in a random UTF font
# xfd -fn `grep -i ISO10646 xlsfonts.lst | choose.pl `

# Find all the .kde config files referenced herein:
# grep \.kde/ check-system.sh | perl -pne 's{\s* (FILE=|file_has_text \s*)}{}xms; s{\s*".+\z}{\n}xms; s{\s+\#}{}xms;s{\./}{}xms ' | sort | uniq > ~/xxx
if [ ! -z "$USE_KDE" ]; then
if cmd_exists kfontinst > /dev/null ; then
	cmd_exists kfontinst
	FILE=.fonts/p/ProFontWindows.ttf
	# TODO needed for workshare
	FILE=.fonts/ProFontWindows.ttf
	file_exists $FILE "ProFontWindows font needs to be installed" || find $DOWNLOAD/ -name '*.ttf'
	file_exists $FILE > /dev/null || kfontinst $DOWNLOAD/ProFontWinTweaked/ProFontWindows.ttf
	file_exists $FILE "ProFontWindows still not installed"

	FILE=.fonts/p/ProFontWindows_Bold.ttf
	file_exists $FILE > /dev/null || kfontinst $DOWNLOAD/ProFont-Windows-Bold/ProFont-Bold-01/ProFontWindows-Bold.ttf
	file_exists $FILE "ProFontWindows Bold still not installed"

	file_has_text .kde/share/apps/konsole/Shell.profile "Font=ProFontWindows,14" "need to set font for konsole Settings / Edit Current Profile / Appearance / Set Font"
	file_has_text .kde/share/config/kateschemarc "Font=ProFontWindows,18" "ProFontWindows in kate editor Settings / Configure Kate / Fonts & Colors"
	file_has_text .kde/share/config/kateschemarc "Solarized (dark)" "Solarized Dark schema in kate editor"
	# adjusted Solarized (dark) color for some barely visible items
	file_has_text .kde/share/config/katesyntaxhighlightingrc "Bash:OtherCommand=1,ff930093,ff839496,1,,,,,,,---" "Settings / Configure Kate / Fonts & Colors / Highlighting Text Styles"
	#file_has_text .kde/share/config/katesyntaxhighlightingrc "Bash:OtherCommand=1,ff7b007b,ff839496,1,,,,,,,---" "Settings / Configure Kate / Fonts & Colors / Highlighting Text Styles"

	file_has_text .kde/share/config/katesyntaxhighlightingrc "Bash:Redirection=1,ff293ea6,ff839496,1,,,,,,,---" "Settings / Configure Kate / Fonts & Colors / Highlighting Text Styles"
	file_has_text .kde/share/config/kdeglobals "fixed=ProFontWindows,14" "ProFontWindows for System fixed width font System Settings / Application Appearance / Fonts"

	#TODO KATE color check
	#./.kde/share/config/colors/Recent_Colors
	#./.kde/share/config/kateschemarc

	FILE=.kde/share/config/katerc
	file_has_text "$FILE" "Indent On Backspace=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Indent On Text Paste=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Indentation Width=4" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Newline At EOF=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "PageUp/PageDown Moves Cursor=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Remove Spaces=1" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Show Spaces=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Word Wrap=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Word Wrap Column=128" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Animate Bracket Matching=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Show Indentation Lines=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Show Whole Bracket Expression=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Word Wrap Marker=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Dynamic Word Wrap=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Dynamic Word Wrap Align Indent=80" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Dynamic Word Wrap Indicators=1" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "Smart Copy Cut=true" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "toolbar actions=home,mkdir,up,back,forward,show hidden,short view,detailed view,tree view,detailed tree view,bookmarks,sync_dir,configure" "Settings / Configure Kate / Editor"
	file_has_text "$FILE" "showFullPathOnRoots=true" "Settings / Configure Kate / Editor"

fi # kfontinst command exists
fi # USE_KDE set

fi # not MACOS

BAIL_OUT xfont

if [ ! -z "$USE_I3" ]; then
	apt_has_source_listd "i3window-manager" "deb http://debian.sur5r.net/i3/ $LSB_RELEASE universe" "adding i3wm source for apt"
	cmd_exists $I3WM_CMD || (sudo apt-get update; sudo apt-get --allow-unauthenticated install sur5r-keyring; sudo apt-get update; sudo apt-get install $I3WM_CMD)
	cmd_exists $I3WM_CMD
else
	OK "will not configure i3 window manager unless I3WM_PKG is non-zero"
fi # I3WM_PKG

if [ ! -z "$CHARLES_PKG" ]; then
	# update apt sources list with needed values to install some more complicated programs
	touch go.sudo; rm go.sudo
	apt_has_source "deb http://www.charlesproxy.com/packages/apt/ charles-proxy main" "apt config for charles-proxy missing"
	apt_must_not_have_source "deb-src http://www.charlesproxy.com/packages/apt/ charles-proxy main" "apt config for charles-proxy wrong"
	[ -f go.sudo ] && (wget -q -O - http://www.charlesproxy.com/packages/apt/PublicKey | sudo apt-key add - )
	apt_has_key charlesproxy http://www.charlesproxy.com/packages/apt/PublicKey "key fingerprint for Charles Proxy missing"
else
	OK "will not configure charles proxy unless CHARLES_PKG is non-zero"
fi # CHARLES_PKG

if [ ! -z "$VIRTUALBOX_PKG" ]; then
	# http://ubuntuhandbook.org/index.php/2015/07/install-virtualbox-5-0-ubuntu-15-04-14-04-12-04/
	# https://www.virtualbox.org/wiki/Linux_Downloads
	# http://www.howopensource.com/2013/04/install-virtualbox-ubuntu-ppa/
	apt_has_source "deb http://download.virtualbox.org/virtualbox/debian $VIRTUALBOX_REL contrib" "apt config for virtualbox $VIRTUALBOX_REL"
	apt_must_not_have_source "deb-src http://download.virtualbox.org/virtualbox/debian $VIRTUALBOX_REL contrib" "apt config for virtualbox wrong"
	if [ "$LSB_RELEASE" != "$VIRTUALBOX_REL" ]; then
		apt_must_not_have_source "deb http://download.virtualbox.org/virtualbox/debian $LSB_RELEASE contrib" "apt config trusty must use raring for now"
		apt_must_not_have_source "deb-src http://download.virtualbox.org/virtualbox/debian $LSB_RELEASE contrib" "apt config trusty must use raring for now"
	fi

	apt_has_key VirtualBox http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc "key fingerprint for VirtualBox missing"
	FILTERED_LIST=`filter_packages "$VIRTUALBOX_PKG" "$UNINSTALL_PKGS"`
	installs_from "$FILTERED_LIST" "additional packages for virtualbox"

	cmd_exists dkms "need dkms command for VirtualBox"
	cmd_exists $VIRTUALBOX_CMD || (sudo apt-get update; sudo apt-get install $VIRTUALBOX_PKG)
	commands_exist $VIRTUALBOX_CMDS
else
	OK "will not configure virtualbox unless VIRTUALBOX_PKG is non-zero"
fi # VIRTUALBOX_PKG

if [ ! -z "$SVN_PKG" ]; then
	apt_has_source "deb http://ppa.launchpad.net/svn/ppa/ubuntu $LSB_RELEASE main" "apt config for svn update missing"
	apt_has_source "deb-src http://ppa.launchpad.net/svn/ppa/ubuntu $LSB_RELEASE main" "apt config for svn update missing"
else
	OK "will not configure subversion unless SVN_PKG is non-zero"
fi

if [ ! -z "$MONO_PKG" ]; then
	# http://www.mono-project.com/docs/getting-started/install/linux/
#	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
#	echo "deb http://download.mono-project.com/repo/debian $LSB_RELEASE main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
#	sudo apt-get update
#	sudo apt-get install $MONO_PKG
	cmd_exists $MONO_CMD
else
	OK "will not configure mono unless MONO_PKG is non-zero"
fi

if [ ! -z "$CHARLES_PKG$SVN_PKG$VIRTUALBOX_PKG" ]; then

	echo MAYBE DO MANUALLY apt-get install $CHARLES_PKG $SVN_PKG $VIRTUALBOX_PKG
	[ -f go.sudo ] && (sudo apt-get update; sudo apt-get install $CHARLES_PKG $SVN_PKG && sudo apt-get -f install && echo YOUDO: set charles license: $CHARLES_LICENSE)
fi

[ ! -z "$CHARLES_PKG" ] && cmd_exists $CHARLES_CMD
#[ ! -z "$SKYPE_PKG" ] && cmd_exists $SKYPE_CMD

if [ ! -z "$SVN_PKG" ]; then
	cmd_exists svn
	file_exists /usr/lib/x86_64-linux-gnu/jni/libsvnjavahl-1.so "svn and eclipse setup lib exists"
	dir_linked_to /usr/lib/jni /usr/lib/x86_64-linux-gnu/jni "svn and eclipse symlink exists" root
	apt_has_key WANdisco http://opensource.wandisco.com/wandisco-debian.gpg "key fingerprint for svn 1.8 wandisco"
	apt_has_source_listd WANdisco "deb http://opensource.wandisco.com/ubuntu $LSB_RELEASE svn18" "adding WANdisco source for apt"
	if svn --version | grep " version " | grep $SVN_VER; then
		OK "svn command version correct"
	else
		NOT_OK "svn command version incorrect - will try update"
		# http://askubuntu.com/questions/312568/where-can-i-find-a-subversion-1-8-binary
		sudo apt-get update
		apt-cache show subversion | grep '^Version:'
		sudo apt-get install $SVN_PKG
		NOT_OK "exiting after svn update, try again."
		exit 1
	fi
else
	OK "will not configure subversion unless SVN_PKG is non-zero"
fi # SVN_PKG

has_ssh_keys $COMPANY

which git
if git --version | grep " version " | grep $GIT_VER; then
	OK "git command version correct"
	if [ ! -z "$GIT_PKG_AFTER" ]; then
		FILTERED_LIST=`filter_packages "$GIT_PKG_AFTER" "$UNINSTALL_PKGS"`
		installs_from "$FILTERED_LIST" "additional git packages"
	else
		OK "will not install git tools unless GIT_PKG_AFTER is non-zero"
	fi
else
	NOT_OK "git command version incorrect, want $GIT_VER - will try update"
	if [ -z $MACOS ]; then
		# old setup for git 1.9.1
		# http://blog.avirtualhome.com/git-ppa-for-ubuntu/
		apt_has_source ppa:pdoes/ppa "repository for git"
		sudo apt-get update
		apt-cache show git | grep '^Version:'
		if [ ! -z "$GIT_PKG_AFTER" ]; then
			FILTERED_LIST=`filter_packages "$GIT_PKG_AFTER" "$UNINSTALL_PKGS"`
			installs_from "$FILTERED_LIST" "additional git packages"
		else
			OK "will not install git tools unless GIT_PKG_AFTER is non-zero"
		fi
		NOT_OK "exiting after git update, try again."
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
		NOT_OK "exiting after git update, try again."
		exit 1
	else
		# MACOS git install
		# https://stackoverflow.com/questions/17582685/install-gitk-on-mac#comment40309665_25090800
		# https://sourceforge.net/projects/git-osx-installer/files/git-2.14.1-intel-universal-mavericks.dmg/download?use_mirror=autoselect
		if [ `which git` != /usr/local/bin/git ]; then
			echo "NOT OK MAYBE default git is installed, will upgrade"
			brew update --verbose || echo "NOT OK MAYBE brew did not update but try anyway..."
			brew doctor && brew install git
			if [ `which git` == /usr/local/bin/git ]; then
				OK "git upgraded"
				echo "MAYBE YOUDO manually brew install $GIT_PKG_AFTER"
			else
				echo "NOT OK MAYBE git not upgraded correctly try download"
				make_dir_exist $DOWNLOAD
				pushd $DOWNLOAD
					wget $GIT_URL
					echo "MAYBE YOUDO MANUALLY install package $GIT_TAR"
					echo "MAYBE YOUDO manually brew install $GIT_PKG_AFTER"
					NOT_OK "exiting after git update, try again."
					exit 1
				popd
			fi
		else
			OK "homebrew version of git is installed."
		fi
	fi
	if git --version | grep " version " | grep $GIT_VER; then
		OK "git command version correct"
	else
		NOT_OK "git command version incorrect, want $GIT_VER"
	fi
fi # GIT_VER

if [ ! -z "$GITSVN_PKG" ]; then
	cmd_exists git
	if [ -x $GITSVN_CMD ]; then
		OK "git svn command installed"
	else
		NOT_OK "git svn command missing -- will try to install"
		sudo apt-get install $GITSVN_PKG
	fi
	cmd_exists $GITSVN_CMD
else
	OK "will not configure git-svn unless GITSVN_PKG is non-zero"
fi # GITSVN_PKG

if [ -z $MACOS ]; then # TODO MACOS PKGS
	GIT_COMPLETE=/usr/share/bash-completion/completions/git
	if file_exists "$GIT_COMPLETE" > /dev/null ; then
		# git installs completion file but not in right place any more
		file_linked_to_root /etc/bash_completion.d/git /usr/share/bash-completion/completions/git
	else
		file_exists /etc/bash_completion.d/git "git completion file in etc"
	fi
else # MACOS completion
	install_file_from $(brew --prefix)/etc/bash_completion bash-completion
fi # MACOS

if [ x`git config --global --get user.email` == x$EMAIL ]; then
	OK "git config has been set up"
else
	NOT_OK "git config not set. trying to do so"
	git config --global user.name "$MYNAME"
	git config --global user.email $EMAIL
fi

if git config --global --list | grep rerere; then
	OK "git config rerere has been set up"
else
	echo "NOT OK MAYBE git config rerere not set. trying to do so"
	git config --global rerere.enabled true
	git config --global rerere.autoupdate true
	if git config --global --list | grep rerere; then
		OK "git config rerere has been set up"
	else
		NOT_OK "git config rerere not set. failed to do so"
	fi
fi


if git config --global --list | grep alias.graph; then
	OK "git config alias.graph has been set up"
else
	echo "NOT OK MAYBE git config alias.graph not set. trying to do so"
	git config --global --add alias.graph "log --oneline --graph --decorate --all"
	if git config --global --list | grep alias.graph; then
		OK "git config alias.graph has been set up"
	else
		NOT_OK "git config alias.graph not set. failed to do so"
	fi
fi

if [ ! -z "$USE_JAVA" ]; then
	if [ -z "$JAVA_JRE" ]; then
		JAVA_JRE="$JAVA_HOME/jre/bin/java"
	fi
	if [ -z $MACOS ]; then
		if [ "x$JAVA_HOME" == "x$JAVA_JVM/$JAVA_VER" ]; then
			OK "JAVA_HOME set correctly"
			file_exists "$JAVA_JRE" "java is actually there"
		else
			NOT_OK "JAVA_HOME is incorrect $JAVA_HOME [$JAVA_JVM/$JAVA_VER]"
			exit 1
		fi # JAVA_HOME
		dir_linked_to jdk workspace/$JAVA_VER "shortcut to current java dev kit"
	else
		# MACOS here
		if [ ! -e "$JAVA_JRE" ]; then
			install_command_package_from_url $JAVA_CMD $JAVA_PKG $JAVA_URL "java development kit"
		fi
		if [ "x$JAVA_HOME" == "x$JAVA_JVM" ]; then
			OK "JAVA_HOME set correctly"
			file_exists "$JAVA_JRE" "java is actually there"
		else
			NOT_OK "JAVA_HOME is incorrect $JAVA_HOME [$JAVA_JVM]"
			exit 1
		fi
	fi
	if which groovy; then
		if [ ! -z "$GROOVY_HOME" ]; then
			OK "GROOVY_HOME is set"
			file_exists "$GROOVY_HOME/bin/groovy" "groovy is actually there"
		else
			NOT_OK "GROOVY_HOME is incorrect"
			exit 1
		fi
	fi
fi

if [ ! -z "$DIFFMERGE_PKG" ]; then
	echo CHECK $DIFFMERGE_CMD $DIFMERGE_PKG
	install_command_package_from_url $DIFFMERGE_CMD $DIFFMERGE_PKG $DIFFMERGE_URL "sourcegear diffmerge"
	if [ ! -z $MACOS ]; then
		app_exists DiffMerge.app "you must manually install downloaded diffmerge dmg file and Extras/diffmerge.sh"
	fi
else
	OK "will not configure diffmerge unless DIFFMERGE_PKG is non-zero"
fi

if [ ! -z "$P4MERGE_PKG" ]; then
	install_file_from_zip $P4MERGE_CMD $P4MERGE_PKG "Perforce HELIX P4MERGE: VISUAL MERGE TOOL manual download from $P4MERGE_URL"
	file_linked_to "$HOME/bin/p4merge" "$P4MERGE_CMD" "Perforce p4merge link"
else
	OK "will not configure perforce merge unless P4MERGE_PKG is non-zero"
fi

BAIL_OUT diff

# erlang/elixir
# http://elixir-lang.org/install.html#unix-and-unix-like
if [ ! -z "$ELIXIR_PKG" ]; then
	if [ ! -f "$DOWNLOAD/$ERLANG_PKG" ]; then
		cmd_exists $ERLANG_CMD || (install_file_from_url "$DOWNLOAD/$ERLANG_PKG" $ERLANG_PKG $ERLANG_URL "erlang deb for elixir" && (sudo dpkg -i $DOWNLOAD/$ERLANG_PKG && sudo apt-get update))
	fi
	if [ ! -f "$DOWNLOAD/$ELIXIR_DEB" ]; then
		cmd_exists $ELIXIR_CMD || (install_file_from_url "$DOWNLOAD/$ELIXIR_DEB" $ELIXIR_DEB $ELIXIR_URL "elixir deb package" && (sudo dpkg -i $DOWNLOAD/$ELIXIR_DEB && sudo apt-get update))
	fi
fi

BAIL_OUT elixir

# https://docs.mongodb.com/tutorials/install-mongodb-on-ubuntu/
if [ ! -z "$USE_MONGO" ]; then
	apt_has_key_adv_recv $MONGO_KEYCHK $MONGO_KEY $MONGO_KEYSVR "key fingerprint for mongo database"
	apt_has_source_listd_check "mongodb-org-3.4.list" "deb [ arch=amd64 ] http://repo.mongodb.org/apt/ubuntu $UBUNTU/mongodb-org/3.4 multiverse" "http://repo.mongodb.org/apt/ubuntu" "adding apt source for mongo database"
	cmd_exists $MONGO_CMD || (sudo apt-get update && sudo apt-get install $MONGO_PKG)
	#sudo service mongod start
fi # USE_MONGO

BAIL_OUT mongo

echo BIG BREW_TAPS $BREW_TAPS
echo BIG INSTALL_CMDS $INSTALL_CMDS
echo BIG INSTALL FROM $INSTALL_FROM
echo BIG INSTALL FILES $INSTALL_FILES
echo BIG CUSTOM PKG $CUSTOM_PKG
echo BIG NODE PKG $NODE_PKG_LIST
echo BIG PERL MODULES $PERL_MODULES
echo BIG RUBY GEMS $RUBY_GEMS
echo BIG INSTALL FILE PACKAGES $INSTALL_FILE_PACKAGES
echo BIG COMMANDS $COMMANDS
echo BIG INSTALL NPM GLOBAL FROM $NPM_GLOBAL_PKG_LIST
echo BIG VPN_PKG $VPN_PKG $VPN_CONFIG $VPN_CONN

brew_taps_from "$BREW_TAPS"
if [ ! -z "$UNINSTALL_PKGS" ]; then
	uninstall_from "$UNINSTALL_PKGS"
fi

FILTERED_LIST=`filter_packages "$INSTALL_CMDS" "$UNINSTALL_PKGS"`
installs_from "$FILTERED_LIST"
FILTERED_LIST=`filter_packages "$INSTALL_FROM" "$UNINSTALL_PKGS"`
installs_from "$FILTERED_LIST"
FILTERED_LIST=`filter_packages "$CUSTOM_PKG" "$UNINSTALL_PKGS"`
installs_from "$FILTERED_LIST"

if [ -z $MACOS ]; then
	file_has_text "/etc/gpm.conf" "append='-B 321'" "console mouse driver reversed button order"
fi # not MACOS

BAIL_OUT install

if [ ! -z "$NODE_PKG" ]; then
	FILTERED_LIST=`filter_packages "$NODE_PKG_LIST" "$UNINSTALL_PKGS"`
	echo NODE PKGS: $FILTERED_LIST
	#  brew link node   may be needed on MACOS if node installed but not linked
	installs_from "$FILTERED_LIST"
	if [ -z $MACOS ]; then
		dir_exists "$NODE_LIB" "global node command"
	fi
fi

BAIL_OUT node

[ ! -z "$USE_KDE" ] && [ ! -z "$KSCREENSAVER_PKG" ] && install_command_from_packages kslideshow.kss "$SCREENSAVER_PKG"
[ ! -z "$SCREENSAVER_PKG" ] && install_command_from_packages xscreensaver "$SCREENSAVER_PKG"

BAIL_OUT screensaver

install_perl_modules "$PERL_MODULES"

BAIL_OUT perl

[ ! -z "$RUBY_PKG" ] && install_ruby_gems "$RUBY_GEMS"

BAIL_OUT ruby

FILTERED_LIST=`filter_packages "$INSTALL_FILE_PACKAGES" "$UNINSTALL_PKGS"`
installs_from "$FILTERED_LIST"

BAIL_OUT files

if [ ! -z "$PINTA_PKG" ]; then
	sudo add-apt-repository ppa:pinta-maintainers/pinta-stable
	sudo apt-get update
	sudo apt-get install "$PINTA_PKG"
fi

if [ ! -z "$NODE_PKG" ]; then
	if $NODE_CMD --version | grep $NODE_VER; then
		OK "node command version correct"
	else
		GOTVER=`$NODE_CMD --version`
		NOT_OK "node command version incorrect. trying to update: $GOTVER to $NODE_VER $NODE_CMD"
		if [ -z $MACOS ]; then
			echo HEREIAM STOP NODE
			exit 88
			#https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#wiki-ubuntu-mint-elementary-os
			sudo apt-get update
			sudo apt-get install -y python-software-properties python g++ make
			sudo add-apt-repository ppa:chris-lea/node.js
			sudo apt-get update
			sudo apt-get install nodejs
			exit 1
		else
			# MACOS node upgrade
			if [ ! -z "$NODE_BREW" ]; then
				# https://apple.stackexchange.com/questions/171530/how-do-i-downgrade-node-or-install-a-specific-previous-version-using-homebrew
				brew unlink node
				brew install $NODE_BREW
				brew link $NODE_BREW
				/usr/local/bin/node --version
			fi
			GOTVER=`$NODE_CMD --version`
			NOT_OK "node upgrade $GOT_VER to $NODE_VER using $NODE_BREW check if it worked."
			exit 1
		fi
	fi

	if [ ! -z "$N_VER" ]; then
		if which $N_CMD > /dev/null; then
			OK "n command exists"
		else
			always_install_npm_global_from $N_CMD
		fi
		if $N_CMD --version | grep $N_VER; then
			OK "n command version correct"
		else
			GOTVER=`$N_CMD --version`
			NOT_OK "n command version incorrect, expected $N_VER"
			exit 99
		fi
		for ver in $N_VERS
		do
			install_node $ver
		done
	fi

	if [ ! -z $PNPN_VER ]; then
		if $PNPM_CMD --version | grep $PNPM_VER; then
			OK "pnpm command version correct"
		else
			GOTVER=`$PNPM_CMD --version`
			NOT_OK "MAYBE pnpm command version incorrect, expected $PNPM_VER will try to upgrade"
			# npm install -g pnpm
			$PNPM_CMD install -g $PNPM_NPM_PKG
			if $PNPM_CMD --version | grep $PNPM_VER; then
				OK "pnpm command version correct"
			else
				GOTVER=`$PNPM_CMD --version`
				NOT_OK "pnpm command failed to upgrade to version $PNPM_VER, got version $GOTVER"
				exit 93
			fi
		fi
	fi

	npm config set registry https://registry.npmjs.org/
	echo $NPM_GLOBAL_PKG_LIST > npm-pkg.txt
	if [ ! -z "$UNINSTALL_NPM_GLOBAL_PKGS" ]; then
		uninstall_npm_global_packages "$UNINSTALL_NPM_GLOBAL_PKGS"
	fi
	FILTERED_LIST=`filter_packages "$NPM_GLOBAL_PKG_LIST" "$UNINSTALL_NPM_GLOBAL_PKGS"`
	if [ ! -z "$FRESH_NPM" ]; then
		always_install_npm_global_from npm
		always_install_npm_globals_from "$FILTERED_LIST"
	fi
	install_npm_global_commands_from "$FILTERED_LIST"
	dir_exists "$NODE_MOD" "global node_modules"
	node_module_exists path "test that node module checking works"
	is_npm_global_package_installed grunt "need grunt installed to go further."
	if [ ! -z "$NVM_URL" ]; then
		echo node version before nvm: `node --version`
		NVM_INST="$DOWNLOAD/nvm/install.sh"
		make_dir_exist "$DOWNLOAD/nvm" "install script for nvm"
		install_file_from_url "$NVM_INST" nvm/install.sh "$NVM_URL"
		file_exists "$NVM_CMD" "nvm environment startup installed" || (chmod +x $NVM_INST && bash -c "$NVM_INST" && echo "Start a new terminal to activate nvm")
		set +e
		command -v nvm || (NOT_OK "nvm function not installed will try loading it" \
			&& export NVM_DIR && source "$NVM_CMD" install $NVM_LTS_VER --lts --reinstall-packages-from=system || echo "NOT OK MAYBE lets see if loading nvm worked. If not, you should start a new terminal and make sure the nvm command is present"; \
			nvm ls && nvm ls-remote | tail)
		set -e
		echo MAYBE YOUDO manually: nvm install $NVM_LTS_VER --lts --reinstall-packages-from=system
		echo MAYBE YOUDO manually: nvm install $NVM_LATEST_VER --reinstall-packages-from=system
		dir_exists "$NVM_VER_DIR/$NVM_LTS_VER" "node long term stable version installed" || nvm install $NVM_LTS_VER --lts --reinstall-packages-from=system
		dir_exists "$NVM_VER_DIR/$NVM_LATEST_VER" "node latest version installed" || nvm install $NVM_LATEST_VER --reinstall-packages-from=system
		file_exists "$HOME/.nvmrc" "nvm version configuration" || (echo "$NVM_LATEST_VER" > "$HOME/.nvmrc" && echo "YOUDO manually issue command nvm use $NVM_LATEST_VER")
		echo node version after nvm: `node --version`
	fi
else
	OK "will not configure npm unless NODE_PKG is non-zero"

	make_dir_exist $HOME/.grunt-init "grunt template dir"
	# need to upload ssh public key to github before getting grunt templates
	install_grunt_templates_from "$INSTALL_GRUNT_TEMPLATES"
fi

BAIL_OUT npm

if [ ! -z "$DROPBOX_URL" ]; then
	if [ ! -z $MACOS ]; then
		if ps -efww | grep -v grep | grep Dropbox.app > /dev/null; then
			OK "dropbox daemon is running"
		else
			NOT_OK "dropbox daemon is not running, you need to manually install dropbox"
		fi
	else
		make_dir_exist workspace/dropbox-dist "dropbox distribution files"
		file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd "dropbox installed" || (pushd workspace/dropbox-dist && wget -O - "$DROPBOX_URL" | tar xzf - && ./.dropbox-dist/dropboxd & popd)
		file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd
		if ps -ef --cols 256 | grep -v grep | grep dropbox-dist > /dev/null; then
			OK "dropbox daemon is running"
		else
			NOT_OK "dropbox daemon is not running, will try to start it"
			dropbox.sh
		fi
	fi
fi

BAIL_OUT dropbox

if [ ! -z "$MVN_PKG" ]; then
	cmd_exists mvn
	if mvn --version | grep "Apache Maven " | grep $MVN_VER; then
		OK "mvn command version correct"
	else
		NOT_OK "mvn command version incorrect"
		exit 1
	fi

	if [ -z $MACOS ]; then
		if [ "x$M2_HOME" == "x/usr/share/maven" ]; then
			OK "M2_HOME set correctly"
		else
			NOT_OK "M2_HOME is incorrect $M2_HOME"
			exit 1
		fi
	fi
else
	OK "will not configure maven unless MVN_PKG is non-zero"
fi # MVN_PKG

BAIL_OUT maven

if [ ! -z "$SLACK_PKG" ]; then
	install_command_package_from_url $SLACK_CMD $SLACK_PKG $SLACK_URL "slack messaging system"
else
	OK "will not configure slack messenger unless SLACK_PKG is non-zero"
fi

if [ ! -z "$SKYPE_PKG" ]; then
	install_command_package_from_url $SKYPE_CMD $SKYPE_PKG $SKYPE_URL "skypeforlinux messaging system"
else
	OK "will not configure skypeforlinux unless SKYPE_PKG is non-zero"
fi

if [ ! -z $MACOS ]; then
	install_command_package_from_url "$ITERM_CMD" $ITERM_PKG $ITERM_URL "iTerm2 terminal program"
	app_exists "$ITERM_CMD" "you must manually install downloaded iTerm2 dmg file and sudo -i ln -s 'iTerm 2.app' '/Applications/iTerm2.app'"

#	install_command_package_from_url $KARABINER_CMD $KARABINER_PKG $KARABINER_URL "Karabiner-Elements keyboard remapper program"
#	app_exists Karabiner-Elements.app "you must manually install downloaded Karabiner dmg file"
fi

commands_exist "$COMMANDS"
BAIL_OUT commands

#============================================================================
# end of standard install, now custom install

echo CRON table setup
crontab_has_command "mkdir" "* * * * * mkdir -p /tmp/\$LOGNAME 2> /dev/null && set > /tmp/\$LOGNAME/crontab-set.log 2>&1" "crontab user temp dir creation and env var dump"
crontab_has_command "mkdir"
crontab_has_command "CRITICAL" "* * * * * \$HOME/bin/check-disk-space.sh 95 CRITICAL 2> /dev/null > /dev/null" "crontab warn about critical disk space issues"
crontab_has_command "CRITICAL"
crontab_has_command "check-disk-space.sh" "* * * * * \$HOME/bin/check-disk-space.sh 95 CRITICAL 2> /dev/null > /dev/null
" "crontab warn about low disk space"
crontab_has_command "check-disk-space.sh"
#15 20,22 * * 1-5           $HOME/bin/ezbackup.sh  > /tmp/$LOGNAME/crontab-ezbackup.log 2>&1
#15 8,13,20 * * 6-7         $HOME/bin/ezbackup.sh  > /tmp/$LOGNAME/crontab-ezbackup.log 2>&1
crontab_has_command "ezbackup.sh"
crontab_has_command "track-battery.pl" "* * * * * \$HOME/bin/track-battery.pl > /tmp/\$LOGNAME/crontab-track-battery.log 2>&1" "crontab warn about battery drain"
crontab_has_command "track-battery.pl"

if [ -z $MACOS ]; then
	crontab_has_command "wcdscan.sh" "*/10 9,10,11,12,13,14,15,16,17,18 * * * \$HOME/bin/wcdscan.sh > /tmp/\$LOGNAME/crontab-wcdscan.log 2>&1" "crontab update change dir scan"
	crontab_has_command "wcdscan.sh"
	crontab_has_command "random-desktop.sh" "0,15,30,45 * * * * DISPLAY=:0 \$HOME/bin/random-desktop.sh > /tmp/\$LOGNAME/crontab-random-desktop.log 2>&1" "crontab change desktop background"
	crontab_has_command "random-desktop.sh"
else
	echo "MAYBE YOUDO You need to drag /usr/sbin/cron to System Preferences > Security & Privacy > Privacy > Full Disk Access Panel in order to grant it full access to scan your files. open /usr/sbin"
	crontab_has_command "scan-tree.sh" "*/19 * * * * \$HOME/bin/scan-tree.sh \$HOME \$HOME/scan- > /tmp/\$LOGNAME/crontab-scan-tree.log  2>&1" "crontab scan home directory files for lokate.sh command"
	crontab_has_command "scan-tree.sh"
fi # not MACOS

if [ ! -z "$COMPANY" ]; then
	file_linked_to bin/backup-work.sh $HOME/bin/cfg/$COMPANY/backup-work-$COMPANY.sh "daily backup script"
	file_linked_to bin/backup-work-manual.sh $HOME/bin/cfg/$COMPANY/backup-work-manual-$COMPANY.sh "manual backup script"
	file_linked_to bin/get-from-home.sh $HOME/bin/cfg/$COMPANY/get-from-home-$COMPANY.sh "unpacker script for work at home"
	cmd_exists backup-work.sh "backup script missing"/
	cmd_exists get-from-home.sh "unpacker script for work at home"

	file_exists bin/cfg/$COMPANY/crontab-$HOSTNAME "crontab missing" || backup-work.sh
	crontab_has_command "backup-work.sh" "30 17,18 * * * \$HOME/bin/backup-work.sh > /tmp/\$LOGNAME/crontab-backup-work.log 2>&1" "crontab daily backup configuration"
	crontab_has_command "backup-work.sh"
	if [ -z $MACOS ]; then
		crontab_has_command "night.sh"
		crontab_has_command "brighter.sh"
	fi # not MACOS
else
	#*/7 19,20,21,22,23 * * 1-5 $HOME/bin/retag.sh all > /tmp/$LOGNAME/crontab-retag.log    2>&1
	#*/7 * * * 6-7              $HOME/bin/retag.sh all > /tmp/$LOGNAME/crontab-retag.log    2>&1
	crontab_has_command "retag.sh"
fi

BAIL_OUT crontab

if which prettydiff > /dev/null; then
	file_present prettydiff.js "html beautifier file"
fi

if [ ! -z "$EMACS_PKG" ]; then
	install_file "$HOME/.emacs" "$HOME/bin/cfg/.emacs" "emacs configuration file exists"
	files_same "$HOME/.emacs" "$HOME/bin/cfg/.emacs" "emacs configuration changes"
	copy_dir "$HOME/.emacs.d/lisp" "$HOME/bin/cfg/.emacs.d/lisp" "emacs lisp dir with my scripts"
	copy_dir "$HOME/test/copy" "$HOME/bin/cfg/.emacs.d/lisp" "emacs lisp dir with my scripts"
	file_exists "$HOME/.emacs.d/lisp/bsac.el" "emacs lisp dir has my startup script"
	file_has_text "$HOME/.emacs" "~/.emacs.d/lisp" ".emacs loads my lisp dir configs vdiff ~/bin/cfg/.emacs ~/cfg/.emacs"
	file_exists "$HOME/.emacs.d/elpa/ztree-readme.txt" "emacs melpa packages need to be installed see MANUAL instructions"
	# to install all the needed emacs packages
	# cp ~/bin/cfg/emacs.pkg.el ~/.emacs.d/lisp
	# then start emacs, packages should install...
	# then rm ~/.emacs.d/list/emacs.pkg.el
fi

# generate javascript tags for emacs
# ctags -e -R --extra=+fq --exclude=db --exclude=test --exclude=.git --exclude=public -f TAGS
# save .ctags config for better javascript
# TODO how to use the TAGS file in emacs?

if [ ! -z "$ATOM_PKG" ]; then
	ARCHIVED="$DOWNLOAD/atom-v$ATOM_VER-$ATOM_PKG"
	echo "MAYBE atom check if archived $ARCHIVED"
	if [ ! -e $ARCHIVED ]; then
		[ -e "$DOWNLOAD/$ATOM_PKG" ] && rm "$DOWNLOAD/$ATOM_PKG"
		if [ -z $MACOS ]; then
			install_command_package_from_url $ATOM_CMD "$ATOM_PKG" "$ATOM_URL" "github atom editor" || true
		else
			install_file_from_url_zip "$DOWNLOAD/Atom.app/Contents/PkgInfo" "$ATOM_PKG" "$ATOM_URL" "github atom editor for MACOS - run again to extract and copy..."
			[ -e "$DOWNLOAD/Atom.app" ] && cp -r "$DOWNLOAD/Atom.app" /Applications && rm -rf "$DOWNLOAD/Atom.app"
		fi
	fi
	cmd_or_app_exists $ATOM_APP
	cmd_exists $ATOM_CMD
	cmd_exists apm "atom package manager"
	if atom --version | grep Atom | grep $ATOM_VER; then
		OK "atom $ATOM_VER installed"
		if [ ! -z $ATOM_APM ]; then
			OK "atom ATOM_APM will install packages $ATOM_APM_PKG"
			install_apm_modules_from "$ATOM_APM_PKG"
		else
			OK "atom !ATOM_APM will skip installing packages $ATOM_APM_PKG"
		fi
		echo MAYBE atom move to archived $ARCHIVED
		[ -e "$DOWNLOAD/$ATOM_PKG" ] && mv "$DOWNLOAD/$ATOM_PKG" $ARCHIVED
	else
		atom --version
		NOT_OK "atom $ATOM_VER not installed"
	fi
else
	OK "will not configure atom editor unless ATOM_PKG is non-zero"
fi

if [ ! -z "$SUBLIME_PKG" ]; then
	install_command_package_from_url $SUBLIME_CMD $SUBLIME_PKG $SUBLIME_URL "sublime editor"
	if [ ! -z "$SUBLIME_CFG" ]; then
		cmd_exists git "need git installed before configure sublime"
		cmd_exists grunt "need grunt installed before configure sublime for it"

		# package nodejs-legacy provides node -> nodejs symlink
		#file_linked_to /usr/bin/node /usr/bin/nodejs "grunt needs node command at present, not updated to nodejs yet"
		cmd_exists node "grunt needs node command at present, not updated to nodejs yet"
		install_file_from_url $DOWNLOAD/Package-Control.sublime-package.zip Package-Control.sublime-package.zip "http://sublime.wbond.net/Package%20Control.sublime-package" "sublime package control bundle"
		#cp $DOWNLOAD/Package-Control.sublime-package.zip "$SUBLIME_CFG/Installed Packages/Package Control.sublime-package"
		install_file_manually "$SUBLIME_CFG/Installed Packages/Package Control.sublime-package" "sublime package control from instructions" "https://sublime.wbond.net/installation"
		install_git_repo "$SUBLIME_CFG/Packages" sublime-grunt-build git://github.com/jonschlinkert/sublime-grunt-build.git "sublime text grunt build package - check for Tools/Build System/Grunt after -- May have to correct syntax in print('BuildGruntOnSave: on_post_save')"
		## TODO - maybe not sublime build may be working ... install_file_manually "$SUBLIME_CFG/Packages/Grunt/SublimeGrunt.sublime-settings" "sublime grunt build system" "https://www.npmjs.org/package/sublime-grunt-build"
	fi
	commands_exist "$SUBLIME_CMD"
fi # SUBLIME_PKG

if [ ! -z "$WEBSTORM_ARCHIVE" ]; then
	install_file_from_url_zip "$WEBSTORM_EXTRACTED" "$WEBSTORM_ARCHIVE.tar.gz" "$WEBSTORM_URL" "download webstorm installer"
	cmd_exists $WEBSTORM_CMD "you need to manually install WebStorm with WebStorm.sh command from $DOWNLOAD/$WEBSTORM_ARCHIVE dir"
	dir_linked_to bin/WebStorm $WEBSTORM_EXTRACTED_DIR "current WebStorm dir linked to bin/WebStorm"
	# RUN_PATH = u'/home/bcowgill/bin/WebStorm/bin/webstorm.sh'
	# CONFIG_PATH = u'/home/bcowgill/.WebStorm2016.2/config'
	file_has_text "/usr/local/bin/wstorm" "$HOME/bin/WebStorm" "webstorm refers to current link"
	file_has_text "/usr/local/bin/wstorm" "$HOME/.$WEBSTORM_CONFIG/config" "webstorm refers to config dir"
fi # WEBSTORM_ARCHIVE

if [ ! -z "$VSLICK_ARCHIVE" ]; then
	install_file_from_url_zip "$VSLICK_EXTRACTED" "$VSLICK_ARCHIVE.tar.gz" "$VSLICK_URL" "download visual slick edit installer"
	cmd_exists $VSLICK_CMD "you need to manually install visual slick edit with vsinst command from $DOWNLOAD/$VSLICK_ARCHIVE dir"
fi # VSLICK_ARCHIVE

VIM_AUTOLOAD=~/.vim/autoload
VIM_PLUG_URL=https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

if file_exists "$VIM_AUTOLOAD/plug.vim"; then
	OK "vim plug has been installed"
else
	make_dir_exist "$VIM_AUTOLOAD" "vim autoload directory exists"
	curl -fLo $VIM_AUTOLOAD/plug.vim --create-dirs $VIM_PLUG_URL
	NOT_OK "MAYBE you need to manually run vim and execute :PlugInstall command once."
	file_exists "$VIM_AUTOLOAD/plug.vim" "vim plug plugin manager"
fi

BAIL_OUT editors

if [ ! -z "$USE_SCHEMACRAWLER" ]; then
	if [ ! -z "$USE_POSTGRES" ]; then
		# postgres JDBC driver for creating DB schema diagrams using schemacrawler
		# http://jdbc.postgresql.org/download.html
		POSTGRES_JDBC_JAR=postgresql-9.3-1102.jdbc41.jar
		POSTGRES_JDBC_URL=http://jdbc.postgresql.org/download/$POSTGRES_JDBC_JAR
		POSTGRES_JDBC_DIR=/usr/share/java
		cmd_exists java "must have java installed for JDBC/schemacrawler"
		install_file_from_url $DOWNLOAD/$POSTGRES_JDBC_JAR $POSTGRES_JDBC_JAR "$POSTGRES_JDBC_URL" "postgres JDBC jar file for using schemacrawler"
		file_exists $POSTGRES_JDBC_DIR/$POSTGRES_JDBC_JAR > /dev/null || (NOT_OK "postgres JDBC jar missing in java dir, will copy it"&& sudo cp "$DOWNLOAD/$POSTGRES_JDBC_JAR" "$POSTGRES_JDBC_DIR" )
		file_exists $POSTGRES_JDBC_DIR/$POSTGRES_JDBC_JAR

		# schemacrawler with postgres JDBC driver included
		SCHEMA_VER=10.10.05
		SCHEMA_POSTGRES_ZIP=schemacrawler-postgresql-$SCHEMA_VER-distrib.zip
		SCHEMA_POSTGRES_URL=http://sourceforge.net/projects/schemacrawler/files/SchemaCrawler%20-%20PostgreSQL/$SCHEMA_VER/$SCHEMA_POSTGRES_ZIP/download
		install_file_from_url_zip $DOWNLOAD/schemacrawler-postgresql-$SCHEMA_VER/sc.sh $SCHEMA_POSTGRES_ZIP "$SCHEMA_POSTGRES_URL" "schemacrawler with postgres JDBC driver"
		file_is_executable $DOWNLOAD/schemacrawler-postgresql-$SCHEMA_VER/sc.sh "need executable permission"
	fi # USE_POSTGRES

	if [ ! -z "$USE_MYSQL" ]; then
		# schemacrawler with mysql JDBC driver included
		SCHEMA_MYSQL_ZIP=schemacrawler-mysql-$SCHEMA_VER-distrib.zip
		SCHEMA_MYSQL_URL=http://sourceforge.net/projects/schemacrawler/files/SchemaCrawler%20-%20MySQL/$SCHEMA_VER/$SCHEMA_MYSQL_ZIP/download
		install_file_from_url_zip $DOWNLOAD/schemacrawler-mysql-$SCHEMA_VER/sc.sh $SCHEMA_MYSQL_ZIP "$SCHEMA_MYSQL_URL" "schemacrawler with mysql JDBC driver"
		file_is_executable $DOWNLOAD/schemacrawler-mysql-$SCHEMA_VER/sc.sh "need executable permission"
	fi # USE_MYSQL
fi # USE_SCHEMACRAWLER

if [ ! -z "$USE_MONGO" ]; then
	if [ ! -z "$ROBO3T_ARCHIVE" ]; then
		install_file_from_url_zip "$ROBO3T_EXTRACTED" "$ROBO3T_ARCHIVE.tar.gz" "$ROBO3T_URL" "download mongo db robo 3T UI"
		dir_linked_to bin/robo3t $ROBO3T_EXTRACTED_DIR "current robo3t dir linked to bin/robo3t"
		cmd_exists $ROBO3T_CMD "robo3t runner script present"
	fi # ROBO3T_ARCHIVE
fi # USE_MONGO

BAIL_OUT custom

cmd_exists git "need git to clone repos"
make_dir_exist workspace/play "github repo play area"
for repo in $MY_REPOS; do
	install_git_repo "workspace/play" $repo $GITHUB_URL/$repo.git "my github repo $repo"
done

BAIL_OUT repos

if [ ! -z "$DOCKER_PKG" ]; then
	cmd_exists $DOCKER_CMD || (sudo apt-get update && sudo apt-get install $DOCKER_PRE)
	apt_has_key_adv $DOCKER_KEYCHK $DOCKER_KEY $DOCKER_KEYSVR "key fingerprint for Docker Engine"
	apt_has_source_listd docker "https://apt.dockerproject.org/repo ubuntu-$LSB_RELEASE main" "Adding source for docker to apt"
	cmd_exists $DOCKER_CMD || (sudo apt-get update && apt-cache policy $DOCKER_PKG | grep apt.dockerproject.org/repo && install_command_from $DOCKER_CMD $DOCKER_PKG)
	add_user_to_group $DOCKER_GRP $AUSER "allow docker to be started without root permissions"
fi # DOCKER_PKG

BAIL_OUT docker

if [ ! -z "$VPN_PKG" ]; then
	# https://www.linux.com/learn/tutorials/457103-install-and-configure-openvpn-server-on-linux
	# for VPN after installing bridge-utils need to restart network
	#[14:48:25] Bruno Bossola: Manuel Morales to Linux Users
	#"Habemus VPN! And it works from the UI. I followed this http://labnotes.decampo.org/2012/12/ubuntu-1210-connect-to-microsoft-vpn.html
	#See my screenshots for Workshare specific config. "

	FILE="$VPN_CONFIG"
	file_exists "$FILE" "vpn bridge configuration" || copy_file_to_root "$HOME/bin/cfg$COMP/bridge-vpn" "$FILE" "install vpn config for iface br0 inet static"
	file_has_text "$FILE" "iface br0 inet static"

	if [ -z "$HAD_VPN_CONFIG" ]; then
		OK "restart network after vpn bridge configuration"
		sudo /etc/init.d/networking restart
	fi
fi # VPN_PKG

BAIL_OUT vpn

if [  ! -z "$PHP_PKG" ]; then
	# install composer php package manager
	cmd_exists $PHP_CMD "need php command"
	if cmd_exists composer; then
		echo OK PHP composer package manager preset
	else
		$PHP_CMD -r "copy('https://getcomposer.org/installer', '$DOWNLOAD/composer-setup.php');"
		$PHP_CMD -r "if (hash_file('SHA384', '$DOWNLOAD/composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'OK PHP composer installer verified'; } else { echo 'NOT OK PHP composer installer corrupt'; unlink('$DOWNLOAD/composer-setup.php'); } echo PHP_EOL;"
		$PHP_CMD "$DOWNLOAD/composer-setup.php"
		sudo mv ~/composer.phar /usr/local/bin/composer
		cmd_exists composer
	fi
fi

commands_exist "$COMMANDS_CUSTOM"
BAIL_OUT php

# HEREIAM CUSTOM INSTALL

#============================================================================
# end of main installing, now configuring

pushd bin/fortune
	./mk-fortune.sh
popd

if [ ! -z "$DROPBOX_URL" ]; then
	# Dropbox configuration
	# TODO workshare re-enable
	#dir_exists .config/autostart "System Settings / Startup & Shutdown / Autostart"
	# TODO workshare customise file and copy?
	if [ -d .config/autostart/ ]; then
		file_exists workspace/dropbox-dist/dropboxd.desktop "dropbox autostart saved"
		file_exists .config/autostart/dropboxd.desktop "dropbox autostart" || (cp workspace/dropbox-dist/dropboxd.desktop .config/autostart/dropboxd.desktop)
	fi
	if [ -e $HOME/Dropbox/Photos/Wallpaper/WorkSafe ]; then
		dir_linked_to Pictures/WorkSafe $HOME/Dropbox/Photos/Wallpaper/WorkSafe "link pictures dir to WorkSafe screen saver images"
	else
		dir_linked_to Pictures/WorkSafe $HOME/Dropbox/WorkSafe "link pictures dir to WorkSafe screen saver images"
	fi
fi # DROPBOX_URL

# Mobile phone mounting setup
# http://www.mysolutions.it/mounting-your-mtp-androids-sd-card-on-ubuntu/
# Device 0 (VID=04e8 and PID=6860) is a Samsung Galaxy models (MTP).
if which mtpfs; then
	if [ ! -d /media/mtp ]; then
		if [ ! -e ~/.mtpz-date ]; then
			pushd ~ ; wget https://raw.githubusercontent.com/kbhomes/libmtp-zune/master/src/.mtpz-data; popd
		fi
		make_root_dir_exist /media/mtp "set up mount point for MTP devices"
		sudo chmod 755 /media/mtp
		sudo mtpfs -o allow_other /media/mtp
	fi
fi

# Check mysql configuration options
FILE=.my.cnf
file_has_text "$FILE" "safe-updates" "prevent big deletes from tables"
file_must_not_have_text "$FILE" "#safe-updates" "make sure not commented out"

FILE=".config/leafpad/leafpadrc"
maybe_file_has_text $FILE "ProFontWindows 18"

FILE=-.config/lxterminal/lxterminal.conf
maybe_file_has_text $FILE "ProFontWindows 18"
maybe_file_has_text $FILE "bgcolor=#000000000000"
maybe_file_has_text $FILE "fgcolor=#fffffcee0000"

# git config gui Font
FILE=".gitconfig"
git config --global gui.fontdiff "-family ProFontWindows -size 18 -weight normal -slant roman -underline 0 -overstrike 0"
ini_file_has_text "$FILE" "gui/fontdiff = -family ProFontWindows -size 18 -weight normal -slant roman -underline 0 -overstrike 0" "git gui font Edit / Options"
if [ -z $MACOS ]; then
	ini_file_has_text "$FILE" "gui/fontui = -family FreeSans -size 14 -weight normal -slant roman -underline 0 -overstrike 0" "git gui UI font Edit / Options"
else
	ini_file_has_text "$FILE" "gui/fontui = -family LucidaSans -size 14 -weight normal -slant roman -underline 0 -overstrike 0" "git gui UI font Edit / Options"
fi
ini_file_has_text "$FILE" "gui/tabsize = 4" "git gui tabsize Edit / Options"

# gitk configuration
FILE=.config/git/gitk
if [ -f "$FILE" ]; then
	# There are other colors in the config file which are not in the UI
	file_has_text "$FILE" "set mainfont {ProFontWindows 18}" "Edit / Preferences / Font"
	file_has_text "$FILE" "set textfont {ProFontWindows 18}" "Edit / Preferences / Font"
	if [ -z $MACOS ]; then
		file_has_text "$FILE" "set uifont {{DejaVu Sans} 12 bold}" "Edit / Preferences / Font"
	else
		file_has_text "$FILE" "set uifont {{Lucida Grande} 12 bold}" "Edit / Preferences / Font"
	fi
	file_has_text "$FILE" "set uicolor black" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set bgcolor #001000" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set fgcolor #ff58ff" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set diffcolors {red #00a000 #00ebff}" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set markbgcolor #002c39" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set selectbgcolor #20144c" "Edit / Preferences / Colors"
fi # gitk config file

# Meld diff colors
FILE=".gconf/apps/meld/%gconf.xml"
if [ -f "$FILE" ]; then
	file_contains_text $FILE "use_custom_font.+true" "Edit / Preferences"
	file_has_text $FILE "custom_font" "Edit / Preferences"
	file_has_text $FILE "<stringvalue>ProFontWindows 18" "Edit / Preferences"
	file_has_text $FILE "edit_command_custom" "Edit / Preferences"
	file_has_text $FILE "<stringvalue>i3-sensible-gui-editor" "Edit / Preferences"
	file_contains_text $FILE "use_syntax_highlighting.+true" "Edit / Preferences"
	file_contains_text $FILE "show_whitespace.+true" "Edit / Preferences"
	file_contains_text $FILE "show_line_numbers.+true" "Edit / Preferences"
fi # meld diff/merge config file

# KDE configuration files here
if [ ! -z "$USE_KDE" ]; then
if [ -d .kde ]; then
	DIR=.local/share/applications
	dir_exists $DIR "KDE applications folder"

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
	# this scheme is very dark but not so good with Visual Slick Edit
	#file_has_text $FILE "ColorScheme=Zion .Reversed." "System Settings / Application Appearance / Colors"
	# this scheme is dark and works well with Visual Slick Edit
	file_has_text $FILE "ColorScheme=Obsidian Coast" "System Settings / Application Appearance / Colors"
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
	if [ ! -z "$THUNDER" ]; then
		FILE=.kde/share/config/emaildefaults
		file_contains_text $FILE "EmailClient..e.=thunderbird"
	fi

	FILE=.kde/share/config/kdeglobals
	file_has_text $FILE "BrowserApplication=chromium-browser.desktop"
	#KDE file_has_text $FILE "BrowserApplication..e.=chromium-browser.desktop"

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
	file_has_text "$FILE" "Saver=KSlideshow.desktop" "screensaver configured System Settings / Display and Monitor / Screen Locker"
	#file_has_text "$FILE" "Saver=bsod.desktop" "screensaver configured System Settings / Display and Monitor / Screen Locker"
	file_has_text "$FILE" "Timeout=1200" "screensaver activation time configured"
	file_has_text "$FILE" "LockGrace=60000" "screensaver lock time configured"

	FILE=.kde/share/config/kslideshow.kssrc
	file_has_text "$FILE" "Dropbox/WorkSafe" "screensaver dir configured"
	file_has_text "$FILE" "SubDirectory=true" "screensaver subdirs"

	# .xscreensaver
	# Photopile is a good one

	# uk/us keyboard layout
	FILE=.kde/share/config/kxkbrc
	file_has_text "$FILE" "LayoutList=gb(extd),us" "keyboard layout System Settings / Input Devices / Keyboard / Layouts / Configure Layouts"

	# baloo KDE file indexer can choke on big files, set it up better
	# If you see baloo_file_extractor hogging your CPU do this to find out which files are the problem
	# ps -ef --cols 256 | grep baloo_file_extractor
	# to see the ID's being scanned
	# balooshow ID ID ID
	FILE=.kde/share/config/baloofilerc
	ini_file_contains_key_value "$FILE" "/General/exclude filters" "*.CSV" "baloo KDE file indexer can choke on big files, set it up better"
	ini_file_contains_key_value "$FILE" "/General/exclude filters" "*.csv" "baloo KDE file indexer can choke on big files, set it up better"

	# okular PDF viewer invert colours
	FILE=.kde/share/config/okularpartrc
	ini_file_has_text "$FILE" "/Core General//Document/ChangeColors=true" "okular invert colors Settings / Accessibility"
	ini_file_must_not_have_text "$FILE" "/Core General//Document/RenderMode"
else
	OK "kde will not be configured unless .kde directory exists"
fi # .kde dir
fi # USE_KDE
# End KDE configuration
#============================================================================

if [ ! -z "$CHARLES_PKG" ]; then
	# Check charles configuration options
	FILE=.charles.config
	make_dir_exist tx/mirror/web "charles mirroring area"
	file_has_text $FILE "port>58008" "charles port config Proxy / Proxy Settings"
	file_has_text $FILE "enableSOCKSTransparentHTTPProxying>true" "charles proxy config"
	# this setting has just vanished in charles
	#file_has_text $FILE "lookAndFeel>GTK+" "charles look and feel Edit / Preferences / User Interface"
	file_has_text $FILE "displayFont>ProFontWindows" "charles font config Edit / Preferences / User Interface"
	file_has_text $FILE "displayFontSize>20" "charles font config Edit / Preferences / User Interface"
	file_has_text $FILE "showMemoryUsage>true" "charles memory usage config Edit / Preferences / User Interface"
	file_has_text $FILE "tx/mirror/web</savePath" "charles mirror config Tools / Mirror"

	if [ ! -z "$USE_KDE" ]; then
	if [ -d .kde ]; then
		FILE=.kde/share/config/kioslaverc
		# when system not proxied through charles
		#file_has_text $FILE "ProxyType=0" "system proxy config Alt-F2 / Proxy"
		#file_has_text $FILE "httpProxy=localhost:58008" "system proxy config to charles"
		# when proxying system through charles
		file_has_text $FILE "ProxyType=1" "system proxy config Alt-F2 / Proxy"
		file_has_text $FILE "httpProxy=localhost 58008" "system proxy config to charles"
	fi # .kde dir
	fi # USE_KDE
else
	OK "charles will not be configured unless CHARLES_PKG is non-zero"
fi # CHARLES_PKG

if [ ! -z $DIFFMERGE_PKG ]; then
	if [ -z $MACOS ]; then
		# Sourcegear Diffmerge colors
		cmd_exists ini-inline.pl "missing command to convert INI file to inline settings for search"
		FILE=".SourceGear DiffMerge"
		file_linked_to "$FILE" "$HOME/bin/cfg$COMP/$FILE" "SourceGear DiffMerge config linked"
		if [ -f "$FILE" ]; then
			#ini_file_has_text "$FILE" "/File/Font=16:76:ProFontWindows"
			#ini_file_has_text "$FILE" "/File/Font=11:76:ProFontWindows"
			ini_file_has_text "$FILE" "/File/Font=18:76:ProFontWindows"
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
	fi # diffmerge config file
	else
		# MACOS config
		FILE="Library/Preferences/com.sourcegear.DiffMerge.plist"

		files_same "$FILE" "$HOME/bin/cfg$COMP/$FILE" "DiffMerge MACOS properties. YOUDO copy the light or dark preferences in place or backup recent changes you made"

		FILE="Library/Preferences/SourceGear DiffMerge Preferences"
		files_same "$FILE" "$HOME/bin/cfg$COMP/$FILE" "DiffMerge MACOS preferences. YOUDO copy the light or dark preferences in place or backup recent changes you made"

		# Manually install Diffmerge preferences
		# cp ./cfg/wipro/Library/Preferences/com.sourcegear.DiffMerge.plist.dark /Users/bcowgill/bin/cfg/wipro/Library/Preferences/com.sourcegear.DiffMerge.plist
		# cp "./cfg/wipro/Library/Preferences/SourceGear DiffMerge Preferences.dark" "/Users/bcowgill/bin/cfg/wipro/Library/Preferences/SourceGear DiffMerge Preferences"

		# Manually update in git after a config change.
		# rvcp.sh ./cfg/wipro/Library/Preferences/com.sourcegear.DiffMerge.plist /Users/bcowgill/bin/cfg/wipro/Library/Preferences/com.sourcegear.DiffMerge.plist
		# rvcp.sh "./cfg/wipro/Library/Preferences/SourceGear DiffMerge Preferences" "/Users/bcowgill/bin/cfg/wipro/Library/Preferences/SourceGear DiffMerge Preferences"
	fi # not MACOS
fi # DIFFMERGE_PKG

if [ ! -z $P4MERGE_PKG ]; then
# Perforce p4merge colors
FILE=".p4merge/ApplicationSettings.xml"
file_linked_to "$FILE" "$HOME/bin/cfg/.p4merge-ApplicationSettings.xml" "Perforce Merge config linked"
if [ -f "$FILE" ]; then
	file_has_text $FILE "<family>ProFontWindows" "Edit / Preferences"
	file_has_text $FILE "<pointSize>14" "Edit / Preferences"
	file_contains_text $FILE "<String varName=.DiffOption.>db" "Edit / Preferences ignore line ending and white space length differences"
	file_contains_text $FILE "<Bool varName=.ShowTabsSpaces.>true" "Edit / Preferences"
	file_contains_text $FILE "<Bool varName=.TabInsertsSpaces.>false" "Edit / Preferences"
	file_contains_text $FILE "<Int varName=.TabWidth.>4" "Edit / Preferences"
	file_contains_text $FILE "<Bool varName=.ShowLineNumbers.>true" "Edit / Preferences"
fi # perforce merge config file
fi # P4MERGE_PKG

if [ ! -z "$SUBLIME_CFG" ]; then
	# sublime configuration
	FILE=$SUBLIME_CFG/Packages/User/Preferences.sublime-settings
	file_linked_to $FILE $HOME/bin/cfg/Preferences.sublime-settings
	file_has_text $FILE "Packages/Color Scheme - Default/Cobalt.tmTheme"
	file_has_text $FILE "ProFontWindows"
#	file_contains_text $FILE "font_size.: 16"
	file_contains_text $FILE "font_size.: 23"

	DIR="$SUBLIME_CFG/Packages/Theme - Default"
	FILE="$DIR/Default.sublime-theme"
	## TODO dir_exists "$DIR" "sublime theme override dir"
	## TODO file_linked_to "$FILE" $HOME/bin/cfg/Default.sublime-theme
	## TODO file_linked_to "$DIR/bsac_dark_tool_tip_background.png" $HOME/bin/cfg/bsac_dark_tool_tip_background.png
fi # SUBLIME_CFG

# Postgres pgadmin3 setup
FILE=.pgadmin3
if [ -f "$FILE" ]; then
	WHAT="Postgres pgadmin3 color scheme File / Options / Colours"
	ini_file_has_text "$FILE" "////Font=ProFontWindows 14" "$WHAT"
	ini_file_has_text "$FILE" "////DDFont=ProFontWindows 14" "$WHAT"
	ini_file_has_text "$FILE" "/frmQuery/Font=ProFontWindows 14" "$WHAT"
	ini_file_has_text "$FILE" "/frmQuery/ShowIndentGuides=true" "$WHAT"
	ini_file_has_text "$FILE" "/frmQuery/ShowLineEnds=true" "$WHAT"
	ini_file_has_text "$FILE" "/frmQuery/ShowWhitespace=true" "$WHAT"
	ini_file_has_text "$FILE" "/frmQuery/ShowLineNumber=true" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/MarginBackgroundColour=rgb(31, 5, 65)" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/ColourCaret=yellow" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour1=rgb(0, 127, 0)" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour2=rgb(0, 127, 0)" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour3=rgb(127, 127, 127)" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour4=rgb(0, 127, 127)" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour5=rgb(4, 194, 251)" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour6=rgb(127, 0, 127)" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour7=rgb(127, 0, 127)" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour10=yellow" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/Colour11=red" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/UseSystemBackground=false" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/UseSystemForeground=false" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/ColourBackground=black" "$WHAT"
	ini_file_has_text "$FILE" "/ctlSQLBox/ColourForeground=yellow" "$WHAT"

	WHAT="Postgres pgadmin3 misc settinggs"
	ini_file_has_text "$FILE" "////LogLevel=3" "$WHAT"
	ini_file_has_text "$FILE" "////ColumnNames=true" "$WHAT"
	ini_file_has_text "$FILE" "////KeywordsInUppercase=true" "$WHAT"
	ini_file_has_text "$FILE" "/Copy/ColSeparator=," "$WHAT"
	ini_file_has_text "$FILE" "/History/MaxQueries=1000" "$WHAT"
fi # pgadmin3 config file

if [ ! -z "$PIDGIN_SKYPE_PKG" ]; then
	if dpkg -l libpurple0 | grep 2.10.9 ; then
		NOT_OK "need version 2.10.11+ of libpurple for pidgin skype" || echo " "
	else
		NOT_OK "MAYBE you may be able to get pidgin skype working you need libpurple0 2.10.11 or better" || \
		dpkg -l libpurple0
	fi
fi

if [ "$HOSTNAME" == "raspberrypi" ]; then
	FILE="/etc/rc.local"
	config_has_text "/etc/rc.local" "ifup wlan0" "make sure wlan0 comes up on boot"


fi # raspberrypi

#============================================================================

# HEREIAM CONFIG CHECKS

function DISABLED {
# TODO pipe viewer - progress bar for pipes apt-get install pv

# TODO get unicode bitmap/fonts
# http://unifoundry.com/unifont.html
# wget http://unifoundry.com/pub/unifont-8.0.01/unifont-8.0.01.bmp
# wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont-8.0.01.ttf
# wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont_upper-8.0.01.ttf
# wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont_csur-8.0.01.ttf
# wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont_upper_csur-8.0.01.ttf
# wget http://unifoundry.com/pub/unifont-8.0.01/font-builds/unifont_sample-8.0.01.ttf

if false ; then
# TODO some notes on how to set up then robot framework browser test system
# for workshare.
# https://github.com/workshare/qa
	ROBOT_TEST="pip:python-pip"
	commands pip, pybot needed
	sudo apt-get install chromium-chromedriver
	sudo pip install robotframework==2.8.7
	sudo pip install robotframework-selenium2library==1.6.0
	sudo pip install ntplib
	sudo easy_install -U pip
	sudo pip install requests
	sudo pip install robotframework-debuglibrary
	sudo pip install robotframework-imaplibrary
fi

#HEREIAM INSTALL

if [ ! -z "$GOOGLE_CHROME_PKG" ]; then
	# flash player in google chrome
	# http://helpx.adobe.com/flash-player/kb/enable-flash-player-google-chrome.html

	# Linux Google Chrome v Chromium
	# https://code.google.com/p/chromium/wiki/ChromiumBrowserVsGoogleChrome
	# configs ~/.config/chromium or ~/.config/google-chrome for the different versions

	install_command_package $GOOGLE_CHROME "$GOOGLE_CHROME_PKG" "Google Chrome for Linux from manual download $GOOGLE_CHROME_URL"

	if [ ! -z "$FLASH_URL" ]; then
		install_file_from_url_zip_subdir "$FLASH_EXTRACTED" "$FLASH_ARCHIVE.tar.gz" "$FLASH_ARCHIVE" "$FLASH_URL" "download flash player for google chrome"
		dir_exists "$CHROME_PLUGIN" "google chrome browser plugins directory"
		file_exists "$CHROME_PLUGIN/libflashplayer.so" "will install flash player to google chrome plugins dir" || sudo cp "$FLASH_EXTRACTED" "$CHROME_PLUGIN"
		file_exists "$CHROME_PLUGIN/libflashplayer.so" "flash player to google chrome plugins"
		file_exists "/usr/bin/flash-player-properties" > /dev/null || (NOT_OK "flash player settings missing, will copy them" && sudo cp -r "$FLASH_EXTRACTED_DIR/usr/" /)
		file_exists "/usr/bin/flash-player-properties"
	fi # FLASH_URL
fi # GOOGLE_CHROME_PKG

# Thunderbird
if [ ! -z "$THUNDER" ]; then
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
	OK "thunderbird will not be configured unless THUNDER is non-zero"
fi # THUNDER

# Eclipse configuration (shortcut and font)
if [ ! -z "$USE_ECLIPSE" ]; then
	DIR=.local/share/applications
	file_exists eclipse/eclipse "Eclipse program"
	file_exists eclipse/Eclipse.desktop "Eclipse launcher"
	file_exists $DIR/Eclipse.desktop "Eclipse KDE menu item" || cp eclipse/Eclipse.desktop $DIR/Eclipse.desktop

	TEXT="ProFontWindows"
	DIR=workspace/.metadata/.plugins/org.eclipse.core.runtime/.settings
	file_has_text $DIR/org.eclipse.ui.workbench.prefs "$TEXT"
	file_has_text $DIR/org.eclipse.jdt.ui.prefs "$TEXT"
	file_has_text $DIR/org.eclipse.wst.jsdt.ui.prefs "$TEXT"
else
	OK "eclipse will not be configured unless USE_ECLIPSE is non-zero"
fi # USE_ECLIPSE

# libreoffice color changes
# difficult because of so much punctutation
#FILE=.config/libreoffice/4/user/registrymodifications.xcu
#filter-punct.pl $FILE > $FILE.nopunct
#file_has_text "$FILE.nopunct" #"LibreOffice']/CalcNotesBackground"><prop oor:name="Color" #oor:op="fuse"><value>1842204" "Tools / Options / Appearance"
#file_has_text "$FILE" "" "Tools / Options / Appearance"
#file_has_text "$FILE" "" "Tools / Options / Appearance"
#file_has_text "$FILE" "" "Tools / Options / Appearance"
#file_has_text "$FILE" "" "Tools / Options / Appearance"

# GitKraken https://www.gitkraken.com/download/linux-deb

# Smartgit cannot run on Pi, ARM platform
#SMARTGIT="http://www.syntevo.com/smartgit/download?file=smartgit/smartgit-generic-6_5_8.tar.gz"
#SMARTGIT="http://www.syntevo.com/downloads/smartgit/smartgit-generic-6_5_8.tar.gz"
#install_file_from_url_zip $DOWNLOAD/smartgit/bin/smartgit.sh smartgit-generic-6_5_8.tar.gz "$SMARTGIT" "Smart Git package must manually download: links $SMARTGIT"

echo TODO gvim font setting config

#============================================================================
} # DISABLED

pkg-list.sh > bin/cfg$COMP/pkg-list.txt
OK "updated bin/cfg$COMP/pkg-list.txt"

if [ ! -z $MACOS ]; then
	ls-mac-apps.sh | sort > bin/cfg$COMP/mac-apps.txt
	OK "updated bin/cfg$COMP/mac-apps.txt"
fi

if [ ! -z `which npm` ]; then
	npm -g --no-color list > bin/cfg$COMP/npm-pkg-list.txt 2>&1 || true
	OK "updated bin/cfg$COMP/npm-pkg-list.txt"
fi

if [ ! -z $ATOM_APM ]; then
	if [ ! -z `which apm` ]; then
		apm --no-color list > bin/cfg$COMP/atom-pkg-list.txt 2>&1 || true
		OK "updated bin/cfg$COMP/atom-pkg-list.txt"
	fi
fi

if [ ! -z `which cpanp` ]; then
	cpanp o > bin/cfg$COMP/cpanp-pkg-out-of-date.txt
	OK "updated bin/cfg$COMP/cpanp-pkg-out-of-date.txt"
	OUTPUT=`cpanp b | perl -ne '$q= chr(39); print if s{Wrote \s+ autobundle \s+ to \s+ $q(.+)$q}{$1}xms'`
	echo cpanp bundle file: "$OUTPUT"
	if [ ! -z "$OUTPUT" ]; then
		mv $OUTPUT bin/cfg$COMP/cpanp-autobundle.pm
		OK "updated bin/cfg$COMP/cpanp-autobundle.pm"
	fi
fi

popd

echo COMMANDS="$COMMANDS"
echo PACKAGES="$PACKAGES"


OK "all checks complete"
ENDS
