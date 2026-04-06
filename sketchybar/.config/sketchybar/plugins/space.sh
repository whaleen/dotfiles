#!/bin/bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map_fn.sh"

# Get apps open in this space via yabai
apps=$(yabai -m query --windows --space "$SID" 2>/dev/null \
  | jq -r '.[].app' 2>/dev/null | sort -u)

icon_strip=" "
if [ -n "$apps" ]; then
  while IFS= read -r app; do
    icon_map "$app"
    icon_strip+="$icon_result "
  done <<< "$apps"
fi

# Highlight focused space
if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" \
    background.color="$ACCENT_COLOR_40" \
    background.border_width=1 \
    background.border_color="$ACCENT_COLOR" \
    label="$icon_strip"
else
  sketchybar --set "$NAME" \
    background.color=0x22ffffff \
    background.border_width=0 \
    label="$icon_strip"
fi
