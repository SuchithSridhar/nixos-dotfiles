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

# Check for active monitors and disable unneeded ones
disable_unneeded_displays() {
    sleep 3
    active_monitors=$(hyprctl monitors all | grep 'Monitor' | awk '{print $2}' | tr -d '()')
    for monitor in $active_monitors; do
        local needed=false
        for intended_monitor in "$@"; do
            if [[ $monitor == $intended_monitor ]]; then
                needed=true
                break
            fi
        done
        if [[ $needed == false ]]; then
            hyprctl keyword monitor $monitor,disable
        fi
    done
}

case "$1" in
    # Single display configurations
    edp)
        hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
        disable_unneeded_displays "eDP-1"
        ;;
    hdmi)
        hyprctl keyword monitor HDMI-A-1,1920x1080@60,0x0,1
        disable_unneeded_displays "HDMI-A-1"
        ;;
    usbc)
        hyprctl keyword monitor DP-1,1920x1080@60,0x0,1
        disable_unneeded_displays "DP-1"
        ;;

    # Dual monitor configurations
    edp-hdmi)
        hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
        hyprctl keyword monitor HDMI-A-1,1920x1080@60,1920x0,1
        disable_unneeded_displays "eDP-1" "HDMI-A-1"
        ;;
    edp-usbc)
        hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
        hyprctl keyword monitor DP-1,1920x1080@60,1920x0,1
        disable_unneeded_displays "eDP-1" "DP-1"
        ;;
    hdmi-usbc)
        hyprctl keyword monitor HDMI-A-1,1920x1080@60,0x0,1
        hyprctl keyword monitor DP-1,1920x1080@60,1920x0,1
        disable_unneeded_displays "HDMI-A-1" "DP-1"
        ;;

    # Triple monitor configurations
    edp-hdmi-usbc)
        hyprctl keyword monitor eDP-1,1920x1080@60,0x0,1
        hyprctl keyword monitor HDMI-A-1,1920x1080@60,1920x0,1
        hyprctl keyword monitor DP-1,1920x1080@60,3840x0,1
        disable_unneeded_displays "eDP-1" "HDMI-A-1" "DP-1"
        ;;
    *)
        echo "Invalid option for configuring displays"
        ;;
esac
