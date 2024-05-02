#!/bin/bash
# Author: Suchith Sridhar
# Website: https://suchicodes.com/
#
# Purpose: Take screenshots in multiple ways and
# copy said screenshot to the clipboard.
#
# Dependencies: flameshot, scrot, wl-clipboard

# Usage: ./<script name> <option>
#   Options:
#       - q: temporary with gui selector
#       - w: temporary of currently focused window
#       - e: temporary of current monitor
#       - r: temporary of all displays (as one screenshot)
#
#       - a: permanent with gui selector
#       - s: permanent of currently focused window
#       - d: permanent of current monitor
#       - f: permanent of all displays (as one screenshot)
#
#    Temporary: Saves screenshot as "a_screenshot.png"
#    Permanent: Saves screenshot with timestamp.
#       


# Folder to save screenshots to
base_folder="$HOME/Pictures/ScreenShots/"


# These make the screenshot a "permanent" screenshot
if echo "qwero" | grep -q $1 ; then
    output="$base_folder"$(date +"ss_%y-%m-%d__%H-%M-%S(%3N)").png

# These make the screenshot a "temporary" screenshot
elif echo "asdf" | grep -q $1 ; then
    output="$base_folder""a_screenshot.png"
else
    exit
fi

# Select a region of the screen for the screenshot
if echo "qa" | grep -q $1 ; then
    flameshot gui -r > "${output}"

# Screenshot of the window in focus
elif echo "ws" | grep -q $1 ; then
    scrot -ub $base_folder"temp.png"
    mv -f $base_folder"temp.png" $output

# Screenshot of the current monitor
elif echo "ed" | grep -q $1 ; then
    flameshot screen -r > "$output"

# Screenshot of all the monitors
elif echo "rf" | grep -q $1 ; then
    flameshot full -r > "$output"

# Convert the last temporary screenshot to a permanent 
elif echo "o" | grep -q $1 ; then
    cp "$HOME/Pictures/ScreenShots/a_screenshot.png" "$output"
fi

# Copy the screenshot to the clipboard
wl-copy < $output
notify-send "Screenshot Saved" $output
