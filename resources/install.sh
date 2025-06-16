#!/usr/bin/env bash
set -euo pipefail

disko_cfg="default"
nixos_cfg=""

# ---------- arg-parsing ----------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --disko-cfg)  disko_cfg="$2";  shift 2 ;;
    --nixos-cfg)  nixos_cfg="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done
[[ -z $nixos_cfg ]] && { echo "Error: --nixos-cfg is required"; exit 1; }

echo "disko:  $disko_cfg"
echo "nixos:  $nixos_cfg"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
use_local=false

# ---------- pick disko file ----------
if [[ -f "$SCRIPT_DIR/${disko_cfg}.nix" ]]; then
  DISKO_PATH="$SCRIPT_DIR/${disko_cfg}.nix"
  use_local=true
else
  DISKO_PATH="$SCRIPT_DIR/../hosts/common/core/hardware/${disko_cfg}.nix"
fi
echo "✔ Found disko file: $DISKO_PATH"

# ---------- run disko ----------
sudo nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko/latest -- \
  --mode disko "$DISKO_PATH"

# ---------- seed master AGE key ----------
KEY_SRC="$SCRIPT_DIR/master.age"
KEY_DST="/mnt/var/lib/sops-nix/master.age"
if [[ -f "$KEY_SRC" ]]; then
  sudo install -m 0400 -o root -g root -D "$KEY_SRC" "$KEY_DST"
  echo "🔑 master.age copied to $KEY_DST"
else
  echo "⚠️  master.age missing – secrets must decrypt via generateKey=true"
fi

# ---------- nixos-install ----------
if "$use_local"; then
  sudo nixos-install --flake github:Trivaris/trivnix#"$nixos_cfg"
else
  sudo nixos-install --flake ..#"$nixos_cfg"
fi

# ---------- post-success cleanup & reboot ----------
echo "🎉 Install succeeded – shredding bootstrap key and rebooting..."
sudo shred -u "$KEY_DST" 2>/dev/null || sudo rm -f "$KEY_DST"
sync
sleep 1
sudo reboot
