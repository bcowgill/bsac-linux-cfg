#!/bin/bash
# Check configuration to make sure things are ok and make them ok where possible
# check-system.sh 2>&1 | tee ~/check.log | grep 'NOT OK'

# Search for 'begin' for start of script

# To set up a new computer you can simply download and unzip anywhere
# wget https://github.com/bcowgill/bsac-linux-cfg/archive/master.zip && unzip master.zip
# cd bsac-linux-cfg-master/bin && PATH=$PATH:. ./cfg/check-system.sh
# start a new shell after first run so aliases and functions will be available

# terminate on first error
set -e
# turn on trace of currently running command if you need it
#set -x

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


set -o posix
set > check-system.env0.log
set +o posix

# set FRESH_NPM to reinstall npm packages so they are updated
#FRESH_NPM=1

# set BAIL_OUT to stop after a specific point reached
#BAIL_OUT=font
#BAIL_OUT=diff
#BAIL_OUT=install
#BAIL_OUT=node
#BAIL_OUT=screensaver
#BAIL_OUT=perl
#BAIL_OUT=ruby
#BAIL_OUT=files
#BAIL_OUT=npm
#BAIL_OUT=dropbox
#BAIL_OUT=commands
BAIL_OUT=crontab
#BAIL_OUT=

if which lib-check-system.sh; then
	source `which lib-check-system.sh`
else
	echo "NOT OK cannot find lib-check-system.sh"
	exit 1
fi

function BAIL_OUT {
	local stage
	stage=$1
	if [ "x$BAIL_OUT" == "x$stage" ]; then
		NOT_OK "BAIL_OUT=$BAIL_OUT is set, stopping"
		exit 44
	fi
}

