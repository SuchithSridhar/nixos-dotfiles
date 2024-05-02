#!/usr/bin/env bash
# Author: Suchith Sridhar
# Website: https://suchicodes.com/

# Program Description:
# Program checks the battery and sends a notification
# based on min and max battery specified.
# 2 ways a notification is generated:
# if (currentBattery > maxBattery AND battery is charging) or
# if (currentBattery < minBattery AND battery is not charging)

# NOTE: Added grep -vw 0 since acpi was showing 2 batteries and that
# got rid of the second incorrect battery information.

# Program usually run as cronjob every 5 mins:
# */5 * * * * <script-location>

minBattery=20
maxBattery=95
fullBattery=100

export DISPLAY=":0.0"
export XAUTHORITY="/home/suchi/.Xauthority"
export XDG_RUNTIME_DIR="/run/user/1000"
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)' | grep -vw "0"`
not_charging=`acpi -b | grep -i " charging,"`

if [ "$battery_level" -le "$minBattery" ] && [ "$not_charging" == "" ]
then
    /usr/bin/gotify push "Low battery" -p 9
    /usr/bin/notify-send -u "critical" "Battery low" "Battery at ${battery_level}%!" -a "Script"
    /usr/bin/mpg123 /home/suchi/.local/share/sounds/low_battery.mp3
fi

if [ "$battery_level" -ge "$fullBattery" ] && [ "$not_charging" != "" ]
then
    /usr/bin/gotify push "Laptop battery full." -p 9
    /usr/bin/notify-send "Battery charged" "Battery at ${battery_level}%." -a "Script"
elif [ "$battery_level" -ge "$maxBattery" ] && [ "$not_charging" != "" ]
then
    /usr/bin/notify-send "Battery charged" "Battery at ${battery_level}%." -a "Script"
fi

