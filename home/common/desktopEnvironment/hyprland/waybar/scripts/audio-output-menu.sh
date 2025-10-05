#!/usr/bin/env bash
set -euo pipefail

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -a "PipeWire" "$@" || true
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
  local pwvu_bin

  if ! pwvu_bin="$(find_binary pwvucontrol)"; then
    notify "pwvucontrol not found" "Install pwvucontrol to manage audio outputs."
    exit 127
  fi

  nohup "$pwvu_bin" >/dev/null 2>&1 &
}

main "$@"
