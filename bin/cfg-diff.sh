#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# backup home dir configuration files to allow a GUI config
# change and then figure out which files changed and what the
# differences were.

DIR=workspace/backup/settings
CONF="config kde gconf p4merge thunderbird"
BACKUP=1

if [ -z $DIFFER ]; then
	source `which differ.sh`
fi

pushd $HOME > /dev/null

if [ $BACKUP == 1 ]; then

	[ -d $DIR ] && rm -rf $DIR
	mkdir -p $DIR

	# Make backup copies of likely config files
	for config in $CONF; do
		echo cp .$config to $DIR/$config
		[ -d .$config ] && cp -r .$config $DIR/$config
	done
	# postgres and mysql configs backed up
	cp .pg* .my* $DIR/

	echo "Configuration files with changes:" > reconfigure.newer
	touch reconfigure.timestamp

	echo Backed up in $DIR/
	ls $DIR
	echo Make some configuration changes in GUI - KDE/firefox now!
	read WAIT

	# for testing manual directory diffing
	#touch .config/lxterminal/lxterminal.conf
	#touch .newfile

	# Get list of files that have been changed, maybe due to the config changes you made.
	find . -newer reconfigure.timestamp -type f | grep -v reconfigure.newer >> reconfigure.newer
fi

less reconfigure.newer

if [ $DIFFERDIRS == 1 ]; then
	# Use diff tool to diff whole dirs
	for config in $CONF; do
		[ -d $DIR/$config ] && $DIFFER .$config $DIR/$config
	done
	#$DIFFER .pgadmin3 $DIR/.pgadmin3 $DIFFERWAIT
else
	# Do manual directory diffing for known directories
	# This could be smarter by looking for the file in the backup dir.
	P1="$DIFFER" P2="$DIR" P3="$CONF" P4="$DIFFERWAIT" perl -i -pne '
		my $dirs = $ENV{P3}; $dirs =~ s{\s+}{|}xmsg;
		unless (s{\A (?:\./)? \. ($dirs) (.+) \n\z}
		{$ENV{P1} ".$1$2" "$ENV{P2}/$1$2" $ENV{P4}\n}xmsgi) {
			if (m{\A Configuration \s files \s with \s changes:}xms) { $_ = qq{\n}; }
			else { s{\A}{less }xms }
		};
		' reconfigure.newer
	source reconfigure.newer
fi

popd > /dev/null

