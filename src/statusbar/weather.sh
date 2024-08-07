#!/usr/bin/env sh

show_weather() {
	#i3-msg "workspace weather"
	curl -s http://wttr.in > /tmp/weather 2>&1
	i3-msg "exec --no-startup-id setsid -f st -c weather_floating -e less -Srf /tmp/weather" 2>/dev/null 1>/dev/null
}

case $BLOCK_BUTTON in
	1) notify-send -i none "Weather" "$(curl wttr.in/ | perl -pe 's/\e\[[0-9;]*m(?:\e\[K)?//g' | head -7)" ;;
	3) show_weather ;;
esac

echo "$(curl wttr.in/?format=%T%c%t | cut -c 14- | iconv -c)"