# set_env can only contain $HOME and other generally available values
function set_env {

AUSER=$USER
MYNAME="Brent S.A. Cowgill"
EMAIL=zardoz@infoserve.net
UBUNTU=trusty
COMPANY=
ULIMITFILES=1024
#ULIMITFILES=8096
DOWNLOAD=$HOME/Downloads/check-system
INI_DIR=check-iniline

MOUNT_DATA=""
BIG_DATA="/data"
USE_KDE=1
USE_JAVA=""
SVN_PKG=""
MVN_PKG=""
GITSVN_PKG=""
USE_SCHEMACRAWLER=""
USE_POSTGRES=""
USE_MYSQL=""
USE_PIDGIN=""
CUSTOM_PKG=""

ECLIPSE=""

I3WM_CMD=i3
I3WM_PKG="i3 xdotool xmousepos:xautomation feh"

CHARLES_PKG=charles-proxy
CHARLES_CMD="charles"
CHARLES_LICENSE="UNREGISTERED:xxxxxxxxxx"

SKYPE_CMD=skype
SKYPE_PKG="skype skype-bin"

# http://download.virtualbox.org/virtualbox/5.0.14/virtualbox-5.0_5.0.14-105127~Ubuntu~trusty_amd64.deb
VIRTUALBOX_CMD="VirtualBox"
VIRTUALBOX_CMDS="dkms $VIRTUALBOX_CMD"
VIRTUALBOX_PKG="unar gksu dkms $VIRTUALBOX_CMD:virtualbox-5.0"
VIRTUALBOX_PKG="unar gksu dkms $VIRTUALBOX_CMD:virtualbox-5.1"
VIRTUALBOX_REL="raring"

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
#MVN_PKG="mvn:maven"
MVN_VER="3.0.4"

JAVA_VER=java-7-openjdk-amd64
JAVA_JVM=/usr/lib/jvm

# http://sourcegear.com/diffmerge/downloads.php
DIFFMERGE_CMD=diffmerge
DIFFMERGE_PKG=diffmerge_4.2.0.697.stable_amd64.deb
DIFFMERGE_URL=http://download-us.sourcegear.com/DiffMerge/4.2.0/$DIFFMERGE_PKG

# Perforce p4merge tool
# HELIX P4MERGE: VISUAL MERGE TOOL
P4MERGE_CMD="$DOWNLOAD/p4v-2014.3.1007540/bin/p4merge"
P4MERGE_CMD="$DOWNLOAD/p4v-2015.2.1315639/bin/p4merge"
P4MERGE_URL="http://www.perforce.com/downloads/Perforce/20-User#10"
P4MERGE_PKG=p4v.tgz

RUBY_PKG="ruby ruby-dev"
RUBY_CMD=ruby
#RUBY_GEMS="sass:3.4.2 compass compass-validator foundation"
RUBY_GEMS="sass compass compass-validator foundation"
RUBY_SASS_COMMANDS="ruby gem sass compass foundation"

POSTGRES_PKG="psql:postgresql-client-9.3 pfm pgadmin3:pgadmin3-data pgadmin3"
POSTGRES_NODE_PKG="node-pg"
POSTGRES_NPM_PKG="node-dbi"

# BlisMedia Druid reporting requirements
DRUID_PKG="apache2"
DRUID_PERL_MODULES="CGI::Fast DBI DBD::mysql JSON"
DRUID_PACKAGES="/usr/lib/apache2/modules/mod_fcgid.so:libapache2-mod-fcgid"

PIDGIN_CMD="pidgin" # "pidgin-guifications pidgin-themes pidgin-plugin-pack"
PIDGIN_SKYPE="/usr/lib/purple-2/libskype.so"
PIDGIN_SKYPE_PKG="$PIDGIN_SKYPE:pidgin-skype"
PIDGIN_SRC="pidgin-2.10.11"
PIDGIN_ZIP="$PIDGIN_SRC.tar.bz2"

VPN_PKG="openvpn brctl:bridge-utils"
VPN_CONFIG=/etc/network/interfaces.d/bridge-vpn

# epub, mobi book reader
EBOOK_READER="calibre"

PERL_PKG="cpanm:cpanminus"

TEMPERATURE_PKG="sensors:lm-sensors hddtemp"

NODE_VER="v0.12.9"
#NODE="nodejs nodejs-legacy npm grunt grunt-init uglifyjs phantomjs $POSTGRES_NODE_PKG"
NODE_CMD="nodejs"
NODE_CMDS="$NODE_CMD npm"
NODE_LIB=/usr/lib/nodejs
NODE_PKG="
	$NODE_CMDS
	node:nodejs-legacy
	$NODE_LIB/debug.js:node-debug
	$NODE_LIB/eyes.js:node-eyes
	$NODE_LIB/glob.js:node-glob
	$NODE_LIB/inherits.js:node-inherits
	$NODE_LIB/mkdirp/index.js:node-mkdirp
	$NODE_LIB/rimraf/index.js:node-rimraf
"
NODE_CUSTOM_PKG="
	$NODE_LIB/abbrev.js:node-abbrev
	$NODE_LIB/async.js:node-async
	$NODE_LIB/base64id.js:node-base64id
	$NODE_LIB/bignumber.js:node-bignumber
	$NODE_LIB/bytes/index.js:node-bytes
	$NODE_LIB/chrono.js:node-chrono
	$NODE_LIB/cli/index.js:node-cli
	$NODE_LIB/colors.js:node-colors
	$NODE_LIB/commander.js:node-commander
	$NODE_LIB/contextify/index.js:node-contextify
	$NODE_LIB/daemon/index.js:node-daemon
	$NODE_LIB/dequeue/index.js:node-dequeue
	$NODE_LIB/diff.js:node-diff
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
	$NODE_LIB/optimist.js:node-optimist
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
	$NODE_LIB/zipfile/index.js:node-zipfile
"

NPM_LIB=/usr/local/lib/node_modules
NPM_GLOBAL_PKG="
	prettydiff
	uglifyjs:uglify-js
	jsdoc
	jshint
	eslint
	jscs
	flow:flow-bin
	babel:babel-cli
	node-sass
	lessc:less
	mocha
	phantomjs:phantomjs-prebuilt
	karma:karma-cli
	$NPM_LIB/karma-chrome-launcher/index.js:karma-chrome-launcher
	$NPM_LIB/karma-phantomjs-launcher/index.js:karma-phantomjs-launcher
	bower
	yo
	grunt:grunt-cli
	grunt-init
	express:express-generator
"

INSTALL_GRUNT_TEMPLATES="basic:grunt-init-gruntfile node:grunt-init-node jquery:grunt-init-jquery.git"

# webcollage screensaver pulls from the internet so not safe for work
SCREENSAVER_PKG="
	workrave
	kscreensaver
	ktux
	kcometen4
	screensaver-default-images
	wmmatrix
	xscreensaver
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

# https://download.sublimetext.com/sublime-text_build-3114_amd64.deb
SUBLIME_PKG=sublime-text_build-3114_amd64.deb
SUBLIME_CFG=.config/sublime-text-3
SUBLIME_CMD=subl
SUBLIME_URL=http://download.sublimetext.com
SUBLIME_URL=$SUBLIME_URL/$SUBLIME_PKG

#me@akston:~/bin (dell-7510 *% u+2)$ tar tvzf ~/Downloads/WebStorm-2016.2.tar.gz  | head
#-rw-r--r-- 0/0            6878 2016-07-09 10:44 WebStorm-162.1121.31/bin/idea.properties
WEBSTORM_CMD=wstorm
WEBSTORM_ARCHIVE=WebStorm-2016.2
WEBSTORM_DIR=WebStorm-162.1121.31
WEBSTORM_URL=http://download.jetbrains.com/webstorm
WEBSTORM_EXTRACTED_DIR="$DOWNLOAD/$WEBSTORM_DIR"
WEBSTORM_EXTRACTED="$WEBSTORM_EXTRACTED_DIR/bin/webstorm.sh"
WEBSTORM_URL=$WEBSTORM_URL/$WEBSTORM_ARCHIVE.tar.gz

VSLICK_CMD=vs
VSLICK_ARCHIVE=se_20000300_linux64
VSLICK_URL="http://www.slickedit.com/dl/dl.php?type=trial&platform=linux64&product=se&pname=SlickEdit%20for%20Linux"
VSLICK_EXTRACTED_DIR="$DOWNLOAD/$VSLICK_ARCHIVE"
VSLICK_EXTRACTED="$VSLICK_EXTRACTED_DIR/vsinst"

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
	open-layers
	brick-xtag
	d3-family-tree
	FT-Hackday-2012
	QUnitChainer
	BigScreen
	Qucumber
"

#HEREIAM PKG

# open pages to find latest versions of files to download
# browser.sh https://www.slickedit.com/trial/slickedit
# browser.sh http://www.jetbrains.com/webstorm/download/#section=linux-version
# browser.sh "https://www.sublimetext.com/3"
# browser.sh "http://download.virtualbox.org/virtualbox/"
# browser.sh "http://www.sourcegear.com/diffmerge/downloaded.php"
# browser.sh "https://www.perforce.com/downloads/register/helix?return_url=http://www.perforce.com/downloads/perforce/r15.2/bin.linux26x86_64/p4v.tgz&platform_family=LINUX&platform=Linux%20%28x64%29&version=2015.2/1315639&product_selected=Perforce&edition_selected=helix&product_name=Helix%20P4Merge:%20:%20Visual%20Merge%20Tool&prod_num=10"


TODO=audacity

THUNDER=""
#THUNDER=ryu9c8b3.default


# Chrome download page
GOOGLE_CHROME_URL="http://www.google.com/chrome?platform=linux"
GOOGLE_CHROME=google-chrome
GOOGLE_CHROME_PKG=google-chrome-stable_current_amd64.deb

SUBLIME=subl
SUBLIME_CFG=.config/sublime-text-3
SUBLIME_PKG=sublime-text_build-3083_amd64.deb
SUBLIME_URL=http://c758482.r82.cf2.rackcdn.com/$SUBLIME_PKG


WEBSTORM=wstorm
WEBSTORM_ARCHIVE=WebStorm-11.0.4
WEBSTORM_DIR=WebStorm-143.2370.0
# legacy ver just for testing check-system
WEBSTORM_ARCHIVE=WebStorm-11.0.3
WEBSTORM_DIR=WebStorm-143.1559.5
WEBSTORM_URL=http://download.jetbrains.com/webstorm/$WEBSTORM_ARCHIVE.tar.gz
WEBSTORM_EXTRACTED_DIR="$DOWNLOAD/$WEBSTORM_DIR"
WEBSTORM_EXTRACTED="$WEBSTORM_EXTRACTED_DIR/bin/webstorm.sh"

VSLICK=vs
VSLICK_ARCHIVE=se_19000101_linux64
VSLICK_URL="http://www.slickedit.com/dl/dl.php?type=trial&platform=linux64&product=se&pname=SlickEdit%20for%20Linux"
VSLICK_EXTRACTED_DIR="$DOWNLOAD/$VSLICK_ARCHIVE"
VSLICK_EXTRACTED="$VSLICK_EXTRACTED_DIR/vsinst"


FLASH_ARCHIVE="flashplayer_11_plugin_debug.i386"
FLASH_EXTRACTED_DIR="$DOWNLOAD/$FLASH_ARCHIVE"
FLASH_EXTRACTED="$FLASH_EXTRACTED_DIR/libflashplayer.so"
FLASH_URL="http://fpdownload.macromedia.com/pub/flashplayer/updaters/11/$FLASH_ARCHIVE.tar.gz"
CHROME_PLUGIN="/usr/lib/chromium-browser/plugins"



PULSEAUDIO="pavucontrol pavumeter speaker-test"
KEYBOARD="showkey evtest"

#vim-scripts requires ruby - loads of color schemes and helpful vim scripts
# runit
# jhead for jpeg EXIF header editing
INSTALL_CMDS="
	dlocate deborphan
	curl wget
	vim ctags
	screen tmux cmatrix
	colordiff
	meld
	dos2unix flip
	htop
	ncdu
	lsof
	fdupes
	mmv
	pv
	fortune
	unicode
	gettext
	iselect
	mc
	multitail root-tail
	fbcat
	jhead
	chromium-browser
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
# from skype nas:i386 glibc-doc:i386 locales:i386 rng-tools:i386 gnutls-bin:i386
# krb5-doc:i386 krb5-user:i386 libvisual-0.4-plugins:i386
# gstreamer-codec-install:i386 gnome-codec-install:i386
# gstreamer1.0-tools:i386 gstreamer1.0-plugins-base:i386 jackd2:i386
# pulseaudio:i386 libqt4-declarative-folderlistmodel:i386
# libqt4-declarative-gestures:i386 libqt4-declarative-particles:i386
# libqt4-declarative-shaders:i386 qt4-qmlviewer:i386 libqt4-dev:i386
# libicu48:i386 libthai0:i386 qt4-qtconfig:i386
# Recommended packages:
# xml-core:i386
# from i3wm libevent-perl libio-async-perl libpoe-perl dwm stterm surf

INSTALL_LIST="
	wcd.exec:wcd
	calc:apcalc
	ssh:openssh-client
	sshd:openssh-server
	gvim:vim-gtk
	perldoc:perl-doc
	perlcritic:libperl-critic-perl
	dot:graphviz
	convert:imagemagick
"

INSTALL_FILES="
	/usr/share/doc/fortunes/copyright:fortunes
	/usr/share/doc-base/vim-referencemanual:vim-doc
"

COMMANDS_LIST="
	apt-file
	wcd.exec
	gettext
	git
	gitk
	perl
	dot
	meld
"

if [ "$HOSTNAME" == "akston" ]; then
	GIT_VER=1.9.1
	NODE_VER=v0.10.25
	USE_KDE=""
	#I3WM_PKG=""
	CHARLES_PKG=""
	#SKYPE_PKG=""
	VIRTUALBOX_PKG=""
	#DIFFMERGE_PKG=""
	#P4MERGE_PKG=""
	RUBY_PKG=""
	VPN_PKG=""
	EBOOK_READER=""
	DRUID_PKG=""
	CUSTOM_PKG="
		gnucash
	"
	#NODE_PKG=""

	#SUBLIME_PKG=""
	SUBLIME_CFG=""
	#WEBSTORM_ARCHIVE=""
	#VSLICK_ARCHIVE=""

	# HEREIAM CFG
fi

if [ "$HOSTNAME" == "worksharexps-XPS-15-9530" ]; then
	# Change settings for workshare linux laptop
	AUSER=bcowgill
	EMAIL=brent.cowgill@workshare.com
	COMPANY=workshare
	UBUNTU=vivid
	ULIMITFILES=1024
	BIG_DATA="/data"
	USE_KDE=""
	VIRTUALBOX_REL=$(lsb_release -sc)
	SKYPE_PKG=""
	RUBY_GEMS=""
	RUBY_SASS_COMMANDS=""
	DRUID_PKG=""

	GOOGLE_CHROME_PKG=""
	# no amd64 pkg for perforce merge
	VSLICK_ARCHIVE=""
fi

if [ "$HOSTNAME" == "raspberrypi" ]; then
	# Change settings for the raspberry pi

	UBUNTU="/etc/rpi-issue: Raspberry Pi reference 2015-02-16 (armhf)"
	UBUNTU="wheezy"
	ULIMITFILES=1024
	GIT_VER="1.7.10.4"
	JAVA_VER=jdk-8-oracle-arm-vfp-hflt
	NODE_VER="v0.10.28"
	BIG_DATA=""
	COMPANY=raspberrypi
	I3WM_PKG=""
	CHARLES_PKG=""
	SKYPE_PKG=""
	VIRTUALBOX_PKG=""
	DIFFMERGE_PKG=""
	P4MERGE_PKG=""
	RUBY_GEMS="sass foundation"
	RUBY_SASS_COMMANDS="ruby gem $RUBY_GEMS"
	USE_PIDGIN=""
	VPN_PKG=""
	EBOOK_READER=""
	DRUID_PKG=""
	CUSTOM_PKG="
		vim
		locate
		zip
		cmatrix
		chromium
		gnash
		/usr/lib/gnash/libgnashplugin.so:browser-plugin-gnash
		tightvncserver
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
		gimp
		meld
		htop
		ncdu
		figlet
		banner:sysvbanner
		linuxlogo
	"
	NODE_PKG=""
	NODE_CMD="node"
	NODE_CMDS="node npm"
	SCREENSAVER_PKG=""
	DROPBOX_URL=""
	SUBLIME_PKG=""
	SUBLIME_CFG=""
	WEBSTORM_ARCHIVE=""
	VSLICK_ARCHIVE=""
	MY_REPOS=""

	GOOGLE_CHROME_PKG=""
	FLASH_URL=""
fi # raspberrypi

}
set_env

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

