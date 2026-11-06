# Architecture

Trivnix is a reusable NixOS module layer. The repository also defines desktop,
laptop, and server configurations that compose those modules with private input
data.

## Public flake

`flake.nix` declares upstream inputs and imports the repository's Nix files
through `import-tree`. The imported files define the flake outputs.

| Export | Source | Purpose |
| --- | --- | --- |
| `nixosModules.default` | `modules/nixos/default.nix` | Aggregate NixOS module set |
| `nixosModules.*` | `modules/nixos/` and `hosts/` | Individual module groups and host modules |
| `nixosConfigurations.*` | `hosts/` | `desktop`, `laptop`, and `server` systems |
| `diskoConfigurations.*` | `disko/` | Disko configurations for the three hosts |
| `lib` | `lib/` | Shared Nix helpers |
| `overlays.default` | `overlays/` | The repository's package overlay |

The `modules/home` tree is wired into the repository's host configurations. It
is not currently exposed as a `homeModules` flake output.

## Composition boundary

The host configurations use the companion private input:

- `trivnixPrivate` provides SOPS data, accounts, keys, and other private values.

The public repository defines the host configurations and passes its own `lib`
to them as `trivnixLib`. See [Private integration](private-integration.md).

## External modules

`nixosModules.external-modules` imports the external NixOS modules used by the
host configurations, including Home Manager, SOPS, Lanzaboote, Disko, NUR, the
Epic Games Launcher, and Spicetify. 
