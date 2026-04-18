#!/usr/bin/env bash
SYSTEM_APP_DIR="/usr/share/applications"
USER_APP_DIR="$HOME/.local/share/applications"
mkdir -p "$USER_APP_DIR"

# ---- Pick menu tool ----
if command -v rofi >/dev/null 2>&1; then
    MENU_TOOL="rofi"
elif command -v wofi >/dev/null 2>&1; then
    MENU_TOOL="wofi"
else
    echo "No rofi/wofi found."
    exit 1
fi

run_menu() {
    local prompt="$1"
    local mesg="$2"
    local custom_key="$3"
    local input="$4"

    if [[ "$MENU_TOOL" == "rofi" ]]; then
        echo -e "$input" | rofi \
            -dmenu \
            -i \
            -p "$prompt" \
            -font "JetBrains Mono Nerd Font 10" \
            -sort \
            -disable-history \
            -mesg "$mesg" \
            -kb-custom-1 "$custom_key"
    else
        echo -e "$input" | wofi --dmenu -i -p "$prompt"
    fi
}

show_hidden=false

while true; do
    declare -A seen
    declare -a entries
    declare -a display_lines

    while IFS= read -r -d '' file; do
        base=$(basename "$file")
        name=$(grep -m1 "^Name=" "$file" 2>/dev/null | cut -d= -f2-)

        [[ -z "$name" ]] && continue
        [[ -n "${seen[$name]}" ]] && continue

        seen["$name"]=1

        user_file="$USER_APP_DIR/$base"
        is_hidden=false
        if [[ -f "$user_file" ]]; then
            local_nodisplay=$(grep -m1 "^NoDisplay=" "$user_file" 2>/dev/null | cut -d= -f2-)
            [[ "$local_nodisplay" == "true" ]] && is_hidden=true
        else
            nodisplay=$(grep -m1 "^NoDisplay=" "$file" 2>/dev/null | cut -d= -f2-)
            [[ "$nodisplay" == "true" ]] && is_hidden=true
        fi

        if $is_hidden && ! $show_hidden; then
            unset "seen[$name]"
            continue
        fi

        indicator=$($is_hidden && echo "○  " || echo "●  ")

        display_line="${indicator}${name}"
        entries+=("$display_line|$file|$is_hidden")
        display_lines+=("$display_line")
    done < <(find "$USER_APP_DIR" "$SYSTEM_APP_DIR" -maxdepth 1 -name "*.desktop" -print0 2>/dev/null)

    IFS=$'\n' sorted_lines=($(printf '%s\n' "${display_lines[@]}" | sort)); unset IFS

    if $show_hidden; then
        mesg="●  = visible  |  ○  = hidden  |  Alt+F1 = hide hidden  |  Esc = quit"
    else
        mesg="●  = visible  |  Alt+F1 = show hidden  |  Esc = quit"
    fi

    chosen=$(run_menu "󰀻 App Visibility" "$mesg" "Alt+F1" "$(printf '%s\n' "${sorted_lines[@]}")")

    rofi_exit=$?

    if [[ $rofi_exit -eq 10 ]]; then
        $show_hidden && show_hidden=false || show_hidden=true
        unset seen entries display_lines
        continue
    fi

    [[ -z "$chosen" ]] && exit 0

    chosen_file=""
    is_hidden=false
    for entry in "${entries[@]}"; do
        display="${entry%%|*}"
        rest="${entry#*|}"
        path="${rest%%|*}"
        hidden="${rest##*|}"
        if [[ "$display" == "$chosen" ]]; then
            chosen_file="$path"
            is_hidden="$hidden"
            break
        fi
    done

    [[ -z "$chosen_file" ]] && unset seen entries display_lines && continue

    base=$(basename "$chosen_file")
    target="$USER_APP_DIR/$base"
    is_system=false
    [[ "$chosen_file" == "$SYSTEM_APP_DIR"* ]] && is_system=true

    # Strip indicator prefix to get clean app name for notifications
    app_name="${chosen#*  }"

    if [[ "$is_hidden" == "true" ]]; then
        if [[ -f "$target" ]]; then
            sed -i 's/^NoDisplay=.*/NoDisplay=false/' "$target"
            $is_system && rm "$target"
        fi
        notify-send "App Visibility" "$app_name is now visible." 2>/dev/null
    else
        [[ "$chosen_file" != "$target" ]] && cp "$chosen_file" "$target"
        if grep -q "^NoDisplay=" "$target"; then
            sed -i 's/^NoDisplay=.*/NoDisplay=true/' "$target"
        else
            sed -i '/^\[Desktop Entry\]/a NoDisplay=true' "$target"
        fi
        notify-send "App Visibility" "$app_name is now hidden." 2>/dev/null
    fi

    unset seen entries display_lines

done
