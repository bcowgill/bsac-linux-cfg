#!/bin/bash
# Using the zoneinfo file, we find out the (ZONE) name used by Javascript Date.toString() for Jan/Jul time zones.
# and create four zone txt files listing all (ZONE) names; mapping (ZONE) name to cities, and mapping city to two possible (ZONE) names for daylight savings.

# older versions of node <=8 used short time zone names (GMT) newer ones use full names (Greenwich Mean Time)
# nvm use v8.11.1; node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString()'
# nvm use v17.9.1; node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString()'
# nvm use v18.12.1; node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString()'

Z=/usr/share/zoneinfo/zone.tab
#Z=./zone-ubuntu.tab
#O=linux-nodev8.11.1
#O=linux
#O=macos-nodev8.11.1
O=macos
MAP=1
#N=v17.9.1
N=v18.12.1

. ~/.nvm/nvm.sh

ZONECODES=`grep -v '#' $Z | awk '{ print $1 }' | sort | head -1`
ZONES=`grep -v '#' $Z | awk '{ print $3 }' | sort`

ZD=zone-times-$O.txt
ZT=zone-names-times-$O.txt
ZN=zone-names-short-$O.txt
ZM=zone-map-$O.txt
ZSL=zone-map-short-long-$O.txt

[ -e $ZD ] && rm $ZD
[ -e $ZT ] && rm $ZT
[ -e $ZSL ] && rm $ZSL
for ZONE in UTC ZULU $ZONECODES $ZONES
do
	echo $ZONE

	# Raw zone/toString output winter/summer
	echo -n "$ZONE: " >> $ZD
	TZ=$ZONE node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString()' >> $ZD
	echo -n "+$ZONE: " >> $ZD
	TZ=$ZONE node -p 'now = new Date("Sat Jul 1 01:02:03 GMT 2023"); now.toString()' >> $ZD

	# zone -> (name) output winter/summer
	echo -n "$ZONE: " >> $ZT
	TZ=$ZONE node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")' >> $ZT
	echo -n "+$ZONE: " >> $ZT
	TZ=$ZONE node -p 'now = new Date("Sat Jul 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")' >> $ZT

	#TZ=$ZONE node -p 'now = new Date("Sat Mar 11 12:18:57 GMT 2023"); now.toString()'
	#TZ=$ZONE node -p 'now = new Date("Sat Mar 11 12:18:57 GMT 2023"); [now.toString(), now.toLocaleString()].join(" ")'

	if [ ! -z "$MAP" ]; then
		# (short) -> (long) output winter/summer
		nvm use v8.11.1 2> /dev/null > /dev/null
		echo -n "$ZONE: " >> $ZSL
		echo -n `TZ=$ZONE node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")'` >> $ZSL
		nvm use $N 2> /dev/null > /dev/null
		TZ=$ZONE node -p 'now = new Date("Sun Jan 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")' >> $ZSL

		nvm use v8.11.1 2> /dev/null > /dev/null
		echo -n "+$ZONE: " >> $ZSL
		echo -n `TZ=$ZONE node -p 'now = new Date("Sat Jul 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")'` >> $ZSL
		nvm use $N 2> /dev/null > /dev/null
		TZ=$ZONE node -p 'now = new Date("Sat Jul 1 01:02:03 GMT 2023"); now.toString().replace(/^.*(\(.*\)).*$/, "$1")' >> $ZSL
	fi
done

# Africa/Accra: (Greenwich Mean Time)
# +Africa/Accra: (Greenwich Mean Time)
perl -pne 's{\A.+\(}{(}xms' $ZT | sort | uniq > $ZN

perl -ne '
	s{\+?(.*):\s+(\(.*\))}{}xms;
	$ZONES{$2}{$1} = 1;

	END
	{
		foreach my $zone (sort(keys(%ZONES)))
		{
			my $rhCities = $ZONES{$zone};
			my @places = sort(keys(%$rhCities));
			print qq{$zone\n\t@{[join("\n\t", @places)]}\n}
		}
	}
' \
	$ZT > $ZM


if [ ! -z "$MAP" ]; then
	mv $ZSL $ZSL.bak
	perl -pne 's{\A.+:\s+}{}xms' $ZSL.bak | sort | uniq | perl -pne 'chomp; $q=chr(39); s{\)\(}{)$q: $q(}xms; $_=qq{$q$_$q,\n}' > $ZSL
	rm $ZSL.bak
fi
