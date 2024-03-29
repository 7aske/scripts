#!/usr/bin/env sh

color="$(colorpicker --short --one-shot --preview)"
if [ -n "$color" ]; then
	echo -n "$color" | xclip -sel c
	notify-send --hint=int:transient:1 -t 5000  "xpick" "'$color' copied to clipboard"
fi
