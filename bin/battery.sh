# cross-platform useful battery information
#upower --show-info /org/freedesktop/UPower/devices/battery_BAT1 \
if which pmset > /dev/null; then
	pmset -g batt
	exit 0
fi
for power in `upower --enumerate`; do
    echo $power
    upower --show-info $power | perl -ne 's{\s+}{ }xmsg; print if m{BAT|percent|capacity}xms'
done
echo " "
