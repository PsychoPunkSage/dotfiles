#!/bin/bash
# Listens on Hyprland's event socket and re-applies the current wallpaper
# to any monitor that gets connected after startup (hotplug), so a newly
# plugged-in display never sits on a blank/black background.

wallpaper_current="$HOME/.config/hypr/wallpaper_effects/.wallpaper_current"

get_current_wallpaper() {
    local img
    # Prefer whatever swww is actually showing on any live monitor
    img=$(swww query 2>/dev/null | grep -oP '(?<=image: ).*' | head -n1)
    if [[ -n "$img" && -f "$img" ]]; then
        echo "$img"
        return
    fi
    # Fallback to the last-known wallpaper cached by WallustSwww.sh
    if [[ -f "$wallpaper_current" ]]; then
        echo "$wallpaper_current"
    fi
}

apply_to_monitor() {
    local mon="$1"
    local wallpaper
    wallpaper=$(get_current_wallpaper)

    if [[ -z "$wallpaper" ]]; then
        echo "No known wallpaper to apply to $mon"
        return
    fi

    if ! pgrep -x swww-daemon >/dev/null; then
        swww-daemon --format xrgb &
        sleep 1
    fi

    # Wait until swww's daemon actually knows about the new output
    for _ in $(seq 1 10); do
        if swww query 2>/dev/null | grep -q "^${mon}:"; then
            break
        fi
        sleep 0.5
    done

    swww img -o "$mon" "$wallpaper" \
        --transition-fps 30 --transition-type any --transition-duration 1 \
        --transition-bezier ".43,1.19,1,.4"
}

SOCK="${XDG_RUNTIME_DIR}/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

if [[ -z "$HYPRLAND_INSTANCE_SIGNATURE" || ! -S "$SOCK" ]]; then
    echo "Hyprland event socket not found, exiting."
    exit 1
fi

nc -U "$SOCK" | while IFS= read -r line; do
    event="${line%%>>*}"
    data="${line#*>>}"

    case "$event" in
        monitoraddedv2)
            mon=$(echo "$data" | cut -d',' -f2)
            [[ -n "$mon" ]] && apply_to_monitor "$mon" &
            ;;
        monitoradded)
            mon="$data"
            [[ -n "$mon" ]] && apply_to_monitor "$mon" &
            ;;
    esac
done
