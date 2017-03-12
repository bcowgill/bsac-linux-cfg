# no shebang line or history.log will be empty.
# Take a snapshot of the system for later comparison
# snapshot.sh %d-directory  # will add the date to the directory created

# Save a copy of the environment vars before we change it
_TMP_SET=`mktemp`
set | grep -v _TMP_SET >> $_TMP_SET

# Replace %d in directory name with time now.
NOW=`date +%F-%H-%M`
DIR="${1:-sys-snapshot-%d}"
DIR=`perl -e 'my ($dir, $now) = @ARGV; $dir =~ s{\%d}{$now}xmsg; print $dir;' "$DIR" $NOW`

EXIT=0
GENERIFY=`which filter-generify.pl`
EDITOR=${EDITOR:-vim}

function main
{
	echo Saving a system snapshot to directory $DIR
	mkdir -p "$DIR"

	# save the environment file
	FILE="$DIR/set.log"
	echo " "
	echo "### Envirnonment settings" | tee "$FILE"
	echo "set"                       | tee --append "$FILE"
	echo " "                         | tee --append "$FILE"
	cat $_TMP_SET                    | tee --append "$FILE"

	FILE="$DIR/00-README.log"
	echo " "
	echo "### System snapshot $NOW to $DIR"  > "$FILE"
	echo ". describe the state of the machine or why the snapshot was taken..." >> "$FILE"
	(\
		echo date `date`; \
		echo hostname `hostname`; \
		echo whoami `whoami`; \
		echo groups `groups`; \
		echo /etc/issue `cat /etc/issue` \
	) >> "$FILE" 2>&1
	$EDITOR "$FILE"
	cat "$FILE"

# TODO this fails to show the command history!!
	capture history " " "Shell history"

	capture_clean ps -ef "Running processes"
	capture top "-b -n 1" "Top processes"

	# dmesg --ctime to add time to log
	capture dmesg --notime "Kernel boot ring buffer"

	capture lscpu " " "CPU information"
	capture lspci -t "PCI devices"

	capture lsusb -v "USB devices verbose"
	mv "$FILE" "$DIR/lsusb-verbose.log"
	capture lsusb -t "USB devices tree"

	# probably more compatible settings
	LSBLK="--ascii --all --fs --perms --discard --topology"
	LSBLK="--ascii --all --output NAME,SIZE,TYPE,RM,RO,MODE,OWNER,GROUP,MOUNTPOINT,FSTYPE,LABEL,UUID,ALIGNMENT,MIN-IO,OPT-IO,PHY-SEC,LOG-SEC,ROTA,SCHED,RQ-SIZE,DISC-ALN,DISC-GRAN,DISC-MAX,DISC-ZERO,STATE,MAJ:MIN,KNAME"
	capture lsblk "$LSBLK" "Block devices"

	capture lsinitramfs "-l /boot/*" "Initial RAM file system inforamtion, if any"

	capture lsmod " "  "Kernel modules"

	capture lscgroup " " "Process control groups"

	capture lssubsys "--all --all-mount-points --hierarchies" "Subsystems"

	su_capture fdisk -l "Low level disk partitions"
	capture mount -l "Logical disk structure"

	capture df "--all -k --total --print-type" "Free disk space"

	sudo du -k / 2> "$DIR/du-k-errors.log" | sort -g -r | head -500 > $_TMP_SET
	FILE="$DIR/du-k.log"
	echo " "
	echo "### Top 500 disk usage"           | tee "$FILE"
	echo "du -k / | sort -g -r | head -500" | tee --append "$FILE"
	echo " "                                | tee --append "$FILE"
	cat $_TMP_SET                           | tee --append "$FILE"

	FILE="$DIR/dpkg.log"
	echo " "
	echo "### Debian package listing"       > "$FILE"
	echo "dpkg --list '*'"                  >> "$FILE"
	echo " "                                >> "$FILE"
	dpkg --list '*'                         >> "$FILE" 2>&1
	perl -i -ne 'if ($. > 8) { $_ = undef if m{\A . n}xms }; print if defined($_)' "$FILE"
	cat "$FILE"

	capture_clean ls "-Alr `echo $PATH | sed -e 's/:/ /g'`" "Executables on the path"
	mv "$FILE" "$DIR/ls-path-files.log"

	capture_clean ls "-AlR /media" "Mounted media file lising"
	mv "$FILE" "$DIR/ls-media.log"

	capture ifconfig -a "Network interfaces"
	capture iwconfig " " "Wireless network interfaces"
	capture iwlist scan "Wireless access points"

	capture ping "-c 3 google.com" "Ping connectivity"
	capture traceroute "-m 10 google.com" "Traceroute connectivity"

	BOOT="cmdline.txt config.txt issue.txt os_config.json"
	for ITEM in $BOOT;
	do
		capture_file "/boot/$ITEM"
	done

	PROC="consoles cpuinfo crypto devices diskstats interrupts iomem ioports locks meminfo misc pagetypeinfo partitions sched_debug softirqs stat swaps timer_list timer_stats uptime vc-cma version vmstat zoneinfo"
	for ITEM in $PROC;
	do
		capture_file "/proc/$ITEM"
	done

	ETC="network/interfaces networks resolv.conf"
	for ITEM in $ETC;
	do
		capture_file "/etc/$ITEM"
	done

	sudo cat /etc/wpa_supplicant/wpa_supplicant.conf | perl -pne 's{psk="[^"]*"}{psk="password"}xmsg' > $_TMP_SET
	FILE="$DIR/etc-wpa_supplicant-wpa_supplicant.conf.log"
	echo " "
	echo "### WiFi configuration password filtered" | tee "$FILE"
	echo "/etc/wpa_supplicant/wpa_supplicant.conf"  | tee --append "$FILE"
	echo " "                                        | tee --append "$FILE"
	cat $_TMP_SET                                   | tee --append "$FILE"

	FILE="$DIR/01-rc.d-init.d.log"
	echo " "
	echo "### System V Init Symlink configuration"  | tee "$FILE"
	echo "ls -Al /etc/init.d /etc/rc\*.d"           | tee --append "$FILE"
	echo " "                                        | tee --append "$FILE"
	ls -Al /etc/init.d /etc/rc*.d 2>&1  | $GENERIFY | tee --append "$FILE"

	FILE="$DIR/02-cron.log"
	echo " "
	echo "### Cron table configuration"            | tee "$FILE"
	echo "cat /etc/crontab"                        | tee --append "$FILE"
	echo "ls -Alr /etc/cron\*"                     | tee --append "$FILE"
	echo " "                                       | tee --append "$FILE"
	cat /etc/crontab 2>&1                          | tee --append "$FILE"
	ls -Alr /etc/cron* 2>&1            | $GENERIFY | tee --append "$FILE"

	# save the /etc dir
	FILE="$DIR/03-tar-etc.log"
	echo " "
	echo "### /etc configuration snapshot"         | tee "$FILE"
	echo "tar cvzf "$DIR/etc-snapshot.tgz" /etc"   | tee --append "$FILE"
	echo " "                                       | tee --append "$FILE"
	tar cvzf "$DIR/etc-snapshot.tgz" /etc 2>&1     | tee --append "$FILE"

	FILE="$DIR/99-errors.err"
	echo " "
	echo "### Problems during snapshot" | tee "$FILE"
	egrep -ri "(command not found|warn|error|Permission denied|No such|Cannot (open|find)| is not | will be missing|tar: /)" "$DIR" | tee --append "$FILE"

	# save the script too, as a backup
	cp "$0" "$DIR"
	cp "$GENERIFY" "$DIR"

}

