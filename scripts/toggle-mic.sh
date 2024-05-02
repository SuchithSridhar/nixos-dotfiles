#!/bin/bash
# Author: Suchith Sridhar
# Website: https://suchicodes.com/
#
# Toggle the current state of the mic

# Send the notification before the toggling
# because the 'toggle' command takes a second
if ( amixer | grep "Capture" | grep -q "off" ); then
    dunstify " Microphone Toggled" "Mic State: ON"
else
    dunstify " Microphone Toggled" "Mic State: OFF"
fi

amixer set "Capture" toggle
