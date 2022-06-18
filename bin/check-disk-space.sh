#!/bin/bash
# Show a notification if low disk space anywhere important
LIMIT=${1:-70}
SEVERITY=${2:-LOW}

function check_space {
	local notify
	notify=$1
	df -h --output=target,fstype,avail,pcent,source \
		| grep -v tmpfs \
		| NOTIFY=$notify LIMIT=$LIMIT SEVERITY="$SEVERITY" perl -ne '
			$print = 0;
			if (m{(\d+)\%}xms && $1 > $ENV{LIMIT})
			{
				$print = qq{$ENV{SEVERITY} DISK SPACE: $_};
				$print =~ s{\%}{% full}xmsg;
				$print =~ s{\s+}{ }xmsg;
			}
			print $print if $print;
			system(qq{mynotify.sh "check-disk-space.sh" "$print"}) if $print && $ENV{NOTIFY};
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
	check_here "/lost+found"
	check_here /home
	check_here /var
	check_here /var/lib
	#check_here /
fi
