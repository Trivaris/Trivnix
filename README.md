## Trivnix

> IMPORTANT: This is a WIP and changes are made every day!

Flake-based NixOS and Home Manager modules powering my machines. This repo provides common modules, overlays, and utilities that work together with:

- `trivnixLib` - helper library (functions like `mkNixOS`, `mkHomeManager`)
- `trivnixConfigs` - per-host and per-user configuration
- `trivnixOverlays` - extra packages and overrides
- `trivnixPrivate` - private inputs and secrets

This README is an overview. Detailed guides live under `docs/`.

TODO:
- Waybar Font, Hyprland workspace css, general improvement
- Some icons still missing
- Cover Dark mode everywhere
- Find nicer looking utilities for sound/ bluetooth (overskride) / networking
- ZSH visual improvements