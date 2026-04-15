#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/hypr"

# ---- Mapping: Display Name -> File ----
declare -A CONFIG_MAP=(
  ["Main (hyprland.conf)"]="hyprland.conf"
  ["Monitors"]="monitors.conf"
  ["Programs"]="programs.conf"
  ["Autostart"]="autostart.conf"
  ["Environment"]="env.conf"
  ["Look & Feel"]="looknfeel.conf"
  ["Input"]="input.conf"
  ["Keybinds"]="keybinds.conf"
  ["Workspaces"]="workspaces.conf"
)

# ---- Build menu list ----
options=""
for key in "${!CONFIG_MAP[@]}"; do
  options+="$key\n"
done

# ---- Pick menu tool ----
if command -v rofi >/dev/null 2>&1; then
  choice=$(echo -e "$options" | rofi -dmenu -i -p "Hypr Config")
elif command -v wofi >/dev/null 2>&1; then
  choice=$(echo -e "$options" | wofi --dmenu -i -p "Hypr Config")
else
  echo "No rofi/wofi found."
  exit 1
fi

# ---- Exit if nothing selected ----
[ -z "$choice" ] && exit 0

file="${CONFIG_MAP[$choice]}"

# ---- Safety check ----
[ -z "$file" ] && exit 1

# ---- Open in terminal with nvim ----
kitty nvim "$CONFIG_DIR/$file"

# ---- Reload Hyprland after edit ----
hyprctl reload
