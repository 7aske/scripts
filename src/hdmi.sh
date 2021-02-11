#!/usr/bin/env sh

MODE=${2:-"same-as"}

PRIMARY="$(xrandr | grep primary | cut -d' ' -f1)"
MONITOR="$(xrandr --current | sed -n -e '/connected [^primary]/p' | cut -d ' ' -f1 | head -1)"

if [ "$1" = "on" ]; then
    xrandr --output "$MONITOR" --mode "1920x1080" "--$MODE" "$PRIMARY"
	xrandr --output "$PRIMARY" --mode "1920x1080" --primary
elif [ "$1" = "off" ]; then
    xrandr --output "$MONITOR" --off
fi
