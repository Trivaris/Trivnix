#!/usr/bin/env bash
set -euo pipefail

bluetoothctl_cmd() {
  if command -v bluetoothctl >/dev/null 2>&1; then
    bluetoothctl "$@"
  else
    echo "bluetoothctl not found" >&2
    exit 127
  fi
}

menu_cmd() {
  if command -v rofi >/dev/null 2>&1; then
    rofi -dmenu -i -p "Bluetooth" "$@"
  elif command -v wofi >/dev/null 2>&1; then
    wofi --dmenu -p "Bluetooth"
  else
    if command -v blueman-manager >/dev/null 2>&1; then
      nohup blueman-manager >/dev/null 2>&1 &
    else
      echo "No dmenu-capable launcher (rofi/wofi) found" >&2
    fi
    exit 0
  fi
}

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -a "Bluetooth" "$@" || true
  fi
}

powered_state() {
  bluetoothctl_cmd show | awk -F": " '/Powered:/ {print $2; exit}'
}

is_connected() {
  local mac="$1"
  bluetoothctl_cmd info "$mac" | awk -F": " '/Connected:/ {print $2; exit}'
}

list_paired_devices() {
  local out
  out="$(bluetoothctl_cmd devices Paired 2>/dev/null || true)"
  if [[ -z "$out" ]]; then
    out="$(bluetoothctl_cmd paired-devices 2>/dev/null || true)"
  fi
  printf "%s\n" "$out" \
    | awk 'BEGIN{OFS="\t"} /^Device /{mac=$2; name=""; for(i=3;i<=NF;i++){name=name $i (i<NF?" ":"")}; print mac, name}'
}

build_menu() {
  local power
  power="$(powered_state || true)"

  if [[ "$power" == "no" || -z "$power" ]]; then
    echo "Power On"
    return
  fi

  echo "Power Off"

  while IFS=$'\t' read -r mac name; do
    [[ -z "$mac" ]] && continue
    local conn icon label
    conn="$(is_connected "$mac" || true)"
    if [[ "$conn" == "yes" ]]; then
      icon="󰂱"
      label="$name (connected)"
    else
      icon="󰂯"
      label="$name"
    fi
    printf "%s\t%s %s\n" "$mac" "$icon" "$label"
  done < <(list_paired_devices)
}

main() {
  local selection
  selection="$(build_menu | menu_cmd)" || exit 0

  if [[ "$selection" == "Power On" ]]; then
    bluetoothctl_cmd power on && notify "Powered on"
    exit 0
  elif [[ "$selection" == "Power Off" ]]; then
    bluetoothctl_cmd power off && notify "Powered off"
    exit 0
  fi

  local mac label connected
  mac="${selection%%$'\t'*}"
  if [[ "$mac" == "$selection" || -z "$mac" ]]; then
    exit 0
  fi

  connected="$(is_connected "$mac" || true)"
  if [[ "$connected" == "yes" ]]; then
    if bluetoothctl_cmd disconnect "$mac"; then
      notify "Disconnected ${selection#*$'\t'}"
    else
      notify "Failed to disconnect ${selection#*$'\t'}"
      exit 1
    fi
  else
    if bluetoothctl_cmd connect "$mac"; then
      notify "Connected ${selection#*$'\t'}"
    else
      notify "Failed to connect ${selection#*$'\t'}"
      exit 1
    fi
  fi
}

main "$@"
