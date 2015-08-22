 upower --show-info /org/freedesktop/UPower/devices/battery_BAT1 | egrep 'percentage|capacity' | perl -pne 's{(percentage)}{battery $1}xms'
