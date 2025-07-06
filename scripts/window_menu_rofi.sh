#!/bin/bash

# Alternative version using rofi instead of wofi
# To use this version, rename it to window_menu.sh

# Get the current window information
ACTIVE_WINDOW=$(hyprctl activewindow -j)
WINDOW_CLASS=$(echo "$ACTIVE_WINDOW" | jq -r '.class')
WINDOW_TITLE=$(echo "$ACTIVE_WINDOW" | jq -r '.title')

# Create menu options with icons
MENU_OPTIONS="󰅖 Close Window
󰕰 Minimize Window
󰊓 Toggle Fullscreen
󰌌 Move to Workspace 1
󰌌 Move to Workspace 2
󰌌 Move to Workspace 3
󰌌 Move to Workspace 4
󰌌 Move to Workspace 5
󰙵 Window Properties
󰕰 List All Windows"

# Show the menu using rofi with inline styling to match waybar
SELECTED=$(echo "$MENU_OPTIONS" | rofi -dmenu -p "Window Actions" -font "JetBrains Mono 13" -width 25 -lines 10 -location 0 -color-enabled -color-window "#141e1e,#333,#7aa2f7" -color-normal "#141e1e,#a6adc8,#2a2a2e,#e0e0e0,#7aa2f7" -color-active "#141e1e,#7aa2f7,#2a2a2e,#e0e0e0,#7aa2f7" -color-urgent "#141e1e,#f38ba8,#2a2a2e,#e0e0e0,#f38ba8")

# Execute the selected action
case "$SELECTED" in
    "󰅖 Close Window")
        hyprctl dispatch closewindow
        ;;
    "󰕰 Minimize Window")
        # Hyprland doesn't have traditional minimize, so we'll move to special workspace
        hyprctl dispatch movetoworkspacesilent special
        ;;
    "󰊓 Toggle Fullscreen")
        hyprctl dispatch fullscreen
        ;;
    "󰌌 Move to Workspace 1")
        hyprctl dispatch movetoworkspace 1
        ;;
    "󰌌 Move to Workspace 2")
        hyprctl dispatch movetoworkspace 2
        ;;
    "󰌌 Move to Workspace 3")
        hyprctl dispatch movetoworkspace 3
        ;;
    "󰌌 Move to Workspace 4")
        hyprctl dispatch movetoworkspace 4
        ;;
    "󰌌 Move to Workspace 5")
        hyprctl dispatch movetoworkspace 5
        ;;
    "󰙵 Window Properties")
        notify-send "Window Info" "Class: $WINDOW_CLASS\nTitle: $WINDOW_TITLE"
        ;;
    "󰕰 List All Windows")
        hyprctl clients -j | jq -r '.[] | "\(.class) - \(.title)"' | rofi -dmenu -p "All Windows" -font "JetBrains Mono 13" -width 35 -lines 10 -location 0 -color-enabled -color-window "#141e1e,#333,#7aa2f7" -color-normal "#141e1e,#a6adc8,#2a2a2e,#e0e0e0,#7aa2f7" -color-active "#141e1e,#7aa2f7,#2a2a2e,#e0e0e0,#7aa2f7" -color-urgent "#141e1e,#f38ba8,#2a2a2e,#e0e0e0,#f38ba8"
        ;;
esac
