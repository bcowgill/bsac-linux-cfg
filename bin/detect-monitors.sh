#!/bin/bash
# BSACSYS Part of Brent S.A. Cowgill's System Toolkit
# detect which monitors are attached
# source `which detect-monitors.sh` will define OUTPUT_MAIN/OUTPUT_AUX/OUTPUT_RES
# detect-monitors.sh show -- shows detail about monitors
# detect-monitors.sh i3-update -- will update then i3-config file with then connected monitors

RES=1920x1080
RES2=1280x1024
OUTPUT_MAIN=
OUTPUT_AUX=
OUTPUT_AUX2=
OUTPUT_RES_MAIN=
OUTPUT_RES_AUX=
OUTPUT_RES_AUX2=

XROUT=$(mktemp)
XRERR=$(mktemp)
xrandr >> $XROUT 2> $XRERR

if [ "${1:-quiet}" == "show" ]; then
	# if show option provided, show all resolutions with computed aspect ratio
	perl -pne 's{\s{2}(\d+)x(\d+)\s{2}}{qq{  $1x$2  @{[substr($1/$2,0,7)]}}}xmsge' < $XROUT
else
	grep ' connected' < $XROUT
fi

MONITORS=`grep ' connected' < $XROUT | wc -l`
MONITOR_NAMES=`grep ' connected' < $XROUT | perl -pne 's{\A (\w+) .+ \z}{$1\n}xms'`

# force values when testing...
#MONITORS=2
#MONITOR_NAMES='eDP1 HDMI1'
#MONITORS=3
#MONITOR_NAMES='eDP1 DP1 HDMI1'

# eDP1 is laptop main screen
#eDP1 connected primary 1920x1080+1920+0 (normal left inverted right x axis y axis) 346mm x 194mm
#DP1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 477mm x 268mm
#HDMI1 disconnected (normal left inverted right x axis y axis)
#HDMI2 disconnected (normal left inverted right x axis y axis)
#VGA1 disconnected (normal left inverted right x axis y axis)
#VIRTUAL1 disconnected (normal left inverted right x axis y axis)

if egrep '   ' < $XROUT | grep $RES > /dev/null ; then
	echo resolution $RES ok
else
	echo did not detect desired resolution $RES
	rm $XROUT $XRERR
	exit 1
fi

if [ $MONITORS == 1 ]; then
	# set up single monitor
	MAIN=$MONITOR_NAMES
	AUX=$MAIN
	AUX2=$MAIN
	RES2=$RES
	echo $MAIN `xrandr --dryrun --output $MAIN --mode $RES 2> $XRERR`
else
	if [ $MONITORS == 2 ]; then
		RES2=$RES
		# set up dual monitors to show in same resolution
		for mon in $MONITOR_NAMES; do
			MAIN=${AUX:-$mon}
			AUX=$mon
		done
		AUX2=$AUX
		echo $MAIN `xrandr --dryrun --output $MAIN --mode $RES 2> $XRERR`
		echo $AUX `xrandr --dryrun --output $AUX --mode $RES2 2> $XRERR`
	else
		if [ $MONITORS == 3 ]; then
			# set up three monitors
			# eDP1 DP1 HDMI1
			for mon in $MONITOR_NAMES; do
				if [ -z $MAIN ]; then
					MAIN=$mon
				else
					if [ -z $AUX2 ]; then
						AUX2=$mon
					else
						AUX=$mon
					fi
				fi
			done
			echo $MAIN `xrandr --dryrun --output $MAIN --mode $RES 2> $XRERR`
			echo $AUX  `xrandr --dryrun --output $AUX --mode $RES2 2> $XRERR`
			echo $AUX2 `xrandr --dryrun --output $AUX2 --mode $RES 2> $XRERR`
		else
			echo $MONITORS monitors found, unexpected
			echo $MONITOR_NAMES
			rm $XROUT $XRERR
			exit 1
		fi
	fi
fi

if [ $RES != $RES2 ]; then
	if egrep '   ' < $XROUT | grep $RES2 > /dev/null ; then
		echo resolution $RES2 ok
	else
		echo did not detect desired resolution $RES2
		rm $XROUT $XRERR
		exit 1
	fi
fi

OUTPUT_MONITORS=$MONITORS
OUTPUT_MAIN=$MAIN
OUTPUT_AUX=$AUX
OUTPUT_AUX2=$AUX2
OUTPUT_RES_MAIN=$RES
OUTPUT_RES_AUX=$RES
OUTPUT_RES_AUX2=$RES
export OUTPUT_MONITORS OUTPUT_MAIN OUTPUT_AUX OUTPUT_AUX2 OUTPUT_RES_MAIN OUTPUT_RES_AUX OUTPUT_RES_AUX2
echo OUTPUT_MONITORS=$OUTPUT_MONITORS
echo OUTPUT_MAIN=$OUTPUT_MAIN
echo OUTPUT_AUX=$OUTPUT_AUX
echo OUTPUT_AUX2=$OUTPUT_AUX2
echo OUTPUT_RES_MAIN=$OUTPUT_RES_MAIN
echo OUTPUT_RES_AUX=$OUTPUT_RES_AUX
echo OUTPUT_RES_AUX2=$OUTPUT_RES_AUX2

if [ ${1:-normal} == i3-update ]; then
	i3-config-update.sh
fi
