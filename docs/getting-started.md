# Getting Started

This guide covers installation and day-to-day rebuilds.

Prerequisites

- Access to `trivnixPrivate` and any required SSH keys (see `docs/trivnix-private.md`)
- AGE keys for hosts/users (see `docs/secrets.md`)
- A NixOS ISO with flakes enabled

## Install (Manual)

1) Boot into the NixOS installer and get networking working.

2) Prepare SOPS key on target root:

```bash
sudo mkdir -p /mnt/var/lib/sops-nix
sudo install -m 0400 -o root -g root /path/to/host_<configname>.age /mnt/var/lib/sops-nix/key.txt
```

3) Partition and mount disks via `disko` (optional but recommended):

```bash
sudo nix --experimental-features 'nix-command flakes' \
  run github:nix-community/disko/latest -- \
  --mode destroy,format,mount /path/to/partitions.nix
```

Note: In `trivnixConfigs`, disk layout typically resides at `configs/<configname>/partitions.nix`.

4) Install NixOS using this flake:

```bash
sudo nixos-install --no-root-passwd --flake github:trivaris/trivnix#<configname>
```

If using a local clone, replace the flake URL with `.#<configname>`.

5) Reboot. The system will fetch `trivnixConfigs` and apply the selected modules.

## Rebuilds

- Update inputs: `nix flake update`
- Switch NixOS: `sudo nixos-rebuild switch --flake .#<configname>`
- Switch Home Manager: `home-manager switch --flake .#<user>@<configname>`

See `docs/usage.md` for module toggles and everyday workflows.
