#!/usr/bin/env bash
# Author: Suchith Sridhar
# Website: https://suchicodes.com/
#
# Set the path for the program that
# "notes-screenshot-copy.sh" uses to save
# pictures.

if [ "$1" != "" ]; then
    if [ -d "$1" ]; then
        echo `realpath $1` > $HOME/.config/custom-config/picpath
        exit 0
    else
        echo "Invalid path for picpath."
        exit 1
    fi
fi
echo "$(pwd)" > $HOME/.config/custom-config/picpath