# disable commands for omitted packages
[ -z "$SVN_PKG"           ] && SVN_CMD=""
[ -z "$SKYPE_PKG"         ] && SKYPE_CMD=""
[ -z "$I3WM_PKG"          ] && I3WM_CMD=""
[ -z "$CHARLES_PKG"       ] && CHARLES_CMD=""
[ -z "$VIRTUALBOX_PKG"    ] && VIRTUALBOX_CMDS=""
[ -z "$MVN_PKG"           ] && MVN_CMD=""
[ -z "$GITSVN_PKG"        ] && GITSVN_CMD=""
[ -z "$DIFFMERGE_PKG"     ] && DIFFMERGE_CMD=""
[ -z "$P4MERGE_PKG"       ] && P4MERGE_CMD=""
[ -z "$RUBY_PKG"          ] && RUBY_CMD="" && RUBY_GEMS="" && RUBY_SASS_COMMANDS=""
[ -z "$USE_POSTGRES"      ] && POSTGRES_PKG="" && POSTGRES_NODE_PKG="" && POSTGRES_NPM_PKG=""
[ -z "$USE_PIDGIN"        ] && PIDGIN_CMD="" && PIDGIN_SKYPE_PKG=""
[ -z "$DRUID_PKG"         ] && DRUID_PERL_MODULES="" && DRUID_PACKAGES=""
[ -z "$NODE_PKG"          ] && NODE_CMD="" && NODE_CMDS="" && NODE_CUSTOM_PKG="" && NPM_GLOBAL_PKG="" && POSTGRES_NODE_PKG="" && POSTGRES_NPM_PKG=""

