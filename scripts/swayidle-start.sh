#!/usr/bin/env bash

# Define the swayidle process name
SWAY_IDLE_PID_FILE="/tmp/swayidle.pid"

start_swayidle() {
    # Start swayidle if it's not running
    if ! pgrep -x "swayidle" > /dev/null; then
        swayidle -w \
            timeout 300 'swaylock -f -c 000000' \
            timeout 600 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
            before-sleep 'swaylock -f -c 000000' &
        echo $! > "$SWAY_IDLE_PID_FILE"
        echo "Swayidle started."
        # Notify user that swayidle has started
        notify-send "Swayidle" "Swayidle has been started."
    else
        echo "Swayidle is already running."
        # Notify user that swayidle is already running
        notify-send "Swayidle" "Swayidle is already running."
    fi
}

stop_swayidle() {
    # Stop swayidle if it's running
    if pgrep -x "swayidle" > /dev/null; then
        kill "$(cat "$SWAY_IDLE_PID_FILE")"
        rm "$SWAY_IDLE_PID_FILE"
        echo "Swayidle stopped."
        # Notify user that swayidle has been stopped
        notify-send "Swayidle" "Swayidle has been stopped."
    else
        echo "Swayidle is not running."
        # Notify user that swayidle isn't running
        notify-send "Swayidle" "Swayidle is not running."
    fi
}

toggle_swayidle() {
    if [ -f "$SWAY_IDLE_PID_FILE" ]; then
        stop_swayidle
    else
        start_swayidle
    fi
}

# Call the toggle function
toggle_swayidle
