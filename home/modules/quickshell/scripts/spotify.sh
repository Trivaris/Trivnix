#!/bin/sh

class=$(playerctl metadata -i firefox --format '{{lc(status)}}' 2>/dev/null || echo "")
iconplaying=""
iconpaused=""
text=""

info=$(playerctl metadata --format '{{title}} by {{artist}} ' 2>/dev/null || echo "")
if [ "$class" = "playing" ]; then
  if [ ${#info} -gt 40 ]; then
    info="$(printf "%s" "$info" | cut -c1-40)..."
  fi
  text="$iconplaying  $info"
elif [ "$class" = "paused" ]; then
  text="$iconpaused  $info"
elif [ "$class" = "stopped" ] || [ -z "$class" ]; then
  text="  Nothing Playing"
fi

printf "$text"