# HEREIAM DERIVED

# final package configuration based on what has been turned on
GIT_TAR=git-$GIT_VER
GIT_URL=https://git-core.googlecode.com/files/$GIT_TAR.tar.gz
GIT_PKG_AFTER="
	/usr/share/doc-base/git-tools:git-doc
	/usr/lib/git-core/git-gui:git-gui
	gitk
	tig
	$GITSVN_PKG
"

NODE_PKG_LIST="
	$NODE_PKG
	$NODE_CUSTOM_PKG
	$POSTGRES_NODE_PKG
"

NPM_GLOBAL_PKG_LIST="
	$NPM_GLOBAL_PKG
	$POSTGRES_NPM_PKG
"

INSTALL_FROM="
	$INSTALL_LIST
	$PERL_PKG
	$TEMPERATURE_PKG
	$I3WM_PKG
	$MVN_PKG
	$POSTGRES_PKG
	$DRUID_PKG
	$PIDGIN_CMD
	$PIDGIN_SKYPE_PKG
	$VPN_PKG
	$EBOOK_READER
"

COMMANDS="
	$COMMANDS_LIST
	$NODE_CMDS
	$RUBY_CMD
	$RUBY_SASS_COMMANDS
	$SVN_CMD
	$MVN_CMD
	$I3WM_CMD
	$CHARLES_CMD
	$DIFFMERGE_CMD
	$SKYPE_CMD
	$PIDGIN_CMD
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
	$PULSEAUDIO
	$KEYBOARD
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

set -o posix
set > check-system.env.log
set +o posix
}
set_derived_env

function pre_checks {
	if [ -e "$VPN_CONFIG" ]; then
		OK vpn config file already exists $VPN_CONFIG
		HAD_VPN_CONFIG=1
	fi
}
pre_checks

echo CONFIG INSTALL_CMDS=$INSTALL_CMDS
echo CONFIG INSTALL_FROM=$INSTALL_FROM
echo CONFIG INSTALL_FILES=$INSTALL_FILES
echo CONFIG COMMANDS=$COMMANDS
echo CONFIG PACKAGES=$PACKAGES
echo CONFIG NODE_PKG_LIST=$NODE_PKG_LIST
echo CONFIG PERL_MODULES=$PERL_MODULES
echo CONFIG RUBY_GEMS=$RUBY_GEMS
echo CONFIG INSTALL_FILE_PACKAGES=$INSTALL_FILE_PACKAGES
echo CONFIG NPM_GLOBAL_PKG_LIST

#============================================================================
# begin actual system checking

# provides lsb_release command as well.
cmd_exists apt-file || (sudo apt-get install apt-file && sudo apt-file update)

uname -a && lsb_release -a && id

if grep $USER /etc/group | grep sudo; then
	OK "user $USER has sudo privileges"
	sudo egrep "\b$AUSER\b" /etc/passwd /etc/group /etc/sudoers
	#/etc/passwd:bcowgill:x:1001:1001:Brent Cowgill,,,:/home/bcowgill:/bin/bash
	#/etc/group:sudo:x:27:workshare-xps,bcowgill
	#/etc/group:bcowgill:x:1001:
	#etc/sudoers:bcowgill   ALL=(ALL:ALL) ALL
else
	NOT_OK "user $USER does not have sudo privileges"
fi

pushd $HOME

if [ "$HOME" == "/home/me" ]; then
	dir_exists "$HOME" "home dir ok"
else
   dir_link_exists "/home/me" "$HOME" "need to alias home dir as /home/me"
fi

make_dir_exist workspace/play "workspace play area missing"
make_dir_exist workspace/tx   "workspace transfer area missing"
make_dir_exist workspace/projects "workspace projects area missing"
make_dir_exist $DOWNLOAD "Downloads area missing"
make_dir_exist $DROP_BACKUP "Dropbox backup area"

