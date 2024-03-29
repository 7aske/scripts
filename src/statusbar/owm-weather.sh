#!/bin/bash

BASE_URL="http://api.openweathermap.org/data/2.5/weather"
URL="${BASE_URL}?id=${OPENWEATHERMAP_CITY_ID}&appid=${OPENWEATHERMAP_API_KEY}&units=metric"

declare -A ICONS

ICONS["01d"]="☀️"
ICONS["01n"]="🌙"
ICONS["02d"]="🌤"
ICONS["02n"]="🌤"
ICONS["03d"]="☁️"
ICONS["03n"]="☁️"
ICONS["04d"]="☁️"
ICONS["04n"]="☁️"
ICONS["09d"]="🌧"
ICONS["09n"]="🌧"
ICONS["10d"]="🌦"
ICONS["10n"]="🌦"
ICONS["11d"]="🌩"
ICONS["11n"]="🌩"
ICONS["13d"]="❄️"
ICONS["13n"]="❄️"
ICONS["50d"]="🌫"
ICONS["50n"]="🌫"
ICONS["unknown"]="❓"


response=$(curl -s $URL)

if [ $? -eq 0 ]; then
    temperature=$(echo $response | jq -r '.main.temp')
    icon=$(echo $response | jq -r '.weather[0].icon')
    description=$(echo $response | jq -r '.weather[0].description')

	printf "<span rise='-4pt'>%.1f°C</span> <span size='medium' rise='-4pt'>%s</span>\n" $temperature ${ICONS["$icon"]}
else
    echo ${ICONS["unknown"]}
fi

