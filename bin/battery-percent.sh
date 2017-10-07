# cross-platform battery percentage indicator
if which pmset > /dev/null; then
	pmset -g batt | perl -ne 'print "$1 🔋 \n" if m{(\d+\%)}xms'
	exit 0
fi
#upower --show-info /org/freedesktop/UPower/devices/battery_BAT1 \
for power in `upower --enumerate`; do
	upower --show-info $power | perl -ne 's{\s+}{ }xmsg; print qq{$_\n} if m{BAT|percent|capacity}xms' \
		| perl -ne 'chomp; if (s{\A\s*(percentage:\s*)}{}xms) { $_ .= "🔋 "; print }'
done
echo " "
