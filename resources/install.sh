#!/usr/bin/env bash

set -euo pipefail

configname="default"

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in 
  --configname)
      configname="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Resolve path relative to script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# Prefer local file in same dir, fallback to ../hosts/common/hardware/
if [[ -f "$SCRIPT_DIR/${configname}.nix" ]]; then
  CONFIG_PATH="$SCRIPT_DIR/${configname}.nix"
else
  CONFIG_PATH="$SCRIPT_DIR/../hosts/common/hardware/${configname}.nix"
fi

# Run disko
sudo nix \
  --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- --mode disko \
  "$CONFIG_PATH"

# If keys.txt exists, copy to /var/lib/sops-nix/
KEY_FILE="$SCRIPT_DIR/keys.txt"
sudo mkdir -p /var/lib/sops-nix/
sudo install -m 600 -o root -g root "$KEY_FILE" /var/lib/sops-nix/keys.txt
echo "✅ Copied keys.txt to /var/lib/sops-nix/keys.txt"

# Auto-fetch latest commit from GitHub
latest_commit=$(nix flake metadata github:Trivaris/trivnix | jq -r .locked.rev)

# Final install
sudo nixos-install --flake github:Trivaris/trivnix/$latest_commit#$configname