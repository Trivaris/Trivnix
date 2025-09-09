## Trivnix

Flake-based NixOS and Home Manager modules powering my machines. This repo provides common modules, overlays, and utilities that work together with:

- `trivnix-lib` – helper library (functions like `resolveDir`, `mkNixOS`, `mkHomeManager`)
- `trivnix-configs` – per-host and per-user configuration source of truth
- `trivnix-private` – private inputs and secrets glue

This README is an overview. Detailed guides live under `docs/`.

---

## Highlights
- Flake-based setup with `nixpkgs`, `home-manager`, `sops-nix`, `disko`, `hyprland`, `stylix` and more.
- Clean split between reusable modules (this repo) and concrete configs (`trivnix-configs`).
- Optional modules for desktop environments, services, and user programs toggled via prefs.
- Secrets via `sops-nix` with per-host and per-user key separation.

---

## Quick Start
- Read how things fit together: `docs/architecture.md`
- See actual layout: `docs/repo-structure.md`
- Install or rebuild: `docs/getting-started.md`
- Toggle modules and everyday use: `docs/usage.md`
- Add a new host or user: `docs/adding-host.md`
- Formatting rules used here: `docs/formatting.md`
- Secrets reference: `secrets/README.md`

---

## Contributors
- Trivaris – author and maintainer
- Inspired by work from m3tam3re and EmergentMind

---

## License
MIT — see `LICENSE`.
