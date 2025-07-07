#!/bin/bash
sleep 2

# Set primary workspace
hyprctl dispatch workspace 1

# Focus primary monitor
hyprctl dispatch focusmonitor DP-2

# Optional: Set specific window positions
sleep 1
hyprctl dispatch workspace 2
hyprctl dispatch exec $terminal
hyprctl dispatch workspace 1

# Start polkit agent (only once!)
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Start udiskie for automounting (optional)
/usr/bin/udiskie --no-sys-tray &

