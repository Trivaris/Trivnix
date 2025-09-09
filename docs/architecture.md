# Architecture

This repo provides reusable NixOS and Home Manager modules and overlays. It works together with two companion repositories and one private input:

- `trivnix` (this repo): common NixOS/Home modules, overlays, shared logic
- `trivnix-lib`: helper library (`resolveDir`, `mkNixOS`, `mkHomeManager`, etc.)
- `trivnix-configs`: per-host and per-user configuration source of truth
- `trivnix-private`: private inputs and glue for secrets

## Outputs Flow

`outputs.nix` wires everything together:

- Reads host definitions from `trivnix-configs.configs`.
- For each host, builds a NixOS config using `trivnix-lib.mkNixOS`.
- For each user on a host, builds a Home Manager config using `trivnix-lib.mkHomeManager`.
- Exposes results under `nixosConfigurations` and `homeConfigurations`.

Paths to check in this repo:
- `outputs.nix`
- `overlays/`
- `host/common`, `host/modules`
- `home/common`, `home/modules`
- `shared/`, `secrets/`, `resources/`

In `trivnix-configs`, each host lives under `configs/<configname>/` and typically includes:
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
  - Example lists: `home/modules/cli/default.nix` (`options.userPrefs.cli`)
  - Other options under `home/modules/*` (e.g., `gui`, `browsers`, `vscodium`, etc.)

Examples

Host services list:

```nix
hostPrefs.services = [ "bluetooth" "printing" ];
```

Host desktop environment and display manager:

```nix
hostPrefs.displayManager = "gdm";          # see host/common/displayManager
hostPrefs.desktopEnvironment.name = "kde";  # or "hyprland" (see host/common/desktopEnvironment)
```

User program sets:

```nix
userPrefs.gui = [ "vscodium" "spotify" "bitwarden" ];
userPrefs.cli = [ "bat" "fzf" "zoxide" "nvim" ];
```

## Overlays and Packages

Overlays are defined in `overlays/` and merged in `outputs.nix`. Custom or patched packages live under `overlays/packages/`.

## Secrets and Theming

- Secrets are managed via `sops-nix`. See `secrets/README.md` for layout and rules.
- Theming is centralized via Stylix; see `shared/stylix/` and `host/common/stylix.nix`.

