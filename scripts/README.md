# Window Menu Script

This script provides a dropdown menu for the Waybar hyprland/window module with window management options.

## Features

- **Close Window**: Closes the active window
- **Minimize Window**: Moves window to special workspace (Hyprland's equivalent of minimizing)
- **Maximize/Restore Window**: Toggles fullscreen state
- **Move to Workspace**: Move window to a different workspace
- **Window Information**: Display detailed window information
- **Toggle Floating**: Toggle floating state of the window
- **Toggle Fullscreen**: Toggle fullscreen mode

## Dependencies

- `hyprctl` (part of Hyprland)
- `rofi` or `wofi` (for dropdown menu)
- `jq` (for JSON parsing)
- `notify-send` (for notifications)
- `zenity` (optional, for window information dialog)

## Installation

1. Place the script in `~/.config/waybar/scripts/window_menu.sh`
2. Make it executable: `chmod +x ~/.config/waybar/scripts/window_menu.sh`
3. Add the on-click action to your waybar config:
   ```json
   "hyprland/window": {
     "format": "{class} - {title}",
     "on-click": "~/.config/waybar/scripts/window_menu.sh"
   }
   ```

## Usage

Click on the window title in the Waybar to open the dropdown menu with window management options.

## Notes

- The "Minimize" function moves windows to a special workspace called "minimized"
- Use `hyprctl dispatch togglespecialworkspace minimized` to restore minimized windows
- The script gracefully handles missing dependencies and provides error notifications