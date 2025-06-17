#!/usr/bin/env bash
set -euo pipefail

disko_cfg="default"
nixos_cfg=""
reboot=false

# ---------- arg-parsing ----------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --disko-cfg)  disko_cfg="$2";  shift 2 ;;
    --nixos-cfg)  nixos_cfg="$2"; shift 2 ;;
    --reboot)     reboot_flag=true; shift ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done
[[ -z $nixos_cfg ]] && { echo "✖ Error: --nixos-cfg is required"; exit 1; }

echo "✔ disko:  $disko_cfg"
echo "✔ nixos:  $nixos_cfg"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

# ---------- pick disko file ----------
if [[ -f "$SCRIPT_DIR/../hosts/common/core/hardware/${disko_cfg}.nix" ]]; then
  DISKO_PATH="$SCRIPT_DIR/../hosts/common/core/hardware/${disko_cfg}.nix"
else
  echo "✖ Error: Disko Config File is required"; exit 1;
fi
echo "✔ Found disko file: $DISKO_PATH"

# ---------- seed AGE key ----------
KEY_DST="/mnt/var/lib/sops-nix/key.txt"
if [[ -f "/run/media/nixos/Ventoy/keys/host_$nixos_cfg.age" ]]; then
  KEY_SRC="/run/media/nixos/Ventoy/keys/host_$nixos_cfg.age"
elif [[ -f "$SCRIPT_DIR/key.txt" ]]; then
  KEY_SRC="$SCRIPT_DIR/key.txt"
else
  echo "✖ Error: key.txt missing"; exit 1;
fi
echo "✔ Found key file: $KEY_SRC"

sudo install -m 0400 -o root -g root -D "$KEY_SRC" "$KEY_DST"
echo "✔ Copied key.txt to $KEY_DST"

# ---------- nixos-install ----------
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount "$DISKO_PATH"
sudo nixos-install --no-root-passwd --flake "$SCRIPT_DIR/..#$nixos_cfg"

# ---------- post-success cleanup & reboot ----------
echo "✔ Install succeeded - shredding bootstrap key and rebooting..."
sudo shred -u "$KEY_DST" 2>/dev/null || sudo rm -f "$KEY_DST"
sync

# ---------- Reboot-Question ----------
if $reboot_flag; then
  echo "✔ Rebooting now..."
  sudo reboot
else
  read -rp "Reboot now? [y/N]: " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "✔ Rebooting..."
    sudo reboot
  else
    echo "✖ Skipped reboot"
  fi
fi
