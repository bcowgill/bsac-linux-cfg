#upower --show-info /org/freedesktop/UPower/devices/battery_BAT1 \
for power in `upower --enumerate`; do
    echo $power
    upower --show-info $power | perl -ne 's{\s+}{ }xmsg; print if m{BAT|percent|capacity}xms'
done
echo " "
