#!/usr/bin/env bash
# =============================================================
#                                                  
#   █████████   █████████                          
#  ███░░░░░███ ███░░░░░███  Suchith Sridhar        
# ░███    ░░░ ░███    ░░░   
# ░░█████████ ░░█████████   https://suchicodes.com 
#  ░░░░░░░░███ ░░░░░░░░███  https://github.com/suchithsridhar
#  ███    ░███ ███    ░███  
# ░░█████████ ░░█████████                            
#  ░░░░░░░░░   ░░░░░░░░░                            
#                                                    
# =============================================================
# A script to configure displays in Hyprland (Wayland).
# =============================================================

# Utility function to turn off unnecessary displays
turn_off_unneeded_displays() {
    all_displays=$(wlr-randr | grep "connected" | cut -d" " -f1)
    local intended_displays=("$@")
    for display in $all_displays; do
        local needed=false
        for intended_display in "${intended_displays[@]}"; do
            if [[ $display == $intended_display ]]; then
                needed=true
                break
            fi
        done
        if [[ $needed == false ]]; then
            wlr-randr --output $display --off
        fi
    done
}

case "$1" in
    # Single display
    edp)
        turn_off_unneeded_displays "eDP-1"
        wlr-randr \
            --output eDP-1 --mode 1920x1080 --pos 0,0
        ;;
    hdmi)
        turn_off_unneeded_displays "HDMI-A-1"
        wlr-randr \
            --output HDMI-A-1 --mode 1920x1080 --pos 0,0
        ;;
    usbc)
        turn_off_unneeded_displays "DP-1"
        wlr-randr \
            --output DP-1 --mode 1920x1080 --pos 0,0
        ;;

    # Two Horizontal Displays
    edp-hdmi)
        turn_off_unneeded_displays "eDP-1" "HDMI-A-1"
        wlr-randr \
            --output eDP-1 --mode 1920x1080 --pos 0,0 \
            --output HDMI-A-1 --mode 1920x1080 --pos 1920,0
        ;;
    edp-hdmi-alt)
        turn_off_unneeded_displays "eDP-1" "HDMI-A-1"
        wlr-randr \
            --output eDP-1 --mode 1920x1080 --pos 0,0 \
            --output HDMI-A-1 --mode 1920x1080 --pos 1920,0
        ;;
    edp-usbc)
        turn_off_unneeded_displays "eDP-1" "DP-1"
        wlr-randr \
            --output eDP-1 --mode 1920x1080 --pos 0,0 \
            --output DP-1 --mode 1920x1080 --pos 1920,0
        ;;
    hdmi-usbc)
        turn_off_unneeded_displays "HDMI-A-1" "DP-1"
        wlr-randr \
            --output HDMI-A-1 --mode 1920x1080 --pos 0,0 \
            --output DP-1 --mode 1920x1080 --pos 1920,0
        ;;

    # Triple displays
    edp-hdmi-usbc)
        turn_off_unneeded_displays "HDMI-A-1" "DP-1" "eDP-1"
        wlr-randr \
            --output eDP-1 --mode 1920x1080 --pos 0,0 \
            --output HDMI-A-1 --mode 1920x1080 --pos 1920,0 \
            --output DP-1 --mode 1920x1080 --pos 3840,0
        ;;
    *)
        echo "Invalid option for configuring displays"
        ;;
esac

sleep 1

hyprctl reload
