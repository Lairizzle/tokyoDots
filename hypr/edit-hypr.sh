#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/hypr"

# ---- Mapping: Display Name -> File ----
declare -A CONFIG_MAP=(
  ["󰈙 Main (hyprland.lua)"]="hyprland.lua"
  ["󰍹 Monitors"]="monitors.lua"
  ["󰏖 Programs"]="programs.lua"
  ["󰀻 Shortcuts"]="app-visibility.sh"
  ["󰄉 Autostart"]="autostart.lua"
  ["󰒓 Environment"]="env.lua"
  ["󰔎 Look & Feel"]="looknfeel.lua"
  ["󰌿 Input"]="input.lua"
  ["󰌌 Keybinds"]="keybinds.lua"
  ["󰖲 Workspaces"]="workspaces.lua"
)

# ---- Build menu list sorted by label (after icon), icons preserved ----
options=$(
  for key in "${!CONFIG_MAP[@]}"; do
    label="${key#* }"
    printf '%s\t%s\n' "$label" "$key"
  done | sort -f | cut -f2-
)

# ---- Pick menu tool ----
if command -v rofi >/dev/null 2>&1; then
  choice=$(echo -e "$options" | rofi \
    -dmenu \
    -i \
    -p "⚙️ Hypr Config" \
    -font "Jetbrains Mono Nerd Font 10" \
    -sort \
    -disable-history)
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

# ---- Run script or open in editor ----
if [[ "$file" == *.sh ]]; then
    bash "$CONFIG_DIR/$file"
else
    ${TERMINAL:-kitty} nvim "$CONFIG_DIR/$file"
    hyprctl reload
fi

