#!/usr/bin/env bash
# Author: Suchith Sridhar
# Website: https://suchicodes.com/
#
# Purpose: Take screenshots in multiple ways and
# copy said screenshot to the clipboard using Hyprshot.
#
# Dependencies: hyprshot, wl-clipboard

# Usage: ./<script name> <option>
#   Options:
#       - q: temporary with gui selector (region)
#       - w: temporary of currently focused window
#       - e: temporary of current monitor
#       - r: temporary of all displays (not directly supported, treated as current monitor)
#
#       - a: permanent with gui selector (region)
#       - s: permanent of currently focused window
#       - d: permanent of current monitor
#       - f: permanent of all displays (not directly supported, treated as current monitor)
#
#    Temporary: Saves screenshot as "a_screenshot.png"
#    Permanent: Saves screenshot with timestamp.

# Folder to save screenshots to
base_folder="$HOME/Pictures/Screenshots/"

# Determine if it's a permanent or temporary screenshot
if echo "qwero" | grep -q $1 ; then
    # Permanent screenshot
    filename=$(date +"ss_%y-%m-%d__%H-%M-%S(%3N)").png
elif echo "asdf" | grep -q $1 ; then
    # Temporary screenshot
    filename="a_screenshot.png"
else
    echo "Invalid command"
    exit 1
fi

output="$base_folder$filename"

# Take screenshot based on the input option
case $1 in
    q|a)  # Region selection
        hyprshot -m region -o "$base_folder" -f "$filename"
        ;;
    w|s)  # Currently focused window
        hyprshot -m window -c -o "$base_folder" -f "$filename"
        ;;
    e|d)  # Current monitor
        hyprshot -m output -c -o "$base_folder" -f "$filename"
        ;;
    r|f)  # All displays (treated as current monitor)
        hyprshot -m output -o "$base_folder" -f "$filename"
        ;;
    *)    # Invalid option
        echo "Invalid option: $1"
        exit 1
        ;;
esac

# Notification
notify-send "Screenshot Saved" "$output"
wl-copy < "$output"