get_git

check_linux "$UBUNTU"
which git && git --version
which java && java -version && ls $JAVA_JVM
which perl && perl --version
which python && python --version
which ruby && ruby --version
which node && node --version
which nodejs && nodejs --version
which npm && npm --version

# chicken egg bootstrap:
if [ ! -e $HOME/bin ]; then
	NOT_OK "MAYBE there is no $HOME/bin dir yet, we will install ourself."
	mkdir $HOME/bin
fi

if [ -e $HOME/bin ]; then
	if [ ! -e $HOME/bin/cfg/check-system.sh ]; then
		NOT_OK "MAYBE there is a $HOME/bin dir, we will install ourself there. "
		mv $HOME/bin $HOME/bin.saved
		git clone https://github.com/bcowgill/bsac-linux-cfg.git
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
		/bin/true
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

# Shell configuration files
file_linked_to .bash_aliases bin/cfg/.bash_aliases  "bash alias configured"
file_linked_to .bash_functions bin/cfg/.bash_functions "bash functions configured"
file_linked_to .bashrc bin/cfg/.bashrc "bashrc configured"
file_linked_to .my.cnf bin/cfg/.my.cnf "mysql configured"
file_linked_to .pgadmin3 bin/cfg/.pgadmin3 "postgres admin tool configured"
file_linked_to .perltidyrc bin/cfg/.perltidyrc "perltidyrc configured"
#file_linked_to .perltidyrc bin/cfg/.perltidyrc-$COMPANY "perltidyrc configured for $COMPANY"
file_linked_to .vimrc bin/cfg/vimrc.txt  "awesome vim configured"
#file_linked_to .vimrc bin/cfg/.vimrc  "vim configured"
file_linked_to .Xresources bin/cfg/.Xresources "xresources config for xterm and other X programs"
file_linked_to .xscreensaver bin/cfg$COMP/.xscreensaver "xscreensaver configuration"
file_linked_to .screenrc bin/cfg/.screenrc "screen command layouts configured"
make_dir_exist .config/i3 "i3 configuration file dir"
file_linked_to .config/i3/config $HOME/bin/cfg$COMP/.i3-config "i3 window manager configuration"

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

# Fonts ================================================================
# https://www.raspberrypi.org/forums/viewtopic.php?f=66&t=14781
cmd_exists wget
install_file_from_url_zip $DOWNLOAD/MProFont/ProFontWindows.ttf MProFont.zip "http://tobiasjung.name/downloadfile.php?file=MProFont.zip" "ProFontWindows font package"
install_file_from_url_zip $DOWNLOAD/ProFont-Windows-Bold/ProFont-Bold-01/ProFontWindows-Bold.ttf ProFont-Windows-Bold.zip "http://tobiasjung.name/downloadfile.php?file=ProFont-Windows-Bold.zip" "ProFontWindows bold font package"
install_file_from_url_zip $DOWNLOAD/ProFontWinTweaked/ProFontWindows.ttf ProFontWinTweaked.zip "http://tobiasjung.name/downloadfile.php?file=ProFontWinTweaked.zip" "ProFontWindows tweaked font package"
echo YOUDO You have to manually install ProFontWindows with your Font Manager from $DOWNLOAD/MProFont/ProFontWindows.ttf

# alternative install: npm install git://github.com/adobe-fonts/source-code-pro.git#release
# https://github.com/adobe-fonts/source-code-pro/
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

# Get unicode fonts and examples
# http://www.cl.cam.ac.uk/~mgk25/ucs-fonts.html
# http://www.cl.cam.ac.uk/~mgk25/ucs/quick-intro.txt
# http://www.cl.cam.ac.uk/~mgk25/unicode.html#x11
URL=http://www.cl.cam.ac.uk/~mgk25
if [ ! -f xlsfonts.lst  ]; then
	locale -a > locale-a.lst
	xset q > xset-q.lst
	xlsfonts > xlsfonts.lst
	fc-list > fc-list.lst
fi
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

# MUSTDO finish this
if /bin/false ; then
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
	file_exists $FILE "ProFontWindows font needs to be installed" || find $DOWNLOADS/ -name '*.ttf'
	file_exists $FILE > /dev/null || kfontinst $DOWNLOADS/ProFontWinTweaked/ProFontWindows.ttf
	file_exists $FILE "ProFontWindows still not installed"

	FILE=.fonts/p/ProFontWindows_Bold.ttf
	file_exists $FILE > /dev/null || kfontinst $DOWNLOADS/ProFont-Windows-Bold/ProFont-Bold-01/ProFontWindows-Bold.ttf
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

BAIL_OUT font

if [ ! -z "$I3WM_PKG" ]; then
	FILE="/etc/apt/sources.list.d/i3window-manager.list"
	make_root_file_exist "$FILE" "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" "adding i3wm source for apt"
	file_has_text "$FILE" "debian.sur5r.net"
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

if [ ! -z "$SKYPE_PKG" ]; then
	apt_has_source "deb http://archive.canonical.com/ $(lsb_release -sc) partner" "apt config for skype missing"
else
	OK "will not configure skype unless SKYPE_PKG is non-zero"
fi # SKYPE_PKG

if [ ! -z "$VIRTUALBOX_PKG" ]; then
	# http://ubuntuhandbook.org/index.php/2015/07/install-virtualbox-5-0-ubuntu-15-04-14-04-12-04/
	# https://www.virtualbox.org/wiki/Linux_Downloads
	# http://www.howopensource.com/2013/04/install-virtualbox-ubuntu-ppa/
	apt_has_source "deb http://download.virtualbox.org/virtualbox/debian $VIRTUALBOX_REL contrib" "apt config for virtualbox $VIRTUALBOX_REL"
	apt_must_not_have_source "deb-src http://download.virtualbox.org/virtualbox/debian $VIRTUALBOX_REL contrib" "apt config for virtualbox wrong"
	if [ "$(lsb_release -sc)" != "$VIRTUALBOX_REL" ]; then
		apt_must_not_have_source "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" "apt config trusty must use raring for now"
		apt_must_not_have_source "deb-src http://download.virtualbox.org/virtualbox/debian $(lsb_release -sc) contrib" "apt config trusty must use raring for now"
	fi

	apt_has_key VirtualBox http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc "key fingerprint for VirtualBox missing"
	installs_from "$VIRTUALBOX_PKG" "additional packages for virtualbox"

	cmd_exists dkms "need dkms command for VirtualBox"
	cmd_exists $VIRTUALBOX_CMD || (sudo apt-get update; sudo apt-get install $VIRTUALBOX_PKG)
	commands_exist $VIRTUALBOX_CMDS