# capture the output of a command to a snapshot file
function capture
{
	local cmd args msg
	cmd="$1"
	args="$2"
	msg="$3"

	# export the file name from the function
	FILE="$DIR/$cmd.log"

	echo " "
	echo "### $msg"   | tee "$FILE"
	echo "$cmd $args" | tee --append "$FILE"
	echo " "          | tee --append "$FILE"

	$cmd $args 2>&1   | tee --append "$FILE"
}

# capture the output of a command to a snapshot file and clean up dates/times
function capture_clean
{
	local cmd args msg
	cmd="$1"
	args="$2"
	msg="$3"

	# export the file name from the function
	FILE="$DIR/$cmd.log"

	echo " "
	echo "### $msg"   | tee "$FILE"
	echo "$cmd $args" | tee --append "$FILE"
	echo " "          | tee --append "$FILE"

	$cmd $args 2>&1   | $GENERIFY | tee --append "$FILE"
}


# capture the output of a superuser command to a snapshot file
function su_capture
{
	local cmd args msg
	cmd="$1"
	args="$2"
	msg="$3"

	# export the file name from the function
	FILE="$DIR/$cmd.log"

	echo " "
	echo "### $msg"        | tee "$FILE"
	echo "sudo $cmd $args" | tee --append "$FILE"
	echo " "               | tee --append "$FILE"

	sudo $cmd $args 2>&1   | tee --append "$FILE"
}

# capture a file from somewhere
function capture_file
{
	local path msg   file
	path="$1"
	msg="$2"
	file=`echo $path | sed -e "s/\//-/g; s/^-//"`

	# export the file name from the function
	FILE="$DIR/$file.log"

	echo " "
	echo "### $msg"   | tee "$FILE"
	echo "$path"      | tee --append "$FILE"
	echo " "          | tee --append "$FILE"

	cat "$path" 2>&1  | tee --append "$FILE"
}

if [ ! -d "$DIR" ]; then
	main
else
	echo "Directory $DIR already exists, will not overwrite."
	EXIT=1
fi

# Clean up temp file now we are done with it
rm $_TMP_SET
exit $EXIT
