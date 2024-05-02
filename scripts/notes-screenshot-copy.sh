#!/usr/bin/env bash
# Author: Suchith Sridhar
# Website: https://suchicodes.com/
#
# Save the most recent temporary screenshot
# as the next pic<num>.png in the folder specified
# in the picpath file.
#
# Temporary screenshot is picture at path:
# ~/Pictures/ScreenShots/a_screenshot.png
#
# There is another script "setpicpath.sh" that can be
# used to set the path of the pic.

COUNTER=1;
BASE=`cat $HOME/.config/custom-config/picpath`
while true; do
    if [ -f "$BASE/pic$COUNTER.png" ] || [ -f "$BASE/pic$COUNTER.jpg" ]; then
        let COUNTER+=1;
    else
        cp $HOME/Pictures/ScreenShots/a_screenshot.png "$BASE/pic$COUNTER.png"
        notify-send "Copied to $BASE/pic$COUNTER.png"
        break
    fi
done
