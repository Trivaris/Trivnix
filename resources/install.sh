#!/usr/bin/env bash

set -euo pipefail

disko="default"
nixos=""

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --disko)
      disko="$2"
      shift 2
      ;;
    --nixos)
      nixos="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Check required args
if [[ -z "$nixos" ]]; then
  echo "Error: --nixos is required"
  exit 1
fi

# Debug/logging output
echo "Using disko config: $disko"
echo "Using nixos config: $nixos"

# Resolve path relative to script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

use_local_config=false

# Prefer local file in same dir, fallback to ../hosts/common/hardware/
if [[ -f "$SCRIPT_DIR/${disko}.nix" ]]; then
  CONFIG_PATH="$SCRIPT_DIR/${disko}.nix"
  use_local_config=true
else
  CONFIG_PATH="$SCRIPT_DIR/../hosts/common/core/hardware/${disko}.nix"
fi

echo Found disko config

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

# Final install
if [[ "$use_local_config" == true ]]; then
  sudo nixos-install --flake github:Trivaris/trivnix#$nixos
else
  sudo nixos-install --flake ..#$nixos
fi
