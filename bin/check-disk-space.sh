#!/bin/bash
# Show a notification if low disk space anywhere important
LIMIT=${1:-70}
SEVERITY=${2:-LOW}
SILENCE='/tmp/check-disk-space.SILENCE'

function check_space {
	local notify
	notify=$1
	df -h --output=target,fstype,avail,pcent,source \
		| grep -vE 'tmpfs|iso9660|ADR620-16GB' \
		| NOTIFY=$notify LIMIT=$LIMIT SEVERITY="$SEVERITY" perl -ne '
			$print = 0;
			if (m{(\d+)\%}xms && $1 > $ENV{LIMIT})
			{
				$print = qq{$ENV{SEVERITY} DISK SPACE: $_};
				$print =~ s{\%}{% full}xmsg;
				$print =~ s{\s+}{ }xmsg;
			}
			if ($print)
			{
				print $print;
				if ($ENV{NOTIFY})
				{
					my $num = int(1+rand(3));
					system(qq{mynotify.sh "check-disk-space.sh" "$print"});
					system(qq{sound-play.sh "~/bin/sounds/critical-disk-space-spoken$num.mp3"}) if ($ENV{LIMIT} > 90 && !-e $SILENCE);
				}
			}
		'
}

function check_here {
	local where
	where="$1"
	if [ -d "$where" ]; then
		pushd "$where" > /dev/null
		echo " "
		echo $where - space hogs:
		du -sh --threshold=1G * 2> /dev/null
		popd > /dev/null
	fi
}

if check_space | grep  'DISK SPACE' > /dev/null; then
	check_space notify
	check_here $HOME
	check_here $HOME/d
	check_here $HOME/d/backup
	check_here $HOME/d/Download
	check_here /data/$USER
	check_here /data/$USER/backup
	check_here /tmp
	check_here /home
	check_here /var
	check_here /var/lib
	#check_here /
fi
echo " "
if [ -e $SILENCE ]; then
	echo Note: file $SILENCE exists, no audible alarms will sound when there is a CRITICAL lack of disk space.
else
	echo Note: to silence the audible alarm about CRITICAL disk space,
	echo touch $SILENCE
fi

exit $?

MacOS df command does not allow -output selection, must parse this...
df -h
Filesystem       Size   Used  Avail Capacity iused      ifree %iused  Mounted on
/dev/disk1s5s1  466Gi   19Gi  314Gi     6%  553785 4882923135    0%   /
devfs           192Ki  192Ki    0Bi   100%     664          0  100%   /dev
/dev/disk1s4    466Gi  1.0Mi  314Gi     1%       1 4883476919    0%   /System/Volumes/VM
/dev/disk1s2    466Gi  274Mi  314Gi     1%     760 4883476160    0%   /System/Volumes/Preboot
/dev/disk1s6    466Gi  109Mi  314Gi     1%     394 4883476526    0%   /System/Volumes/Update
/dev/disk1s1    466Gi  132Gi  314Gi    30% 3785320 4879691600    0%   /System/Volumes/Data
map auto_home     0Bi    0Bi    0Bi   100%       0          0  100%   /System/Volumes/Data/home
/dev/disk1s5    466Gi   19Gi  314Gi     6%  553607 4882923313    0%   /System/Volumes/Update/mnt1
