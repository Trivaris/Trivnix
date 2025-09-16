# Architecture

This repo provides reusable NixOS and Home Manager modules and overlays. It works together with two companion repositories and one private input:

- `trivnix` (this repo): common NixOS/Home modules, overlays, shared logic
- `trivnixLib`: helper library (`resolveDir`, `mkNixOS`, `mkHomeManager`, etc.)
- `trivnixConfigs`: per-host and per-user configuration source of truth
- `trivnixPrivate`: private inputs and glue for secrets

## Outputs Flow

`flake/outputs.nix` wires everything together:

- Reads host definitions from `trivnixConfigs.configs`.
- Imports helpers from `flake/nixosConfigurations.nix` and `flake/homeConfigurations.nix` to map each entry.
- For every host, calls `trivnixLib.mkNixOS`.
- For every user on a host, calls `trivnixLib.mkHomeManager`.
- Exposes results under `nixosConfigurations` and `homeConfigurations`.

Paths to check in this repo:
- `flake/outputs.nix`, `flake/modules.nix`, `flake/nixosConfigurations.nix`, `flake/homeConfigurations.nix`
- `overlays/`
- `host/common`, `host/modules`
- `home/common`, `home/modules`
- `shared/`, `secrets/`

In `trivnixConfigs`, each host lives under `configs/<configname>/` and typically includes:
- `infos.nix`: hostname, architecture, stateVersion, network info, etc.
- `prefs.nix`: host-level preferences (desktop environment, services, etc.)
- `users.nix`: users on this host and their preferences
- `hardware.nix`, `partitions.nix`, `pkgsConfig.nix`, `pubKeys/` as needed

## Prefs Model

Modules in this repo use two major option trees:

- `hostPrefs`: host-level options used by NixOS modules
  - Example lists: `host/common/services/default.nix` (`options.hostPrefs.services`)
  - Example single options: `host/common/displayManager`, `host/common/desktopEnvironment/*`

- `userPrefs`: user-level options used by Home Manager modules
  - Example lists: `home/modules/cli/default.nix` (`options.userPrefs.cli.enabled`)
  - Other options under `home/modules/*` (e.g., `gui`, `browsers`, `vscodium`, etc.)

Examples

Host services list:

```nix
hostPrefs.services = [ "bluetooth" "printing" ];
```

Host desktop environment and display manager:

```nix
hostPrefs.displayManager = "gdm";          # see host/common/displayManager
hostPrefs.desktopEnvironment = "kde";      # or "hyprland" (see host/common/desktopEnvironment)
```

User program sets:

```nix
userPrefs.gui = [ "vscodium" "spotify" "bitwarden" ];
userPrefs.cli.enabled = [ "bat" "fzf" "zoxide" "nvim" ];
```

## Overlays and Packages

Overlays are defined in `overlays/` and merged via `flake/overlays.nix` in `flake/outputs.nix`. Custom or patched packages live under `overlays/packages/`.

## Secrets and Theming

- Secrets are managed via `sops-nix`. See `docs/secrets.md` for layout and rules.
- Theming is centralized via Stylix; see `shared/stylix/` and `host/common/stylix.nix`.
