#!/bin/bash

# Window management script for Waybar hyprland/window module
# Provides dropdown menu with window management options

# Check if jq is available
if ! command -v jq &> /dev/null; then
    notify-send "Error" "jq not found. This script requires jq for JSON parsing."
    exit 1
fi

# Check if hyprctl is available
if ! command -v hyprctl &> /dev/null; then
    notify-send "Error" "hyprctl not found. This script requires Hyprland."
    exit 1
fi

# Check if rofi is available, fallback to wofi
if command -v rofi &> /dev/null; then
    MENU_CMD="rofi -dmenu -i -p 'Window Action' -theme-str 'window {width: 300px;}'"
elif command -v wofi &> /dev/null; then
    MENU_CMD="wofi --dmenu --prompt 'Window Action' --width 300 --height 300"
else
    notify-send "Error" "Neither rofi nor wofi found. Please install one of them."
    exit 1
fi

# Get active window information
active_window=$(hyprctl activewindow -j 2>/dev/null)
if [[ -z "$active_window" || "$active_window" == "Invalid" ]]; then
    notify-send "No Active Window" "No window is currently active."
    exit 1
fi

# Extract window information
window_class=$(echo "$active_window" | jq -r '.class // "Unknown"')
window_title=$(echo "$active_window" | jq -r '.title // "Unknown"')
window_address=$(echo "$active_window" | jq -r '.address // ""')
window_workspace=$(echo "$active_window" | jq -r '.workspace.name // "Unknown"')
window_fullscreen=$(echo "$active_window" | jq -r '.fullscreen // false')

# Check if window is maximized (fullscreen state 1 = maximized)
if [[ "$window_fullscreen" == "1" ]]; then
    maximize_text="󰕇 Restore Window"
else
    maximize_text="󰕃 Maximize Window"
fi

# Menu options
options="󰅖 Close Window
󰕞 Minimize Window
$maximize_text
󰹻 Move to Workspace
󰋗 Window Information
󰆼 Toggle Floating
󰊠 Toggle Fullscreen"

# Show menu and get selection
selected=$(echo -e "$options" | eval "$MENU_CMD")

case "$selected" in
    "󰅖 Close Window")
        hyprctl dispatch closewindow address:$window_address
        ;;
    "󰕞 Minimize Window")
        # Hyprland doesn't have traditional minimize, we'll move to special workspace
        hyprctl dispatch movetoworkspacesilent special:minimized,address:$window_address
        notify-send "Window Minimized" "Window moved to special workspace. Use 'togglespecialworkspace minimized' to restore."
        ;;
    "󰕃 Maximize Window")
        hyprctl dispatch fullscreen 1
        ;;
    "󰕇 Restore Window")
        hyprctl dispatch fullscreen 1
        ;;
    "󰹻 Move to Workspace")
        # Get list of workspaces
        workspaces=$(hyprctl workspaces -j | jq -r '.[].name' | sort -n)
        workspace_selected=$(echo -e "$workspaces\nNew Workspace" | eval "$MENU_CMD -p 'Select Workspace'")
        
        if [[ "$workspace_selected" == "New Workspace" ]]; then
            new_workspace=$(echo "" | eval "$MENU_CMD -p 'Enter workspace name/number'")
            if [[ -n "$new_workspace" ]]; then
                hyprctl dispatch movetoworkspace "$new_workspace",address:$window_address
            fi
        elif [[ -n "$workspace_selected" ]]; then
            hyprctl dispatch movetoworkspace "$workspace_selected",address:$window_address
        fi
        ;;
    "󰋗 Window Information")
        info="Window Information:
Class: $window_class
Title: $window_title
Workspace: $window_workspace
Address: $window_address
Fullscreen: $window_fullscreen"
        
        if command -v zenity &> /dev/null; then
            zenity --info --text="$info" --title="Window Information"
        else
            notify-send "Window Information" "$info"
        fi
        ;;
    "󰆼 Toggle Floating")
        hyprctl dispatch togglefloating address:$window_address
        ;;
    "󰊠 Toggle Fullscreen")
        hyprctl dispatch fullscreen 0
        ;;
esac