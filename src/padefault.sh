#!/bin/bash

# toggles default sound output device
default_sink=$(pacmd info | grep "Default sink name:" | cut -d ' ' -f4)

_usage() {
	echo "usage: padefault <command> [args]"
	echo "commands:"
	echo "    toggle          cycles default audio device"
	echo "    mute            toggle mute on default device"
	echo "    mute-all        toggle mute on all outputs"
	echo "    mute-all-src    toggle mute on all inputs"
	echo "    volume [args]   sets default audio device volume"
	exit 0
}

padef_toggle() {
	sinks=($(pactl list sinks | grep Name: | cut -d ' ' -f2 | grep -n ''))
	names=($(pacmd list-sinks | grep alsa.name | cut -d '=' -f2 | tr -d ' "'))
	for sink in "${sinks[@]}"
	do
		name=$(echo "$sink" | cut -d ':' -f2)
		index=$(echo "$sink" | cut -d ':' -f1)
		if [ "$name" == "$default_sink" ]
		then
			if [ "${#sinks[@]}" == "$index" ]
			then
				pactl set-default-sink "$(echo "${sinks[0]}" | cut -d ':' -f2)"
				notify-send 'Default Audio Device' "${names[0]}" -t 1500
			else
				pactl set-default-sink "$(echo "${sinks[$index]}" | cut -d ':' -f2)"
				notify-send 'Default Audio Device' "${names[$index]}" -t 1500
			fi
		fi

	done
	exit 0
}

padef_volume() {
	pactl set-sink-volume "$default_sink" "$1"
	notify-send  "volume" " $1 ($(getvol)%)" -t 500
	exit 0
}

padef_mute() {
	pactl set-sink-mute "$default_sink" toggle
	notify-send "volume" "toggle mute\n$default_sink" -t 500
	exit 0
}

_is_any_muted() {
	target="${1:-"sink"}"
	for mute in $(pactl list "${target}s" | grep Mute | awk '{print $2}'); do
		if [ "$mute" == "yes" ]; then
			return 0
		fi
	done
	return 1

}

pa_mute_all() {
	target="${1:-"sink"}"
	_is_any_muted "$target"
	action="$(($?))"
	for sink in $(pactl list "${target}s" short | awk '{print $1}'); do
		pactl "set-${target}-mute" "$sink" $action
	done
	notify-send "volume" "$target toggle mute" -t 1000
}

case "$1" in 
	toggle|t)          padef_toggle      ;;
	volume|vol|v)      padef_volume "$2" ;;
	mute|m)            padef_mute        ;;
	mute-all|ma)       pa_mute_all       ;;
	mute-all-src|mas)  pa_mute_all source;;
	-h|help|h)         _usage            ;;
	*)                 padef_toggle      ;;
esac

