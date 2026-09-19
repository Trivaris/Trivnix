pkgs:
''
    #!/bin/sh
    PATH="${pkgs.curl}/bin:${pkgs.coreutils}/bin:$PATH"

    # Queries wttr.in for compact weather info formatted as: "weatherCode:temp"
    # Example output: "113:+18°C"
    raw=$(curl -sf "https://wttr.in/Darmstadt?m&format=%c:%t" 2>/dev/null)

    # Fallback to standard cloud if the network request fails or returns empty
    if [ -z "$raw" ]; then
        printf '{"icon": "", "temp": "--°"}\n'
        exit 0
    fi

    # Split into condition character and temperature
    cond=$(printf "%s" "$raw" | cut -d':' -f1 | tr -d ' ')
    temp=$(printf "%s" "$raw" | cut -d':' -f2 | tr -d '+ ')

    # Map condition emojis / wttr characters to Nerd Font glyphs
    case "$cond" in
        "☀️"|"🌣"|"🌤")
            icon="󰖙" # Clear / Sunny
            ;;
        "⛅"|"🌥")
            icon="󰖕" # Partly cloudy
            ;;
        "☁️"|"☁")
            icon="󰖐" # Overcast / Cloudy
            ;;
        "🌧"|"🌦")
            icon="󰖖" # Rain / Showers
            ;;
        "⛈"|"🌩")
            icon="󰙾" # Thunderstorm
            ;;
        "🌨"|"❄️"|"❄")
            icon="󰼶" # Snow
            ;;
        "🌫")
            icon="󰖑" # Fog / Mist
            ;;
        *)
            icon="" # Generic fallback cloud
            ;;
    esac

    printf '{"icon": "%s", "temp": "%s"}\n' "$icon" "$temp"
''