else
	OK "will not configure virtualbox unless VIRTUALBOX_PKG is non-zero"
fi # VIRTUALBOX_PKG

if [ ! -z "$SVN_PKG" ]; then
	apt_has_source "deb http://ppa.launchpad.net/svn/ppa/ubuntu $(lsb_release -sc) main" "apt config for svn update missing"
	apt_has_source "deb-src http://ppa.launchpad.net/svn/ppa/ubuntu $(lsb_release -sc) main" "apt config for svn update missing"
fi

if [ ! -z "$CHARLES_PKG$SVN_PKG$SKYPE_PKG$VIRTUALBOX_PKG" ]; then

	echo MAYBE DO MANUALLY apt-get install $CHARLES_PKG $SVN_PKG $SKYPE_PKG $VIRTUALBOX_PKG
	[ -f go.sudo ] && (sudo apt-get update; sudo apt-get install $CHARLES_PKG $SVN_PKG $SKYPE_PKG && sudo apt-get -f install && echo YOUDO: set charles license: $CHARLES_LICENSE)
fi

[ ! -z "$CHARLES_PKG" ] && cmd_exists $CHARLES_CMD
[ ! -z "$SKYPE_PKG" ] && cmd_exists $SKYPE_CMD

if [ ! -z "$SVN_PKG" ]; then
	cmd_exists svn
	file_exists /usr/lib/x86_64-linux-gnu/jni/libsvnjavahl-1.so "svn and eclipse setup lib exists"
	dir_linked_to /usr/lib/jni /usr/lib/x86_64-linux-gnu/jni "svn and eclipse symlink exists" root
	apt_has_key WANdisco http://opensource.wandisco.com/wandisco-debian.gpg "key fingerprint for svn 1.8 wandisco"
	FILE="/etc/apt/sources.list.d/WANdisco.list"
	make_root_file_exist "$FILE" "deb http://opensource.wandisco.com/ubuntu $(lsb_release -sc) svn18" "adding WANdisco source for apt"
	file_has_text "$FILE" wandisco.com
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
	installs_from "$GIT_PKG_AFTER" "additional git packages"
else
	NOT_OK "git command version incorrect - will try update"
	# old setup for git 1.9.1
	# http://blog.avirtualhome.com/git-ppa-for-ubuntu/
	apt_has_source ppa:pdoes/ppa "repository for git"
	sudo apt-get update
	apt-cache show git | grep '^Version:'
	installs_from "$GIT_PKG_AFTER" "additional git packages"
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

GIT_COMPLETE=/usr/share/bash-completion/completions/git
if file_exists "$GIT_COMPLETE" > /dev/null ; then
	# git installs completion file but not in right place any more
	file_linked_to_root /etc/bash_completion.d/git /usr/share/bash-completion/completions/git
else
	file_exists /etc/bash_completion.d/git "git completeion file in etc"
fi

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
	NOT_OK "git config rerere not set. trying to do so"
	git config --global rerere.enabled true
	git config --global rerere.autoupdate true
fi

if git config --global --list | grep alias.graph; then
	OK "git config alias.graph has been set up"
else
	NOT_OK "git config alias.graph not set. trying to do so"
	git config --global --add alias.graph "log --oneline --graph --decorate --all"
fi

if [ ! -z "$MVN_PKG" ]; then
	cmd_exists mvn
	if mvn --version | grep "Apache Maven " | grep $MVN_VER; then
		OK "mvn command version correct"
	else
		NOT_OK "mvn command version incorrect"
		exit 1
	fi

	if [ "x$M2_HOME" == "x/usr/share/maven" ]; then
		OK "M2_HOME set correctly"
	else
		NOT_OK "M2_HOME is incorrect $M2_HOME"
		exit 1
	fi
else
	OK "will not configure maven unless MVN_PKG is non-zero"
fi # MVN_PKG

if [ ! -z "$USE_JAVA" ]; then
	if [ "x$JAVA_HOME" == "x$JAVA_JVM/$JAVA_VER" ]; then
		OK "JAVA_HOME set correctly"
		file_exists "$JAVA_HOME/jre/bin/java" "java is actually there"
	else
		NOT_OK "JAVA_HOME is incorrect $JAVA_HOME"
		exit 1
	fi # JAVA_HOME
	dir_linked_to jdk workspace/$JAVA_VER "shortcut to current java dev kit"
fi

if [ ! -z "$DIFFMERGE_PKG" ]; then
	install_command_package_from_url $DIFFMERGE_CMD $DIFFMERGE_PKG $DIFFMERGE_URL "sourcegear diffmerge"
else
	OK "will not configure diffmerge unless DIFFMERGE_PKG is non-zero"
fi

if [ ! -z "$P4MERGE_PKG" ]; then
	install_file_from_zip $P4MERGE_CMD $P4MERGE_PKG "Perforce p4merge manual download from $P4MERGE_URL"
	file_linked_to "$HOME/bin/p4merge" "$P4MERGE_CMD" "Perforce p4merge link"
else
	OK "will not configure perforce merge unless P4MERGE_PKG is non-zero"
fi

BAIL_OUT diff

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

installs_from "$INSTALL_CMDS"
installs_from "$INSTALL_FROM"
installs_from "$CUSTOM_PKG"

BAIL_OUT install

[ ! -z "$NODE_PKG" ] && installs_from "$NODE_PKG_LIST"

BAIL_OUT node

