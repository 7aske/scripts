#!/usr/bin/env bash

# toggles sound output device for the focused window

indices=($(pacmd list-sink-inputs | awk '$1 == "index:" {print $2}'))
ids=($(pacmd list-sink-inputs | awk '$1 ~ /application.process.id/ {print $3}' | cut -d '"' -f2))
idsinks=($(pacmd list-sink-inputs | awk '$1 ~ /sink:/ {print $3}' | tr -d "<>"))

sinks=($(pactl list sinks | grep Name: | cut -d ' ' -f2 | grep -n ''))
names=($(pacmd list-sinks | grep alsa.name | cut -d '=' -f2 | tr -d ' "'))

wname="$(xdotool getwindowfocus getwindowname)"
echo $wname
case "$wname" in
    "Cantata") pid="$(pgrep mpd)" ;;
    *"Chromium") pid="$(pgrep chromium)" ;;
    *"Brave") pid="$(pgrep brave)" ;;
    *) pid=$(xdotool getwindowfocus getwindowpid);;
esac

for i in "${!indices[@]}"; do
    if [[ "$pid" =~ "${ids[i]}" ]]; then
        for sink in "${sinks[@]}"; do
            name=$(echo "$sink" | cut -d ':' -f2)
            index=$(echo "$sink" | cut -d ':' -f1)

            if [ "$name" == "${idsinks[$i]}" ]; then
                if [ "${#sinks[@]}" == "$index" ]; then
                    notify-send -a padefault "Switched Audio Output" "$wname -> ${names[0]}" -t 2000
                    pacmd move-sink-input "${indices[$i]}" "$(echo "${sinks[0]}" | cut -d ':' -f2)"
                else
                    notify-send -a padefault "Switched Audio Output" "$wname -> ${names[$index]}" -t 2000
                    pacmd move-sink-input "${indices[$i]}" "$(echo "${sinks[$index]}" | cut -d ':' -f2)"
                fi
            fi
        done
    fi
done
