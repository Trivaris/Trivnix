# Architecture

Trivnix is the reusable module layer. A separate `trivnixconfig` flake selects hosts, users, and enabled features.

## Public flake

`flake.nix` declares upstream inputs and delegates its outputs to `flake/outputs.nix`.

| Export | Source | Purpose |
| --- | --- | --- |
| `nixosModules.default` | `host/` | Host, service, and system modules |
| `nixosModules.dependencies` | `flake/modules.nix` | Upstream NixOS modules required by the host tree |
| `homeModules.default` | `home/` | Home Manager and desktop modules |
| `homeModules.dependencies` | `flake/modules.nix` | Upstream Home Manager modules required by the home tree |
| `overlays.hyprqt6engine` | `flake/overlays.nix` | Hyprland Qt6 engine package overlay |

The module trees are loaded with `import-tree`, so nested module files are part of the exported default module set.

## Composition boundary

The companion configuration flake normally provides:

- host and user configurations
- `trivnixLib` helpers and shared option definitions
- `trivnixPrivate` secrets and private metadata
- `trivnixOverlays` local package overrides

Those inputs are intentionally not part of this repository's public source. See [Private integration](private-integration.md).

## Dependency bundles

Import `nixosModules.dependencies` or `homeModules.dependencies` when a configuration uses modules that rely on the upstream inputs listed in `flake/modules.nix`. The bundles currently include Disko, the mailserver, NUR, sops-nix, Lanzaboote, the Epic Games Launcher module, and the Home Manager sops-nix module.