[ ! -z "$USE_KDE" ] && [ ! -z "$SCREENSAVER_PKG" ] && install_command_from_packages kslideshow.kss "$SCREENSAVER_PKG"

BAIL_OUT screensaver

install_perl_modules "$PERL_MODULES"

BAIL_OUT perl

[ ! -z "$RUBY_PKG" ] && install_ruby_gems "$RUBY_GEMS"

BAIL_OUT ruby

installs_from "$INSTALL_FILE_PACKAGES"

BAIL_OUT files

if [ ! -z "$NODE_PKG" ]; then
	if $NODE_CMD --version | grep $NODE_VER; then
		OK "node command version correct"
	else
		echo HEREIAM STOP NODE
		exit 88
		GOTVER=`$NODE_CMD --version`
		NOT_OK "node command version incorrect. trying to update: $GOTVER to $NODE_VER"
		#https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#wiki-ubuntu-mint-elementary-os
		sudo apt-get update
		sudo apt-get install -y python-software-properties python g++ make
		sudo add-apt-repository ppa:chris-lea/node.js
		sudo apt-get update
		sudo apt-get install nodejs
		exit 1
	fi

	npm config set registry https://registry.npmjs.org/
	if [ ! -z "$FRESH_NPM" ]; then
		always_install_npm_global_from npm
		always_install_npm_globals_from "$NPM_GLOBAL_PKG_LIST"
		install_npm_global_commands_from "$NPM_GLOBAL_PKG_LIST"
	else
		install_npm_global_commands_from "$NPM_GLOBAL_PKG_LIST"
	fi
	is_npm_global_package_installed grunt "need grunt installed to go further."
	make_dir_exist $HOME/.grunt-init "grunt template dir"
	# need to upload ssh public key to github before getting grunt templates
	install_grunt_templates_from "$INSTALL_GRUNT_TEMPLATES"
else
	OK "will not configure npm unless NODE_PKG is non-zero"
fi

BAIL_OUT npm

if [ ! -z "$DROPBOX_URL" ]; then
	make_dir_exist workspace/dropbox-dist "dropbox distribution files"
	file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd "dropbox installed" || (pushd workspace/dropbox-dist && wget -O - "$DROPBOX_URL" | tar xzf - && ./.dropbox-dist/dropboxd & popd)
	file_exists workspace/dropbox-dist/.dropbox-dist/dropboxd
	if ps -ef | grep -v grep | grep dropbox-dist > /dev/null; then
		OK "dropbox daemon is running"
	else
		NOT_OK "dropbox daemon is not running, will try to start it"
		dropbox.sh
	fi
fi

BAIL_OUT dropbox

commands_exist "$COMMANDS"
BAIL_OUT commands

#============================================================================
# end of standard install, now custom install

echo CRON table setup
crontab_has_command "mkdir" "* * * * * mkdir -p /tmp/\$LOGNAME && set > /tmp/\$LOGNAME/crontab-set.log 2>&1" "crontab user temp dir creation and env var dump"
crontab_has_command "mkdir"
crontab_has_command "wcdscan.sh" "*/10 9,10,11,12,13,14,15,16,17,18 * * * \$HOME/bin/wcdscan.sh > /tmp/\$LOGNAME/crontab-wcdscan.log 2>&1" "crontab update change dir scan"
crontab_has_command "wcdscan.sh"

if [ ! -z "$COMPANY" ]; then
	file_linked_to bin/backup-work.sh $HOME/bin/cfg/$COMPANY/backup-work-$COMPANY.sh "daily backup script"
	file_linked_to bin/backup-work-manual.sh $HOME/bin/cfg/$COMPANY/backup-work-manual-$COMPANY.sh "manual backup script"
	file_linked_to bin/get-from-home.sh $HOME/bin/cfg/$COMPANY/get-from-home-$COMPANY.sh "unpacker script for work at home"
	cmd_exists backup-work.sh "backup script missing"/
	cmd_exists get-from-home.sh "unpacker script for work at home"

	file_exists bin/cfg/$COMPANY/crontab-$HOSTNAME "crontab missing" || backup-work.sh
	crontab_has_command "backup-work.sh" "30 17,18 * * * \$HOME/bin/backup-work.sh > /tmp/\$LOGNAME/crontab-backup-work.log 2>&1" "crontab daily backup configuration"
	crontab_has_command "backup-work.sh"
fi

BAIL_OUT commandks

file_present prettydiff.js "html beautifier file"

if [ ! -z "$SUBLIME_PKG" ]; then
	install_command_package_from_url $SUBLIME_CMD $SUBLIME_PKG $SUBLIME_URL "sublime editor"
	if [ ! -z "$SUBLIME_CFG" ]; then
		cmd_exists git "need git installed before configure sublime"
		cmd_exists grunt "need grunt installed before configure sublime for it"

		# package nodejs-legacy provides node -> nodejs symlink
		#file_linked_to /usr/bin/node /usr/bin/nodejs "grunt needs node command at present, not updated to nodejs yet"
		cmd_exists node "grunt needs node command at present, not updated to nodejs yet"
		install_file_from_url $DOWNLOADS/Package-Control.sublime-package.zip Package-Control.sublime-package.zip "http://sublime.wbond.net/Package%20Control.sublime-package" "sublime package control bundle"
		#cp $DOWNLOADS/Package-Control.sublime-package.zip "$SUBLIME_CFG/Installed Packages/Package Control.sublime-package"
		install_file_manually "$SUBLIME_CFG/Installed Packages/Package Control.sublime-package" "sublime package control from instructions" "https://sublime.wbond.net/installation"
		install_git_repo "$SUBLIME_CFG/Packages" sublime-grunt-build git://github.com/jonschlinkert/sublime-grunt-build.git "sublime text grunt build package - check for Tools/Build System/Grunt after -- May have to correct syntax in print('BuildGruntOnSave: on_post_save')"
		## TODO - maybe not sublime build may be working ... install_file_manually "$SUBLIME_CFG/Packages/Grunt/SublimeGrunt.sublime-settings" "sublime grunt build system" "https://www.npmjs.org/package/sublime-grunt-build"
	fi
	commands_exist "$SUBLIME_CMD"
