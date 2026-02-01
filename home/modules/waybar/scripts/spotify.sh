#!/bin/sh

class=$(playerctl metadata --player=spotify --format '{{lc(status)}}' 2>/dev/null || echo "")
icon=""
text=""

if [ "$class" = "playing" ]; then
  info=$(playerctl metadata --player=spotify --format '{{title}} by {{artist}} ' 2>/dev/null || echo "")
  if [ ${#info} -gt 40 ]; then
    info="$(printf "%s" "$info" | cut -c1-40)..."
  fi
  text="$icon   $info"
elif [ "$class" = "paused" ]; then
  text="$icon "
elif [ "$class" = "stopped" ] || [ -z "$class" ]; then
  text=""
fi

printf "$text"
