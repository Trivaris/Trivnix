#!/usr/bin/env bash
set -euo pipefail

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -a "Network" "$@" || true
  fi
}

find_binary() {
  local bin="$1"
  local path

  if path="$(command -v "$bin" 2>/dev/null)"; then
    printf '%s\n' "$path"
    return 0
  fi

  local -a candidates=(
    "/run/current-system/sw/bin/$bin"
    "$HOME/.nix-profile/bin/$bin"
    "/etc/profiles/per-user/$USER/bin/$bin"
    "$HOME/.local/state/nix/profiles/home-manager/default/bin/$bin"
  )

  for path in "${candidates[@]}"; do
    if [[ -x "$path" ]]; then
      printf '%s\n' "$path"
      return 0
    fi
  done

  return 1
}

main() {
  local nm_bin

  if nm_bin="$(find_binary nm-connection-manager)"; then
    :
  elif nm_bin="$(find_binary nm-connection-editor)"; then
    :
  else
    notify "NetworkManager tools not found" "Install networkmanagerapplet for the connection editor."
    exit 127
  fi

  nohup "$nm_bin" >/dev/null 2>&1 &
}

main "$@"