fi # SUBLIME_PKG

if [ ! -z "$WEBSTORM_ARCHIVE" ]; then
	install_file_from_url_zip "$WEBSTORM_EXTRACTED" "$WEBSTORM_ARCHIVE.tar.gz" "$WEBSTORM_URL" "download webstorm installer"
	cmd_exists $WEBSTORM_CMD "you need to manually install WebStorm with WebStorm.sh command from $DOWNLOAD/$WEBSTORM_ARCHIVE dir"
	dir_linked_to bin/WebStorm $DOWNLOAD/$WEBSTORM_DIR "current WebStorm dir linked to bin/WebStorm"
	file_has_text "/usr/local/bin/wstorm" "$HOME/bin/WebStorm" "webstorm refers to current link"
fi # WEBSTORM_ARCHIVE

if [ ! -z "$VSLICK_ARCHIVE" ]; then
	install_file_from_url_zip "$VSLICK_EXTRACTED" "$VSLICK_ARCHIVE.tar.gz" "$VSLICK_URL" "download visual slick edit installer"
	cmd_exists $VSLICK_CMD "you need to manually install visual slick edit with vsinst command from $DOWNLOAD/$VSLICK_ARCHIVE dir"
fi # VSLICK_ARCHIVE

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

cmd_exists git "need git to clone repos"
make_dir_exist workspace/play "github repo play area"
for repo in $MY_REPOS; do
	install_git_repo "workspace/play" $repo $GITHUB_URL/$repo.git "my github repo $repo"
done

# HEREIAM CUSTOM INSTALL

#============================================================================
# end of main installing, now configuring

pushd bin/fortune
	./mk-fortune.sh && cd starwars && ./mk-fortune-starwars.sh
popd

if [ ! -z "$DROPBOX_URL" ]; then
	# Dropbox configuration
	# TODO workshare re-enable
	#dir_exists .config/autostart "System Settings / Startup & Shutdown / Autostart"
	# TODO workshare customise file and copy?
	file_exists workspace/dropbox-dist/dropboxd.desktop "dropbox autostart saved"
	file_exists .config/autostart/dropboxd.desktop "dropbox autostart" || (cp workspace/dropbox-dist/dropboxd.desktop .config/autostart/dropboxd.desktop)
	dir_linked_to Pictures/WorkSafe $HOME/Dropbox/WorkSafe "link pictures dir to WorkSafe screen saver images"
fi # DROPBOX_URL

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

# gitk configuration
FILE=.config/git/gitk
if [ -f "$FILE" ]; then
	# There are other colors in the config file which are not in the UI
	file_has_text "$FILE" "set mainfont {ProFontWindows 18}" "Edit / Preferences / Font"
	file_has_text "$FILE" "set textfont {ProFontWindows 18}" "Edit / Preferences / Font"
	file_has_text "$FILE" "set uifont {{DejaVu Sans} 12 bold}" "Edit / Preferences / Font"
	file_has_text "$FILE" "set uicolor #000000" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set bgcolor #001000" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set fgcolor #ff58ff" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set diffcolors {red #00a000 #00ebff}" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set markbgcolor #002c39" "Edit / Preferences / Colors"
	file_has_text "$FILE" "set selectbgcolor #20144c" "Edit / Preferences / Colors"
fi # gitk config file

# Meld diff colors
FILE=".gconf/apps/meld/%gconf.xml"
file_linked_to "$FILE" "$HOME/bin/cfg/%gconf.xml" "meld diff config linked"
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
	# ps -ef | grep baloo_file_extractor
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

# oggconvert gui - convert sound files to free formats
# digikam photo metadata/tag/edit software

# EMACS packages
# sudo apt-get install editorconfig exuberant-ctags libparse-exuberantctags-perl
# editorconfig .el files download and put in .emacs.d dir
# https://github.com/editorconfig/editorconfig-emacs/archive/master.zip
# mkdir ~/.emacs.d/lisp
# cp *.el ~/.emacs.d/lisp/
# add to .emacs file:
#(add-to-list 'load-path "~/.emacs.d/lisp")
#(require 'editorconfig)
#(editorconfig-mode 1)

# ace jump mode
# https://github.com/winterTTr/ace-jump-mode/
# https://www.youtube.com/watch?feature=player_embedded&v=UZkpmegySnc#!
# cd ~/.emacs.d/lisp
# wget https://raw.githubusercontent.com/winterTTr/ace-jump-mode/master/ace-jump-mode.el
# add to .emacs file the config on the readme page.
# C-c Space and C-c C-' were chosen as bind keys

# generate javascript tags for emacs
# ctags -e -R --extra=+fq --exclude=db --exclude=test --exclude=.git --exclude=public -f TAGS
# save .ctags config for better javascript

# https://www.linux.com/learn/tutorials/457103-install-and-configure-openvpn-server-on-linux
# for VPN after installing bridge-utils need to restart network
#[14:48:25] Bruno Bossola: Manuel Morales to Linux Users
#"Habemus VPN! And it works from the UI. I followed this http://labnotes.decampo.org/2012/12/ubuntu-1210-connect-to-microsoft-vpn.html
#See my screenshots for Workshare specific config. "
if [ ! -z "$VPN_PKG" ]; then
	FILE="$VPN_CONFIG"
	file_exists "$FILE" "vpn bridge configuration" || copy_file_to_root "$HOME/bin/cfg$COMP/bridge-vpn" "$FILE" "install vpn config for iface br0 inet static"
	file_has_text "$FILE" "iface br0 inet static"

	if [ -z "$HAD_VPN_CONFIG" ]; then
		OK "restart network after vpn bridge configuration"
		sudo /etc/init.d/networking restart
	fi
fi

if /bin/false ; then
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
else
	OK "eclipse will not be configured unless ECLIPSE is non-zero"
fi # ECLIPSE

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

sudo updatedb &

popd

echo COMMANDS="$COMMANDS"
echo PACKAGES="$PACKAGES"


OK "all checks complete"
ENDS

